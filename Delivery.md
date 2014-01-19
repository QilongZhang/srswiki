# 分发方式：HLS/RTMP

SRS支持HLS/RTMP两种成熟而且广泛应用的流媒体分发方式。

RTMP指Adobe的RTMP(Realtime Message Protocol)，广泛应用于低延时直播，也是编码器和服务器对接的实际标准协议，在PC（Flash）上有最佳观看体验和最佳稳定性。

HLS指Apple的HLS(Http Live Streaming)，本身就是Live（直播）的，不过Vod（点播）也能支持。HLS是Apple平台的标准流媒体协议，和RTMP在PC上一样支持得天衣无缝。

HLS和RTMP两种分发方式，就可以支持所有的终端。

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
<td>Windows PC</td>
<td>RTMP</td>
<td>Adobe Flash</td>
<td>主流的低延时分发方式，<br/>Adobe对RTMP是Flash原生支持方式，<br/>FMS（Adobe Media Server前身），<br/>就是Flash Media Server的简写，可见Flash播放RTMP是多么“原生”，<br/>就像浏览器打开http网页一样“原生”，<br/>经测试，Flash播放RTMP流可以10天以上不间断播放。</td>
</tr>
<tr>
<td>HLS</td>
<td>Apple/Android</td>
<td>HTTP</td>
<td>Apple/Google</td>
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
# hello
```

有几个关键的参数，这些参数在SRS的配置文件中都有配置项：
* hls_fragment：配置每个ts切片的大小。
* hls_window：配置保存多少个切片，即切片窗口大小。

譬如，每个ts切片为10秒，窗口为60秒，那么m3u8中会保存6个ts切片。

## SRS如何支持HLS

SRS的HLS主要参考了nginx-rtmp的HLS实现方式，SRS没有做什么事情，都是nginx-rtmp实现的。而分发m3u8和ts文件，也是使用nginx分发的。

SRS只是读了遍ts的标准文档，把相关部分加了注释而已。譬如下面这段：
```c++
// @see: ngx_rtmp_mpegts.c
// TODO: support full mpegts feature in future.
class SrsMpegtsWriter
{
public:
    static int write_frame(int fd, SrsMpegtsFrame* frame, SrsCodecBuffer* buffer)
    {
        int ret = ERROR_SUCCESS;
        
        if (!buffer->bytes || buffer->size <= 0) {
            return ret;
        }
        
        char* last = buffer->bytes + buffer->size;
        char* pos = buffer->bytes;
        
        bool first = true;
        while (pos < last) {
            static char packet[188];
            char* p = packet;
            
            frame->cc++;
            
            // sync_byte; //8bits
            *p++ = 0x47;
            // pid; //13bits
            *p++ = (frame->pid >> 8) & 0x1f;
            // payload_unit_start_indicator; //1bit
            if (first) {
                p[-1] |= 0x40;
            }
            *p++ = frame->pid;
            
            // transport_scrambling_control; //2bits
            // adaption_field_control; //2bits, 0x01: PayloadOnly
            // continuity_counter; //4bits
            *p++ = 0x10 | (frame->cc & 0x0f);
            
            if (first) {
                first = false;
                if (frame->key) {
                    p[-1] |= 0x20; // Both Adaption and Payload
                    *p++ = 7;    // size
                    *p++ = 0x50; // random access + PCR
                    p = write_pcr(p, frame->dts - SRS_HLS_DELAY);
                }
                
                // PES header
                // packet_start_code_prefix; //24bits, '00 00 01'
                *p++ = 0x00;
                *p++ = 0x00;
                *p++ = 0x01;
                //8bits
                *p++ = frame->sid;
                
                // pts(33bits) need 5bytes.
                u_int8_t header_size = 5;
                u_int8_t flags = 0x80; // pts
                
                // dts(33bits) need 5bytes also
                if (frame->dts != frame->pts) {
                    header_size += 5;
                    flags |= 0x40; // dts
                }
                
                // 3bytes: flag fields from PES_packet_length to PES_header_data_length
                int pes_size = (last - pos) + header_size + 3;
                if (pes_size > 0xffff) {
                    /**
                    * when actual packet length > 0xffff(65535),
                    * which exceed the max u_int16_t packet length,
                    * use 0 packet length, the next unit start indicates the end of packet.
                    */
                    pes_size = 0;
                }
                
                // PES_packet_length; //16bits
                *p++ = (pes_size >> 8);
                *p++ = pes_size;
                
                // PES_scrambling_control; //2bits, '10'
                // PES_priority; //1bit
                // data_alignment_indicator; //1bit
                // copyright; //1bit
                // original_or_copy; //1bit	
                *p++ = 0x80; /* H222 */
                
                // PTS_DTS_flags; //2bits
                // ESCR_flag; //1bit
                // ES_rate_flag; //1bit
                // DSM_trick_mode_flag; //1bit
                // additional_copy_info_flag; //1bit
                // PES_CRC_flag; //1bit
                // PES_extension_flag; //1bit
                *p++ = flags;
                
                // PES_header_data_length; //8bits
                *p++ = header_size;

                // pts; // 33bits
                p = write_pts(p, flags >> 6, frame->pts + SRS_HLS_DELAY);
                
                // dts; // 33bits
                if (frame->dts != frame->pts) {
                    p = write_pts(p, 1, frame->dts + SRS_HLS_DELAY);
                }
            }
            
            int body_size = sizeof(packet) - (p - packet);
            int in_size = last - pos;
            
            if (body_size <= in_size) {
                memcpy(p, pos, body_size);
                pos += body_size;
            } else {
                p = fill_stuff(p, packet, body_size, in_size);
                memcpy(p, pos, in_size);
                pos = last;
            }
            
            // write ts packet
            if (::write(fd, packet, sizeof(packet)) != sizeof(packet)) {
                ret = ERROR_HLS_WRITE_FAILED;
                srs_error("write ts file failed. ret=%d", ret);
                return ret;
            }
        }
        
        return ret;
    }
};
```

## 配置方法

SRS的`with-hls.vhost.com`VHOST是HLS配置的实例：
```bash
# the vhost with hls specified.
vhost with-hls.vhost.com {
    hls {
        # whether the hls is enabled.
        # if off, donot write hls(ts and m3u8) when publish.
        # default: off
        enabled         on;
        # the hls output path.
        # the app dir is auto created under the hls_path.
        # for example, for rtmp stream:
        #   rtmp://127.0.0.1/live/livestream
        #   http://127.0.0.1/live/livestream.m3u8
        # where hls_path is /hls, srs will create the following files:
        #   /hls/live       the app dir for all streams.
        #   /hls/live/livestream.m3u8   the HLS m3u8 file.
        #   /hls/live/livestream-1.ts   the HLS media/ts file.
        # in a word, the hls_path is for vhost.
        # default: ./objs/nginx/html
        hls_path        /data/nginx/html;
        # the hls fragment in seconds, the duration of a piece of ts.
        # default: 10
        hls_fragment    10;
        # the hls window in seconds, the number of ts in m3u8.
        # default: 60
        hls_window      60;
    }
}
```

其中hls配置就是HLS的配置，主要配置项如下：
* enabled：是否开启HLS，on/off，默认off。
* hls_path：HLS的m3u8和ts文件保存的路径。SRS会自动加上app和stream名称。譬如：
```bash
对于RTMP流：rtmp://localhost/live/livestream
HLS配置路径：hls_path        /data/nginx/html;
那么会生成以下文件：
/data/nginx/html/live/livestream.m3u8
/data/nginx/html/live/livestream-0.ts
/data/nginx/html/live/livestream-1.ts
/data/nginx/html/live/livestream-2.ts
```