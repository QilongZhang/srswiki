# DRM

DRM use to protect the content, can use many strategys:
* Refer Autisuck: Check the refer(PageUrl) of RTMP connect params, which is set by flash player.
* Token Authentication: Check the token of RTMP connect params, SRS can use http-callback to verify the token.
* FMS token tranverse: Edge server will verify each connection on origin server.
* Access Server: Adobe Access Server.
* Publish Authentication: The authentication protocol for publish.

## Refer Autisuck

SRS support config the refer to antisuck.

When play RTMP url, adobe flash player will send the page url in the connect params PageUrl, 
which is cannot changed by as code, server can check the web page url to ensure the user is ok.

While user use client application, the PageUrl can be any value, for example, 
use srs-librtmp to play RTMP url, the Refer antisuck is not work.

To config the refer antisuck in srs:

```bash
# the vhost for antisuck.
vhost refer.anti_suck.com {
    # the common refer for play and publish.
    # if the page url of client not in the refer, access denied.
    # if not specified this field, allow all.
    # default: not specified.
    refer           github.com github.io;
    # refer for publish clients specified.
    # the common refer is not overrided by this.
    # if not specified this field, allow all.
    # default: not specified.
    refer_publish   github.com github.io;
    # refer for play clients specified.
    # the common refer is not overrided by this.
    # if not specified this field, allow all.
    # default: not specified.
    refer_play      github.com github.io;
}
```

## Token Authentication

The token authentication similar to refer, but the token is put in the url, not in the args of connect:
* Put token in RTMP url, for example, `rtmp://vhost/app?token=xxxx/stream`, SRS will pass the token 
in the http-callback. read [HTTP callback](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_HTTPCallback)
* Put token in the connect args, for example, as code NetConnection.connect(url, token), need to modify SRS code.

Token is robust then refer, can specifies more params, for instance, the expire time.

For example:

1. When user access the web page, web application server can generate a token in the RTMP url, for example,
token = md5(time + id + salt + expire) = 88195f8943e5c944066725df2b1706f8
1. The RTMP url to play is, for instance, rtmp://192.168.1.10/live?time=1402307089&expire=3600&token=88195f8943e5c944066725df2b1706f8/livestream
1. Config the http callback of SRS `on_connect http://127.0.0.1:8085/api/v1/clients;`, 
read [HTTP callback](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_HTTPCallback#config-srs)
1. When user play stream, SRS will callback the url with token to verify,
if invalid, the http callback can return none zero which indicates error.

## TokenTraverse

Token防盗链的穿越，指的是在origin-edge集群中，客户播放edge边缘服务器的流时，边缘将认证的token发送给源站进行验证，即token穿越。

FMS的edge和FMS的origin使用私有协议，使用一个连接回源取数据，一个连接回源传输控制命令，譬如token穿越就是在这个连接做的。参考：https://github.com/winlinvip/simple-rtmp-server/issues/104

token认证建议使用http方式，也就是说客户端连接到边缘时，边缘使用http回调方式验证token。像fms那种token穿越，是需要走RTMP协议，其他开源服务器一般都不支持这种方式（中国特色）。

SRS可以支持类似fms的token穿越，不过实现方式稍微有区别，不是采用fms edge的私有协议，而是每次新开一个连接回源验证，验证通过后边缘才提供服务。也就是边缘先做一个完全的代理。

SRS这种方式的特点是：
* 在token认证上，能和fms源站对接，fms源站感觉不到什么区别。
* 每次边缘都会新开连接去验证，开销会大一些；而且只限于connect事件验证，马上验证过后就会收到disconnect事件。
* 会导致源站的短连接过多（连接验证token，断开），不过可以加一层fms edge解决，这样比所有都是fms edge要好。

对于源站短连接过多的问题，可以加一层fms边缘缓解，假设1000个客户端连接到边缘：
* srs => 客户fms 这种方案，会有1000个连接去回源验证，然后断开。
* srs => cdn-fms => 客户fms 这种方案，会有1000个连接去cdn的fms去验证，只有1个连接去客户那边验证。

SRS的token穿越(traverse)的配置，参考`edge.token.traverse.conf`：

```bash
listen              1935;
vhost __defaultVhost__ {
    mode            remote;
    origin          127.0.0.1:19350;
    token_traverse  on;
}
```

## Access服务器

SRS暂时不支持。

## 推流认证

SRS暂时不支持，是RTMP特殊的握手协议。

Winlin 2014.6