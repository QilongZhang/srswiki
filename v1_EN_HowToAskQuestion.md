# How to Ask Question

Before you ask any question, please read the [Wiki](https://github.com/winlinvip/simple-rtmp-server/wiki) and try to answer the question yourself.

## FAQ

Some FAQs:

* How to build: [Build](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_CN_Build)
* The hardware required: [Build](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_CN_Build)
* The os required: [Build](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_CN_Build)
* Why publish/play failed when SRS start ok? Maybe you should disable selinux and stop iptables: [Build](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_CN_Build)
* How to use the cluster: [Cluster](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_Cluster)
* The performance benchmark: [Performance](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_CN_Performance)
* What is the license of SRS? Why MIT? Please see: [License](https://github.com/winlinvip/simple-rtmp-server/blob/master/LICENSE)
* How to run the demo pages of SRS: [Demo](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_CN_SampleDemo)
* The authors and contributors: [Readme](https://github.com/winlinvip/simple-rtmp-server/tree/1.0release#authors)
* The architecture of SRS: [Readme](https://github.com/winlinvip/simple-rtmp-server/tree/1.0release#architecture)
* The key features of SRS: [Readme](https://github.com/winlinvip/simple-rtmp-server/tree/1.0release#summary)
* The releases of SRS: [Readme](https://github.com/winlinvip/simple-rtmp-server/tree/1.0release#releases)
* Comparaton to other servers: [Compare](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_CN_Compare)
* The history of SRS: [Readme](https://github.com/winlinvip/simple-rtmp-server/tree/1.0release#history)

File new bug when you still have questions, please follow the following bug template.

## Bug Template

Please file bug with following description:
* Issue: the descrpition of your issue.
* Environment: os(32/64bits, version), server deploy architecture.
* StreamFlow: encoder info, how to publish to SRS, player how to play.
* SRS version: the version of SRS, you can get it by command `./objs/srs -v`
* Encoder: what is the detail info of encoder, the arguments of command line.
* SRS config: the config of SRS which you are using.
* SRS log: the detail log of SRS.
* Replay step: the description to replay the bug.

Winlin 2014.10