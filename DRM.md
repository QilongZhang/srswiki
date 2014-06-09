# DRM

DRM重要的功能就是防盗链，只有允许的用户，才能访问服务器的流。有多种DRM的方式：
* refer防盗链：检查用户从哪个网站过来的。譬如不是从公司的页面过来的人都不让看。
* token防盗链：用户在播放时，必须先申请token，SRS会回调http检查这个token合法性。
* Access服务器：专门的access服务器负责DRM。譬如adobe的access服务器。
* 推流认证：adobe的RTMP推流时，支持几种认证方式，这个也可以归于防盗链概念。

## Refer防盗链

SRS支持refer防盗链，adobe的flash在播放RTMP流时，会把页面的http url放在请求中，as客户端代码不可以更改。当然如果用自己的客户端，不用flash播放流，就可以随意伪造了；尽管如此，refer防盗链还是能防住相当一部分盗链。

配置Refer防盗链，在vhost中开启refer即可，可以指定publish和play的refer：

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

## Token防盗链

token类似于refer，不过是放在RTMP url中，或者在connect的请求参数中：
* token在RTMP url，譬如：`rtmp://vhost/app?token=xxxx/stream`，这样服务器在on_connect回调接口中，就会把url带过去验证。参考：[HTTP callback](https://github.com/winlinvip/simple-rtmp-server/wiki/HTTPCallback)
* token在connect的参数中：as函数NetConnection.connect(url, token)，服务器也可以拿到这个token。注意：SRS目前不支持。

token比refer更强悍，可以指定超时时间，可以变更token之类。可惜就是需要服务器端做定制，做验证。SRS提供http回调来做验证，已经有人用这种方式做了，比较简单靠谱。

举个常用的token认证的例子：

1. 用户在web页面登录，服务器可以生成一个token，譬如token=md5(time+id+私钥+有效期)=88195f8943e5c944066725df2b1706f8
1. 服务器返回给用户一个地址，带token，譬如：rtmp://192.168.1.10/live?time=1402307089&expire=3600&token=88195f8943e5c944066725df2b1706f8/livestream
1. 配置srs的http回调，`on_connect http://127.0.0.1:8085/api/v1/clients;`，参考：[HTTP callback](https://github.com/winlinvip/simple-rtmp-server/wiki/HTTPCallback#%E9%85%8D%E7%BD%AEsrs)
1. 用户推流时，srs会回调那个地址，解析请求的内容，里面的tcUrl就有那些认证信息。按同样的算法验证，如果md5变了就返回错误，srs就会拒绝连接。如果返回0就会接受连接。

## Access服务器

SRS暂时不支持。

## 推流认证

SRS暂时不支持，是RTMP特殊的握手协议。

Winlin 2014.6