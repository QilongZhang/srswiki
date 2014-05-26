# 产品对比

对比几个知名的商业流媒体服务器，知名的开源流媒体服务器，以星级评定。难免有主观因素，以及不熟悉该产品的因素，有异议可以在群里面告知。

SRS聚焦在某些方面，这些都是由[产品定位](https://github.com/winlinvip/simple-rtmp-server/wiki/Product)决定的，有所不为才能有所为。

SRS优势的基础在于基础架构，采用ST轻量线程，SRS和其他流媒体系统的根本区别（类似于GO）就是轻量线程，参考[SRS架构](https://github.com/winlinvip/simple-rtmp-server/wiki/Architecture)。

详细的功能列表，以及研发计划，参考：[产品功能列表](https://github.com/winlinvip/simple-rtmp-server/wiki/Features)

## 术语表

下面对比用到的术语：
* RTMPS/E/T：RTMPS/E是加密协议，RTMPT是HTTP穿墙协议
* DASH：各路诸侯对抗Apple的HLS提出的类似协议
* 转换Vhost：上行publish加速往往使用特殊设备和域名，需要转换vhost为下行域名，在CDN/VDN中常用
* 配置友好：FMS/Helix/Wowza的配置是XML时代产物，不是给人看的，极其不友好。Nginx配置是当代产物，简单明了易读。
* 启动脚本：以linux服务启动的脚本，譬如init.d下面的脚本
* 源站配套系统：其他辅助系统，譬如VMS、转码、编码、收录、P2P等等。
* 扩展脚本语言：FMS有AS，crtmpd/nginx有lua，扩展语言难以调试，代码量较多时问题频繁发生，不觉得是个好东西
* 单线程：单线程能支持10K级别并发，往往采用非阻塞异步机制
* 轻量线程：轻量线程架构能使用“类同步”（本质异步）结构简化逻辑
* 代码维护性：代码量，有效注释，注释百分比，逻辑复杂性，业务复杂性

## History

国家没有历史就没有文化，产品没有历史就没有品牌。开源软件也需要历史，只有不断更新和完善的产品才是好产品，尤其是资源紧缺的开源产品。

![Media Stream Servers History](http://winlinvip.github.io/srs.release/wiki/images/compare/100.release.png)

## Protocol

协议是服务器的基础，协议决定了关键应用场景，譬如毫秒级别延时只能用udp，秒级别延迟用RTMP，十秒级别可以用HLS。

可惜技术并不能十全十美，RTMP在PC上支持完善是因为adobe的flash支持得好，HLS在IOS上完善是因为apple支持得好，不代表RTMP协议就简单。

所以什么协议都支持的服务器往往失去了重要的方向和定位，互联网上最重要的莫过于HTTP，即HLS协议，因此目前HLS大行其道。而实际PC平台浏览器中的的重要协议，是RTMP。

![Media Stream Servers Protocol](http://winlinvip.github.io/srs.release/wiki/images/compare/200.protocol.png)

## Feature

流媒体不仅仅是能播放就可以，特别对于流媒体业务运营。配置几个参数就能转码，和写复杂的FFMPEG参数完全不一样，技术上容易1倍，到最终用户使用时会方便千百倍。

![Media Stream Servers Feature](http://winlinvip.github.io/srs.release/wiki/images/compare/300.feature.png)

## Deploy

部署不重要么？如果你有老旧的机器，运行着老系统，就不会那么认为了，不是所有系统都能更新到CENTOS6的，程序员往往喜欢写不能碰的软件，特别是系统，特别是早期的程序员。如果加上现在广泛应用的ARM呢？能在ARM上运行，不仅仅是很酷吧!

![Media Stream Servers Deploy](http://winlinvip.github.io/srs.release/wiki/images/compare/400.deploy.png)

## Arch

体系结构其实是时代特征，FMS/Helix/Wowza一看就是一个时代的，nginx/rtmpd/srs是这个时代的架构。

![Media Stream Servers Architecture](http://winlinvip.github.io/srs.release/wiki/images/compare/500.arch.png)

## CDN/VDN

对于CDN/VDN，往往有很多特殊的要求，这些只有在CDN里面的运维最清楚。CDN的软件系统，应该做到不需要运维半夜三更职守升级，这个很容易？你没有在CDN混过吧。

![Media Stream Servers CDN/VDN](http://winlinvip.github.io/srs.release/wiki/images/compare/600.cdn.png)

## Code

代码行数往往没有什么意义，软件的基础是代码，所以比较下代码行数也没有关系。如果代码行数相差不大，功能也差不多，那没有什么奇怪的；如果功能少一倍，代码行数差不多，我会选择行数少的；如果功能少一倍，代码却多一倍，只有脑袋有问题的才会选择前者吧。

![Media Stream Servers Code](http://winlinvip.github.io/srs.release/wiki/images/compare/700.code.png)

## SRS history

SRS的里程碑，服务器开发不是百米冲刺，而是马拉松，绝对的马拉松。

![Media Stream Servers SRS History](http://winlinvip.github.io/srs.release/wiki/images/compare/800.srs.higtory.png)

Winlin 2014.5