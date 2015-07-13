[**HOME**](Home) > [**CN(1.0)**](v1_CN_Home)

## SRS Overview

SRS is industrial-strength live streaming cluster, for the best conceptual integrity and the simplest implementation. SRS provides variety of inputs, for example, [[Push RTMP to SRS | v1_EN_SampleRTMP ]], [[Pull Stream to SRS | v1_EN_Ingest]]. SRS can transform the RTMP to other protocols or deliveries, for example, [[RTMP Transcode | v1_EN_SampleFFMPEG]], [[Forward to Other Servers | v1_EN_SampleForward]], [[Remux to HLS | v1_EN_SampleHLS]], [[DVR to FLV | v1_CN_DVR]]. SRS canbe used in CDN for large stream clusters, for example, [[RTMP Cluster | v1_CN_SampleRTMPCluster]], [[VHOST | v1_CN_RtmpUrlVhost]], [[Reload | v1_CN_Reload]]. Futhermore, SRS provides apis, for example, [[HTTP Callback | v1_CN_HTTPCallback]], [[HTTP API | v1_CN_HTTPApi]], [[RTMP Bandwidth Test | v1_CN_BandwidthTestTool]].

## Downloading

Get SRS from the [downloads page][website] of the project website. If you'd like to build SRS from scratch, visit [[Build SRS | v1_CN_Build]].

SRS runs on Linuxs, for instace, Centos and Ubuntu, and x86, x86-64, ARM and MIPS is ok. MacOS only supports code edit and build. SRS does not support other Unix-like system, neither windows. SRS build on the coroutine library [state-threads][st], which simplify the complex protocol imlementations.

SRS is easy to run on a machine, or multiple machines, to run the cluster. SRS is single process, not multiple processes model.

## Where to Go from Here

***User Guides:***

* [Quick Start][qstart]: A quick introduction of SRS, please start here.
* [[Why SRS|v1_CN_Product]]: Why you should choose SRS? What's the roadmap?
* [GIT Mirrors][mirrors]: The GIT mirrors of SRS to get SRS faster.
* [Main Features][features]: The features list of SRS. Some features is introduced from specified version; while some features are experiment.
* [Releases][releases]: The released versions of SRS.
* [[Docs|v1_CN_Docs]]: The detail tech docs of SRS.

**Deployment Guides:***

* [[RTMP Server|v1_CN_SampleRTMP]]: How to delivery RTMP using SRS.
* [[Delivery HLS|v1_CN_SampleHLS]]: How to delivery RTMP and HLS using SRS.
* [[Transcode|v1_CN_SampleFFMPEG]]: How to transcode the RTMP stream.
* [[Forward|v1_CN_SampleForward]]: How to forward RTMP to other servers.
* [[Low latency|v1_CN_SampleRealtime]]: How to deploy the low latency SRS.
* [[Ingest|v1_CN_SampleIngest]]: How to ingest other streams to SRS.
* [[HTTP Server|v1_CN_SampleHTTP]]: How to deploy SRS as HTTP server.
* [[SRS DEMO|v1_CN_SampleDemo]]: How to deploy the demo of SRS.
* [[Projects|v1_CN_Sample]]: Who are using SRS.
* [[Setup|v1_CN_Setup]]: How to setup SRS.

**Benchmarks:***

* [Performance][performance]: The performance benchmark.

**Join Us:***

* [Donation][donation]: Donate SRS.
* [File Issue][issue]: File an issue.
* [[Contact|v1_CN_Contact]]: Contact us.

## Questions or need help?

For any help, [contact us](v1_CN_Contact).

Winlin 2015.7

[st]: https://github.com/winlinvip/state-threads
[website]: http://ossrs.net

[qstart]: https://github.com/simple-rtmp-server/srs/tree/1.0release#usage
[mirrors]: https://github.com/simple-rtmp-server/srs/tree/1.0release#mirrors
[features]: https://github.com/simple-rtmp-server/srs/tree/1.0release#summary
[releases]: https://github.com/simple-rtmp-server/srs/tree/1.0release#releases

[donation]: http://www.ossrs.net/srs.release/donation/index.html
[issue]: https://github.com/simple-rtmp-server/srs/issues/new

[performance]: https://github.com/simple-rtmp-server/srs/tree/1.0release#performance