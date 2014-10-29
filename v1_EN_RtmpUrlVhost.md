# RTMP URL/Vhost

The url of RTMP is simple, and the vhost is not a new concept, although it's easy to confuse for the fresh. What is vhost? What is app? Why FMLE should input the app and stream?

The benifit of RTMP and HLS, see: [HLS](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_DeliveryHLS)

## Use Scenario

The use scenario of vhost:
* Multiple customers cloud: For example, CDN(content delivery network) serves multiple customers. How does CDN to seperate customer and stat the data? Maybe stream path is duplicated, for example, live/livestream is the most frequently used app and stream. The vhost, similar to the virtual server, provides abstract for multiple customers.
* Different config: For example, FMLE publish h264+mp3, which should be transcoded to h264+aac. We can use vhost to use different config, h264+mp3 disabled hls while the h264+aac vhost enalbe hls.

In a word, vhost is the element of config, to seperate customer and apply different config.

## Standard RTMP URL

Standard RTMP URL is the most compatible URL, for all servers and players can identify. The RTMP URL is similar to the HTTP URL:

<table>
<thead>
<tr>
<th>HTTP</th>
<th>Schema</th>
<th>Host</th>
<th>Port</th>
<th colspan=2>Path</th>
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
<th>RTMP</th>
<th>Schema</th>
<th>Host</th>
<th>Port</th>
<th>App</th>
<th>Stream</th>
</tr>
</tfoot>
</table>

It is:
* Schema：The protocol prefix, HTTP/HTTPS for HTTP protocol, and RTMP/RTMPS/RTMPE/RTMPT for RTMP protocol, while the RTMFP is adobe flash p2p protocol.
* Host：The server ip or dns name to connect to. It is dns name for CDN, and the dns name is used as the vhost for the specified customer.
* Port：The tcp port, default 80 for HTTP and 1935 for RTMP.
* Path：The http file path for HTTP.
* App：The application for RTMP, similar to the directory of resource(stream).
* Stream：The stream for RTMP, similar to the resource(file) in specified app.

## NoVhost

However, most user donot need the vhost, and it's a little complex, so donot use it when you donot need it. Most user actually only need app and stream.

When to use vhost? When you serve 100+ customers and use the same delivery network, they use theire own vhost and can use the sample app and stream.

The common use scenario, for example, if you use SRS to build a video website. So you are the only customer, donot need vhost. Suppose you provides video chat, there are some categories which includes some chat rooms. For example, categories are military, reader, history. The military category has rooms rock, radar; the reader category has red_masion. The config of SRS is very simple:

```bash
listen              1935;
vhost __defaultVhost__ {
}
```

When generate web pages, for instance, military category, all app is `military`. The url of chat room is `rtmp://yourdomain.com/military/rock`, while the encoder publish this stream, and all player play this stream.

The other pages of the military category use the same app name `military`, but use the different stream name, fr example, radar chat room use the stream url `rtmp://yourdomain.com/military/radar`.

When generate the pages, add new stream, the config of SRS no need to change. For example, when add a new chat room cannon, no need to change config of SRS. It is simple enough!

The reader category can use app `reader`, and the `red_mansion` chat room can use the url `rtmp://yourdomain.com/reader/red_mansion`.

## Vhost Use scenario

The vhost of RTMP is same to HTTP virtual server. For example, the demo.srs.com is resolve to 192.168.1.10 by dns or hosts:

<table>
<thead>
<tr>
<th>HTTP</th>
<th>Host</th>
<th>Port</th>
<th>VHost</th>
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
<th>RTMP</th>
<th>Host</th>
<th>Port</th>
<th>VHost</th>
</tr>
</tfoot>
</table>

The use scenario of vhost:
* Multiple Customers: When need to serve multiple customers use the same network, for example, cctv and wasu delivery stream on the same CDN, how to seperate them, when they use the same app and stream?
* DNS scheduler: When CDN delivery content, the fast edge for the specified user is resolved for the dns name. We can use vhost as the dns name to scheduler user to different edge.
* Multiple Config sections: Sometimes we need different config, for example, to delivery RTMP for PC and transcode RTMP to HLS for android and IOS, we can use one vhost to delivery RTMP and another for HLS.

### Vhost For Multiple Customers

For example, we got two customers cctv and wasu, use the same edge server 192.168.1.10, when user access the stream of these two customers:

<table>
<thead>
<tr>
<th>RTMP</th>
<th>Host</th>
<th>Port</th>
<th>VHost</th>
<th>App</th>
<th>Stream</th>
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

The config on the edge 192.168.1.10, need to config the vhost:

