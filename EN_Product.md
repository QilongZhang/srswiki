# SRS Roadmap

About the SRS History, Vision and Roadmap.

## Vision

SRS is industrial-strength live streaming cluster, for the best conceptual integrity and the simplest implementation.

* Industrial-strength: SRS provides high available(right now we know a CDN of China use SRS to delivery 100Gbps+ live stream), high performance, tracable log, reload and vhost for internet live video streaming industrial-strength group.
* Internet: SRS is refined again and again to get the best conceptual integrity and the simplest implementation, for the internet application is changed every day and evolve very fast, for everyone to master SRS in very short time.
* Live Streaming: SRS never support both VOD and Live, for these two streaming is very very different. We recomment the VOD to use HTTP protocol, and live which required low latency use RTMP, both RTMP and HTTP are ok for live without latency.
* Conceptual Integrity: SRS will refine again and again util code freezed to release. The integrity of conceptual is refined again and again. For example, we will finger out the tracable log, which involes identified id for each connection, and server id in response of RTMP, and upnode id for edge.
* Simplest Implementation: SRS never add features which is very hard to implement, and we will finger out the simplest architecture and logic code, we will do our best to keep the code as simple as we can. Maybe SRS does not provides lots of features, maybe the code is not eligance, but it's the most simple we can archive.

Notes: the conceptual integrity refer to Brooks.

## Release1.0

SRS release 1.0, about 1 year and the main aims:

* Live stream for internet application: the RTMP and HLS stream delivering, support any origin, encoder and player.
* Dozens of features, for example, Foward, Transcode, Ingest, DVR, to build your application very fast and stable. Comparing to FMS, user need a server-side dvr script and click the DVR button on FMLE, SRS only need 3lines conf to enable the dvr feature.
* Features for CDN, for example, the vhost, http api, reload, tracable log and wiki. Vhost is very important for CDN to serve multiple customers specified by vhost on the same live streaming platform. Reload is neccessary to adjust at any time. Tracable to finger out what happent when get problem.
* Full utest and benchmark mechenism: utest for core, kernel, protocol and some components of app. performance bechmark by gperf and gprof.
* For ARM and MIPS, SRS can running on raspberry-pi and cubieboard.

SRS 1.0 beta is ok at 2014.10. We plan to release SRS 1.0 at 2014.12.

## Release2.0

SRS release 2.0, about 6 months and the main aims:

* Research and simplify st, remove platform code to only support linux/arm.
* Simplify RTMP packet send mechenism, base on better knowlegement of st.
* Other small changes, for example, dvr to stream plan, add h264 to rtmp interface for srs-librtmp.

## Backlog

SRS 3.0+ features backlog:

* HTTP Streaming:
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/130" target="_blank">HLS edge</a>，
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/129" target="_blank">HTTP FLV delivering</a>，
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/83" target="_blank">HTTP API authentication</a>，
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/139" target="_blank">HLS fast cache</a>，
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/140" target="_blank">HTTP support vhost</a>，
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/52" target="_blank">HTTP trigger RTMP</a>，
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/174" target="_blank">HTTP-MP4 streaming</a>
* Enhanced RTMP Streaming:
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/106" target="_blank">RTMP call forward</a>，
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/92" target="_blank">RTMP302 Redirection</a>，
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/71" target="_blank">RTMP publish authentication</a>，
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/131" target="_blank">AMF3 codec</a>，
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/132" target="_blank">SharedObject and text delivery</a>，
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/156" target="_blank">Multiple stream over the same connection</a>，
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/163" target="_blank">Forward with extra parameters</a>，
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/164" target="_blank">Edge with extra parameters</a>，
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/93" target="_blank">RTMFP protocol</a>
* Realtime without latency:
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/120" target="_blank">FRSC realtime</a>，
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/94" target="_blank">UDP for server communication</a>
* RTSP Streaming:
<a href="https://github.com/winlinvip/simple-rtmp-server/issues/133" target="_blank">RTSP streaming</a>

