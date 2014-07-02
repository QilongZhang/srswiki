# SRS产品规划

关于SRS的来源，定位，愿景，和知名服务器的比较。

## Vision

SRS定位是运营级的互联网直播服务器，追求更好的概念完整性和最简单实现的代码。

* 运营级：商业运营追求极高的稳定性，良好的系统对接，以及错误排查和处理机制。譬如日志文件格式，reload，系统HTTP接口，提供init.d脚本，转发，转码，边缘回多源站，都是根据CDN运营经验作为判断这些功能作为核心的依据。
* 互联网：互联网最大的特征是变化，唯一不变的就是不断变化的客户要求，唯一不变的是基础结构的概念完整性和简洁性。互联网还意味着参与性，听取用户的需求和变更，持续改进和维护。
* 直播服务器：直播和点播这两种截然不同的业务类型，导致架构和目标完全不一致，从运营的设备组，应对的挑战都完全不同。两种都支持只能说明没有重心，或者低估了代价。
* 概念完整性：虽然代码甚至结构都在变化，但是结构的概念完整性是一直追求的目标。从SRS服务器，P2P，ARM监控产业，MIPS路由器，服务器监控管理，ARM智能手机，SRS的规模不再是一个服务器而已。
* 简单实现：对于过于复杂的实现，宁可不加入这个功能，也不牺牲前面提到的要求。对于已经实现的功能的代码，总会在一个版本release前给予充分的时间来找出最简答案。不求最高性能，最优雅，最牛逼，但求最简单易懂。

备注：概念完整性可以参考Brooks的相关文献，在宏观方面他还是很有造诣。

## FMS PK SRS

FMS是adobe的流媒体服务器，RTMP协议就是adobe提出来的，FMS一定是重量级的产品。

FMS比SRS优点
* 功能全面：支持RTMP/RTMPE/RTMPS/RTMPT/RTMFP流协议，AMF0/AMF3编码，SharedObject协议，HLS/HDS协议，直播和点播，支持服务器脚本，支持多码率，支持Windows和Linux平台。能想到的好像都能支持。SRS呢？可怜兮兮的只有RTMP/AMF0/HLS/直播/linux。
* 研发资源充分：adobe做FMS的多少人，看那个样子真是不少，还得不断改进和推出新版本。这个也算一个优势，不过也难讲，windows也不少人，对比起linux，服务器还是比不过后者。

