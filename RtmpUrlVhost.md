# RTMP的URL规则和Vhost规则

RTMP的url其实很简单，vhost其实也没有什么新的概念，但是对于没有使用过的同学来讲，还是很容易混淆。几乎每个新人都必问的问题：RTMP那个URL推流时应该填什么，什么是vhost，什么是app？

## 标准RTMP URL

标准RTMP URL指的是最大兼容的RTMP URL，基本上所有的服务器和播放器都能识别的URL，和HTTP URL其实很相似，例如：

<table>
<tr>
<td><strong>HTTP</strong></td>
<td><strong>Schema</strong></td>
<td><strong>Host</strong></td>
<td><strong>Port</strong></td>
<td colspan=2><strong>Path</strong></td>
</tr>
<tr>
<td>http://42.121.5.85:80/players/srs_player.html</td>
<td>http</td>
<td>42.121.5.85</td>
<td>80</td>
<td colspan=2>/players/srs_player.html</td>
</tr>
<tr>
<td>rtmp://42.121.5.85:1935/live/livestream</td>
<td>rtmp</td>
<td>42.121.5.85</td>
<td>1935</td>
<td>live</td>
<td>livestream</td>
</tr>
<tr>
<td><strong>RTMP</strong></td>
<td><strong>Schema</strong></td>
<td><strong>Host</strong></td>
<td><strong>Port</strong></td>
<td><strong>App</strong></td>
<td><strong>Stream</strong></td>
</tr>
</table>
