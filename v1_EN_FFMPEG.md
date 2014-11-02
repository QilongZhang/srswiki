# Live Streaming Transcode

SRS can transcode the RTMP stream and output to any RTMP server, typically itself.

## Use Scenario

The important use scenaio of FFMPEG:
* One in N out: Publish a high resolution video with big bitrate, for intance, h.264 5Mbps 1080p. Then use FFMPEG to transcode to multiple bitrates, for example, 1080p/720p/576p, the 576p is for mobile devices.
* Support multiple screen: The stream published by flash is in h264/vp6/mp3/speex codec. Use FFMPEG to transcode to HLS(h264+aac) for IOS/Android.
* Stream filters: For example, add logo to stream. SRS support all filters of FFMPEG.

## Workflow

The workflow of SRS transcoding:

1. Encoder publish RTMP to SRS.
1. SRS fork process for FFMPEG when transcode configed.
1. The forked FFMPEG transcode stream and publish to SRS or other servers.

## Transcode Config

The SRS transcoding feature can apply on vhost, app or specified stream.

```bash
listen              1935;
vhost __defaultVhost__ {
    # apply on vhost, for all streams.
    transcode {
        enabled     on;
        ffmpeg      ./objs/ffmpeg/bin/ffmpeg;
        engine ff {
            # whether the engine is enabled
            # default: off.
            enabled         on;
            # ffmpeg filters, follows the main input.
            vfilter {
            }
            # video encoder name. can be:
            # libx264: use h.264(libx264) video encoder.
            # copy: donot encoder the video stream, copy it.
            # vn: disable video output.
            vcodec          libx264;
            # video bitrate, in kbps
            vbitrate        1500;
            # video framerate.
            vfps            25;
            # video width, must be even numbers.
            vwidth          768;
            # video height, must be even numbers.
            vheight         320;
            # the max threads for ffmpeg to used.
            vthreads        12;
            # x264 profile, @see x264 -help, can be:
            # high,main,baseline
            vprofile        main;
            # x264 preset, @see x264 -help, can be: 
            # ultrafast,superfast,veryfast,faster,fast
            # medium,slow,slower,veryslow,placebo
            vpreset         medium;
            # other x264 or ffmpeg video params
            vparams {
            }
            # audio encoder name. can be:
            # libaacplus: use aac(libaacplus) audio encoder.
            # copy: donot encoder the audio stream, copy it.
            # an: disable audio output.
            acodec          libaacplus;
            # audio bitrate, in kbps. [16, 72] for libaacplus.
            abitrate        70;
            # audio sample rate. for flv/rtmp, it must be:
            # 44100,22050,11025,5512
            asample_rate    44100;
            # audio channel, 1 for mono, 2 for stereo.
            achannels       2;
            # other ffmpeg audio params
            aparams {
            }
            # output stream. variables:
            # [vhost] the input stream vhost.
            # [port] the intput stream port.
            # [app] the input stream app.
            # [stream] the input stream name.
            # [engine] the tanscode engine name.
            output          rtmp://127.0.0.1:[port]/[app]?vhost=[vhost]/[stream]_[engine];
        }
    }
}
```

The config apply to all streams of this vhost, for example:
* Publish stream to: rtmp://dev:1935/live/livestream
* Play the origin stream: rtmp://dev:1935/live/livestream
* Play the transcoded stream: rtmp://dev:1935/live/livestream_ff

The output url contains some variables:
* [vhost] The input stream vhost, for instance, dev.ossrs.net
* [port] The input stream port, for instance, 1935
* [app] The input stream app, for instance, live
* [stream] The intput stream name, for instance, livestream
* [engine] The transcode engine name, which follow the keyword engine, for instance, ff

Add the app or app/stream when need to apply transcode to app or stream:

```bash
listen              1935;
vhost __defaultVhost__ {
    # Transcode all streams of app "live"
    transcode live {
    }
}
```

Or for stream:

```bash
listen              1935;
vhost __defaultVhost__ {
    # Transcode stream name "livestream" and app is "live"
    transcode live/livestream{
    }
}
```

