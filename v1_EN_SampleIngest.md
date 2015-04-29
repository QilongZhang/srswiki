# Ingest deploy example

SRS can start process to ingest file/stream/device, transcode or not,
then publish to SRS. For detail, read [Ingest](https://github.com/simple-rtmp-server/srs/wiki/v1_EN_Ingest).

<strong>Suppose the server ip is 192.168.1.170</strong>

<strong>Step 1, get SRS.</strong> For detail, read [GIT](https://github.com/simple-rtmp-server/srs/wiki/v1_EN_Git)

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
./configure --disable-all --with-ssl --with-ffmpeg --with-ingest && make
```

<strong>Step 3, config srs.</strong> For detail, read [Ingest](https://github.com/simple-rtmp-server/srs/wiki/v1_EN_Ingest)

Save bellow as config, or use `conf/ingest.conf`:

```bash
# conf/ingest.conf
listen              1935;
max_connections     1000;
vhost __defaultVhost__ {
    ingest livestream {
        enabled      on;
        input {
            type    file;
            url     ./doc/source.200kbps.768x320.flv;
        }
        ffmpeg      ./objs/ffmpeg/bin/ffmpeg;
        engine {
            enabled          off;
            output          rtmp://127.0.0.1:[port]/live?vhost=[vhost]/livestream;
        }
    }
}
```

<strong>Step 4, start srs.</strong> For detail, read [Ingest](https://github.com/simple-rtmp-server/srs/wiki/v1_EN_Ingest)

```bash
./objs/srs -c conf/ingest.conf
```

The streams on SRS:
* Stream ingest: rtmp://192.168.1.170:1935/live/livestream

<strong>Step 5, play RTMP.</strong> For detail, read [Ingest](https://github.com/simple-rtmp-server/srs/wiki/v1_EN_Ingest)

RTMP url is: `rtmp://192.168.1.170:1935/live/livestream`

User can use vlc to play the RTMP stream.

Or, use online SRS player: [http://winlinvip.github.io/srs.release/trunk/research/players/srs_player.html?vhost=__defaultVhost__&autostart=true&server=192.168.1.170&app=live&stream=livestream&port=1935](http://winlinvip.github.io/srs.release/trunk/research/players/srs_player.html?vhost=__defaultVhost__&autostart=true&server=192.168.1.170&app=live&stream=livestream&port=1935)

Note: Please replace all ip 192.168.1.170 to your server ip.

Winlin 2014.11