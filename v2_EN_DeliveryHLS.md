# Delivery HLS

SRS supports RTMP and HLS, the most popular delivery protocol for internet.

RTMP is Adobe RTMP(Realtime Message Protocol), for low latency live streaming, and the standard protocol for internet encoder, and the best protocol for flash on PC.

HLS is Apple HLS(Http Live Streaming), for both live and vod streaming over HTTP, and the standard protocol on Apple platform.

Server deliverying HLS and RTMP can support all screen. For RTMP, see: [Delivery RTMP](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_DeliveryRTMP)。

For information about compare RTMP and HLS, read [RTMP PK HLS](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_RTMP.PK.HTTP).

For information about how to deploy SRS to support HLS, read [Usage: HLS](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_SampleHLS).

## Use Scenario

The main use scenario of HLS:
* Cross Platform: Live streaming on PC is RTMP, and some as library can play HLS on flash right now. Android 3.0 can play HLS, and Apple always support HLS.
* Industrial Strength on Apple: The most stable live streaming protocol for OSX/IOS is HLS, similar the RTMP for flash.
* Friendly for CDN: The HLS over HTTP is friendly for CDN to delivery HLS.
* Simple: The HLS is open protocol and there are lots of tools for ts.

In a word, HLS is the best delivery protocol when user donot care about the latency, for both PC and mobile(Android and IOS).

## Delivering Streams

The table bellow describes the different protocols for PC and mobile platform.

<table>
<thead>
<tr>
<th>Delivery</th>
<th>Platform</th>
<th>Protocol</th>
<th>Inventor</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>RTMP</td>
<td>Windows Flash</td>
<td>RTMP</td>
<td>Adobe</td>
<td>The RTMP is used to delivery low latency stream over internet, especially for the web explorer application for flash on PC. The RTMP allows you to publish stream to server very stable and for a long time.</td>
</tr>
<tr>
<td>HLS</td>
<td>Apple/<br/>Android</td>
<td>HTTP</td>
<td>Apple/<br/>Google</td>
<td>HLS lantency >= 10s. Android3+ supports HLS. All Apple platforms support HLS.</td>
</tr>
<tr>
<td>HDS</td>
<td>-</td>
<td>HTTP</td>
<td>Adobe</td>
<td>HDS is a protocol similar to HLS, develped by Adobe. HDS is complex and no benefits, however, SRS2 support HDS.</td>
</tr>
<tr>
<td><a href='http://en.wikipedia.org/wiki/Dynamic_Adaptive_Streaming_over_HTTP'>DASH</a></td>
<td>-</td>
<td>HTTP</td>
<td>-</td>
<td>Dash(Dynamic Adaptive Streaming over HTTP), developed by some company similar to HLS. It's a new protocol, and SRS maybe support it when it already used by many users.</td>
</tr>
</tbody>
</table>

## HLS

HLS is a http m3u8 url, which can be play in Apple Safari directly. For example:

```bash
http://demo.srs.com/live/livestream.m3u8
```

The m3u8 url must embed in HTML5 for Android. For example:

```html
<!-- livestream.html -->
<video width="640" height="360"
        autoplay controls autobuffer 
        src="http://demo.srs.com/live/livestream.m3u8"
        type="application/vnd.apple.mpegurl">
</video>
```