## Transcode Rulers

SRS的转码参数全是FFMPEG的参数，有些参数SRS做了自定义，见下表。

<table>
<tr>
<th>SRS参数</th><th>FFMPEG参数</th><th>实例</th><th>说明</th>
</tr>
<tr>
<td>vcodec</td><td>vcodec</td><td>ffmpeg ... -vcodec libx264 ...</td><td>指定视频编码器</td>
</tr>
<tr>
<td>vbitrate</td><td>b:v</td><td>ffmpeg ... -b:v 500000 ...</td><td>输出的视频码率</td>
</tr>
<tr>
<td>vfps</td><td>r</td><td>ffmpeg ... -r 25 ...</td><td>输出的视频帧率</td>
</tr>
<tr>
<td>vwidth/vheight</td><td>s</td><td>ffmpeg ... -s 400x300 -aspect 400:300 ...</td><td>输出的视频宽度x高度，以及宽高比</td>
</tr>
<tr>
<td>vthreads</td><td>threads</td><td>ffmpeg ... -threads 8 ...</td><td>编码线程数</td>
</tr>
<tr>
<td>vprofile</td><td>profile:v</td><td>ffmpeg ... -profile:v high ...</td><td>编码x264的profile</td>
</tr>
<tr>
<td>vpreset</td><td>preset</td><td>ffmpeg ... -preset medium ...</td><td>编码x264的preset</td>
</tr>
<tr>
<td>acodec</td><td>acodec</td><td>ffmpeg ... -acodec libaacplus ...</td><td>音频编码器</td>
</tr>
<tr>
<td>abitrate</td><td>b:a</td><td>ffmpeg ... -b:a 70000 ...</td><td>音频输出码率。libaacplus：16-72k</td>
</tr>
<tr>
<td>asample_rate</td><td>ar</td><td>ffmpeg ... -ar 44100 ...</td><td>音频采样率</td>
</tr>
<tr>
<td>achannels</td><td>ac</td><td>ffmpeg ... -ac 2 ...</td><td>音频声道</td>
</tr>
</table>

另外，还有三个是可以加其他ffmpeg参数：
* vfilter：添加在vcodec之前的滤镜参数。
* vparams：添加在vcodec之后，acodec之前的视频编码参数。
* aparams：添加在acodec之后，-y之前的音频编码参数。

这些参数应用的顺序是：
```bash
ffmpeg -f flv -i <input_rtmp> {vfilter} -vcodec ... {vparams} -acodec ... {aparams} -f flv -y {output}
```

具体参数可以查看SRS的日志，譬如：
```bash
[2014-02-28 21:38:09.603][4][trace][start] start transcoder, 
log: ./objs/logs/encoder-__defaultVhost__-live-livestream.log, 
params: ./objs/ffmpeg/bin/ffmpeg -f flv -i 
rtmp://127.0.0.1:1935/live?vhost=__defaultVhost__/livestream 
-vcodec libx264 -b:v 500000 -r 25.00 -s 768x320 -aspect 768:320 
-threads 12 -profile:v main -preset medium -acodec libaacplus 
-b:a 70000 -ar 44100 -ac 2 -f flv 
-y rtmp://127.0.0.1:1935/live?vhost=__defaultVhost__/livestream_ff 
```

## FFMPEG日志过大

FFMPEG启动后，SRS会将stdout和stderr都定向到日志文件，譬如`./objs/logs/encoder-__defaultVhost__-live-livestream.log`，有时候日志会比较大。可以配置ffmpeg输出较少日志：

```bash
listen              1935;
vhost __defaultVhost__ {
    transcode {
        enabled     on;
        ffmpeg      ./objs/ffmpeg/bin/ffmpeg;
        engine ff {
            enabled         on;
            vfilter {
                # -v quiet
                v           quiet;
            }
            vcodec          libx264;
            vbitrate        500;
            vfps            25;
            vwidth          768;
            vheight         320;
            vthreads        12;
            vprofile        main;
            vpreset         medium;
            vparams {
            }
            acodec          libaacplus;
            abitrate        70;
            asample_rate    44100;
            achannels       2;
            aparams {
            }
            output          rtmp://127.0.0.1:[port]/[app]?vhost=[vhost]/[stream]_[engine];
        }
    }
}
```

