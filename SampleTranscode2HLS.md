# 转码后分发HLS部署实例

HLS需要h.264+aac，若符合这个要求可以按照[Usage: HLS](https://github.com/winlinvip/simple-rtmp-server/wiki/SampleHLS)部署，若不符合这个要求则需要转码。

如何知道流是否是h264+aac编码：
* [Usage: HLS](https://github.com/winlinvip/simple-rtmp-server/wiki/SampleHLS)中的`Q&A`说明的问题。
* 看编码器的参数，FMLE可以选视频编码为vp6或者h264，音频一般为mp3/NellyMoser。，所以FMLE肯定推流是不符合要求的。
* 看SRS的日志，若显示`hls only support video h.264/avc codec. ret=601`，就明显说明是编码问题。

备注：在虚拟机上测试，一路流转码为aac，需要3%CPU，在物理机上可能稍好点。转码的开销比分发要大，实际应用需要考虑这个因素。

分发纯音频流参考：[HLS audio only](https://github.com/winlinvip/simple-rtmp-server/wiki/DeliveryHLS#hlsaudioonly)

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
./configure --with-ssl --with-hls --with-nginx --with-ffmpeg && make
```

<strong>第三步，启动分发hls（m3u8/ts）的nginx。详细参考[HLS分发](https://github.com/winlinvip/simple-rtmp-server/wiki/DeliveryHLS)

```bash
sudo ./objs/nginx/sbin/nginx
```

备注：请确定nginx已经启动，可以访问[http://192.168.1.170/nginx.html](http://192.168.1.170/nginx.html)，若能看到`nginx is ok`则没有问题。

<strong>第四步，编写SRS配置文件。</strong>详细参考[HLS分发](https://github.com/winlinvip/simple-rtmp-server/wiki/DeliveryHLS)

将以下内容保存为文件，譬如`conf/transcode2hls.audio.only.conf`，服务器启动时指定该配置文件(srs的conf文件夹有该文件)。

```bash
# conf/transcode2hls.audio.only.conf
listen              1935;
vhost __defaultVhost__ {
    hls {
        enabled         on;
        hls_path        ./objs/nginx/html;
        hls_fragment    10;
        hls_window      60;
    }
    transcode {
        enabled     on;
        ffmpeg      ./objs/ffmpeg/bin/ffmpeg;
        engine ff {
            enabled         on;
            vcodec          copy;
            acodec          libaacplus;
            abitrate        45;
            asample_rate    44100;
            achannels       2;
            aparams {
            }
            output          rtmp://127.0.0.1:[port]/[app]?vhost=[vhost]/[stream]_[engine];
        }
    }
}
```

备注：这个配置使用只转码音频，因为视频是h.264符合要求，若需要全转码，参考[HLS+Transcode](https://github.com/winlinvip/simple-rtmp-server/wiki/DeliveryHLS#wiki-hls%E5%92%8Ctranscode)

<strong>第五步，启动SRS。</strong>详细参考[HLS分发](https://github.com/winlinvip/simple-rtmp-server/wiki/DeliveryHLS)

```bash
./objs/srs -c conf/transcode2hls.audio.only.conf
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
* RTMP流地址为（FMLE推流无HLS地址）：`rtmp://192.168.1.170/live/livestream`
* 转码后的RTMP流地址为：`rtmp://192.168.1.170/live/livestream_ff`
* 转码后的HLS流地址为： `http://192.168.1.170/live/livestream_ff.m3u8`

<strong>第七步，观看RTMP流。</strong>详细参考[HLS分发](https://github.com/winlinvip/simple-rtmp-server/wiki/DeliveryHLS)

RTMP流地址为：`rtmp://192.168.1.170/live/livestream_ff`

可以使用VLC观看。

或者使用在线SRS播放器播放：[http://winlinvip.github.io/simple-rtmp-server/trunk/research/players/srs_player.html?vhost=__defaultVhost__&autostart=true&server=192.168.1.170&app=live&stream=livestream_ff](http://winlinvip.github.io/simple-rtmp-server/trunk/research/players/srs_player.html?vhost=__defaultVhost__&autostart=true&server=192.168.1.170&app=live&stream=livestream_ff)

备注：请将所有实例的IP地址192.168.1.170都换成部署的服务器IP地址。

<strong>第八步，观看HLS流。</strong>详细参考[HLS分发](https://github.com/winlinvip/simple-rtmp-server/wiki/DeliveryHLS)

HLS流地址为： `http://192.168.1.170/live/livestream_ff.m3u8`

可以使用VLC观看。

或者使用在线SRS播放器播放：[http://winlinvip.github.io/simple-rtmp-server/trunk/research/players/jwplayer6.html?vhost=__defaultVhost__&hls_autostart=true&server=192.168.1.170&app=live&stream=livestream_ff](http://winlinvip.github.io/simple-rtmp-server/trunk/research/players/jwplayer6.html?vhost=__defaultVhost__&hls_autostart=true&server=192.168.1.170&app=live&stream=livestream_ff)

备注：请将所有实例的IP地址192.168.1.170都换成部署的服务器IP地址。

Winlin 2014.3