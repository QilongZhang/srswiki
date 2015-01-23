# Streamer

Streamer is a server feature to accept stream over other protocol, for example, allow user to publish MPEG-TS over UDP to SRS.

Streamer will cast other stream protocol to rtmp, then publish to SRS itself, to devliery in RTMP/HLS/HTTP.

## Use Scenario

Typically use scenarios:

* Push MPEG-TS over UDP to SRS, delivery in RTMP/HLS/HTTP.
* Push RTSP to SRS, delivery in RTMP/HLS/HTTP.

Remark: The streamer will demux other protocol then push to SRS over RTMP, so all features of SRS are available, for example, push RTSP to SRS over RTMP to edge vhost which will forward stream to origin, or transcode the rtmp stream, or directly forward to other server. And, all delivery methods are ok, for example, push RTSP to SRS overy RTMP, delivery in RTMP/HLS/HTTP.

## Protcols

The protocols supported by Streamer:

* MPEG-TS over UDP: Coming sone.

2015.1