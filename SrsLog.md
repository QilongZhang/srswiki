# SRS系统日志

SRS支持打印到console和file，支持设置level。

## LogTank

LogTank即log的容器，日志打印到什么地方。

SRS提供两种打印日志的方式，通过配置`srs_log_tank`：
* console：打印日志到控制台。当配置文件没有加载时，也打印到控制台。
* file: 默认，打印日志到文件。必须指定配置`srs_log_file`，日志文件。日志文件默认为：`./objs/srs.log`

配置文件中的说明：

```bash
# the log tank, console or file.
# if console, print log to console.
# if file, write log to file. requires srs_log_file if log to file.
# default: file.
srs_log_tank        file;
```

## LogLevel

LogLevel就是log的级别，什么级别的日志才会打印出来。

SRS支持设置日志级别，通过设置`srs_log_level`：
* verbose: 非常详细的日志，性能会很低，日志会非常多。SRS默认是编译时禁用这些日志，提高性能。
* info：较为详细的日志，性能也受影响。SRS默认编译时禁用这些日志。
* trace: 重要的日志，比较少，SRS默认使用这个级别。
* warn: 警告日志，SRS在控制台以黄色显示。若SRS运行较稳定，可以只打开这个日志。建议使用trace级别。
* error: 错误日志，SRS在控制台以红色显示。

配置文件中的说明：

```bash
# the log level, for all log tanks.
# can be: verbose, info, trace, warn, error
# defualt: trace
srs_log_level       trace;
```

注意事项：
* 设置了低级别的日志，自动会打印高级别的。譬如设置为trace，那么trace/warn/error日志都会打印出来。
* 默认verbose和info是编译时禁用的，若需要打开这两个日志，需要修改`srs_kernel_log.hpp`，将对应的禁用编译宏打开。
* 推荐使用trace级别，重要的日志不多，对于排错很方便。如果有错误，建议用gdb调试，不要依赖日志。只有在不得已时才用日志排错。

## 守护进程

为何默认启动srs时只有一条日志呢？原因是守护进程方式启动时，日志会打印到文件。

一个相关的配置是守护进程方式启动，这样就不要nohup启动了（实际上是程序实现了nohup）：

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