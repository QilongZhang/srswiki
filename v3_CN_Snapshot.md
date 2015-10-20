# Snapshot

截图有以下几种方式可以实现：

1. HttpCallback：使用HTTP回调，收到`on_publish`事件后开启ffmpeg进程截图，收到`on_unpublish`事件后停止ffmpeg进程。SRS提供了实例，具体参考下面的内容。
1. Transcoder：转码可以配置为截图，SRS提供了实例，具体参考下面的内容。

## HttpCallback

下面的实例使用Http回调截图。

先启动实例Api服务器：
```
python research/api-server/server.py 8085
```

SRS的配置如下：
```
# snapshot.conf
listen              1935;
max_connections     1000;
daemon              off;
srs_log_tank        console;
vhost __defaultVhost__ {
    http_hooks {
        enabled on;
        on_publish http://127.0.0.1:8085/api/v1/snapshots;
        on_unpublish http://127.0.0.1:8085/api/v1/snapshots;
    }
    ingest {
        enabled on;
        input {
            type file;
            url ./doc/source.200kbps.768x320.flv;
        }
        ffmpeg ./objs/ffmpeg/bin/ffmpeg;
        engine {
            enabled off;
            output rtmp://127.0.0.1:[port]/live?vhost=[vhost]/livestream;
        }
    }
}
```

启动SRS时，ingest将会推流，SRS会调用Api服务器的接口，开始截图：
```
./objs/srs -c snapshot.conf
```

截图生成的目录：
```
winlin:srs winlin$ ls -lh research/api-server/static-dir/*.png
-rw-r--r--  1 winlin  staff    27K Oct 20 11:50 research/api-server/static-dir/live-livestream.png
```

可以通过HTTP访问，譬如： [http://localhost:8085/live-livestream.png](http://localhost:8085/live-livestream.png)

Winlin 2015.10