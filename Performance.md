# Performance

对比SRS和高性能nginx-rtmp的Performance，SRS为单进程，nginx-rtmp支持多进程，为了对比nginx-rtmp也只开启一个进程。

提供详细的性能测试的过程，可以为其他性能测试做出参数，譬如测试nginx-rtmp的多进程，和srs的forward对比之类。

## 硬件环境

本次对比所用到的硬件环境，使用虚拟机，客户端和服务器都运行于一台机器，避开网络瓶颈。

* 硬件: 虚拟机
* 系统: CentOS 6.0 x86_64 Linux 2.6.32-71.el6.x86_64
* CPU: 3 Intel(R) Core(TM) i7-3520M CPU @ 2.90GHz
× 内存: 2007MB

## OS设置

超过1024的连接数测试需要打开linux的限制。且必须以root登录和执行。

* 设置连接数：`ulimit -HSn 10240`
* 查看连接数：
```
[root@dev6 ~]# ulimit -n
10240
```
* 注意：启动服务器前必须确保连接数限制打开。

## NGINX-RTMP

NGINX-RTMP使用的版本信息，以及编译参数。

* NGINX: nginx-1.5.7.tar.gz
* NGINX-RTMP: nginx-rtmp-module-1.0.4.tar.gz
* 编译参数：
```
./configure --prefix=`pwd`/../_release \
--add-module=`pwd`/../nginx-rtmp-module-1.0.4 \
--with-http_ssl_module && make && make install
```
* 配置nginx：`_release/conf/nginx.conf`
```
user  root;
worker_processes  1;

events {
    worker_connections  10240;
}
rtmp{
    server{
        listen 19350;
        application live{
            live on;
        }
    }
}
```
* 确保连接数没有限制：
```
[root@dev6 nginx-rtmp]# ulimit -n
10240
```
* 启动命令：``./_release/sbin/nginx``
* 确保nginx启动成功：
```
[root@dev6 nginx-rtmp]# netstat -anp|grep 19350
tcp        0      0 0.0.0.0:19350               0.0.0.0:*                   LISTEN      6486/nginx
```

## SRS

SRS接受RTMP流，并转发给nginx-rtmp做为对比。

SRS的版本和编译参数。

* SRS: [SRS 0.9](https://github.com/winlinvip/simple-rtmp-server/releases/tag/0.9)
* 编译参数：``./configure && make``
* 配置SRS：`conf/srs.conf`
```
listen              1935;
max_connections     10240;
vhost __defaultVhost__ {
    gop_cache       on;
    forward         127.0.0.1:19350;
}
```
* 确保连接数没有限制：
```
[root@dev6 trunk]# ulimit -n
10240
```
* 启动命令：``nohup ./objs/srs -c conf/srs.conf >/dev/null 2>&1 &``
* 确保srs启动成功：
```
[root@dev6 trunk]# netstat -anp|grep "1935 "
tcp        0      0 0.0.0.0:1935                0.0.0.0:*                   LISTEN      6583/srs
```

## 客户端

使用linux工具模拟RTMP客户端访问，参考：[st-load](https://github.com/winlinvip/st-load)

* 编译：`./configure && make`