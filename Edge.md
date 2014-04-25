# Edge边缘服务器

SRS的Edge提供访问时回源机制，在CDN/VDN等流众多的应用场景中有重大意义，forward/ingest方案会造成大量带宽浪费。同时，SRS的Edge能对接所有的RTMP源站服务器，不像FMS的Edge只能对接FMS源站（有私有协议）；另外，SRS的Edge支持SRS源站的所有逻辑（譬如转码，转发，HLS，DVR等等），也就是说可以选择在源站切片HLS，也可以直接在边缘切片HLS。

备注：Edge往往需要配合多进程，SRS的多进程在计划之中。

Edge的主要应用场景：
* CDN/VDN大规模集群，客户众多流众多需要按需回源。
* 小规模集群，但是流比较多，需要按需回源。
* 骨干带宽低，边缘服务器强悍，可以内部分发RTMP后边缘切片HLS，避免RTMP和HLS都回源。

Winlin 2014.4