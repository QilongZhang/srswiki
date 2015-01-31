# Streamer

Streamer is a server feature to accept stream over other protocol, for example, allow user to publish MPEG-TS over UDP to SRS.

Streamer will cast other stream protocol to rtmp, then publish to SRS itself, to devliery in RTMP/HLS/HTTP.

## Use Scenario

Typically use scenarios:

* Push MPEG-TS over UDP to SRS, delivery in RTMP/HLS/HTTP.
* Push RTSP to SRS, delivery in RTMP/HLS/HTTP.

Remark: The streamer will demux other protocol then push to SRS over RTMP, so all features of SRS are available, for example, push RTSP to SRS over RTMP to edge vhost which will forward stream to origin, or transcode the rtmp stream, or directly forward to other server. And, all delivery methods are ok, for example, push RTSP to SRS overy RTMP, delivery in RTMP/HLS/HTTP.

## Protocols

The protocols supported by Streamer:

* MPEG-TS over UDP: Support encoder to push MPEG-TS over UDP to SRS.

## Push MPEG-TS over UDP

SRS can listen a udp port, which recv udp packet(SPTS) from encoder, then remux the SPTS to a RTMP stream. All features for RTMP is ok for this RTMP stream.

The config for pushing MPEG-TS over UDP, see `conf/push.mpegts.over.udp.conf`:

```
# the streamer cast stream from other protocol to SRS over RTMP.
# @see https://github.com/winlinvip/simple-rtmp-server/tree/develop#stream-architecture
stream_caster {
    # whether stream caster is enabled.
    # default: off
    enabled         on;
    # the caster type of stream, the casters:
    #       mpegts_over_udp, MPEG-TS over UDP caster.
    caster          mpegts_over_udp;
    # the output rtmp url.
    # for example, rtmp://127.0.0.1/live/livestream.
    output          rtmp://127.0.0.1/live/livestream;
    # the listen port for stream caster.
    # for caster:
    #       mpegts_over_udp, listen at udp port.
    listen          1935;
}
```

For more information, read https://github.com/winlinvip/simple-rtmp-server/issues/250#issuecomment-72321769

2015.1