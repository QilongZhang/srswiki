# SRS librtmp

librtmp is a client side library, seems from rtmpdump.

## Use Scenarios

The use scenarios of librtmp:
* Play or suck RTMP stream: For example rtmpdump, dvr RTMP stream to flv file.
* Publish RTMP stream: Publish RTMP stream to server.
* Use sync block socket: It's ok for client.
* ARM: Can used for linux arm, for some embed device, to publish stream to server.
* Publish h.264 raw stream: SRS2.0 supports this feature, read [publish-h264-raw-data](https://github.com/winlinvip/simple-rtmp-server/wiki/v2_EN_SrsLibrtmp#publish-h264-raw-data)

Note: About the openssl, complex and simple handshake, read [RTMP protocol](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_RTMPHandshake)

Note: To cross build srs-librtmp for ARM cpu, read [srs-arm](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_SrsLinuxArm)

## librtmp For Server

librtmp or srs-librtmp only for client side application, impossible for server side.

## Why SRS provides srs-librtmp

SRS provides different librtmp:
* The code of librtmp is hard to maintain.
* The interface of librtmp is hard to use.
* No example, while srs-librtmp provides lots of examples at trunk/research/librtmp.
* Min depends, SRS extract core/kernel/rtmp modules for srs-librtmp.
* Min library requires, srs-librtmp only depends on stdc++.
* NO ST, srs-librtmp does not depends on st.
* Provides bandwidth api, to get the bandwidth data to server, read [Bandwidth Test](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_BandwidthTestTool)
* Provides tracable log, to get the information on server of client, read [Tracable log](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_SrsLog)
* Supports directly publish h.264 raw stream, read [publish-h264-raw-data](https://github.com/winlinvip/simple-rtmp-server/wiki/v2_EN_SrsLibrtmp#publish-h264-raw-data)
* Exports SRS to srs-librtmp as single project which can be make to .h and .a, or exports SRS to a single .h and .cpp file, read [export srs librtmp](https://github.com/winlinvip/simple-rtmp-server/wiki/v2_EN_SrsLibrtmp#export-srs-librtmp)

In a word, SRS provides more efficient and simple client library srs-librtmp.

## Export Srs Librtmp

SRS在2.0提供了导出srs-librtmp的编译选项，可以将srs-librtmp单独导出为project，单独编译生成.h和.a，方便在linux和windows平台编译。

使用方法，导出为project，可以make成.h和.a：

```
dir=/home/winlin/srs-librtmp &&
rm -rf $dir &&
./configure --export-librtmp-project=$dir &&
cd $dir && make &&
./objs/research/librtmp/srs_play rtmp://ossrs.net/live/livestream
```

SRS将srs-librtmp导出为独立可以make的项目，生成.a静态库和.h头文件，以及生成了srs-librtmp的所有实例。

还可以直接导出为一个文件，提供了简单的使用实例，[其他实例](https://github.com/winlinvip/simple-rtmp-server/wiki/v2_EN_SrsLibrtmp#srs-librtmp-examples)参考research的其他例子：

```
dir=/home/winlin/srs-librtmp &&
rm -rf $dir &&
./configure --export-librtmp-single=$dir &&
cd $dir && gcc example.c srs_librtmp.cpp -g -O0 -lstdc++ -o example && 
strip example && ./example
```

备注：导出目录支持相对目录和绝对目录。

## 编译srs-librtmp

编译SRS时，会自动编译srs-librtmp，譬如：

```bash
./configure --with-librtmp --without-ssl
```

编译会生成srs-librtmp和对应的[实例](https://github.com/winlinvip/simple-rtmp-server/wiki/v2_EN_SrsLibrtmp#srs-librtmp-examples)。

<strong>备注：支持librtmp只需要打开--with-librtmp，但推荐打开--without-ssl，不依赖于ssl，对于一般客户端（不需要模拟flash）足够了。这样srs-librtmp不依赖于任何其他库，在x86/x64/arm等平台都可以编译和运行</strong>

<strong>备注：就算打开了--with-ssl，srslibrtmp也只提供simple_handshake函数，不提供complex_handshake函数。所以推荐关闭ssl，不依赖于ssl，没有实际的用处。</strong>

SRS编译成功后，用户就可以使用这些库开发

## Windows下编译srs-librtmp

srs-librtmp可以只依赖于c++和socket，可以在windows下编译。

先使用SRS导出srs-librtmp，然后在vs中编译，参考：[export srs librtmp](https://github.com/winlinvip/simple-rtmp-server/wiki/v2_EN_SrsLibrtmp#export-srs-librtmp)

使用了一些linu的头文件，需要做一些portal。

注意：srs-librtmp客户端推流和抓流，不需要ssl库。代码都是c++/stl，网络部分用的是同步socket。

## 数据格式

srs-librtmp提供了一系列接口函数，就数据按照一定格式发送到服务器，或者从服务器读取音视频数据。

数据接口包括：
* 读取数据包：int srs_read_packet(int* type, u_int32_t* timestamp, char** data, int* size)
* 发送数据包：int srs_write_packet(int type, u_int32_t timestamp, char* data, int size)
* 发送h.264裸码流：参考[publish-h264-raw-data](https://github.com/winlinvip/simple-rtmp-server/wiki/v2_EN_SrsLibrtmp#publish-h264-raw-data)

接口接受的的数据(char* data)，音视频数据，格式为flv的Video/Audio数据。参考srs的doc目录的规范文件[video_file_format_spec_v10_1.pdf](https://raw.github.com/winlinvip/simple-rtmp-server/master/trunk/doc/video_file_format_spec_v10_1.pdf)
* 音频数据格式参考：`E.4.2.1 AUDIODATA`，p76，譬如，aac编码的音频数据。
* 视频数据格式参考：`E.4.3.1 VIDEODATA`，p78，譬如，h.264编码的视频数据。
* 脚本数据格式参考：`E.4.4.1 SCRIPTDATA`，p80，譬如，onMetadata，流的信息（宽高，码率，分辨率等）

数据类型(int type)定义如下（`E.4.1 FLV Tag`，page 75）：
* 音频：8 = audio，宏定义：SRS_RTMP_TYPE_AUDIO
* 视频：9 = video，宏定义：SRS_RTMP_TYPE_VIDEO
* 脚本数据：18 = script data，宏定义：SRS_RTMP_TYPE_SCRIPT

其他的数据，譬如时间戳，都是通过参数接受和发送。

另外，文档其他重要信息：
* flv文件头格式：`E.2 The FLV header`，p74。
* flv文件主体格式：`E.3 The FLV File Body`，p74。
* tag头格式：`E.4.1 FLV Tag`，p75。

使用flv格式的原因：
* flv的格式足够简单。
* ffmpeg也是用的这种格式
* 收到流后加上flv tag header，就可以直接保存为flv文件
* 从flv文件解封装数据后，只要将tag的内容给接口就可以，flv的tag头很简单。

## Publish H.264 Raw Data

SRS-librtmp支持发布h.264裸码流，直接调用api即可将数据发送给SRS。

参考博客：http://blog.csdn.net/win_lin/article/details/41170653

总结起来就是说，H264的裸码流（帧）转换RTMP时：

1. dts和pts是不在h264流中的，外部给出。
1. SPS和PPS在RTMP一个包里面发出去。
1. RTMP包=5字节RTMP包头+H264头+H264数据，具体参考：SrsAvcAacCodec::video_avc_demux
1. 直接提供接口，发送h264数据，其中包含annexb的头：N[00] 00 00 01, where N>=0.

加了一个直接发送h264裸码流的接口：

```
/**
* write h.264 raw frame over RTMP to rtmp server.
* @param frames the input h264 raw data, encoded h.264 I/P/B frames data.
*       frames can be one or more than one frame,
*       each frame prefixed h.264 annexb header, by N[00] 00 00 01, where N>=0, 
*       for instance, frame = header(00 00 00 01) + payload(67 42 80 29 95 A0 14 01 6E 40)
*       about annexb, @see H.264-AVC-ISO_IEC_14496-10.pdf, page 211.
* @paam frames_size the size of h264 raw data. 
*       assert frames_size > 0, at least has 1 bytes header.
* @param dts the dts of h.264 raw data.
* @param pts the pts of h.264 raw data.
* 
* @remark, user should free the frames.
* @remark, the tbn of dts/pts is 1/1000 for RTMP, that is, in ms.
* @remark, cts = pts - dts
* 
* @return 0, success; otherswise, failed.
*/
extern int srs_write_h264_raw_frames(srs_rtmp_t rtmp, 
    char* frames, int frames_size, u_int32_t dts, u_int32_t pts
);
```

对于例子中的h264流文件：http://winlinvip.github.io/srs.release/3rdparty/720p.h264.raw

里面的数据是：

```
// SPS
000000016742802995A014016E40
// PPS
0000000168CE3880
// IFrame
0000000165B8041014C038008B0D0D3A071.....
// PFrame
0000000141E02041F8CDDC562BBDEFAD2F.....
```

调用时，可以SPS和PPS一起发，帧一次发一个：

```
// SPS+PPS
srs_write_h264_raw_frame('000000016742802995A014016E400000000168CE3880', size, dts, pts)
// IFrame
srs_write_h264_raw_frame('0000000165B8041014C038008B0D0D3A071......', size, dts, pts)
// PFrame
srs_write_h264_raw_frame('0000000141E02041F8CDDC562BBDEFAD2F......', size, dts, pts)
```

调用时，可以一次发一次frame也行：

```
// SPS
srs_write_h264_raw_frame('000000016742802995A014016E4', size, dts, pts)
// PPS
srs_write_h264_raw_frame('00000000168CE3880', size, dts, pts)
// IFrame
srs_write_h264_raw_frame('0000000165B8041014C038008B0D0D3A071......', size, dts, pts)
// PFrame
srs_write_h264_raw_frame('0000000141E02041F8CDDC562BBDEFAD2F......', size, dts, pts) 
```

参考：https://github.com/winlinvip/simple-rtmp-server/issues/66#issuecomment-62240521

使用：https://github.com/winlinvip/simple-rtmp-server/issues/66#issuecomment-62245512

## srs-librtmp Examples

SRS提供了实例sample，也会在编译srs-librtmp时自动编译：
* research/librtmp/srs_play.c：播放RTMP流实例。
* research/librtmp/srs_publish.c：推送RTMP流实例。
* research/librtmp/srs_ingest_flv.c：读取本地文件并推送RTMP流实例。
* research/librtmp/srs_ingest_rtmp.c：读取RTMP流并推送RTMP流实例。
* research/librtmp/srs_bandwidth_check.c：带宽测试工具。
* research/librtmp/srs_flv_injecter.c：点播FLV关键帧注入文件。
* research/librtmp/srs_flv_parser.c：FLV文件查看工具。
* research/librtmp/srs_ingest_rtmp.c：采集RTMP流，推送RTMP流给SRS。
* research/librtmp/srs_ingest_flv.c：采集FLV文件，推送RTMP流给SRS。
* research/librtmp/srs_detect_rtmp.c：RTMP流检测工具。
* research/librtmp/srs_h264_raw_publish.c：H.264裸码流发布到SRS实例。

## 运行实例

启动SRS：

```bash
[winlin@dev6 srs]$ make && ./objs/srs -c srs.conf 
[2014-03-02 18:28:03.857][trace][1][16] server started, listen at port=1935, fd=4
[2014-03-02 18:28:03.857][trace][2][16] thread cycle start
```

推流实例：

```bash
[winlin@dev6 srs]$ make && ./research/librtmp/srs_publish_ssl 
publish rtmp stream to server like FMLE/FFMPEG/Encoder
srs(simple-rtmp-server) client librtmp library.
version: 0.9.9
simple handshake success
connect vhost/app success
publish stream success
sent packet: type=Video, time=40, size=4096
sent packet: type=Video, time=80, size=4096
sent packet: type=Video, time=120, size=4096
sent packet: type=Video, time=160, size=4096
sent packet: type=Video, time=200, size=4096
sent packet: type=Video, time=240, size=4096
```

备注：推流实例发送的视频数据不是真正的视频数据，实际使用时，譬如从摄像头取出h.264裸码流，需要封装成接口要求的数据，然后调用接口发送出去。或者[直接发送h264裸码流](https://github.com/winlinvip/simple-rtmp-server/wiki/v2_EN_SrsLibrtmp#publish-h264-raw-data)。

播放实例：

```bash
[winlin@dev6 trunk]$ make && ./research/librtmp/srs_play_ssl 
suck rtmp stream like rtmpdump
srs(simple-rtmp-server) client librtmp library.
version: 0.9.9
simple handshake success
connect vhost/app success
play stream success
got packet: type=Data, time=0, size=24
got packet: type=Data, time=0, size=44
got packet: type=Video, time=40, size=4096
got packet: type=Video, time=80, size=4096
got packet: type=Video, time=120, size=4096
got packet: type=Video, time=160, size=4096
got packet: type=Video, time=200, size=4096
got packet: type=Video, time=240, size=4096
got packet: type=Video, time=280, size=4096
got packet: type=Video, time=320, size=4096
got packet: type=Video, time=360, size=4096
got packet: type=Video, time=400, size=4096
```

Winlin 2014.11