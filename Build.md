# 编译SRS

## SRS依赖关系

SRS依赖于g++/gcc/make，st-1.9，http-parser2.1，ffmpeg，cherrypy，nginx，openssl-devel。

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
<td>RTMP服务器，st为处理并发的基础库<br/>forward,vhost,refer,reload为基础功能。</td>
</tr>
<tr>
<td>RTMP<br/>(H.264/AAC)</td>
<td>可选</td>
<td>--with-ssl<br/>--without-ssl</td>
<td>openssl-devel</td>
<td>RTMP分发H.264/AAC，需要支持<a href="http://blog.csdn.net/win_lin/article/details/13006803">复杂握手</a><br/>即简单握手的内容为1537字节随机数，<br/>而复杂握手为按一定规则加密的数据</td>
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
<td>将RTMP流转码后输出RTMP流，<br/>FFMPEG依赖的项目实在太多，<br/>而且在老版本的linux上这些库很难编译成功，<br/>因此若不需要转码功能，建议关闭此功能，<br/>若需要转码，推荐使用CentOS6.*系统</td>
</tr>
<tr>
<td>ApiServer</td>
<td>可选</td>
<td>--with-http<br/>--without-http</td>
<td>cherrypy</td>
<td>当某些事件发生，SRS可以调用http地址，<br/>譬如on_connect，为客户端连接到服务器时，<br/>SRS自带了一个research/api-server，<br/>提供了这些http api的默认实现，<br/>使用Cherrypy。另外，若开启了ApiServer，<br/>players的演示默认会跳转到api-server</td>
</tr>
<tr>
<td>DEMO</td>
<td>可选</td>
<td>--with-hls<br/>--without-hls</td>
<td>nginx/cherrypy</td>
<td>SRS的演示播放器/转码输出的流/编码器/视频会议，<br/>因为需要http服务器，所以依赖于nginx，<br/>另外，视频会议因为需要知道大家发布的流名称，<br/>所以需要ApiServer支持</td>
</tr>
</table>

## 常见需求

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
</table>