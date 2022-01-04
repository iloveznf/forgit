#源镜像
FROM golang:latest
#作者
MAINTAINER libo "490278886@qq.com"
#设置工作目录
WORKDIR /usr/local/service-a
#将服务器的go工程代码加入到docker容器中
ADD ./service-a /usr/local/service-a
#暴露端口
EXPOSE 8888
#最终运行docker的命令

ENTRYPOINT  ["./service-a"," --file","./config.yaml"]
