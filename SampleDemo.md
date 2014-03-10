# Demo的部署

SRS的DEMO的部署，提供网页演示播放/推送RTMP到SRS，播放HLS，转码，视频会议等。

<strong>假设服务器的IP是：192.168.1.170</strong>

<strong>第一步，设置客户端hosts，注意是客户端（需要将demo.srs.com这个域名/vhost解析到服务器）</strong>

```bash
# edit the folowing file:
# linux: /etc/hosts
# windows: C:\Windows\System32\drivers\etc\hosts
# where server ip is 192.168.1.170
192.168.1.170 demo.srs.com
```

<strong>第二步，获取SRS。</strong>详细参考[GIT获取代码](https://github.com/winlinvip/simple-rtmp-server/wiki/Git)

```bash
git clone https://github.com/winlinvip/simple-rtmp-server
cd simple-rtmp-server/trunk
```

或者使用git更新已有代码：

```bash
git pull
```

<strong>第三步，编译SRS。</strong>详细参考[Build](https://github.com/winlinvip/simple-rtmp-server/wiki/Build)

```bash
./configure && make
```

<strong>第三步，启动SRS的DEMO，启动ffmpeg/nginx/srs等。</strong>

```bash
bash scripts/run.sh
```

访问SRS的DEMO：[http://demo.srs.com](http://demo.srs.com)

Winlin 2014.3