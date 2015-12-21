#Bravo Media Server

BMS(Bravo Media Server)是基于SRS开发的商业版，由[chnvideo](http://www.chnvideo.com)研发。

## Major Compare

BMS和SRS的主要区别如下：

| Feature | SRS | BMS | Remark |
| ------  | --- | --- | ------ |
| 级别 | 工业级 | 工业级 | 发行版本都是工业级集群标准 |
| 开源 | 是 | 否 | BMS为闭源商业软件，提供售前咨询和售后服务，<br/>以及定制化开发，系统对接等 |
| 发行版 | 1.0 | 3.0 | SRS目前发行版为1.0，SRS2为alpha测试版。<br/>BMS合并了SRS2和SRS3的功能，为发行版 |
| 周期 | 1-2年 | 6个月 | SRS的版本发行周期为1到2年 |
| 代码量 | 9.95万行 | 11.29万行 | 包含服务器的注释和单元测试<br/>BMS比SRS多13.47%的代码量。 |
| 自动测试 | 无 | 是 | BMS包含自动化测试系统，每次提交自动回归测试 |

## Detail Compare

BMS和SRS的详细对比如下（注意对比的是发行版，即SRS1和BMS3）：

| Feature | SRS | BMS | Remark |
| ------  | ---- | ---- | ----- |
| 输入 | RTMP | RTMP, FLV, RTSP, UDP| 推流到服务器的输入方式 |
| 输出 | RTMP, HLS | RTMP, FLV, TS, MP3, HLS | 服务器分发给客户端的方式 |

## Contact

有需要请联系[chnvideo](http://www.chnvideo.com).