The [m3u8](https://github.com/winlinvip/simple-rtmp-server/blob/master/trunk/doc/hls-m3u8-draft-pantos-http-live-streaming-12.txt) of HLS is a play list actually. For example:

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

The important data item can be configed in SRS config file:

* EXT-X-TARGETDURATION: It's calc by SRS automatically. The EXT-X-TARGETDURATION tag specifies the maximum media segment duration.  The EXTINF duration of each media segment in the Playlist file, when rounded to the nearest integer, MUST be less than or equal to the target duration.  This tag MUST appear once in a Media Playlist file.  It applies to the entire Playlist file.
* EXTINF: It's calc by SRS automatically, and the max value is configed in SRS `hls_fragment`. The EXTINF tag specifies the duration of a media segment.  It applies only to the media segment that follows it, and MUST be followed by a media segment URI.  Each media segment MUST be preceded by an EXTINF tag.
* Number of ts in m3u8: The `hls_window` in seconds specifies how many ts files in m3u8, and SRS will delete the old ts files.
* Name of ts filename: For example, `livestream-67.ts`, SRS will increase the number, the next ts for instance is `livestream-68.ts`.

For example, the `hls_fragment` is 10s, and the `hls_window` is 60s, then there about 60/10=6 ts files i m3u8, and the old ts files are automatically deleted by SRS.

## HLS Workflow

The workflow of HLS: 

1. Encoder, for example, FFMPEG or FMLE, publish RTMP stream to SRS, and the codec of stream must be H.264+AAC(Use transcode for other codecs).
1. SRS demux RTMP then mux mpegts and write to ts file, update the m3u8.
1. Client, for example, the IPhone or VLC, access m3u8 provides by any web server, for instance, SRS embeded HTTP server, or nginx.

Note: SRS only need to config the HLS on vhost, and SRS will create the dir by app name.

## HLS Config

the vhost `with-hls.vhost.com` in conf/full.conf of SRS is a example to config HLS, which user can copy the hls section to vhost:

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
        # the audio overflow ratio.
        # for pure audio, the duration to reap the segment.
        # for example, the hls_fragment is 10s, hsl_aof_ratio is 2.0,
        # the segemnt will reap to 20s for pure audio.
        # default: 2.0
        hls_aof_ratio   2.0;
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
        # the m3u8 file is configed by hls_path/hls_m3u8_file, the default is:
        #       ./objs/nginx/html/[app]/[stream].m3u8
        # the ts file is configed by hls_path/hls_ts_file, the default is:
        #       ./objs/nginx/html/[app]/[stream]-[seq].ts
        # @remark the hls_path is compatible with srs v1 config.
        # default: ./objs/nginx/html
        hls_path        ./objs/nginx/html;
        # the hls m3u8 file name.
        # we supports some variables to generate the filename.
        #       [vhost], the vhost of stream.
        #       [app], the app of stream.
        #       [stream], the stream name of stream.
        # default: [app]/[stream].m3u8
        hls_m3u8_file   [app]/[stream].m3u8;
        # the hls ts file name.
        # we supports some variables to generate the filename.
        #       [vhost], the vhost of stream.
        #       [app], the app of stream.
        #       [stream], the stream name of stream.
        #       [2006], replace this const to current year.
        #       [01], replace this const to current month.
        #       [02], replace this const to current date.
        #       [15], replace this const to current hour.
        #       [04], repleace this const to current minute.
        #       [05], repleace this const to current second.
        #       [999], repleace this const to current millisecond.
        #       [timestamp],replace this const to current UNIX timestamp in ms.
        #       [seq], the sequence number of ts.
        # @see https://github.com/winlinvip/simple-rtmp-server/wiki/v2_CN_DVR#custom-path
        # @see https://github.com/winlinvip/simple-rtmp-server/wiki/v2_CN_DeliveryHLS#hls-config
        # default: [app]/[stream]-[seq].ts
        hls_ts_file     [app]/[stream]-[seq].ts;
        # the hls entry prefix, which is base url of ts url.
        # if specified, the ts path in m3u8 will be like:
        #         http://your-server/live/livestream-0.ts
        #         http://your-server/live/livestream-1.ts
        #         ...
        # optional, default to empty string.
        hls_entry_prefix http://your-server;
        # the hls mount for hls_storage ram,
        # which use srs embeded http server to delivery HLS,
        # where the mount specifies the HTTP url to mount.
        # @see the mount of http_remux.
        # @remark the hls_mount must endswith .m3u8.
        # default: [vhost]/[app]/[stream].m3u8
        hls_mount       [vhost]/[app]/[stream].m3u8;
        # the default audio codec of hls.
        # when codec changed, write the PAT/PMT table, but maybe ok util next ts.
        # so user can set the default codec for mp3.
        # the available audio codec: 
        #       aac, mp3
        # default: aac
        hls_acodec      aac;
        # the default video codec of hls.
        # when codec changed, write the PAT/PMT table, but maybe ok util next ts.
        # so user can set the default codec for pure audio(without video) to vn.
        # the available video codec:
        #       h264, vn
        # default: h264
        hls_vcodec      h264;
        # whether cleanup the old ts files.
        # default: on
        hls_cleanup     on;

        # on_hls, never config in here, should config in http_hooks.
        # for the hls http callback, @see http_hooks.on_hls of vhost hooks.callback.srs.com
        # @read https://github.com/winlinvip/simple-rtmp-server/wiki/v2_CN_DeliveryHLS#http-callback
        # @read https://github.com/winlinvip/simple-rtmp-server/wiki/v2_EN_DeliveryHLS#http-callback
        
        # on_hls_notify, never config in here, should config in http_hooks.
        # we support the variables to generate the notify url:
        #       [ts_url], replace with the ts url.
        # for the hls http callback, @see http_hooks.on_hls_notify of vhost hooks.callback.srs.com
        # @read https://github.com/winlinvip/simple-rtmp-server/wiki/v2_CN_DeliveryHLS#on-hls-notify
        # @read https://github.com/winlinvip/simple-rtmp-server/wiki/v2_EN_DeliveryHLS#on-hls-notify
    }
}
```

The section `hls` is for HLS config:
* enabled: Whether enable HLS, on to enable, off to disable. Default: off.
* hls_fragment: The HLS duration in seconds. The actual duration of ts file is by:
```bash
TS duration(s) = max(hls_fragment, gop_size)
hls_fragment: The config seconds for ts file, for example, 5s.
gop_size: The stream gop size, for example, the fps is 20, gop is 200frames, then gop_size=gop/fps=10s.
So, the actual ts duration is max(5, 10)=10s, that is why the ts duration is larger than hls_fragment.
```
* hls_td_ratio: The ratio to calc the m3u8 EXT-X-TARGETDURATION, read https://github.com/winlinvip/simple-rtmp-server/issues/304#issuecomment-74000081
* hls_aof_ratio: The ratio to determine whether the pure audio shoule be reap. For example, when hls_fragment is 10s, the hls_aof_ratio is 2.0, for pure audio, reap ts every 10s*2.0=20s.
* hls_window: The total HLS windows size in seconds, the sum of all ts duration in m3u8. SRS will drop the old ts file in m3u8 and delete the file on fs. SRS will keep:
```bash
hls_window >= sum(each ts duration in m3u8)
```
* hls_storage: The storage type, can be ram(in memory only), disk(in disk only), both(in memory and disk). The hls_path must be specified for disk or both; while the hls_mount must be specified for ram or both.
* hls_path: The path to save m3u8 and ts file, where m3u8 and ts files saved in.
* hls_m3u8_file: The filename of m3u8 file, with variables [vhost], [app] and [stream] to replace.
* hls_ts_file: The filename of ts fle, with some variables in [dvr variables](https://github.com/winlinvip/simple-rtmp-server/wiki/v2_CN_DVR#custom-path). And, variable [seq] is the ts seqence number.
```bash
For RTMP stream: rtmp://localhost/live/livestream
HLS path: 
        hls_path        /data/nginx/html;
        hls_m3u8_file   [app]/[stream].m3u8;
        hls_ts_file     [app]/[stream]-[seq].ts;
