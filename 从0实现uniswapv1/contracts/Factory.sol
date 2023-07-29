//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./Exchange.sol";

contract Factory {
    // 代币的地址 -> 交换合约地址
    mapping(address => address) public tokenToExchange;

    // 创建一个新的交换合约，_tokenAddress表示要创建交换合约的代币地址
    function createExchange(address _tokenAddress) public returns (address) {
        require(_tokenAddress != address(0), "invalid token address");
        require(
            tokenToExchange[_tokenAddress] == address(0),
            "exchange already exists"
        );
        // 首先实例化一个交换合约
        Exchange exchange = new Exchange(_tokenAddress);
        // 这里其实将一个代币地址映射到一个合约地址上去
        tokenToExchange[_tokenAddress] = address(exchange);
        // 返回一个交换合约的地址
        return address(exchange);
    }

    // 给定代币地址对应的交换合约地址
    function getExchange(address _tokenAddress) public view returns (address) {
        return tokenToExchange[_tokenAddress];
    }
}
