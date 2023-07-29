// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// 定义一个接口,传递合约的地址，这个合约肯定是有这几个方法，随时帮我们进行调用
// 其实我感觉就是为了在本合约中调用其他合约的方法
interface IExchange {
    function ethToTokenSwap(uint256 _minTokens) external payable;

    function ethToTokenTransfer(
        uint256 _minTokens,
        address _recipient
    ) external payable;
}

interface IFactory {
    function getExchange(address _tokenAddress) external returns (address);
}

contract Exchange is ERC20 {
    address public tokenAddress; // 代币地址
    address public factoryAddress; // <--- new line

    // 代币的地址是一个状态变量
    // 发行该代币的合约地址
    constructor(address _token) ERC20("Zuniswap-V1", "ZUNI-V1") {
        // 我们自己的币
        require(_token != address(0), "invalid token address");
        tokenAddress = _token;
        factoryAddress = msg.sender; // <--- new line
    }

    // 增加合约的流动性
    // 其实这个函数应该是将一定数量的代币存入到合约中去
    function addLiquidity(
        uint256 _tokenAmount
    ) public payable returns (uint256) {
        if (getReserve() == 0) {
            // 当该合约并未有收到该代币的时候
            // 第一次的时候直接转入即可
            IERC20 token = IERC20(tokenAddress);
            token.transferFrom(msg.sender, address(this), _tokenAmount);
            // 获取该合约中的以太币储备金
            uint256 liquidity = address(this).balance;
            // 给调用合约的用户铸造流动性代币 = 合约中的以太币储备金
            _mint(msg.sender, liquidity);
            return liquidity;
        } else {
            // 合约中的以太币的储备金（除去当前交易的金额）
            uint256 ethReserve = address(this).balance - msg.value;
            // 代币的储备金
            uint256 tokenReserve = getReserve();
            uint256 tokenAmount = (msg.value * tokenReserve) / ethReserve;
            require(_tokenAmount >= tokenAmount, "insufficient token amount");

            IERC20 token = IERC20(tokenAddress);
            // 调用者会将一定比例的代币转给该合约,这里应该不会将所有的代币都返回
            token.transferFrom(msg.sender, address(this), tokenAmount);

            uint256 liquidity = (msg.value * totalSupply()) / ethReserve;
            _mint(msg.sender, liquidity);
            return liquidity;
        }
    }

    function removeLiquidity(
        uint256 _amount
    ) public returns (uint256, uint256) {
        require(_amount > 0, "invalid amount");

        uint256 ethAmount = (address(this).balance * _amount) / totalSupply();
        uint256 tokenAmount = (getReserve() * _amount) / totalSupply();

        _burn(msg.sender, _amount);
        payable(msg.sender).transfer(ethAmount);
        IERC20(tokenAddress).transfer(msg.sender, tokenAmount);

        return (ethAmount, tokenAmount);
    }

    // 返回交易所代币余额的辅助函数
    // 返回当前合约所拥有的代币储备金
    function getReserve() public view returns (uint256) {
        return IERC20(tokenAddress).balanceOf(address(this));
    }

    // 获取以太币 => 代币价格
    function getTokenAmount(uint256 _ethSold) public view returns (uint256) {
        require(_ethSold > 0, "ethSold is too small");
        uint256 tokenReserve = getReserve();
        return getAmount(_ethSold, address(this).balance, tokenReserve);
    }

    // 获取代币 => 以太币的价格
    function getEthAmount(uint256 _tokenSold) public view returns (uint256) {
        require(_tokenSold > 0, "tokenSold is too small");

        uint256 tokenReserve = getReserve();

        return getAmount(_tokenSold, tokenReserve, address(this).balance);
    }

    // 计算输出金额
    // inputAmount输入金额
    // inputReserve 输入的储备金
    // outputReserve 输出的储备金
    function getAmount(
        uint256 inputAmount,
        uint256 inputReserve,
        uint256 outputReserve
    ) private pure returns (uint256) {
        require(inputReserve > 0 && outputReserve > 0, "invalid reserves");

        // return (inputAmount * outputReserve) / (inputReserve + inputAmount);
        // 收取1%的手续费
        // 分子和分母同时 * 100
        uint256 inputAmountWithFee = inputAmount * 99;
        uint256 numerator = inputAmountWithFee * outputReserve;
        // * 100的目的可能是为了减小数值溢出的风险吧
        uint256 denominator = (inputReserve * 100) + inputAmountWithFee;

        return numerator / denominator;
    }

    // 公共函数提取，以太币 -> 代币的核心逻辑
    function ethToToken(uint256 _minTokens, address recipient) private {
        // 获取该合约所拥有的代币储备金
        uint256 tokenReserve = getReserve();
        // 获取代币金额
        uint256 tokensBought = getAmount(
            msg.value,
            address(this).balance - msg.value,
            tokenReserve
        );

        require(tokensBought >= _minTokens, "insufficient output amount");
        // 发送一定数量的代币给调用者
        IERC20(tokenAddress).transfer(recipient, tokensBought);
    }

    // 这个是指定发送人的以太币 -> 代币的逻辑
    function ethToTokenTransfer(
        uint256 _minTokens,
        address _recipient
    ) public payable {
        ethToToken(_minTokens, _recipient);
    }

    // 交换,以太币 => 代币
    function ethToTokenSwap(uint256 _minTokens) public payable {
        // // 获取该合约所拥有的代币储备金
        // uint256 tokenReserve = getReserve();
        // // msg.value 调用者发送的以太币
        // // address(this).balance - msg.value 以太币的储备金
        // // tokenReserve 代币储备金
        // uint256 tokensBought = getAmount(
        //     msg.value,
        //     address(this).balance - msg.value,
        //     tokenReserve
        // );
        // require(tokensBought >= _minTokens, "insufficient output amount");
        // // 发送一定数量的代币给调用者
        // IERC20(tokenAddress).transfer(msg.sender, tokensBought);
        // 这个是发送给调用者代币的逻辑
        ethToToken(_minTokens, msg.sender);
    }

    // 交换 代币 => 以太币
    function tokenToEthSwap(uint256 _tokensSold, uint256 _minEth) public {
        uint256 tokenReserve = getReserve();
        uint256 ethBought = getAmount(
            _tokensSold,
            tokenReserve,
            address(this).balance
        );

        require(ethBought >= _minEth, "insufficient output amount");

        IERC20(tokenAddress).transferFrom(
            msg.sender,
            address(this),
            _tokensSold
        );
        // 发送以太币给调用者，金额为ethBought
        payable(msg.sender).transfer(ethBought);
    }

    // 代币 -> 代币
    // _tokenSold 要出手的代币数量
    // _minEth 要交换的最小的代币数量
    // _tokenAddress 要交换的代币的合约地址
    function tokenToTokenSwap(
        uint256 _tokensSold,
        uint256 _minTokensBought,
        address _tokenAddress
    ) public {
        // 得到要交换的代币的合约地址
        address exchangeAddress = IFactory(factoryAddress).getExchange(
            _tokenAddress
        );
        require(
            exchangeAddress != address(this) && exchangeAddress != address(0),
            "invalid exchange address"
        );
        // 返回当前合约所拥有的代币储备金
        uint256 tokenReserve = getReserve();
        // 返回代币对应的以太币金额
        uint256 ethBought = getAmount(
            _tokensSold,
            tokenReserve,
            address(this).balance
        );
        // 从msg.sender中的地址转移一定数量的代币给当前合约
        IERC20(tokenAddress).transferFrom(
            msg.sender,
            address(this),
            _tokensSold
        );
        // 给调用合约的人转移一定数量的以太币
        // ethToToken将以太币转换为代币后发送给调用者
        IExchange(exchangeAddress).ethToTokenTransfer{value: ethBought}(
            _minTokensBought,
            msg.sender
        );
    }
}
