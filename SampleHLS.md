# HLS部署实例

SRS支持HLS的详细步骤。

<strong>假设服务器的IP是：192.168.1.170</strong>

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

<strong>第三步，启动分发hls（m3u8/ts）的nginx。详细参考[HLS分发](https://github.com/winlinvip/simple-rtmp-server/wiki/DeliveryHLS)

```bash
sudo ./objs/nginx/sbin/nginx
```

备注：请确定nginx已经启动，可以访问[http://192.168.1.170/nginx.html](http://192.168.1.170/nginx.html)，若能看到`nginx is ok`则没有问题。

<strong>第四步，编写SRS配置文件。</strong>详细参考[HLS分发](https://github.com/winlinvip/simple-rtmp-server/wiki/DeliveryHLS)

将以下内容保存为文件，譬如`conf/hls.conf`，服务器启动时指定该配置文件(srs的conf文件夹有该文件)。

```bash
# conf/hls.conf
listen              1935;
vhost __defaultVhost__ {
    hls {
        enabled         on;
        hls_path        ./objs/nginx/html;
        hls_fragment    10;
        hls_window      60;
    }
}
```

<strong>第五步，启动SRS。</strong>详细参考[HLS分发](https://github.com/winlinvip/simple-rtmp-server/wiki/DeliveryHLS)

```bash
./objs/srs -c conf/hls.conf
```

<strong>第六步，启动推流编码器。</strong>详细参考[HLS分发](https://github.com/winlinvip/simple-rtmp-server/wiki/DeliveryHLS)

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

生成的流地址为：
* RTMP流地址为：`rtmp://192.168.1.170/live/livestream`
* HLS流地址为： `http://192.168.1.170/live/livestream.m3u8`

<strong>

<strong>第七步，观看RTMP流。</strong>详细参考[HLS分发](https://github.com/winlinvip/simple-rtmp-server/wiki/DeliveryHLS)

RTMP流地址为：`rtmp://192.168.1.170/live/livestream`

可以使用VLC观看。

或者使用在线SRS播放器播放：[http://winlinvip.github.io/simple-rtmp-server/trunk/research/players/srs_player.html?vhost=__defaultVhost__&autostart=true&server=192.168.1.170&app=live&stream=livestream](http://winlinvip.github.io/simple-rtmp-server/trunk/research/players/srs_player.html?vhost=__defaultVhost__&autostart=true&server=192.168.1.170&app=live&stream=livestream)

备注：请将所有实例的IP地址192.168.1.170都换成部署的服务器IP地址。

<strong>第八步，观看HLS流。</strong>详细参考[HLS分发](https://github.com/winlinvip/simple-rtmp-server/wiki/DeliveryHLS)

HLS流地址为： `http://192.168.1.170/live/livestream.m3u8`

可以使用VLC观看。

或者使用在线SRS播放器播放：[http://winlinvip.github.io/simple-rtmp-server/trunk/research/players/jwplayer6.html?vhost=__defaultVhost__&hls_autostart=true&server=192.168.1.170&app=live&stream=livestream](http://winlinvip.github.io/simple-rtmp-server/trunk/research/players/jwplayer6.html?vhost=__defaultVhost__&hls_autostart=true&server=192.168.1.170&app=live&stream=livestream)

备注：请将所有实例的IP地址192.168.1.170都换成部署的服务器IP地址。

Winlin 2014.3