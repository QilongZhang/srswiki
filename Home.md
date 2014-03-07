Welcome to the simple-rtmp-server wiki!

## [如何提问](https://github.com/winlinvip/simple-rtmp-server/wiki/HowToAskQuestion)

提问是一门艺术，不是别人不待见你，是你提的问题实在不招人待见。提问前务必参考：[如何提问](https://github.com/winlinvip/simple-rtmp-server/wiki/HowToAskQuestion)

## [SRS产品定位] (https://github.com/winlinvip/simple-rtmp-server/wiki/Product)

SRS产品定位是什么？SRS亮点是什么？和其他产品对比呢？参考：[SRS产品定位] (https://github.com/winlinvip/simple-rtmp-server/wiki/Product)

## [应用实例](https://github.com/winlinvip/simple-rtmp-server/wiki/Sample)

SRS的实际应用，可以用SRS实际做点什么？参考：[应用实例](https://github.com/winlinvip/simple-rtmp-server/wiki/Sample)

## [编译SRS](https://github.com/winlinvip/simple-rtmp-server/wiki/Build)

编译SRS的常见选项，SRS的功能，以及应用场景，编译和启动，DEMO的查看方法。链接：[编译SRS](https://github.com/winlinvip/simple-rtmp-server/wiki/Build)

## [SRS的架构](https://github.com/winlinvip/simple-rtmp-server/wiki/Architecture)

SRS开发者必看的基础wiki，SRS的基础架构。链接：[SRS的架构](https://github.com/winlinvip/simple-rtmp-server/wiki/Architecture)

## [RTMP URL & Vhost](https://github.com/winlinvip/simple-rtmp-server/wiki/RtmpUrlVhost)

搞不清楚RTMP的那些个vhost/app/stream？特别还有参数的时候？参考链接：[RTMP URL & Vhost](https://github.com/winlinvip/simple-rtmp-server/wiki/RtmpUrlVhost)

## [RTMP握手协议](https://github.com/winlinvip/simple-rtmp-server/wiki/RTMPHandshake)

RTMP为何要依赖ssl？什么是RTMP简单握手和复杂握手？什么时候用Simple就足够了？参考：[RTMP握手协议](https://github.com/winlinvip/simple-rtmp-server/wiki/RTMPHandshake)

## [FFMPEG直播流转码](https://github.com/winlinvip/simple-rtmp-server/wiki/FFMPEG)

如何使用SRS对直播流转码？如何只对视频或音频转码？如何配置台标？转码参数的意义和顺序？参考：[FFMPEG直播流转码](https://github.com/winlinvip/simple-rtmp-server/wiki/FFMPEG)

## [Delivery HLS](https://github.com/winlinvip/simple-rtmp-server/wiki/DeliveryHLS)

如何将RTMP流切片成HLS分发？HLS相关知识，SRS配置HLS？参考链接：[Delivery HLS](https://github.com/winlinvip/simple-rtmp-server/wiki/DeliveryHLS)

## [Reload](https://github.com/winlinvip/simple-rtmp-server/wiki/Reload)

如何在不影响正在服务的用户的前提下：将一个转码流的码率调低？如何禁用某些频道的HLS？如何添加和删除频道？参考：[Reload](https://github.com/winlinvip/simple-rtmp-server/wiki/Reload)

## [低延时应用](https://github.com/winlinvip/simple-rtmp-server/wiki/LowLatency)

如何配置低延时？延时到底受哪些因素的影响？SRS如何配置？SRS延迟多大？参考：[低延时应用](https://github.com/winlinvip/simple-rtmp-server/wiki/LowLatency)

## [HTTP回调](https://github.com/winlinvip/simple-rtmp-server/wiki/HTTPCallback)

如何认证客户端连接？如何在发布流时通知外部程序？如何在客户端连接和关闭时加入额外处理逻辑？SRS在各种事件时可以回调HTTP接口。参考：[HTTP回调](https://github.com/winlinvip/simple-rtmp-server/wiki/HTTPCallback)

## [搭建小型集群](https://github.com/winlinvip/simple-rtmp-server/wiki/Cluster)

使用forward搭建小型集群的配置方法。链接：[搭建小型集群](https://github.com/winlinvip/simple-rtmp-server/wiki/Cluster)

## [性能测试和对比](https://github.com/winlinvip/simple-rtmp-server/wiki/Performance)

对比了SRS和高性能服务器nginx-rtmp，提供详细的测试步骤，供其他性能对比进行参考。链接：[性能测试和对比](https://github.com/winlinvip/simple-rtmp-server/wiki/Performance)

## [服务器端脚本](https://github.com/winlinvip/simple-rtmp-server/wiki/ServerSideScript)

SRS为何不支持服务器端脚本？链接：[服务器端脚本](https://github.com/winlinvip/simple-rtmp-server/wiki/ServerSideScript)

## [SRS-librtmp](https://github.com/winlinvip/simple-rtmp-server/wiki/SrsLibrtmp)

如何使用SRS提供的客户端rtmp库？为何要提供？结构是什么？主要流程是什么？实例如何使用？参考：[SRS-librtmp](https://github.com/winlinvip/simple-rtmp-server/wiki/SrsLibrtmp)

## [SRS应用于linux-arm](https://github.com/winlinvip/simple-rtmp-server/wiki/SrsLinuxArm)

linux-arm设备如何使用SRS分发RTMP流？linux-arm上SRS的性能如何？参考：[SRS应用于linux-arm](https://github.com/winlinvip/simple-rtmp-server/wiki/SrsLinuxArm)

## [GPERF内存和性能分析](https://github.com/winlinvip/simple-rtmp-server/wiki/GPERF)

如何查找内存泄漏？valgrind不支持st怎么办？如何知道哪个函数占用内存多？哪个函数性能有问题？参考：[GPERF内存和性能分析](https://github.com/winlinvip/simple-rtmp-server/wiki/GPERF)

## [GPROF性能分析](https://github.com/winlinvip/simple-rtmp-server/wiki/GPROF)

如何对SRS做性能优化？如何用gprof分析SRS性能？如何看性能的函数调用图？参考：[GPROF性能分析](https://github.com/winlinvip/simple-rtmp-server/wiki/GPROF)

## [C++的开发环境](https://github.com/winlinvip/simple-rtmp-server/wiki/IDE)

C++如何选择开发环境？建议UltimateC++，当然等[jetbrains](http://www.jetbrains.com/idea/)出Windows下C++的IDE了会更好。参考：[C++的开发环境](https://github.com/winlinvip/simple-rtmp-server/wiki/IDE)

Winlin 2014.2