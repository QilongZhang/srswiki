操作系统：CentOS release 6.5 (Final)  x86_64  gcc version 4.4.7 20120313 (Red Hat 4.4.7-4) (GCC)
用SRS什么版本:0.9.123
客户端：自己的编码的数据push到srs 服务器上的
问题可以重现，只要使用我们这边push的数据就是必现的，但是我们的数据流push到nginx-trmp和wowza上没有问题的

报错的日志：
^@[2014-06-11 15:51:39.047][trace][22345][107] got metadata
^@[2014-06-11 15:51:39.050][trace][22345][107] got audio sh, size=9
^@[2014-06-11 15:51:39.063][trace][22345][107] got video sh, size=46
^@[2014-06-11 15:51:42.356][error][22345][107][11] chunk stream is fresh, fmt must be 0, actual is 1. cid=2, ret=301(Resource temporarily unavailable)
^@[2014-06-11 15:51:42.356][error][22345][107][11] read message header failed. ret=301(Resource temporarily unavailable)
^@[2014-06-11 15:51:42.356][error][22345][107][11] recv interlaced message failed. ret=301(Resource temporarily unavailable)
^@[2014-06-11 15:51:42.356][error][22345][107][11] fmle recv identify client message failed. ret=301(Resource temporarily unavailable)
^@[2014-06-11 15:51:42.357][trace][22345][107] cleanup when unpublish
^@[2014-06-11 15:51:42.357][error][22345][107][11] stream service cycle failed. ret=301(Resource temporarily unavailable)

问题描述：
客户端发送数据流到服务器，服务器一会就主动关闭客户端，看客户端的日志显示读取消息头有问题