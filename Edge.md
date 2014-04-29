# Edge边缘服务器

SRS的Edge提供访问时回源机制，在CDN/VDN等流众多的应用场景中有重大意义，forward/ingest方案会造成大量带宽浪费。同时，SRS的Edge能对接所有的RTMP源站服务器，不像FMS的Edge只能对接FMS源站（有私有协议）；另外，SRS的Edge支持SRS源站的所有逻辑（譬如转码，转发，HLS，DVR等等），也就是说可以选择在源站切片HLS，也可以直接在边缘切片HLS。

备注：Edge往往需要配合多进程，SRS的多进程在计划之中。

Edge的主要应用场景：
* CDN/VDN大规模集群，客户众多流众多需要按需回源。
* 小规模集群，但是流比较多，需要按需回源。
* 骨干带宽低，边缘服务器强悍，可以内部分发RTMP后边缘切片HLS，避免RTMP和HLS都回源。

## 配置

edge属于vhost的配置，将某个vhost配置为edge后，该vhost会回源取流（播放时）或者将流转发给源站（发布时）。

```bash
vhost __defaultVhost__ {
    # the mode of vhost, local or remote.
    #       local: vhost is origin vhost, which provides stream source.
    #       remote: vhost is edge vhost, which pull/push to origin.
    # default: local
    mode            remote;
    # for edge(remote mode), user must specifies the origin server
    # format as: <server_name|ip>[:port]
    # @remark user can specifies multiple origin for error backup, by space,
    # for example, 192.168.1.100:1935 192.168.1.101:1935 192.168.1.102:1935
    origin          127.0.0.1:1935 localhost:1935;
}
```

可配置`多个`源站，在故障时会切换到下一个源站。

## 下行边缘结构设计

下行边缘指的是下行加速边缘，即客户端播放边缘服务器的流，边缘服务器从上层或源站取流。

SRS下行边缘是非常重要的功能，需要考虑以下因素：
* 以后支持多进程时结构变动最小。
* 和目前所有功能的对接良好。
* 支持平滑切换，源站和边缘两种角色。

权衡后，SRS下行边缘的结构设计如下：
* 客户端连接到SRS
* 开始播放SRS的流
* 若流存在则直接播放。
* 若流不存在，则从源站开始取流。
* 其他其他流的功能，譬如转码/转发/采集等等。

核心原则是：
* 边缘服务器在没有流时，向源站拉取流。
* 当流建立起来后，边缘完全变成源站服务器，对流的处理逻辑保持一致。
* 支持回多个源站，错误时切换。这样可以支持上层服务器热备。

备注：RTMP多进程（计划中）的核心原则是用多进程作为完全镜像代理，连接到本地的服务器（源站或边缘），完全不考虑其他业务因素，透明代理。这样可以简单，而且利用多CPU能力。HTTP多进程是不考虑支持的，用NGINX是最好选择，SRS的HTTP服务器只是用在嵌入式设备中，没有性能要求的场合。

## 上行边缘结构设计

上行边缘指的是上行推流加速，客户端推流到边缘服务器，边缘将流转发给源站服务器。

考虑到下行和上行可能同时发生在一台边缘服务器，所以上行边缘只能用最简单的代理方式，完全将流代理到上层或源站服务器。也就是说，只有在下行边缘时，边缘服务器才会启用其他的功能，譬如HLS转发等等。

上行边缘主要流程是：
* 客户端连接到SRS
* 开始推流到SRS。
* 开始转发到源站服务器。

## EdgeState

边缘的状态图分析如下：

![RTMP-HLS-latency](http://winlinvip.github.io/srs.release/wiki/images/edge-state.jpg)

注意：这种细节的文档很难保持不变，以代码为准。

## 边缘的难点

RTMP边缘对于SRS来讲问题不大，主要是混合了reload和HLS功能的边缘服务器，会是一个难点。

譬如，用户在访问边缘上的HLS流时，是使用nginx反向代理回源，还是使用RTMP回源后在边缘切片？对于前者，需要部署srs作为RTMP边缘，nginx作为HLS边缘，管理两个服务器自然是比一个要费劲。若使用后者，即RTMP回源后边缘切片，能节省骨干带宽，只有一路回源，难点在于访问HLS时要发起RTMP回源连接。

正因为业务逻辑会是边缘服务器的难点，所以SRS对于上行边缘，采取直接代理方式，并没有采取边缘缓存方式。所谓边缘缓存方式，即推流到边缘时边缘也会当作源站直接缓存（作为源站），然后转发给源站。边缘缓存方式看起来先进，这个边缘节点不必回源，实际上加大了集群的逻辑难度，不如直接作为代理方式简单。

Winlin 2014.4