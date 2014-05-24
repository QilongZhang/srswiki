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
<th>开放</th>
<th>带宽</th>
<th>磁盘</th>
<th>默认流</th>
<th>DEMO</th>
</tr>
<tr>
<td><a href="http://www.aliyun.com/product/ecs/">阿里云</a></td>
<td>182.92.80.26</td>
<td>北京</td>
<td>开放</td>
<td>5Mbps</td>
<td>100GB</td>
<td><a href="http://182.92.80.26:8085/players/srs_player.html?vhost=182.92.80.26&stream=livestream&autostart=true" target="_blank">livestream</a></td>
<td><a href="http://182.92.80.26:8085" target="_blank">DEMO</a></td>
</tr>
</table>

## 官方域名

感谢JOHNNY贡献了[ossrs.net](http://www.ossrs.net)域名，主要的链接：
* [SRS官方主页](http://www.ossrs.net) SRS的官方主页。
* [SRS官方HTTP-API](http://www.ossrs.net:1985/api/v1/summaries) SRS官方服务器的SRS的api。
* [SRS虚拟直播流](http://www.ossrs.net:8085/players/srs_player.html?vhost=www.ossrs.net&stream=livestream&autostart=true) 观看服务器上的虚拟轮播流（虚拟直播流）。大家可以上传=>自动转码=>人工审查=>发布视频到直播流。
* SRS虚拟直播流上传 `ftp://ftpuser:srs@www.ossrs.net` 上传到服务器后，服务器转码集群会自动转码，转码完毕后需要人工视频审查，审查没有问题请通知我，将上传的文件加入轮播流。
* [SRS使用的转码集群](http://www.ossrs.net:1971/) SRS官方服务器的虚拟直播流的转码集群，由[chnvideo.com](http://chnvideo.com)供应。
* [SRS官方视频审查](http://www.ossrs.net/srs-preview/) SRS官方服务器的虚拟直播流的审查地址，审查通过后通知我将视频发布到虚拟直播流。

## 默认演示流轮播

大家可以上传电影到SRS服务器，有100GB空间，上传的电影经过转码，我审核通过后，会自动加入播放列表，随机轮流播放。

使用ftp上传地址：`ftp://ftpuser:srs@www.ossrs.net`

上传完毕后请告知我，推荐使用ftp工具上传，编码使用utf-8。

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

## SRS

![SRS](http://182.92.80.26:8085/srs/wiki/images/srs.qq.jpg)

Winlin 2014.5