SRS will generate below files:
/data/nginx/html/live/livestream.m3u8
/data/nginx/html/live/livestream-0.ts
/data/nginx/html/live/livestream-1.ts
/data/nginx/html/live/livestream-2.ts
And the HLS url to play: http://localhost/live/livestream.m3u8
```
* hls_entry_prefix: the base url for ts. optional and default to empty string.
```
For ts: live/livestream-0.ts
When config: hls_entry_prefix http://your-server;
The ts url generated to: http://your-server/live/livestream-0.ts
```
* hls_mount: The mount of m3u8/ts ram, refer to `mount` of `http_remux` at [http_remux](https://github.com/winlinvip/simple-rtmp-server/wiki/v2_EN_DeliveryHttpStream#http-live-stream-config)
* hls_acodec: the default audio codec of hls. when codec changed, write the PAT/PMT table, but maybe ok util next ts.so user can set the default codec for mp3.
* hls_vcodec: the default video codec of hls. when codec changed, write the PAT/PMT table, but maybe ok util next ts. so user can set the default codec for pure audio(without video) to vn.
* hls_cleanup: whether cleanup the ts files.
* on_hls: callback when ts generated.
* on_hls_notify: callback when ts generated, use [ts_url] as variable, use GET method. can used to push ts file to can network.

How to deploy SRS to delivery HLS, read [Usage: HLS](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_SampleHLS)

## HTTP Callback

To config `on_hls` for http hooks, should config in `http_hooks` section, not in hls.

## ON HLS Notify

To config the `on_hls_notify` for push ts file to can network, should config in `http_hooks` section, not in hls.

## HLSAudioOnly

SRS supports to deliver pure audio stream by HLS. The audio codec requires AAC, user must transcode other codecs to aac, read [Usage: Transcode2HLS](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_SampleTranscode2HLS)

For information about drop video, read [Transcode: Disable Stream](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_FFMPEG#drop-video-or-audio)

There is no special config for pure audio for HLS. Please read  [Usage: HLS](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_SampleHLS)

## HLS and Forward

All stream publish by forward will output HLS when HLS enalbed.

## HLS and Transcode

User can use transcode to ensure the video codec is h.264 and audio codec is aac/mp3, because h.264+aac/mp3 is required by HLS.

The below transcode config set the [gop](http://ffmpeg.org/ffmpeg-codecs.html#Options-7) to keep ts duration small:
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
The gop is 100/20=5s, where fps specified by vfps is 20, and gop frames specified by g is 100.

## HLS Multiple Bitrate

SRS does not support HLS multiple bitrate.

## HLS M3u8 Examples

### live.m3u8

http://ossrs.net/hls/live.m3u8

```
#EXTM3U
#EXT-X-VERSION:3
#EXT-X-ALLOW-CACHE:YES
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

