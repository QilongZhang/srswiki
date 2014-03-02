# SRS产品规划

SRS虽然是开源项目，但是窃以为，任何软件产品还是要有规划，没有定位，就不知道不做什么，不知道不做什么就不知道做什么，不知道做什么就做不好。

SRS的核心目标是做流媒体服务器核心，不做流媒体方案，以最简方式满足用户需求：
* 方案就是端到端，从视频源到流媒体服务器，到边缘服务器，到客户端播放器，都需要做开发。
* SRS只做直播，因为点播一般是http，而且基本上都是方案，需要播放器和api服务器交互。譬如，若点播走HLS方案，则直接使用nginx或squid就可以做分发，不是SRS的菜。
* 直播流的接入部分，SRS提供[srs-librtmp](https://github.com/winlinvip/simple-rtmp-server/wiki/SrsLibrtmp)，可以推送RTMP流到RTMP服务器。SRS的接入是标准的RTMP，一般不做其他的接入方式（要做也是将其他流转换成RTMP）。
* 录制和时移：直播流转点播文件，需要播放器做支持（从api服务器拿到播放列表），所以SRS不会做。不过RTMP写入文件，属于流媒体服务器的范畴，SRS可以考虑。
* 直播HLS流：IOS的直播一般是[HLS](https://github.com/winlinvip/simple-rtmp-server/wiki/DeliveryHLS)，而HLS实际上也是方案（客户端一般是apple做了），SRS也只是将RTMP流写入ts文件，生成m3u8列表。SRS不会做分发。
* 直播DASH流：和HLS类似，SRS也只是生成文件不分发。不过目前国内市场没有反应，SRS不会做的。
* 直播HDS流：和HLS类似，但是HDS国内没有市场，而且HDS协议比较繁琐，不够简洁，SRS不建议做。
* 直播RTMP边缘：一般作为CDN会有需求，源站和边缘走RTMP能较好支持热备，延迟也没有影响，属于流服务器的范畴。SRS有开发计划。
* DRM：DRM属于方案，有些简单的DRM（譬如Refer防盗链）SRS做了支持，其他需要对接的方案，SRS也提供HTTP callback，需要额外的自定义开发才能支持。
* 直播RTMP加密：属于服务器范畴，主要市场没有反应，有需要SRS可以考虑支持。
* 直播RTMP流转码：转码属于方案，但使用[FFMPEG转码](https://github.com/winlinvip/simple-rtmp-server/wiki/FFMPEG)（实现比较简单）SRS做了支持，可以使用HTTP callback对接商业编码器，实现较好的直播RTMP转码。
* 直播RTMP转发：SRS可以将流转发给其他RTMP服务器，作为备份，和边缘热备一样属于服务器的范畴。SRS已经支持，并可以支持基于[Forward](https://github.com/winlinvip/simple-rtmp-server/wiki/Cluster)的简单集群。
* 最小依赖：SRS的核心RTMP只依赖于st，srs-librtmp不依赖于其他软件，支持复杂握手依赖于ssl。SRS最小只有1.8MB，strip后只有504KB。加上ssl后只有2.9MB，strip后只有1.5MB。
* 应用广泛：由于SRS的最小依赖，可以运行在Centos4/5/6系统，linux各种发行版。srs-librtmp只用到了c/c++标准库（复杂握手需要加上ssl，一般不需要）。
* Reload：SRS可应用于365x24小时不间断服务，修改配置文件后[Reloadd](https://github.com/winlinvip/simple-rtmp-server/wiki/Reload)即可生效，现有客户端连接不受影响。那就是说，改变ffmpeg编码参数，客户端不会断开连接，就可以看到效果。
* 低延时：SRS由于逻辑简单，依赖的st库也性能极高（和直接用epoll没有差异），SRS能做到[延迟最低](https://github.com/winlinvip/simple-rtmp-server/wiki/LowLatency)（RTMP最低延迟基本上在0.8秒以上），高性能才能低延迟。
* HTTP回调：SRS提供各种事件的回调函数([HttpCallback](https://github.com/winlinvip/simple-rtmp-server/wiki/HTTPCallback))，方便和外部系统对接。为了简洁，SRS不会支持lua或者as等[服务器端脚本](https://github.com/winlinvip/simple-rtmp-server/wiki/ServerSideScript)语言。
* CLI：SRS提供cli，基于socket，能远程管理SRS，提供各种控制接口。

各项功能的研发计划，参考SRS首页：[SRS功能](https://github.com/winlinvip/simple-rtmp-server#summary)

Winlin