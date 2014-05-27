# SRS系统日志

SRS支持打印到console和file，支持设置level，支持连接级别的日志，支持日志快速索引。

## LogTank

LogTank即log的容器，日志打印到什么地方。

SRS提供两种打印日志的方式，通过配置`srs_log_tank`：
* console：打印日志到控制台。当配置文件没有加载时，也打印到控制台。
* file: 默认，打印日志到文件。必须指定配置`srs_log_file`，日志文件。日志文件默认为：`./objs/srs.log`

配置文件中的说明：

```bash
# the log tank, console or file.
# if console, print log to console.
# if file, write log to file. requires srs_log_file if log to file.
# default: file.
srs_log_tank        file;
```

## LogLevel

LogLevel就是log的级别，什么级别的日志才会打印出来。

SRS支持设置日志级别，通过设置`srs_log_level`：
* verbose: 非常详细的日志，性能会很低，日志会非常多。SRS默认是编译时禁用这些日志，提高性能。
* info：较为详细的日志，性能也受影响。SRS默认编译时禁用这些日志。
* trace: 重要的日志，比较少，SRS默认使用这个级别。
* warn: 警告日志，SRS在控制台以黄色显示。若SRS运行较稳定，可以只打开这个日志。建议使用trace级别。
* error: 错误日志，SRS在控制台以红色显示。

配置文件中的说明：

```bash
# the log level, for all log tanks.
# can be: verbose, info, trace, warn, error
# defualt: trace
srs_log_level       trace;
```

注意事项：
* 设置了低级别的日志，自动会打印高级别的。譬如设置为trace，那么trace/warn/error日志都会打印出来。
* 默认verbose和info是编译时禁用的，若需要打开这两个日志，需要修改`srs_kernel_log.hpp`，将对应的禁用编译宏打开。
* 推荐使用trace级别，重要的日志不多，对于排错很方便。如果有错误，建议用gdb调试，不要依赖日志。只有在不得已时才用日志排错。

## 工具的日志

Transcode/Ingest等都是用到了外部工具，譬如FFMPEG，所以我们统称ffmpeg日志。

SRS可以配置ffmpeg的日志路径，若配置为`/dev/null`则禁用ffmpeg日志，在某些嵌入式系统磁盘较小时比较有用，需要减少日志时有用：
```bash
# the logs dir.
# if enabled ffmpeg, each stracoding stream will create a log file.
# "/dev/null" to disable the log.
# default: ./objs
ff_log_dir          ./objs;
```

## 日志格式

SRS的日志可以定位到某个连接，可以在混杂了成千上万个链接的日志中找到某一个连接的日志，譬如要看某个客户端的日志。这个功能和SRS的日志格式设计相关，譬如：

```bash
[2014-04-04 11:21:29.183][trace][104][11] rtmp get peer ip success. ip=192.168.1.179
```

日志格式如下：
* <strong>[2014-04-04 11:21:29.183]</strong> 日志的日期，毫秒数因为SRS的时间cache，分辨率定义在SRS_TIME_RESOLUTION_MS，即500毫秒更新一次时间。防止gettimeofday函数调用造成性能问题。
* <strong>[trace]</strong> 日志的级别，参考上面对日志级别的定义。打印到控制台的日志，trace是白色，warn是黄色，error是红色。一般只有trace日志说明没有发现异常。
* <strong>[104]</strong> 标识id。进程存活期间，保证id唯一，从0开始计算。这个就是找到某个连接的日志的关键。
* <strong>[11]</strong> errno，系统错误码。这个在error时才有效，其他时候这个值没有意义。
* <strong>rtmp get peer ip success.</strong> 日志的文本。若有错误，一般会打印出错误码，譬如：identify client failed. ret=211(Timer expired) 说明是超时。

下面是一些常用的日志分析方法。

### 日志快速索引

某个客户端如果出现问题，譬如投诉说卡，播放断开，如何排查问题？SRS提供基于连接的日志，可以根据连接的id查询这个客户端在服务器的日志（参考下面基于连接的日志）。

