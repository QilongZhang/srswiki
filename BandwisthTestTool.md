# Bandwidth test

Video very card to play this , suddenly a large buffer , pushing up the mountain stream , there may be a low -bandwidth , SRS supports testing client- server bandwidth .

SRS configuration files need to open the bandwidth test configuration , plus a separate vhost generally support gun . SRS configuration `conf / bandwidth.conf`. For example :

`` `bash
listen 1935;
vhost __ defaultVhost__ {
}

vhost bandcheck.srs.com {
    enabled on;
    chunk_size 65000;
    bandcheck {
        enabled on;
        key "35c9b402c12a7246868752e2878f7e0e";
        interval 30;
        limit_kbps 4000;
    }
}
`` `

<strong> Assuming the server IP is : 192.168.1.170 </ strong>

After starting with a bandwidth test client can see : [http://winlinvip.github.io/srs.release/trunk/research/players/srs_bwt.html?server=192.168.1.170] (http://winlinvip.github .io / srs.release / trunk / research / players / srs_bwt.html? server = 192.168.1.170)

Note: Keep all instances are replaced by IP address 192.168.1.170 IP address of the server deployment.

After the completion of the bandwidth detection prompts , such as:

`` `bash
Detect the end : Server : 192.168.1.107 Uplink : 2170 kbps downstream : 3955 kbps Test time: 7.012 seconds
`` `

In addition , SRS also provides bandwidth detection command-line tool :

`` `bash
[winlin @ dev6 srs] $. / objs / bandwidth-i 127.0.0.1-p 1935-v bandcheck.srs.com-k 35c9b402c12a7246868752e2878f7e0e
[2014-04-16 16:11:23.335] [trace] [0] [11] result: play 3742 kbps, publish 149 kbps, check time 7.0900 S
`` `

Winlin