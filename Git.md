# GIT使用和代码更新

如何选择SRS的稳定版本？如何更新代码？

## SRS稳定版本

目前还没有稳定版本，还在测试中。

## 如何获取SRS最新代码

你可以从github获取SRS的代码，需要先安装git（如何安装git可以百度下）。

安装好git后，执行以下命令获取SRS最新代码：

```bash
git clone https://github.com/winlinvip/simple-rtmp-server
```

## 如何更新SRS最新代码

SRS包含的软件很多，不需要额外下载其他的包就可以编译。所以第一次从github上下载后，不需要每次都git clone，用以下命令即可更新：

```bash
git pull
```

另外，不需要删除objs后编译srs，只需要make就可以编译。若make出错，则执行configure之后再make，可能有配置项更新。

## CSDN-Mirror

SRS在CSDN上有镜像，参考网址：https://code.csdn.net/winlinvip/srs-csdn

SRS会不定期将代码更新到CSDN，基本上是同步的。csdn的git仓库是：

```bash
git clone https://code.csdn.net/winlinvip/srs-csdn.git
```

可以在CSDN上建立自己的仓库，然后和github上的srs同步，可以运行脚本：

```bash
bash scripts/csdn.mirror.sh 
```

可以参考脚本中的提示，创建自己的分支，每次可执行该脚本和github的srs同步。

Winlin 2014.3