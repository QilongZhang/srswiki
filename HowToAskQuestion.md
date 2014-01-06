# 如何提问

为了减少沟通成本，帮助大家直接解决问题，提问前请阅读这个wiki，帮助大家提出更好的问题，更快速高效的解决问题。而不是挤牙膏一样的问“请问你的启动SRS命令是什么？”“请问你的SRS配置文件是什么？”“请问你的SRS日志是什么？”

希望把80%的时间花在解决问题上，而不是一问一答的Q&A上，真的很浪费时间。如果我们在浪费别人的时间，别人如何肯花时间帮你解决问题？与人方便，自己方便。

# 提问前

提问前需要做什么？确保别人已经碰到过类似的问题，或者wiki中已经说明了，这种问题就不要提了。

下面是一些基本的问题：

* 如何编译：参考[Build](https://github.com/winlinvip/simple-rtmp-server/wiki/Build)
* SRS需要什么硬件环境：参考[Build](https://github.com/winlinvip/simple-rtmp-server/wiki/Build)
* SRS需要什么软件环境：参考[Build](https://github.com/winlinvip/simple-rtmp-server/wiki/Build)
* 为何看不到流？可能是防火墙问题，参考[Build](https://github.com/winlinvip/simple-rtmp-server/wiki/Build)
* 如何搭建集群：参考[Cluster](https://github.com/winlinvip/simple-rtmp-server/wiki/Cluster)
* 如何测SRS性能：参考[Performance](https://github.com/winlinvip/simple-rtmp-server/wiki/Performance)
* SRS的授权是MIT？参考[License](https://github.com/winlinvip/simple-rtmp-server/blob/master/LICENSE)
* 如何看SRS的DEMO？参考[Readme](https://github.com/winlinvip/simple-rtmp-server#usagesimple)
* 如何一步一步编译SRS的DEMO？参考[Readme](https://github.com/winlinvip/simple-rtmp-server#usagedetail)
* SRS的主要作者是谁？参考[Readme](https://github.com/winlinvip/simple-rtmp-server#authors)
* SRS的架构是什么？参考[Readme](https://github.com/winlinvip/simple-rtmp-server#architecture)
* SRS的功能有哪些，哪些是开发中的？参考[Readme](https://github.com/winlinvip/simple-rtmp-server#summary)
* SRS发布的版本有哪些？参考[Readme](https://github.com/winlinvip/simple-rtmp-server#releases)
* SRS和Nginx-Rtmp/CRtmpServer/Red5/Wowza/FMS/Helix相比，优势在哪里？参考[Readme](https://github.com/winlinvip/simple-rtmp-server#compare)
* SRS开发人员每天都在做些什么？参考[Reaame](https://github.com/winlinvip/simple-rtmp-server#history)

如果上面都不是你要提的问题，查看[Wiki](https://github.com/winlinvip/simple-rtmp-server/wiki)，若Wiki都翻遍了，还是没有，那就参考下面的提问要求提问吧。

## 提问范例

提问时，需要收集以下重要信息：
* 问题描述：先描述问题。
* 运行环境：操作系统（位数，版本），服务器多少台，服务器IP等信息
* 网络架构：编码器如何推流到SRS，SRS如何分发到播放器。
* SRS的版本：是master分支最新代码，还是某个版本。执行命令获取SRS的版本：`./objs/srs -v`
* 编码器推流方式：不要说用ffmpeg推流，要说明具体的方式。
* SRS的配置文件：请不要说我是参考的哪个wiki，因为wiki上的大家也记不住，直接把配置文件内容粘贴出来。
* SRS的启动脚本：请不要参考的README的启动方式，给出具体的启动方式。
* 客户端播放的方式：不要说客户端播放不了，应该说明详细的播放方式，以及日志。
* SRS服务器日志：把SRS服务器日志发出来，可以和配置一起打个包。

举个实际的例子：

    大家好，我翻遍了wiki，仔细阅读了Readme和所有的Wiki，都找不到原因和解决办法，不得不麻烦大家帮忙看看。
    * 问题描述：VLC可以观看1935，但是看不了1936端口的流。
    * 运行环境：CentOS 6.0 64bits，服务器192.168.1.170
    * 网络架构：FFMPEG推流到SRS(1935端口），SRS(1935)转发给SRS(1936)，使用VLC观看。
    * SRS的版本：master分支最新代码
    * 编码器推流方式：使用FFMPEG推流，命令如下
    ```
    ./objs/ffmpeg/bin/ffmpeg -re -i ./doc/source.200kbps.768x320.flv \
        -vcodec copy -acodec copy \
        -f flv -y rtmp://127.0.0.1/live/livestream;
    ```
    * SRS(1935)的配置文件：
    ```
    [winlin@dev6 trunk]$ cat 1935.conf 
    listen              1935;
    vhost __defaultVhost__ {
        enabled         on;
        gop_cache       on;
        forward         127.0.0.1:1936;
    }
    ```
    * SRS(1935)的启动脚本：`nohup ./objs/srs -c 1935.conf >t.1935.log 2>&1 &`
    * SRS(1936)的配置文件：
    ```
    [winlin@dev6 trunk]$ cat 1936.conf 
    listen              1936;
    vhost __defaultVhost__ {
        enabled         on;
        gop_cache       on;
    }
    ```
    * SRS(1936)的启动脚本：`nohup ./objs/srs -c 1936.conf >t.1936.log 2>&1 &`
    * 客户端播放的方式：
    使用vlc播放流成功 rtmp://192.168.1.170/live/livestream
    使用vlc播放流失败 rtmp://192.168.1.170:1936/live/livestream
    * SRS服务器(侦听1935)日志：
    ```
    [winlin@dev6 trunk]$ cat t.1935.log
    [2014-01-06 19:33:17.054][0][error][read_token] end of file. ret=409 errno=2(No such file or directory)
    [2014-01-06 19:33:17.071][1][trace][listen] server started, listen at port=1935, fd=4
    [2014-01-06 19:33:17.071][2][trace][thread_cycle] thread cycle start
    [2014-01-06 19:36:27.691][3][trace][do_cycle] get peer ip success. ip=127.0.0.1, send_to=30000000, recv_to=30000000
    [2014-01-06 19:36:27.691][3][trace][handshake_with_client] srand initialized the random.
    [2014-01-06 19:36:27.693][3][trace][handshake_with_client] complex handshake success.
    ```
    * SRS服务器(侦听1935)日志：
    ```
    [winlin@dev6 trunk]$ cat t.1936.log
    2014-01-06 19:42:44.060][0][error][read_token] end of file. ret=409 errno=2(No such file or directory)
    [2014-01-06 19:42:44.061][1][trace][listen] server started, listen at port=1936, fd=4
    [2014-01-06 19:42:44.061][2][trace][thread_cycle] thread cycle start
    [2014-01-06 19:42:46.797][3][trace][do_cycle] get peer ip success. ip=127.0.0.1, send_to=30000000, recv_to=30000000
    [2014-01-06 19:42:46.797][3][trace][handshake_with_client] srand initialized the random.
    [2014-01-06 19:42:46.798][3][trace][handshake_with_client] simple handshake success.
    ```
    拜托，谢谢～

这个问题就很快能得到排查，开发人员能按照配置进行复现。