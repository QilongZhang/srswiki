[**HOME**](Home) > [**CN(1.0)**](v1_CN_Home)

## SRS Overview

SRS定位是运营级的互联网直播服务器集群，追求更好的概念完整性和最简单实现的代码。SRS提供了丰富的接入方案将RTMP流接入SRS，包括[[推送RTMP到SRS | v1_CN_SampleRTMP ]]、[[拉取流到SRS | v1_CN_Ingest]]。SRS还支持将接入的RTMP流进行各种变换，譬如[[直播流转码 | v1_CN_SampleFFMPEG]]、[[转发给其他服务器 | v1_CN_SampleForward]]、[[转封装成HLS | v1_CN_SampleHLS]]、[[录制成FLV | v1_CN_DVR]]。SRS包含支大规模集群如CDN业务的关键特性，譬如[[RTMP多级集群 | v1_CN_SampleRTMPCluster]]、[[VHOST虚拟服务器  | v1_CN_RtmpUrlVhost]]、[[无中断服务Reload | v1_CN_Reload]]。此外，SRS还提供丰富的应用接口，包括[[HTTP回调 | v1_CN_HTTPCallback]]、[[HTTP API接口 | v1_CN_HTTPApi]]、[[RTMP测速 | v1_CN_BandwidthTestTool]]。

WIKI是开发者的主要文档。若需要下载安装包，请访问[**ossrs.net**][website].

## Quick navigation

| 关于SRS             | 项目              | 安装设置          | 文档                  |
|----------------------------|---------------------------------|-------------------------------|---------------------------|
| [[/images/help.png]] | [[/images/users.png]] | [[/images/tools.png]] | [[/images/database.png]] |
| [[关于SRS| v1_CN_Product]] | [[项目| v1_CN_Project]]       | [[安装设置| v1_CN_Setup]] | [[文档| v1_CN_Docs]]|
| 关于SRS的背景和产品定位 | 关于SRS项目，如何贡献代码 | 如何一步一步安装和运行SRS | SRS的详细技术资料 |

备注：请点击上面的链接进入，譬如点击安装设置，进入如何安装和设置SRS页面。

## Questions or need help?

其他联系方式，参考[联系我们](v1_CN_Contact)

Winlin 2015.3

[st]: https://github.com/winlinvip/state-threads
[website]: http://ossrs.net