```bash
listen              1935;
vhost show.cctv.cn {
}
vhost show.wasu.cn {
}
```

### Vhost For DNS scheduler

Please refer to the tech for DNS and CDN.

### Vhost For Multiple Config

For example, two customers cctv and wasu, and cctv needs mininum latency, while wasu needs fast startup. 

Then we config the cctv without gop cache, and wasu config with gop cache:

```bash
listen              1935;
vhost show.cctv.cn {
    gop_cache       off;
}
vhost show.wasu.cn {
    gop_cache       on;
}
```

These two vhosts is completely isolated.

## \_\_defaultVhost\_\_

The default vhost is \_\_defaultVhost\_\ introduced by FMS. When mismatch and vhost not found, use the default vhost if configed.

For example, the config of SRS on 192.168.1.10:

```bash
listen              1935;
vhost demo.srs.com {
}
```

Then, when user access the vhost:
* rtmp://demo.srs.com/live/livestream：OK, matched vhost is demo.srs.com.
* rtmp://192.168.1.10/live/livestream：Failed, no matched vhost, and no default vhost.

The rule of default vhost is same to other vhost, the default is used for the vhost not matched and not find.

## Access Specified Vhost

There are two ways to access the vhost on server:
* DNS name: When access the dns name equals to the vhost, by dns resolve or hosts file, we can access the vhost on server.
* App parameters: When connect to tcUrl on server, that is, connect to the app, the parameter can specifies the vhost. This needs the server supports this way, for example, SRS can use parameter ?vhost=VHOST and ...vhost...VHOST to access specified vhost.

For example:

```bash
RTMP URL: rtmp://demo.srs.com/live/livestream
Edge servers: 50 servers
Edge server ip: 192.168.1.100 to 192.168.1.150
Edge SRS config:
    listen              1935;
    vhost demo.srs.com {
        mode remote;
        origin: xxxxxxx;
    }
```

The ways to access the url on edge servers:

<table>
<thead>
<tr>
<th>User</th>
<th>RTMP URL</th>
<th>Hosts file</th>
<th>Target</th>
</tr>
</thead>
<tbody>
<tr>
<td>User</td>
<td>rtmp://demo.srs.com/live/livestream</td>
<th>NO</th>
<td>Scheduled by DNS</td>
</tr>
<tr>
<td>Admin</td>
<td>rtmp://demo.srs.com/live/livestream</td>
<th>192.168.1.100 demo.srs.com</th>
<td>Stream on 192.168.1.100</td>
</tr>
<tr>
<td>Admin</td>
<td>rtmp://192.168.1.100/live?<br/>vhost=demo.srs.com/livestream</td>
<th>NO</th>
<td>Stream on 192.168.1.100</td>
</tr>
<tr>
<td>Admin</td>
<td>rtmp://192.168.1.100/live<br/>...vhost...demo.srs.com/livestream</td>
<th>NO</th>
<td>Stream on 192.168.1.100</td>
</tr>
</tbody>
</table>

It is sample way to access other servers.

## The Publish URL of FMLE

