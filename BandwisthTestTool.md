# 带宽测试

视频很卡，播放不了，缓冲区突然很大，推流上不来，都有可能是带宽过低，SRS支持测试客户端到服务器的带宽。

SRS配置文件中需要打开带宽测试配置，一般是单独加一个vhost支持测速。譬如：

```bash
listen              1935;
vhost __defaultVhost__ {
}

vhost bandcheck.srs.com {
    enabled         on;
    chunk_size      65000;
    bandcheck {
        enabled         on;
        key             "35c9b402c12a7246868752e2878f7e0e";
        interval        30;
        limit_kbps      4000;
    }
}
```

<strong>假设服务器的IP是：192.168.1.170</strong>

启动后用带宽测试客户端就可以查看：[http://winlinvip.github.io/srs.release/trunk/research/players/srs_bwt.html?server=192.168.1.170](http://winlinvip.github.io/srs.release/trunk/research/players/srs_bwt.html?server=192.168.1.170)

Winlin