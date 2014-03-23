# SRS系统服务

SRS提供多种启动的方式，包括：
* 在git目录直接启动，简单直接，但系统重启后需要手动启动。
* 系统服务，init.d脚本：SRS提供`simple-rtmp-server/trunk/etc/init.d/srs`脚本，可以作为CentOS或者Ubuntu的系统服务自动启动。

## 直接启动

若不需要添加到系统服务，每次重启后需要手动启动SRS，可以直接在srs的trunk目录执行脚本：

```bash
cd /home/winlin/_git/simple-rtmp-server/trunk &&
./etc/init.d/srs start
```

## LinuxService

SRS作为系统服务启动，需要以下几步：
* 安装srs：安装脚本会自动修改init.d脚本，将`ROOT="./"`改为安装目录。
* 链接安装目录的`init.d/simple-rtmp-server`到`/etc/init.d/srs`
* 添加到系统服务，CentOS和Ubuntu方法不一样。

<strong>Step1:</strong> 安装SRS

编译SRS后，可执行命令安装SRS：

```bash
make && sudo make install
```

安装命令会将srs默认安装到`/usr/local/srs`中，可以在configure时指定其他目录，譬如```./configure --prefix=`pwd`/_release```可以安装到当前目录的_release目录（可以不用sudo安装，直接用`make install`即可安装。

<strong>Step2:</strong> 链接脚本：

```bash
sudo ln -sf \
    /usr/local/srs/etc/init.d/srs \
    /etc/init.d/srs
```

备注：若SRS安装到其他目录，将`/usr/local/srs`替换成其他目录。

备注：也可以使用其他的名称，譬如`/etc/init.d/simple-rtmp-server`，可以任意名称，启动时也用该名称。

<strong>Step3:</strong>添加服务：

```bash
#centos 6
sudo /sbin/chkconfig --add simple-rtmp-server
```

或者

```bash
#ubuntu12
sudo update-rc.d simple-rtmp-server defaults
```

## 使用init.d脚本管理SRS

查看SRS状态：

```bash
/etc/init.d/srs status
```

启动SRS：

```bash
/etc/init.d/srs start
```

停止SRS：

```bash
/etc/init.d/srs stop
```

重启SRS：

```bash
/etc/init.d/srs restart
```

Reload SRS：

```bash
/etc/init.d/srs reload
```

## 安装DEMO-API

SRS支持安装DEMO到`/usr/local/srs`目录，用户在configure时可以修改这个目录。

配置时打开demo支持：

```bash
./configure --with-hls --with-ffmpeg --with-http-callback --with-ffmpeg
```

安装命令：

```bash
make && sudo make install-demo
```

安装后，可以启动api：

```bash
/usr/local/srs/etc/init.d/srs-api start
```

即可以观看demo的页面。推流需要自己手动推流。若需要观看所有演示，直接用脚本启动，参考：[Usage: Demo](https://github.com/winlinvip/simple-rtmp-server/wiki/SampleDemo)

注意：安装demo-api适用于使用播放器的客户，使用推流编码器的客户，以及使用视频会议demo的客户。总之只会启动api-server，所以默认那些演示流是不会起来的。

注意：也可以直接在srs的git目录启动`./etc/init.d/simple-rtmp-servr-api start`，不必安装。

注意：也可以以系统服务方式启动api-server，参考前面srs以系统服务方式启动的例子。

软链脚本：

```bash
sudo ln -sf \
    /usr/local/srs/etc/init.d/srs-api \
    /etc/init.d/srs-api
```

加入服务：

```bash
#centos 6
sudo /sbin/chkconfig --add simple-rtmp-server-api
```

或者

```bash
#ubuntu12
sudo update-rc.d simple-rtmp-server-api defaults
```

管理SRS-api服务：

查看SRS-api状态：

```bash
/etc/init.d/srs-api status
```

启动SRS-api：

```bash
/etc/init.d/srs-api start
```

停止SRS-api：

```bash
/etc/init.d/srs-api stop
```

重启SRS-api：

```bash
/etc/init.d/srs-api restart
```

Winlin 2014.3