# Streamer

Streamer是SRS作为服务器侦听并接收其他协议的流（譬如RTSP，MPEG-TS over UDP等等），将这些协议的流转换成RTMP推送给自己，以使用RTMP/HLS/HTTP分发流。

## Use Scenario

常见的应用场景包括：

* Push MPEG-TS over UDP to SRS：通过UDP协议，将MPEG-TS推送到SRS，分发为RTMP/HLS/HTTP流。
* Push RTSP to SRS：通过RTSP协议，将流推送到SRS，分发为RTMP/HLS/HTTP流。

备注：Streamer将其他支持的协议推送RTMP给SRS后，所有SRS的功能都能支持。譬如，推RTSP流给Streamer，Streamer转成RTMP推送给SRS，若vhost是edge，SRS将RTMP流转发给源站。或者将RTMP流转码，或者直接转发。另外，所有分发方法都是可用的，譬如推RTSP流给Streamer，Streamer转成RTMP推给SRS，以RTMP/HLS/HTTP分发。

## Protocols

目前Streamer支持的协议包括：

* MPEG-TS over UDP：开发中。

2015.1