SRS对于所有新功能都持推延态度；有悖于系统一致性和概念完整性的功能绝对不做，譬如支持Windows系统就有悖于一致性和完整性（服务器系统的差异太大）；对于确定要做的功能SRS也会仔细斟酌最佳方案，譬如支持多进程就是在选最佳方案；对于已有方案要做到最好，譬如最低延迟方案。对于功能点，只要属于系统一致性和概念完整性范围内都会考虑添加，或者说，大部分都不做，要做就要做到最好，the best or nothing!

## BigThanks

SRS是2013.9(2013.8.22提离职申请，理论上2013.9.22就离职，为了交接平稳我增加了交接时间)我从蓝汛离职后，我参考nginx_rtmp写了个简洁直播源站服务器。蓝汛接我工作的同事也可以看到服务器如何一步步构建。蓝汛的客户也可以用这个源站，那些乱七八糟的源站对接太麻烦。我想用业余时间构建不受客户随意影响的产品，只遵循核心价值而加入功能，而不是为了赚钱或者客户头脑发热，总之，实现我对于产品价值和质量，真正实现客户核心要求，定位清晰，一个实践现代软件工程和研发理念的服务器。

2013.10底加入观止负责研发管理工作。后来观止创想做编码器，编码器需要输出到rtmp服务器，nginx-rtmp又经常出问题，就打算用我的SRS替换nginx-rtmp。后来编码器上线过程中，我也逐步完善了SRS，是快速成长期。开放服务器，就让客户可以更好的用我们编码器，而且我们编码器可以支持拉模式。这个阶段主要是源站阶段。

2014.3进入反馈期，树苺派，极路由，cubieboard等嵌入式设备上有人问是否能支持。我自己买了树苺派，在上面运行成功，改了st的一个bug。从这个时候开始，是功能爆发的时期，得到群里童鞋们的反馈。转码，转发，采集，录制都是这个时期的工作。

2014.5，SRS功能冻结，测试和解决问题。我们公司扩大产品线，准备做VDN，视频分发网络，自然srs成为最佳选择。公司各位老大也一致认为srs的定位比较合适，一致商议决定直播服务器使用srs。SRS的功能都已经完善，VDN其他业务系统譬如监控和计费开始研发，我只有周末时间做SRS了。

