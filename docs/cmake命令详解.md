# cmake命令

## 概述

cmake是一个项目构建工具,并且是跨平台的.makefile通常依赖于当前的编译平台,cmake允许开发者指定整个工程的编译流程,再根据编译平台,自动生成本地化的Makefile和工程文件,最后用户只需make即可

```
项目源码 --> CMakeLists.txt --> cmake执行命令 --> 生成Makefile文件 --> make执行命令
```

## 使用

### 1. 注释

CMake使用`#`进行行注释,可以放在任何位置

```CMAKE

# 这是一个 CMakeLists.txt 文件
cmake_minimum_required(VERSION 3.0.0)
```

CMake使用`#[[]]`进行块注释

```SHELL
#[[ 这是一个 CMakeLists.txt 文件 
这是一个 CMakeLists.txt 文件 
这是一个 CMakeLists.txt 文件
]]
cmake_minimum_required(VERSION 3.0.0)
```


### 2. 共处一室

```shell
$ tree
.
├── add.c
├── div.c
├── head.h
├── main.c
├── mult.c
└── sub.c

```

在上述源文件所在目录下添加一个新的文件`CMakeLists.txt`,文件内容如下:

```CMAKE
cmake_minimum_required(VERSION 3.0)
project(CALC)
add_executable(app add.c div.c main.c mult.c sub.c)
```

- cmake_minimum_required 指定使用的cmake最低版本,可选,非必须,如果不嫁可能会有警告
- project: 定义工程名称,并可指定工程的版本、工程描述、web主页地址、支持的语言,如果不需要这些都是可以忽略的

```CMAKE
# PROJECT 指令的语法是：
project(<PROJECT-NAME> [<language-name>...])
project(<PROJECT-NAME>
       [VERSION <major>[.<minor>[.<patch>[.<tweak>]]]]
       [DESCRIPTION <project-description-string>]
       [HOMEPAGE_URL <url-string>]
       [LANGUAGES <language-name>...])
```
- add_executable: 定义工程会生成一个可执行程序

```CMAKE
add_executable(可执行程序名 源文件名称)
```

这里面的可执行程序名和`project`中的项目名没有任何关系,源文件名可以是一个也可以是多个,如有多个可用空格或`;`间隔

```CMAKE
# 样式1
add_executable(app add.c div.c main.c mult.c sub.c)

# 样式2
add_executable(app add.c;div.c;main.c;mult.c;sub.c)
```

现在就可以开始执行CMAKE命令了

```SHELL
# cmake 命令原型
$ cmake CMakeLists.txt文件所在路径
```

```SHELL
$ tree
.
├── add.c
├── CMakeLists.txt
├── div.c
├── head.h
├── main.c
├── mult.c
└── sub.c

0 directories, 7 files
robin@OS:~/Linux/3Day/calc$ cmake .
```

执行命令完毕后

```SHELL
$ tree -L 1
.
├── add.c
├── CMakeCache.txt         # new add file
├── CMakeFiles             # new add dir
├── cmake_install.cmake    # new add file
├── CMakeLists.txt
├── div.c
├── head.h
├── main.c
├── Makefile               # new add file
├── mult.c
└── sub.c
```

我们可以看到在对应的目录下生成了一个`makefile`文件,此时再执行`make`命令,就可以看到我们的执行程序了

```SHELL

$ make
Scanning dependencies of target app
[ 16%] Building C object CMakeFiles/app.dir/add.c.o
[ 33%] Building C object CMakeFiles/app.dir/div.c.o
[ 50%] Building C object CMakeFiles/app.dir/main.c.o
[ 66%] Building C object CMakeFiles/app.dir/mult.c.o
[ 83%] Building C object CMakeFiles/app.dir/sub.c.o
[100%] Linking C executable app
[100%] Built target app

# 查看可执行程序是否已经生成
$ tree -L 1
.
├── add.c
├── app					# 生成的可执行程序
├── CMakeCache.txt
├── CMakeFiles
├── cmake_install.cmake
├── CMakeLists.txt
├── div.c
├── head.h
├── main.c
├── Makefile
├── mult.c
└── sub.c
```

