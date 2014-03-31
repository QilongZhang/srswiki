# gprof性能分析

SRS支持gprof性能分析。

## SRS性能分析

SRS使用gprof分析的步骤如下：
* 配置：`./configure --with-gprof`
* 编译：`make`
* 直接启动即可：`rm -f gmon.out; ./objs/srs -c conf/srs.conf`
* 退出SRS：`killall -2 srs # or CTRL+C to stop gprof`
* 生成gprof报告：`gprof -b ./objs/srs gmon.out > gprof.srs.log && rm -f gmon.out`

可以打开`gprof.srs.log`查看性能报告，譬如：
```bash
Each sample counts as 0.01 seconds.
  %   cumulative   self              self     total
 time   seconds   seconds    calls  ms/call  ms/call  name
 33.33      0.03     0.03                             bn_sqr4x_mont
 11.11      0.04     0.01     5412     0.00     0.00  SrsBuffer::erase(int)
 11.11      0.05     0.01                             SrsComplexHandshake::handshake_with_server(ISrsProtocolReaderWriter*)
 11.11      0.06     0.01                             _st_vp_check_clock
```

注意：性能分析在不同的CPU压力下，不同的流条件，结果都不一样。所以需要在和实际应用较为接近的流码率，客户端连接数，机器型号和配置等等，环境一致的数据给出的报告，才能给改进有参考价值；否则可能改进后发现根本没有用（没有跑那个分支）。

## 图形化

gprof还能图形化，可以将结果绘制成调用图：
* 编译SRS：参考上一节`SRS性能分析`。
* 编译图形化工具：`(cd 3rdparty/gprof && bash build_gprof2dot.sh)`
* 启动服务器（按CTRL+C生成数据）：`./objs/srs -c conf/srs.conf`
* 生成gprof数据：`gprof -b ./objs/srs gmon.out > gprof.srs.log`
* 将报表转换为图片：`./3rdparty/gprof/gprof2dot.py gprof.srs.log | dot -Tpng -o winlin.png`

图片中一眼就能看出性能有问题的函数，参考下图：
![SRS-gprof性能分析图片](http://winlinvip.github.io/srs.release/wiki/images/winlin.png)

备注：有时候dot会占用N多内存，而且还出不了图片，这个应该是dot的bug。这时候赶快`killall -9 dot`，不要等了。有可能是因为性能数据太少，一般让SRS的CPU跑高点（5%以上），gprof的数据较多时，不会出现这种情况；若出现了，就重新gprof采样就好了。

Winlin 2014.3