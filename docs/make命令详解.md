# make命令

## 文件格式

1. 概述

makefile文件由一系列`规则(rules)`构成 

```
<target> : <prerequisites>
[tab]   <commands>
```
上面第一行冒号前面的部分，叫做`目标`，冒号后面的部分叫做`前置条件`，第二行必须由一个tab键起首，后面跟着命令

目标是必须的，不可省略；`前置条件`和`命令`都是可选的，但是两者之中必须至少存在一个。

每条规则就明确两件事儿: 构建目标的前置条件是什么以及如何构建

2. 目标

一个目标构成一条规则。目标通常是文件名，指明make命令要构建的对象，例如a.txt ，目标可以是一个文件名，也可以是多个文件名，之前用空格分隔

除了文件名，目标还可以是某个操作的名字，这称为伪目标

```shell
clean:
    rm *.o
```
上面的代码的目标是clean,他不是一个文件名称，而是一个操作的名称，属于伪目标，作用是删除对象文件

```shell
make clean
```

但是如果当前目录中，正好有一个文件叫做clean,那么这个命令不会执行，因为make发现clean文件已经存在，就认为没有必要构建了

为了避免这种情况，可以明确的声明clean是伪目标

```shell 
.PHONY: clean
clean:
    rm *.o temp
```

如果make命令运行时候没有指定目标，默认会执行makefile文件的第一个目标

```shell
make
```

3. 前置条件

前置条件通常是一组文件名，之间用空格分割。它制定了目标是否重新构建的判断标准：只要有一个前置文件不存在，或者有过更新，目标就需要重新构建

```shell
result.txt: source.txt
    cp source.txt result.txt
```

上面的代码中，构建result.txt的前置条件就是source.txt,如果当前目录中,source.txt已经存在，那么make result.txt可以正常运行，否则必须再写一条规则，生成source.txt

```shell
source.txt:
    echo "this is the source" > source.txt
```

上面的代码中,srouce.txt后面没有前置条件，就意味着它跟其他文件没有关系，这要这个文件还不存在，每次调用make source.txt它都会生成

如果需要生成多个文件，往往需要下面的写法:

```shell
source: file1 file2 file3

# 这里再分别定义file1/file2/file3
file1:
    echo "file1"
file2:
    echo "file2"
file3:
    echo "file3"        
```

直接执行make source 相当于

```shell
make file1
make file2
make file3
```

> 我的理解就是命令的嵌套，先后顺序


4. 命令

命令表示如何更新目标文件，由一行或者多行的shell命令组成，每个命令之前必须有一个tab键



## 文件的语法

1. 注释

\# 代表注释

```shell
# 这就是注释
result.txt: source.txt
```

2. 回声

正常情况下,make会打印每条命令，然后执行，在命令的前面加上@，就可以关闭回声

> 通常只会在纯注释或者输出的地方加上@


3. 通配符

```shell
clean:
#匹配所有的.o文件
    rm -f *.0 
```

4. 模式匹配

make命令允许对文件名进行类似正则运算的匹配，主要的匹配符是%,比如假定当前目录下有f1.c和f2.c两个文件，需要将他们编译成对应的对象文件


```shell

%.o: %.c

```

等同于

```shell
f1.o: f1.c
f2.o: f2.c
```

5. 变量和赋值(声明变量)

```shell
txt = Hello World
test:
    # 变量需要放到$()之中
    @echo $(txt)
    # shell的变量双$
    @echo $$HOME
```

6. 内置变量

```shell
output:
    # CC指向当前使用的编译器
    # 主要是为了跨平台兼容性
    $(CC) -o output input.c

```

7. 自动变量

```shell
#  $@ 指当前目标,例如make foo的$@就是foo
a.txt b.txt:
    # 等同于分别touch a.txt / touch b.txt
    touch $@

```


```shell
# $< 指代第一个前提条件，例如规则t:p1 p2,那么$<指代p1
a.txt: b.txt c.txt
    cp $< $@

```

- 额外

```

 $? 指代比目标更新的所有前置条件，之间以空格分割，比如规则为t:p1 p2,其中p2的时间戳比t新，$?就指代p2

 $^ 指代所有的前置条件，之间以空格分割，例如规则t: p1 p2,那么 $^就指代p1 p2

 $* 指代匹配符%的部分，比如%匹配f1.txt中的f1,$*就表示f1


 $(@D)和$(@F),分别指向 $@ 的目录名和文件名。比如，$@是 src/input.c，那么$(@D) 的值为 src ，$(@F) 的值为 input.c

 $(<D) 和 $(<F) $(<D) 和 $(<F) 分别指向 $< 的目录名和文件名。

```

8. 判断和循环

makefile使用Bash预发，完成判断和循环

```shell
ifeq (\$(CC), gcc)
    libs = $(libs_for_gcc)
else
    libs = $(normal_libs)
endif        
```
上面的代码判断当前编译器是否是gcc,然后制定不同的库文件


```shell
LIST = one two three
all:
    for i in $(LIST); do \
        echo $$i; \
    done

# 等同于

all:
    for i in one two three; do \
        echo $i; \
    done

```


9. 函数

- shell函数

shell 函数用来执行 shell 命令

```shell
srcfiles := $(shell echo src/{00..99}.txt)
```

- wildcard函数

wildcard 函数用来在 Makefile 中，替换 Bash 的通配符。
```shell
srcfiles := $(wildcard src/*.txt)

```

- subst函数

下面的例子将字符串"feet on the street"替换成"fEEt on the strEEt"。

```shell

$(subst ee,EE,feet on the street)

```

- patsubst函数

下面的例子将文件名"x.c.c bar.c"，替换成"x.c.o bar.o"。

```shell
$(patsubst %.c,%.o,x.c.c bar.c)
```

- 替换后缀名
替换后缀名函数的写法是：变量名 + 冒号 + 后缀名替换规则。它实际上patsubst函数的一种简写形式。

```shell
min: $(OUTPUT:.js=.min.js)

```
上面代码的意思是，将变量OUTPUT中的后缀名 .js 全部替换成 .min.js 。


## cmake


自动生成兼容不同平台的makefile文件，非常的方便...建议以后就用它把







