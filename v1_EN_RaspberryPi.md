# Performance benchmark for SRS on RaspberryPi

SRS can running on armv6(RaspberryPi) or armv7(Android). 
The bellow data show the performance benchmark.

## Install SRS

Download the binary for armv6 from [Github](http://winlinvip.github.io/simple-rtmp-server/releases/) 
or [SRS Server](http://ossrs.net/srs/releases/)

## RaspberryPi

The hardware of raspberrypi:
* [RaspberryPi](http://item.jd.com/1014155.html)：Type B
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

Software:
* RaspberryPi img：2014-01-07-wheezy-raspbian.img
* <strong>uname</strong>: Linux raspberrypi 3.10.25+ #622 PREEMPT Fri Jan 3 18:41:00 GMT 2014 armv6l GNU/Linux
* <strong>cpu</strong>: arm61
* <strong>Server</strong>: srs 0.9.38
* <strong>ServerType</strong>: raspberry pi
* <strong>Client</strong>：[st-load](https://github.com/winlinvip/st-load)
* <strong>ClientType</strong>: Virtual Machine Centos6
* <strong>Play</strong>: PC win7, flash
* <strong>Network</strong>: 100Mbps

Stream information:
* Video Bitrate: 200kbps
* Resolution: 768x320
* Audio Bitrate: 30kbps

For arm [SRS: arm](https://github.com/simple-rtmp-server/srs/wiki/v1_EN_SrsLinuxArm#raspberrypi)

## OS settings

Login as root, set the fd limits:

* Set limit: `ulimit -HSn 10240`
* View the limit:

```bash
[root@dev6 ~]# ulimit -n
10240
```

* Restart SRS：`sudo /etc/init.d/srs restart`

## Publish and Play

Use centos to publish to SRS:

* Start FFMPEG:

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

* Play RTMP: `rtmp://192.168.1.105:1935/live/livestream`
* Online Play: [Online Player](http://winlinvip.github.io/simple-rtmp-server/trunk/research/players/srs_player.html?server=192.168.1.105&port=1935&app=live&stream=livestream&vhost=192.168.1.105&autostart=true)

## Client

The RTMP load test tool, read [st-load](https://github.com/winlinvip/st-load)

The st_rtmp_load used to test RTMP load, support 800-3k concurrency for each process.

* Build: `./configure && make`
* Start: `./objs/st_rtmp_load -c 800 -r <rtmp_url>`

## Record Data

Record data before test:

* The cpu for SRS:

```bash
pid=`ps aux|grep srs|grep objs|awk '{print $2}'` && top -p $pid
```

* The cpu for st-load:

```bash
pid=`ps aux|grep load|grep rtmp|awk '{print $2}'` && top -p $pid
```

* The connections:

```bash
for((;;)); do \
    srs_connections=`sudo netstat -anp|grep 1935|grep ESTABLISHED|wc -l`;  \
    echo "srs_connections: $srs_connections";  \
    sleep 5;  \
done
```

* The bandwidth in NBps:

```bash
[winlin@dev6 ~]$ dstat 30
----total-cpu-usage---- -dsk/total- -net/lo- ---paging-- ---system--
usr sys idl wai hiq siq| read  writ| recv  send|  in   out | int   csw 
  0   0  96   0   0   3|   0     0 |1860B   58k|   0     0 |2996   465 
  0   1  96   0   0   3|   0     0 |1800B   56k|   0     0 |2989   463 
  0   0  97   0   0   2|   0     0 |1500B   46k|   0     0 |2979   461 
```

* The table

<table>
<tr>
  <td>Server</td>
  <td>CPU</td>
  <td>Memory</td>
  <td>Clients</td>
  <td>ExpectNbps</td>
  <td>ActualNbps</td>
  <td>st-load</td>
  <td>Latency</td>
</tr>
<tr>
  <td>SRS</td>
  <td>1.0%</td>
  <td>3MB</td>
  <td>3</td>
  <td>-</td>
  <td>-</td>
  <td>-</td>
  <td>0.8s</td>
</tr>
</table>

## Benchmark SRS 0.9.38

Let's start performance benchmark.

* The data for 10 clients:

```bash
./objs/st_rtmp_load -c 10 -r rtmp://192.168.1.105:1935/live/livestream >/dev/null &
```

<table>
<tr>
  <td>Server</td>
  <td>CPU</td>
  <td>Memory</td>
  <td>Clients</td>
  <td>ExpectNbps</td>
  <td>ActualNbps</td>
  <td>st-load</td>
  <td>Latency</td>
</tr>
<tr>
  <td>SRS</td>
  <td>17%</td>
  <td>1.4MB</td>
  <td>11</td>
  <td>2.53Mbps</td>
  <td>2.6Mbps</td>
  <td>1.3%</td>
  <td>1.7s</td>
</tr>
</table>

* The data for 20 clients:

<table>
<tr>
  <td>Server</td>
  <td>CPU</td>
  <td>Memory</td>
  <td>Clients</td>
  <td>ExpectNbps</td>
  <td>ActualNbps</td>
  <td>st-load</td>
  <td>Latency</td>
</tr>
<tr>
  <td>SRS</td>
  <td>23%</td>
  <td>2MB</td>
  <td>21</td>
  <td>4.83Mbps</td>
  <td>5.5Mbps</td>
  <td>2.3%</td>
  <td>1.5s</td>
</tr>
</table>

* The data for 30 clients:

<table>
<tr>
  <td>Server</td>
  <td>CPU</td>
  <td>Memory</td>
  <td>Clients</td>
  <td>ExpectNbps</td>
  <td>ActualNbps</td>
  <td>st-load</td>
  <td>Latency</td>
</tr>
<tr>
  <td>SRS</td>
  <td>50%</td>
  <td>4MB</td>
  <td>31</td>
  <td>7.1Mbps</td>
  <td>8Mbps</td>
  <td>4%</td>
  <td>2s</td>
</tr>
</table>

The summary for RaspberryPi Type B, 230kbps performance:

<table>
<tr>
  <td>Server</td>
  <td>CPU</td>
  <td>Memory</td>
  <td>Clients</td>
  <td>ExpectNbps</td>
  <td>ActualNbps</td>
  <td>st-load</td>
  <td>Latency</td>
</tr>
<tr>
  <td>SRS</td>
  <td>17%</td>
  <td>1.4MB</td>
  <td>11</td>
  <td>2.53Mbps</td>
  <td>2.6Mbps</td>
  <td>1.3%</td>
  <td>1.7s</td>
</tr>
<tr>
  <td>SRS</td>
  <td>23%</td>
  <td>2MB</td>
  <td>21</td>
  <td>4.83Mbps</td>
  <td>5.5Mbps</td>
  <td>2.3%</td>
  <td>1.5s</td>
</tr>
<tr>
  <td>SRS</td>
  <td>50%</td>
  <td>4MB</td>
  <td>31</td>
  <td>7.1Mbps</td>
  <td>8Mbps</td>
  <td>4%</td>
  <td>2s</td>
</tr>
</table>

## Benchmark SRS 0.9.72

The benchmark for RTMP SRS 0.9.72.

<table>
<tr>
  <td>Server</td>
  <td>CPU</td>
  <td>Memory</td>
  <td>Clients</td>
  <td>ExpectNbps</td>
  <td>ActualNbps</td>
  <td>st-load</td>
  <td>Latency</td>
</tr>
<tr>
  <td>SRS</td>
  <td>5%</td>
  <td>2MB</td>
  <td>2</td>
  <td>1Mbps</td>
  <td>1.2Mbps</td>
  <td>0%</td>
  <td>1.5s</td>
</tr>
<tr>
  <td>SRS</td>
  <td>20%</td>
  <td>2MB</td>
  <td>12</td>
  <td>6.9Mbps</td>
  <td>6.6Mbps</td>
  <td>2.8%</td>
  <td>2s</td>
</tr>
<tr>
  <td>SRS</td>
  <td>36%</td>
  <td>2.4MB</td>
  <td>22</td>
  <td>12.7Mbps</td>
  <td>12.9Mbps</td>
  <td>2.3%</td>
  <td>2.5s</td>
</tr>
<tr>
  <td>SRS</td>
  <td>47%</td>
  <td>3.1MB</td>
  <td>32</td>
  <td>18.5Mbps</td>
  <td>18.5Mbps</td>
  <td>5%</td>
  <td>2.0s</td>
</tr>
<tr>
  <td>SRS</td>
  <td>62%</td>
  <td>3.4MB</td>
  <td>42</td>
  <td>24.3Mbps</td>
  <td>25.7Mbps</td>
  <td>9.3%</td>
  <td>3.4s</td>
</tr>
<tr>
  <td>SRS</td>
  <td>85%</td>
  <td>3.7MB</td>
  <td>52</td>
  <td>30.2Mbps</td>
  <td>30.7Mbps</td>
  <td>13.6%</td>
  <td>3.5s</td>
</tr>
</table>

## cubieboard benchmark

No data.

Winlin 2014.11