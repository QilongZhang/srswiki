# RTMP的URL规则和Vhost规则

RTMP的url其实很简单，vhost其实也没有什么新的概念，但是对于没有使用过的同学来讲，还是很容易混淆。几乎每个新人都必问的问题：RTMP那个URL推流时应该填什么，什么是vhost，什么是app？

## 标准RTMP URL

标准RTMP URL指的是最大兼容的RTMP URL，基本上所有的服务器和播放器都能识别的URL，和HTTP URL其实很相似，例如：

<table>
<thead>
<tr>
<th><strong>HTTP</strong></th>
<th><strong>Schema</strong></th>
<th><strong>Host</strong></th>
<th><strong>Port</strong></th>
<th colspan=2><strong>Path</strong></th>
</tr>
</thead>
<tbody>
<tr>
<td>http://192.168.1.10:80/players/srs_player.html</td>
<td>http</td>
<td>192.168.1.10</td>
<td>80</td>
<td colspan=2>/players/srs_player.html</td>
</tr>
<tr>
<td>rtmp://192.168.1.10:1935/live/livestream</td>
<td>rtmp</td>
<td>192.168.1.10</td>
<td>1935</td>
<td>live</td>
<td>livestream</td>
</tr>
</tbody>
<tfoot>
<tr>
<th><strong>RTMP</strong></th>
<th><strong>Schema</strong></th>
<th><strong>Host</strong></th>
<th><strong>Port</strong></th>
<th><strong>App</strong></th>
<th><strong>Stream</strong></th>
</tr>
</tfoot>
</table>

其中：
* Schema：协议头，HTTP为HTTP或HTTPS，RTMP为RTMP/RTMPS/RTMPE/RTMPT等众多协议，还有新出的RTMFP。
* Host：主机，表示要连接的主机，可以为主机DNS名称或者IP地址。商用时，一般不会用IP地址，而是DNS名称，这样可以用CDN分发内容（CDN一般使用DNS调度，即不同网络和地理位置的用户，通过DNS解析到的IP不一样，实现用户的就近访问）。
* Port：端口，HTTP默认为80，RTMP默认为1935。当端口没有指定时，使用默认端口。
* Path：路径，HTTP访问的文件路径。
* App：RTMP的Application（应用）名称，可以类比为文件夹。以文件夹来分类不同的流，没有特殊约定，可以任意划分。
* Stream：RTMP的Stream（流）名称，可以类比为文件。

## Vhost的应用

RTMP的Vhost和HTTP的Vhost概念是一样的：虚拟主机。详见下表（假设域名demo.srs.com被解析到IP为192.168.1.10的服务器）：

<table>
<thead>
<tr>
<th><strong>HTTP</strong></th>
<th><strong>Host</strong></th>
<th><strong>Port</strong></th>
<th><strong>VHost</strong></th>
</tr>
</thead>
<tbody>
<tr>
<td>http://demo.srs.com:80/players/srs_player.html</td>
<td>192.168.1.10</td>
<td>80</td>
<td>demo.srs.com</td>
</tr>
<tr>
<td>rtmp://demo.srs.com:1935/live/livestream</td>
<td>192.168.1.10</td>
<td>1935</td>
<td>demo.srs.com</td>
</tr>
</tbody>
<tfoot>
<tr>
<th><strong>RTMP</strong></th>
<th><strong>Host</strong></th>
<th><strong>Port</strong></th>
<th><strong>VHost</strong></th>
</tr>
</tfoot>
</table>

Vhost主要的作用是：
* 支持多用户：当一台服务器需要服务多个客户，譬如CDN有cctv（央视）和wasu（华数传媒）两个客户时，如何隔离他们两个的资源？相当于不同的用户共用一台计算机，他们可以在自己的文件系统建立同样的文件目录结构，但是彼此不会冲突。
* 域名调度：CDN分发内容时，需要让用户访问离自己最近的边缘节点，边缘节点再从源站或上层节点获取数据，达到加速访问的效果。一般的做法就是Host是DNS域名，这样可以根据用户的信息解析到不同的节点。
* 支持多配置：有时候需要使用不同的配置，考虑一个支持多终端（PC/Apple/Android）的应用，PC上RTMP分发，Apple和Android是HLS分发，如何让PC延迟最低，同时HLS也能支持，而且终端播放时尽量地址一致（降低终端开发难度）？可以使用两个Vhost，PC和HLS；PC配置为最低延迟的RTMP，并且将流转发给HLS的Vhost，可以对音频转码（可能不是H264/AAC）后切片为HLS。PC和HLS这两个Vhost的配置肯定是不一样的，播放时，流名称是一样，只需要使用不同的Host就可以。

### Vhost支持多用户

假设cctv和wasu都运行在一台边缘节点(192.168.1.10)上，用户访问这两个媒体的流时，Vhost的作用见下表：

<table>
<thead>
<tr>
<th><strong>RTMP</strong></th>
<th><strong>Host</strong></th>
<th><strong>Port</strong></th>
<th><strong>VHost</strong></th>
<th><strong>App</strong></th>
<th><strong>Stream</strong></th>
</tr>
</thead>
<tbody>
<tr>
<td>rtmp://show.cctv.cn/live/livestream</td>
<td>192.168.1.10</td>
<td>1935</td>
<td>show.cctv.cn</td>
<td>live</td>
<td>livestream</td>
</tr>
<tr>
<td>rtmp://show.wasu.cn/live/livestream</td>
<td>192.168.1.10</td>
<td>1935</td>
<td>show.wasu.cn</td>
<td>live</td>
<td>livestream</td>
</tr>
</tbody>
</table>