The publish URL of FMLE, see: [Adobe FMLE](http://help.adobe.com/en_US/FlashMediaLiveEncoder/3.0/Using/WS5b3ccc516d4fbf351e63e3d11c104ba878-7ff7.html)：
* FMS URL: The tcUrl, the vhost and app. For example: rtmp://demo.srs.com/live
* Backup URL: The backup server.
* Stream: The stream name. For example: livestream

Why FMLE seperate the RTMP URL to two parts: tcUrl(vhost/app) and stream?
* Support multiple app and stream: The app can be multiple app, for example, live/live1. The stream can be multiple level stream, for example, livestream/livestream1. The RTMP url is: rtmp://vhost/live/live1/livestream/livestream1.
* Support parameters for app: The HLS/HDS url of FMS is ugly, see: [FMS livepkgr](http://help.adobe.com/en_US/flashmediaserver/devguide/WSd391de4d9c7bd609-52e437a812a3725dfa0-8000.html#WSd391de4d9c7bd609-52e437a812a3725dfa0-7ff5), for example, publish a rtmp stream and slice to HLS:
```bash
FMLE:
FMS URL: rtmp://demo.srs.com/livepkgr
Stream: livestream?adbe-live-event=liveevent

Client:
RTMP:  rtmp://demo.srs.com/livepkgr/livestream
HLS: http://demo.srs.com/hls-live/livepkgr/_definst_/liveevent/livestream.m3u8
HDS: http://demo.srs.com/hds-live/livepkgr/_definst_/liveevent/livestream.f4m
```

Compare to the simple solution of SRS:
```bash
FMLE: 
FMS URL: rtmp://demo.srs.com/livepkgr
Stream: livestream

Client:
RTMP: rtmp://demo.srs.com/livepkgr/livestream
HLS: http://demo.srs.com/livepkgr/livestream.m3u8
HDS: not support yet.
```

The next section descripts the parameters of RTMP url.

## Parameters in RTMP URL

There is no parameters for RTMP URL, similar to query string of HTTP, we can pass parameters in RTMP URL for SRS:
* Vhost：Specifies the vhost in the RTMP URL for SRS.
* Event: The events for HLS of FMS, while SRS do not use this solution, all HLS parameters is in config.
* Token authentication: Not implements for SRS, while user can specifies the token in the RTMP URL, for example, rtmp://server/live?vhost=xxx&token=xxx/livestream, SRS can fetch the token and verify it on remote authentication server. The token authentication is better and complex than refer authentication.

Why pass the parameters in tcUrl? The client as code to play RTMP stream is:

```as
// how to play url: rtmp://demo.srs.com/live/livestream
conn = new NetConnection();
conn.connect("rtmp://demo.srs.com/live");

stream = new NetStream(conn);
stream.play("livestream");
```

From the perspective of RTMP protcol:
* NetConnection.connect(vhost+app): Complete the handshake protocol, send the connect packet to connect at the vhost and app. The parameters, for instance, the token or vhost, must specifies in the tcUrl(vhost/app).
* NetStream.play(stream): Send a play packet and start play the stream.

## RTMP URL of SRS

SRS always simplify the problem, never make it more complex.

The RTMP URL of SRS use standard RTMP URL. Generally do not need to modify the url or add parameters in it, except:
* Change vhost: Manually change vhost in RTMP URL for debuging.
* Token authentication: To support token authentication.

Furthermore, recomment user to use one level app and stream, never use multiple level app and stream. For example:

```bash
// Not recomment multiple level app and stream, which confuse people.
rtmp://demo.srs.com/show/live/livestream
rtmp://demo.srs.com/show/live/livestream/2013
```

The srs_player and srs_publisher donot support multiple level app and stream. Both srs_player and srs_publisher make the word behind the last / to stream, the left is tcUrl(vhost/app). For example:

```bash
// For both srs_player and srs_publisher:
// play or publish the following rtmp URL:
rtmp://demo.srs.com/show/live/livestream/2013
schema: rtmp
host/vhost: demo.srs.com
app: show/live/livestream
stream: 2013
```

It simplify the url, the palyer and publisher only need user to input a url, not tcUrl and stream.

The RTMP URL of SRS:
<table>
<thead>
<tr>
<th>URL</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>rtmp://demo.srs.com/live/livestream</td>
<td>Standard RTMP URL</td>
</tr>
<tr>
<td>rtmp://192.168.1.10/live?vhost=demo.srs.com/livestream</td>
<td>URL specifies vhost</td>
</tr>
<tr>
<td>rtmp://demo.srs.com/live?key=ER892ID839KD9D0A1D87D/livestream</td>
<td>URL specifies token authentication</td>
</tr>
</tbody>
</table>

## Vhost of SRS config

The full.conf of conf of SRS contains many vhost, which used to show each feature. All features is put into the vhost demo.srs.com:

<table>
<thead>
<th>Category</th>
<th>Vhost</th>
<th>Description</th>
</thead>
<tbody>
<tr>
<td>RTMP</td><td>__defaultVhost__</td><td>默认Vhost的配置，只支持RTMP功能</td>
</tr>
<tr>
<td>RTMP</td><td>chunksize.vhost.com</td><td>如何设置chunk size的实例。其他Vhost将此配置打开，即可设置chunk size。</td>
</tr>
<tr>
<td>Forward</td><td>same.vhost.forward.vhost.com</td><td>Forward实例：将流转发到同一个vhost。</td>
</tr>
<tr>
<td>Forward</td><td>change.vhost.forward.vhost.com</td><td>Forward实例：转发时，转发到服务器的不同vhost。</td>
</tr>
<tr>
<td>HLS</td><td>with-hls.vhost.com</td><td>HLS实例：如何开启HLS，以及HLS的相关配置。</td>
</tr>
<tr>
<td>HLS</td><td>no-hls.vhost.com</td><td>HLS实例：如何禁用HLS。</td>
</tr>
<tr>
<td>RTMP</td><td>min.delay.com</td><td>RTMP最低延迟：如何配置最低延迟的RTMP流。</td>
</tr>
<tr>
<td>RTMP</td><td>refer.anti_suck.com</td><td>Refer实例：如何配置Refer防盗链。</td>
</tr>
<tr>
<td>RTMP</td><td>bandcheck.srs.com</td><td>带宽测试用的vhost，srs测速默认连接到这个vhost。这个vhost配置了带宽测速的key，可测速间隔和最大测速带宽限制。其他Vhost也可以支持测速，只要把这个配置项打开，然后在测速播放器的参数中指明另外的vhost</td>
</tr>
<tr>
<td>RTMP</td><td>removed.vhost.com</td><td>禁用vhost实例：如何禁用vhost。</td>
</tr>
<tr>
<td>Callback</td><td>hooks.callback.vhost.com</td><td>设置http callback的实例，当这些事件发生时，SRS会调用指定的http api。其他Vhost将这些配置打开，就可以支持http callback。</td>
</tr>
<tr>
<td>Transcode</td><td>mirror.transcode.vhost.com</td><td>转码实例：使用ffmpeg的实例filter，将视频做镜像翻转处理。其他Vhost添加这个配置，就可以对流进行转码。<br/>注：所有转码的流都需要重新推送到SRS，使用不同的流名称（vhost和app也可以不一样）。</td>
</tr>
<tr>
<td>Transcode</td><td>drawtext.transcode.vhost.com</td><td>转码实例：在视频上加文字filter。其他Vhost添加此配置，就可以做文字水印。<br/>注：所有转码的流都需要重新推送到SRS，使用不同的流名称（vhost和app也可以不一样）。</td>
</tr>
<tr>
<td>Transcode</td><td>crop.transcode.vhost.com</td><td>转码实例：剪裁视频filter。其他vhost添加此filter，即可对视频进行剪裁。<br/>注：所有转码的流都需要重新推送到SRS，使用不同的流名称（vhost和app也可以不一样）。</td>
</tr>
<tr>
<td>Transcode</td><td>logo.transcode.vhost.com</td><td>转码实例：添加图片/视频水印。其他vhost添加这些配置，可以加图片/视频水印。<br/>注：所有转码的流都需要重新推送到SRS，使用不同的流名称（vhost和app也可以不一样）。</td>
</tr>
<tr>
<td>Transcode</td><td>audio.transcode.vhost.com</td><td>转码实例：只对音频转码。其他vhost添加此配置，可只对音频转码。<br/>注：所有转码的流都需要重新推送到SRS，使用不同的流名称（vhost和app也可以不一样）。</td>
</tr>
<tr>
<td>Transcode</td><td>copy.transcode.vhost.com</td><td>转码实例：只转封装。类似于forward功能。</td>
</tr>
<tr>
<td>Transcode</td><td>all.transcode.vhost.com</td><td>转码实例：对上面的实例的汇总。</td>
</tr>
<tr>
<td>Transcode</td><td>ffempty.transcode.vhost.com</td><td>调用ffempty程序转码，这个只是一个stub，打印出参数而已。用作调试用，看参数是否传递正确。</td>
</tr>
<tr>
<td>Transcode</td><td>app.transcode.vhost.com</td><td>转码实例：只对匹配的app的流进行转码。</td>
</tr>
<tr>
<td>Transcode</td><td>stream.transcode.vhost.com</td><td>转码实例：只对匹配的流进行转码。</td>
</tr>
</tbody>
</table>

SRS的demo.conf配置文件中，包含了demo用到的一些vhost，参考[Usage: Demo](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_SampleDemo)。

<table>
<thead>
<th>Category</th>
<th>Vhost</th>
<th>说明</th>
</thead>
<tbody>
<tr>
<td>DEMO</td><td>players</td><td>srs_player播放的演示流，按照Readme的Step会推流到这个vhost，demo页面打开后播放的流就是这个vhost中的流</td>
</tr>
<tr>
<td>DEMO</td><td>players_pub</td><td>srs编码器推流到players这个vhost，然后转码后将流推送到这个vhost，并切片为hls，srs编码器播放的带字幕的流就是这个vhost的流</td>
</tr>
<tr>
<td>DEMO</td><td>players_pub_rtmp</td><td>srs编码器演示页面中的低延时播放器，播放的就是这个vhost的流，这个vhost关闭了gop cache，关闭了hls，让延时最低（在1秒内）</td>
</tr>
<tr>
<td>DEMO</td><td>demo.srs.com</td><td>srs的演示vhost，Readme的step最后的12路流演示，以及播放器的12路流延时，都是访问的这个vhost。包含了SRS所有的功能。</td>
</tr>
<tr>
<td>Others</td><td>dev</td><td>开发用的，可忽略</td>
</tr>
</tbody>
</table>

Winlin 2014.10