对ffmpeg添加`-v quiet`参数即可。

## 拷贝

可以配置vcodec/acodec copy，实现不转码。譬如，视频为h264编码，但是音频是mp3/speex，需要转码音频为aac，然后切片为HLS输出。

```bash
listen              1935;
vhost __defaultVhost__ {
    transcode {
        enabled     on;
        ffmpeg      ./objs/ffmpeg/bin/ffmpeg;
        engine ff {
            enabled         on;
            vcodec          copy;
            acodec          libaacplus;
            abitrate        70;
            asample_rate    44100;
            achannels       2;
            aparams {
            }
            output          rtmp://127.0.0.1:[port]/[app]?vhost=[vhost]/[stream]_[engine];
        }
    }
}
```

或者拷贝视频和音频：
```bash
listen              1935;
vhost __defaultVhost__ {
    transcode {
        enabled     on;
        ffmpeg      ./objs/ffmpeg/bin/ffmpeg;
        engine ff {
            enabled         on;
            vcodec          copy;
            acodec          copy;
            output          rtmp://127.0.0.1:[port]/[app]?vhost=[vhost]/[stream]_[engine];
        }
    }
}
```

## 禁用

可以禁用视频或者音频，只输出音频或视频。譬如，电台可以丢弃视频，对音频转码为aac后输出HLS。

可以配置vcodec为vn，acodec为an实现禁用。例如：

```bash
listen              1935;
vhost __defaultVhost__ {
    transcode {
        enabled     on;
        ffmpeg      ./objs/ffmpeg/bin/ffmpeg;
        engine vn {
            enabled         on;
            vcodec          vn;
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

该配置只输出纯音频，编码为aac。

## 其他转码配置

conf/full.conf中有很多FFMPEG转码配置的实例，也可以参考ffmpeg的命令行。
* mirror.transcode.srs.com 将视频流上半截，翻转到下半截，看起来像个镜子。
* drawtext.transcode.srs.com 加文字水印。
* crop.transcode.srs.com 剪裁视频。
* logo.transcode.srs.com 添加图片logo。
* audio.transcode.srs.com 只对音频转码。
* copy.transcode.srs.com 不转码只转封装，类似于SRS的Forward。
* all.transcode.srs.com 转码参数的详细说明。
* ffempty.transcode.srs.com 一个ffmpeg的mock，不转码只打印参数。
* app.transcode.srs.com 对指定的app的流转码。
* stream.transcode.srs.com 对指定的流转码。
* vn.transcode.srs.com 只输出音频，禁止视频输出。

## ARM下转码

SRS可以在ARM下调用系统的ffmpeg转码，参考：[Raspberry pi 转码](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_CN_ARMTranscode)

注意：使用自己的工具时，需要禁用ffmpeg，但是打开transcode选项：`--with-transcode --without-ffmpeg`，这样就不会编译ffmpeg，但是编译了直播转码功能。参考：[Build](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_CN_Build)

## FFMPEG转码flash流

flash可以当作编码器推流，参考演示中的编码器或者视频会议。flash只支持speex/nellymoser/pcma/pcmu，但flash会有一个特性，没有声音时就没有音频包。FFMPEG会依赖于这些音频包，如果没有会认为没有音频。

所以FFMPEG用来转码flash推上来的RTMP流时，可能会有一个问题：ffmpeg认为没有音频。

另外，FFMPEG取flash的流的时间会很长，也可能是在等待这些音频包。

## FFMPEG

FFMPEG相关链接：
* [ffmpeg.org](http://ffmpeg.org)
* [ffmpeg命令行](http://ffmpeg.org/ffmpeg.html)
* [ffmpeg滤镜](http://ffmpeg.org/ffmpeg-filters.html)
* [ffmpeg编解码参数](http://ffmpeg.org/ffmpeg-codecs.html)

Winlin 2014.10