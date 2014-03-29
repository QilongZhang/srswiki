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

流信息：
* 码率：200kbps
* 分辨率：720x576
* 音频：无音频

Winlin 2014.3