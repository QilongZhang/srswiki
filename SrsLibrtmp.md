# SRS提供的librtmp

librtmp是一个客户端库，好像是rtmpdump提供的一个客户端RTMP库。

## 应用场景

librtmp的主要应用场景包括：
* 播放RTMP流：譬如rtmpdump，将服务器的流读取后保存为flv文件。
* 推流？不知道是否提供推流接口，可能有。
* 基于同步阻塞socket，客户端用可以了。
* arm？可能能编译出来给arm-linux用，譬如某些设备上，采集后推送到RTMP服务器。

备注：关于链接ssl，握手协议，简单握手和复杂握手，参考[RTMP握手协议](https://github.com/winlinvip/simple-rtmp-server/wiki/RTMPHandshake)

备注：ARM上使用srs-librtmp需要交叉编译，参考[srs-arm](https://github.com/winlinvip/simple-rtmp-server/wiki/SrsLinuxArm)，即使用交叉编译环境编译srs-librtmp（可以不依赖于其他库，ssl/st都不需要）

## librtmp做Server

群里有很多人问，librtmp如何做server，实在不胜其骚扰，所以单列一章。

server的特点是会有多个客户端连接，至少有两个：一个推流连接，一个播放连接。所以server有两种策略：
* 每个连接一个线程或进程：像apache。这样可以用同步socket来收发数据（同步简单）。坏处就是没法支持很高并发，1000个已经到顶了，得开1000个线程/进程啊。
* 使用单进程，但是用异步socket：像nginx这样。好处就是能支持很高并发。坏处就是异步socket麻烦。

rtmpdump提供的librtmp，当然是基于同步socket的。所以使用librtmp做server，只能采取第一种方法，即用多线程处理多个连接。多线程多麻烦啊！要锁，同步，而且还支持不了多少个。

librtmp的定位就是客户端程序，偏偏要超越它的定位去使用，这种大约只有中国人才能这样“无所畏惧”。

嵌入式设备上做rtmp server，当然可以用srs/crtmpd/nginx-rtmp，轮也轮不到librtmp。

## 编译srs-librtmp

编译SRS时，会自动编译srs-librtmp，譬如：

```bash
./configure --with-librtmp --without-ssl
```

编译会生成srs-librtmp和对应的sample，主要文件见下表。

<table>
<tr>
<th>SRS编译选项</th><th>编译说明</th><th>srs-librtmp文件</th><th>说明</th>
</tr>
<tr>
<td>./configure \<br/>
--with-librtmp --without-ssl</td>
<td>不依赖openssl，<br/>不支持复杂握手，<br/>只支持简单握手</td>
<td>
objs/include/srs_librtmp.h<br/>
objs/lib/libsrs_rtmp.a
</td>
<td>
一般客户端使用简单握手即可：<br/>
1. 推流：譬如FMLE，也是使用简单握手推流。<br/>
2. 播放：一般服务器也支持简单握手后播放，<br/>譬如SRS支持。
</td>
</tr>
<tr>
<td>./configure \<br/>
--with-librtmp --with-ssl</td>
<td>依赖openssl，<br/>支持复杂握手，<br/>支持简单握手</td>
<td>
objs/include/srs_librtmp.h<br/>
objs/lib/libsrs_rtmp.a<br/>
objs/openssl/lib/libssl.a<br/>
objs/openssl/lib/libcrypto.a
</td>
<td>
复杂握手主要应用于：<br/>
1. 完全模拟flash客户端，<br/>
flash播放vp6+mp3/speex时只需要简单握手，<br/>
播放h264+aac时需要复杂握手<br/>（简单握手会从服务器取数据，<br/>但是没有图像和声音）。
</td>
</tr>
</table>

<strong>备注：支持librtmp只需要打开--with-librtmp，但推荐打开--without-ssl，不依赖于ssl，对于一般客户端（不需要模拟flash）足够了。这样srs-librtmp不依赖于任何其他库，在x86/x64/arm等平台都可以编译和运行</strong>

SRS编译成功后，用户就可以使用这些库开发

## srs-librtmp实例

SRS提供了实例sample，也会在编译srs-librtmp时自动编译：
* research/librtmp/srs_play.c：播放RTMP流实例。
* research/librtmp/srs_publish.c：推送RTMP流实例。

依赖ssl的编译方法（支持复杂握手和简单握手）：

```bash
# 编译srs-librtmp时自动编译这些实例
# 实例的单独编译方法为：
cd /home/winlin/git/simple-rtmp-server/trunk/research/librtmp
make ssl
```

不需要ssl（不支持复杂握手，只支持简单握手）编译方法(<strong>推荐</strong>)：

```bash
# 编译srs-librtmp时自动编译这些实例
# 实例的单独编译方法为：
cd /home/winlin/git/simple-rtmp-server/trunk/research/librtmp
make nossl
```

实例编译的二进制文件：
* research/librtmp/srs_play_nossl：播放RTMP流，没有ssl，只支持简单握手。<strong>推荐</strong>
* research/librtmp/srs_play_ssl：播放RTMP流，有ssl，支持简单握手和复杂握手。
* research/librtmp/srs_publish_nossl：推送RTMP流，没有ssl，只支持简单握手。<strong>推荐</strong>
* research/librtmp/srs_publish_ssl：推送RTMP流，有ssl，支持简单握手和复杂握手。

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

## SRS为何提供librtmp

srs提供的客户端srs-librtmp的定位和librtmp不一样，主要是：
* librtmp的代码确实很烂，毋庸置疑，典型的代码堆积。
* librtmp接口定义不良好，这个对比srs就可以看出，使用起来得看实现代码。
* 没有实例：接口的使用最好提供实例，srs提供了publish/play/rtmpdump实例。
* 最小依赖关系：srs调整了模块化，只取出了core/kernel/rtmp三个模块，其他代码没有编译到srs-librtmp中，避免了冗余。
* 最少依赖库：srs-librtmp只依赖c/c++标准库（若需要复杂握手需要依赖openssl，srs也编译出来了，只需要加入链接即可）。
* 不依赖st：srs-librtmp使用同步阻塞socket，没有使用st（st主要是服务器处理并发需要）。

一句话，srs为何提供客户端开发库？因为rtmp客户端开发不方便，不直观，不简洁。

## srs-librtmp接口说明

srs-librtmp接口参考头文件`srs_librtmp.h`：

```c
/*
The MIT License (MIT)

Copyright (c) 2013-2014 winlin

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#ifndef SRS_LIB_RTMP_HPP
#define SRS_LIB_RTMP_HPP

/*
#include <srs_librtmp.h>
*/

#include <sys/types.h>

/**
* srs-librtmp is a librtmp like library,
* used to play/publish rtmp stream from/to rtmp server.
* socket: use sync and block socket to connect/recv/send data with server.
* depends: no need other libraries; depends on ssl if use srs_complex_handshake.
* thread-safe: no
*/

#ifdef __cplusplus
extern "C"{
#endif

// the output handler.
typedef void* srs_rtmp_t;

/**
* create/destroy a rtmp protocol stack.
* @url rtmp url, for example: 
* 		rtmp://127.0.0.1/live/livestream
* @return a rtmp handler, or NULL if error occured.
*/
srs_rtmp_t srs_rtmp_create(const char* url);
void srs_rtmp_destroy(srs_rtmp_t rtmp);

/**
* handshake with server
* category: publish/play
* previous: rtmp-create
* next: connect-app
* @return 0, success; otherwise, failed.
*/
/**
* simple handshake specifies in rtmp 1.0,
* not depends on ssl.
*/
int srs_simple_handshake(srs_rtmp_t rtmp);
/**
* complex handshake is specified by adobe Flash player,
* depends on ssl, user must compile srs with ssl, then
* link user program libssl.a and libcrypt.a
* @remark user can use srs_ssl_enabled() to detect 
* whether ssl is ok.
*/
int srs_complex_handshake(srs_rtmp_t rtmp);

/**
* connect to rtmp vhost/app
* category: publish/play
* previous: handshake
* next: publish or play
* @return 0, success; otherwise, failed.
*/
int srs_connect_app(srs_rtmp_t rtmp);

/**
* play a live/vod stream.
* category: play
* previous: connect-app
* next: destroy
* @return 0, success; otherwise, failed.
*/
int srs_play_stream(srs_rtmp_t rtmp);

/**
* publish a live stream.
* category: publish
* previous: connect-app
* next: destroy
* @return 0, success; otherwise, failed.
*/
int srs_publish_stream(srs_rtmp_t rtmp);

/**
* E.4.1 FLV Tag, page 75
*/
// 8 = audio
#define SRS_RTMP_TYPE_AUDIO 8
// 9 = video
#define SRS_RTMP_TYPE_VIDEO 9
// 18 = script data
#define SRS_RTMP_TYPE_SCRIPT 18
/**
* convert the flv tag type to string.
* 	SRS_RTMP_TYPE_AUDIO to "Audio"
* 	SRS_RTMP_TYPE_VIDEO to "Video"
* 	SRS_RTMP_TYPE_SCRIPT to "Data"
* 	otherwise, "Unknown"
*/
const char* srs_type2string(int type);
/**
* read a audio/video/script-data packet from rtmp stream.
* @param type, output the packet type, macros:
*			SRS_RTMP_TYPE_AUDIO, FlvTagAudio
*			SRS_RTMP_TYPE_VIDEO, FlvTagVideo
*			SRS_RTMP_TYPE_SCRIPT, FlvTagScript
* @param timestamp, in ms, overflow in 50days
* @param data, the packet data, according to type:
* 			FlvTagAudio, @see "E.4.2.1 AUDIODATA"
*			FlvTagVideo, @see "E.4.3.1 VIDEODATA"
*			FlvTagScript, @see "E.4.4.1 SCRIPTDATA"
* @param size, size of packet.
* @return the error code. 0 for success; otherwise, error.
*
* @remark: for read, user must free the data.
* @remark: for write, user should never free the data, even if error.
*/
int srs_read_packet(srs_rtmp_t rtmp, int* type, u_int32_t* timestamp, char** data, int* size);
int srs_write_packet(srs_rtmp_t rtmp, int type, u_int32_t timestamp, char* data, int size);

/**
* whether srs is compiled with ssl,
* that is, compile srs with ssl: ./configure --with-ssl,.
* if no ssl, complex handshake always error.
* @return 0 for false, otherwise, true.
*/
int srs_ssl_enabled();

/**
* get protocol stack version
*/
int srs_version_major();
int srs_version_minor();
int srs_version_revision();

#ifdef __cplusplus
}
#endif

#endif
```

Winlin 2014.2