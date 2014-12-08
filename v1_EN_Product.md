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
* High performance, supports 2.7k clients.

[SRS Release 1.0](https://github.com/winlinvip/simple-rtmp-server/releases/tag/1.0) already released at 2014.12.5.

The hotfixes of SRS 1.0, read [hotfixes](https://github.com/winlinvip/simple-rtmp-server/compare/1.0...1.0release)

## Release2.0

SRS release 2.0, about 6 months and the main aims:

* Support English wiki(EN+CN).
* Enhance performance, supports 7.5k+ play and 4.5k+ publish. Read [#194](https://github.com/winlinvip/simple-rtmp-server/issues/194) and [#237](https://github.com/winlinvip/simple-rtmp-server/issues/237)
* The srs-librtmp supports publish h.264 and aac raw stream. Read [#66](https://github.com/winlinvip/simple-rtmp-server/issues/66) and [#212](https://github.com/winlinvip/simple-rtmp-server/issues/212)
* Research and simplify st, remove platform code to only support linux/arm. Read [#182](https://github.com/winlinvip/simple-rtmp-server/issues/182)
* The srs-librtmp compile on windows, read [bug #213](https://github.com/winlinvip/simple-rtmp-server/issues/213) and [srs-librtmp](https://github.com/winlinvip/srs.librtmp)
* Simplify the handshake, use template method to remove union. Read [#235](https://github.com/winlinvip/simple-rtmp-server/issues/235) 
* The srs-librtmp supports hijack io for [st-load](https://github.com/winlinvip/st-load).
* Other small changes.

## Release3.0

SRS release 3.0, in researching now, no milestone. The main aims:

* SRS.GO, implements srs in go language, read [SRS.GO project](https://github.com/winlinvip/srs.go) and the [GO Performance Benchmark](http://blog.csdn.net/win_lin/article/details/41379799)

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

2014.10，[SRS1.0](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_Product#release10)beta is ok, waiting for bugs and 1.0 will be released at 2014.12. SRS 1.0, total 1 year, [17](https://github.com/winlinvip/simple-rtmp-server/releases)milestones, [7](https://github.com/winlinvip/simple-rtmp-server/tree/1.0release#releases)mainline versions, 223 revisions, 43700 lines feature code, 15616 lines utest code, 1803 commits, [161](https://github.com/winlinvip/simple-rtmp-server/issues) bugs and features, [117](https://github.com/winlinvip/simple-rtmp-server/issues?q=milestone%3A"srs+1.0+release")bugs fixed, [1](https://github.com/winlinvip/simple-rtmp-server/tree/1.0release#system-requirements)os supported(linux), 4 cpu(x86/x64/arm/mips), [11](https://github.com/winlinvip/simple-rtmp-server/tree/1.0release#about)kernel features(origin、 [edge](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_Edge)、 [vhost](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_RtmpUrlVhost)、 [transcode](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_FFMPEG)、 [ingest](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_Ingest)、 [dvr](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_DVR)、 [forward](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_FFMPEG)、 [http-api](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_HTTPApi)、 [http-callback](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_HTTPCallback)、 [reload](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_Reload)、 [tracable-log](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_SrsLog))，[35](https://github.com/winlinvip/simple-rtmp-server/tree/1.0release#summary)features，[58](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_Home) wiki，[2](https://github.com/winlinvip/simple-rtmp-server/tree/1.0release#authors)primary authors，[12](https://github.com/winlinvip/simple-rtmp-server/blob/master/AUTHORS.txt)contributors，[14](https://github.com/winlinvip/simple-rtmp-server/tree/1.0release#donation)donation，ChinaCache、VeryCloud、VeryCDN、Tsinghua[use or develop on SRS](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_Sample)，100 companies use SRS.

2014.10 startup [SRS2.0](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_Product#release20)develop，6 months to comlete，to research and master st, simplify client packet send model, with other small feature refine. [Other features](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_Product#backlog) postpone to 3.0+。

Thanks winlin to create, arch, coding, test and write wiki for SRS. Thanks for my parents and teachers. Thanks colleague who help me. Thanks all contributors and users of SRS. Let's push SRS to be better together~

SRS will be a very important member for server software development.

Winlin, 2014.10