如果服务器是多层结构呢？譬如CDN集群，有时候就需要查询连接的回源连接，以及回源连接在上层服务器的日志。这个时候快速知道客户端或者边缘在上层服务器的ID就及其重要了。

客户端或者边缘能拿到自己在上层服务器的ID，就是日志的快速索引。我举个例子：

播放流：rtmp://dev:1935/live/livestream
![客户端显示id](http://winlinvip.github.io/srs.release/wiki/images/client.log.png)
能看到SrsIp，即服务器ip为192.168.1.107，对于DNS解析而言，这个很重要，知道是哪个边缘节点。SrsPid为9131，SrsId为117，所以去这个服务器上grep关键字"\[9131\]\[117\]"就可以。
```bash
[winlin@dev6 srs]$ grep -ina "\[9131\]\[117\]" objs/edge.log 
875:[2014-05-27 16:49:16.699][trace][9131][117] serve client, peer ip=192.168.1.113
876:[2014-05-27 16:49:16.706][trace][9131][117] complex handshake with client success
877:[2014-05-27 16:49:16.706][trace][9131][117] rtmp connect app success. tcUrl=rtmp://dev:1935/live, pageUrl=http://demo.chnvideo.com:8085/srs/trunk/research/players/srs_player.html?server=192.168.1.107&vhost=192.168.1.107&stream=livestream, swfUrl=http://demo.chnvideo.com:8085/srs/trunk/research/players/srs_player/release/srs_player.swf?_version=1.23, schema=rtmp, vhost=__defaultVhost__, port=1935, app=live
878:[2014-05-27 16:49:16.908][trace][9131][117] set ack window size to 2500000
879:[2014-05-27 16:49:16.908][trace][9131][117] identify ignore messages except AMF0/AMF3 command message. type=0x5
880:[2014-05-27 16:49:16.917][trace][9131][117] ignored. set buffer length to 800
881:[2014-05-27 16:49:16.917][trace][9131][117] identify ignore messages except AMF0/AMF3 command message. type=0x4
882:[2014-05-27 16:49:16.939][trace][9131][117] identity client type=play, stream_name=livestream, duration=-1.00
883:[2014-05-27 16:49:16.939][trace][9131][117] identify client success. type=Play, stream_name=livestream, duration=-1.00
884:[2014-05-27 16:49:16.939][trace][9131][117] set output chunk size to 4096
885:[2014-05-27 16:49:16.940][trace][9131][117] set chunk_size=4096 success
886:[2014-05-27 16:49:16.940][trace][9131][117] source found, ip=192.168.1.113, url=__defaultVhost__/live/livestream, enabled_cache=1, edge=1
887:[2014-05-27 16:49:16.940][trace][9131][117] dispatch cached gop success. count=23, duration=323
888:[2014-05-27 16:49:16.940][trace][9131][117] create consumer, queue_size=30.00, tba=44100, tbv=1000
891:[2014-05-27 16:49:16.940][trace][9131][117] ignored. set buffer length to 800
902:[2014-05-27 16:49:19.345][trace][9131][117] -> PLA time=2419, msgs=14, okbps=234,0,0, ikbps=12,0,0
```

### 系统信息

日志中有版本和配置信息，以及使用的pid文件，侦听的端口，启动前几条日志就是：

```bash
[winlin@dev6 srs]$ ./objs/srs -c console.conf 
[winlin@dev6 srs]$ cat objs/srs.log 
[2014-04-04 11:39:24.176][trace][0][0] config parsed EOF
[2014-04-04 11:39:24.176][trace][0][0] log file is ./objs/srs.log
[2014-04-04 11:39:24.177][trace][0][0] srs(simple-rtmp-server) 0.9.46
[2014-04-04 11:39:24.177][trace][0][0] uname: Linux dev6 2.6.32-71.el6.x86_64 
#1 SMP Fri May 20 03:51:51 BST 2011 x86_64 x86_64 x86_64 GNU/Linux
[2014-04-04 11:39:24.177][trace][0][0] build: 2014-04-03 18:38:23, little-endian
[2014-04-04 11:39:24.177][trace][0][0] configure:  --dev --with-hls --with-nginx 
--with-ssl --with-ffmpeg --with-http-callback --with-http-server --with-http-api 
--with-librtmp --with-bwtc --with-research --with-utest --without-gperf --without-gmc 
--without-gmp --without-gcp --without-gprof --without-arm-ubuntu12 --jobs=1 
--prefix=/usr/local/srs
[2014-04-04 11:39:24.177][trace][0][0] write pid=4021 to ./objs/srs.pid success!
[2014-04-04 11:39:24.177][trace][100][16] server started, listen at port=1935, type=0, fd=6
[2014-04-04 11:39:24.177][trace][100][16] server started, listen at port=1985, type=1, fd=7
[2014-04-04 11:39:24.177][trace][100][16] server started, listen at port=8080, type=2, fd=8
[2014-04-04 11:39:24.177][trace][101][16] listen cycle start, port=1935, type=0, fd=6
[2014-04-04 11:39:24.177][trace][102][11] listen cycle start, port=1985, type=1, fd=7
[2014-04-04 11:39:24.177][trace][103][11] listen cycle start, port=8080, type=2, fd=8
[2014-04-04 11:39:26.799][trace][0][11] get a signal, signo=2
[2014-04-04 11:39:26.799][trace][0][11] user terminate program
```

可以看到这个边缘

主要信息包括：
* <strong>日志文件</strong>：[2014-04-04 11:39:24.176][trace][0][0] log file is ./objs/srs.log
* <strong>系统版本</strong>：[2014-04-04 11:39:24.177][trace][0][0] srs(simple-rtmp-server) 0.9.46
* <strong>编译系统信息</strong>：[2014-04-04 11:39:24.177][trace][0][0] uname: Linux dev6 2.6.32-71.el6.x86_64 
#1 SMP Fri May 20 03:51:51 BST 2011 x86_64 x86_64 x86_64 GNU/Linux
* <strong>编译日期</strong>：[2014-04-04 11:39:24.177][trace][0][0] build: 2014-04-03 18:38:23, little-endian
* <strong>编译参数</strong>：[2014-04-04 11:39:24.177][trace][0][0] configure:  --dev --with-hls --with-nginx 
--with-ssl --with-ffmpeg --with-http-callback --with-http-server --with-http-api --with-librtmp 
--with-bwtc --with-research --with-utest --without-gperf --without-gmc --without-gmp 
--without-gcp --without-gprof --without-arm-ubuntu12 --jobs=1 --prefix=/usr/local/srs
* <strong>PID文件</strong>：[2014-04-04 11:39:24.177][trace][0][0] write pid=4021 to ./objs/srs.pid success!
* <strong>侦听端口1935（RTMP）</strong>：[2014-04-04 11:39:24.177][trace][100][16] server started, listen at port=1935, type=0, fd=6
* <strong>侦听1985（HTTP接口）</strong>：[2014-04-04 11:39:24.177][trace][100][16] server started, listen at port=1985, type=1, fd=7
* <strong>侦听8080（HTTP服务）</strong>：[2014-04-04 11:39:24.177][trace][100][16] server started, listen at port=8080, type=2, fd=8
* <strong>侦听循环开始，准备接受连接</strong>：[2014-04-04 11:39:24.177][trace][101][16] listen cycle start, port=1935, type=0, fd=6

### 基于连接的日志

提供基于连接的日志，对于排错至关重要。当然对于系统分析需要支持良好的api。

举例来说，服务器运行了1年，支持了1千万次访问。要知道这1千万个用户多少个用户点了暂停按钮，多少概率会跳过片头，多少用户观看了10分钟以上，都访问了些什么节目，这个属于大数据分析，需要集群提供api查询，集群能提供这个数据的前提是服务器能提供api查询。

用户投诉卡，或者观看不了，推流不成功，或者通过数据分析发现某个流的用户观看延迟很大。这种具体的问题，就需要分析某个连接的日志。

假设需要知道推流的编码器的日志，流是`rtmp://192.168.1.107:1935/live/livestream`，那么先需要观察日志，一般推流的日志如下：

```bash
[2014-04-04 11:56:06.074][trace][104][11] rtmp get peer ip success. ip=192.168.1.179, 
send_to=30000000us, recv_to=30000000us
[2014-04-04 11:56:06.080][trace][104][11] srand initialized the random.
[2014-04-04 11:56:06.082][trace][104][11] simple handshake with client success.
[2014-04-04 11:56:06.083][trace][104][11] rtmp connect app success. 
tcUrl=rtmp://192.168.1.107:1935/live, pageUrl=, swfUrl=rtmp://192.168.1.107:1935/live, 
schema=rtmp, vhost=__defaultVhost__, port=1935, app=live
[2014-04-04 11:56:06.288][trace][104][11] set ack window size to 2500000
[2014-04-04 11:56:06.288][trace][104][11] identify ignore messages except AMF0/AMF3 
command message. type=0x5
[2014-04-04 11:56:06.288][trace][104][11] identify client success. 
type=publish(FMLEPublish), stream_name=livestream
```

查找标识id：
* 可以grep关键字`identify client success`，然后grep关键字`type=publish`，然后grep关键字`livestream`。
* 如果熟悉的话，也可以直接grep关键字`identify client success. type=publish`，然后grep关键字`livestream`。
* 也可以分步实现，先grep关键字`identify client success. type=publish`，把所有推流的连接找出来。然后观察后再加条件。
结果如下：

```bash
[winlin@dev6 srs]$ cat objs/srs.log|grep -ina "identify client success. type=publish"
20:[2014-04-04 11:56:06.288][trace][104][11] identify client success. type=publish, stream_name=livestream
43:[2014-04-04 11:56:18.138][trace][105][11] identify client success. type=publish, stream_name=winlin
65:[2014-04-04 11:56:29.531][trace][106][11] identify client success. type=publish, stream_name=livestream
86:[2014-04-04 11:56:35.966][trace][107][11] identify client success. type=publish, stream_name=livestream
```

可见有几次推流，还有其他的流。可是根据时间过滤，或者根据流名称：

```bash
[winlin@dev6 srs]$ cat objs/srs.log|grep -ina "identify client success. type=publish"|grep -a "livestream"
20:[2014-04-04 11:56:06.288][trace][104][11] identify client success. type=publish, stream_name=livestream
65:[2014-04-04 11:56:29.531][trace][106][11] identify client success. type=publish, stream_name=livestream
86:[2014-04-04 11:56:35.966][trace][107][11] identify client success. type=publish, stream_name=livestream
```

找到了三个推流连接，还可以继续筛选。假设我们看第一个，那么标识是`104`，可以grep关键字`\[104\]\[`，譬如：
```bash
[winlin@dev6 srs]$ cat objs/srs.log |grep -ina "\[104\]\["
14:[2014-04-04 11:56:06.074][trace][104][11] rtmp get peer ip success. ip=192.168.1.179, 
send_to=30000000us, recv_to=30000000us
15:[2014-04-04 11:56:06.080][trace][104][11] srand initialized the random.
16:[2014-04-04 11:56:06.082][trace][104][11] simple handshake with client success.
17:[2014-04-04 11:56:06.083][trace][104][11] rtmp connect app success. 
tcUrl=rtmp://192.168.1.107:1935/live, pageUrl=, swfUrl=rtmp://192.168.1.107:1935/live, 
schema=rtmp, vhost=__defaultVhost__, port=1935, app=live
18:[2014-04-04 11:56:06.288][trace][104][11] set ack window size to 2500000
19:[2014-04-04 11:56:06.288][trace][104][11] identify ignore messages except AMF0/AMF3 
command message. type=0x5
20:[2014-04-04 11:56:06.288][trace][104][11] identify client success. 
type=publish(FMLEPublish), stream_name=livestream
21:[2014-04-04 11:56:06.288][trace][104][11] set output chunk size to 60000
22:[2014-04-04 11:56:06.288][trace][104][11] set chunk_size=60000 success
23:[2014-04-04 11:56:07.397][trace][104][11] <- time=225273, obytes=4168, ibytes=7607, okbps=32, ikbps=59
24:[2014-04-04 11:56:07.398][trace][104][11] dispatch metadata success.
25:[2014-04-04 11:56:07.398][trace][104][11] process onMetaData message success.
26:[2014-04-04 11:56:07.398][trace][104][11] update video sequence header success. size=67
27:[2014-04-04 11:56:08.704][trace][104][11] <- time=226471, obytes=4168, ibytes=36842, okbps=13, ikbps=116
28:[2014-04-04 11:56:09.901][trace][104][11] <- time=227671, obytes=4168, ibytes=67166, okbps=9, ikbps=152
29:[2014-04-04 11:56:11.102][trace][104][11] <- time=228869, obytes=4168, ibytes=97481, okbps=6, ikbps=155
30:[2014-04-04 11:56:11.219][trace][104][11] clear cache/metadata/sequence-headers when unpublish.
31:[2014-04-04 11:56:11.219][trace][104][11] control message(unpublish) accept, retry stream service.
32:[2014-04-04 11:56:11.219][trace][104][11] ignore AMF0/AMF3 command message.
33:[2014-04-04 11:56:11.419][trace][104][11] drop the AMF0/AMF3 command message, command_name=deleteStream
34:[2014-04-04 11:56:11.420][trace][104][11] ignore AMF0/AMF3 command message.
35:[2014-04-04 11:56:12.620][error][104][104] recv client message failed. ret=207(Connection reset by peer)
36:[2014-04-04 11:56:12.620][error][104][104] identify client failed. ret=207(Connection reset by peer)
37:[2014-04-04 11:56:12.620][warn][104][104] client disconnect peer. ret=204
[winlin@dev6 srs]$ 
```

这个连接的日志就都出来了，重点关注warn和error日志。可以看到这个是客户端关闭了连接：`36:[2014-04-04 11:56:12.620][error][104][104] identify client failed. ret=207(Connection reset by peer)`。

## 守护进程

为何默认启动srs时只有一条日志呢？原因是守护进程方式启动时，日志会打印到文件。

一个相关的配置是守护进程方式启动，这样就不要nohup启动了（实际上是程序实现了nohup）：

```bash
# whether start as deamon
# default: on
daemon              on;
```

若希望不以daemon启动，且日志打印到console，可以使用配置`conf/console.conf`：

```bash
# no-daemon and write log to console config for srs.
# @see full.conf for detail config.

listen              1935;
daemon              off;
srs_log_tank        console;
vhost __defaultVhost__ {
}
```

启动方式：

```bash
./objs/srs -c conf/console.conf 
```

系统默认方式是daemon+log2file，具体参考`full.conf`的说明。

注意：[init.d脚本启动](https://github.com/winlinvip/simple-rtmp-server/wiki/LinuxService)会将console日志也打印到文件，若没有指定文件，默认文件为`./objs/srs.log`。脚本启动尽量保证日志不丢失。

注意：一般以daemon后台启动，并将日志写到文件（默认），srs会提示配置解析成功，日志写到文件。

```bash
[winlin@dev6 srs]$ ./objs/srs -c conf/srs.conf 
[2014-04-14 12:12:57.775][trace][0][0] config parse complete
[2014-04-14 12:12:57.775][trace][0][0] write log to file ./objs/srs.log
[2014-04-14 12:12:57.775][trace][0][0] you can: tailf ./objs/srs.log
[2014-04-14 12:12:57.775][trace][0][0] @see: https://github.com/winlinvip/simple-rtmp-server/wiki/SrsLog
```

Winlin 2014.3