# Delivery HTTP Flv Stream

## HTTP FLV VOD Stream

关于HTTP flv 点播流，参考：https://github.com/winlinvip/simple-rtmp-server/wiki/v2_CN_FlvVodStream

## HTTP FLV Live Stream

SRS支持将RTMP流转封装为HTTP flv流，即在publish发布RTMP流时，在SRS的http模块中挂载一个对应的http地址（根据配置），用户在访问这个http flv文件时，从rtmp流转封装为flv分发给用户。

分发HTTP FLV直播流的配置如下：

```
http_server {
    enabled         on;
    listen          8080;
}
vhost your_vhost {
    http_remux {
        enabled     on;
        mount       [vhost]/[app]/[stream].flv;
    }
}
```

配置项的详细信息参考下面的[配置章节](https://github.com/winlinvip/simple-rtmp-server/wiki/v2_CN_DeliveryHttpStream#http-live-stream-config)的说明。

## HTTP TS Live Stream

SRS支持将RTMP流转封装为HTTP ts流，即在publish发布RTMP流时，在SRS的http模块中挂载一个对应的http地址（根据配置），用户在访问这个http ts文件时，从rtmp流转封装为ts分发给用户。

分发HTTP TS直播流的配置如下：

```
http_server {
    enabled         on;
    listen          8080;
}
vhost your_vhost {
    http_remux {
        enabled     on;
        mount       [vhost]/[app]/[stream].ts;
    }
}
```

配置项的详细信息参考下面的[配置章节](https://github.com/winlinvip/simple-rtmp-server/wiki/v2_CN_DeliveryHttpStream#http-live-stream-config)的说明。

## HTTP Mp3 Live Stream

SRS支持将rtmp流中的视频丢弃，将音频流转封装为mp3格式，在SRS的http模块中挂载对应的http地址（根据配置），用户在访问这个http mp3文件时，从rtmp转封装为mp3分发给用户。

分发HTTP mp3直播流的配置如下：

```
http_server {
    enabled         on;
    listen          8080;
}
vhost your_vhost {
    http_remux {
        enabled     on;
        fast_cache  30;
        mount       [vhost]/[app]/[stream].mp3;
    }
}
```

配置项的详细信息参考下面的[配置章节](https://github.com/winlinvip/simple-rtmp-server/wiki/v2_CN_DeliveryHttpStream#http-live-stream-config)的说明。

## HTTP Aac Live Stream

SRS支持将rtmp流中的视频丢弃，将音频流转封装为aac格式，在SRS的http模块中挂载对应的http地址（根据配置），用户在访问这个http aac文件时，从rtmp转封装为aac分发给用户。

分发HTTP aac直播流的配置如下：

```
http_server {
    enabled         on;
    listen          8080;
}
vhost your_vhost {
    http_remux {
        enabled     on;
        fast_cache  30;
        mount       [vhost]/[app]/[stream].aac;
    }
}
```

配置项的详细信息参考下面的[配置章节](https://github.com/winlinvip/simple-rtmp-server/wiki/v2_CN_DeliveryHttpStream#http-live-stream-config)的说明。

## HTTP Live Stream Config

HTTP Flv/Mp3/Aac Live Stream的配置如下，更改不同的扩展名即可以不同方式分发：

```
vhost your_vhost {
    # http flv/mp3/aac/ts stream vhost specified config
    http_remux {
        # whether enable the http live streaming service for vhost.
        # default: off
        enabled     on;
        # the fast cache for audio stream(mp3/aac),
        # to cache more audio and send to client in a time to make android(weixin) happy.
        # @remark the flv/ts stream ignore it
        # @remark 0 to disable fast cache for http audio stream.
        # default: 0
        fast_cache  30;
        # the stream mout for rtmp to remux to live streaming.
        # typical mount to [vhost]/[app]/[stream].flv
        # the variables:
        #       [vhost] current vhost for http live stream.
        #       [app] current app for http live stream.
        #       [stream] current stream for http live stream.
        # @remark the [vhost] is optional, used to mount at specified vhost.
        # the extension:
        #       .flv mount http live flv stream, use default gop cache.
        #       .ts mount http live ts stream, use default gop cache.
        #       .mp3 mount http live mp3 stream, ignore video and audio mp3 codec required.
        #       .aac mount http live aac stream, ignore video and audio aac codec required.
        # for example:
        #       mount to [vhost]/[app]/[stream].flv
        #           access by http://ossrs.net:8080/live/livestream.flv
        #       mount to /[app]/[stream].flv
        #           access by http://ossrs.net:8080/live/livestream.flv
        #           or by http://192.168.1.173:8080/live/livestream.flv
        #       mount to [vhost]/[app]/[stream].mp3
        #           access by http://ossrs.net:8080/live/livestream.mp3
        #       mount to [vhost]/[app]/[stream].aac
        #           access by http://ossrs.net:8080/live/livestream.aac
        #       mount to [vhost]/[app]/[stream].ts
        #           access by http://ossrs.net:8080/live/livestream.ts
        # @remark the port of http is specified by http_server section.
        # default: [vhost]/[app]/[stream].flv
        mount       [vhost]/[app]/[stream].flv;
        # whether http stream trigger rtmp stream source when no stream available,
        # for example, when encoder has not publish stream yet,
        # user can play the http flv stream and wait for stream.
        # default: on
        hstrs       on;
    }
}
```

备注：若需要同时分发不同的http live stream，可以使用forward到其他vhost，不同的vhost配置不同的http live stream。

备注：HTTP服务器配置，参考[HTTP Server](https://github.com/winlinvip/simple-rtmp-server/wiki/v2_EN_HTTPServer#config)

## HSTRS

HSTRS(http stream trigger rtmp source)由HTTP流触发的RTMP回源，该功能可以用于构建HTTP-FLV集群，即HTTP-FLV流的合并回源，以及HTTP-FLV在没有流时的等待standby。

HSTRS需要开启配置项`http_remux`的`hstrs`，默认是开启的。

详细信息参考：https://github.com/winlinvip/simple-rtmp-server/issues/324

## Sample

配置实例参考：https://github.com/winlinvip/simple-rtmp-server/issues/293#issuecomment-70449126

Winlin 2015.1