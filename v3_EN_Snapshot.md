# Snapshot

SRS provides workaround for snapshots:

1. HttpCallback: Use http callbacks to handle `on_publish` event to snapshot by FFMPEG, and to stop FFMPEG when got `on_unpublish` event.
1. Transcoder: Use transcoder to snapshot.

## HttpCallback

This section describes how to use http callbacks to snapshot.

First, start the sample api server:
```
python research/api-server/server.py 8085
```

Second, write the config for SRS to snapshot:
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

Thrird, start SRS and the ingest will publish RTMP stream, which will trigger the `on_publish` event, then api will snapshot:
```
./objs/srs -c snapshot.conf
```

The snapshot generate thumbnails to directory:
```
winlin:srs winlin$ ls -lh research/api-server/static-dir/live/*.png
-rw-r--r--  1 winlin  staff   268K Oct 20 13:30 livestream-001.png
-rw-r--r--  1 winlin  staff   237K Oct 20 13:30 livestream-002.png
-rw-r--r--  1 winlin  staff    42K Oct 20 13:30 livestream-003.png
lrwxr-xr-x  1 winlin  staff   105B Oct 20 13:30 livestream-best.png -> livestream-002.png
```

The thumbnail `live-livestream-best.png` will link to the big one to avoid blank image.

User can access it by http server: [http://localhost:8085/live/livestream-best.png](http://localhost:8085/live/livestream-best.png)

Winlin 2015.10