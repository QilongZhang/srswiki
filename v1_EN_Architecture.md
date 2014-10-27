# SRS Architecture

SRS is a high performance server, single thread, async and none-blocking using epoll. Similar to NGINX, but without multiple process right now.

SRS use coroutine library state-threads, which use select, poll or epoll. ST(state-threads) is a server arch for internet application, see: [StateThreads](http://blog.csdn.net/win_lin/article/details/8242653).

ST mirror, see: [ST](https://github.com/winlinvip/state-threads)

BTW: SRS multiple process arch is in plan, maybe support in 2015.

Winlin 2014.10