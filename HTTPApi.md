# HTTP接口

SRS提供HTTP接口，供外部程序管理服务器，并支持跨域（js可以直接控制和获取服务器的各种信息）。

## 设计原则

SRS的HTTP接口遵循最简单原则，主要包括：
* 只提供json数据格式接口，要求请求和响应的数据全都是json。
* 不提供html数据，譬如运行SRS后，浏览器打开HTTP接口或HTTP服务地址，看到的是json，不是html。
* 服务器不支持写配置文件，HTTP接口提供的修改功能都是内存中的，reload之后会被配置文件覆盖。

## 编译和启动

SRS需要打开HTTPApi选项，参考：[configure选项](https://github.com/winlinvip/simple-rtmp-server/wiki/Build#srs%E4%BE%9D%E8%B5%96%E5%85%B3%E7%B3%BB)

```bash
./configure --with-http-api && make
```

配置文件需要开启http-api：

```bash
# http-api.conf
listen              1935;
http_api {
    enabled         on;
    listen          1985;
}
vhost __defaultVhost__ {
}
```

启动服务器：`./objs/srs -c http-api.conf`

访问api：浏览器打开地址[http://192.168.1.170:1985/api/v1](http://192.168.1.170:1985/api/v1)

Winlin 2014.4