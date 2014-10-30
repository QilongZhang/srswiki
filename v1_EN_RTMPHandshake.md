# RTMP Handshake

The rtmp specification 1.0 defines the RTMP handshake:
* c0/s0: 1 bytes, specifies the protocol is RTMP or RTMPE/RTMPS.
* c1/s1: 1536 bytes, first 4 bytes is time, next 4 bytes is 0x00, 1528 random bytes.
* c2/s2: 1536 bytes, first 4 bytes is time echo, next 4 bytes is time, 1528 bytes c2==s1 and s2==c1.
This is the simple handshake, the standard handshake, and the FMLE use this handshake.

While the server connected by flash player only support simple handshake, the flash player can only play the vp6 codec, and do not support h.264+aac. Adobe changed the simple handshake to encrypted complex handshake, see: [Changed Handshake of RTMP](http://blog.csdn.net/win_lin/article/details/13006803)

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

备注：SRS编译时若打开了SSL选项（--with-ssl），SRS会先使用复杂握手和客户端握手，若复杂握手失败，则尝试简单握手。

Winlin 2014.10