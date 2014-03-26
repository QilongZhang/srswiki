# ATC支持HLS/HDS热备

RTMP的热备怎么做？当边缘回源时，上层出现故障，可以切换到另外一个上层，所以RTMP热备只需要指定多个上层/源站就可以。边缘在故障切换时，会重新连接新服务器，客户端连接还没有断开，所以看起来就像是编码器重新推流了，画面最多抖动一下或者卡一下。

HLS热备怎么做？边缘从某个源站拿不到ts切片时，会去另外一个服务器拿。所以就要求两个上层的ts切片一样，当然如果上层服务器都从一个源站取片，是没有问题的。

如果HLS的源站需要做热备，怎么办？参考：[HDS/HLS热备](http://www.adobe.com/cn/devnet/adobe-media-server/articles/varnish-sample-for-failover.html)，如下图所示：

```bash
                              +----------+
               +---ATC-RTMP->-+  server  +---+
+----------+   |              +----------+   |   +---------------+    +-------+
| encoder  +->-+                             +->-+ Reverse Proxy +-->-+  CDN  +
+----------+   |              +----------+   |   +---------------+    +-------+
               +---ATC-RTMP->-+  server  +---+
                              +----------+
```

所以ATC RTMP说白了就是绝对时间，server需要能接入绝对时间，若切片在server上则根据绝对时间切片，若server和ReverseProxy之间还有切片工具，那server应该给切片工具绝对时间。

## SRS配置ATC

SRS默认ATC是关闭，即给客户端的RTMP流永远从0开始。若工具需要SRS不修改时间戳（只将sequence header和metadata调整为第一个音视频包的时间戳），可以打开ATC配置：

```bash
vhost __defaultVhost__ {
    # vhost for atc for hls/hds/rtmp backup.
    # generally, atc default to off, server delivery rtmp stream to client(flash) timestamp from 0.
    # when atc is on, server delivery rtmp stream by absolute time.
    # atc is used, for instance, encoder will copy stream to master and slave server,
    # server use atc to delivery stream to edge/client, where stream time from master/slave server
    # is always the same, client/tools can slice RTMP stream to HLS according to the same time,
    # if the time not the same, the HLS stream cannot slice to support system backup.
    # 
    # @see http://www.adobe.com/cn/devnet/adobe-media-server/articles/varnish-sample-for-failover.html
    # @see http://www.baidu.com/#wd=hds%20hls%20atc
    #
    # default: off
    atc             on;
}
```

Winlin 2014.3