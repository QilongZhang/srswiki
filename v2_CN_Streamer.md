# Streamer

Streamer是SRS作为服务器侦听并接收其他协议的流（譬如RTSP，MPEG-TS over UDP等等），将这些协议的流转换成RTMP推送给自己，以使用RTMP/HLS/HTTP分发流。

## Use Scenario

常见的应用场景包括：

* Push MPEG-TS over UDP to SRS：通过UDP协议，将MPEG-TS推送到SRS，分发为RTMP/HLS/HTTP流。
* Push RTSP to SRS：通过RTSP协议，将流推送到SRS，分发为RTMP/HLS/HTTP流。
* POST FLV over HTTP to SRS: 通过HTTP协议，将FLV流POST到SRS，分发为RTMP/HLS/HTTP流。

备注：Streamer将其他支持的协议推送RTMP给SRS后，所有SRS的功能都能支持。譬如，推RTSP流给Streamer，Streamer转成RTMP推送给SRS，若vhost是edge，SRS将RTMP流转发给源站。或者将RTMP流转码，或者直接转发。另外，所有分发方法都是可用的，譬如推RTSP流给Streamer，Streamer转成RTMP推给SRS，以RTMP/HLS/HTTP分发。

## Build

编译SRS时打开StreamCaster支持，参考[Build](https://github.com/winlinvip/simple-rtmp-server/wiki/v2_CN_Build)：

```
./configure --with-stream-caster
```

## Protocols

目前Streamer支持的协议包括：

* MPEG-TS over UDP：已支持，可使用FFMPEG或其他编码器`push MPEG-TS over UDP`到SRS上。
* Push RTSP to SRS：已支持，可以使用FFMPEG或其他编码器`push rtsp to SRS`。
* POST FLV over HTTP to SRS: 规划中。

## Push MPEG-TS over UDP

SRS可以侦听一个udp端口，编码器将流推送到这个udp端口（SPTS）后，SRS会转成一路RTMP流。后面RTMP流能支持的功能都支持。

配置如下，参考`conf/push.mpegts.over.udp.conf`：

```
# the streamer cast stream from other protocol to SRS over RTMP.
# @see https://github.com/winlinvip/simple-rtmp-server/tree/develop#stream-architecture
stream_caster {
    # whether stream caster is enabled.
    # default: off
    enabled         on;
    # the caster type of stream, the casters:
    #       mpegts_over_udp, MPEG-TS over UDP caster.
    caster          mpegts_over_udp;
    # the output rtmp url.
    # for example, rtmp://127.0.0.1/live/livestream.
    output          rtmp://127.0.0.1/live/livestream;
    # the listen port for stream caster.
    # for caster:
    #       mpegts_over_udp, listen at udp port.
    listen          1935;
}
```

参考：https://github.com/winlinvip/simple-rtmp-server/issues/250#issuecomment-72321769

# Push RTSP to SRS

SRS可以侦听一个tcp端口，编码器将流推送到这个tcp端口（RTSP）后，SRS会转成一路RTMP流。后面RTMP流能支持的功能都支持。

配置如下，参考`conf/push.rtsp.conf`：

```
# the streamer cast stream from other protocol to SRS over RTMP.
# @see https://github.com/winlinvip/simple-rtmp-server/tree/develop#stream-architecture
stream_caster {
    # whether stream caster is enabled.
    # default: off
    enabled         off;
    # the caster type of stream, the casters:
    #       rtsp, Real Time Streaming Protocol (RTSP).
    caster          rtsp;
    # the output rtmp url.
    # for rtsp caster, the typically output url:
    #       rtmp://127.0.0.1/[app]/[stream]
    #       for example, the rtsp url:
    #           rtsp://192.168.1.173:8544/live/livestream.sdp
    #           where the [app] is "live" and [stream] is "livestream", output is:
    #           rtmp://127.0.0.1/live/livestream
    output          rtmp://127.0.0.1/live/livestream;
    # the listen port for stream caster.
    #       for rtsp caster, listen at tcp port. for example, 554.
    listen          554;
    # for the rtsp caster, the rtp server local port over udp,
    # which reply the rtsp setup request message, the port will be used:
    #       [rtp_port_min, rtp_port_max)
    rtp_port_min    57200;
    rtp_port_max    57300;
}
```

参考：https://github.com/winlinvip/simple-rtmp-server/issues/133#issuecomment-75531884

2015.1