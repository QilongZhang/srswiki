# SRS Roadmap

About the SRS History, Vision and Roadmap.

## Vision

SRS is industrial-strength live streaming cluster, for the best conceptual integrity and the simplest implementation.

* Industrial-strength: SRS provides a high availability (right now we know of a Chinese CDN using SRS to deliver 100Gbps+ of live streaming media), high performance, industrial strength Internet live video streaming solution with traceable logs, reloading and vhost support.
* Internet: SRS is refined again and again to get the best conceptual integrity and the simplest implementation, because the internet application changes every day and evolves very fast, for everyone to master SRS in very short time.
* Live Streaming: SRS will never support both VOD and Live, because these two kinds of streaming are very very different. We recommend that VOD use HTTP, and live which requires low latency use RTMP, while both RTMP and HTTP are okay for live without low latency requirements.
* Conceptual Integrity: SRS will be refined again and again until the code is frozen for release. The conceptual integrity is refined again and again. For example, we will figure out the traceable log, which involves identifying an identifier for each connection, and a server ID in the RTMP response, and upnode ID for the edge.
* Simplest Implementation: SRS will never add features which are very hard to implement, and we will figure out the simplest architecture and logic for the code. We will do our best to keep the code as simple as we can. Maybe SRS does not provide lots of features, maybe the code is not elegant, but it's the  simplest we can achieve.

Notes: for conceptual integrity refer to Brooks.

## Release1.0

Dev code: HuKaiqun, my teacher.

