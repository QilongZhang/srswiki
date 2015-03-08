# SRS产品规划

关于SRS的来源，定位，愿景和计划。

## Vision

SRS定位是运营级的互联网直播服务器集群，追求更好的概念完整性和最简单实现的代码。

* 运营级：商业运营追求极高的稳定性，良好的系统对接，以及错误排查和处理机制。譬如日志文件格式，reload，系统HTTP接口，提供init.d脚本，转发，转码，边缘回多源站，都是根据CDN运营经验作为判断这些功能作为核心的依据。
* 互联网：互联网最大的特征是变化，唯一不变的就是不断变化的客户要求，唯一不变的是基础结构的概念完整性和简洁性。互联网还意味着参与性，听取用户的需求和变更，持续改进和维护。
* 直播服务器：直播和点播这两种截然不同的业务类型，导致架构和目标完全不一致，从运营的设备组，应对的挑战都完全不同。两种都支持只能说明没有重心，或者低估了代价。
* 集群：FMS(AMS)的集群还是很不错的，虽然在运营容错很差。SRS支持完善的直播集群，Vhost分为源站和边缘，容错支持多源站切换、测速、可追溯日志等。
* 概念完整性：虽然代码甚至结构都在变化，但是结构的概念完整性是一直追求的目标。从SRS服务器，P2P，ARM监控产业，MIPS路由器，服务器监控管理，ARM智能手机，SRS的规模不再是一个服务器而已。
* 简单实现：对于过于复杂的实现，宁可不加入这个功能，也不牺牲前面提到的要求。对于已经实现的功能的代码，总会在一个版本release前给予充分的时间来找出最简答案。不求最高性能，最优雅，最牛逼，但求最简单易懂。

备注：概念完整性可以参考Brooks的相关文献，在宏观方面他还是很有造诣。

## Release1.0

开发代号：HuKaiqun（胡开群）。感谢我的初中老师胡开群和高昂老师，教育我热爱自己所做的事情。

