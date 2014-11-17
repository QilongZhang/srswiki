# Transcode deploy example

FFMPEG can used to transcode the live stream, output the other RTMP server.
For detail, read [FFMPEG](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_FFMPEG).

<strong>Suppose the server ip is 192.168.1.170</strong>

<strong>Step 1, get SRS.</strong> For detail, read [GIT](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_Git)

```bash
git clone https://github.com/winlinvip/simple-rtmp-server
cd simple-rtmp-server/trunk
```

Or update the exists code:

```bash
git pull
```

<strong>Step 2, build SRS.</strong> For detail, read [Build](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_Build)

```bash
./configure --disable-all --with-ssl --with-ffmpeg --with-transcode && make
```

<strong>Step 3, config file.</strong> For detail, read [FFMPEG](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_FFMPEG)

Save the bellow as config file, or use `conf/ffmpeg.transcode.conf` instead:

```bash
# conf/ffmpeg.transcode.conf
listen              1935;
max_connections     1000;
vhost __defaultVhost__ {
    transcode {
        enabled     on;
        ffmpeg      ./objs/ffmpeg/bin/ffmpeg;
        engine ff {
            enabled         on;
            vfilter {
            }
            vcodec          libx264;
            vbitrate        500;
            vfps            25;
            vwidth          768;
            vheight         320;
            vthreads        12;
            vprofile        main;
            vpreset         medium;
            vparams {
            }
            acodec          libaacplus;
            abitrate        70;
            asample_rate    44100;
            achannels       2;
            aparams {
            }
            output          rtmp://127.0.0.1:[port]/[app]?vhost=[vhost]/[stream]_[engine];
        }
    }
}
```

<strong>Step 4, start SRS.</strong> For detail, read [FFMPEG](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_FFMPEG)

```bash
./objs/srs -c conf/ffmpeg.conf
```

<strong>第四步，启动推流编码器。</strong> For detail, read [FFMPEG](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_FFMPEG)

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
* 编码器推送流：rtmp://192.168.1.170:1935/live/livestream
* 观看原始流：rtmp://192.168.1.170:1935/live/livestream
* 观看转码流：rtmp://192.168.1.170:1935/live/livestream_ff

<strong>第五步，观看RTMP流。</strong> For detail, read [FFMPEG](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_FFMPEG)

RTMP url is: `rtmp://192.168.1.170:1935/live/livestream`

User can use vlc to play the RTMP stream.

Or, use online SRS player: [http://winlinvip.github.io/srs.release/trunk/research/players/srs_player.html?vhost=__defaultVhost__&autostart=true&server=192.168.1.170&app=live&stream=livestream&port=1935](http://winlinvip.github.io/srs.release/trunk/research/players/srs_player.html?vhost=__defaultVhost__&autostart=true&server=192.168.1.170&app=live&stream=livestream&port=1935)

Note: Please replace all ip 192.168.1.170 to your server ip.

<strong>第六步，观看FFMPEG转码的RTMP流。</strong> For detail, read [FFMPEG](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_FFMPEG)

RTMP url is: `rtmp://192.168.1.170:1935/live/livestream_ff`

User can use vlc to play the RTMP stream.

Or, use online SRS player: [http://winlinvip.github.io/srs.release/trunk/research/players/srs_player.html?vhost=__defaultVhost__&autostart=true&server=192.168.1.170&app=live&stream=livestream_ff&port=1935](http://winlinvip.github.io/srs.release/trunk/research/players/srs_player.html?vhost=__defaultVhost__&autostart=true&server=192.168.1.170&app=live&stream=livestream_ff&port=1935)

Note: Please replace all ip 192.168.1.170 to your server ip.

Winlin 2014.3