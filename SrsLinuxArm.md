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

## 网络安装ARM虚拟环境

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

安装方式，可以选择网络安装，下载网络安装镜像后启动。

网络安装，先下载内核镜像：
* [initrd.gz](http://ftp.de.debian.org/debian/dists/stable/main/installer-armel/current/images/versatile/netboot/initrd.gz)
* [vmlinuz-3.2.0-4-versatile](http://ftp.de.debian.org/debian/dists/stable/main/installer-armel/current/images/versatile/netboot/vmlinuz-3.2.0-4-versatile)

开始安装：

```bash
qemu-system-arm -machine versatilepb -kernel vmlinuz-3.2.0-4-versatile \
    -hda hda.img -initrd initrd.gz -append "root=/dev/ram" -m 256
```

安装过程中，镜像源选择China或者Taiwan。

安装完成后，需要从hda.img硬盘中将启动映像拷贝出来，下次qemu就从它开始引导。

```bash
file -s hda.img 
#hda.img: x86 boot sector; 
#    partition 1: ID=0x83, starthead 32, startsector 2048, 7936000 sectors; 
#    partition 2: ID=0x5, starthead 63, startsector 7940094, 446466 sectors, code offset 0xb8
#第一扇区的起始地址是2048，挂载映像到文件夹：
mkdir -p disk && sudo mount ./hda.img ./disk -o offset=$((2048*256))
#取出启动内核：
cp disk/boot/initrd.img-3.2.0-4-versatile .
#使用新启动内核启动：
qemu-system-arm -machine versatilepb -kernel vmlinuz-3.2.0-4-versatile \
    -hda hda.img -initrd initrd.img-3.2.0-4-versatile -m 256 -append "root=/dev/sda1"
```

## 直接使用已经安装好的镜像

网络安装很慢，而且有时候安装失败。可以直接使用已经安装好的镜像。

首先是下载编译qemu，参考前面一章。

下载已经安装好的镜像，引导内核：
* [vmlinuz-3.2.0-4-versatile](http://people.debian.org/~aurel32/qemu/armel/vmlinuz-3.2.0-4-versatile)
* [initrd.img-3.2.0-4-versatile](http://people.debian.org/~aurel32/qemu/armel/initrd.img-3.2.0-4-versatile)
* [debian_wheezy_armel_standard.qcow2](http://people.debian.org/~aurel32/qemu/armel/debian_wheezy_armel_standard.qcow2)

下载后直接启动qemu：

```bash
qemu-system-arm -M versatilepb -kernel vmlinuz-3.2.0-4-versatile \
    -initrd initrd.img-3.2.0-4-versatile -hda debian_wheezy_armel_standard.qcow2 -append "root=/dev/sda1"
```

登录信息：
* ROOT密码：root
* 用户名：user
* 用户密码：user

网络设置：

arm虚拟机如何对外提供服务？桥接的方式很麻烦，有一种简单的方式，就是[端口转发](http://en.wikibooks.org/wiki/QEMU/Networking)，启动qemu时指定宿主host的端口和虚拟机的端口绑定，这样就可以访问宿主的端口来访问虚拟机了。譬如：

```bash
qemu-system-arm -M versatilepb -kernel vmlinuz-3.2.0-4-versatile \
    -initrd initrd.img-3.2.0-4-versatile -hda debian_wheezy_armel_standard.qcow2 -append "root=/dev/sda1" \
    -redir tcp:8000::80 -redir tcp:4450::445 -redir tcp:2200::22 -redir tcp:19350::1935
```

备注：注意，端口不能太小，譬如800:80就不行。

启动后，连接宿主的2200就可以登录到arm虚拟机。访问宿主的8000就是访问arm的80，访问19350就是访问arm的流媒体1935。445是samba端口，宿主可以将arm的共享挂载到自己的目录，对外提供共享。

其实，只要能开放22和服务端口（1935），就可以啦，可以通过scp拷贝文件。从宿主host拷贝文件到arm虚拟机：

```bash
scp -P 2200 objs/srs root@localhost:~
```

输入密码就可以拷贝过去，结果如下：

```bash
root@debian-armel:~# uname -a
Linux debian-armel 3.2.0-4-versatile #1 Debian 3.2.51-1 armv5tejl GNU/Linux
root@debian-armel:~# ls -lh
total 3.3M
-rwxr-xr-x 1 root root 3.3M Mar 15 19:01 srs
root@debian-armel:~# file srs
srs: ELF 64-bit LSB executable, x86-64, version 1 (GNU/Linux), dynamically linked (uses shared libs), for GNU/Linux 2.6.24, BuildID[sha1]=0x678e75d2547bc219be05864ef6582a3a7a4ad734, not stripped
```

若srs编译时指定arm，则可以启动，推流和观看宿主的19350，就是arm提供服务了。

## ARM和License

ARM设备大多是消费类产品，所以对于依赖的软件授权（License）很敏感，nginx-rtmp/crtmpserver都是GPL授权，对于需要目标用户在国外的ARM设备还是SRS的MIT-License更商业友好。

License也是很多ARM厂商考虑SRS的原因。

Winlin 2014.2