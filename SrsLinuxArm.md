# SRS应用于linux-arm

arm芯片上，如何使用SRS？一般arm上的硬件可以获取到h.264裸码流。有几个方案：
* arm推送RTMP到SRS：从arm上将h.264裸码流包装成flv流，使用[srs-librtmp](https://github.com/winlinvip/simple-rtmp-server/wiki/SrsLibrtmp)，或者librtmp，将flv格式的包以RTMP发送到SRS。
* arm推送h.264裸码流到SRS（目前还不支持）：可以使用自定义协议，可以不必使用RTMP这么复杂的协议，使用socket将h.264裸码流发送到SRS，SRS服务器端将裸码流打包成RTMP分发。
* arm上运行SRS：在arm上运行SRS，使用上面两个方案将h.264裸码流推送到arm上的SRS。客户端或者RTMP边缘直接从arm上的SRS源站取RTMP流。

## 为何ARM上跑SRS？

ARM跑SRS主要原因：
* arm设备，像摄像头，比较多，譬如一万个摄像头，如果有中心服务器，都往上面推，中心服务器就完蛋了。
* 用户看摄像头时，一般需要装插件，一般摄像头只能出rtmp。所以没法用浏览器flash直接看。所以arm上跑个srs，就可以让用户直接打开。
* arm上跑srs，每个摄像头都是服务器，相当于分布式服务器。不过都是源站。

SRS在ARM上主要是源站：
* 只需要st，ssl，提供基本的RTMP流源站即可。
* 不需要http-parser，nginx，ffmpeg，api-server，边缘，其他都不需要。

等ARM上SRS运行没有问题，SRS会新开一个分支，去掉其他的东西，只保留必要的东西。

备注：“arm上运行SRS”需要在编译时用arm编译命令，并且st要使用linux-optimized选项，否则运行失败。
备注：arm上运行srs，主要st的移植性有问题，有人报告说会运行失败。应该是st的汇编不支持arm平台。总之，目前arm上运行srs服务器还是不靠谱的事情。

建议有arm需求的研发可以：<br/>
1. 看下st的汇编部分，看能否直接用linux api，这个靠谱<br/>
2. 给st邮件列表发个邮件问下，看大牛怎么说。<br/>
3. 给srs的st打个patch，我增加一个编译选项，先用你的patch。等st接受你的patch了，我再升级合并过去。<br/>
arm上支持有几个人提过，但无论如何，linux x86平台srs是必须保证的。我只能保证不影响linux x86平台运行时，加入arm支持。只能加编译选项和打st的patch，这样就完全不影响x86平台。

## 搭建ARM虚拟环境

qemu可以模拟arm的环境，可以在CentOS/Ubuntu下先编译安装qemu（yum/aptitude安装的好像不全）。

qemu依赖于SDL（图形界面），SDL依赖于图形linux，所以最好用ubuntu桌面版和CentOS开发版，进入图形界面后安装sdl。
* CentOS SDL安装：`sudo yum install -y SDL-devel`
* Ubuntu SDL安装：`sudo aptitude install -y libsdl1.2-dev`

然后下载qemu，好像网站被墙了，所以可以用迅雷下，它的p2p网络会去找这个文件：

```html
http://wiki.qemu-project.org/download/qemu-1.7.0.tar.bz2
```

编译和安装qemu

```bash
tar xf qemu-1.7.0.tar.bz2 && cd qemu-1.7.0 && ./configure && make && sudo make install
```

qemu两个重要的工具：

```bash
/usr/local/bin/qemu-img
/usr/local/bin/qemu-system-arm
```

创建虚拟机使用的硬盘：

```bash
qemu-img create -f raw hda.img 4G
```

安装方式，可以选择：
* 网络安装，下载网络安装镜像后启动。
* ISO映像安装，下载ISO文件，然后安装。就像一般装其他虚拟机一样。

网络安装，先下载内核镜像：
* [initrd.gz](http://ftp.de.debian.org/debian/dists/stable/main/installer-armel/current/images/versatile/netboot/initrd.gz)
* [vmlinuz-3.2.0-4-versatile](http://ftp.de.debian.org/debian/dists/stable/main/installer-armel/current/images/versatile/netboot/vmlinuz-3.2.0-4-versatile)

开始安装：

```bash
qemu-system-arm -machine versatilepb -kernel vmlinuz-3.2.0-4-versatile -hda hda.img -initrd initrd.gz -m 256
```

安装过程中，镜像源选择China或者Taiwan。

## ARM和License

ARM设备大多是消费类产品，所以对于依赖的软件授权（License）很敏感，nginx-rtmp/crtmpserver都是GPL授权，对于需要目标用户在国外的ARM设备还是SRS的MIT-License更商业友好。

License也是很多ARM厂商考虑SRS的原因。

Winlin 2014.2