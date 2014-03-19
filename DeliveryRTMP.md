# 分发RTMP流

SRS（Simple RTMP Server）分发RTMP是核心功能，srs的主要定位就是分发RTMP低延时流媒体，同时支持分发HLS流。

RTMP和HLS的优势参考：[HLS](https://github.com/winlinvip/simple-rtmp-server/wiki/DeliveryHLS)

## 配置RTMP流

SRS只需要配置vhost和侦听端口就可以支持RTMP（vhost内容参考[vhost](https://github.com/winlinvip/simple-rtmp-server/wiki/RtmpUrlVhost)）：

```bash
listen              1935;
vhost __defaultVhost__ {
}
```

启动服务器：`./objs/srs -c conf/rtmp.conf`

## 推送RTMP流

可以使用支持RTMP输出的编码器，譬如FMLE。在FMS URL中输入vhost/app，在Stream中输入流名称。譬如：

```bash
# 譬如RTMP流：rtmp://192.168.1.170/live/livestream
FMS URL: rtmp://192.168.1.170/live
Stream: livestream
```

RTMP的URL规则，Vhost规则，参考：[RTMP URL&Vhost](https://github.com/winlinvip/simple-rtmp-server/wiki/RtmpUrlVhost)

部署分发RTMP流的实例，参考：[Usage: RTMP](https://github.com/winlinvip/simple-rtmp-server/wiki/SampleRTMP)

如下图所示：
![FMLE推流到SRS](https://raw.github.com/winlinvip/simple-rtmp-server/master/trunk/doc/wiki/FMLE.png)

## 观看RTMP流

可以使用支持RTMP流的播放器播放，譬如vlc/flash player，播放地址：`rtmp://192.168.1.170/live/livestream`

srs提供flash的播放器和编码器，支持在线播放RTMP/HLS流，参考：[srs](http://winlinvip.github.io/simple-rtmp-server)

## RTMP流的低延时配置

RTMP流的延时在1-3秒，比HLS的延时更靠谱，低延时的配置参考：[低延时](https://github.com/winlinvip/simple-rtmp-server/wiki/LowLatency)

Winlin