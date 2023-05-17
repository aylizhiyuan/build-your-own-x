新建Docker步骤


1、 容器操作

获取镜像image

docker pull ubuntu  我的理解是拉取远程的镜像资源(大部分都会提供一些镜像)

有了镜像之后便可以启动了,使用

docker run -it ubuntu /bin/bash   i 交互式操作  t 终端， 退出的话是exit

交互式的docker，比较适合从0开始搭建的那种


但是大部分情况下，我们是希望他们是后台运行的，所以,通过后台运行方式启动docker

docker run -itd —name ubuntu-test ubuntu /bin/bash

这时候可以查看我的容器进程 

docker ps -a 

可以选择关闭

docker stop 容器ID 或者 docker restart or start 容器Id


以后台运行的容器，如果想进去进行操作的话，则可以使用

docker attach  如果退出会导致容器退出

docker exec 推荐使用 

docker exec -it 2594b9575c34 /bin/bash

删除容器

docker rm -f 容器Id 删除容器


2、 运行我们的web应用

举例： 

docker pull training/webapp # 载入镜像
docker run -d -P training/webapp pyhton app.py  启动我们的应用 
docker run -d -p 5000(机器):5000(容器) training/webapp python app.py  内部的5000端口映射外部的5000端口
docker port 容器id 查看我的容器进程的端口情况
docker logs -f 容器id 查看我的容器进程的标准输出
docker top 容器id  查看我容器进程中的进程


3、 docker镜像的使用

我们可以通过docker images查看我们本地的镜像

一、从已经创建的容器中更新镜像，并提交

docker run -t -i ubuntu:15.10 /bin/bash  启动了一个容器

进入容器内进行了更新操作之后可以使用

docker commit -m="has update" -a="runoob" e218edb10161 runoob/ubuntu:v2

-m 提交的描述信息
-a 指定镜像作者
e218edb10161 容器ID
runoob/ubuntu:v2: 指定要创建的目标镜像名

然后我们可以启动这个我们新建的镜像  docker run -t -i runoob/ubuntu:v2 /bin/bash    




二、使用dockerfile指令来创建一个新的镜像

暂不补充...


4、仓库管理

公共仓库 在 https://hub.docker.com 免费注册一个 Docker 账号 

docker search ubuntu
docker pull ubuntu
docker push username/ubuntu:18.04



5、dockerfile
```
* FROM
构建镜像基于哪个镜像
* MAINTAINER
镜像维护者姓名或邮箱地址
* RUN
构建镜像时运行的指令
* CMD
运行容器时执行的shell环境
* VOLUME
指定容器挂载点到宿主机自动生成的目录或其他容器
* USER
为RUN、CMD、和 ENTRYPOINT 执行命令指定运行用户
* WORKDIR
为 RUN、CMD、ENTRYPOINT、COPY 和 ADD 设置工作目录，就是切换目录
* HEALTHCHECH
健康检查
* ARG
构建时指定的一些参数
* EXPOSE
声明容器的服务端口（仅仅是声明）
* ENV
设置容器环境变量
* ADD
拷贝文件或目录到容器中，如果是URL或压缩包便会自动下载或自动解压
* COPY
拷贝文件或目录到容器中，跟ADD类似，但不具备自动下载或解压的功能
* ENTRYPOINT
运行容器时执行的shell命令
```


6、dockercomponse

Compose 使用的三个步骤：
```
* 使用 Dockerfile 定义应用程序的环境。
* 使用 docker-compose.yml 定义构成应用程序的服务，这样它们可以在隔离环境中一起运行。
* 最后，执行 docker-compose up 命令来启动并运行整个应用程序。
```









