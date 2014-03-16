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

备注：st在arm上有个bug，原因是setjmp.h的布局变了。st在setjmp后，开辟新的stack空间，所以需要将sp设置为新开辟的空间。
* i386的sp偏移量是4：env[0].__jmp_buf[4]=(long)sp
* x86_64的sp偏移量是6：env[0].__jmp_buf[6]=(long)sp
* armhf(v7cpu)的sp偏移量是8，但是st写的是20，所以就崩溃了。

```bash
// md.h
        #elif defined(__i386__)
            #if defined(__GLIBC__) && __GLIBC__ >= 2
                #define MD_GET_SP(_t) (_t)->context[0].__jmpbuf[4]
        #elif defined(__amd64__) || defined(__x86_64__)
            #define MD_GET_SP(_t) (_t)->context[0].__jmpbuf[6]
        #elif defined(__arm__)
            #if defined(__GLIBC__) && __GLIBC__ >= 2
                #define MD_GET_SP(_t) (_t)->context[0].__jmpbuf[20]
```

x86_64的setjmp的env参数的布局：[参考资料](https://gfiber.googlesource.com/kernel/prism/+/dbb415ed05d5cea3d84dec3400669fb4f9b4c727%5E/arch/um/sys-x86_64/setjmp.S)

```bash
# The jmp_buf is assumed to contain the following, in order:
#       %rbx
#       %rsp (post-return)
#       %rbp
#       %r12
#       %r13
#       %r14
#       %r15
#       <return address>
// 从下往上数，sp是倒数第二个。所以st写的6是对的。
```

arm直接看头文件的说明：

```bash
// /usr/arm-linux-gnueabi/include/bits/setjmp.h
#ifndef _ASM
/* The exact set of registers saved may depend on the particular core
   in use, as some coprocessor registers may need to be saved.  The C
   Library ABI requires that the buffer be 8-byte aligned, and
   recommends that the buffer contain 64 words.  The first 28 words
   are occupied by v1-v6, sl, fp, sp, pc, d8-d15, and fpscr.  (Note
   that d8-15 require 17 words, due to the use of fstmx.)  */
typedef int __jmp_buf[64] __attribute__((__aligned__ (8)));
#endif
//布局应该是：words=ints
0-5: v1-v6 
6: sl
7: fp
8: sp
9: pc
10-26: d8-d15 17words
27: fpscr
//所以应该sp是env[8]，设置它就对了。
```

## Ubuntu/CentOS编译arm-srs

srs使用的默认gcc/g++编译出来的srs无法在arm下使用，必须使用arm编译器。（srs会在将来新加一个编译选项）

以Ubuntu12为例，arm编译器的安装：

```bash
sudo aptitude install -y gcc-arm-linux-gnueabi g++-arm-linux-gnueabi
```

编译工具对比：

<table>
<tr><th>x86</td><td>arm</td></tr>
<tr><td>gcc</td><td>arm-linux-gnueabi-gcc</td></tr>
<tr><td>g++</td><td>arm-linux-gnueabi-g++</td></tr>
<tr><td>ar</td><td>arm-linux-gnueabi-ar</td></tr>
<tr><td>as</td><td>arm-linux-gnueabi-as</td></tr>
<tr><td>ld</td><td>arm-linux-gnueabi-ld</td></tr>
<tr><td>ranlib</td><td>arm-linux-gnueabi-ranlib</td></tr>
<tr><td>strip</td><td>arm-linux-gnueabi-strip</td></tr>
</table>

## Armel和Armhf

有时候总是碰到`Illegal instruction`，那是编译器的目标CPU太高，虚拟机的CPU太低。参考：[http://stackoverflow.com/questions/14253626/arm-cross-compiling](http://stackoverflow.com/questions/14253626/arm-cross-compiling)

写一个简单的测试程序，测试编译环境：

```cpp
/*
 arm-linux-gnueabi-g++ -o test test.cpp -static
 arm-linux-gnueabi-strip test
*/
#include <stdio.h>

int main(int argc, char** argv) {
    printf("hello, arm!\n");
    return 0;
}
```

编译出test后，使用工具查看目标CPU：

```bash
arm-linux-gnueabi-readelf --file-header --arch-specific test
运行结果如下：
  Machine:                           ARM
File Attributes
  Tag_CPU_name: "7-A"
  Tag_CPU_arch: v7
```

可见Ubuntu12的交叉环境是cpuv7（debian armhf），所以arm虚拟机需要是v7的。

若使用debian armel，cpu是v5的，信息如下：

```bash
root@debian-armel:~# cat /proc/cpuinfo 
Processor	: ARM926EJ-S rev 5 (v5l)
CPU revision	: 5
```

若使用debian armhf，cpu是v7的，信息如下：

```bash
root@debian-armhf:~# cat /proc/cpuinfo 
Processor	: ARMv7 Processor rev 0 (v7l)
CPU architecture: 7
```

将测试程序编译后scp到arm虚拟机，可以运行：

```bash
root@debian-armhf:~# ./test 
hello, arm!
```

## 安装QEMU虚拟机环境

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

## 启动ARM虚拟机

网络安装很慢，而且有时候安装失败。可以直接使用别人提供的已经安装好的镜像，QEMU的磁盘文件和引导镜像。

首先是下载编译qemu，参考前面一章。

下载已经安装好的镜像(armhf对应ubuntu12交叉环境），引导内核：
* [vmlinuz-3.2.0-4-vexpress](http://people.debian.org/~aurel32/qemu/armhf/vmlinuz-3.2.0-4-vexpress)
* [initrd.img-3.2.0-4-vexpress](http://people.debian.org/~aurel32/qemu/armhf/initrd.img-3.2.0-4-vexpress)
* [debian_wheezy_armhf_standard.qcow2](http://people.debian.org/~aurel32/qemu/armhf/debian_wheezy_armhf_standard.qcow2)

下载后直接启动qemu：

```bash
qemu-system-arm -M vexpress-a9 -kernel vmlinuz-3.2.0-4-vexpress \
    -initrd initrd.img-3.2.0-4-vexpress -drive if=sd,file=debian_wheezy_armhf_standard.qcow2 \
    -append "root=/dev/mmcblk0p2"
```

登录信息：
* ROOT密码：root
* 用户名：user
* 用户密码：user

## ARM虚拟机网络设置

arm虚拟机如何对外提供服务？桥接的方式很麻烦，有一种简单的方式，就是[端口转发](http://en.wikibooks.org/wiki/QEMU/Networking)，启动qemu时指定宿主host的端口和虚拟机的端口绑定，这样就可以访问宿主的端口来访问虚拟机了。譬如：

```bash
qemu-system-arm -M vexpress-a9 -kernel vmlinuz-3.2.0-4-vexpress \
    -initrd initrd.img-3.2.0-4-vexpress -drive if=sd,file=debian_wheezy_armhf_standard.qcow2 \
    -append "root=/dev/mmcblk0p2" \
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

## 其他：网络安装debian-arm虚拟机

除了直接使用已有的镜像，还可以通过网络安装（但网络比较慢，安装过程容易出错，不推荐）。

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

Winlin 2014.2