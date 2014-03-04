# RTMP握手协议

rtmp 1.0规范中，指定了RTMP的握手协议：
* c0/s0：一个字节，说明是明文还是加密。
* c1/s1: 1536字节，4字节时间，4字节0x00，1528字节随机数
* c2/s2: 1536字节，4字节时间1，4字节时间2，1528随机数和s1相同。
这个就是srs以及其他开源软件所谓的simple handshake，简单握手，标准握手，FMLE也是使用这个握手协议。

Flash播放器连接服务器时，若服务器只支持简单握手，则无法播放h264和aac的流，可能是adobe的限制。adobe将简单握手改为了有一系列加密算法的复杂握手（complex handshake） ，具体参考[变更的RTMP握手](http://blog.csdn.net/win_lin/article/details/13006803)

下表为总结：

<table>
<tr>
<th>握手方式</th>
<th>依赖库</th>
<th>Flash播放<br/>支持的编码</th>
<th>常见客户端</th>
<th>SRS支持方式</th>
<th>用途</th>
</tr>
<tr>
<td>Simple<br/>标准握手<br/>简单握手</td>
<td>不依赖</td>
<td>vp6+mp3/speex</td>
<td>所有客户端</td>
<td>支持</td>
<td>编码器，譬如FMLE，FFMPEG<br/>srs-librtmp（两种都支持，推荐用Simple）</td>
</tr>
<tr>
<td>Complex<br/>复杂握手</td>
<td>openssl</td>
<td>vp6+mp3/speex<br/>h264+aac</td>
<td>Flash播放器</td>
<td>支持</td>
<td>主要是Flash播放器播放H264+aac流时需要，<br/>其他都不需要</td>
</tr>
</table>

Winlin