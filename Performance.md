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
* 下载页面，包含编译脚本：[下载nginx-rtmp](http://download.csdn.net/download/winlinvip/6795467)
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

## 推流和观看

使用ffmpeg推送SRS的实例流到SRS，SRS转发给nginx-rtmp，可以通过vlc/srs-players观看。

推送RTMP流到服务器和观看。

* 启动FFMPEG循环推流：
```
for((;;)); do \
    ./objs/ffmpeg/bin/ffmpeg \
        -re -i doc/source.200kbps.768x320.flv \
        -acodec copy -vcodec copy \
        -f flv -y rtmp://127.0.0.1:1935/live/livestream; \
    sleep 1; 
done
```
* 查看服务器的地址：`192.168.2.101`
```
[root@dev6 nginx-rtmp]# ifconfig eth0
eth0      Link encap:Ethernet  HWaddr 08:00:27:8A:EC:94  
          inet addr:192.168.2.101  Bcast:192.168.2.255  Mask:255.255.255.0
```
* SRS的流地址：`rtmp://192.168.2.101:1935/live/livestream`
* 通过srs-players播放SRS流：[播放SRS的流](http://42.121.5.85:8085/players/srs_player.html?server=192.168.2.101&port=1935&app=live&stream=livestream&vhost=192.168.2.101&autostart=true)
* nginx-rtmp的流地址：`rtmp://192.168.2.101:19350/live/livestream`
* 通过srs-players播放nginx-rtmp流：[播放nginx-rtmp的流](http://42.121.5.85:8085/players/srs_player.html?server=192.168.2.101&port=19350&app=live&stream=livestream&vhost=192.168.2.101&autostart=true)

## 客户端

使用linux工具模拟RTMP客户端访问，参考：[st-load](https://github.com/winlinvip/st-load)

st_rtmp_load为RTMP流负载测试工具，单个进程可以模拟1000至3000个客户端。为了避免过高负载，一个进程模拟800个客户端。

* 编译：`./configure && make`
* 启动参数：`./objs/st_rtmp_load -c 800 -r <rtmp_url>`

## 开始负载测试前

测试前，记录SRS和nginx-rtmp的各项资源使用指标，用作对比。

* top命令：
```
srs_pid=`ps aux|grep srs|grep conf|awk '{print $2}'`; \
nginx_pid=`ps aux|grep nginx|grep worker|awk '{print $2}'`; \
top -p $srs_pid,$nginx_pid
```
* 查看连接数命令：
```
srs_connections=`netstat -anp|grep srs|grep ESTABLISHED|wc -l`; \
nginx_connections=`netstat -anp|grep nginx|grep ESTABLISHED|wc -l`; \
echo "srs_connections: $srs_connections"; \
echo "nginx_connections: $nginx_connections";
```
* 数据见下表：

<table>
<tr>
  <td>Server</td>
  <td>CPU</td>
  <td>Memory</td>
  <td>Time</td>
  <td>Connections</td>
</tr>
<tr>
  <td>SRS</td>
  <td>1.0%</td>
  <td>3MB</td>
  <td>0:12.97</td>
  <td>3</td>
</tr>
<tr>
  <td>nginx-rtmp</td>
  <td>0.7%</td>
  <td>8MB</td>
  <td>0:03.28</td>
  <td>2</td>
</tr>
</table>

其中，srs的三个连接是：
* FFMPEG推流连接。
* Forward给nginx RTMP流的一个连接。
* 观看连接：[播放地址](http://42.121.5.85:8085/players/srs_player.html?server=192.168.2.101&port=1935&app=live&stream=livestream&vhost=192.168.2.101&autostart=true)

其中，nginx-rtmp的两个连接是：
* SRS forward RTMP的一个连接。
* 观看连接：[播放地址](http://42.121.5.85:8085/players/srs_player.html?server=192.168.2.101&port=19350&app=live&stream=livestream&vhost=192.168.2.101&autostart=true)