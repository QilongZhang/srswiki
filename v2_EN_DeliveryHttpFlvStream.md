# Delivery HTTP Flv Stream

## HTTP FLV VOD Stream

About the HTTP flv vod stream, read https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_FlvVodStream

## HTTP FLV Live Stream

SRS supports remux the rtmp stream to http flv stream, when publish rtmp stream on SRS, SRS will mount a http flv url and when user access the flv url, SRS will remux the rtmp stream to user.

## HTTP Mp3 Live Stream

SRS support remux the rtmp stream to http mp3 stream, drop video and mount mp3 http url, SRS will delivery mp3 stream when user access it.

## HTTP Aac Live Stream

SRS support remux the rtmp stream to http aac stream, drop video and mount aac http url, SRS will delivery aac stream when user access it.

## HTTP Live Stream Config

The config for HTTP Flv/Mp3/Aac Live Stream, use different extension to apply different stream:

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

Remark: Use forward+vhost to support multiple http live stream for a stream.

## Sample

The config sample, read https://github.com/winlinvip/simple-rtmp-server/issues/293#issuecomment-70449126

Winlin 2015.1