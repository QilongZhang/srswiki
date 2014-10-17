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

SRS features: the best or nothing!

## BigThanks

2013.9, I leave ChinaCache and create SRS at 2013.10 to show how to codec the RTMP for the colleagues to maintain the SmartServer, which is for ChinaCache wrote by winlin.

2013.10, I join Chnvideo as the team leader of developers. Chnvideo encoder publish stream to nginx-rtmp in the ancient time, but nginx-rtmp always crash or timestamp fault, so Chnvideo start to use SRS as RTMP server.

2013.4, support arm and mips, for example, raspberry-pi, cubieboard, and hiwifi. Most of important SRS features is created during this period, for example, transcode, forward, ingest, dvr and edge.

2014.5, features freezed, start to test and fix bug. Chnvideo plan to use SRS in some product.

2014.10，[SRS1.0](https://github.com/winlinvip/simple-rtmp-server/wiki/EN_Product#release10)beta is ok, waiting for bugs and 1.0 will be released at 2014.12. SRS 1.0, total 1 year, [17](https://github.com/winlinvip/simple-rtmp-server/releases)milestones, [7](https://github.com/winlinvip/simple-rtmp-server/tree/1.0release#releases)mainline versions, 223 revisions, 43700 lines feature code, 15616 lines utest code, 1803 commits, [161](https://github.com/winlinvip/simple-rtmp-server/issues) bugs and features, [117](https://github.com/winlinvip/simple-rtmp-server/issues?q=milestone%3A"srs+1.0+release")bugs fixed, [1](https://github.com/winlinvip/simple-rtmp-server/tree/1.0release#system-requirements)os supported(linux), 4 cpu(x86/x64/arm/mips), [11](https://github.com/winlinvip/simple-rtmp-server/tree/1.0release#about)kernel features(origin、 [edge](https://github.com/winlinvip/simple-rtmp-server/wiki/EN_Edge)、 [vhost](https://github.com/winlinvip/simple-rtmp-server/wiki/EN_RtmpUrlVhost)、 [transcode](https://github.com/winlinvip/simple-rtmp-server/wiki/EN_FFMPEG)、 [ingest](https://github.com/winlinvip/simple-rtmp-server/wiki/EN_Ingest)、 [dvr](https://github.com/winlinvip/simple-rtmp-server/wiki/EN_DVR)、 [forward](https://github.com/winlinvip/simple-rtmp-server/wiki/EN_FFMPEG)、 [http-api](https://github.com/winlinvip/simple-rtmp-server/wiki/EN_HTTPApi)、 [http-callback](https://github.com/winlinvip/simple-rtmp-server/wiki/EN_HTTPCallback)、 [reload](https://github.com/winlinvip/simple-rtmp-server/wiki/EN_Reload)、 [tracable-log](https://github.com/winlinvip/simple-rtmp-server/wiki/EN_SrsLog))，[35](https://github.com/winlinvip/simple-rtmp-server/tree/1.0release#summary)features，[58](https://github.com/winlinvip/simple-rtmp-server/wiki/EN_CNHome) wiki，[2](https://github.com/winlinvip/simple-rtmp-server/tree/1.0release#authors)primary authors，[12](https://github.com/winlinvip/simple-rtmp-server/blob/master/AUTHORS.txt)contributors，[14](https://github.com/winlinvip/simple-rtmp-server/tree/1.0release#donation)donation，ChinaCache、VeryCloud、VeryCDN、Tsinghua[use or develop on SRS](https://github.com/winlinvip/simple-rtmp-server/wiki/EN_Sample)，100 companies use SRS.

2014.10 startup [SRS2.0](https://github.com/winlinvip/simple-rtmp-server/wiki/EN_Product#release20)develop，6 months to comlete，to research and master st, simplify client packet send model, with other small feature refine. [Other features](https://github.com/winlinvip/simple-rtmp-server/wiki/EN_Product#backlog) postpone to 3.0+。

感谢我自己像个偏执狂一样独自坚持完成srs的定位，架构，编码，测试和文档。感谢父母的养育，老师的培养，尤其是初中的胡开群高昂老师，高中的周国文老师，大学的欧旭理老师。感谢刚毕业在大唐工作时何力对我的帮助，以及微软时期赵斌对于接口设计的教导。感谢蓝汛时期付亮副总裁，我的研发管理启蒙老师对我认可和支持；感谢蓝汛时期Micheal热情大气无私，以及精湛的能力教我解决蓝汛边缘服务器的异步状态问题，让我领悟到要不断学习和进步；感谢蓝汛流媒体团队的各位同事，陪我走过我技术发展的黄金时期之一，尤其是文杰和刘岐能把蓝汛流媒体团队发展更上一层楼。感谢观止创想各位老大信任和支持我的管理方法和工作，以及认同SRS的架构在SRS基础上开发商用服务器平台。感谢所有关注和使用SRS的公司和用户，以及SRS的贡献者和主作者们，共同推动SRS向前发展。

SRS虽然是重新编码和架构(不使用一行任何公司的现有代码是开源软件的底线)，实际上过去三年在直播集群中积累的经验最重要。SRS是我对于软件设计和开发的一个总结，是我对于产品研发的最好诠释。周末没多少时间，不过好产品不是靠人力的，靠的是毅力，经验和信仰。我要做的是不断成长的产品，几十年的产品，不着急这一时半会儿。

入软件行业有10年，写代码有7年了，一直看一些书、反思、实践、再看书；书上众说纷纭，总得试一试看谁说的是对的；所以我做SRS只是当作形成自己体系的一个机会。古人说，不能记住你给别人的帮助，不能忘记别人对你的帮助。开源项目更多是不能记住你给别人的帮助。能做大的开源项目，往往聚集了一些同样是“不忘记别人对你的帮助”的这些人，才能一起推动项目发展。

商业公司永远无法做出我个人满意的产品，不是时间的原因。SRS一定会出现众多的修改闭源商业版本，但没有一个能比我的分支更完整和可延续。这就是因为不考虑利益时才能考虑长远的缘故。

srs必定广泛使用，如同漫天繁星散布渺渺宇宙，灿漫夏花开遍地球月球火星太阳系，愿蓝汛和观止创想财源广进，[SRSTeam](https://github.com/winlinvip/simple-rtmp-server/tree/1.0release#authors)永垂不朽，彪炳千古，哈哈哈!

Winlin, 2014.10