# 低延时直播应用

直播应用中，RTMP和HLS基本上可以覆盖所有客户端观看（参考：[DeliveryHLS](https://github.com/winlinvip/simple-rtmp-server/wiki/DeliveryHLS)），HLS主要是延时比较大，RTMP主要优势在于延时低。

## RTMP和延时

RTMP的特点如下：
* Adobe支持得很好：RTMP实际上是现在编码器输出的工业标准协议，基本上所有的编码器（摄像头之类）都支持RTMP输出。原因在于PC市场巨大，PC主要是Windows，Windows的浏览器基本上都支持flash，Flash又支持RTMP支持得灰常好。
* 适合长时间播放：因为RTMP支持的很完善，所以能做到flash播放RTMP流长时间不断流，当时测试是100万秒，即10天多可以连续播放。对于商用流媒体应用，客户端的稳定性当然也是必须的，否则最终用户看不了还怎么玩？我就知道有个教育客户，最初使用播放器播放http流，需要播放不同的文件，结果就总出问题，如果换成服务器端将不同的文件转换成RTMP流，客户端就可以一直播放；该客户走RTMP方案后，经过CDN分发，没听说客户端出问题了。
* 延迟较低：比起YY的那种UDP私有协议，RTMP算延迟大的（延迟在1-3秒），比起HTTP流的延时（一般在10秒以上）RTMP算低延时。一般的直播应用，只要不是电话类对话的那种要求，RTMP延迟是可以接受的。在一般的视频会议（参考SRS的视频会议延时）应用中，RTMP延时也能接受，原因是别人在说话的时候我们一般在听，实际上1秒延时没有关系，我们也要思考（话说有些人的CPU处理速度还没有这么快）。
* 有累积延迟：技术一定要知道弱点，RTMP有个弱点就是累积误差，原因是RTMP基于TCP不会丢包。所以当网络状态差时，服务器会将包缓存起来，导致累积的延迟；待网络状况好了，就一起发给客户端。这个的对策就是，当客户端的缓冲区很大，就断开重连。当然SRS也提供配置。

## RTMP延迟的测量

如何测量延时，是个很难的问题，不过有个行之有效的方法，就是用手机的秒表，可以比较精确的对比延时。参考：[RTMP延时测量](http://blog.csdn.net/win_lin/article/details/12615591)

经过测量发现，在网络状况良好时：
* RTMP延时可以做到0.8秒左右（SRS也可以）。
* 多级边缘节点不会影响延迟（和SRS同源的某CDN的边缘服务器可以做到）
* Nginx-Rtmp延迟有点大，估计是缓存的处理，多进程通信导致？
* GOP是个硬指标，不过SRS可以关闭GOP的cache来避免这个影响，参考后面的配置方法。
* 服务器性能太低，也会导致延迟变大，服务器来不及发送数据。

## GOP-Cache

什么是GOP？就是视频流中两个I帧的时间距离，如果问什么是I帧就去百度。

GOP有什么影响？Flash（解码器）只有拿到GOP才能开始解码播放。也就是说，服务器一般先给一个I帧给Flash。可惜问题来了，假设GOP是10秒，也就是每隔10秒才有关键帧，如果用户在第5秒时开始播放，会怎么样？

第一种方案：等待下一个I帧，也就是说，再等5秒才开始给客户端数据。这样延迟就很低了，总是实时的流。问题是：等待的这5秒，会黑屏，现象就是播放器卡在那里，什么也没有，有些用户可能以为死掉了，就会刷新页面。总之，某些客户会认为等待关键帧是个不可饶恕的错误，延时有什么关系？我就希望能快速启动和播放视频，最好打开就能放！

第二种方案：马上开始放，放什么呢？你肯定知道了，放前一个I帧。也就是说，服务器需要总是cache一个gop，这样客户端上来就从前一个I帧开始播放，就可以快速启动了。问题是：延迟自然就大了。

有没有好的方案？有！至少有两种：
* 编码器调低GOP，譬如0.5秒一个GOP，这样延迟也很低，也不用等待。坏处是编码器压缩率会降低，图像质量没有那么好。
* 服务器提供配置，可以选择前面两个方案之一：SRS就这么做，有个gop_cache配置项，on就会马上播放，off就低延迟。

SRS的配置项：

```bash
# the listen ports, split by space.
listen              1935;
vhost __defaultVhost__ {
    # whether cache the last gop.
    # if on, cache the last gop and dispatch to client,
    #   to enable fast startup for client, client play immediately.
    # if off, send the latest media data to client,
    #   client need to wait for the next Iframe to decode and show the video.
    # set to off if requires min delay;
    # set to on if requires client fast startup.
    # default: on
    gop_cache       on;
}
```

备注：参考conf/srs.conf的min.delay.com配置。

## 累积延迟

除了GOP-Cache，还有一个有关系，就是累积延迟。SRS可以配置直播队列的长度，服务器会将数据放在直播队列中，如果超过这个长度就清空到最后一个I帧：

```bash
    # the max live queue length in seconds.
    # if the messages in the queue exceed the max length, 
    # drop the old whole gop.
    # default: 30
    queue_length    10;
```

当然这个不能配置太小，譬如GOP是1秒，queue_length是1秒，这样会导致有1秒数据就清空，会导致跳跃。

有更好的方法？有的。延迟基本上就等于客户端的缓冲区长度，因为延迟大多由于网络带宽低，服务器缓存后一起发给客户端，现象就是客户端的缓冲区变大了，譬如NetStream.BufferLength=5秒，那么说明缓冲区中至少有5秒数据。

处理累积延迟的最好方法，是客户端检测到缓冲区有很多数据了，如果可以的话，就重连服务器。当然如果网络一直不好，那就没有办法了。

## 低延时配置

考虑GOP-Cache和累积延迟，推荐的低延时配置如下（参考min.delay.com）：
```bash
# the listen ports, split by space.
listen              1935;
vhost __defaultVhost__ {
    # whether cache the last gop.
    # if on, cache the last gop and dispatch to client,
    #   to enable fast startup for client, client play immediately.
    # if off, send the latest media data to client,
    #   client need to wait for the next Iframe to decode and show the video.
    # set to off if requires min delay;
    # set to on if requires client fast startup.
    # default: on
    gop_cache       off;
    # the max live queue length in seconds.
    # if the messages in the queue exceed the max length, 
    # drop the old whole gop.
    # default: 30
    queue_length    10;
}
```

当然，服务器的性能也要考虑，不可以让一个SRS进程跑太高带宽，一般CPU在80%以下不会影响延迟，连接数参考[性能](https://github.com/winlinvip/simple-rtmp-server/wiki/Performance)。

Winlin