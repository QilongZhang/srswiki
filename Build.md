# 编译SRS

## 操作系统

* README中的Usage，在<strong>Centos6.x</strong>下面测试成功。按照Step操作后，浏览器中打开服务器地址就能观看所有的DEMO。
* DEMO演示了所有SRS的功能，特别是ffmpeg依赖的库巨多，因此为了简化，推荐使用<strong>Centos6.x</strong>.
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
2. 把SELINUX的值改为disabled：

```bash
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=disabled
```
3. 重启系统：`sudo init 6`

## SRS依赖关系

SRS依赖于g++/gcc/make，st-1.9，http-parser2.1，ffmpeg，cherrypy，nginx，openssl-devel，python2。

某些依赖可以通过configure配置脚本关闭，详见下表：

<table>
<tr>
<td><strong>功能</strong></td>
<td><strong>选项</strong></td>
<td><strong>编译开关</strong></td>
<td><strong>依赖库</strong></td>
<td><strong>说明</strong></td>
</tr>
<tr>
<td>编译器</td>
<td><strong>必选</strong></td>
<td>无</td>
<td>linux,g++,gcc,make</td>
<td>基础编译环境</td>
</tr>
<tr>
<td>RTMP(Basic)</td>
<td><strong>必选</strong></td>
<td>无</td>
<td>st-1.9</td>
<td>RTMP服务器，st为处理并发的基础库<br/>forward,vhost,refer,reload为基础功能。<br/><br/>st-1.9没有再依赖其他库，在各种linux下都可以编译，<br/>测试过的有CentOS 4/5/6，其他问题也不大</td>
</tr>
<tr>
<td>RTMP<br/>(H.264/AAC)</td>
<td>可选</td>
<td>--with-ssl<br/>--without-ssl</td>
<td>openssl-devel</td>
<td>RTMP分发H.264/AAC，需要支持<a href="http://blog.csdn.net/win_lin/article/details/13006803">复杂握手</a><br/><br/>简单握手的内容为1537字节随机数，<br/>而复杂握手为按一定规则加密的数据</td>
</tr>
<tr>
<td>HLS</td>
<td>可选</td>
<td>--with-hls<br/>--without-hls</td>
<td>nginx</td>
<td>将RTMP流切片成ts，并生成m3u8，<br/>即AppleHLS流分发，打开此功能后会编译<a href="http://nginx.org/">nginx</a>，<br/>通过nginx分发m3u8和ts静态文件</td>
</tr>
<tr>
<td>Transcode</td>
<td>可选</td>
<td>--with-ffmpeg<br/>--without-ffmpeg</td>
<td>ffmpeg<br/>(libaacplus,<br/>lame,yasm,<br/>x264,ffmpeg)</td>
<td>将RTMP流转码后输出RTMP流，<br/>FFMPEG依赖的项目实在太多，<br/>而且在老版本的linux上这些库很难编译成功，<br/><br/>因此若不需要转码功能，建议关闭此功能，<br/>若需要转码，推荐使用CentOS6.*系统</td>
</tr>
<tr>
<td>ApiServer</td>
<td>可选</td>
<td>--with-http<br/>--without-http</td>
<td>cherrypy<br/>http-parser2.1<br/>python2</td>
<td>当某些事件发生，SRS可以调用http地址<br/><br/>譬如客户端连接到服务器时，SRS会调用on_connect接口，<br/>SRS自带了一个research/api-server(使用Cherrypy)，<br/>提供了这些http api的默认实现。<br/><br/>另外，若开启了ApiServer，<br/>players的演示默认会跳转到api-server<br/><br/>http-parser2.1在各种linux下编译问题也不大<br/><br/>python2.6/2.7在CentOS6下才有，<br/>所以CentOS5启动ApiServer会报json模块找不到</td>
</tr>
<tr>
<td>DEMO</td>
<td>可选</td>
<td>--with-hls<br/>--without-hls</td>
<td>nginx/cherrypy</td>
<td>SRS的演示播放器/转码输出的流/编码器/视频会议，<br/>因为需要http服务器，所以依赖于nginx，<br/><br/>另外，视频会议因为需要知道大家发布的流名称，<br/>所以需要ApiServer支持</td>
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
<td>./configure \<br/>--with-ssl \<br/>--without-hls \<br/>--without-http \<br/>--without-ffmpeg</td>
<td>只有基本的RTMP功能，作为RTMP源站提供服务。<br/>包含Forward/Reload/Refer/Vhost等核心功能。<br/>没有HLS，也没有转码，没有ApiServer。<br/>典型场景：<br/>1.RTMP网络电视台<br/>2.美女主播<br/>3.视频会议<br/>4.低延时的交互类应用<br/>5.其他RTMP应用</td>
</tr>
<tr>
<td>快速预览<br/>最小依赖</td>
<td>RTMP(Basic)</td>
<td>./configure \<br/>--without-ssl \<br/>--without-hls \<br/>--without-http \<br/>--without-ffmpeg</td>
<td>只保留系统核心功能，连RTMP分发h.264/aac都去掉。<br/>可以编译速度最快，几乎在所有的linux都能编译成功<br/>包含RTMP(Basic)基本流分发功能，<br/>包含Forward/Reload/Refer/Vhost核心功能<br/>典型场景：<br/>1.想快速编译SRS<br/>2.想在很老的系统下编译SRS<br/>3.VP6推RTMP流就可以</td>
</tr>
<tr>
<td>多屏分发</td>
<td>RTMP(Basic)<br/>RTMP(H.264/AAC)<br/>HLS</td>
<td>./configure \<br/>--with-ssl \<br/>--with-hls \<br/>--without-http \<br/>--without-ffmpeg</td>
<td>希望支持PC(RTMP)，Apple(HLS)和Android(HLS)观看，<br/>PC上自然是adobe的flash观看效果最佳，<br/>1. flash自然是播放RTMP最稳定，<br/>测试显示10天连续播放都没有问题，<br/>2. Apple平台自然是HLS，<br/>就是看到HLS在Apple上完美表现，<br/>SRS才决定支持HLS，<br/>3. Android上的流媒体没有稳定的分发方式，<br/>相对而言，HLS是较好的选择，<br/>Andorid上播放器用HTML5播放m3u8<br/>典型场景：<br/>1.多屏分发的广播流<br/>2.对延时不那么关心（HLS延时至少一个ts切片）<br/>3.需要支持移动端<br/>注意：HLS需要h264和AAC编码，若编码器不支持，则需要转码</td>
</tr>
<tr>
<td>转码</td>
<td>RTMP(Basic)<br/>RTMP(H.264/AAC)<br/>Transcode</td>
<td>./configure \<br/>--with-ssl \<br/>--without-hls \<br/>--without-http \<br/>--with-ffmpeg</td>
<td>希望对RTMP进行转码后输出，<br/>譬如，flash推流到SRS，编码是vp6和speex，<br/>希望转码为h264和aac后输出HLS，<br/>譬如，编码器推送较高码率到SRS，转码输出较低码率，<br/>譬如，加水印后输出，<br/>譬如，只对音频进行转码，将speex/mp3转码为aac给手机端播放，<br/>转码是wowza里面很贵的一个插件，应用场景可见一斑<br/>典型场景：<br/>1.需要输出HLS，但是输入流不是h264/aac<br/>2.高码率输入，多路输出，手机端播放低码率的流<br/>3.各种FFMPEG滤镜的应用<br/>注意：所有转码的流可以再经过SRS进行HLS切片和forward</td>
</tr>
<tr>
<td>逻辑控制</td>
<td>RTMP(Basic)<br/>ApiServer</td>
<td>./configure \<br/>--without-ssl \<br/>--without-hls \<br/>--with-http \<br/>--without-ffmpeg</td>
<td>希望对服务器上的各种事件进行控制，<br/>譬如，连接到SRS后，到ApiServer进行验证，<br/>通过后再进行服务，<br/>譬如，希望统计当前连接数，各个流的数据等，<br/>典型场景：<br/>1.视频会议，ApiServer可以知道SRS上的流<br/>2.统计，统计在线人数，带宽等（cli也可以查询）<br/>3.认证，通过认证后才进行服务，<br/>注意：当事件发生时，SRS调用http地址告知ApiServer，<br/>若ApiServer需要主动控制SRS，可以通过cli</td>
</tr>
<tr>
<td>客户端</td>
<td>HLS</td>
<td>./configure \<br/>--without-ssl \<br/>--with-hls \<br/>--without-http \<br/>--without-ffmpeg</td>
<td>SRS提供了以下客户端：<br/>1.播放器，research/players/srs_player<br/>research/players/srs_player.html<br/>2.编码器，research/players/srs_publisher<br/>research/players/srs_publisher.html<br/>3.测速：research/players/srs_bwt<br/>research/players/srs_bwt.html<br/>4.jwplayer：research/players/jwplayer6.html<br/>5.osmf播放器：research/players/osmf.html<br/>srs提供的客户端(srs-player/publisher)都是全js接口，<br/>flash元素只有video播放，<br/>典型场景：<br/>1.希望播放RTMP/HLS流<br/>2.希望使用flash推流<br/>3.希望测试客户端到服务器带宽<br/>注意：HLS提供的nginx，只是用做分发静态文件，<br/>可以把对应的目录拷贝到其他web服务器下也可以观看</td>
</tr>
<tr>
<td>测速</td>
<td>HLS</td>
<td>./configure \<br/>--without-ssl \<br/>--with-hls \<br/>--without-http \<br/>--without-ffmpeg</td>
<td>SRS提供的测速工具，分为flash客户端和linux命令行工具，<br/>1.flash测速：research/players/srs_bwt<br/>research/players/srs_bwt.html<br/>flash测速提供全js接口，方便嵌入页面<br/>2.linux测速：./objs/bandwidth<br/>典型场景：<br/>1.推流前测速，看用户带宽是否达到要求<br/>2.排查卡顿问题，查看节点之间带宽<br/>注意：HLS提供的nginx，只是用做分发静态文件，<br/>可以把对应的目录拷贝到其他web服务器下也可以观看</td>
</tr>
<tr>
<td>小型集群</td>
<td>RTMP(Basic)</td>
<td>./configure \<br/>--without-ssl \<br/>--without-hls \<br/>--without-http \<br/>--without-ffmpeg</td>
<td>SRS的Forward可组建小型集群，参考<a href="https://github.com/winlinvip/simple-rtmp-server/wiki/Cluster">Cluster</a></td>
</tr>
</table>

