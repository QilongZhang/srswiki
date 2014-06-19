# SRS产品规划

SRS虽然是开源项目，但是窃以为，任何软件产品还是要有规划，没有定位，就不知道不做什么，不知道不做什么就不知道做什么，不知道做什么就做不好。

## SRS目标

SRS定位是运营的服务器，不是流媒体服务器，也不提供方案。
* SRS强大的地方在于api，能提供http的api，能接入各种监控系统（注：监控系统是商业系统）。
* 方案就是端到端，从视频源到流媒体服务器，到边缘服务器，到客户端播放器，都需要做开发。
* SRS重点做直播，因为点播一般是http，而且基本上都是方案，需要播放器和api服务器交互。譬如，若点播走HLS方案，则直接使用nginx或squid就可以做分发，不是SRS的菜。
* 当然，直播和点播的方案都需要服务器做支持，只是直播需要做更多的事情，点播基本上HLS就足够了。SRS会提供直播/点播服务器部分必须做的，但不会提供管理系统，视频库，播放器等方案。
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
* API：SRS提供HTTP RESTful API，管理系统的html/js就可以直接管理服务器。
* ARM：SRS尽量依赖少量的库，依赖的库也是小而且足够成熟。譬如openssl是通用的开源库。state-threads，http-parser，都是小巧而且在各种平台都能编译通过。因为如此，SRS可以在ARM上编译和运行。
* 内嵌HTTP服务器：为了方便直播/点播的HLS的分发，SRS内嵌了HTTP服务器，支持简单的文件的分发。流媒体的特点，特别是直播，可以支持少部分HTTP协议即可。

各项功能的研发计划，参考SRS首页：[SRS功能](https://github.com/winlinvip/simple-rtmp-server#summary)

## SRS亮点

亮点只有在对比才能有亮点，对比各种流媒体服务器，SRS的亮点总结如下。不过我也会列出其他产品有的，但是SRS还没有的点，人总是自大的，看我对SRS的优点罗列就能看出来，哈哈。

为何SRS总有亮点：
* SRS作者乐天派，总是能看到自己长处，对不利的消息往往视而不见。
* SRS以商业定位做开源软件，比商业软件开放，比开源软件谨慎。
* SRS作者水平一般，只喜欢古老和熟烂的东西，代码也不敢写太高深（自己看不懂）。SRS至少能保持一个亮点：简洁。

SRS支持RTMP/HLS的最简单配置：

```bash
listen              1935;
http_stream {
    enabled         on;
    listen          80;
}
vhost __defaultVhost__ {
    hls {
        enabled         on;
    }
}
```

有见过更简单的么？

### FMS PK SRS

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

### Wowza PK SRS

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

### NginxRtmp PK SRS

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

### Red5 PK SRS

Red5就算了，100个连接就不行了，有wowza的java的弱点，也没有特别的优点，就不要pk了。同是开源软件，相煎何太急。

### crtmpd PK SRS

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

### 其他

以上就是我所知道的流媒体服务器，特别是是直播流媒体服务器，目前来看SRS还是相当让我满意的。

如果你希望知道其他服务器和SRS的PK结果，在QQ群里告知我，我看看然后加上。如果还不错，可以PK一下的话。

## BigThanks

其实srs是我到新公司后(2013.9从一家优秀的CDN公司毕业)，业余时间做的一个开源服务器，初衷是公司编码器需要输出到rtmp服务器，nginx-rtmp又经常出问题，我以前也做过rtmp边缘服务器，所以干脆就自己做个rtmp服务器。主要参考nginx-rtmp的协议栈，fms的一些概念，适配当前国内主流的视频分发需求。

后来我们公司扩大产品线，准备做VDN，视频分发网络，自然srs成为最佳选择。公司各位老大也一致认为srs的定位比较合适，一致商议决定使用srs。我也有更多时间投入到srs，用商业思路做开源产品，公司自然成为srs的主要力量。

这个是后来我将chnvideo公司，以及各位cofounder加入`big thank you`名单，没有老大的支持，成不了什么事情。想象如果我还在之前所有的公司，老板都不可能支持开源，业余时间都不行。

总之，将熊熊一窝，一事无成，一定是将不行；有点任何成绩，必然都是将的功劳。所以，应该先感谢中国政府，不过实际点，感谢目前公司的领导，是实话。我想，这是django为何也首先感谢他leader的原因

srs必定广泛使用，如同漫天繁星散布渺渺宇宙，灿漫夏花开遍地球月球火星太阳系，愿[chnvideo](chnvideo.com)公司财源广进，[SrsTeam](https://github.com/winlinvip/simple-rtmp-server#authors)永垂不朽，彪炳千古，哈哈哈!

## Vision

SRS只有crtmp的1/3代码，nginx-rtmp的1/2代码；更少代码完成的东西就是好，ST就是强大，我不掩饰这一点。SRS注释为17.39%，nginx-rtmp的注释是3.77%，crtmpd的注释是17.00%。

我希望beijing的签名能在地球上横行。

我希望软件界能改变外界对中国人的看法，贪婪、索取、闭门造车、封闭、小气、代码很次。

所以我给SRS选择MIT协议，让开源界和商界都能广泛使用。

虽然核心是st，用了stl，跑在linux上，抄袭了nginx-rtmp。这些不正是仰仗各位大牛去换成china创造么？

备注：代码比较的版本是SRS(0.9.90)，crtmp(r811)，nginx-rtmp(1.1.4)，nginx(1.5)

Beijing, 2014.3<br/>
Winlin