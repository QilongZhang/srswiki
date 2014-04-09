# 应用实例

SRS真实的应用实例，大家可以添加自己的应用实例。（请拷贝最后的实例，修改成自己的）

## 某农场监控

2014.1

农场中摄像头支持RTSP访问，FFMPEG将RTSP转换成RTMP推送到SRS，flash客户端播放RTMP流。同时flash客户端可以和控制服务器通信，控制农场的浇水和施肥。

## 清华活动直播

2014.2

清华大学每周都会有活动，譬如名家演讲等，使用SRS支持，少量的机器即可满足高并发。

主要流程：
* 在教室使用播控系统（摄像机+采集卡或者摄像机+导播台）推送RTMP流到主SRS
* 主SRS自动Forward给从SRS（参考[Cluster](https://github.com/winlinvip/simple-rtmp-server/wiki/Cluster)）
* PC客户端（Flash）使用FlowerPlayer，支持多个服务器的负载均衡
* FlowerPlayer支持在两个主从SRS，自动选择一个服务器，实现负载均衡

主要的活动包括：
* 2014-02-23，丘成桐清华演讲

## IOS可以看的监控

2014.3

一般监控摄像头只支持输出RTMP/RTSP，或者支持RTSP方式读取流。如果想在IOS譬如IPad上看监控的流，怎么办？先部署一套rtmp服务器譬如nginx-rtmp/crtmpd/wowza/red5之类，然后用ffmpeg把rtsp流转成rtmp（或者摄像头直接推流到rtmp服务器），然后让服务器切片成hls输出，在IOS上观看。想想都觉得比较麻烦额，如果摄像头比较多怎么办？一个服务器还扛不住，部署集群？

最简单的方式是什么？摄像头自己支持输出HLS流不就好了？也就是摄像头有个内网ip作为服务器，摄像头给出一个hls的播放地址，IOS客户端譬如IPad可以播放这个HLS地址。

SRS最适合做这个事情，依赖很少，提供[arm编译脚本](https://github.com/winlinvip/simple-rtmp-server/wiki/SampleARM)，只需要[改下configure的交叉编译工具](https://github.com/winlinvip/simple-rtmp-server/wiki/SrsLinuxArm#%E4%BD%BF%E7%94%A8%E5%85%B6%E4%BB%96%E4%BA%A4%E5%8F%89%E7%BC%96%E8%AF%91%E5%B7%A5%E5%85%B7)就可以编译了。

主要流程：
* 编译arm下的srs，部署到树莓派，在摄像头中启动srs。
* 使用ffmpeg将摄像头的rtsp以RTMP方式推到srs。或者用自己程序采集设备数据推送RTMP流到srs。
* srs分发RTMP流和HLS流。其实PC上也可以看了。
* IOS譬如IPad上播放HLS地址。

## 网络摄像机

2014.4

网络摄像机使用hi3518芯片，如何用网页无插件直接观看网络摄像机的流呢？

目前有应用方式如下：
* hi3518上跑采集和推流程序（用srslibrtmp）
* 同时hi3518上还跑了srs/nginx-rtmp作为服务器
* 推流程序推到hi3518本机的nginx服务器
* PC上网页直接观看hi3518上的流

## 某工厂监控系统

2014.4

某工厂的监控系统主要组成：
* 采集端：采集端采用IPC摄像头安装在工厂重要监控位置，通过网线或者wifi连接到监控中心交换机。
* 监控中心：中心控制服务器，负责管理采集端和流媒体服务器，提供PC/Android/IOS观看平台。
* 流媒体服务器：负责接收采集端的流，提供观看端RTMP/HLS的流。
* 观看端：PC/Android/IOS。要求PC端的延迟在3秒内。Android/IOS延迟在20秒之内。

主要流程包括：
* 采集端启动：IPC摄像头像监控中心注册，获得发布地址，譬如：rtmp://myfactory/live/live1，并告知采集端一些信息，譬如摄像头的位置之类。
* 采集端开始推流：IPC摄像头使用librtmp发布到地址rtmp://myfactory/live/live1，即将音频视频数据推送到RTMP流媒体服务器。
* 流媒体服务器接收流：流媒体服务器使用SRS，接收采集端的RTMP流。FMS-3/3.5/4.5都有问题，估计是和librtmp对接问题。
* 观看端观看：用户使用PC/Android/IOS登录监控中心后，监控中心返回所有的摄像头信息和流地址。PC端使用flash，延迟在3秒之内；Android/IOS使用HLS，延迟在20秒之内。
* 时移：监控中心会开启录制计划，将RTMP流录制为FLV文件。用户可以在监控中心观看录制的历史视频。

## 实例名称

实例说明，[链接](http://yourlink)

Winlin 2014.2