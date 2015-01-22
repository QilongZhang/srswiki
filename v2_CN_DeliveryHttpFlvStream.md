# Delivery HTTP Flv Stream

## HTTP FLV VOD Stream

关于HTTP flv 点播流，参考：https://github.com/winlinvip/simple-rtmp-server/wiki/v2_CN_FlvVodStream

## HTTP FLV Live Stream

SRS支持将RTMP流转封装为HTTP flv流，即在publish发布RTMP流时，在SRS的http模块中挂载一个对应的http地址（根据配置），用户在访问这个http flv文件时，从rtmp流转封装为flv分发给用户。

## HTTP Mp3 Live Stream

SRS支持将rtmp流中的视频丢弃，将音频流转封装为mp3格式，在SRS的http模块中挂载对应的http地址（根据配置），用户在访问这个http mp3文件时，从rtmp转封装为mp3分发给用户。

## HTTP Aac Live Stream

SRS支持将rtmp流中的视频丢弃，将音频流转封装为aac格式，在SRS的http模块中挂载对应的http地址（根据配置），用户在访问这个http aac文件时，从rtmp转封装为aac分发给用户。

## HTTP Live Stream Config

HTTP Flv/Mp3/Aac Live Stream的配置如下，更改不同的扩展名即可以不同方式分发：

```
    # http flv/mp3/aac stream vhost specified config
    http_flv {
        # whether enable the http flv live streaming service for vhost.
        # default: off
        enabled     on;
        # the fast cache for audio stream(mp3/aac),
        # to cache more audio and send to client in a time to make android(weixin) happy.
        # @remark the flv stream ignore it
        # default: 30
        fast_cache  30;
        # the stream mout for rtmp to remux to flv live streaming.
        # typical mount to [vhost]/[app]/[stream].flv
        # the variables:
        #       [vhost] current vhost for http flv live stream.
        #       [app] current app for http flv live stream.
        #       [stream] current stream for http flv live stream.
        # @remark the [vhost] is optional, used to mount at specified vhost.
        # the extension:
        #       .flv mount http live flv stream, use default gop cache.
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
        # @remark the port of http is specified by http_stream section.
        # default: [vhost]/[app]/[stream].flv
        mount       [vhost]/[app]/[stream].flv;
    }
```

备注：若需要同时分发不同的http live stream，可以使用forward到其他vhost，不同的vhost配置不同的http live stream。

备注：HTTP服务器配置，参考[HTTP Server](https://github.com/winlinvip/simple-rtmp-server/wiki/v2_EN_HTTPServer#config)

## Sample

配置实例参考：https://github.com/winlinvip/simple-rtmp-server/issues/293#issuecomment-70449126

Winlin 2015.1