# 编译SRS

本文说明了如何编译和打包SRS，另外，可以直接下载release的binary，提供了几个常见系统的安装包，安装程序会安装系统服务，直接以系统服务启动即可。参考：[Github: release]([Download Released SRS(下载发布版)](http://winlinvip.github.io/simple-rtmp-server))或者[国内镜像: release](http://demo.chnvideo.com:8085/srs/releases)

## 操作系统

* README中的Usage，在<strong>Centos6.x/Ubuntu12</strong>下面测试成功。按照Step操作后，浏览器中打开服务器地址就能观看所有的DEMO。
* DEMO演示了所有SRS的功能，特别是ffmpeg依赖的库巨多，因此为了简化，推荐使用<strong>Centos6.x/Ubuntu12</strong>.
* 若的确需要在其他系统下编译SRS，下面说明SRS依赖的各种库，可以关掉某些功能减少编译的依赖。

## 关闭防火墙和selinux

有时候启动没有问题，但是就是看不了，原因是防火墙和selinux开着。

可以用下面的方法关掉防火墙：

```bash
# disable the firewall
sudo /etc/init.d/iptables stop
sudo /sbin/chkconfig iptables off
```

selinux也需要disable，运行命令`getenforce`，若不是Disabled，执行下面的步骤：

1. 编辑配置文件：`sudo vi /etc/sysconfig/selinux`
1. 把SELINUX的值改为disabled：`SELINUX=disabled`
1. 重启系统：`sudo init 6`

## 编译和启动

确定用什么编译选项后（参考下面的说明），编译SRS其实很简单。只需要RTMP和HLS：

```
./configure && make
```

指定配置文件，即可启动SRS：

```bash
./objs/srs -c conf/srs.conf
```

推RTMP流和观看，参考[Usage: RTMP](https://github.com/winlinvip/simple-rtmp-server/wiki/SampleRTMP)

更多使用方法，参考[Usage](https://github.com/winlinvip/simple-rtmp-server#usage)

## jobs:加速编译

由于SRS在configure时需要编译ffmpeg/nginx，这个过程会很漫长，如果你有多核机器，那么可以使用jobs来并行编译。
* configure: 在编译srs依赖的工具时可以并行编译。
* make: 在编译srs时可以使用并行编译。

srs并行编译和串行编译的项目包括（srs会自动判断，不需要用户指定）：
* srs: 支持并行编译。
* st-1.9: 串行编译，库比较小，编译时间很短。
* http-parser: 串行编译，库比较小，编译时间很短。
* openssl: 串行编译，并行编译有问题。
* nginx: 支持并行编译。
* ffmpeg: 支持并行编译。
* lame: 支持并行编译。ffmpeg用到的mp3库。
* libaacplus: 串行编译，并行编译有问题。ffmpeg用到的aac库。
* x264: 支持并行编译。ffmpeg用到的x264库。

configure使用并行编译的方法如下：

```bash
./configure --jobs=16
```

注意：configure不支持make那样的"-jN"，只支持"--jobs[=N]"。

make使用并行编译的方法如下：

```bash
// or make --jobs=16
make -j16
```

## Package

SRS提供了打包脚本，可以将srs打包（不包含nginx/ffmpeg等外部程序）。安装包也提供下载，参考本文开头部分。

打包脚本会编译srs，然后将srs的文件打包为zip（zip比tar通用）。详细参考package的帮助：

```bash
[winlin@dev6 srs]$ ./scripts/package.sh --help

  --help                   print this message

  --arm                    configure with arm and make srs. use arm tools to get info.
  --no-build               donot build srs, user has builded. only make install.
```

## SRS依赖关系

SRS依赖于g++/gcc/make，st-1.9，http-parser2.1，ffmpeg，cherrypy，nginx，openssl-devel，python2。

某些依赖可以通过configure配置脚本关闭，详见下表：

<table>
<tr>
<td><strong>功能</strong></td>
<td><strong>选项</strong></td>
<td><strong>编译</strong></td>
<td><strong>依赖库</strong></td>
<td><strong>说明</strong></td>
</tr>
<tr>
<td>编译器</td>
<td>必选</td>
<td>无</td>
<td>linux,g++,gcc,make</td>
<td>基础编译环境</td>
</tr>
<tr>
<td>RTMP(Basic)</td>
<td>必选</td>
<td>无</td>
<td>st-1.9</td>
<td>RTMP服务器，st为处理并发的基础库<br/>forward,vhost,refer,reload为基础功能。<br/><br/>st-1.9没有再依赖其他库，在各种linux下都可以编译，<br/>测试过的有CentOS4/5/6，Ubuntu12，Debian-Armhf，<br/>其他问题也不大<br/>
参考: <a href="https://github.com/winlinvip/simple-rtmp-server/wiki/DeliveryRTMP">DeliveryRTMP</td>
</tr>
<tr>
<td>RTMP<br/>(H.264/AAC)</td>
<td>可选</td>
<td>--with-ssl</td>
<td>ssl</td>
<td>RTMP分发H.264/AAC，需要支持<a href="http://blog.csdn.net/win_lin/article/details/13006803">复杂握手</a><br/><br/>简单握手的内容为1537字节随机数，<br/>而复杂握手为按一定规则加密的数据<br/><br/>srs使用自己编译的ssl库<br/>
参考: <a href="https://github.com/winlinvip/simple-rtmp-server/wiki/RTMPHandshake">RTMPHandshake</td>
</tr>
<tr>
<td>HLS</td>
<td>可选</td>
<td>--with-hls \<br/>
--with-nginx</td>
<td>nginx</td>
<td>--with-hls<br/>将RTMP流切片成ts，并生成m3u8，<br/>即AppleHLS流分发。参考：<a href="https://github.com/winlinvip/simple-rtmp-server/wiki/DeliveryHLS">HLS</a><br/><br/>
--with-nginx<br/>打开此功能后会编译<a href="http://nginx.org/">nginx</a>，<br/>通过nginx分发m3u8和ts静态文件<br/>
参考: <a href="https://github.com/winlinvip/simple-rtmp-server/wiki/DeliveryHLS">DeliveryHLS</a>
</td>
</tr>
<tr>
<td>FFMPEG</td>
<td>可选</td>
<td>--with-ffmpeg</td>
<td>ffmpeg<br/>(libaacplus,<br/>lame,yasm,<br/>x264,ffmpeg)</td>
<td>转码，转封装，采集工具，<br/>FFMPEG依赖的项目实在太多，<br/>而且在老版本的linux上这些库很难编译成功，<br/><br/>因此若不需要转码功能，建议关闭此功能，<br/>若需要转码，推荐使用CentOS6.*/Ubuntu12系统<br/>
参考: <a href="https://github.com/winlinvip/simple-rtmp-server/wiki/FFMPEG">FFMPEG</a></td>
</tr>
<tr>
<td>Transcode</td>
<td>可选</td>
<td>--with-transcode</td>
<td>转码工具<br/>譬如FFMPEG</td>
<td>将RTMP流转码后输出RTMP流，<br/>一般转码需要FFMPEG工具，<br/>或者禁用FFMPEG后指定自己的工具<br/>
参考: <a href="https://github.com/winlinvip/simple-rtmp-server/wiki/FFMPEG">FFMPEG</a></td>
</tr>
<tr>
<td>HttpCallback</td>
<td>可选</td>
<td>--with-http-callback</td>
<td>cherrypy<br/>http-parser2.1<br/>python2</td>
<td>当某些事件发生，SRS可以调用http地址<br/><br/>譬如客户端连接到服务器时，SRS会调用<br/>on_connect接口，SRS自带了一个<br/>research/api-server(使用Cherrypy)，<br/>提供了这些http api的默认实现。<br/><br/>另外，若开启了HttpCallback，<br/>players的演示默认会跳转到api-server<br/><br/>http-parser2.1在各种linux下编译问题也不大<br/><br/>python2.6/2.7在CentOS6/Ubuntu12下才有，<br/>所以CentOS5启动HttpCallback会报json模块找不到<br/>
参考: <a href="https://github.com/winlinvip/simple-rtmp-server/wiki/HTTPCallback">HTTPCallback</td>
</tr>
<tr>
<td>HttpServer</td>
<td>可选</td>
<td>--with-http-server</td>
<td>http-parser2.1</td>
<td>SRS内嵌了一个web服务器，实现基本的http协议，<br/>主要用于文件分发。<br/>
参考: <a href="https://github.com/winlinvip/simple-rtmp-server/wiki/HTTPServer">HTTPServer</a></td>
</tr>
<tr>
<td>HttpApi</td>
<td>可选</td>
<td>--with-http-api</td>
<td>http-parser2.1</td>
<td>SRS提供http-api（内嵌了web服务器），<br/>支持http方式管理服务器。<br/>
参考: <a href="https://github.com/winlinvip/simple-rtmp-server/wiki/HTTPApi">HTTPApi</a></td>
</tr>
<tr>
<td>ARM</td>
<td>可选</td>
<td>--with-arm-ubuntu12</td>
<td>无额外依赖</td>
<td>SRS可运行于ARM，<br/>若需要支持<a href="https://github.com/winlinvip/simple-rtmp-server/wiki/RTMPHandshake">复杂握手</a>则需要依赖ssl，<br/>目前在Ubuntu12下编译，<br/>debian-armhf(v7cpu)下测试通过<br/>
参考: <a href="https://github.com/winlinvip/simple-rtmp-server/wiki/SrsLinuxArm">SrsLinuxArm</td>
</tr>
<tr>
<td>librtmp</td>
<td>可选</td>
<td>--with-librtmp</td>
<td>无额外依赖</td>
<td>SRS提供客户端库<a href="https://github.com/winlinvip/simple-rtmp-server/wiki/SrsLibrtmp">srs-librtmp</a>，<br/>若需要支持<a href="https://github.com/winlinvip/simple-rtmp-server/wiki/RTMPHandshake">复杂握手</a>则需要依赖ssl，<br/>支持客户端推RTMP流到SRS，或者播放RTMP流<br/><br/>srs-librtmp使用同步socket，协议栈和SRS<br/>服务端一致，和librtmp一样，只适合用作客户端，<br/>不可用作服务端。<br/>
参考: <a href="https://github.com/winlinvip/simple-rtmp-server/wiki/SrsLibrtmp">SrsLibrtmp</td>
</tr>
<tr>
<td>DEMO</td>
<td>可选</td>
<td>--with-ssl \<br/>--with-hls \<br/>--with-nginx \<br/>--with-ffmpeg \<br/>--with-transcode<br/></td>
<td>nginx/cherrypy</td>
<td>SRS的演示播放器/转码输出的流/编码器/视频会议，<br/>因为需要http服务器，所以依赖于nginx，<br/><br/>另外，视频会议因为需要知道大家发布的流名称，<br/>所以需要HttpCallback支持<br/>
参考: <a href="https://github.com/winlinvip/simple-rtmp-server/wiki/SampleDemo">SampleDemo</td>
</tr>
<tr>
<td>GPERF</td>
<td>可选</td>
<td>--with-gperf</td>
<td>gperftools</td>
<td>使用Google的tcmalloc内存分配库，<br/>gmc/gmp/gcp依赖这个选项，参考：<a href="https://github.com/winlinvip/simple-rtmp-server/wiki/GPERF">GPERF</a></td>
</tr>
<tr>
<td>GPERF(GMC)</td>
<td>可选</td>
<td>--with-gmc</td>
<td>gperftools</td>
<td>内存检查gperf-memory-check，<br/>gmc依赖gperf，参考：<a href="https://github.com/winlinvip/simple-rtmp-server/wiki/GPERF">GPERF</a></td>
</tr>
<tr>
<td>GPERF(GMP)</td>
<td>可选</td>
<td>--with-gmp</td>
<td>gperftools</td>
<td>内存性能分析gperf-memory-profile，<br/>gmp依赖gperf，参考：<a href="https://github.com/winlinvip/simple-rtmp-server/wiki/GPERF">GPERF</a></td>
</tr>
<tr>
<td>GPERF(GCP)</td>
<td>可选</td>
<td>--with-gcp</td>
<td>gperftools</td>
<td>CPU性能分析gperf-cpu-profile，<br/>gcp依赖gperf，参考：<a href="https://github.com/winlinvip/simple-rtmp-server/wiki/GPERF">GPERF</a></td>
</tr>
<tr>
<td>GPROF</td>
<td>可选</td>
<td>--with-gprof</td>
<td>gprof</td>
<td>GNU CPU profile性能分析工具，<br/>参考：<a href="https://github.com/winlinvip/simple-rtmp-server/wiki/GPROF">GPROF</a></td>
</tr>
</table>

## 应用场景

下面是常见的几种应用场景，以及对应的编译选项。

<table>
<tr>
<td><strong>应用场景</strong></td>
<td><strong>功能组合</strong></td>
<td><strong>编译选项</strong></td>
<td><strong>说明</strong></td>
</tr>
<tr>
<td>RTMP功能</td>
<td>RTMP(Basic)<br/>RTMP(H.264/AAC)</td>
<td>./configure \<br/>--with-ssl \<br/>--without-hls \<br/>--without-http-callback \<br/>--without-ffmpeg</td>
<td>只有基本的RTMP功能，作为RTMP源站提供服务。<br/>包含Forward/Reload/Refer/Vhost等核心功能。<br/>没有HLS，也没有转码，没有HttpCallback。<br/>典型场景：<br/>1.RTMP网络电视台<br/>2.美女主播<br/>3.视频会议<br/>4.低延时的交互类应用<br/>5.其他RTMP应用</td>
</tr>
<tr>
<td>快速预览<br/>最小依赖</td>
<td>RTMP(Basic)</td>
<td>./configure \<br/>--without-ssl \<br/>--without-hls \<br/>--without-http-callback \<br/>--without-ffmpeg \<br/>--without-transcode \<br/>--without-http-server \<br/>--without-http-api</td>
<td>只保留系统核心功能，连RTMP分发h.264/aac都去掉。<br/>可以编译速度最快，几乎在所有的linux都能编译成功<br/>包含RTMP(Basic)基本流分发功能，<br/>包含Forward/Reload/Refer/Vhost核心功能<br/>典型场景：<br/>1.想快速编译SRS<br/>2.想在很老的系统下编译SRS<br/>3.VP6推RTMP流就可以</td>
</tr>
<tr>
<td>多屏分发</td>
<td>RTMP(Basic)<br/>RTMP(H.264/AAC)<br/>HLS</td>
<td>./configure \<br/>--with-ssl \<br/>--with-hls \<br/>--with-nginx \<br/>--without-http-callback \<br/>--without-ffmpeg \<br/>--without-transcode</td>
<td>希望支持PC(RTMP)，Apple(HLS)和Android(HLS)观看，<br/>PC上自然是adobe的flash观看效果最佳，<br/>1. flash自然是播放RTMP最稳定，<br/>测试显示10天连续播放都没有问题，<br/>2. Apple平台自然是HLS，<br/>就是看到HLS在Apple上完美表现，<br/>SRS才决定支持HLS，<br/>3. Android上的流媒体没有稳定的分发方式，<br/>相对而言，HLS是较好的选择，<br/>Andorid上播放器用HTML5播放m3u8<br/>典型场景：<br/>1.多屏分发的广播流<br/>2.对延时不那么关心（HLS延时至少一个ts切片）<br/>3.需要支持移动端<br/>注意：HLS需要h264和AAC编码，若编码器不支持，则需要转码</td>
</tr>
<tr>
<td>转码</td>
<td>RTMP(Basic)<br/>RTMP(H.264/AAC)<br/>Transcode</td>
<td>./configure \<br/>--with-ssl \<br/>--without-hls \<br/>--without-http-callback \<br/>--with-ffmpeg \<br/>--with-transcode</td>
<td>希望对RTMP进行转码后输出，<br/>譬如，flash推流到SRS，编码是vp6和speex，<br/>希望转码为h264和aac后输出HLS，<br/>譬如，编码器推送较高码率到SRS，转码输出较低码率，<br/>譬如，加水印后输出，<br/>譬如，只对音频进行转码，将speex/mp3转码为aac给手机端播放，<br/>转码是wowza里面很贵的一个插件，应用场景可见一斑<br/>典型场景：<br/>1.需要输出HLS，但是输入流不是h264/aac<br/>2.高码率输入，多路输出，手机端播放低码率的流<br/>3.各种FFMPEG滤镜的应用<br/>注意：所有转码的流可以再经过SRS进行HLS切片和forward</td>
</tr>
<tr>
<td>逻辑控制</td>
<td>RTMP(Basic)<br/>HttpCallback</td>
<td>./configure \<br/>--without-ssl \<br/>--without-hls \<br/>--with-http-callback \<br/>--without-ffmpeg \<br/>--without-transcode</td>
<td>希望对服务器上的各种事件进行控制，<br/>譬如，连接到SRS后，到api-server进行验证，<br/>通过后再进行服务，<br/>譬如，希望统计当前连接数，各个流的数据等，<br/>典型场景：<br/>1.视频会议，api-server可以知道SRS上的流<br/>2.统计，统计在线人数，带宽等（cli也可以查询）<br/>3.认证，通过认证后才进行服务，<br/>注意：当事件发生时，SRS调用http地址告知api-server，<br/>若api-server需要主动控制SRS，可以通过cli</td>
</tr>
<tr>
<td>客户端</td>
<td>HLS</td>
<td>./configure \<br/>--without-ssl \<br/>--with-hls \<br/>--with-nginx \<br/>--without-http-callback \<br/>--without-ffmpeg \<br/>--without-transcode</td>
<td>SRS提供了以下客户端：<br/>1.播放器，research/players/srs_player<br/>research/players/srs_player.html<br/>2.编码器，research/players/srs_publisher<br/>research/players/srs_publisher.html<br/>3.测速：research/players/srs_bwt<br/>research/players/srs_bwt.html<br/>4.jwplayer：research/players/jwplayer6.html<br/>5.osmf播放器：research/players/osmf.html<br/>srs提供的客户端(srs-player/publisher)都是全js接口，<br/>flash元素只有video播放，<br/>典型场景：<br/>1.希望播放RTMP/HLS流<br/>2.希望使用flash推流<br/>3.希望测试客户端到服务器带宽<br/>注意：HLS提供的nginx，只是用做分发静态文件，<br/>可以把对应的目录拷贝到其他web服务器下也可以观看</td>
</tr>
<tr>
<td>测速</td>
<td>HLS</td>
<td>./configure \<br/>--without-ssl \<br/>--with-hls \<br/>--with-nginx \<br/>--without-http-callback \<br/>--without-ffmpeg \<br/>--without-transcode</td>
<td>SRS提供的测速工具，分为flash客户端和linux命令行工具，<br/>1.flash测速：research/players/srs_bwt<br/>research/players/srs_bwt.html<br/>flash测速提供全js接口，方便嵌入页面<br/>2.linux测速：./objs/bandwidth<br/>典型场景：<br/>1.推流前测速，看用户带宽是否达到要求<br/>2.排查卡顿问题，查看节点之间带宽<br/>注意：HLS提供的nginx，只是用做分发静态文件，<br/>可以把对应的目录拷贝到其他web服务器下也可以观看</td>
</tr>
<tr>
<td>小型集群</td>
<td>RTMP(Basic)</td>
<td>./configure \<br/>--without-ssl \<br/>--without-hls \<br/>--without-http-callback \<br/>--without-ffmpeg \<br/>--without-transcode</td>
<td>SRS的Forward可组建小型集群，参考<a href="https://github.com/winlinvip/simple-rtmp-server/wiki/Cluster">Cluster</a></td>
</tr>
<tr>
<td>ARM</td>
<td>ARM</td>
<td>./configure \<br/>--with-arm-ubuntu12</td>
<td>SRS在ARM上运行，参考<a href="https://github.com/winlinvip/simple-rtmp-server/wiki/SrsLinuxArm">arm-srs</a></td>
</tr>
<tr>
<td>srs-librtmp</td>
<td>librtmp</td>
<td>./configure \<br/>--with-librtmp</td>
<td>SRS提供客户端推流/播放库，参考<a href="https://github.com/winlinvip/simple-rtmp-server/wiki/SrsLibrtmp">srs-librtmp</a></td>
</tr>
</table>

## 自定义编译参数

SRS可以自定义编译器，譬如arm编译时使用arm-linux-g++而非g++。参考[ARM：手动编译](https://github.com/winlinvip/simple-rtmp-server/wiki/SrsLinuxArm#%E6%89%8B%E5%8A%A8%E7%BC%96%E8%AF%91srs)

注意：SRS和ST都可以通过编译前设置变量编译，但是ssl需要手动修改Makefile。还好ssl不用每次都编译。

## 编译的生成项目

configure和make将会生成一些项目，都在objs目录。有些文件在research目录，configure会自动软链到objs目录。

HttpCallback(及其服务端api-server)的目录为research/api-server，没有做软链，可以直接启动。详细参考下面的方法。

<table>
<tr>
<td><strong>生成项目</strong></td>
<td><strong>使用方法</strong></td>
<td><strong>说明</strong></td>
</tr>
<tr>
<td>./objs/srs</td>
<td>./objs/srs -c conf/srs.conf</td>
<td>启动SRS服务器</td>
</tr>
<tr>
<td>./objs/bandwidth</td>
<td>./objs/bandwidth -h</td>
<td>linux测速工具</td>
</tr>
<tr>
<td>./objs/nginx</td>
<td>sudo ./objs/nginx/sbin/nginx</td>
<td>HLS/DEMO用到的nginx服务器</td>
</tr>
<tr>
<td>api-server</td>
<td>python research/api-server/server.py 8085</td>
<td>启动HTTP hooks和DEMO视频会议用到的api-server</td>
</tr>
<tr>
<td>FFMPEG</td>
<td>./objs/ffmpeg/bin/ffmpeg</td>
<td>SRS转码用的FFMPEG，DEMO推流也是用它</td>
</tr>
<tr>
<td>librtmp</td>
<td>./objs/include/srs_librtmp.h<br/>
./objs/lib/srs_librtmp.a</td>
<td>SRS提供的客户端库，参考<a href="https://github.com/winlinvip/simple-rtmp-server/wiki/SrsLibrtmp">srs-librtmp</a></td>
</tr>
<tr>
<td>DEMO<br/>(关闭HttpCallback)</td>
<td>./objs/nginx/html/players</td>
<td>SRS的DEMO的静态页面，当没有开启HttpCallback时</td>
</tr>
<tr>
<td>DEMO<br/>(开启HttpCallback)</td>
<td>research/api-server/static-dir/players</td>
<td>SRS的DEMO的静态页面，<br/>和nginx里面的静态目录是一个目录，软链到research/players，<br/>1.当HttpCallback开启（--with-http-callback)，<br/>nginx的index.html会默认跳转到HttpCallback的首页，<br/>原因是视频会议的DEMO需要HttpCallback，<br/>2.若HttpCallback没有开启，<br/>则默认浏览的是Nginx里面的DEMO，<br/>当然视频会议会无法演示</td>
</tr>
</table>

## 配置参数说明

SRS的配置(configure)参数说明如下：
* --help 配置的帮助信息
* --with-ssl 添加ssl支持，ssl用来支持复杂握手。参考：[RTMP Handshake](https://github.com/winlinvip/simple-rtmp-server/wiki/RTMPHandshake)。
* --with-hls 支持HLS输出，将RTMP流切片成ts，可用于支持移动端HLS（IOS/Android），不过PC端jwplayer也支持HLS。参考：[HLS](https://github.com/winlinvip/simple-rtmp-server/wiki/DeliveryHLS)
* --with-nginx 编译nginx，使用nginx作为web服务器分发HLS文件，以及demo的静态页等。
* --with-http-callback 支持http回调接口，用于认证，统计，事件处理等。参考：[HTTP callback](https://github.com/winlinvip/simple-rtmp-server/wiki/HTTPCallback)
* --with-http-api 打开HTTP管理接口。参考：[HTTP API](https://github.com/winlinvip/simple-rtmp-server/wiki/HTTPApi)
* --with-http-server 打开内置HTTP服务器，支持分发HTTP流。参考：[HTTP Server](https://github.com/winlinvip/simple-rtmp-server/wiki/HTTPServer)
* --with-ffmpeg 编译转码/转封装/采集用的工具FFMPEG。参考：[FFMPEG](https://github.com/winlinvip/simple-rtmp-server/wiki/FFMPEG)
* --with-transcode 直播流转码功能。需要在配置中指定转码工具。
* --with-research 是否编译research目录的文件，research目录是一些调研，譬如ts info是做HLS时调研的ts标准。和SRS的功能没有关系，仅供参考。
* --with-utest 是否编译SRS的单元测试，默认开启，也可以关闭。
* --with-gperf 是否使用google的tcmalloc库，默认关闭。
* --with-gmc 是否使用gperf的内存检测，编译后启动srs会检测内存错误。这个选项会导致低性能，只应该在找内存泄漏时才开启。默认关闭。参考：[gperf](https://github.com/winlinvip/simple-rtmp-server/wiki/GPERF)
* --with-gmp 是否使用gperf的内存性能分析，编译后srs退出时会生成内存分析报告。这个选项会导致地性能，只应该在调优时开启。默认关闭。参考：[gperf](https://github.com/winlinvip/simple-rtmp-server/wiki/GPERF)
* --with-gcp 是否启用gperf的CPU性能分析，编译后srs退出时会生成CPU分析报告。这个选项会导致地性能，只应该在调优时开启。默认关闭。参考：[gperf](https://github.com/winlinvip/simple-rtmp-server/wiki/GPERF)
* --with-gprof 是否启用gprof性能分析，编译后srs会生成CPU分析报告。这个选项会导致地性能，只应该在调优时开启。默认关闭。参考：[gprof](https://github.com/winlinvip/simple-rtmp-server/wiki/GPROF)
* --with-librtmp 客户端推流/播放库，参考[srs-librtmp](https://github.com/winlinvip/simple-rtmp-server/wiki/SrsLibrtmp)
* --with-arm-ubuntu12 交叉编译ARM上运行的SRS，要求系统是Ubuntu12。参考[srs-arm](https://github.com/winlinvip/simple-rtmp-server/wiki/SrsLinuxArm)
* --jobs[=N] 开启的编译进程数，和make的-j（--jobs）一样，在configure时可能会编译nginx/ffmpeg等工具，可以开启多个jobs编译，可以显著加速。参考：[Build: jobs](https://github.com/winlinvip/simple-rtmp-server/wiki/Build#wiki-jobs%E5%8A%A0%E9%80%9F%E7%BC%96%E8%AF%91)
* --static 使用静态链接。指定arm编译时，会自动打开这个选项。手动编译需要用户自身打开。参考：[ARM](https://github.com/winlinvip/simple-rtmp-server/wiki/SrsLinuxArm)

Winlin 2014.2