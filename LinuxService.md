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
* 安装srs：安装脚本会自动修改init.d脚本
* 链接安装目录的`init.d/simple-rtmp-server`到`/etc/init.d/simple-rtmp-server`
* 添加到系统服务，CentOS和Ubuntu方法不一样。

<strong>Step1:</strong> 安装SRS

编译SRS后，可执行命令安装SRS：

```bash
sudo make install
```

安装命令会将srs默认安装到`/usr/local/srs`中，可以在configure时指定其他目录，譬如```./configure --prefix=`pwd`/_release```可以安装到当前目录的_release目录（可以不用sudo安装，直接用`make install`即可安装。

<strong>Step2:</strong> 链接脚本：

```bash
sudo ln -sf \
    /usr/local/srs/etc/init.d/simple-rtmp-server \
    /etc/init.d/simple-rtmp-server
```

备注：若SRS安装到其他目录，将`/usr/local/srs`替换成其他目录。

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