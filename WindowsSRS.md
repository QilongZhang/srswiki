#Windows下的SRS

SRS定位为Simple，而Simple的最根本原因是Arch的Simple。而Arch的Simple依赖于简化支持的逻辑，譬如OS。基于这个最根本精神，我本人不会维护非linux分支。即：
* linux x86/64：普通linux分支，我会维护，并加入各种必要的特性，譬如RTMP、HLS、转发、转码、采集、录制、API、HTTP调用等等。当然也包括srs-librtmp。
* linux arm：嵌入式分支，我也会维护，保持最基本的RTMP、HLS、API和HTTP调用等。当然也包括srs-librtmp。
* windows srs-librtmp：windows平台的客户端库，这个分支我会参与，因为srslibrtmp用到的是基本的c++函数，可以适用于所有的系统。在windows下支持这个特性还是有必要的。我只是参与，维护者由windows下的牛人维护，因此新开分支：[https://github.com/winlinvip/srs.librtmp.win](https://github.com/winlinvip/srs.librtmp.win)。
* windows srs：windows平台的服务器，这个我完全不参与，只是建议和linux分支保持一致。维护者由windows下的牛人维护，新开分支：[https://github.com/winlinvip/srs.win](https://github.com/winlinvip/srs.win)

Winlin 2014.5