[SRS release 1.0](https://github.com/simple-rtmp-server/srs/tree/1.0release), took about 1 year, with these main goals:

* Live stream for internet applications: RTMP and HLS stream delivery, supporting any origin, encoder and player.
* Dozens of features, such as Foward, Transcode, Ingest, and DVR for example, so that you can build your application very fast and stably. Compared to FMS, where the user needs a server-side DVR script and to click the DVR button on FMLE, SRS only need 3 lines of configuration to enable the DVR feature.
* Features for CDN, for example: vhosts, HTTP API, reloading, traceable logs and a wiki. Vhost is very important for CDN to serve multiple customers specified by vhost on the same live streaming platform. Reload is necessary to make adjustments at any time. Traceability to figure out what happens when a problem occurs.
* Full utest and benchmark mechanism: utest for core, kernel, protocol and some components of the application. Performance bechmarking by gperf and gprof.
* For ARM and MIPS, SRS can run on raspberry-pi and cubieboard.
* High performance: supports 2.7k clients.

[SRS Release 1.0](https://github.com/simple-rtmp-server/srs/tree/1.0release) already released at 2014.12.5.

## Release2.0

Dev code: ZhouGuowen, my teacher.

[SRS release 2.0](https://github.com/simple-rtmp-server/srs/tree/2.0release), took about 6 months, with these main goals:

* Support English wiki (EN+CN).
* Enhance performance, supports playing 10k+ streams and publishing 4.5k+ streams. Read [#194](https://github.com/simple-rtmp-server/srs/issues/194), [#237](https://github.com/simple-rtmp-server/srs/issues/237) and [#251](https://github.com/simple-rtmp-server/srs/issues/251)
* The srs-librtmp supports publishing h.264 and aac raw stream. Read [#66](https://github.com/simple-rtmp-server/srs/issues/66) and [#212](https://github.com/simple-rtmp-server/srs/issues/212)
* Research and simplify st, remove platform code to only support linux/arm. Read [#182](https://github.com/simple-rtmp-server/srs/issues/182)
* Support srs-librtmp compilation on windows, read [bug #213](https://github.com/simple-rtmp-server/srs/issues/213) and [srs-librtmp](https://github.com/winlinvip/srs.librtmp)
* Simplify the handshake, use template method to remove union. Read [#235](https://github.com/simple-rtmp-server/srs/issues/235) 
* The srs-librtmp supports hijack io for [st-load](https://github.com/winlinvip/st-load).
* Support min-latency(realtime) mode, 0.1s+ latency. Read [#257](https://github.com/simple-rtmp-server/srs/issues/257#issuecomment-66773208)
* Support security features allow/deny publish/play all/ip. Read [#211](https://github.com/simple-rtmp-server/srs/issues/211)
* Support [custom dvr path](https://github.com/simple-rtmp-server/srs/issues/179) 
and [dvr http callback](https://github.com/simple-rtmp-server/srs/issues/274).
* Rewrite the embedded HTTP server, refer to go HTTP. Read [#277](https://github.com/simple-rtmp-server/srs/issues/277).
* Remux RTMP to HTTP flv/mp3/aac/ts live stream, read [#293](https://github.com/simple-rtmp-server/srs/issues/293).
* Support HLS in RAM, without writing to disk. Read [#136](https://github.com/simple-rtmp-server/srs/issues/136).
* Enhanced DVR, support append/callback, read [#179](https://github.com/simple-rtmp-server/srs/issues/179).
* Enhanced HTTP API, support query stream/vhost, read [#316](https://github.com/simple-rtmp-server/srs/issues/316).
* Support HSTRS(http stream trigger ramp source), for HTTP-FLV standby and edge server, read [#324](https://github.com/simple-rtmp-server/srs/issues/324).
* [experimental]Support HDS, read [#328](https://github.com/simple-rtmp-server/srs/issues/328).
* [experimental]Support push MPEG-TS over UDP to SRS, read [#250](https://github.com/simple-rtmp-server/srs/issues/250).
* [experimental]Support push RTSP to SRS, read [#133](https://github.com/simple-rtmp-server/srs/issues/133).
* [experimental]Support remote console management, read [console](http://ossrs.net:1985/console).
* Other small changes.

[SRS Release 2.0](https://github.com/simple-rtmp-server/srs/tree/2.0release) planned release on 2015.12.

## Release3.0

Dev code: OuXuli, my college teach, the founder of [Qgzxol.com](http://www.qgzxol.com).

[SRS release 3.0](https://github.com/simple-rtmp-server/srs/tree/develop), is being researched now, no milestone yet. The main goals may include:

* Research SRS.GO, implements SRS in go language, read [SRS.GO project](https://github.com/winlinvip/srs.go) and the [GO Performance Benchmark](http://blog.csdn.net/win_lin/article/details/41379799)
* Support H.265, push RTMP with H.265, delivery in HLS.
* Support MPEG-DASH, the future streaming protocol.
* Support HTTP edge server.
* Support Spark big-data.
* Others.

[SRS Release 3.0][develop] plan to release at 2016.12.

## Backlog

SRS 3.0+ features backlog:

* HTTP Streaming：[HLS Edge][bug130]，[HTTP API Authencation][bug83]，[Callback for HTTP][bug52]，[HTTP-MP4 Streaming][bug174]
* Enhanced RTMP: [Forward Call][bug106]，[RTMP 302 Redirect][bug92]，[RTMP Token][bug71]，[AMF3][bug131]，[SharedObject][bug132]，[Multiple Streams per Connection][bug156]，[Forward With extra params][bug163]，[Edge with extra params][bug164]，[RTMFP][bug93]
* Realtime：[FRSC][bug90]，[UDP in cluster][bug94]

SRS features: the best or nothing!

## BigThanks

2013.9, I leave ChinaCache and create SRS at 2013.10 to show how to codec the RTMP for colleagues to maintain the SmartServer, which is for ChinaCache written by winlin.

2013.10, I join Chnvideo as the team leader of developers. Chnvideo encoder used to publish streams to nginx-rtmp before, but nginx-rtmp always crashed or had timestamp faults, so Chnvideo started to use SRS as the RTMP server.

2013.4, supported arm and mips, for example, raspberry-pi, cubieboard, and hiwifi. Most of the important SRS features were created during this period, for example: transcode, forward, ingest, DVR and edge.

2014.5, feature freeze, began to test and fix bug. Chnvideo planning to use SRS in some products.

2014.10，[SRS1.0](v1_EN_Product#release10) beta is OK, waiting for bug reports and fixes and then 1.0 will be released at 2014.12. SRS 1.0, total of 1 year, [17](https://github.com/simple-rtmp-server/srs/releases)milestones, [7](https://github.com/simple-rtmp-server/srs/tree/1.0release#releases) mainline versions, 223 revisions, 43700 lines of feature code, 15616 lines of utest code, 1803 commits, [161](https://github.com/simple-rtmp-server/srs/issues) bugs and features, [117](https://github.com/simple-rtmp-server/srs/issues?q=milestone%3A"srs+1.0+release") bugs fixed, [1](https://github.com/simple-rtmp-server/srs/tree/1.0release#system-requirements) OS supported (Linux), 4 CPU architectures (x86/x64/arm/mips), [11](https://github.com/simple-rtmp-server/srs/tree/1.0release#about) kernel features( origin、 [edge](v1_EN_Edge)、 [vhost](v1_EN_RtmpUrlVhost)、 [transcode](v1_EN_FFMPEG)、 [ingest](v1_EN_Ingest)、 [DVR](v1_EN_DVR)、 [forward](v1_EN_FFMPEG)、 [HTTP-API](v1_EN_HTTPApi)、 [HTTP-callback](v1_EN_HTTPCallback)、 [reload](v1_EN_Reload)、 [traceable-log](v1_EN_SrsLog))，[35](https://github.com/simple-rtmp-server/srs/tree/1.0release#summary) features，[58](v1_EN_Home) wiki，[2](https://github.com/simple-rtmp-server/srs/tree/1.0release#authors) primary authors，[12](https://github.com/simple-rtmp-server/srs/blob/master/AUTHORS.txt) contributors，[14](https://github.com/simple-rtmp-server/srs/tree/1.0release#donation) donations，ChinaCache、VeryCloud、VeryCDN、Tsinghua [use or develop on SRS](v1_EN_Sample)，100 companies use SRS.

2014.10 start [SRS2.0](v1_EN_Product#release20) development，6 months to complete，To research and master st, simplify client packet send model, and refine other small features. [Other features](v1_EN_Product#backlog) postponed to 3.0+。

Thanks to winlin for creating, architecting, coding, testing and writing the wiki for SRS. Thanks to my parents and teachers. Thanks to my colleagues who helped me. Thanks to all contributors and users of SRS. Let's push SRS to be better together~

SRS will be a very important member for server software development.

Winlin, 2014.10

[bug133]: https://github.com/simple-rtmp-server/srs/issues/133
[bug94]: https://github.com/simple-rtmp-server/srs/issues/94
[bug90]: https://github.com/simple-rtmp-server/srs/issues/120
[bug93]: https://github.com/simple-rtmp-server/srs/issues/93
[bug164]: https://github.com/simple-rtmp-server/srs/issues/164
[bug163]: https://github.com/simple-rtmp-server/srs/issues/163
[bug156]: https://github.com/simple-rtmp-server/srs/issues/156
[bug132]: https://github.com/simple-rtmp-server/srs/issues/132
[bug131]: https://github.com/simple-rtmp-server/srs/issues/131
[bug71]: https://github.com/simple-rtmp-server/srs/issues/71
[bug92]: https://github.com/simple-rtmp-server/srs/issues/92
[bug106]: https://github.com/simple-rtmp-server/srs/issues/106
[bug174]: https://github.com/simple-rtmp-server/srs/issues/174
[bug52]: https://github.com/simple-rtmp-server/srs/issues/52
[bug83]: https://github.com/simple-rtmp-server/srs/issues/83
[bug130]: https://github.com/simple-rtmp-server/srs/issues/130
[bug250]: https://github.com/simple-rtmp-server/srs/issues/250
[bug324]: https://github.com/simple-rtmp-server/srs/issues/324
[bug328]: https://github.com/simple-rtmp-server/srs/issues/328
[bug316]: https://github.com/simple-rtmp-server/srs/issues/316
[bug179]: https://github.com/simple-rtmp-server/srs/issues/179
[bug136]: https://github.com/simple-rtmp-server/srs/issues/136
[bug293]: https://github.com/simple-rtmp-server/srs/issues/293
[bug194]: https://github.com/simple-rtmp-server/srs/issues/194
[bug237]: https://github.com/simple-rtmp-server/srs/issues/237
[bug251]: https://github.com/simple-rtmp-server/srs/issues/251
[bug66]: https://github.com/simple-rtmp-server/srs/issues/66
[bug212]: https://github.com/simple-rtmp-server/srs/issues/212
[bug182]: https://github.com/simple-rtmp-server/srs/issues/182
[bug213]: https://github.com/simple-rtmp-server/srs/issues/213
[bug235]: https://github.com/simple-rtmp-server/srs/issues/235
[bug257]: https://github.com/simple-rtmp-server/srs/issues/257#issuecomment-66773208
[bug211]: https://github.com/simple-rtmp-server/srs/issues/211
[bug179]: https://github.com/simple-rtmp-server/srs/issues/179
[bug274]: https://github.com/simple-rtmp-server/srs/issues/274
[bug277]: https://github.com/simple-rtmp-server/srs/issues/277
[bug367]: https://github.com/simple-rtmp-server/srs/issues/367

[develop]: https://github.com/simple-rtmp-server/srs/tree/develop
[2.0release]: https://github.com/simple-rtmp-server/srs/tree/2.0release
[1.0release]: https://github.com/simple-rtmp-server/srs/tree/1.0release
[p2.0release]: https://github.com/simple-rtmp-server/srs/wiki/v1_CN_Product#release20
[p1.0release]: https://github.com/simple-rtmp-server/srs/wiki/v1_CN_Product#release10
[backlog]: https://github.com/simple-rtmp-server/srs/wiki/v1_CN_Product#backlog
[donations]: https://github.com/simple-rtmp-server/srs/blob/develop/DONATIONS.txt
[issues]: https://github.com/simple-rtmp-server/srs/issues
[releases]: https://github.com/simple-rtmp-server/srs/releases
[authors]: https://github.com/simple-rtmp-server/srs/tree/develop#authors
[librtmp]: https://github.com/winlinvip/srs.librtmp
[load]: https://github.com/winlinvip/st-load

[blog_go]: http://blog.csdn.net/win_lin/article/details/41379799
[srs_go]: https://github.com/winlinvip/srs.go
[qgzxol]: http://www.qgzxol.com