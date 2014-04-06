# 采集

采集(Ingest)指的是将文件（flv，mp4，mkv，avi，rmvb等等），流（RTMP，RTMPT，RTMPS，RTSP，HTTP，HLS等等），设备等的数据，转封装为RTMP流（若编码不是h264/aac则需要转码），推送到SRS。

采集基本上就是使用FFMPEG作为编码器，或者转封装器，将外部流主动抓取到SRS。

Winlin 2014.4