**放在build文件夹中执行**

```SHELL
# 首先进入build文件夹再执行cmake
$ mkdir build
$ cd build
$ cmake ..
```

```SHELL
$ tree build -L 1
build
├── CMakeCache.txt
├── CMakeFiles
├── cmake_install.cmake
└── Makefile

1 directory, 3 files

```



### 3. 私人定制

***变量***

```CMAKE
# SET的指令的语法是:
# []中的参数为可选项,如不需要则可以不写
SET (VAR [VALUE] [CACHE TYPE DOCSTRING [FORCE]])
```


```CMAKE
# 方式1: 各个源文件之间使用空格间隔
# set(SRC_LIST add.c div.c main.c mult.c sub.c)

# 方式2: 各个源文件之间使用分号;间隔
set(SRC_LIST add.c;div.c;main.c;mult.c;sub.c)
add_executable(app ${SRC_LIST})
```

***指定使用的C++标准***

```CMAKE
# 增加-std=c++11
set(CMAKE_CXX_STANDARD 11)
# 增加-std=C++14
set(CMAKE_CXX_STANDARD 14)
# 增加-std=C++17
set(CMAKE_CXX_STANDARD 17)
```
在执行cmake命令的时候指定这个宏的值

```SHELL
cmake 文件路径 -DCMAKE_CXX_STANDARD=11

cmake 文件路径 -DCMAKE_CXX_STANDARD=14

cmake 文件路径 -DCMAKE_CXX_STANDARD=17
```

***指定输出的路径***

```CMAKE
set(HOME /home/robin/Linux/Sort)
set(EXECUTABLE_OUTPUT_PATH ${HOME}/bin)
```

### 4. 搜索文件

使用`aux_source_directory`可以查找某个路径下的所有源文件

```CMAKE
# dir: 要搜索的目录
# variable: 将从dir目录搜索到的源文件列表存储到该变量中
axu_source_directory(< dir > < variable >)
```

```CMAKE
cmake_minimum_required(VERSION 3.0)
project(CALC)
include_directory(${PROJECT_SOURCE_DIR}/include)
# 搜索src目录下的源文件
aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR}/src SRC_LIST)
add_executeable(app ${SRC_LIST})
```

***根据规则查找文件***

```CMAKE
# GLOB: 将指定目录下搜索到的满足
file(GLOB/GLOB_RECURSE 变量名 要搜索的文件路径和文件类型)
file(GLOB MAIN_SRC ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp)
file(GLOB MAIN_HEAD ${CMAKE_CURRENT_SOURCE_DIR}/include/*.h)
```

### 5. 包含头文件

通常系统内部包含的头文件是不需要做什么处理的,gcc会自动为你包含,但是如果是自己创建的头文件,可能会放在`include`文件夹中,默认是需要指明头文件的位置的

```CMAKE
include_directories(headpath)
```

```SHELL
$ tree
.
├── build
├── CMakeLists.txt
├── include
│   └── head.h
└── src
    ├── add.cpp
    ├── div.cpp
    ├── main.cpp
    ├── mult.cpp
    └── sub.cpp

3 directories, 7 files
```

cMakeLists.txt的文件内容如下:

```CMAKE
cmake_minimum_required(VERSION 3.0)
project(CALC)
set(CMAKE_CXX_STANDARD 11)
set(HOME /home/robin/Linux/calc)
set(EXECUTABLE_OUTPUT_PATH ${HOME}/bin/)
include_directories(${PROJECT_SOURCE_DIR}/include)
file(GLOB SRC_LIST ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp)
add_executable(app  ${SRC_LIST})
```

### 6. 制作静态库或者动态库

有些时候我们编写的源代码并不需要将他们编译生成为可执行程序,而是生成静态库或者动态库给第三方使用

静态库可以让不同的项目直接复用相同的代码,仅仅是为了`复用`,我们自己的类库通常就是做成静态库

***制作静态库***

***制作动态库***

***指定输出的路径***

### 7. 包含库文件

***链接静态库***

***链接动态库***

### 8. 日志

### 9. 变量操作

### 10. 宏定义




