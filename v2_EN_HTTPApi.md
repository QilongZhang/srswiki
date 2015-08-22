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

Remark: Please use your server ip instead.

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

SRS response error in both HTTP status or HTTP body.

For example, SRS response HTTP error, where HTTP status not 200:

```
winlin:~ winlin$ curl -v http://127.0.0.1:1985 && echo ""
< HTTP/1.1 404 Not Found
< Connection: Keep-Alive
< Content-Length: 9
< Content-Type: text/plain; charset=utf-8
< Server: SRS/2.0.184
< 
Not Found
```

For example, SRS response code not 0 when HTTTP Status 200:

```
winlin:~ winlin$ curl -v http://127.0.0.1:1985/api/v1/tests/errors && echo ""
< HTTP/1.1 200 OK
< Connection: Keep-Alive
< Content-Length: 12
< Content-Type: application/json
< Server: SRS/2.0.184
< 
{"code":100}
```

User should handle these two error style.

## Crossdomain

SRS HTTP API supports js crossdomain, so the html/js can invoke http api of srs。

## Server ID

Each response of api contains a `server` field, which identify the server. When ServerID changed, SRS already restarted, all information before is invalid.

## API Nevigation

SRS提供了API的导航，即所有支持的API及描述。

地址是：`http://`92.168.1.102:1985/api/v1/vhosts`，主要包含的子api有：

| API | Example  | Description |
| --- | -------- | ---------   |
| server | 4481  | The identity of SRS   |
| versions | /api/v1/versions  | the version of SRS |
| summaries | /api/v1/summaries | the summary(pid, argv, pwd, cpu, mem) of SRS |
| rusages  | /api/v1/rusages | the rusage of SRS |
| self_proc_stats | /api/v1/self_proc_stats | the self process stats |
| system_proc_stats | /api/v1/system_proc_stats | the system process stats |
| meminfos | /api/v1/meminfos | the meminfo of system |
| authors | /api/v1/authors | the license, copyright, authors and contributors |
| requests | /api/v1/requests | the request itself, for http debug |
| vhosts | /api/v1/vhosts | manage all vhosts or specified vhost |
| streams | /api/v1/streams | manage all streams or specified stream |
| clients | /api/v1/clients | manage all clients or specified client, default query top 10 clients |

## Vhost

SRS provides http api to query all vhosts, where server is the id of srs, which identify whether srs restarted.

The http api vhost url: `http://192.168.1.102:1985/api/v1/vhosts`

To process specified vhost by id, for instance `http://192.168.1.102:1985/api/v1/vhosts/3756`

## Stream

SRS provides http api to query all streams, where sever is the id of srs, and vhost is the vhost contains the stream.

The http api stream url: `http://192.168.1.102:1985/api/v1/streams`

To process specified stream by id, for instance `http://192.168.1.102:1985/api/v1/streams/3756`

## Kickoff Client

SRS provides HTTP RESTful api to kickoff user:

```
DELETE /api/v1/clients/{id}
```

User can get the id of client to kickoff:

```
GET /api/v1/clients
```

User can get the id of publish client from streams api:

```
GET /api/v1/streams
```

Remark: User can use [HTTP REST Tool](http://ossrs.net/srs.release/http-rest/index.html) to send a request.

Winlin 2015.3