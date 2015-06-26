# HTTP API

SRS provides HTTP api, to external application to manage SRS, and support crossdomain for js.

The following is a SRS server api of ossrs.net:

![SRS](http://winlinvip.github.io/srs.release/wiki/images/demo.api.png?v1)

## Design Priciple

The HTTP API of SRS follows the simple priciple:

* Only provides API in json format, both request and json are json.
* No html, access the api return json format.

## Build

To enable http api, configure SRS with `--with-http-api`, 
read [configure](v2_EN_Build)

```bash
./configure --with-http-api && make
```

## Config

The config also need to enable it:

```bash
listen              1935;
# system statistics section.
# the main cycle will retrieve the system stat,
# for example, the cpu/mem/network/disk-io data,
# the http api, for instance, /api/v1/summaries will show these data.
# @remark the heartbeat depends on the network,
#       for example, the eth0 maybe the device which index is 0.
stats {
    # the index of device ip.
    # we may retrieve more than one network device.
    # default: 0
    network         0;
    # the device name to stat the disk iops.
    # ignore the device of /proc/diskstats if not configed.
    disk            sda sdb xvda xvdb;
}
# api of srs.
# the http api config, export for external program to manage srs.
# user can access http api of srs in browser directly, for instance, to access by:
#       curl http://192.168.1.170:1985/api/v1/reload
# which will reload srs, like cmd killall -1 srs, but the js can also invoke the http api,
# where the cli can only be used in shell/terminate.
http_api {
    # whether http api is enabled.
    # default: off
    enabled         on;
    # the http api listen entry is <[ip:]port>
    # for example, 192.168.1.100:1985
    # where the ip is optional, default to 0.0.0.0, that is 1985 equals to 0.0.0.0:1985
    # default: 1985
    listen          1985;
    # whether enable crossdomain request.
    # default: on
    crossdomain     on;
}
vhost __defaultVhost__ {
}
```

The `http_api` enable the HTTP API, and `stats` used for SRS to stat the system info, including:

* network: Used for heartbeat to report the network info, where heartbeat used to report system info. Please read [Heartbeat](https://github.com/simple-rtmp-server/srs/wiki/v1_CN_Heartbeat)
* disk: Used to stat the specified disk iops. You can use command `cat /proc/diskstats` to get the right disk names, for instance, xvda.

## Start

Start SRS: `./objs/srs -c http-api.conf`

Access api, open the url in web browser: [http://192.168.1.170:1985/api/v1](http://192.168.1.170:1985/api/v1)

## Performance

The HTTP api supports 370 request per seconds.

## Access Api

Use web brower, or curl, or other http library.

SRS provides api urls list, no need to remember:
* code, an int error code. 0 is success.
* urls, the url lists, can be access.
* data, the last level api serve data.

Root directory:

```bash
# curl http://192.168.1.102:1985/
{

    "code": 0,
    "urls": {
        "api": "the api root"
    }

}
```

The urls is the apis to access:

```bash
# curl http://192.168.1.102:1985/api/
{

    "code": 0,
    "urls": {
        "v1": "the api version 1.0"
    }

}
```

Go on:

```bash
# curl http://192.168.1.102:1985/api/v1/
{

    "code": 0,
    "urls": {
        "versions": "the version of SRS",
        "authors": "the primary authors and contributors"
    }

}
```

Go on:

```bash
# curl http://192.168.1.102:1985/api/v1/versions
{

    "code": 0,
    "data": {
        "major": 0,
        "minor": 9,
        "revision": 43,
        "version": "0.9.43"
    }

}
```

Or:

```bash
# curl http://192.168.1.102:1985/api/v1/authors
{

    "code": 0,
    "data": {
        "primary_authors": "winlin,wenjie.zhao",
        "contributors_link": "https://github.com/simple-rtmp-server/srs/blob/master/AUTHORS.txt",
        "contributors": "winlin<winlin@vip.126.com> wenjie.zhao<740936897@qq.com> xiangcheng.liu<liuxc0116@foxmail.com> naijia.liu<youngcow@youngcow.net> alcoholyi<alcoholyi@qq.com> "
    }

}
```

The Api of SRS is self-describes api.

## Error Code

When error for http server, maybe return an error page, SRS always return the json result.

For example, the 404 `not found` api `http://192.168.1.102:1985/apis`:

```bash
{

    "code": 804,
    "data": {
        "status_code": 404,
        "reason_phrase": "Not Found",
        "url": "/apis"
    }

}
```

While the http header is 404:

```bash
HTTP/1.1 404 Not Found
Server: SRS/0.9.43
Content-Type: application/json;charset=utf-8
Allow: DELETE, GET, HEAD, OPTIONS, POST, PUT
Content-Length: 81
```

Not all HTTP protocol is supported by SRS.

## Crossdomain

SRS HTTP API supports js crossdomain, so the html/js can invoke http api of srs。

## Vhost

SRS provides http api to query all vhosts, where server is the id of srs, which identify whether srs restarted.

The http api vhost url: `http://192.168.1.102:1985/api/v1/vhosts`

## Stream

SRS provides http api to query all streams, where sever is the id of srs, and vhost is the vhost contains the stream.

The http api stream url: `http://192.168.1.102:1985/api/v1/streams`

Winlin 2015.3
