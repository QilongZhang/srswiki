#FlashP2P

SRS能够支持FlashP2P系统，但是不是直接支持的。总所周知，FlashP2P是另外一套庞大的系统，重点是rtmfp服务器，p2p控制器，客户端播放器，流媒体服务器。
* rtmfp服务器：提供rtmfp协议，客户端通过rtmfp协议互联。
* p2p控制器：提供p2p发现和分享机制
* 客户端播放器：支持p2p的传输，流的播放。
* 流媒体服务器：接入其他协议，譬如SRS接入RTMP，按照FlashP2P的要求输出。

SRS主要的角色是将RTMP流录制为flv文件或者其他文件，然后告知P2P系统。剩下的事情就是P2P做的了。

SRS首页提供了实现了FlashP2P的架构和说明。

注意：FlashP2P系统为[chnvideo.com](http://www.chnvideo.com)商业方案，SRS只是支持对接。

Winlin 2014.4