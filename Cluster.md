# Forward搭建小型集群

srs定位为源站服务器，其中一项重要的功能是forward，即将服务器的流转发到其他服务器。

备注：SRS的边缘RTMP参考[Edge](https://github.com/winlinvip/simple-rtmp-server/wiki/Edge)，支持访问时回源，为大规模并发提供最佳解决方案。

forward本身是用做热备，即用户推一路流上来，可以被SRS转发（或者转码后转发）到多个源站，CDN边缘可以回多个源，实现故障热备的功能，构建强容错系统。

转发的部署实例参考：[Usage: Forward](https://github.com/winlinvip/simple-rtmp-server/wiki/SampleForward)

forward也可以用作搭建小型集群。架构图如下：

```bash
                                                    +-------------+    +------------------+
                                                +-->+  Edge(1935) +->--+  Player(3000)    +
                                                |   +-------------+    +------------------+
                                                |   +-------------+    +------------------+
                                                |-->+  Edge(1936) +->--+  Player(3000)    +
                                                |   +-------------+    +------------------+
+-----------+           +-----------+           |     192.168.1.6                          
|  Encoder  +-publish->-+    SRS    +-forward->-|                                          
+-----------+           +-----------+           |   +-------------+    +------------------+
 192.168.1.3             192.168.1.5            +-->+  Edge(1935) +->--+  Player(3000)    +
                                                |   +-------------+    +------------------+
                                                |   +-------------+    +------------------+
                                                +-->+  Edge(1936) +->--+  Player(3000)    +
                                                    +-------------+    +------------------+
                                                      192.168.1.7                          
```

下面是搭建小型集群的实例。

## Encoder编码器

编码器使用FFMPEG推流。编码参数如下：

```bash
for((;;)); do\
    ./objs/ffmpeg/bin/ffmpeg \
    -re -i doc/source.200kbps.768x320.flv \
    -vcodec copy -acodec copy \
    -f flv -y rtmp://192.168.1.5:1935/live/livestream; \
done
```

## SRS源站服务器

SRS（192.168.1.5）的配置如下：

```bash
listen              1935;
max_connections     10240;
vhost __defaultVhost__ {
    gop_cache       on;
    forward         192.168.1.6:1935 192.168.1.6:1936 192.168.1.7:1935 192.168.1.7:1936;
}
```

源站的流地址播放地址是：`rtmp://192.168.1.5/live/livestream`

将流forward到两个边缘节点上。

## 边缘节点

边缘节点启动多个SRS的进程，每个进程一个配置文件，侦听不同的端口。

以192.168.1.6的配置为例，需要侦听1935和1936端口。

配置文件`srs.1935.conf`配置如下：

```bash
listen              1935;
max_connections     10240;
vhost __defaultVhost__ {
    gop_cache       on;
}
```

配置文件`srs.1936.conf`配置如下：

```bash
listen              1936;
max_connections     10240;
vhost __defaultVhost__ {
    gop_cache       on;
}
```

启动两个SRS进程：

```bash
nohup ./objs/srs -c srs.1935.conf >/dev/null 2>&1 &
nohup ./objs/srs -c srs.1936.conf >/dev/null 2>&1 &
```

播放器可以随机播放着两个流：
* `rtmp://192.168.1.6:1935/live/livestream`
* `rtmp://192.168.1.6:1936/live/livestream`

另外一个边缘节点192.168.1.7的配置和192.168.1.6一样。

## 服务的流

此架构服务中的流为：

<table>
<tr>
  <td>流地址</td>
  <td>服务器</td>
  <td>端口</td>
  <td>连接数</td>
</tr>
<tr>
  <td>rtmp://192.168.1.6:1935/live/livestream</td>
  <td>192.168.1.6</td>
  <td>1935</td>
  <td>3000</td>
</tr>
<tr>
  <td>rtmp://192.168.1.6:1936/live/livestream</td>
  <td>192.168.1.6</td>
  <td>1936</td>
  <td>3000</td>
</tr>
<tr>
  <td>rtmp://192.168.1.7:1935/live/livestream</td>
  <td>192.168.1.7</td>
  <td>1935</td>
  <td>3000</td>
</tr>
<tr>
  <td>rtmp://192.168.1.7:1936/live/livestream</td>
  <td>192.168.1.7</td>
  <td>1936</td>
  <td>3000</td>
</tr>
</table>

这个架构每个节点可以支撑6000个并发，两个节点可以支撑1.2万并发。
还可以加端口，可以支持更多并发。

## 和CDN大规模集群的区别

这个架构和CDN架构的最大区别在于，CDN属于大规模集群，边缘节点会有成千上万台，源站2台（做热备），还需要有中间层。CDN的客户很多，流也会有很多。所以假若源站将每个流都转发给边缘，会造成巨大的浪费（有很多流只有少数节点需要）。

可见，forward只适用于所有边缘节点都需要所有的流。CDN是某些边缘节点需要某些流。

forward的瓶颈在于流的数目，假设每个SRS只侦听一个端口：

```bash
系统中流的数目 = 编码器的流数目 × 节点数目 × 端口数目
```

考虑5个节点，每个节点起4个端口，即有20个SRS边缘。编码器出5路流，则有`20 * 5 = 100路流`。

同样的架构，对于CDN的边缘节点来讲，系统的流数为`用户访问边缘节点的流`，假设没有用户访问，系统中就没有流量。某个区域的用户访问某个节点上的流，系统中只有一路流，而不是forward广播式的多路流。

另外，forward需要播放器随机访问多个端口，实现负载均衡，或者播放器访问api服务器，api服务器实现负载均衡，对于CDN来讲也不合适（需要客户改播放器）。

总之，forward适用于小型规模的集群，不适用于CDN大规模集群应用。

## 高级应用

forward还可以结合hls和transcoder功能使用，即在源站将流转码，然后forward到边缘节点，边缘节点支持rtmp同时切HLS。

因为用户推上来的流，或者编码器（譬如FMLE）可能不是h264+aac，需要先转码为h264+aac（可以只转码音频）后才能切片为hls。

需要结合vhost，先将流transcode送到另外一个vhost，这个vhost将流转发到边缘。这样可以只转发转码的流。

参考vhost，hls和transcoder相关wiki。

Winlin 2014.2