SRS比FMS优点
* 更高性能：FMS的性能不算瓶颈，不过FMS一个进程开启246个线程的架构设计来看，FMS就是一个旧时代的产物。
* 不跨平台：FMS支持跨平台，在我看来不过是多此一举，服务器为何要跑在windows上面？大约只是为了自宫练宝典。正是SRS不跨平台，才得以略去很多麻烦事。
* 配置简单：FMS的配置巨麻烦无比，xml也是上一代技术的产物，真心xml作为配置是个不好用的东西。何况FMS的配置巨繁琐，创建vhost还得创建一个目录，拷贝配置，创建app也要建立目录，且小心了，别改错了。SRS呢？根本不用创建app，为什么要创建app？！创建vhost只要在配置文件加一行就搞定。
* 不支持Reload：FMS没有Reload，所以某CDN公司的运维就很苦了，白天不能动FMS，不能加新客户，那会导致FMS重启。只能半夜三更起来，操作完了还要阿弥陀佛，因为研发一般这时候睡觉了，除了问题就只能自求多福。SRS呢？直接Reload就能生效，不影响在线用户，想怎么改都行。
* 重启巨慢：c/c++程序嘛，总会出问题，解决这种问题，简单的方式就是看门狗重启。FMS惨了，重启要1分钟，我去，1分钟没有流啊，客户都要找上门赔钱了，不行的。SRS重启多长时间？以毫秒计算。
* 日志不明：FMS的日志，就是没有什么用的东西，想知道某个IP的客户端为何死活播放不了？想知道有哪些客户端延迟较大？想知道目前服务器吞吐带宽？做梦吧，adobe根本没打算给出来，或许他们自己也不知道，哈哈。SRS呢？首先，记录完整日志，都有错误码，而且有client id，可以查询到某个客户端的整个信息（要在那么多客户端中找出一个，不简单）。其次，使用pithy print，做到智能化打印，SRS的日志输出还是比较能给人看的，不多不少。最后，SRS提供cli，能吐出json数据，想查带宽？想查流信息？cli都可以搞定，而且是json，现代系统标准接口。
* 没有热备：FMS竟然没有热备？是的，不是adobe不行，几乎都不会考虑热备。SRS边缘可以回多个源站，一个挂了切另外一个。FMS如何做？得改配置，重启，等等，重启不是要一分钟吗？是的，简单来讲，FMS不支持热备。
* 适应性强：FMS适应性如何不强？FMS4只能运行在Centos5 64位，FMS5要好点也好不到哪里去。SRS呢？估计linux-arm上都能跑，更别提什么linux发行版，什么机器，什么内存，都行！如果你有大量旧机器要跑流媒体？可以，上SRS吧。
* url格式简单：这个也算？我觉得很算。看过FMS的RTMP对应的HDS/HLS流吧？多么长的地址，多么恐怖的adbevent！谁要是能立马配置FMS的HLS，然后输入地址播放，那真的是神。SRS呢？把rtmp换成http，后面加上.m3u8就是HLS，多么简单！
* 不支持转码：FMS无法对直播流在服务器端转码。SRS使用ffmpeg做了支持。adobe是大公司，应该是没有办法使用ffmpeg转码。
* 不支持录制：FMS的录制是在FMLE上有个DVR的按钮，然后配置服务器端脚本实现，不靠谱。SRS的录制和时移只会做一部分，但是也会比那种脚本方案要靠谱很多（脚本不可能不出问题，亲身经历）。
* 没有代码：FMS最重要一点，不提供代码，有bug？找adobe。想要定制？找adobe。那基本上就不要有那个念想了。SRS代码都是开源的，SRS作者水平一般，所以写出来代码就需要很小心，尽量写得清楚，不然自己看不懂，哈哈。

## Wowza PK SRS

Wowza也是个很了不起的产品，据说公司快上市了，Wowza和SRS在功能上很像，不过也是比SRS强大很多。

Wowza比SRS优点
* 功能全面：和FMS类似，Wowza支持的功能很多，估计比FMS不会少。

SRS比Wowza优点
* c++高性能：wowza是java的，想不通为何用java做服务器，性能肯定不高。不过实测发现没有想象的那么低，当然还是很低。低性能的问题就是延迟会大。不过不是所有流媒体客户都关心延迟，所以Wowza这点不算硬伤。
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

nginx-rtmp是2012.3.17发布的0.0.1，基本上那个时候开始做的。参考：[nginx-rtmp release 0.0.1](https://github.com/arut/nginx-rtmp-module/releases/tag/v0.0.1)。

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

## BigThanks

其实srs是我到新公司后(2013.9从一家优秀的CDN公司毕业)，业余时间做的一个开源服务器，初衷是公司编码器需要输出到rtmp服务器，nginx-rtmp又经常出问题，我以前也做过rtmp边缘服务器，所以干脆就自己做个rtmp服务器。主要参考nginx-rtmp的协议栈，fms的一些概念，适配当前国内主流的视频分发需求。

后来我们公司扩大产品线，准备做VDN，视频分发网络，自然srs成为最佳选择。公司各位老大也一致认为srs的定位比较合适，一致商议决定使用srs。我也有更多时间投入到srs，用商业思路做开源产品，公司自然成为srs的主要力量。

这个是后来我将chnvideo公司，以及各位cofounder加入`big thank you`名单，没有老大的支持，成不了什么事情。想象如果我还在之前所有的公司，老板都不可能支持开源，业余时间都不行。

总之，将熊熊一窝，一事无成，一定是将不行；有点任何成绩，必然都是将的功劳。所以，应该先感谢中国政府，不过实际点，感谢目前公司的领导，是实话。我想，这是django为何也首先感谢他leader的原因

srs必定广泛使用，如同漫天繁星散布渺渺宇宙，灿漫夏花开遍地球月球火星太阳系，愿[chnvideo](chnvideo.com)公司财源广进，[SrsTeam](https://github.com/winlinvip/simple-rtmp-server#authors)永垂不朽，彪炳千古，哈哈哈!

Beijing, 2014.3<br/>
Winlin