[SRS release 1.0](https://github.com/winlinvip/simple-rtmp-server/tree/1.0release)，预计研发周期为1年左右。主要的目标是：

* 提供互联网直播的核心业务功能，即RTMP/HLS直播。能对接任意的编码器和播放器，集群支持对接任意的源站服务器。
* 提供丰富的外围流媒体功能，譬如Forward，Transcode，Ingest，DVR。方便开展多种源站业务。
* 完善的运维接口，reload，HTTP API，完善和保持更新的wiki。另外，提供配套的商业监控和排错系统。
* 完备的utest机制，还有gperf（gmc，gmp，gcp）和gprof性能以及优化机制。提供c++层次足够满意的性能和内存错误查找机制。
* 在ARM/MIPS等嵌入式CPU设备Linux上运行。另外，提供配套的内网监控和排错，cubieboard/raspberry-pi的嵌入式服务器。
* 高性能服务器，支持2.7k并发。

[SRS Release 1.0](https://github.com/winlinvip/simple-rtmp-server/tree/1.0release)已经在2014.12.5如期发布。

## Release2.0

开发代号：ZhouGuowen（周国文）。感谢我的高中老师周国文老师，教我成人自立，为我翻开一个新的篇章。

[SRS release 2.0](https://github.com/winlinvip/simple-rtmp-server/tree/develop)，预计研发周期为6个月左右。主要的目标是：

* 翻译中文wiki为英文。
* 提升性能，支持10k+播放和4.5k+推流。参考：[#194](https://github.com/winlinvip/simple-rtmp-server/issues/194)，[#237](https://github.com/winlinvip/simple-rtmp-server/issues/237)和[#251](https://github.com/winlinvip/simple-rtmp-server/issues/251)
* srs-librtmp支持发送h.264和aac裸码流。参考：[#66](https://github.com/winlinvip/simple-rtmp-server/issues/66)和[#212](https://github.com/winlinvip/simple-rtmp-server/issues/212)
* 学习和简化st，只保留linux/arm部分代码。参考：[#182](https://github.com/winlinvip/simple-rtmp-server/issues/182)
* srs-librtmp支持windows平台。参考：[bug #213](https://github.com/winlinvip/simple-rtmp-server/issues/213), 以及[srs-librtmp](https://github.com/winlinvip/srs.librtmp)
* 简化握手，使用模板方法代替union。参考：[#235](https://github.com/winlinvip/simple-rtmp-server/issues/235)
* srs-librtmp支持劫持IO，应用于[st-load](https://github.com/winlinvip/st-load).
* 支持实时模式，最低支持0.1秒延迟。参考：[#257](https://github.com/winlinvip/simple-rtmp-server/issues/257#issuecomment-66773208)
* 支持允许和禁止客户端推流或播放。参考：[#211](https://github.com/winlinvip/simple-rtmp-server/issues/211)
* DVR支持[自定义文件路径](https://github.com/winlinvip/simple-rtmp-server/issues/179)和[DVR http callback](https://github.com/winlinvip/simple-rtmp-server/issues/274).
* 可商用的内置HTTP服务器，参考GO的http模块。参考：[#277](https://github.com/winlinvip/simple-rtmp-server/issues/277).
* RTMP流转封装为HTTP Live flv/aac/mp3/ts流分发。参考：[#293](https://github.com/winlinvip/simple-rtmp-server/issues/293).
* 支持内存HLS，无磁盘IO, 参考：[#136](https://github.com/winlinvip/simple-rtmp-server/issues/136).
* 增强的DVR，支持Append/callback，参考：[#179](https://github.com/winlinvip/simple-rtmp-server/issues/179).
* 增强的HTTP API，支持stream/vhost查询，参考：[#316](https://github.com/winlinvip/simple-rtmp-server/issues/316).
* [experiment]支持Push MPEG-TS over UDP to SRS, 参考：[#250](https://github.com/winlinvip/simple-rtmp-server/issues/250).
* [experiment]支持Push RTSP to SRS，参考：[#133](https://github.com/winlinvip/simple-rtmp-server/issues/133).
* 其他小功能的完善。

## Release3.0

SRS release 3.0，预研阶段，没有时间表。主要的目标是：

* SRS.GO，转向GO语言。参考：[SRS.GO项目](https://github.com/winlinvip/srs.go)，以及[GO性能评测](http://blog.csdn.net/win_lin/article/details/41379799)

## Backlog

SRS 3.0+ 的功能列表，可能的方向：

* HTTP方向：
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/130" target="_blank">HLS边缘</a>，
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/129" target="_blank">HTTP FLV分发</a>，
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/83" target="_blank">HTTP API认证</a>，
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/139" target="_blank">HLS快速缓存技术</a>，
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/140" target="_blank">HTTP支持vhost</a>，
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/52" target="_blank">HTTP访问时回调</a>，
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/174" target="_blank">HTTP-MP4流</a>
* 增强的RTMP方向：
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/106" target="_blank">转发调用</a>，
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/92" target="_blank">支持RTMP302跳转</a>，
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/71" target="_blank">RTMP推流认证</a>，
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/131" target="_blank">支持AMF3</a>，
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/132" target="_blank">SharedObject和文本分发</a>，
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/156" target="_blank">一个连接多个流</a>，
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/163" target="_blank">Forward支持额外参数</a>，
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/164" target="_blank">Edge支持额外参数</a>，
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/93" target="_blank">支持RTMFP协议</a>
* 超低延迟方向：
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/120" target="_blank">FRSC百毫秒延迟</a>，
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/94" target="_blank">集群内部使用UDP</a>
* 监控RTSP方向：
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/133" target="_blank">支持RTSP</a>

SRS对于所有新功能都持推延态度；有悖于系统一致性和概念完整性的功能绝对不做，譬如支持Windows系统就有悖于一致性和完整性（服务器系统的差异太大）；对于确定要做的功能SRS也会仔细斟酌最佳方案，譬如支持多进程就是在选最佳方案；对于已有方案要做到最好，譬如最低延迟方案。对于功能点，只要属于系统一致性和概念完整性范围内都会考虑添加，或者说，大部分都不做，要做就要做到最好，the best or nothing!

## BigThanks

SRS是2013.9(2013.8.22提离职申请，理论上2013.9.22就离职，为了交接平稳我增加了交接时间)我从蓝汛离职后，我参考nginx_rtmp写了个简洁直播源站服务器。蓝汛接我工作的同事也可以看到服务器如何一步步构建。蓝汛的客户也可以用这个源站，那些乱七八糟的源站对接太麻烦。我想用业余时间构建不受客户随意影响的产品，只遵循核心价值而加入功能，而不是为了赚钱或者客户头脑发热，总之，实现我对于产品价值和质量，真正实现客户核心要求，定位清晰，一个实践现代软件工程和研发理念的服务器。

2013.10底加入观止负责研发管理工作。后来观止创想做编码器，编码器需要输出到rtmp服务器，nginx-rtmp又经常出问题，就打算用我的SRS替换nginx-rtmp。后来编码器上线过程中，我也逐步完善了SRS，是快速成长期。开放服务器，就让客户可以更好的用我们编码器，而且我们编码器可以支持拉模式。这个阶段主要是源站阶段。

2014.3进入反馈期，树苺派，极路由，cubieboard等嵌入式设备上有人问是否能支持。我自己买了树苺派，在上面运行成功，改了st的一个bug。从这个时候开始，是功能爆发的时期，得到群里童鞋们的反馈。转码，转发，采集，录制都是这个时期的工作。

2014.5，SRS功能冻结，测试和解决问题。我们公司扩大产品线，准备做VDN，视频分发网络，自然srs成为最佳选择。公司各位老大也一致认为srs的定位比较合适，一致商议决定直播服务器使用srs。SRS的功能都已经完善，VDN其他业务系统譬如监控和计费开始研发，我只有周末时间做SRS了。

2014.10，[SRS1.0](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_CN_Product#release10)beta发布，坐等大家反馈bug，如果没有bug就在2014年底发布[SRS1.0](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_CN_Product#release10)release。观止创想也准备在1.0release的基础上上研发下一代商用流媒体服务器。从0到1.0，SRS花了1年时间，[17](https://github.com/winlinvip/simple-rtmp-server/releases)个里程碑，[7](https://github.com/winlinvip/simple-rtmp-server/tree/1.0release#releases)个开发版，223个修订版，43700行功能代码，15616行utest代码，1803次提交，[161](https://github.com/winlinvip/simple-rtmp-server/issues)个bug和功能，解决了[117](https://github.com/winlinvip/simple-rtmp-server/issues?q=milestone%3A"srs+1.0+release")个，可在[1](https://github.com/winlinvip/simple-rtmp-server/tree/1.0release#system-requirements)个平台运行(linux)，支持4种cpu(x86/x64/arm/mips)，[11](https://github.com/winlinvip/simple-rtmp-server/tree/1.0release#about)个核心功能(origin、 [edge](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_CN_Edge)、 [vhost](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_CN_RtmpUrlVhost)、 [transcode](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_CN_FFMPEG)、 [ingest](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_CN_Ingest)、 [dvr](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_CN_DVR)、 [forward](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_CN_FFMPEG)、 [http-api](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_CN_HTTPApi)、 [http-callback](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_CN_HTTPCallback)、 [reload](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_CN_Reload)、 [tracable-log](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_CN_SrsLog))，[35](https://github.com/winlinvip/simple-rtmp-server/tree/1.0release#summary)个功能点，[58](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_CN_Home)篇wiki，SRS的QQ群有245位成员，活跃成员141人，[2](https://github.com/winlinvip/simple-rtmp-server/tree/1.0release#authors)位主作者，[12](https://github.com/winlinvip/simple-rtmp-server/blob/master/AUTHORS.txt)位贡献者，[14](https://github.com/winlinvip/simple-rtmp-server/tree/1.0release#donation)位捐赠者，至少有蓝汛、VeryCloud、VeryCDN、清华电视台在[使用或基于SRS改自己的服务器](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_CN_Sample)，数百个各种行业的公司在使用SRS主要包含视频监控、移动端、在线教育、秀场和KTV、互动视频、电视台、物联网、学生。

2014.10启动[SRS2.0](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_CN_Product#release20)研发，预计6个月左右的研发周期，主要目标是完全了解和掌握st，简化服务器的客户端模型，以及其他小功能的完善。比较[大的方向](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_CN_Product#backlog)在3.0+支持。

感谢我自己像个偏执狂一样独自坚持完成srs的定位，架构，编码，测试和文档。感谢父母的养育，老师的培养，尤其是初中的胡开群高昂老师，高中的周国文老师，大学的欧旭理老师。感谢刚毕业在大唐工作时何力对我的帮助，以及微软时期赵斌对于接口设计的教导。感谢蓝汛时期付亮副总裁，我的研发管理启蒙老师对我认可和支持；感谢蓝汛时期Micheal热情大气无私，以及精湛的能力教我解决蓝汛边缘服务器的异步状态问题，让我领悟到要不断学习和进步；感谢蓝汛流媒体团队的各位同事，陪我走过我技术发展的黄金时期之一，尤其是文杰和刘岐能把蓝汛流媒体团队发展更上一层楼。感谢观止创想各位老大信任和支持我的管理方法和工作，以及认同SRS的架构在SRS基础上开发商用服务器平台。感谢所有关注和使用SRS的公司和用户，以及SRS的贡献者和主作者们，共同推动SRS向前发展。

SRS虽然是重新编码和架构(不使用一行任何公司的现有代码是开源软件的底线)，实际上过去三年在直播集群中积累的经验最重要。SRS是我对于软件设计和开发的一个总结，是我对于产品研发的最好诠释。周末没多少时间，不过好产品不是靠人力的，靠的是毅力，经验和信仰。我要做的是不断成长的产品，几十年的产品，不着急这一时半会儿。

入软件行业有10年，写代码有7年了，一直看一些书、反思、实践、再看书；书上众说纷纭，总得试一试看谁说的是对的；所以我做SRS只是当作形成自己体系的一个机会。古人说，不能记住你给别人的帮助，不能忘记别人对你的帮助。开源项目更多是不能记住你给别人的帮助。能做大的开源项目，往往聚集了一些同样是“不忘记别人对你的帮助”的这些人，才能一起推动项目发展。

商业公司永远无法做出我个人满意的产品，不是时间的原因。SRS一定会出现众多的修改闭源商业版本，但没有一个能比我的分支更完整和可延续。这就是因为不考虑利益时才能考虑长远的缘故。

srs必定广泛使用，如同漫天繁星散布渺渺宇宙，灿漫夏花开遍地球月球火星太阳系，愿蓝汛和观止创想财源广进，[SRSTeam](https://github.com/winlinvip/simple-rtmp-server/tree/1.0release#authors)永垂不朽，彪炳千古，哈哈哈!

Beijing, 2014.3<br/>
Winlin