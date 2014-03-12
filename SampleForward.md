# RTMP流转发（Forward）部署实例

SRS可以将送到SRS的流转发给其他RTMP服务器，实现简单集群/热备功能，也可以实现一路流热备（譬如编码器由于带宽限制，只能送一路流到RTMP服务器，要求RTMP服务器能将这路流也转发给其他RTMP备用服务器，实现主备容错集群）。

<strong>假设服务器的IP是：192.168.1.170</strong>

Forward就是SRS将流拷贝输出给其他的RTMP服务器，以SRS转发给SRS为例：
* 主SRS：编码器推流到主SRS，主SRS将流处理的同时，将流转发到备SRS
* 备SRS：主SRS转发流到备SRS，就像编码器推送流到备用SRS一样。
我们的部署实例中，主SRS侦听1935端口，备SRS侦听19350端口。

<strong>第一步，获取SRS。</strong>详细参考[GIT获取代码](https://github.com/winlinvip/simple-rtmp-server/wiki/Git)

```bash
git clone https://github.com/winlinvip/simple-rtmp-server
cd simple-rtmp-server/trunk
```

或者使用git更新已有代码：

```bash
git pull
```

<strong>第二步，编译SRS。</strong>详细参考[Build](https://github.com/winlinvip/simple-rtmp-server/wiki/Build)

```bash
./configure && make
```

<strong>第三步，编写主SRS配置文件。</strong>详细参考[Cluster](https://github.com/winlinvip/simple-rtmp-server/wiki/Cluster)

将以下内容保存为文件，譬如`conf/forward.master.conf`，服务器启动时指定该配置文件(srs的conf文件夹有该文件)。

```bash
# conf/forward.master.conf
listen              1935;
vhost __defaultVhost__ {
    forward         127.0.0.1:19350;
}
```

<strong>第四步，启动主SRS，主SRS将流转发到备SRS。</strong>详细参考[Cluster](https://github.com/winlinvip/simple-rtmp-server/wiki/Cluster)

```bash
./objs/srs -c conf/forward.master.conf
```

<strong>第五步，编写备SRS配置文件。</strong>详细参考[Cluster](https://github.com/winlinvip/simple-rtmp-server/wiki/Cluster)

将以下内容保存为文件，譬如`conf/forward.slave.conf`，服务器启动时指定该配置文件(srs的conf文件夹有该文件)。

```bash
# conf/forward.slave.conf
listen              19350;
vhost __defaultVhost__ {
}
```

<strong>第六步，启动备SRS，主SRS将流转发到备SRS。</strong>详细参考[Cluster](https://github.com/winlinvip/simple-rtmp-server/wiki/Cluster)

```bash
./objs/srs -c conf/forward.slave.conf
```

<strong>第七步，启动推流编码器。</strong>详细参考[Cluster](https://github.com/winlinvip/simple-rtmp-server/wiki/Cluster)

使用FFMPEG命令推流：

```bash
    for((;;)); do \
        ./objs/ffmpeg/bin/ffmpeg -re -i ./doc/source.200kbps.768x320.flv \
        -vcodec copy -acodec copy \
        -f flv -y rtmp://192.168.1.170/live/livestream; \
        sleep 1; \
    done
```

或使用FMLE推流：

```bash
FMS URL: rtmp://192.168.1.170/live
Stream: livestream
```

涉及的流包括：
* 编码器推送的流：rtmp://192.168.1.170/live/livestream
* 主SRS转发的流：rtmp://192.168.1.170:19350/live/livestream
* 观看主SRS的流：rtmp://192.168.1.170/live/livestream
* 观看备SRS的流：rtmp://192.168.1.170:19350/live/livestream

<strong>第八步，观看主SRS的RTMP流。</strong>详细参考[Cluster](https://github.com/winlinvip/simple-rtmp-server/wiki/Cluster)

RTMP流地址为：`rtmp://192.168.1.170/live/livestream`

可以使用VLC观看。

或者使用在线SRS播放器播放：[http://winlinvip.github.io/simple-rtmp-server/trunk/research/players/srs_player.html?vhost=__defaultVhost__&autostart=true&server=192.168.1.170&app=live&stream=livestream](http://winlinvip.github.io/simple-rtmp-server/trunk/research/players/srs_player.html?vhost=__defaultVhost__&autostart=true&server=192.168.1.170&app=live&stream=livestream)

备注：请将所有实例的IP地址192.168.1.170都换成部署的服务器IP地址。

<strong>第九步，观看备SRS的RTMP流。</strong>详细参考[Cluster](https://github.com/winlinvip/simple-rtmp-server/wiki/Cluster)

RTMP流地址为：`rtmp://192.168.1.170:19350/live/livestream`

可以使用VLC观看。

或者使用在线SRS播放器播放：[http://winlinvip.github.io/simple-rtmp-server/trunk/research/players/srs_player.html?vhost=__defaultVhost__&autostart=true&server=192.168.1.170&app=live&stream=livestream&port=19350](http://winlinvip.github.io/simple-rtmp-server/trunk/research/players/srs_player.html?vhost=__defaultVhost__&autostart=true&server=192.168.1.170&app=live&stream=livestream&port=19350)

备注：请将所有实例的IP地址192.168.1.170都换成部署的服务器IP地址。

Winlin 2014.3