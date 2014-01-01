# Performance

对比SRS和高性能nginx-rtmp的Performance，SRS为单进程，nginx-rtmp支持多进程，为了对比nginx-rtmp也只开启一个进程。

提供详细的性能测试的过程，可以为其他性能测试做出参数，譬如测试nginx-rtmp的多进程，和srs的forward对比之类。

## 硬件环境

本次对比所用到的硬件环境，使用虚拟机，客户端和服务器都运行于一台机器，避开网络瓶颈。

* 硬件: 虚拟机
* 系统: CentOS 6.0 x86_64 Linux 2.6.32-71.el6.x86_64
* CPU: 3 Intel(R) Core(TM) i7-3520M CPU @ 2.90GHz
× 内存: 2007MB

## NGINX-RTMP

NGINX-RTMP使用的版本信息，以及编译参数。

* NGINX: nginx-1.5.7.tar.gz
* NGINX-RTMP: nginx-rtmp-module-1.0.4.tar.gz
* 编译参数：./configure --prefix=\`pwd\`/../_release --add-module=\`pwd\`/../nginx-rtmp-module-1.0.4 --with-http_ssl_module

## NGINX配置文件

NGINX的配置文件为：`cat _release/conf/nginx.conf`

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