# 如何提问

为了减少沟通成本，帮助大家直接解决问题，提问前请阅读这个wiki，帮助大家提出更好的问题，更快速高效的解决问题。

希望把80%的时间花在解决问题上，而不是一问一答的Q&A上，真的很浪费时间。如果我们在浪费别人的时间，别人如何肯花时间帮你解决问题？与人方便，自己方便。

如果你是开发者，准备看SRS代码，准备改点什么，那么下面的“开发者须知”就是你要详细看的。

如果你是用户，只是运行SRS，或者发现bug需要报告bug，那么查看“用户须知”就好了。

## 社区守则

一些基本的守则：
* 不要单独问我问题，在群里问。原因很简单：其一，群里人众多，如果都单独问我，我就要死了。其二，大多数问题都是重复的，群里问搞不好别人也知道。其三，我希望SRS形成社区，社区能互相帮助。当然，如果有特殊情况可以例外。
* 不要问开放性问题，问封闭性问题。这个是所有提问的原则，譬如，不要问SRS好不好？RTMP是什么？要问具体的问题：RTMP的extended timestamp，在c3的头中会发吗？
* 问问题前过一遍wiki，基本上你的问题都在wiki中有答案，难道一定要别人帮助你找wiki链接么？

## 开发者须知

SRS群和邮件列表，不是老师的黑板和学生举手的问题，80%的问题注定得不到答案，因为80%的问题都是“看代码”。不要显示自己的幼稚和懒惰，能自己搞定的问题，为何要别人代劳？

* 不要问抽象的问题，譬如SRS如何实现RTMP？如何出HLS流？如何处理并发？如何线程同步？
* 问非常具体的问题，譬如不要问ts时间戳如何处理，而是问：代码第xxx行，计算pts=dts+cts，cts是否是rtmp包的时间戳？当然这个问题调试下就能明白。
* 不要泛泛发问，看完README，看完WIKI，自己调试代码，然后发问。开发者只允许问具体的问题。

## 用户须知

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

    提交bug，或者问问题时，说明以下情况：
    * 系统：什么操作系统？32位还是64位？编译器版本多少？
    * 编码器：用什么编码器？版本是什么？编码参数是什么？流地址是什么？
    * 服务器：用SRS什么版本？配置是什么？日志是什么？
    * 客户端：用什么客户端？版本是什么？
    * 问题和重现步骤：问题是什么？重现步骤是什么？

这个问题就很快能得到排查，开发人员能按照重现步骤进行复现。

QQ群守则：

```
@新人 群守则：
1. 有问题群里问，不私下问我问题，道理很简单。
2. 多读wiki少问重复问题，80%的答案都是参考xxx wiki。
3. 人太多了太吵，我会定期清理不说话又不认识的人。如果说话的次数跟不上我提交代码的次数，那说明很懒；如果说话的次数跟不上我release版本的次数，那是真的极其懒惰；如果从来都不说话，那我怎么知道死没死。有人管清人叫做“威权主义”，我觉得挺好，至少是主义，哈哈。
```

Winlin 2014.1