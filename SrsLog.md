# SRS系统日志

SRS提供两种打印日志的方式，通过配置`srs_log_tank`：
* console：打印日志到控制台。当配置文件没有加载时，也打印到控制台。
* file: 默认，打印日志到文件。必须指定配置`srs_log_file`，日志文件。日志文件默认为：`./objs/srs.log`

另外，一个相关的配置是守护进程方式启动，这样就不要nohup启动了（实际上是程序实现了nohup）：

```bash
# whether start as deamon
# default: on
daemon              on;
```

若希望不以daemon启动，且日志打印到console，可以使用配置`conf/console.conf`：

```bash
# no-daemon and write log to console config for srs.
# @see full.conf for detail config.

listen              1935;
daemon              off;
srs_log_tank        console;
vhost __defaultVhost__ {
}
```

启动方式：

```bash
./objs/srs -c conf/console.conf 
```

系统默认方式是daemon+log2file，具体参考`full.conf`的说明。

注意：[init.d脚本启动](https://github.com/winlinvip/simple-rtmp-server/wiki/LinuxService)会将console日志也打印到文件，若没有指定文件，默认文件为`./objs/srs.log`。脚本启动尽量保证日志不丢失。

注意：一般以daemon后台启动，并将日志写到文件（默认），srs只会在控制台打印一条消息，表示配置文件解析成功了。

```bash
[winlin@dev6 srs]$ ./objs/srs -c conf/hls.conf 
[2014-04-02 15:05:43.302][trace][0][0] config parsed EOF
[winlin@dev6 srs]$
```

Winlin 2014.3