# Delivery RTMP

The kernel feature of SRS is RTMP.

The RTMP and HLS, see: [HLS](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_DeliveryHLS)

Compoare the RTMP and HLS, see: [RTMP PK HLS](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_RTMP.PK.HTTP)

How to deploy SRS to support RTMP: [Usage: RTMP](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_SampleRTMP)

## Use Scenario

RTMP the first supported video stream for flash, and the best realtime stream on PC flash:
* No plugin: The flash plugin already installed on almost all PC, no need other plugin to play the RTMP stream.
* Fast develop player: Only need 7lines to play a RTMP stream for flash. It is very complex to play the HLS or HDS on PC flash.
* Industrial-strength: RTMP server and flash player is very stable for RTMP.
* Realtime Stream for internet: RTMP latency in 0.8-3s, can be used in live show or meeting.
* The actual standard for encoder output for internet: RTMP is the actual standard protocol, for all encoder to publish stream to internet server, server will mux the RTMP to HLS, HDS or DASH.

SRS live streaming use RTMP as kernel protocol.

SRS vod streaming is in plan and use HTTP protocol.

## FlashRTMP

RTMP is the acient and the first video streaming protocol supported by flash, which is MacroMedia flash player, then rename to Adobe Flash player. Few lines code to play the RTMP stream:

```bash
var conn = new NetConnection();
var stream = new NetStream(conn);
var video = new Video();
this.addChild(video);
video.attachNetStream(stream);
conn.connect("rtmp://192.168.1.170/live");
stream.play("livestream");
```

## Config RTMP stream

Config SRS to support RTMP:

```bash
listen              1935;
max_connections     1000;
vhost __defaultVhost__ {
}
```

Start server: `./objs/srs -c conf/rtmp.conf`

## 推送RTMP流

可以使用支持RTMP输出的编码器，譬如FMLE。在FMS URL中输入vhost/app，在Stream中输入流名称。譬如：

```bash
# 譬如RTMP流：rtmp://192.168.1.170/live/livestream
FMS URL: rtmp://192.168.1.170/live
Stream: livestream
```

RTMP的URL规则，Vhost规则，参考：[RTMP URL&Vhost](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_RtmpUrlVhost)

部署分发RTMP流的实例，参考：[Usage: RTMP](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_SampleRTMP)

如下图所示：
![FMLE推流到SRS](http://winlinvip.github.io/srs.release/wiki/images/FMLE.png)

## 观看RTMP流

可以使用支持RTMP流的播放器播放，譬如vlc/flash player，播放地址：`rtmp://192.168.1.170/live/livestream`

srs提供flash的播放器和编码器，支持在线播放RTMP/HLS流，参考：[srs](http://winlinvip.github.io/simple-rtmp-server)

## RTMP流的低延时配置

RTMP流的延时在1-3秒，比HLS的延时更靠谱，低延时的配置参考：[低延时](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_LowLatency)

Winlin 2014.11