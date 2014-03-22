# SRS系统服务

SRS提供`simple-rtmp-server/trunk/etc/init.d/simple-rtmp-server`脚本，可以作为CentOS或者Ubuntu的系统服务自动启动。
* 同一的启动停止方式，像sshd一样管理。
* 系统重启后会作为服务自动启动，不用手动启动。
* 提供简单的CLI管理（启动，停止，重启，reload等）。

## 直接启动

若不需要添加到系统服务，每次重启后需要手动启动SRS，可以直接在srs的trunk目录执行脚本：

```bash
cd /home/winlin/_git/simple-rtmp-server/trunk &&
./etc/init.d/simple-rtmp-server start
```

## LinuxService

SRS作为系统服务启动，需要以下几步：
* 修改脚本的根目录
* 链接`simple-rtmp-server/trunk/etc/init.d/simple-rtmp-server`到`/etc/init.d/simple-rtmp-server`
* 添加到系统服务，CentOS和Ubuntu方法不一样。

<strong>Step1:</strong> 修改脚本根目录

脚本的根目录默认在`simple-rtmp-server/trunk`，也就是若你直接执行命令`./etc/init.d/simple-rtmp-server`是可以启动的，脚本默认使用相对目录（无法知道绝对目录，需要用户指定）。

编辑脚本，修改为绝对目录，在任何地方都可以启动了：

```bash
ROOT="./"
APP="./objs/srs"
CONFIG="./conf/srs.conf"
DEFAULT_PID_FILE='./objs/srs.pid'
```

一般只需要修改ROOT，譬如：

```bash
ROOT="/home/winlin/_git/simple-rtmp-server/trunk"
APP="./objs/srs"
CONFIG="./conf/srs.conf"
DEFAULT_PID_FILE='./objs/srs.pid'
```

<strong>Step2:</strong> 链接脚本：

```bash
sudo ln -sf \
    /home/winlin/_git/simple-rtmp-server/trunk/etc/init.d/simple-rtmp-server \
    /etc/init.d/simple-rtmp-server
```

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
/etc/init.d/simple-rtmp-server status
```

启动SRS：

```bash
/etc/init.d/simple-rtmp-server start
```

停止SRS：

```bash
/etc/init.d/simple-rtmp-server stop
```

重启SRS：

```bash
/etc/init.d/simple-rtmp-server restart
```

Reload SRS：

```bash
/etc/init.d/simple-rtmp-server reload
```

Winlin 2014.3