# 搭建小型集群：forward

srs定位为源站服务器，其中一项重要的功能是forward，即将服务器的流转发到其他服务器。

forward本身是用做热备，即用户推一路流上来，可以被SRS转发（或者转码后转发）到多个源站，CDN边缘可以回多个源，实现故障热备的功能，构建强容错系统。

forward也可以用作搭建小型集群。架构图如下：
```
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
```
for((;;)); do\
    ./objs/ffmpeg/bin/ffmpeg \
    -re -i doc/source.200kbps.768x320.flv \
    -vcodec copy -acodec copy \
    -f flv -y rtmp://192.168.1.5:1935/live/livestream; \
done
```

## SRS源站服务器

SRS（192.168.1.5）的配置如下：

```
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

```
listen              1935;
max_connections     10240;
vhost __defaultVhost__ {
    gop_cache       on;
}
```

配置文件`srs.1936.conf`配置如下：

```
listen              1936;
max_connections     10240;
vhost __defaultVhost__ {
    gop_cache       on;
}
```

启动两个SRS进程：

```
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