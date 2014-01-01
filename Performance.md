对比SRS和高性能nginx-rtmp的Performance。

### 硬件环境
* 硬件: 虚拟机
* 系统: CentOS 6.0 x86_64 Linux 2.6.32-71.el6.x86_64
* CPU: 3 Intel(R) Core(TM) i7-3520M CPU @ 2.90GHz
× 内存: 2007MB

### NGINX-RTMP
* NGINX: nginx-1.5.7.tar.gz
* NGINX-RTMP: nginx-rtmp-module-1.0.4.tar.gz
* 编译参数：./configure --prefix=\`pwd\`/../_release --add-module=\`pwd\`/../nginx-rtmp-module-1.0.4 --with-http_ssl_module
* 配置文件:
```
user  winlin;
worker_processes  1;

events {
    worker_connections  10240;
}
rtmp{
    server{
        listen 19350;
        application live{
            live on;
        }
    }
}
```