在边缘节点（192.168.1.10）上的SRS，需要配置Vhost，例如：

```bash
listen              1935;
vhost show.cctv.cn {
    enabled         on;
}
vhost show.wasu.cn {
    enabled         on;
}
```

### Vhost域名调度

详细参考DNS和CDN的实现。

### Vhost支持多配置

以上面举的例子，若cctv需要延迟最低（意味着启动时只有声音，画面是黑屏），而wasu需要快速启动（打开就能看到视频，服务器cache了最后一个gop，延迟会较大）。

只需要对这两个Vhost进行不同的配置，例如：

```bash
listen              1935;
vhost show.cctv.cn {
    enabled         on;
    gop_cache       off;
}
vhost show.wasu.cn {
    enabled         on;
    gop_cache       on;
}
```

总之，这两个Vhost的配置完全没有关系，不会相互影响。

## 访问指定的Vhost

如何访问某台服务器上的Vhost？有两个方法：
* 配置hosts：因为Vhost实际上就是DNS解析，所以可以配置客户端的hosts，将域名（Vhost）解析到指定的服务器，就可以访问这台服务器上的指定的vhost。
* 使用app的参数：需要服务器支持。在app后面带参数指定要访问的Vhost。SRS支持?vhost=VHOST和...vhost...VHOST这两种方式，后面的方式是避免一些播放器不识别？和=等特殊字符。

普通用户不用这么麻烦，直接访问RTMP地址就好了，有时候运维需要看某台机器上的Vhost的流是否有问题，就需要这种特殊的访问方式。考虑下面的例子：

```bash
RTMP URL: rtmp://demo.srs.com/live/livestream
边缘节点数目：50台
边缘节点IP：192.168.1.100 至 192.168.1.150
边缘节点SRS配置：
    listen              1935;
    vhost demo.srs.com {
        enabled         on;
    }
```

各种访问方式见下表：


<table>
<thead>
<tr>
<th><strong>用户</strong></th>
<th><strong>RTMP URL</strong></th>
<th><strong>hosts设置</strong></th>
<th><strong>目标</strong></th>
</tr>
</thead>
<tbody>
<tr>
<td>普通用户</td>
<td>rtmp://demo.srs.com/live/livestream</td>
<th>无</th>
<td>正常观看直播流</td>
</tr>
<tr>
<td>运维</td>
<td>rtmp://demo.srs.com/live/livestream</td>
<th>192.168.1.100 demo.srs.com</th>
<td>查看192.168.1.100上的流</td>
</tr>
<tr>
<td>运维</td>
<td>rtmp://192.168.1.100/live?vhost=demo.srs.com/livestream</td>
<th>无</th>
<td>查看192.168.1.100上的流</td>
</tr>
<tr>
<td>运维</td>
<td>rtmp://192.168.1.100/live...vhost...demo.srs.com/livestream</td>
<th>无</th>
<td>查看192.168.1.100上的流</td>
</tr>
</tbody>
</table>

访问其他服务器的流也类似。

## FMLE的奇怪URL方式

FMLE推流时，URL那个地方，有三个可以输入的框，参考[Adobe FMLE](http://help.adobe.com/en_US/FlashMediaLiveEncoder/3.0/Using/WS5b3ccc516d4fbf351e63e3d11c104ba878-7ff7.html)：
* FMS URL: 需要输入rtmp://host:port/app，例如：rtmp://demo.srs.com/live
* Backup URL: 备份的服务器，格式同FMS URL。若指定了备份服务器，FMLE会同时推送给这两个服务器。
* Stream: 流名称，例如：livestream

实际上是将RTMP URL分成了两部分，stream前面那部分和stream。为何要这么搞？我猜想有以下原因：
* 支持多级app和Stream：我们目前举的例子都是一级app和一级stream，实际上RTMP支持多级app和stream，就像子文件夹，实际上很少用得到。所以SRS的URL都是一个地址，默认最后一个/后面就是stream，前面是app。
* 支持流名称带参数：Adobe的鬼HLS/HDS非常之麻烦，那个地址是个恶心的完全不一致。参考[FMS livepkgr](http://help.adobe.com/en_US/flashmediaserver/devguide/WSd391de4d9c7bd609-52e437a812a3725dfa0-8000.html#WSd391de4d9c7bd609-52e437a812a3725dfa0-7ff5)，例如发布一个rtmp和HLS的流：
```bash
FMLE:
FMS URL: rtmp://demo.srs.com/livepkgr
Stream: livestream?adbe-live-event=liveevent

Client:
RTMP:  rtmp://demo.srs.com/livepkgr/livestream
HLS: http://demo.srs.com/hls-live/livepkgr/_definst_/liveevent/livestream.m3u8
HDS: http://demo.srs.com/hds-live/livepkgr/_definst_/liveevent/livestream.f4m
```
没有比这个更恶心的东西了。比较SRS的简洁方案：
```bash
FMLE: 
FMS URL: rtmp://demo.srs.com/livepkgr
Stream: livestream

Client:
RTMP: rtmp://demo.srs.com/livepkgr/livestream
HLS: http://demo.srs.com/livepkgr/livestream.m3u8
HDS: not support yet.
```

既然谈到了RTMP URL中的参数，下一章就说说这个。