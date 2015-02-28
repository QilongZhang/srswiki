# 分发方式：HLS

SRS支持HLS/RTMP两种成熟而且广泛应用的流媒体分发方式。

RTMP指Adobe的RTMP(Realtime Message Protocol)，广泛应用于低延时直播，也是编码器和服务器对接的实际标准协议，在PC（Flash）上有最佳观看体验和最佳稳定性。

HLS指Apple的HLS(Http Live Streaming)，本身就是Live（直播）的，不过Vod（点播）也能支持。HLS是Apple平台的标准流媒体协议，和RTMP在PC上一样支持得天衣无缝。

HLS和RTMP两种分发方式，就可以支持所有的终端。RTMP参考[RTMP分发](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_CN_DeliveryRTMP)。

RTMP和HLS的比较参考：[RTMP PK HLS](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_CN_RTMP.PK.HTTP)

部署分发HLS的实例，参考：[Usage: HLS](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_CN_SampleHLS)

## 应用场景

HLS主要的应用场景包括：
* 跨平台：PC主要的直播方案是RTMP，也有一些库能播放HLS，譬如jwplayer，基于osmf的hls插件也一大堆。所以实际上如果选一种协议能跨PC/Android/IOS，那就是HLS。
* IOS上苛刻的稳定性要求：IOS上最稳定的当然是HLS，稳定性不差于RTMP在PC-flash上的表现。
* 友好的CDN分发方式：目前CDN对于RTMP也是基本协议，但是HLS分发的基础是HTTP，所以CDN的接入和分发会比RTMP更加完善。能在各种CDN之间切换，RTMP也能，只是可能需要对接测试。
* 简单：HLS作为流媒体协议非常简单，apple支持得也很完善。Android对HLS的支持也会越来越完善。至于DASH/HDS，好像没有什么特别的理由，就像linux已经大行其道而且开放，其他的系统很难再广泛应用。

总之，SRS支持HLS主要是作为输出的分发协议，直播以RTMP+HLS分发，满总各种应用场景。点播以HLS为主。

## 分发方式比较

详见下表：

<table>
<thead>
<tr>
<th>分发</th>
<th>平台</th>
<th>协议</th>
<th>公司</th>
<th>说明</th>
</tr>
</thead>
<tbody>
<tr>
<td>RTMP</td>
<td>Windows Flash</td>
<td>RTMP</td>
<td>Adobe</td>
<td>主流的低延时分发方式，<br/>Adobe对RTMP是Flash原生支持方式，<br/>FMS（Adobe Media Server前身），<br/>就是Flash Media Server的简写，可见Flash播放RTMP是多么“原生”，<br/>就像浏览器打开http网页一样“原生”，<br/>经测试，Flash播放RTMP流可以10天以上不间断播放。</td>
</tr>
<tr>
<td>HLS</td>
<td>Apple/<br/>Android</td>
<td>HTTP</td>
<td>Apple/<br/>Google</td>
<td>延时一个切片以上（一般10秒以上），<br/>Apple平台上HLS的效果比PC的RTMP还要好，<br/>而且Apple所有设备都支持，<br/>Android最初不支持HLS，后来也支持了，<br/>但测试发现支持得还不如Apple，<br/>不过观看是没有问题，稳定性稍差，<br/>所以有些公司专门做Android上的流媒体播放器。</td>
</tr>
<tr>
<td>HDS</td>
<td>-</td>
<td>HTTP</td>
<td>Adobe</td>
<td>Adobe自己的HLS，<br/>协议方面做得是复杂而且没有什么好处，<br/>国内没有什么应用，传说国外有，<br/>像这种东西SRS是绝对不会支持的。</td>
</tr>
<tr>
<td><a href='http://en.wikipedia.org/wiki/Dynamic_Adaptive_Streaming_over_HTTP'>DASH</a></td>
<td>-</td>
<td>HTTP</td>
<td>-</td>
<td>Dynamic Adaptive Streaming over HTTP (DASH)，<br/>一些公司提出的HLS，<br/>国内还没有应用，国外据说有用了，<br/>nginx-rtmp好像已经支持了，<br/>明显这个还不成熟，SRS是不会支持的。</td>
</tr>
</tbody>
</table>

## HLS简介

