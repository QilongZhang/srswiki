# 点播FLV流

注意：
* 点播建议用http分发，http服务器一大堆。而srs只是因为有http-api，所以顺带支持了flv流。不建议用srs做点播服务器。
* 另外，有些嵌入式设备中分发srs切出来的hls，本身并发也不高，为了方便也可以用；但这个属于直播范畴了。
* 总之，srs不支持点播，只支持直播。这是官方回答。

SRS支持分发HTTP文件，支持分发FLV文件，也支持FLV的SEEK(?start=xxx)。

SRS也支持将直播流录制为FLV文件，因此可以支持直播转点播（即时移）。

点播FLV流的主要流程是：
* 服务器录制直播为FLV文件，或者上传FLV点播文件资源，到SRS的HTTP根目录：`objs/nginx/html`
* [可选] 使用`research/librtmp/srs_flv_injecter`将FLV的时间和对于的offset（文件偏移量）写入FLV的metadat。
* 播放器请求FLV文件，譬如：`http://192.168.1.170:8080/sample.flv`
* 用户点击进度条进行SEEK，譬如SEEK到300秒。
* 播放器可以估算一个offset，或者根据inject的时间和offset对应关系找出准确的关键帧的offset。譬如：`6638860`
* 根据offset发起新请求：`http://192.168.1.170:8080/sample.flv?start=6638860`

备注：SRS还不支持限速，会以最快的速度将文件发给客户端。
备注：SRS还提供了查看FLV文件内容的工具`research/librtmp/srs_flv_parser`，可以看到metadata和每个tag信息。

Winlin 2014.5