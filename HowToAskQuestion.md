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
* 运行环境：操作系统（位数，版本）
* SRS的版本：是master分支最新代码，还是某个版本。执行命令获取SRS的版本：`./objs/srs -v`
* SRS的配置文件：请不要说我是参考的哪个wiki，因为wiki上的大家也记不住，直接把配置文件内容粘贴出来。
* SRS服务器日志：把SRS服务器日志发出来，可以和配置一起打个包。
* 其他脚本：譬如启动推流的脚本，播放流的脚本。

举个实际的例子：

