# SRS应用于linux-arm

arm芯片上，如何使用SRS？一般arm上的硬件可以获取到h.264裸码流。有几个方案：
* arm推送RTMP到SRS：从arm上将h.264裸码流包装成flv流，使用[srs-librtmp](https://github.com/winlinvip/simple-rtmp-server/wiki/SrsLibrtmp)，或者librtmp，将flv格式的包以RTMP发送到SRS。
* arm推送h.264裸码流到SRS（目前还不支持）：可以使用自定义协议，可以不必使用RTMP这么复杂的协议，使用socket将h.264裸码流发送到SRS，SRS服务器端将裸码流打包成RTMP分发。
* arm上运行SRS：在arm上运行SRS，使用上面两个方案将h.264裸码流推送到arm上的SRS。客户端或者RTMP边缘直接从arm上的SRS源站取RTMP流。

推荐第一种方案，“arm推送RTMP到SRS”。

备注：“arm上运行SRS”需要在编译时用arm编译命令，并且st要使用linux-optimized选项，否则运行失败。