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

Winlin 2014.3