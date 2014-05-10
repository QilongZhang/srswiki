# 产品对比

对比几个知名的商业流媒体服务器，知名的开源流媒体服务器，以星级评定。难免有主观因素，以及不熟悉该产品的因素，有异议可以在群里面告知。

## History

![Media Stream Servers History](http://winlinvip.github.io/srs.release/wiki/images/100.release.png)

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

## Protocol

![Media Stream Servers Protocol](http://winlinvip.github.io/srs.release/wiki/images/200.protocol.png)

## Feature

![Media Stream Servers Feature](http://winlinvip.github.io/srs.release/wiki/images/300.feature.png)

## Deploy

![Media Stream Servers Deploy](http://winlinvip.github.io/srs.release/wiki/images/400.deploy.png)

## Deploy

![Media Stream Servers Architecture](http://winlinvip.github.io/srs.release/wiki/images/500.arch.png)

## CDN/VDN

![Media Stream Servers CDN/VDN](http://winlinvip.github.io/srs.release/wiki/images/600.cdn.png)

## Code

![Media Stream Servers Code](http://winlinvip.github.io/srs.release/wiki/images/700.code.png)

## SRS history

![Media Stream Servers SRS History](http://winlinvip.github.io/srs.release/wiki/images/800.srs.higtory.png)

Winlin 2014.5