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
<td>RTMP服务器</td>
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