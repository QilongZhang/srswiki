# SRS的架构

SRS是单进程使用epoll进行异步socket操作的高性能服务器，架构和nginx同源（同为非阻塞、异步、单线程），除了nginx是多进程SRS是单进程之外。

SRS没有直接使用epoll进行状态处理，而是使用了协程库state-threads，简称st（详细介绍可以看文章：[高性能、高并发、高扩展性和可读性的网络服务器架构：StateThreads](http://blog.csdn.net/win_lin/article/details/8242653)）。

ST参考：[ST](https://github.com/winlinvip/state-threads)

另外，SRS多进程在研发计划中，预计在2015年可以支持。

Winlin 2014.2