## 自定义编译参数

SRS可以自定义编译器，譬如arm编译时使用arm-linux-g++而非g++，编译方法是：

```bash
export CXX=arm-linux-g++ && ./configure --with-ssl --without-hls --without-http --without-ffmpeg && make
```

可以定义的其他编译变量是：
* CXXFLAGS: c++编译器参数。默认：-ansi -Wall -g -O0
* CXX: c++编译器。默认：g++
* LINK：链接器。默认和CXX一样。
* AR：库生成器。默认：ar

## 编译和启动

确定用什么编译选项后，编译SRS其实很简单。譬如，demo使用的选项：

```
./configure --with-ssl --with-hls --with-http --with-ffmpeg &&
make
```

在configure时，会根据选择的功能编译需要的库和工具。configure完成后，make就可以编译SRS。

编译成功后，启动SRS/nginx/ApiServer，启动推流的实例（可以查看[README](https://github.com/winlinvip/simple-rtmp-server)的[Usage](https://github.com/winlinvip/simple-rtmp-server#usagesimple)）。譬如：

```bash
echo "启动HLS/DEMO要用到的web服务器"
sudo ./objs/nginx/sbin/nginx
echo "启动DEMO(视频会议)和HttpHooks要用到的Api服务器" 
nohup python research/api-server/server.py 8085 >/dev/null 2>&1 &
echo "启动SRS服务器，默认配置文件" 
sudo ./objs/srs -c conf/srs.conf >objs/logs/srs.log 2>&1 &
echo "推一路流到SRS(live?vhost=demo.srs.com/livestream)，DEMO中的1进12出的演示" 
bash scripts/_step.start.ffmpeg.demo.sh 
echo "推一路流到SRS(live?vhost=players/livestream)，DEMO中的播放器播放的流" 
bash scripts/_step.start.ffmpeg.players.sh
```

注意：scripts/run.sh其实就是做的上面的几步，这些脚本就是把[Usage(detail)](https://github.com/winlinvip/simple-rtmp-server#usagedetail)中的命令写到脚本中了而已。

假设服务器的ip是：192.168.2.101

DEMO地址为：[http://192.168.2.101](http://192.168.2.101)

呃，浏览器，当然是Chrome/Firefox/Safari/Opera效果都很好，主要是bootstrap里面的css3和jquery支持得比较好。其实IE10以上虽然丑但是还可以，其他的IE内核的“鹌鹑”浏览器之类的，真的是没有办法，很丑。

OK，结论就是：用Chrome浏览 [http://192.168.2.101](http://192.168.2.101)

## 编译的生成项目

configure和make将会生成一些项目，都在objs目录。有些文件在research目录，configure会自动软链到objs目录。

ApiServer的目录为research/api-server，没有做软链，可以直接启动。详细参考下面的方法。

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
<td>ApiServer</td>
<td>python research/api-server/server.py 8085</td>
<td>启动HTTP hooks和DEMO视频会议用到的ApiServer</td>
</tr>
<tr>
<td>FFMPEG</td>
<td>./objs/ffmpeg/bin/ffmpeg</td>
<td>SRS转码用的FFMPEG，DEMO推流也是用它</td>
</tr>
<tr>
<td>DEMO<br/>(关闭ApiServer)</td>
<td>./objs/nginx/html/players</td>
<td>SRS的DEMO的静态页面，当没有开启ApiServer时</td>
</tr>
<tr>
<td>DEMO<br/>(开启ApiServer)</td>
<td>research/api-server/static-dir/players</td>
<td>SRS的DEMO的静态页面，<br/>和nginx里面的静态目录是一个目录，软链到research/players，<br/>1.当ApiServer开启（--with-http)，<br/>nginx的index.html会默认跳转到ApiServer的首页，<br/>原因是视频会议的DEMO需要ApiServer，<br/>2.若ApiServer没有开启，<br/>则默认浏览的是Nginx里面的DEMO，<br/>当然视频会议会无法演示</td>
</tr>
</table>