http://ossrs.net/hls/event.m3u8

```
#EXTM3U
#EXT-X-VERSION:3
#EXT-X-ALLOW-CACHE:YES
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

http://ossrs.net/hls/vod.m3u8

```
#EXTM3U
#EXT-X-VERSION:3
#EXT-X-ALLOW-CACHE:YES
#EXT-X-PLAYLIST-TYPE:VOD
#EXT-X-TARGETDURATION:12
#EXTINF:10.120,
livestream-184.ts
#EXTINF:10.029,
livestream-185.ts
#EXTINF:10.206,
livestream-186.ts
#EXTINF:10.160,
livestream-187.ts
#EXTINF:11.360,
livestream-188.ts
#EXTINF:9.782,
livestream-189.ts
#EXT-X-ENDLIST
```

### loop.m3u8

```
#EXTM3U
#EXT-X-VERSION:3
#EXT-X-ALLOW-CACHE:YES
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

SRS supports delivery HLS in RAM, without write m3u8/ts to disk. Read [136](https://github.com/winlinvip/simple-rtmp-server/issues/136)

The config example, refer to `conf/ram.hls.conf`:

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

Remark: The HTTP server must enabled.

For example, publish rtmp at `rtmp://192.168.1.173/live/livestream`, the HLS stream url is `http://192.168.1.173:8080/live/livestream.m3u8`

For information about config, read [Config](https://github.com/winlinvip/simple-rtmp-server/wiki/v2_CN_DeliveryHLS#hls-config)

## SRS How to Support HLS

The HLS of SRS1 refer to nginx-rtmp.

SRS2 already rewrite the HLS strictly following the spec.

Winlin 2015.2