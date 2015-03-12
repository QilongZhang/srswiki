# DeliveryHDS

HDS指Adobe的Http Dynamic Stream，和Apple的[HLS](https://github.com/winlinvip/simple-rtmp-server/wiki/v2_CN_DeliveryHLS)类似。

# Build

编译SRS时可以打开或者关闭HDS，详细参考：[Build](https://github.com/winlinvip/simple-rtmp-server/wiki/v2_CN_Build)

```
./configure --with-hds
```

# Player

Adobe的HDS可以在Flash播放器中，使用[OSMF播放器](http://www.ossrs.net/players/osmf.html)打开。

输入地址：`http://ossrs.net:8081/live/livestream.f4m`

# HDS Config

conf/full.conf中hds.srs.com是HDS的配置实例：

```
vhost __defaultVhost__ {
    hds {
        # whether hds enabled
        # default: off
        enabled         on;
        # the hds fragment in seconds.
        # default: 10
        hds_fragment    10;
        # the hds window in seconds, erase the segment when exceed the window.
        # default: 60
        hds_window      60;
        # the path to store the hds files.
        # default: ./objs/nginx/html
        hds_path        ./objs/nginx/html;
    }
}
```

配置项的意义和HLS类似，参考[HLS config](https://github.com/winlinvip/simple-rtmp-server/wiki/v2_CN_DeliveryHLS#hls-config)

# Why HDS

为何SRS要在SRS2引入HDS？主要是SRS的HTTP服务器重写，以及文杰哥对于HDS很熟悉。另外，加入HDS不会对SRS现有结构有影响。

Winlin 2015.3