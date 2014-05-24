# LiveShow

公用机器是SRS提供给所有人使用的服务器。

## 用途

SRS感谢捐赠，我用这些捐赠购买公网阿里云的虚拟主机。这些机器的用处：
* 大家测试和学习使用
* 部署SRS的demo环境
* 做性能测试
* 自动编译和回归测试
* 版本发布
* 发行版本下载

## 机器信息

这些机器的列表：

<table>
<tr>
<th>供应商</th>
<th>公网IP</th>
<th>地域</th>
<th>是否开放</th>
<th>带宽</th>
<th>默认流</th>
<th>DEMO</th>
</tr>
<tr>
<td><a href="http://www.aliyun.com/product/ecs/">阿里云主机</a></td>
<td>182.92.80.26</td>
<td>北京</td>
<td>开放</td>
<td>5Mbps</td>
<td><a href="http://182.92.80.26:8085/players/srs_player.html?vhost=182.92.80.26&stream=livestream&autostart=true" target="_blank">livestream</a></td>
<td><a href="http://182.92.80.26:8085" target="_blank">DEMO</a></td>
</tr>
</table>

## SRS配置

公用机器上配置了默认vhost，有需要可以联系我添加新的vhost。

```
listen              1935;
http_api {
    enabled         on;
    listen          1985;
}
http_stream {
    enabled         on;
    listen          8080;
    dir             ./objs/nginx/html;
}
vhost __defaultVhost__ {
    hls {
        enabled         on;
        hls_path        ./objs/nginx/html;
        hls_fragment    10;
        hls_window      60;
    }
    ingest livestream {
        enabled      on;
        input {
            type    file;
            url     ./doc/source.200kbps.768x320.flv;
        }
        ffmpeg      ./objs/srs_ingest_flv_ssl;
        engine {
            enabled          off;
            output          rtmp://127.0.0.1:[port]/live?vhost=[vhost]/livestream;
        }
    }
}
```

实例流的播放地址：[http://182.92.80.26:8085/players/srs_player.html?vhost=182.92.80.26&stream=livestream&autostart=true](http://182.92.80.26:8085/players/srs_player.html?vhost=182.92.80.26&stream=livestream&autostart=true)

![SRS](http://182.92.80.26:8085/srs/wiki/images/srs.qq.jpg)

Winlin 2014.5