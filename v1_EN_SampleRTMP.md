# RTMP deploy example

RTMP is the kernel feature of SRS.

<strong>Suppose the server ip is 192.168.1.170</strong>

<strong>Step 1, get SRS.</strong> For detail, read [GIT][GIT]

```bash
git clone https://github.com/simple-rtmp-server/srs
cd simple-rtmp-server/trunk
```

Or update the exists code:

```bash
git pull
```

<strong>Step 2, build SRS.</strong> For detail, read [Build][Build]

```bash
./configure --disable-all --with-ssl && make
```

<strong>Step 3, config srs.</strong> For detail, read [RTMP](v1_CN_DeliveryRTMP)

Save bellow as config, or use `conf/rtmp.conf`:

```bash
# conf/rtmp.conf
listen              1935;
max_connections     1000;
vhost __defaultVhost__ {
}
```

<strong>Step 4, start srs.</strong> For detail, read [RTMP](v1_CN_DeliveryRTMP)

```bash
./objs/srs -c conf/rtmp.conf
```

<strong>Step 5, start encoder.</strong> For detail, read [RTMP](v1_CN_DeliveryRTMP)

Use FFMPEG to publish stream:

```bash
    for((;;)); do \
        ./objs/ffmpeg/bin/ffmpeg -re -i ./doc/source.200kbps.768x320.flv \
        -vcodec copy -acodec copy \
        -f flv -y rtmp://192.168.1.170/live/livestream; \
        sleep 1; \
    done
```

Or use FMLE to publish:

```bash
FMS URL: rtmp://192.168.1.170/live
Stream: livestream
```

<strong>Step 6, play RTMP.</strong> For detail, read [RTMP](v1_CN_DeliveryRTMP)

RTMP url is: `rtmp://192.168.1.170:1935/live/livestream`

User can use vlc to play the RTMP stream.

Or, use online SRS player: [srs-player][srs-player]

Note: Please replace all ip 192.168.1.170 to your server ip.

Winlin 2014.11

[RTMP]: https://github.com/simple-rtmp-server/srs/wiki/v1_EN_DeliveryRTMP
[LowLatency]: https://github.com/simple-rtmp-server/srs/wiki/v1_EN_LowLatency
[Ingest]: https://github.com/simple-rtmp-server/srs/wiki/v1_EN_Ingest
[Forward]: https://github.com/simple-rtmp-server/srs/wiki/v1_EN_Forward
[FFMPEG]: https://github.com/simple-rtmp-server/srs/wiki/v1_EN_FFMPEG
[Usage]: https://github.com/simple-rtmp-server/srs/tree/1.0release#usage
[SrsLinuxArm]: https://github.com/simple-rtmp-server/srs/wiki/v1_EN_SrsLinuxArm
[HLS-And-Transcode]: https://github.com/simple-rtmp-server/srs/wiki/v1_EN_DeliveryHLS#hls-and-transcode
[HLS-Audio-Only]: https://github.com/simple-rtmp-server/srs/wiki/v1_EN_DeliveryHLS#hlsaudioonly
[nginx]: http://192.168.1.170:8080/nginx.html
[GIT]: https://github.com/simple-rtmp-server/srs/wiki/v1_EN_Git
[Build]: https://github.com/simple-rtmp-server/srs/wiki/v1_EN_Build
[HLS]: https://github.com/simple-rtmp-server/srs/wiki/v1_EN_DeliveryHLS
[HTTP-Server]: https://github.com/simple-rtmp-server/srs/wiki/v1_EN_HTTPServer
[Transcode2HLS]: https://github.com/simple-rtmp-server/srs/wiki/v1_EN_SampleTranscode2HLS
[srs-player]: http://winlinvip.github.io/srs.release/trunk/research/players/srs_player.html?vhost=__defaultVhost__&autostart=true&server=192.168.1.170&app=live&stream=livestream&port=1935
[srs-player-19350]: http://winlinvip.github.io/srs.release/trunk/research/players/srs_player.html?vhost=__defaultVhost__&autostart=true&server=192.168.1.170&app=live&stream=livestream&port=19350
[srs-player-ff]: http://winlinvip.github.io/srs.release/trunk/research/players/srs_player.html?vhost=__defaultVhost__&autostart=true&server=192.168.1.170&app=live&stream=livestream_ff
[jwplayer]: http://winlinvip.github.io/srs.release/trunk/research/players/jwplayer6.html?vhost=__defaultVhost__&hls_autostart=true&server=192.168.1.170&app=live&stream=livestream&hls_port=8080
[jwplayer-ff]: http://winlinvip.github.io/srs.release/trunk/research/players/jwplayer6.html?vhost=__defaultVhost__&hls_autostart=true&server=192.168.1.170&app=live&stream=livestream_ff&hls_port=8080