2014.10，[SRS1.0](https://github.com/winlinvip/simple-rtmp-server/wiki/EN_Product#release10)beta发布，坐等大家反馈bug，如果没有bug就在2014年底发布[SRS1.0](https://github.com/winlinvip/simple-rtmp-server/wiki/EN_Product#release10)release。观止创想也准备在1.0release的基础上上研发下一代商用流媒体服务器。从0到1.0，SRS花了1年时间，[17](https://github.com/winlinvip/simple-rtmp-server/releases)个里程碑，[7](https://github.com/winlinvip/simple-rtmp-server/tree/1.0release#releases)个开发版，223个修订版，43700行功能代码，15616行utest代码，1803次提交，[161](https://github.com/winlinvip/simple-rtmp-server/issues)个bug和功能，解决了[117](https://github.com/winlinvip/simple-rtmp-server/issues?q=milestone%3A"srs+1.0+release")个，可在[1](https://github.com/winlinvip/simple-rtmp-server/tree/1.0release#system-requirements)个平台运行(linux)，支持4种cpu(x86/x64/arm/mips)，[11](https://github.com/winlinvip/simple-rtmp-server/tree/1.0release#about)个核心功能(origin、 [edge](https://github.com/winlinvip/simple-rtmp-server/wiki/EN_Edge)、 [vhost](https://github.com/winlinvip/simple-rtmp-server/wiki/EN_RtmpUrlVhost)、 [transcode](https://github.com/winlinvip/simple-rtmp-server/wiki/EN_FFMPEG)、 [ingest](https://github.com/winlinvip/simple-rtmp-server/wiki/EN_Ingest)、 [dvr](https://github.com/winlinvip/simple-rtmp-server/wiki/EN_DVR)、 [forward](https://github.com/winlinvip/simple-rtmp-server/wiki/EN_FFMPEG)、 [http-api](https://github.com/winlinvip/simple-rtmp-server/wiki/EN_HTTPApi)、 [http-callback](https://github.com/winlinvip/simple-rtmp-server/wiki/EN_HTTPCallback)、 [reload](https://github.com/winlinvip/simple-rtmp-server/wiki/EN_Reload)、 [tracable-log](https://github.com/winlinvip/simple-rtmp-server/wiki/EN_SrsLog))，[35](https://github.com/winlinvip/simple-rtmp-server/tree/1.0release#summary)个功能点，[58](https://github.com/winlinvip/simple-rtmp-server/wiki/EN_CNHome)篇wiki，SRS的QQ群有245位成员，活跃成员141人，[2](https://github.com/winlinvip/simple-rtmp-server/tree/1.0release#authors)位主作者，[12](https://github.com/winlinvip/simple-rtmp-server/blob/master/AUTHORS.txt)位贡献者，[14](https://github.com/winlinvip/simple-rtmp-server/tree/1.0release#donation)位捐赠者，至少有蓝汛、VeryCloud、VeryCDN、清华电视台在[使用或基于SRS改自己的服务器](https://github.com/winlinvip/simple-rtmp-server/wiki/EN_Sample)，数百个各种行业的公司在使用SRS主要包含视频监控、移动端、在线教育、秀场和KTV、互动视频、电视台、物联网、学生。

2014.10启动[SRS2.0](https://github.com/winlinvip/simple-rtmp-server/wiki/EN_Product#release20)研发，预计6个月左右的研发周期，主要目标是完全了解和掌握st，简化服务器的客户端模型，以及其他小功能的完善。比较[大的方向](https://github.com/winlinvip/simple-rtmp-server/wiki/EN_Product#backlog)在3.0+支持。

感谢我自己像个偏执狂一样独自坚持完成srs的定位，架构，编码，测试和文档。感谢父母的养育，老师的培养，尤其是初中的胡开群高昂老师，高中的周国文老师，大学的欧旭理老师。感谢刚毕业在大唐工作时何力对我的帮助，以及微软时期赵斌对于接口设计的教导。感谢蓝汛时期付亮副总裁，我的研发管理启蒙老师对我认可和支持；感谢蓝汛时期Micheal热情大气无私，以及精湛的能力教我解决蓝汛边缘服务器的异步状态问题，让我领悟到要不断学习和进步；感谢蓝汛流媒体团队的各位同事，陪我走过我技术发展的黄金时期之一，尤其是文杰和刘岐能把蓝汛流媒体团队发展更上一层楼。感谢观止创想各位老大信任和支持我的管理方法和工作，以及认同SRS的架构在SRS基础上开发商用服务器平台。感谢所有关注和使用SRS的公司和用户，以及SRS的贡献者和主作者们，共同推动SRS向前发展。

SRS虽然是重新编码和架构(不使用一行任何公司的现有代码是开源软件的底线)，实际上过去三年在直播集群中积累的经验最重要。SRS是我对于软件设计和开发的一个总结，是我对于产品研发的最好诠释。周末没多少时间，不过好产品不是靠人力的，靠的是毅力，经验和信仰。我要做的是不断成长的产品，几十年的产品，不着急这一时半会儿。

入软件行业有10年，写代码有7年了，一直看一些书、反思、实践、再看书；书上众说纷纭，总得试一试看谁说的是对的；所以我做SRS只是当作形成自己体系的一个机会。古人说，不能记住你给别人的帮助，不能忘记别人对你的帮助。开源项目更多是不能记住你给别人的帮助。能做大的开源项目，往往聚集了一些同样是“不忘记别人对你的帮助”的这些人，才能一起推动项目发展。

商业公司永远无法做出我个人满意的产品，不是时间的原因。SRS一定会出现众多的修改闭源商业版本，但没有一个能比我的分支更完整和可延续。这就是因为不考虑利益时才能考虑长远的缘故。

srs必定广泛使用，如同漫天繁星散布渺渺宇宙，灿漫夏花开遍地球月球火星太阳系，愿蓝汛和观止创想财源广进，[SRSTeam](https://github.com/winlinvip/simple-rtmp-server/tree/1.0release#authors)永垂不朽，彪炳千古，哈哈哈!

Winlin, 2014.10