# SRS librtmp

librtmp is a client side library, seems from rtmpdump.

## Use Scenarios

The use scenarios of librtmp:
* Play or suck RTMP stream: For example rtmpdump, dvr RTMP stream to flv file.
* Publish RTMP stream: Publish RTMP stream to server.
* Use sync block socket: It's ok for client.
* ARM: Can used for linux arm, for some embed device, to publish stream to server.

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

In a word, SRS provides more efficient and simple client library srs-librtmp.

## 编译srs-librtmp

编译SRS时，会自动编译srs-librtmp，譬如：

```bash
./configure --with-librtmp --without-ssl
```

编译会生成srs-librtmp和对应的[实例](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_SrsLibrtmp#srs-librtmp-examples)。

<strong>备注：支持librtmp只需要打开--with-librtmp，但推荐打开--without-ssl，不依赖于ssl，对于一般客户端（不需要模拟flash）足够了。这样srs-librtmp不依赖于任何其他库，在x86/x64/arm等平台都可以编译和运行</strong>

<strong>备注：就算打开了--with-ssl，srslibrtmp也只提供simple_handshake函数，不提供complex_handshake函数。所以推荐关闭ssl，不依赖于ssl，没有实际的用处。</strong>

SRS编译成功后，用户就可以使用这些库开发

## Windows下编译srs-librtmp

srs-librtmp可以只依赖于c++和socket，可以在windows下编译。不过srs没有提供直接编译的方法，可行的方法是：
* 先在linux下编译通过：`./configure --disable-all --with-librtmp && make`
* 头文件就是`src/libs/srs_librtmp.hpp`，将以下文件拷贝到windows下编译：

```bash
objs/srs_auto_headers.hpp
src/core/*
src/kernel/*
src/rtmp/*
src/libs/*
```

注意：srs-librtmp客户端推流和抓流，不需要ssl库。代码都是c++/stl，网络部分用的是同步socket。
备注：SRS2.0提供将srs-librtmp导出为一个project或者文件，参考[导出srs-librtmp](https://github.com/winlinvip/simple-rtmp-server/wiki/v2_EN_SrsLibrtmp#export-srs-librtmp)。SRS1.0不支持导出，可以自己合并2.0的修改到1.0。

## 数据格式

srs-librtmp提供了一系列接口函数，就数据按照一定格式发送到服务器，或者从服务器读取音视频数据。

数据接口包括：
* 读取数据包：int srs_read_packet(int* type, u_int32_t* timestamp, char** data, int* size)
* 发送数据包：int srs_write_packet(int type, u_int32_t timestamp, char* data, int size)

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

备注：SRS2.0支持直接发送h264裸码流，参考[publish h.264 raw data](https://github.com/winlinvip/simple-rtmp-server/wiki/v2_EN_SrsLibrtmp#publish-h264-raw-data)

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

备注：推流实例发送的视频数据不是真正的视频数据，实际使用时，譬如从摄像头取出h.264裸码流，需要封装成接口要求的数据，然后调用接口发送出去。

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