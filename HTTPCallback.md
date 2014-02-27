# HTTP回调和服务器定制

SRS不支持服务器脚本（参考：[服务器端脚本](https://github.com/winlinvip/simple-rtmp-server/wiki/ServerSideScript)），服务器端定制有一个重要的替代功能，就是HTTP回调。譬如当客户端连接到SRS时，回调指定的http地址，这样可以实现验证功能。

## HTTP回调事件

SRS的回调事件包括：

<table>
<tr>
<th>事件</th><th>数据</th><th>说明</th>
</tr>
<tr>
<td>on_connect</td>
<td>
<pre>
{
    "action": "on_connect",
    "client_id": 1985,
    "ip": "192.168.1.10", "vhost": "video.test.com", "app": "live",
    "pageUrl": "http://www.test.com/live.html"
}
</pre>
</td>
<td>当客户端连接到指定的vhost和app时</td>
</tr>
<tr>
<td>on_close</td>
<td>
<pre>
{
    "action": "on_close",
    "client_id": 1985,
    "ip": "192.168.1.10", "vhost": "video.test.com", "app": "live"
}
</pre>
</td>
<td>当客户端关闭连接，或者SRS主动关闭连接时</td>
</tr>
<tr>
<td>on_publish</td>
<td>
<pre>
{
    "action": "on_publish",
    "client_id": 1985,
    "ip": "192.168.1.10", "vhost": "video.test.com", "app": "live",
    "stream": "livestream"
}
</pre>
</td>
<td>当客户端发布流时，譬如flash/FMLE方式推流到服务器</td>
</tr>
<tr>
<td>on_unpublish</td>
<td>
<pre>
{
    "action": "on_unpublish",
    "client_id": 1985,
    "ip": "192.168.1.10", "vhost": "video.test.com", "app": "live",
    "stream": "livestream"
}
</pre>
</td>
<td>当客户端停止发布流时</td>
</tr>
<tr>
<td>on_play</td>
<td>
<pre>
{
    "action": "on_play",
    "client_id": 1985,
    "ip": "192.168.1.10", "vhost": "video.test.com", "app": "live",
    "stream": "livestream"
}
</pre>
</td>
<td>当客户端开始播放流时</td>
</tr>
<tr>
<td>on_stop</td>
<td>
<pre>
{
    "action": "on_stop",
    "client_id": 1985,
    "ip": "192.168.1.10", "vhost": "video.test.com", "app": "live",
    "stream": "livestream"
}
</pre>
</td>
<td>当客户端停止播放时。备注：停止播放可能不会关闭连接，还能再继续播放。</td>
</tr>
</table>

其中，
* 事件：发生该事件时，即回调指定的HTTP地址。
* HTTP地址：可以支持多个，以空格分隔，SRS会依次回调这些接口。
* 数据：SRS将数据POST到HTTP接口。
* 返回值：SRS要求HTTP服务器返回HTTP200并且response内容为整数错误码（0表示成功），其他错误码会断开客户端连接。

## 配置SRS

以on_connect为例，当用户连接到vhost/app时，验证客户端的ip，配置文件如下：

```bash
# the listen ports, split by space.
listen              1935;
vhost __defaultVhost__ {
    http_hooks {
        # whether the http hooks enalbe.
        # default off.
        enabled         on;
        # when client connect to vhost/app, call the hook,
        # the request in the POST data string is a object encode by json:
        #       {
        #           "action": "on_connect",
        #           "client_id": 1985,
        #           "ip": "192.168.1.10", "vhost": "video.test.com", "app": "live",
        #           "pageUrl": "http://www.test.com/live.html"
        #       }
        # if valid, the hook must return HTTP code 200(Stauts OK) and response
        # an int value specifies the error code(0 corresponding to success):
        #       0
        # support multiple api hooks, format:
        #       on_connect http://xxx/api0 http://xxx/api1 http://xxx/apiN
        on_connect      http://127.0.0.1:8085/api/v1/clients;
    }
}
```

## 默认的HTTP服务器

SRS自带了一个默认的处理HTTP Callback的服务器，启动时需要指定端口，譬如8085端口。

启动方法：`python research/api-server/server.py 8085`

## 推流和播放

推流到SRS时，会调用HTTP接口：
```bash
[2014-02-27 09:41:33][trace] post to clients, req={"action":"on_connect","client_id":4,"ip":"192.168.1.179","vhost":"__defaultVhost__","app":"live","pageUrl":""}
[2014-02-27 09:41:33][trace] srs on_connect: client id=4, ip=192.168.1.179, vhost=__defaultVhost__, app=live, pageUrl=
127.0.0.1 - - [27/Feb/2014:09:41:33] "POST /api/v1/clients HTTP/1.1" 200 1 "" "srs(simple rtmp server)0.9.2"
```

播放SRS的流时，也会调用HTTP接口：
```bash
[2014-02-27 09:41:50][trace] post to clients, req={"action":"on_connect","client_id":5,"ip":"192.168.1.179","vhost":"__defaultVhost__","app":"live","pageUrl":"http://dev.chnvideo.com:3080/players/rtmp/"}
[2014-02-27 09:41:50][trace] srs on_connect: client id=5, ip=192.168.1.179, vhost=__defaultVhost__, app=live, pageUrl=http://dev.chnvideo.com:3080/players/rtmp/
127.0.0.1 - - [27/Feb/2014:09:41:50] "POST /api/v1/clients HTTP/1.1" 200 1 "" "srs(simple rtmp server)0.9.2"
```

Winlin