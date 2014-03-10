# RTMP部署实例

RTMP部署的步骤。

<strong>假设服务器的IP是：192.168.1.170</strong>

<strong>第一步，获取SRS。</strong>详细参考[GIT获取代码](https://github.com/winlinvip/simple-rtmp-server/wiki/Git)

```bash
git clone https://github.com/winlinvip/simple-rtmp-server
cd simple-rtmp-server/trunk
```

或者使用git更新已有代码：

```bash
git pull
```

<strong>第二步，编译SRS。</strong>详细参考[Build](https://github.com/winlinvip/simple-rtmp-server/wiki/Build)

```bash
./configure && make
```

<strong>第三步，编写SRS配置文件。</strong>详细参考[RTMP分发](https://github.com/winlinvip/simple-rtmp-server/wiki/DeliveryRTMP)

```bash
# conf/rtmp.conf
listen              1935;
vhost __defaultVhost__ {
}
```

<strong>第三步，启动SRS。</strong>详细参考[RTMP分发](https://github.com/winlinvip/simple-rtmp-server/wiki/DeliveryRTMP)

```bash
./objs/srs -c conf/rtmp.conf
```

<strong>第四步，启动推流编码器。</strong>详细参考[RTMP分发](https://github.com/winlinvip/simple-rtmp-server/wiki/DeliveryRTMP)

```bash
    for((;;)); do \
        ./objs/ffmpeg/bin/ffmpeg -re -i ./doc/source.200kbps.768x320.flv \
        -vcodec copy -acodec copy \
        -f flv -y rtmp://127.0.0.1/live/livestream; \
        sleep 1; \
    done
```

或使用FMLE推流：

```bash
FMS URL: rtmp://127.0.0.1/live
Stream: livestream
```

<strong>

Winlin 2014.3