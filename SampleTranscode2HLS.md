# 转码后分发HLS部署实例

HLS需要h.264+aac，若符合这个要求可以按照[Usage: HLS](https://github.com/winlinvip/simple-rtmp-server/wiki/SampleHLS)部署，若不符合这个要求则需要转码。

如何知道流是否是h264+aac编码：
* [Usage: HLS](https://github.com/winlinvip/simple-rtmp-server/wiki/SampleHLS)中的`Q&A`说明的问题。
* 看编码器的参数，FMLE可以选视频编码为vp6或者h264，音频一般为mp3/NellyMoser。，所以FMLE肯定推流是不符合要求的。
* 看SRS的日志，若显示`hls only support video h.264/avc codec. ret=601`，就明显说明是编码问题。

Winlin 2014.3