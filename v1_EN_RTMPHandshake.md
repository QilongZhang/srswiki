# RTMP Handshake

The rtmp specification 1.0 defines the RTMP handshake:
* c0/s0: 1 bytes, specifies the protocol is RTMP or RTMPE/RTMPS.
* c1/s1: 1536 bytes, first 4 bytes is time, next 4 bytes is 0x00, 1528 random bytes.
* c2/s2: 1536 bytes, first 4 bytes is time echo, next 4 bytes is time, 1528 bytes c2==s1 and s2==c1.
This is the simple handshake, the standard handshake, and the FMLE use this handshake.

While the server connected by flash player only support simple handshake, the flash player can only play the vp6 codec, and do not support h.264+aac. Adobe changed the simple handshake to encrypted complex handshake, see: [Changed Handshake of RTMP](http://blog.csdn.net/win_lin/article/details/13006803)

The handshake summary:

<table>
<tr>
<th>Handshake</th>
<th>Depends</th>
<th>Flash player<br/>codec</th>
<th>Client</th>
<th>SRS</th>
<th>Use Scenario</th>
</tr>
<tr>
<td>Simple<br/>Standard</td>
<td>No</td>
<td>vp6+mp3/speex</td>
<td>All</td>
<td>Supprted</td>
<td>Encoder, for examle, FMLE, FFMPEG</td>
</tr>
<tr>
<td>Complex</td>
<td>openssl</td>
<td>vp6+mp3/speex<br/>h264+aac</td>
<td>Flash Player</td>
<td>Supported</td>
<td>Flash player requires complex handshake to play h.264+aac codec.</td>
</tr>
</table>

Notes: When compile SRS with SSL, SRS will try complex, then simple.

Winlin 2014.10
