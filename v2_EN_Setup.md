[**HOME**](Home) > [**EN(1.0)**](v2_EN_Home) > [**Setup**](v2_EN_Setup)

下面的列表可以让你一步步了解SRS的各项功能：

1. [查看ossrs.net的公网服务器演示流](v1_EN_LiveShow)
1. [运行SRS的演示](v1_EN_SampleDemo)
1. [分发RTMP流](v1_EN_SampleRTMP)
1. [分发RTMP+HLS流](v1_EN_SampleHLS)
1. [转码后分发HLS流](v1_EN_SampleTranscode2HLS)
1. [使用FFMPEG转码](v1_EN_SampleFFMPEG)
1. [使用Ingest拉流到服务器](v1_EN_SampleIngest)
1. [转发流到其他服务器](v1_EN_SampleForward)
1. [最低延迟模式分发实时流](v1_EN_SampleRealtime)
1. [在ARM上运行SRS](v1_EN_SampleARM)
1. [使用SRS内嵌的HTTP服务器](v1_EN_SampleHTTP)

不知道SRS的版本规划，功能列表，目前的进度，定位，联系方式？性能报告？Raspberrypi性能？请读[Contact](v1_EN_Contact)、[Product](v1_EN_Product)、[Compare](v1_EN_Compare)、[Features](v1_EN_Features)、[Performance](v1_EN_Performance)、[RaspberrypiPerf](v1_EN_RaspberryPi)

如何编译SRS？开启和关闭某些功能？如何在ARM下编译？交叉编译？使用多个CPU编译SRS？如何编译SRS时编译FFMPEG和NGINX？如何打包？如何启动SRS？如何以服务启动？SRS日志格式是什么？HTTP管理接口有哪些？请读[Build](v1_EN_Build)、[Service](v1_EN_LinuxService)、[Log](v1_EN_SrsLog)、[HttpApi](v1_EN_HTTPApi)

不知道vhost(域名、频道)、app(挂载点)、stream(流名称)是什么意思？GOP是什么意思？如何降低延迟？什么是RTMP的复杂握手？请读[RTMP URL](v1_EN_RtmpUrlVhost)、[Realtime](v1_EN_LowLatency)、[Handshake](v1_EN_RTMPHandshake)

到底使用RTMP还是HLS？甚至是HDS？这些分发方式到底有啥区别？HTTP-FLV又是什么？HTTP-FLV和RTMP的区别在哪里？请读[RTMP](v1_EN_DeliveryRTMP)、[HLS](v1_EN_DeliveryHLS)、[RTMP PK HLS](v1_EN_RTMP.PK.HTTP)、[HDS](v2_EN_DeliveryHDS)、[HTTP Stream](v2_EN_DeliveryHttpStream)

如何搭建RTMP集群？如何支持全国各地的观众观看？如何跨网分发流？如何预推流到边缘？CDN的RTMP集群如何使用SRS搭建？如何构建自己的RTMP直播分发CDN？Forward和Edge的区别是什么？为何优先使用Edge而不是Forward？什么是HSTRS？SRS是否支持HTTP-FLV的合并回源？如何搭建HTTP-FLV集群？如何支持绝对时间？如何做主备？请读[Forward](v1_EN_Forward)、[Edge](v1_EN_Edge)、[HTTP Stream](v2_EN_DeliveryHttpStream)、[ATC](v1_EN_RTMP-ATC)

SRS的架构是什么？如何设置http回调？SRS为何不支持服务器端脚本？SRS如何矫正时间戳？RTMP的时间戳单增是什么意思？如何让SRS主动汇报信息到你的服务器？请读[Arch](v1_EN_Architecture)、[Callback](v1_EN_HTTPCallback)、[Script](v1_EN_ServerSideScript)、[Jitter](v1_EN_TimeJitter)、[Heartbeat](v1_EN_Heartbeat)

SRS支持哪些IDE？如何使用GIT？如何切换分支？如何切换到开发版？如何切换到其他release分支？如何提交pull request？如何和SRS保持同步？如何分析SRS的性能瓶颈？请读[IDE](v1_EN_IDE)、[Git](v1_EN_Git)、[Perf](v1_EN_Performance)、[GProf](v1_EN_GPROF)、[GPerf](v1_EN_GPERF)

如何做认证？如何支持Referer防盗链？如何支持RTMP token穿越？请读[Callback](v1_EN_HTTPCallback)、[DRM](v1_EN_DRM)

如何支持录制？如何按时间段录制？如何按照推流和结束推流录制？如何定制DVR的路径？如何设置DVR的HTTP回调？请读[DVR](v1_EN_DVR)

如何分析SRS日志？流卡顿如何分析？如何不重启服务器应用新配置？如何做带宽测试排错？如何知道客户端连接的服务器IP？如何知道客户端在服务器的id？请读[Reload](v1_EN_Reload)、[Log](v1_EN_SrsLog)、[SrsLibrtmp](v1_EN_SrsLibrtmp)、[Bandwidth](v1_EN_BandwidthTestTool)

如果没有找到你的答案，请在QQ群、微信或邮件[联系我们](v1_EN_Contact)，请先阅读[如何提问](v1_EN_HowToAskQuestion)

Winlin 2015.3