HLS是提供一个m3u8地址，Apple的Safari浏览器直接就能打开m3u8地址，譬如：
```bash
http://demo.srs.com/live/livestream.m3u8
```

Android不能直接打开，需要使用html5的video标签，然后在浏览器中打开这个页面即可，譬如：
```html
<!-- livestream.html -->
<video width="640" height="360"
        autoplay controls autobuffer 
        src="http://demo.srs.com/live/livestream.m3u8"
        type="application/vnd.apple.mpegurl">
</video>
```

HLS的[m3u8](https://github.com/winlinvip/simple-rtmp-server/blob/master/trunk/doc/hls-m3u8-draft-pantos-http-live-streaming-12.txt)，是一个ts的列表，也就是告诉浏览器可以播放这些ts文件，譬如：
```bash
#EXTM3U
#EXT-X-VERSION:3
#EXT-X-MEDIA-SEQUENCE:64
#EXT-X-TARGETDURATION:12
#EXTINF:11.550
livestream-64.ts
#EXTINF:5.250
livestream-65.ts
#EXTINF:7.700
livestream-66.ts
#EXTINF:6.850
livestream-67.ts
```

有几个关键的参数，这些参数在SRS的配置文件中都有配置项：
* EXT-X-TARGETDURATION：所有切片的最大时长。有些Apple设备这个参数不正确会无法播放。SRS会自动计算出ts文件的最大时长，然后更新m3u8时会自动更新这个值。用户不必自己配置。
* EXTINF：ts切片的实际时长，SRS提供配置项hls_fragment，但实际上的ts时长还受gop影响，详见下面配置HLS的说明。
* ts文件的数目：SRS可配置hls_window，指定m3u8中保存多少个切片，SRS会自动清理旧的切片。
* livestream-67.ts：SRS会自动维护ts切片的文件名，在编码器重推之后，这个编号会继续增长，保证流的连续性。直到SRS重启，这个编号才重置为0。

譬如，每个ts切片为10秒，窗口为60秒，那么m3u8中会保存6个ts切片。

## HLS流程

HLS的主要流程是：

1. FFMPEG或FMLE或编码器，推送RTMP流到SRS，编码为H264/AAC（其他编码需要SRS转码）
1. SRS将RTMP切片成TS，并生成M3U8。若流非H264和AAC，则停止输出HLS（可使用SRS转码到SRS其他vhost或流，然后再切HLS）。
1. 访问m3u8，srs内置的http服务器（或者通用http服务器）提供HTTP服务。

注意：SRS只需要在Vhost上配置HLS，会自动根据流的app创建目录，但是配置的hls_path必须自己创建

## HLS Config

conf/full.conf中的with-hls.vhost.com是HLS配置的实例，可以拷贝到默认的Vhost，例如：
```bash
vhost __defaultVhost__ {
    hls {
        # whether the hls is enabled.
        # if off, donot write hls(ts and m3u8) when publish.
        # default: off
        enabled         on;
        # the hls fragment in seconds, the duration of a piece of ts.
        # default: 10
        hls_fragment    10;
        # the hls m3u8 target duration ratio,
        #   EXT-X-TARGETDURATION = hls_td_ratio * hls_fragment // init
        #   EXT-X-TARGETDURATION = max(ts_duration, EXT-X-TARGETDURATION) // for each ts
        # @see https://github.com/winlinvip/simple-rtmp-server/issues/304#issuecomment-74000081
        # default: 1.5
        hls_td_ratio    1.5;
        # the hls window in seconds, the number of ts in m3u8.
        # default: 60
        hls_window      60;
        # the error strategy. canbe:
        #       ignore, when error ignore and disable hls.
        #       disconnect, when error disconnect the publish connection.
        #       continue, when error ignore and continue output hls.
        # @see https://github.com/winlinvip/simple-rtmp-server/issues/264
        # default: ignore
        hls_on_error    ignore;
        # the hls storage: disk, ram or both.
        #       disk, to write hls m3u8/ts to disk.
        #       ram, serve m3u8/ts in memory, which use embeded http server to delivery.
        #       both, disk and ram.
        # default: disk
        hls_storage     disk;
        # the hls output path.
        # the app dir is auto created under the hls_path.
        # for example, for rtmp stream:
        #       rtmp://127.0.0.1/live/livestream
        #       http://127.0.0.1/live/livestream.m3u8
        # where hls_path is /hls, srs will create the following files:
        #       /hls/live       the app dir for all streams.
        #       /hls/live/livestream.m3u8   the HLS m3u8 file.
        #       /hls/live/livestream-1.ts   the HLS media/ts file.
        # in a word, the hls_path is for vhost.
        # default: ./objs/nginx/html
        hls_path        ./objs/nginx/html;
        # the hls mount for hls_storage ram,
        # which use srs embeded http server to delivery HLS,
        # where the mount specifies the HTTP url to mount.
        # @see the mount of http_remux.
        # @remark the hls_mount must endswith .m3u8.
        # default: [vhost]/[app]/[stream].m3u8
        hls_mount       [vhost]/[app]/[stream].m3u8;
    }
}
```

其中hls配置就是HLS的配置，主要配置项如下：
* enabled：是否开启HLS，on/off，默认off。
* hls_fragment：秒，指定ts切片的最小长度。实际上ts文件的长度由以下公式决定：
```bash
ts文件时长 = max(hls_fragment, gop_size)
hls_fragment：配置文件中的长度。譬如：5秒。
gop_size：编码器配置的gop的长度，譬如ffmpeg指定fps为20帧/秒，gop为200帧，则gop_size=gop/fps=10秒。
那么，最终ts的时长为max(5, 10) = 10秒。这也是为什么有些流配置了hls_fragment，但是ts时长仍然比这个大的原因。
```
* hls_td_ratio：倍数。控制m3u8的EXT-X-TARGETDURATION，参考：https://github.com/winlinvip/simple-rtmp-server/issues/304#issuecomment-74000081
* hls_window：秒，指定HLS窗口大小，即m3u8中ts文件的时长之和，超过总时长后，丢弃第一个m3u8中的第一个切片，直到ts的总时长在这个配置项范围之内。即SRS保证下面的公式：
```bash
hls_window >= sum(m3u8中每个ts的时长)
```
* hls_storage：存储方式，可以是ram(内存)，disk(磁盘)，both(两者同时支持)。若指定为disk或both，则需要指定hls_path。若指定ram或both，则需要指定hls_mount。具体参考后面的描述。
* hls_path：HLS的m3u8和ts文件保存的路径。SRS会自动加上app和stream名称。譬如：
```bash
对于RTMP流：rtmp://localhost/live/livestream
HLS配置路径：hls_path        /data/nginx/html;
那么会生成以下文件：
/data/nginx/html/live/livestream.m3u8
/data/nginx/html/live/livestream-0.ts
/data/nginx/html/live/livestream-1.ts
/data/nginx/html/live/livestream-2.ts
最后的HLS地址为：http://localhost/live/livestream.m3u8
```
* hls_mount: 内存HLS的M3u8/ts挂载点，和`http_remux`的`mount`含义一样。参考：[http_remux](https://github.com/winlinvip/simple-rtmp-server/wiki/v2_CN_DeliveryHttpStream#http-live-stream-config)。

部署分发HLS的实例，参考：[Usage: HLS](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_CN_SampleHLS)

## HLSAudioOnly

SRS支持分发HLS纯音频流，当RTMP流没有视频，且音频为aac（可以使用转码转为aac，参考[Usage: Transcode2HLS](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_CN_SampleTranscode2HLS)），SRS只切片音频。

若RTMP流中已经有视频和音频，需要支持纯音频HLS流，可以用转码将视频去掉，参考：[转码: 禁用流](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_CN_FFMPEG#%E7%A6%81%E7%94%A8)。然后分发音频流。

分发纯音频流不需要特殊配置，和HLS分发一样，参考：[Usage: HLS](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_CN_SampleHLS)

## HLS和Forward

Forward的流和普通流不做区分，若forward的流所在的VHOST配置了HLS，一样会应用HLS配置进行切片。

因此，可以对原始流进行Transcode之后，保证流符合h.264/aac的规范，然后forward到多个配置了HLS的VHOST进行切片。支持多个源站的热备。

## HLS和Transcode

HLS要求RTMP流的编码为h.264+aac，否则会自动禁用HLS，会出现RTMP流能看HLS流不能看（或者看到的HLS是之前的流）。

Transcode将RTMP流转码后，可以让SRS接入任何编码的RTMP流，然后转换成HLS要求的h.264/aac编码方式。

配置Transcode时，若需要控制ts长度，需要[配置ffmpeg编码的gop](http://ffmpeg.org/ffmpeg-codecs.html#Options-7)，譬如：
```bash
vhost hls.transcode.vhost.com {
    transcode {
        enabled     on;
        ffmpeg      ./objs/ffmpeg/bin/ffmpeg;
        engine hls {
            enabled         on;
            vfilter {
            }
            vcodec          libx264;
            vbitrate        500;
            vfps            20;
            vwidth          768;
            vheight         320;
            vthreads        2;
            vprofile        baseline;
            vpreset         superfast;
            vparams {
                g           100;
            }
            acodec          libaacplus;
            abitrate        45;
            asample_rate    44100;
            achannels       2;
            aparams {
            }
            output          rtmp://127.0.0.1:[port]/[app]?vhost=[vhost]/[stream]_[engine];
        }
    }
}
```
该FFMPEG转码参数，指定gop时长为100/20=5秒，fps帧率（vfps=20），gop帧数（g=100）。

## HLS自适应码流

SRS目前不支持HLS自适应码流，需要调研这个功能。

## HLS实例

### live.m3u8

```
#EXTM3U
#EXT-X-VERSION:3
#EXT-X-ALLOW-CACHE:NO
#EXT-X-TARGETDURATION:13
#EXT-X-MEDIA-SEQUENCE:430
#EXTINF:11.800
news-430.ts
#EXTINF:10.120
news-431.ts
#EXTINF:11.160
news-432.ts
```

### event.m3u8

```
#EXTM3U
#EXT-X-VERSION:3
#EXT-X-ALLOW-CACHE:NO
#EXT-X-TARGETDURATION:13
#EXT-X-MEDIA-SEQUENCE:430
#EXT-X-PLAYLIST-TYPE:EVENT
#EXTINF:11.800
news-430.ts
#EXTINF:10.120
news-431.ts
#EXTINF:11.160
news-432.ts
```

### vod.m3u8

```
#EXTM3U
#EXT-X-VERSION:3
#EXT-X-ALLOW-CACHE:NO
#EXT-X-TARGETDURATION:13
#EXT-X-MEDIA-SEQUENCE:430
#EXT-X-PLAYLIST-TYPE:VOD
#EXTINF:11.800
news-430.ts
#EXTINF:10.120
news-431.ts
#EXTINF:11.160
news-432.ts
#EXT-X-ENDLIST
```

### loop.m3u8

```
#EXTM3U
#EXT-X-VERSION:3
#EXT-X-ALLOW-CACHE:NO
#EXT-X-TARGETDURATION:13
#EXT-X-MEDIA-SEQUENCE:430
#EXT-X-PLAYLIST-TYPE:VOD
#EXTINF:11.800
news-430.ts
#EXTINF:10.120
news-431.ts
#EXT-X-DISCONTINUITY
#EXTINF:11.952
news-430.ts
#EXTINF:12.640
news-431.ts
#EXTINF:11.160
news-432.ts
#EXT-X-DISCONTINUITY
#EXTINF:11.751
news-430.ts
#EXTINF:2.040
news-431.ts
#EXT-X-ENDLIST
```

## HLS in RAM

SRS支持内存直接分发HLS，不写入磁盘。参考：[136](https://github.com/winlinvip/simple-rtmp-server/issues/136)

配置实例，参考`conf/ram.hls.conf`：

```
http_server {
    enabled         on;
    listen          8080;
    dir             ./objs/nginx/html;
}
vhost __defaultVhost__ {
    hls {
        enabled         on;
        hls_fragment    10;
        hls_window      60;
        hls_storage     ram;
        hls_mount       /[app]/[stream].m3u8;
    }
}
```

必须开启SRS的内置HTTP服务器功能，否则无法分发HLS。

譬如，推流地址：`rtmp://192.168.1.173/live/livestream`，上面的配置生成的HLS地址是：`http://192.168.1.173:8080/live/livestream.m3u8`

配置项的具体含义参考：[Config](https://github.com/winlinvip/simple-rtmp-server/wiki/v2_CN_DeliveryHLS#hls-config)

## SRS如何支持HLS

SRS1的HLS主要参考了nginx-rtmp的HLS实现方式，SRS2已经按照HLS标准规范重新实现。

Winlin 2015.2