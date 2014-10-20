# Product Compare

We compare some famous media streaming server with SRS.

SRS focus on live streaming server, to provide the best feature or nothing, see [Product](https://github.com/winlinvip/simple-rtmp-server/wiki/EN_Product).

SRS use the best tech for RTMP protocol, the coroutine, which can simplify the state machine of async epoll states, provides by st(state-threads), see [Architecture](https://github.com/winlinvip/simple-rtmp-server/wiki/EN_Architecture)。

For detail feature and roadmap, see [Features](https://github.com/winlinvip/simple-rtmp-server/wiki/EN_Features)

## Introduction

The keyword we using:
* RTMPS/E/T：RTMPS/E is encrypt protocol, RTMPT is RTMP over HTTP to traverse firewalls.
* DASH：the HLS similar protocol design by some company.
* Change Vhost：for upnode speedup, to publish stream to RTMP cluster, CDN need to change vhost to use different device group for publish and play service.
* Readable Config: FMS/Helix/Wowza use xml config, it's very ugly. nginx style config is json-similar, modern server config. SRS use nginx style config.
* Service Script: linux system service script, see /etc/init.d/srs.
* Origin Suite: other origin software suite, for example, vms, transcode system, encoder, recorder, p2p.
* Server Side Script: the as of FMS, lua for crtmpd/nginx. SRS never support server-side script, for it's hard to debug and maintain and more bug introduced.
* Single Thread: modern linux use epoll to support 10k+ concurrency by single thread and none-blocking async socket.
* Coroutine: the coroutine is a domain of C, similar to eventlet of python, golang of google. A new domain of server side development tech.
* Maintainable: to get more maintable code, for the same features, we must write less code, add more comments, simplify the logic and use the best arch for the problem domain.
* Tracable log: client can get its id on server, edge can get its id on upnode, to get the log base on session by grep the id.

## History

The history of media stream industry.

![Media Stream Servers History](http://winlinvip.github.io/srs.release/wiki/images/compare/100.release.png)

## Protocol

Specified use scenarios must use specified protocols, because specified protocol is design for specified use scenarios. For example, udp design for 0-1000ms latency use scenario, RTMP for 1s-10s, while HLS for 10s+, vice versa.

There is no simple or good tech, and a tech is simple or good only when huge users and company spend time on it. For instance, RTMP for flash is ok for Adobe Player support it, user only need 4lines to play a RTMP stream, nothing more than NetConnection.connect(tcUrl) then NetStream.play(streamName). For example, HLS is ok for IOS/MAC for Apple Safari support it, user only need to use html5 or redirect to the http://xxx/xxx.m3u8. But, neither RTMP nor HLS is simple or good, both are complex and complex.

For internet, a "open" protocol is very important, so the RTSP never use in internet for most of company are using RTSP as private protocol. HTTP is "open" enough, and HTTP/HLS can be used in internet streaming protocol. RTMP is private but supported by flash which running almost on all PC, and RTMP can be "open" protocol for internet(PC only), and mobile platform can use RTMP by FFMPEG or AVFormat library. So, RTMP on PC(flash) is very simple for client, but complex for mobile to support RTMP.

![Media Stream Servers Protocol](http://winlinvip.github.io/srs.release/wiki/images/compare/200.protocol.png)

## Feature

It's not good enough for a streaming system to provides delivery feature, especially for public or private CDN. For example, nginx-rtmp can transcode by exec external FFMPEG, and SRS support FFMPEG by specifies the path and video/audio params and SRS will auto restart FFMPEG when quit. It's very important for user to simple the problem domain, for instance, user can modify the config item fps from 20 to 25, but it's very complex for user to modify the FFMPEG param -v:f which maybe changed for different version.

![Media Stream Servers Feature](http://winlinvip.github.io/srs.release/wiki/images/compare/300.feature.png)

## Deploy

SRS support all linux, including x86/x64/arm/mips cpu.

![Media Stream Servers Deploy](http://winlinvip.github.io/srs.release/wiki/images/compare/400.deploy.png)

## Arch

First generation server arch: FMS/Helix/Wowza, multiple thread, single process, sync and blocking io.

Second generation server arch: nginx/crtmpd, single thread, single/multiple process, async and none-blocking io.

Third generation server arch: go/eventlet/srs, single thread, single/multiple process, async and none-blocking io.

![Media Stream Servers Architecture](http://winlinvip.github.io/srs.release/wiki/images/compare/500.arch.png)

## CDN/VDN

Special key features for cdn(content delivery network) or vdn(video delivery network).

![Media Stream Servers CDN/VDN](http://winlinvip.github.io/srs.release/wiki/images/compare/600.cdn.png?version=1.0)

## Code

Code lines and comments lines, maybe means nothing, whatever, it just a data of server comparation.

![Media Stream Servers Code](http://winlinvip.github.io/srs.release/wiki/images/compare/700.code.png?v=3)

## SRS history

Cook needs time, the server development also needs long long time to code, refine and evolve. The releases and milestone makes the Marathon easier.

![Media Stream Servers SRS History](http://winlinvip.github.io/srs.release/wiki/images/compare/800.srs.higtory.png?v=1)

## FMS PK SRS

FMS is a media streaming server of Adobe, which created RTMP protocol. FMS is a very important one, and it evolved from 1.0 to 5.0. FMS(Flash Media Server) 5.0 renamed to AMS(Adobe Media Server).

FMS better than SRS for:
* Features：FMS supports RTMP/RTMPE/RTMPS/RTMPT/RTMFP protocol, AMF0/AMF3 codec, SharedObject, HLS/HDS, Live/Vod, ServerSide ActionScript1.0, FlashP2P, Windows/Linux; FMS supports everything whatever you know. SRS only support RTMP/AMF0/HLS/Live/linux.
* Dev Resource: The developer resource of Adobe FMS is very large, maybe 100+. SRS only 2 primary authors.

SRS better than SRS for:
* Simple: SRS focus on small problem domain, which is the most complex for all software(see OOAD). Because of lack of deveoper resource, SRS only provides features which is the most popular for internet. SRS is simple for and only for problem domain is simplified.
* High Performance: FMS is not low performance, but the tech using by FMS is not modern high performance arch. The "modern" arch is single-thread, async and none-blocking, which introduced by epoll of linux, for example, nginx. FMS use multiple thread arch, about 265 threads running for FMS.
* Only Linux: Why support windows for servers? Linux is not good enough as a server platform?
* Easy Config: the config is very complex of FMS, for the xml is ugly and complex to read and maintain. Why app for a live server? App is no use for a pure live server. SRS is vhost based config.
* Reload：FMS does not support FMS, while reload is very very important for service.
* Fast Restart: SRS restart very fast, <100ms, for there is no lock to wait and no resource to release. FMS need about 60s to restart. Restart is a very common feature when got unknown problem.
* Tracable Log: Although FMS provides log, but only access and error log, it is nothing to tell us why connect failed, we can not finger out the whole log of a specified connection from connect to play then close. SRS use session based log to grep by the connection id, which is send to flash client and edge node. SRS use tracable log, when we got any connection id, everything we got, that is, the source id for this connection, the id on the upnode, etc.
* High Available: No backup server for edge, when fault or upnode server crash. SRS can fetch from multiple upnode server, when one failed, rollback to the next immediately.
* For all Linux: FMS only run on Centos5 64bits, AMF can run on Centos5/6 32/64bits. SRS is ok for all Linux which has epoll, for x86/64/arm/mips cpu, that is, for Centos4/5/6 or Ubuntu or Debian or whatever linux.
* Simple URL: It's simple to guess the HLS by the RTMP of SRS, vice versa. For example, RTMP is rtmp://server/live/livestream, then HLS is http://server/live/livestream.m3u8. What about FMS? Nobody can finger it out for rtmp and hds/hls is very complex.
* Transcode: SRS support live stream transcode by fork a FFMPEG process.
* DVR: SRS support dvr with some plans. FMS need some server-side scripts which always introduce bugs.
* OpenSource: SRS use MIT license. FMS is not open source. If you want to master one server, only SRS is possible.

## Wowza PK SRS

Wowza也是个很了不起的产品，据说公司快上市了，Wowza和SRS在功能上很像，不过也是比SRS强大很多。

Wowza比SRS优点
* 功能全面：和FMS类似，Wowza支持的功能很多，估计比FMS不会少。

SRS比Wowza优点
* c++高性能：wowza是java的，想不通为何用java做服务器，性能肯定不高。不过实测发现没有想象的那么低，当然比起NGINX还是很低。低性能的问题就是延迟会大。不过不是所有流媒体客户都关心延迟，所以Wowza这点不算硬伤。
* 部署简单：wowza依赖于jdk，还得设置环境变量，我去。wowza的安装包也很大，jdk的也很大，都在100MB+，真的不方便。SRS多大？3MB左右，不依赖与任何外部库。一个srs，一个conf，就能跑起来了。wowza需要多少东西。。。
* 内存少：其实java都是这样，内存居高不下，没有办法，gc肯定没有那么智能。wowza吃内存是以GB算的，SRS是以KB算的，在某些没有10GB内存的服务器上，还是不要跑wowza得好。虽说内存便宜，如果内存没法那么大呢？譬如arm？
* 不跨平台：wowza使用java跨平台，技术就是这样，有好处就会有代价。SRS打死也不会考虑做非linux平台，目的就是雷总的名言“xx粗暴，简单有效”。
* 配置简单：java的配置，xml，蛋疼，不喜欢所有java的配置，譬如tomcat之类。nginx的配置文件绝对是极品，是的，SRS就是抄袭的nginx的配置部分的代码。
* 不支持Reload：wowza也没有听说过reload这回事吧，这个功能上用起来真是很重要，不知道为何大家都不支持。同样的，nginx的reload多么强大。reload也不是多么难的事情，srs也支持reload，这个不是从nginx抄袭的，自己写额。
* 日志不明：商业软件都是一副德行，生怕别人看懂日志，提供的接口也很封闭。SRS当然不会了，原因是SRS没有那么多精力做方案，只好提供接口给大家控制和使用。
* 没有热备：wowza的热备似乎是个插件，也有可能没有，这点不太确定。不过SRS原生支持热备，发生故障时切换时间以毫秒计算，也就是上层服务器没有流了，马上切换到其他服务器，用户不会断也不会有感觉。
* 没有代码：wowza也是没有代码的，比FMS好的是它提供了plugin方案。等等，plugin方案和nginx的模块，哪个好？当然是后者，后者直接编译进去，接口都可见，甚至把nginx自己代码改了都可以。SRS不支持nginx的模块，原因是觉得那个太麻烦，本身代码就没有多少，不如直接改。

## NginxRtmp PK SRS

可以说，nginx-rtmp是最现代化的流服务器，几乎无可挑剔，所以现在崛起也很快。主要得益于nginx的基础做得好。

nginx-rtmp是2012.3.17发布的0.0.1（1.0是在2013.5.27），基本上那个时候开始做的。参考：[nginx-rtmp release 0.0.1](https://github.com/arut/nginx-rtmp-module/releases/tag/v0.0.1)。

nginx-rtmp(1.1.4版本)的代码行数是30957行代码，和SRS(0.9.90 33679行，另外st有4839行)是差不多的，功能和SRS差不多吗？

可惜，nginx-rtmp不能单独运行，得基于nginx运行。nginx1.5的代码是141534行，核心的服务器部分（core, event)是37678行。也就是说，nginx-rtmp实际上是68883行，是SRS（38610行）的1.784倍，功能能有SRS的2倍吗？这就是ST强大的地方吧。

SRS的注释（可使用工具research/code-statistic/csr.py统计）是5944行，占总代码行数的17.65%。ST的注释是754行，占代码总行数比例为15.58%。合在一起是6698行，占总数的17.39%。

Nginx的注释是1644行，占代码总行数的4.36%。NginxRTMP的注释是946行，占代码总行数的3.06%。混合在一起的行数是2598行，占总行数的3.77%。

nginx-rtmp比SRS优点
* 作者牛逼：能在nginx上写rtmp扩展的人，真心是牛逼。SRS作者以前做过类似的事情，不是在nginx上，是照着nginx的底层结构，用linux/epoll/多进程单线程/非阻塞异步socket实现RTMP协议，发现越到后面那个异步状态处理越麻烦。不得不承认，nginx-rtmp作者能力比SRS作者能力高出N个数量级。
* 支持多进程：nginx的多进程是个硬指标。SRS有研发计划，但目前还没有支持多进程（多进程不Simple），好消息是在不久将来，SRS就可以在这点上不成为弱点了。

SRS比nginx-rtmp优点
* 简单：nginx高性能，原因是直接使用异步非阻塞socket。SRS本质上也是，所以说和nginx同源架构，但是在另外一个牛人的指点下，用了st这个库，避免了异步socket那些状态处理。所以SRS看起来的逻辑很简单。我一直以为，nginx-rtmp最大的挑战就是不稳定，太复杂了，越发展应该是越明显，不过nginx-rtmp作者很强大，这个就很难估计了。
* Vhost：nginx-rtmp作者估计没有用过FMS，因为FMS的Vhost在客户较多时，会很有用（是个必选），也可能是支持vhost会导致RTMP状态更多吧。总之，没有vhost，对于CDN这种公司，有很多客户用同一套流媒体时，是不行的（如何计费呢？）
* RTMP边缘：或许nginx-rtmp的pull和push也算边缘，但是实际上不完全是，边缘应该只需要知道源站的ip，所有信息都从源站取。这样对于大规模部署很方便。另外和上面一点相关，配置应该基于vhost，而不是app，app是不需要配置的，只有vhost才需要，配置vhost后随便客户推什么流上来啦。
* 转码：nginx-rtmp其实也可以用ffmpeg转码，也是用ffmpeg，不过稍微没有往前走一步。nginx-rtmp的转码是通过事件，类似SRS的HTTP callback，在连接上来时转码。SRS往前走了一步，在配置文件里配置转码信息，SRS会自动管理进程，kill或者重启。使用起来还是方便不少的。
* 代码少：nginx-rtmp是基于nginx的，nginx是web服务器，专业的牛逼的web服务器。所以nginx-rtmp的代码总数是16万行，而srs只有2万行。如果要在arm上编译，还是srs稍微瘦一点。如果打算维护，还是维护2万行代码的产品会好些。
* 中文文档：SRS中文文档基本覆盖了SRS的功能，而且会根据大家的问题更新，还是很适合中文水平不错的人。
* 有QQ群：nginx-rtmp人家不是国人嘛，当然不会有QQ群的。所以对于国内用户的声音，nginx-rtmp更像典型的开源软件；坦白讲，SRS的QQ群的实时沟通，还是能更明确大家到底在如何使用SRS，以及SRS的方向。

我也fork了nginx-rtmp代码，RTMP和HLS部分都是参考了nginx-rtmp，大牛还是大牛啊。nginx-rtmp 1.1.4的一些提交，还是在fix crash，直接异步的方式做RTMP还是比较难的：

![nginx-rtmp crash](http://winlinvip.github.io/srs.release/wiki/images/nginx-rtmp-1.1.4-crash.png)

对比下代码，响应connect-app这个包的发送的代码：

![nginx-pk-srs.send-conn-response](http://winlinvip.github.io/srs.release/wiki/images/nginx-pk-srs.send-conn-response.png)

这个就是同步和异步socket的区别，以及问题的分解导致的一致性（组包和发包两个层次，而不是nginx那样设置数据，更改全局配置，调用发送函数），对象层次的互动和数据操作（或者说数据隐藏和层次化，和数据结构）这两个编程方法的区别。

## Red5 PK SRS

Red5就算了，100个连接就不行了，有wowza的java的弱点，也没有特别的优点，就不要pk了。同是开源软件，相煎何太急。

## crtmpd PK SRS

crtmpd（rtmpserver），c++的RTMP服务器，但是SRS也是C++的，私下以为crtmpd是以c的思维习惯来写c++代码，就像c++作者讲的，拿着c++这个电钻当铁锤锤钉子————不仅仅没有效果，还可能会砸到自己的手。

crtmp(svnversion为811版本）的代码行数是93450行代码，是SRS(0.9.90 38518行，其中st有4839行)的2.426倍，功能不会比SRS多3倍吧？这就是ST强大的地方。

SRS的注释（可使用工具research/code-statistic/csr.py统计）是5944行，占总代码行数的17.65%。ST的注释是754行，占代码总行数比例为15.58%。合在一起是6698行，占总数的17.39%。

CRTMPD的注释是15891行，占代码总行数的17.00%。

```bash
# CRTMPD
python ~/srs/research/code-statistic/csr.py ~/git/crtmpserver/sources/ *.h,*.cpp .svn,tests
#total:93450 code:77559 comments:15891(17.00%) block:13123 line:2768
```

```bash
#NGINX1.5(event,core)
python ~/srs/research/code-statistic/csr.py ~/tools/nginx-rtmp/nginx-1.5.7/src/ *.h,*.c http,mail,misc,os
#total:37678 code:36034 comments:1644(4.36%) block:1644 line:0
```

```bash
#NGINX-RTMP1.1.4
python ~/srs/research/code-statistic/csr.py ~/tools/nginx-rtmp/nginx-rtmp-module-1.1.4/ *.h,*.c
#total:30957 code:30011 comments:946(3.06%) block:946 line:0
```

```bash
# NGINX(event,core)+NGINX-RTMP
python ~/srs/research/code-statistic/csr.py ~/tools/nginx-rtmp/mixed/ *.h,*.c
#total:68883 code:66285 comments:2598(3.77%) block:2598 line:0
```

```bash
# ST
python ~/srs/research/code-statistic/csr.py ~/srs/objs/st-1.9/ *.h,*.c examples,extensions,LINUX
#total:4839 code:4085 comments:754(15.58%) block:754 line:0
```

```bash
# SRS
python ~/srs/research/code-statistic/csr.py ~/srs/src *.*pp utest,upp
#total:33679 code:27735 comments:5944(17.65%) block:4126 line:1818
```

而且，crtmpd还支持lua，这个是开源软件的通病，喜欢什么都往里面加，窃以为不可取。所以有人抱怨说crtmpd太大，是的，大得不得了。

我测试过crtmpd性能，还是不错的，应该和SRS差不多。可惜crtmpd走的是单进程方向，各种扩展和协议，没有支持多进程和边缘集群方向，所以大家道不同不相为谋，也没有什么好比较的了。

## 其他

以上就是我所知道的流媒体服务器，特别是是直播流媒体服务器，目前来看SRS还是相当让我满意的。

如果你希望知道其他服务器和SRS的PK结果，在QQ群里告知我，我看看然后加上。如果还不错，可以PK一下的话。

Winlin 2014.10