## Exec

## NGINX RTMP EXEC

NGINX-RTMP支持的EXEC方式，参考[nginx exec][ne]，SRS只支持常用的几种。下面是exec的支持情况：

1. exec/exec_publish: 当发布流时调用，支持。
1. exec_pull: 不支持。
1. exec_play: 不支持。
1. exec_record_done: 不支持。

Winlin 2015.08

[ne]: https://github.com/arut/nginx-rtmp-module/wiki/Directives#exec