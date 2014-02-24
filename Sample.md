# 应用实例

SRS真实的应用实例，大家可以添加自己的应用实例。（请拷贝最后的实例，修改成自己的）

## 某农场监控

农场中摄像头支持RTSP访问，FFMPEG将RTSP转换成RTMP推送到SRS，flash客户端播放RTMP流。同时flash客户端可以和控制服务器通信，控制农场的浇水和施肥。

## 清华活动直播

清华大学每周都会有活动，譬如名家演讲等，使用SRS支持，少量的机器即可满足高并发。

主要流程：
* 在教室使用播控系统（摄像机+采集卡或者摄像机+导播台）推送RTMP流到主SRS
* 主SRS自动Forward给从SRS（参考[Cluster](https://github.com/winlinvip/simple-rtmp-server/wiki/Cluster)）
* PC客户端（Flash）使用FlowerPlayer，支持多个服务器的负载均衡
* FlowerPlayer支持在两个主从SRS，自动选择一个服务器，实现负载均衡

主要的活动包括：
* 2014-02-23，丘成桐清华演讲

## 实例名称

实例说明，[链接](http://yourlink)