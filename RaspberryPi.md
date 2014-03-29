# 树莓派下的SRS

SRS支持arm，在树莓派上成功运行，本文记录了树莓派的性能指标。

## 运行

树莓派下安装和运行SRS，有以下方式：
* 编译源站和运行：SRS在arm/raspberrypi下的编译，参考[Build: RaspberryPi](https://github.com/winlinvip/simple-rtmp-server/wiki/SrsLinuxArm#raspberrypi)
* 直接下载binary文件，然后安装运行，下载RespberryPi的安装包：[Github站点](http://winlinvip.github.io/simple-rtmp-server/releases/) 或者 [国内镜像站点](http://demo.chnvideo.com:8085/srs/releases/)。安装方法见页面。

查看SRS是否启动：`/etc/init.d/srs status`

## 环境

本次测试的硬件环境如下：
* [RaspberryPi](http://item.jd.com/1014155.html)：B型
* <strong>SoC</strong> BroadcomBCM2835(CPU,GPU,DSP,SDRAM,USB)
* <strong>CPU</strong> ARM1176JZF-S(ARM11) 700MHz
* <strong>GPU</strong> Broadcom VideoCore IV, OpenGL ES 2.0, 1080p 30 h.264/MPEG-4 AVC decoder
* <strong>RAM</strong> 512MByte
* <strong>USB</strong> 2 x USB2.0
* <strong>VideoOutput</strong> Composite RCA(PAL&NTSC), HDMI(rev 1.3&1.4), raw LCD Panels via DSI 14 HDMI resolution from 40x350 to 1920x1200 plus various PAL and NTSC standards
* <strong>AudioOutput</strong> 3.5mm, HDMI
* <strong>Storage</strong> SD/MMC/SDIO socket
* <strong>Network</strong> 10/100 ethernet
* <strong>Device</strong> 8xGPIO, UART, I2C, SPI bus, +3.3V, +5V, ground(nagetive)
* <strong>Power</strong> 700mA(3.5W) 5V
* <strong>Size</strong> 85.60 x 53.98 mm(3.370 x 2.125 in)
* <strong>OS</strong> Debian GNU/linux, Fedora, Arch Linux ARM, RISC OS, XBMC

另外，直播不会用到SD卡，所以可以忽略不计，用的是class2，4GB的卡。

软件环境如下：
* RaspberryPi提供的img：2014-01-07-wheezy-raspbian.img
* <strong>uname</strong>: Linux raspberrypi 3.10.25+ #622 PREEMPT Fri Jan 3 18:41:00 GMT 2014 armv6l GNU/Linux
* <strong>cpu</strong>: arm61
* <strong>服务器</strong>: srs 0.9.38
* <strong>客户端</strong>：flash + [st-load](https://github.com/winlinvip/st-load)
* <strong>网络</strong>: 百兆交换机（pi只支持百兆）

流信息：
* 码率：200kbps
* 分辨率：768x320
* 音频：30kbps

环境搭建参考：[SRS: arm](https://github.com/winlinvip/simple-rtmp-server/wiki/SrsLinuxArm#raspberrypi)

## OS设置

超过1024的连接数测试需要打开linux的限制。且必须以root登录和执行。

* 设置连接数：`ulimit -HSn 10240`
* 查看连接数：

```bash
[root@dev6 ~]# ulimit -n
10240
```

* 重启srs：`sudo /etc/init.d/srs restart`

* 注意：启动服务器前必须确保连接数限制打开。

## 推流和观看

可以使用centos虚拟机推流到srs，或者用FMLE推流到raspberry-pi的SRS。

推送RTMP流到服务器和观看。

* 启动FFMPEG循环推流：

```bash
for((;;)); do \
    ./objs/ffmpeg/bin/ffmpeg \
        -re -i doc/source.200kbps.768x320.flv \
        -acodec copy -vcodec copy \
        -f flv -y rtmp://192.168.1.105:1935/live/livestream; \
    sleep 1; 
done
```
```

* 查看服务器的地址：`192.168.1.105`

```bash
[root@dev6 nginx-rtmp]# ifconfig eth0
eth0      Link encap:Ethernet  HWaddr 08:00:27:8A:EC:94  
          inet addr:192.168.1.105  Bcast:192.168.2.255  Mask:255.255.255.0
```

* SRS的流地址：`rtmp://192.168.1.105:1935/live/livestream`
* 通过srs-players播放SRS流：[播放SRS的流](http://winlinvip.github.io/simple-rtmp-server/trunk/research/players/srs_player.html?server=192.168.1.105&port=1935&app=live&stream=livestream&vhost=192.168.1.105&autostart=true)

## 客户端

使用linux工具模拟RTMP客户端访问，参考：[st-load](https://github.com/winlinvip/st-load)

st_rtmp_load为RTMP流负载测试工具，单个进程可以模拟1000至3000个客户端。为了避免过高负载，一个进程模拟800个客户端。

* 编译：`./configure && make`
* 启动参数：`./objs/st_rtmp_load -c 800 -r <rtmp_url>`

## 开始负载测试前

测试前，记录SRS和nginx-rtmp的各项资源使用指标，用作对比。

* 查看连接数命令：

```bash
srs_connections=`netstat -anp|grep srs|grep ESTABLISHED|wc -l`; \
echo "srs_connections: $srs_connections"
```

* 查看服务器消耗带宽，其中，单位是bytes，需要乘以8换算成网络用的bits，设置dstat为30秒钟统计一次，数据更准：

```bash
[winlin@dev6 ~]$ dstat 30
----total-cpu-usage---- -dsk/total- -net/lo- ---paging-- ---system--
usr sys idl wai hiq siq| read  writ| recv  send|  in   out | int   csw 
  0   0  96   0   0   3|   0     0 |1860B   58k|   0     0 |2996   465 
  0   1  96   0   0   3|   0     0 |1800B   56k|   0     0 |2989   463 
  0   0  97   0   0   2|   0     0 |1500B   46k|   0     0 |2979   461 
```

* 数据见下表：

<table>
<tr>
  <td>Server</td>
  <td>CPU占用率</td>
  <td>内存</td>
  <td>连接数</td>
  <td>期望带宽</td>
  <td>实际带宽</td>
  <td>st-load</td>
  <td>客户端延迟</td>
</tr>
<tr>
  <td>SRS</td>
  <td>1.0%</td>
  <td>3MB</td>
  <td>3</td>
  <td>不适用</td>
  <td>不适用</td>
  <td>不适用</td>
  <td>0.8秒</td>
</tr>
</table>

期望带宽：譬如测试码率为200kbps时，若模拟1000个并发，应该是1000*200kbps=200Mbps带宽。

实际带宽：指服务器实际的吞吐率，服务器性能下降时（譬如性能瓶颈），可能达不到期望的带宽，会导致客户端拿不到足够的数据，也就是卡顿的现象。

客户端延迟：粗略计算即为客户端的缓冲区长度，假设服务器端的缓冲区可以忽略不计。一般RTMP直播播放器的缓冲区设置为0.8秒，由于网络原因，或者服务器性能问题，数据未能及时发送到客户端，就会造成客户端卡（缓冲区空），网络好时将队列中的数据全部给客户端（缓冲区变大）。

st-load：指模拟500客户端的st-load的平均CPU。一般模拟1000个客户端没有问题，若模拟1000个，则CPU简单除以2。

其中，“不适用”是指还未开始测试带宽，所以未记录数据。

Winlin 2014.3