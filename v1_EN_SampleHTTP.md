# SRS HTTP server deploy example

SRS内嵌了http服务器，支持分发hls流和文件。

以分发HLS为例，使用SRS分发RTMP和HLS流，不依赖于外部服务器。

<strong>假设服务器的IP是：192.168.1.170</strong>

<strong>Step 1, get SRS.</strong> For detail, read [GIT](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_Git)

```bash
git clone https://github.com/winlinvip/simple-rtmp-server
cd simple-rtmp-server/trunk
```

Or update the exists code:

```bash
git pull
```

<strong>Step 2, build SRS.</strong> For detail, read [Build](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_Build)

```bash
./configure --disable-all --with-hls --with-ssl --with-http-server && make
```

<strong>第三步，编写SRS配置文件。</strong>详细参考[HLS分发](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_DeliveryHLS)和[HTTP服务器](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_HTTPServer)

将以下内容保存为文件，譬如`conf/http.hls.conf`，服务器启动时指定该配置文件(srs的conf文件夹有该文件)。

```bash
# conf/http.hls.conf
listen              1935;
max_connections     1000;
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
}
```

备注：hls_path必须存在，srs只会自动创建${hls_path}下的app的目录。参考：[HLS分发: HLS流程](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_DeliveryHLS#hls%E6%B5%81%E7%A8%8B)

<strong>第四步，启动SRS。</strong>详细参考[HLS分发](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_DeliveryHLS)和[HTTP服务器](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_HTTPServer)

```bash
./objs/srs -c conf/http.hls.conf
```

备注：请确定srs-http-server已经启动，可以访问[http://192.168.1.170:8080/nginx.html](http://192.168.1.170:8080/nginx.html)，若能看到`nginx is ok`则没有问题。

备注：实际上提供服务的是SRS，可以看到响应头是`Server: SRS/0.9.51`之类。

<strong>第五步，启动推流编码器。</strong>详细参考[HLS分发](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_DeliveryHLS)

使用FFMPEG命令推流：

```bash
    for((;;)); do \
        ./objs/ffmpeg/bin/ffmpeg -re -i ./doc/source.200kbps.768x320.flv \
        -vcodec copy -acodec copy \
        -f flv -y rtmp://192.168.1.170/live/livestream; \
        sleep 1; \
    done
```

或使用支持h.264+aac的FMLE推流（若不支持h.264+aac，则可以使用srs转码，参考[Transcode2HLS](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_SampleTranscode2HLS)）：

```bash
FMS URL: rtmp://192.168.1.170/live
Stream: livestream
```

生成的流地址为：
* RTMP流地址为：`rtmp://192.168.1.170/live/livestream`
* HLS流地址为： `http://192.168.1.170:8080/live/livestream.m3u8`

<strong>第流步，观看RTMP流。</strong>详细参考[HLS分发](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_DeliveryHLS)

RTMP url is: `rtmp://192.168.1.170:1935/live/livestream`

User can use vlc to play the RTMP stream.

Or, use online SRS player: [http://winlinvip.github.io/srs.release/trunk/research/players/srs_player.html?vhost=__defaultVhost__&autostart=true&server=192.168.1.170&app=live&stream=livestream&port=1935](http://winlinvip.github.io/srs.release/trunk/research/players/srs_player.html?vhost=__defaultVhost__&autostart=true&server=192.168.1.170&app=live&stream=livestream&port=1935)

Note: Please replace all ip 192.168.1.170 to your server ip.

<strong>第七步，观看HLS流。</strong>详细参考[HLS分发](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_DeliveryHLS)

HLS流地址为： `http://192.168.1.170:8080/live/livestream.m3u8`

可以使用VLC观看。

或者使用在线SRS播放器播放：[http://winlinvip.github.io/srs.release/trunk/research/players/jwplayer6.html?vhost=__defaultVhost__&hls_autostart=true&server=192.168.1.170&app=live&stream=livestream&hls_port=8080](http://winlinvip.github.io/srs.release/trunk/research/players/jwplayer6.html?vhost=__defaultVhost__&hls_autostart=true&server=192.168.1.170&app=live&stream=livestream&hls_port=8080)

Note: Please replace all ip 192.168.1.170 to your server ip.

注意：VLC无法观看纯音频流，jwplayer可以观看。

分发纯音频流参考：[HLS audio only](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_DeliveryHLS#hlsaudioonly)

## Q&A

<strong>RTMP流能看，HLS看不了</strong>
* 确认srs-http-server启动并且可以访问：`nginx is ok`页面能访问。
* 确认m3u8文件能下载：浏览器打开`http://192.168.1.170:8080/live/livestream.m3u8`，ip地址换成你服务器的IP地址。
* 若m3u8能下载，可能是jwplayer的问题，使用vlc播放地址：`http://192.168.1.170:8080/live/livestream.m3u8`，ip地址换成你服务器的IP地址。
* 若VLC不能播放，将m3u8下载后，用文本编辑器打开，将m3u8文件内容发到QQ群中，或者贴到issue中。寻求帮助。
* 还有可能是编码问题，参考下面的“RTMP流和HLS流内容不一致”

<strong>RTMP流内容和HLS流内容不一致</strong>
* 一般这种问题出现在使用上面的例子推流，然后换成别的编码器推流，或者换个文件推流。
* 可能是流的编码不对（推流时使用FMLE），HLS需要h.264+aac，需要转码，参考只转码音频[Transcode2HLS](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_SampleTranscode2HLS)或者全转码[HLS+Transcode](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_DeliveryHLS#wiki-hls%E5%92%8Ctranscode)

Winlin 2014.4