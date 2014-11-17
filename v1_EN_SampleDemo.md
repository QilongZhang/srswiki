# SRS demo deploy example

SRS的DEMO的部署，提供网页演示播放/推送RTMP到SRS，播放HLS，转码，视频会议等。

<strong>注意：强烈建议初学者不要动demo，只要看demo就好；建议学完[Usage](https://github.com/winlinvip/simple-rtmp-server/tree/1.0release#usage)的每个单独的使用，然后再动demo。</strong>

<strong>假设服务器的IP是：192.168.1.170</strong>

<strong>第一步，设置客户端hosts，注意是客户端（需要将demo.srs.com这个域名/vhost解析到服务器）</strong>

```bash
# edit the folowing file:
# linux: /etc/hosts
# windows: C:\Windows\System32\drivers\etc\hosts
# where server ip is 192.168.1.170
192.168.1.170 demo.srs.com
```

<strong>Step 2, get SRS.</strong> For detail, read [GIT](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_Git)

```bash
git clone https://github.com/winlinvip/simple-rtmp-server
cd simple-rtmp-server/trunk
```

Or update the exists code:

```bash
git pull
```

<strong>Step 3, build SRS.</strong> For detail, read [Build](https://github.com/winlinvip/simple-rtmp-server/wiki/v1_EN_Build)

```bash
bash scripts/build.sh
```

<strong>Step 3, start SRS DEMO, which will run ffmpeg/api-server/srs</strong>

```bash
bash scripts/run.sh
```

Access SRS DEMO url: [http://demo.srs.com:8085](http://demo.srs.com:8085)

<strong>Step 4, stop SRS DEMO, which will stop ffmpeg/api-server/srs</strong>

```bash
bash scripts/stop.sh
```

Note: All links of demo is ok, all features is on.

Note: Please replace all ip 192.168.1.170 to your server ip.

Note: Demo does not depends on nginx, we use cherrypy to delivery the web pages and HLS. 
Demo use FFMPEG to transcode.

Winlin 2014.11