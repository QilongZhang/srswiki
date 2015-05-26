[**HOME**](Home) > [**CN(2.0)**](v2_CN_Home) > [**Flash/Android/IOS P2P**](v2_CN_WebP2P)

很多朋友关心SRS是否有计划支持RTMFP，是否支持P2P，这篇文章详细介绍了SRS和P2P的关系。

## Summary

我们所指的P2P，并非传统客户端P2P的方式，譬如ed2k那种协议。我们特指三种P2P：

1. Flash P2P：Adobe开发的P2P，Flash播放器之间可以互相P2P，分享视频。
1. Android P2P：特指Android的App的P2P方式，Android上HTML5不可能做P2P。
1. IOS P2P：特指IOS的App的P2P方式，IOS上HTML5不可能做P2P。

这三种P2P都有几个共同点：

1. 只讨论流媒体范畴的P2P，普通文件和数据的P2P不考虑。
1. 流媒体传输使用通用协议，譬如flv、mp4或hls，配合CDN完成P2P原始资源的传输，而并非所有的数据都是P2P网络用私有协议传输。
1. 尽量避免安装额外插件。譬如FlashP2P就在flash播放器上跑（别纠结flash本身就是个插件），只需要集成AS的SDK，不需要额外安装ActiveX浏览器插件。而Android和IOS的P2P，需要集成P2P系统的SDK，只需要安装商家的App，而不需要再安装专门用来做P2P的App。

综上所述，我们可以将Flash/Android/IOS P2P，简称为WebP2P。下面讲WebP2P一种可能的结构，以及SRS和WebP2P的关系。

## Structure

一个WebP2P系统，可以包含下面几个结构：

1. 客户端SDK：P2P系统必须提供客户端SDK，集成在播放器或者App中。譬如FlashP2P提供的是AS的库，Android提供的是java的库，IOS提供oc的库。
1. API调度集群：P2P系统必须支持API调度，弥补DNS的不足，以及提供P2P系统需要的额外数据。API调度就是SDK交互的第一个后端，完成认证、其他服务器资源的分配、流信息、实时调度。
1. RTMFP集群：或者称为基础协议集群，由API调度返回给SDK可用的服务器，客户端使用RTMFP服务器完成NAT打洞，以及必要的数据传输。
1. Tracker集群：或者称为伙伴发现协议集群，由API调度返回给SDK可用的服务器，客户端向Tracker请求可用的伙伴节点。
1. Pingback集群：或者称为实时数据集群，由API调度返回给SDK可用的服务器，并提供给API调度集群调度的实时数据依据，SDK向Pingback集群汇报实时数据。
1. 流媒体源站集群：或者称为流媒体源，主要负责流媒体数据的生成，和CDN对接，由API调度返回给SDK可用的CDN边缘地址。

可以在SRS基础上完成的结构是：流媒体源站集群，RTMFP集群。其他大多是HTTP协议，主要是P2P系统内部的算法和逻辑处理，适合使用Python或者GO实现。

另外，Pingback集群需要提供10秒级别的系统数据，使用GO或者Spark都可以，数据量小时用GO实现也可以，数据量很大时可以用Spark。

下面详细分析SRS在WebP2P中的位置和状态。

## SRS for WebP2P

回过头来说，SRS现在已经支持流媒体和RTMFP了吗？SRS支持了流媒体，但是RTMFP不支持。

所谓SRS支持了流媒体，指的是SRS能输出一种HLS，能符合一种P2P系统的要求。这种P2P系统就是观止创想的P2P系统，具体参考[BravoP2P][BravoP2P]。也就是说，若使用SRS作为您的流媒体服务器，是可以直接对接到观止的P2P系统的，可以给现有的HLS流加上P2P功能。

SRS为何不支持RTMFP呢，有几个原因：

1. RTMFP是观止同事完成的编码，代码所有权属于公司，是否开源由公司决定。
1. RTMFP和SRS的差异太大，有一个RTMFP服务器，还只是P2P系统的六分之一。
1. SRS的目标是提供通用方案，SRS3的Dragon技术，SRS4对接Spark，目前还没有支持P2P系统的计划，P2P系统里面很多是私有方案。

因此，在可以SRS3（预计2016年发布）和SRS4（预计2017年发布）的路线图中，都没有RTMFP的影子。

也就是说，在WebP2P系统中，SRS只计划支持流媒体源站功能。下面分开看看各种WebP2P系统。

## Flash P2P

FlashP2P是由Adobe研发的P2P协议，包括握手、NAT打洞、数据传输，Adobe收购了一家做P2P的公司，将这个RTMFP协议集成到了Flash中。

FlashP2P在PC上的效果很成熟，稳定性也可以达到商用的要求。2013年左右，支持FlashP2P的公司也开始粗现，现在听说过名字的有：[观止创想][BravoP2P]，云成互动，八百里，云帆等等。

## Android P2P

Android手机、盒子和Pad上面支持P2P，这个目前还在发展中。

## IOS P2P

IOS手机和Pad上面支持P2P，这个难度比AndroidP2P还大，目前没有消息。

## Challenge

上面讲了各种WebP2P的情况，WebP2P的挑战有以下几点：

1. 转换思维对接CDN：CDN最惧怕的就是WebP2P公司，不是要分他流量那么简单，而是对接起来灰常痛苦。据说有的FlashP2P系统，得在CDN每个边缘节点部署服务器，因为流媒体切片不通用，这不是要革CDN的命么？因此首先最大的挑战就是转换为互联网思维，尽量使用通用方案，让CDN爽了WebP2P系统才能爽。
1. 保证流畅度：传统P2P可以暂停缓冲个几个小时，而WebP2P直播正在进行时，缓冲个几次用户就刷新页面，这个P2P节点就相当于牺牲了。因此保证流畅度才能保证分享率，如何保证流畅度呢，这个就各显神通了。
1. 实时调度：WebP2P的变化非常快，有的用户刷新页面啦，有的系统拖动啦，有的还暂停，有的就喜欢乱点。因此整个WebP2P的节点信息都是变化很快的，这对实时分析系统有非常大的挑战。
1. 负载均衡和热备：WebP2P的集群也需要负载均衡，譬如RTMFP协议就支持Redirect方式，可以实现负载均衡和热备。传统P2P系统挂掉后节点就没法看视频，而一个WebP2P系统挂掉后依然能看，因为有CDN在那里呢，但是带宽就开始飙升了。而P2P系统的恢复需要较长时间，因此必须使用热备，在出现问题时切换到正常的系统。

我可以用周末的时间，保证SRS一年一个版本；但我和我的同事一天从早到晚，两年时间才做完WebP2P系统第一个版本。如果你的团队全职一年做一个SRS都有困难的话，建议大家不要自己开发，而是使用这些公司的WebP2P云服务；做什么都建议不要和我做同样的东西（狂妄的笑，哈哈）。

以上基本上是我所知道的WebP2P。

Winlin 2015.5

[BravoP2P]: http://www.chnvideo.com