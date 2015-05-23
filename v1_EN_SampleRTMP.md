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

<strong>Step 2, build SRS.</strong> For detail, read [Build](https://github.com/simple-rtmp-server/srs/wiki/v1_EN_Build)

```bash
./configure --disable-all --with-ssl && make
```

<strong>Step 3, config srs.</strong> For detail, read [RTMP](https://github.com/simple-rtmp-server/srs/wiki/v1_EN_DeliveryRTMP)

Save bellow as config, or use `conf/rtmp.conf`:

```bash
# conf/rtmp.conf
listen              1935;
max_connections     1000;
vhost __defaultVhost__ {
}
```

<strong>Step 4, start srs.</strong> For detail, read [RTMP](https://github.com/simple-rtmp-server/srs/wiki/v1_EN_DeliveryRTMP)

```bash
./objs/srs -c conf/rtmp.conf
```

<strong>Step 5, start encoder.</strong> For detail, read [RTMP](https://github.com/simple-rtmp-server/srs/wiki/v1_EN_DeliveryRTMP)

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

<strong>Step 6, play RTMP.</strong> For detail, read [RTMP](https://github.com/simple-rtmp-server/srs/wiki/v1_EN_DeliveryRTMP)

RTMP url is: `rtmp://192.168.1.170:1935/live/livestream`

User can use vlc to play the RTMP stream.

Or, use online SRS player: [http://winlinvip.github.io/srs.release/trunk/research/players/srs_player.html?vhost=__defaultVhost__&autostart=true&server=192.168.1.170&app=live&stream=livestream&port=1935](http://winlinvip.github.io/srs.release/trunk/research/players/srs_player.html?vhost=__defaultVhost__&autostart=true&server=192.168.1.170&app=live&stream=livestream&port=1935)

Note: Please replace all ip 192.168.1.170 to your server ip.

Winlin 2014.11