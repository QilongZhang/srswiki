# ARM transcoding

Under ARM , such as raspberry pi, transcoding audio or feasible. ffmpeg audio transcoding CPU utilization of 50%.

# # Compiler

When using ffmpeg transcoding system , you need to compile the ban srs ffmpeg, open simultaneously transcode options : `- with-transcode - without-ffmpeg`, so it will not compile ffmpeg, but compiled a live transcoding function. Reference : [Build] (https://github.com/winlinvip/simple-rtmp-server/wiki/Build)

# # Configuration file

Use the following configuration:

`` `bash
listen 1935;
http_stream {
    enabled on;
    listen 8080;
    . dir / objs / nginx / html;
}
vhost __ defaultVhost__ {
    transcode {
        enabled on;
        . ffmpeg / objs / ffmpeg / bin / ffmpeg;
        engine arm_aonly {
            enabled on;
            vcodec copy;
            acodec aac;
            abitrate 48;
            asample_rate 44100;
            achannels 2;
            aparams {
                strict experimental;
            }
            output rtmp :/ / 127.0.0.1: [port] / [app] vhost = hls / [stream];?
        }
    }
}

vhost hls {
    hls {
        enabled on;
        . hls_path / objs / nginx / html;
        hls_fragment 10;
        hls_window 60;
    }
}
`` `

# # Run

After starting the CPU usage :

`` `bash
top - 07:07:07 up 38 min, 2 users, load average: 0.96, 0.58, 0.44
Tasks: 74 total, 3 running, 71 sleeping, 0 stopped, 0 zombie
% Cpu (s): 53.2 us, 14.9 sy, 0.0 ni, 28.2 id, 0.0 wa, 0.0 hi, 3.6 si, 0.0 st
KiB Mem: 383156 total, 168808 used, 214348 free, 11704 buffers
KiB Swap: 102396 total, 0 used, 102396 free, 117676 cached

  PID USER PR NI VIRT RES SHR S% CPU% MEM TIME + COMMAND
 3592 winlin 20 0 41620 13m 3880 R 52.1 3.5 1:32.72. / Objs / ffmpeg / bin / ffmpeg
-f flv-i rtmp :/ / 127.0.0.1:1935 / l
 3591 winlin 20 0 3400 1464 1056 R 17.4 0.4 0:29.06. / Objs / srs-c console.conf
`` `

Start transcoding process :

`` `bash
winlin @ raspberrypi: ~ / srs $ ps aux | grep ffmpeg
winlin 3592 51.2 3.4 41620 13408 pts / 0 R + 07:04 1:43. / objs / ffmpeg / bin / ffmpeg
-f flv-i rtmp :/ / 127.0.0.1:1935 / live? vhost = __defaultVhost__ / livestream-vcodec copy
-acodec aac-b: a 48000-ar 44100-ac 2-strict experimental-f flv
-y rtmp :/ / 127.0.0.1:1935 / live? vhost = hls / livestream
`` `

Generated files :

`` `bash
winlin @ raspberrypi: ~ / srs $ ll objs / nginx / html / live /
total 6.1M
-rw-r - r - 1 winlin winlin 936K Apr 5 07:07 livestream-21.ts
-rw-r - r - 1 winlin winlin 935K Apr 5 07:08 livestream-22.ts
-rw-r - r - 1 winlin winlin 155K Apr 5 07:08 livestream-23.ts
-rw-r - r - 1 winlin winlin 833K Apr 5 07:08 livestream-24.ts
-rw-r - r - 1 winlin winlin 905K Apr 5 07:08 livestream-25.ts
-rw-r - r - 1 winlin winlin 934K Apr 5 07:08 livestream-26.ts
-rw-r - r - 1 winlin winlin 933K Apr 5 07:08 livestream-27.ts
-rw-r - r - 1 winlin winlin 529K Apr 5 07:09 livestream-28.ts.tmp
-rw-r - r - 1 winlin winlin 155 Apr 5 06:43 livestream.html
-rw-r - r - 1 winlin winlin 339 Apr 5 07:08 livestream.m3u8
`` `

Winlin 2014