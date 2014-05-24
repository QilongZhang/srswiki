# SRS architecture

SRS is a single process using epoll asynchronous socket operation of high-performance server architecture and nginx homologous (same as non-blocking, asynchronous, single-threaded), in addition to multi-process nginx is outside the SRS is a single process.

SRS does not directly deal with the state to use epoll, but the use of the coroutine library state-threads, referred st (details can be seen below: [high-performance, high-concurrency, high scalability and readability of web server architecture: StateThreads] (http://blog.csdn.net/win_lin/article/details/8242653)).

ST Reference: [ST] (https://github.com/winlinvip/state-threads)

In addition, SRS multi-process research and development program is expected to be supported in 2015.

Winlin 2014.2