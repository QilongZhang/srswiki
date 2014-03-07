# GPERF内存和性能分析

valgrind一个很好用的内存和CPU分析工具，srs由于使用了st(state-threads)，st是基于c函数setjmp和longjmp，valgrind不支持这两个函数，所以srs没法用valgrind分析内存错误和泄漏。

[gperf](https://code.google.com/p/gperftools)是google用作内存和CPU分析的工具，基于tcmalloc（也是google内存分配库，替换glibc的malloc和free）。好消息是gperf可以用作srs的内存和性能分析。

gperf主要有三个应用：
* gmc: gperf memory check, 内存检查（泄漏，错误等），参考：http://google-perftools.googlecode.com/svn/trunk/doc/heap_checker.html
* gmp: gperf memory profile, 内存性能分析（哪个函数内存分配多），参考：http://google-perftools.googlecode.com/svn/trunk/doc/heapprofile.html
* gcp: gperf cpu profile, CPU性能分析（函数消耗CPU多），参考：http://google-perftools.googlecode.com/svn/trunk/doc/heapprofile.html

## gmc内存检查

使用gmc时，需要将tcmalloc编译进去（或者动态链接），具体参考官方文档。除此之外，必须设置环境变量，gmc才被开启。

SRS开启gmc的方法是：
* 配置时加上gmc：`./configure --with-gmc`
* 编译srs：`make`
* 启动时指定环境变量：`env PPROF_PATH=./objs/pprof HEAPCHECK=normal ./objs/srs -c conf/srs.conf`
* 停止srs，打印gmc结果：`CTRL+C` 或者发送SIGINT信号给SRS

注意：必须导出pprof环境变量`PPROF_PATH`，否则函数的地址和符合对应不上

若能打印下面的信息，说明gmc成功启动：

```bash
[winlin@dev6 srs]$ env PPROF_PATH=./objs/pprof HEAPCHECK=normal ./objs/srs -c conf/srs.conf
WARNING: Perftools heap leak checker is active -- Performance may suffer
```

gmc的结果：

```bash
Leak check _main_ detected leaks of 184 bytes in 4 objects
The 4 largest leaks:
Using local file ./objs/srs.
Leak of 56 bytes in 1 objects allocated from:
	@ 46fae8 _st_stack_new
	@ 46f6b1 st_thread_create
	@ 46ea65 st_init
	@ 433f41 SrsServer::initialize
	@ 46e4ca main
	@ 3855a1ec5d __libc_start_main
```

备注：st创建stack的内存泄漏，应该不是问题，属于误报。

另外，SRS有例子说明如何使用gmc，参考：research/gperftools/heap-checker/heap_checker.cc

## 

Winlin 2014.3