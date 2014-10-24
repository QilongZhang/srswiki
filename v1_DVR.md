# DVR录制

SRS支持将RTMP流录制成flv文件。

## 编译选项

DVR的编译选项为`--with-dvr`，关闭DVR的选项为`--without-dvr`。

参考：[Build](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_Build)

## 配置选项

DVR的难点在于写入flv和文件命名，SRS的做法是随机生成文件名，用户可以使用http-callback方式，使用外部程序记录这个文件名，或者改成自己要的文件命名方式。

当然也可以修改SRS代码，这种做法不推荐，c操作文件名比较麻烦。还是用外部辅助系统做会很方便。

DVR的配置文件说明：

```bash
    # dvr RTMP stream to file,
    # start to record to file when encoder publish,
    # reap flv according by specified dvr_plan.
    dvr {
        # whether enabled dvr features
        # default: off
        enabled      on;
        # the dvr output path.
        # the app dir is auto created under the dvr_path.
        # for example, for rtmp stream:
        #   rtmp://127.0.0.1/live/livestream
        #   http://127.0.0.1/live/livestream.m3u8
        # where dvr_path is /dvr, srs will create the following files:
        #   /dvr/live       the app dir for all streams.
        #   /dvr/live/livestream.{time}.flv   the dvr flv file.
        # @remark, the time use system timestamp in ms, user can use http callback to rename it.
        # in a word, the dvr_path is for vhost.
        # default: ./objs/nginx/html
        dvr_path    ./objs/nginx/html;
        # the dvr plan. canbe:
        #   session reap flv when session end(unpublish).
        #   segment reap flv when flv duration exceed the specified dvr_duration.
        # default: session
        dvr_plan        session;
        # the param for plan(segment), in seconds.
        # default: 30
        dvr_duration    30;
        # the param for plan(segment),
        # whether wait keyframe to reap segment,
        # if off, reap segment when duration exceed the dvr_duration,
        # if on, reap segment when duration exceed and got keyframe.
        # default: on
        dvr_wait_keyframe       on;
    }
```

DVR的计划即决定什么时候关闭flv文件，打开新的flv文件，主要的录制计划包括：
* session：按照session来关闭flv文件，即编码器停止推流时关闭flv，整个session录制为一个flv。
* segment：按照时间分段录制，flv文件时长配置为dvr_duration和dvr_wait_keyframe。注意：若不按关键帧切flv（即dvr_wait_keyframe配置为off），所以会导致后面的flv启动时会花屏。

参考`conf/dvr.segment.conf`和`conf/dvr.session.conf`配置实例。

Winlin 2014.4