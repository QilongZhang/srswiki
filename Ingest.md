# 采集

采集(Ingest)指的是将文件（flv，mp4，mkv，avi，rmvb等等），流（RTMP，RTMPT，RTMPS，RTSP，HTTP，HLS等等），设备等的数据，转封装为RTMP流（若编码不是h264/aac则需要转码），推送到SRS。

采集基本上就是使用FFMPEG作为编码器，或者转封装器，将外部流主动抓取到SRS。

## 应用场景

采集的主要应用场景包括：
* 虚拟直播：将文件编码为直播流。可以指定多个文件后，SRS会循环播放。
* RTSP摄像头对接：以前安防摄像头都支持访问RTSP地址，RTSP无法在互联网播放。可以将RTSP采集后，以RTMP推送到SRS，后面的东西就不用讲了。
* 直接采集设备：SRS采集功能可以作为编码器采集设备上的未压缩图像数据，譬如video4linux和alsa设备，编码为h264/aac后输出RTMP到SRS。
* 将HTTP流采集为RTMP：有些老的设备，能输出HTTP的ts或FLV流，可以采集后转封装为RTMP，支持HLS输出。

总之，采集的应用场景主要是“SRS拉流”；能拉任意的流，只要ffmpeg支持；不是h264/aac都没有关系，ffmpeg能转码。

SRS默认是支持“推流”，即等待编码器推流上来，可以是专门的编码设备，FMLE，ffmpeg，xsplit，flash等等。

如此，SRS的接入方式可以是“推流到SRS”和“SRS主动拉流”，基本上作为源站的功能就完善了。

Winlin 2014.4