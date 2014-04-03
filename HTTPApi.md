# HTTP接口

SRS提供HTTP接口，供外部程序管理服务器，并支持跨域（js可以直接控制和获取服务器的各种信息）。

## 设计原则

SRS的HTTP接口遵循最简单原则，主要包括：
* 只提供json数据格式接口，要求请求和响应的数据全都是json。
* 不提供html数据，譬如运行SRS后，浏览器打开HTTP接口或HTTP服务地址，看到的是json，不是html。
* 服务器不支持写配置文件，HTTP接口提供的修改功能都是内存中的，reload之后会被配置文件覆盖。

## 编译和启动

SRS需要打开HTTPApi选项，参考：[configure选项](https://github.com/winlinvip/simple-rtmp-server/wiki/Build#srs%E4%BE%9D%E8%B5%96%E5%85%B3%E7%B3%BB)

```bash
./configure --with-http-api && make
```

配置文件需要开启http-api：

```bash
# http-api.conf
listen              1935;
http_api {
    enabled         on;
    listen          1985;
}
vhost __defaultVhost__ {
}
```

启动服务器：`./objs/srs -c http-api.conf`

访问api：浏览器打开地址[http://192.168.1.170:1985/api/v1](http://192.168.1.170:1985/api/v1)

## 性能

机器：虚拟机CentOS6-64位，4CPU，T430笔记本，VirtualBox

10%CPU，10000次请求，27秒，平均370次请求/秒，30毫秒一个请求

```bash
top - 09:59:49 up 3 days, 50 min,  4 users,  load average: 0.00, 0.00, 0.00
Tasks: 140 total,   1 running, 139 sleeping,   0 stopped,   0 zombie
Cpu(s): 11.6%us, 20.0%sy,  0.0%ni, 66.7%id,  0.0%wa,  0.0%hi,  1.8%si,  0.0%st
Mem:   2055440k total,   990148k used,  1065292k free,   228544k buffers
Swap:  2064376k total,        0k used,  2064376k free,   486620k cached
  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
29696 winlin    20   0 15872 1592 1360 S  9.3  0.1   0:14.21 ./objs/srs -c console.conf
```

```bash
[winlin@dev6 csdn]$ time for((i=0;i<10000;i++)); do curl http://127.0.0.1:1985/api >/dev/null 2>&1; done

real	0m27.375s
user	0m8.223s
sys	0m16.289s
```

Winlin 2014.4