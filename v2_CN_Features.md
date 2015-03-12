# 功能列表

SRS支持的功能，包括已经支持的，计划中的，和没有计划的，参考[SRS: Summary](https://github.com/winlinvip/simple-rtmp-server/tree/release2.0#summary)

2014.4.24

srs直播终于做完整了，支持rtmp，支持hls，内嵌http服务器，业务层面支持转发/录制/采集三大棒，还有测速和vhost。作为流服务器，真的差不多了。据说某cdn用srs支持了hds，不错！

还有，忘记了，支持x86和x64服务器，支持arm譬如安卓和树苺派，支持http接口，支持reload这个超级有用，日志支持会话级别。我所在的公司成功用srs对接flashp2p系统，超赞！

我去，还是忘记了，还有直播流转码呀，wowza要钱的功能。据说这个某cdn还实现了边缘。我去，这个意味着这个cdn的流媒体系统很强悍。最后，集群延迟在0.8-3秒。自己赞一下，哈哈。

参考：https://github.com/winlinvip/simple-rtmp-server/wiki/v1_CN_Product#release10

2015.3.12

SRS2的大功能终于做完了。所有wiki都翻译成了英文，性能从3k时代提升到10k时代，延迟最低到0.1s，重写了内置的http服务器，重写了HLS符合m3u8/ts标准，支持内存HLS，支持分发HTTP流(flv/ts/mp3/aac)，支持分发HDS，增强了DVR支持callback，srs-librtmp支持发送h.264/aac裸码流，支持stream caster(实验性)(push RTSP/MPEGTS to SRS)。

参考：https://github.com/winlinvip/simple-rtmp-server/wiki/v1_CN_Product#release20

Winlin 2015.3