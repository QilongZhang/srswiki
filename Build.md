# Compiler SRS

This article explains how to compile and package SRS, in addition , can be downloaded directly release the binary, provides several common system installation package , the installation program will install system services , system services can be activated directly . Reference : [Github: release] ([Download Released SRS ( download release version )] (http://winlinvip.github.io/simple-rtmp-server)) or [ domestic Mirror : release] (http://demo. chnvideo.com: 8085/srs/releases)

# # Operating System

* README of Usage, in <strong> Centos6.x/Ubuntu12 </ strong> The following test was successful. After Step operation in accordance with the browser open server address can watch all of the DEMO.
* DEMO demonstrates all SRS features, especially the giant multi- ffmpeg library dependencies , so in order to simplify the recommended <strong> Centos6.x/Ubuntu12 </ strong>.
* If you do need to compile in other systems SRS, SRS described below depend on a variety of libraries , you can turn off certain features to reduce compile dependencies.

# # Turn off the firewall and selinux

Sometimes start no problem, but just can not see , because the firewall and selinux open.

You can turn off the firewall using the following method :

`` `bash
# Disable the firewall
sudo / etc / init.d / iptables stop
sudo / sbin / chkconfig iptables off
`` `

selinux also need to disable, run the command `getenforce`, if it is Disabled, perform the following steps :

1 Edit the configuration file :. `Sudo vi / etc / sysconfig / selinux`
1 changed the value of SELINUX disabled: `SELINUX = disabled`
1 Reboot the system : `sudo init 6`

# # Compiler and start

After determining what compiler options used ( refer below) , compiled SRS is actually very simple. Only RTMP and HLS:

`` `
. / configure && make
`` `

Specify the configuration file , you can start SRS:

`` `bash
. / objs / srs-c conf / srs.conf
`` `

Push RTMP streaming and viewing , reference [Usage: RTMP] (https://github.com/winlinvip/simple-rtmp-server/wiki/SampleRTMP)

More use, reference [Usage] (https://github.com/winlinvip/simple-rtmp-server # usage)

# # Compiler options and presets

SRS provides a detailed compilation options to control the function of the switch , as well as providing some useful default, the default options for different application scenarios .

SRS will first apply the default set , and then apply the user's option , for example :. `/ Configure - rtmp-hls - with-http-api`, apply the following order:
* First application presets : - rtmp-hls, open ssl / hls, other features are turned off.
* Application user options : - with-http-api, open the http api interface.

So the last compile command support functions are : RTMP + HLS + HTTP Interface

The default set of references to support the end of the argument list , or execute :. `/ Configure-h` view .

# # Jobs: Acceleration Compiler

Because when you configure SRS need to compile ffmpeg / nginx, this will be a long process , if you have multiple core machine , you can use jobs to parallel compilation .
* Configure: srs -dependent tools at compile time can be compiled in parallel .
* Make: srs can be used when compiling the parallel compilation .

Parallel and serial srs compile compile projects include (srs will automatically determine , without user specified ) :
* Srs: supports parallel compilation.
* St-1.9: Serial compiled library is relatively small, the compilation time is very short.
* Http-parser: serial compiler , libraries is relatively small, the compilation time is very short.
* Openssl: Serial compilation, parallel compilation problems.
* Nginx: supports parallel compilation.
* Ffmpeg: supports parallel compilation.
* Lame: supports parallel compilation. mp3 used ffmpeg library .
* Libaacplus: Serial compilation, parallel compilation problems. aac used ffmpeg library .
* X264: supports parallel compilation. x264 used ffmpeg library .

configure using the parallel compiled as follows:

`` `bash
. / configure - jobs = 16
`` `

Note : configure does not support make that kind of "-jN", only support "- jobs [= N]".

make use of parallel compilation method is as follows :

`` `bash
/ / Or make - jobs = 16
make-j16
`` `

# # Package

SRS provides a packaged script that can be srs packed ( not included nginx / ffmpeg and other external program ) . Installation packages are also available for download , refer to the beginning of this article .

Packaged script will compile srs, srs file and then packaged as a zip (zip than tar Universal ) . Help package of detailed reference :

`` `bash
. [winlin @ dev6 srs] $ / scripts / package.sh - help

  - help print this message

  -. arm configure with arm and make srs use arm tools to get info.
  - no-build donot build srs, user has builded only make install..
`` `

# # SRS dependency

SRS relies on g+ + / gcc / make, st-1.9, http-parser2.1, ffmpeg, cherrypy, nginx, openssl-devel, python2.

Some rely can configure configuration script off the table below:

<table>
<tr>
<td> <strong> function </ strong> </ td>
<td> <strong> Options </ strong> </ td>
<td> <strong> compile </ strong> </ td>
<td> <strong> dependent libraries </ strong> </ td>
<td> <strong> Description </ strong> </ td>
</ tr>
<tr>
<td> compiler </ td>
<td> Required </ td>
<td> None </ td>
<td> linux, g+ +, gcc, make </ td>
<td> -based build environment </ td>
</ tr>
<tr>
<td> RTMP (Basic) </ td>
<td> Required </ td>
<td> None </ td>
<td> st-1.9 </ td>
<td> RTMP servers , st basis for dealing with concurrency library <br/> forward, vhost, refer, reload the basis functions. <br/> <br/> st-1.9 is no longer dependent on other libraries can be compiled under various linux, <br/> tested are CentOS4/5/6, Ubuntu12, Debian-Armhf, <br/> other problems arose <br/>
Reference : <a href="https://github.com/winlinvip/simple-rtmp-server/wiki/DeliveryRTMP"> DeliveryRTMP </ td>
</ tr>
<tr>
<td> RTMP <br/> (H.264/AAC) </ td>
<td> optional </ td>
<td> - with-ssl </ td>
<td> ssl </ td>
<td> RTMP distribute H.264/AAC, the need to support <a href="http://blog.csdn.net/win_lin/article/details/13006803"> complex handshake </ a> <br/> <br / > contents of a simple handshake to 1537 -byte random number , <br/> and complex handshake to encrypt data according to certain rules <br/> <br/> srs using ssl library <br/> own compilation
Reference : <a href="https://github.com/winlinvip/simple-rtmp-server/wiki/RTMPHandshake"> RTMPHandshake </ td>
</ tr>
<tr>
<td> HLS </ td>
<td> optional </ td>
<td> - with-hls \ <br/>
- with-nginx </ td>
<td> nginx </ td>
<td> - with-hls <br/> sliced ​​into the RTMP stream ts, and generate m3u8, <br/> that AppleHLS flow distribution. Reference : <a href="https://github.com/winlinvip/simple-rtmp-server/wiki/DeliveryHLS"> HLS </ a> <br/> <br/>
- with-nginx <br/> compiles open this feature <a href="http://nginx.org/"> nginx </ a>, <br/> distribute m3u8 and ts by nginx static files <br / >
Reference : <a href="https://github.com/winlinvip/simple-rtmp-server/wiki/DeliveryHLS"> DeliveryHLS </ a>
</ td>
</ tr>
<tr>
<td> FFMPEG </ td>
<td> optional </ td>
<td> - with-ffmpeg </ td>
<td> ffmpeg <br/> (libaacplus, <br/> lame, yasm, <br/> x264, ffmpeg) </ td>
<td> transcoding , transfer package, collection tools , <br/> FFMPEG rely on too many projects , <br/> and linux on older versions of these libraries are difficult to compile successfully , <br/> <br/> So if need transcoding function , the proposed closure of this feature , <br/> transcoding if necessary , recommend the use of CentOS6. * / Ubuntu12 system <br/>
Reference : <a href="https://github.com/winlinvip/simple-rtmp-server/wiki/FFMPEG"> FFMPEG </ a> </ td>
</ tr>
<tr>
<td> Transcode </ td>
<td> optional </ td>
<td> - with-transcode </ td>
<td> <br/> transcoding tools such as FFMPEG </ td>
Specify your own tools <br/> <td> output after the transfer code RTMP RTMP streams , <br/> generally need FFMPEG transcoding tool , <br/> or disable FFMPEG
Reference : <a href="https://github.com/winlinvip/simple-rtmp-server/wiki/FFMPEG"> FFMPEG </ a> </ td>
</ tr>
<tr>
<td> Ingest </ td>
<td> optional </ td>
<td> - with-ingest </ td>
<td> collection <br/> tools such as FFMPEG </ td>
Specify your own tools <br/> after <td> the file / stream / device data is pushed to crawl SRS, <br/> general collection needs FFMPEG tool , <br/> or disable FFMPEG
Reference : <a href="https://github.com/winlinvip/simple-rtmp-server/wiki/Ingest"> Ingest </ a> </ td>
</ tr>
<tr>
<td> HttpCallback </ td>
<td> optional </ td>
<td> - with-http-callback </ td>
<td> cherrypy <br/> http-parser2.1 <br/> python2 </ td>
<td> when certain events occur , SRS can call the http address <br/> <br/> example, the client connects to the server , SRS will call <br/> on_connect interfaces , SRS comes with a <br/> research / api-server ( using Cherrypy), <br/> provides a default implementation of these http api . <br/> <br/> addition, if opened HttpCallback, <br/> players will jump to the default presentation api-server <br/> <br/> http-parser2.1 compilation problems in a variety of linux not large <br/> <br/> python2.6/2.7 in CentOS6/Ubuntu12 only , <br/> so CentOS5 start HttpCallback will be reported json module can not find <br/>
Reference : <a href="https://github.com/winlinvip/simple-rtmp-server/wiki/HTTPCallback"> HTTPCallback </ td>
</ tr>
<tr>
<td> HttpServer </ td>
<td> optional </ td>
<td> - with-http-server </ td>
<td> http-parser2.1 </ td>
<td> SRS embedded in a web server , the basic http protocol , <br/> mainly for document distribution . <br/>
Reference : <a href="https://github.com/winlinvip/simple-rtmp-server/wiki/HTTPServer"> HTTPServer </ a> </ td>
</ tr>
<tr>
<td> HttpApi </ td>
<td> optional </ td>
<td> - with-http-api </ td>
<td> http-parser2.1 </ td>
<td> SRS provides http-api ( embedded web server ), <br/> support http managed server. <br/>
Reference : <a href="https://github.com/winlinvip/simple-rtmp-server/wiki/HTTPApi"> HTTPApi </ a> </ td>
</ tr>
<tr>
<td> ARM </ td>
<td> optional </ td>
<td> - with-arm-ubuntu12 </ td>
<td> no additional dependent </ td>
<td> SRS runs on ARM, <br/> If you need support <a href="https://github.com/winlinvip/simple-rtmp-server/wiki/RTMPHandshake"> complex handshake </ a> you need dependence ssl, <br/> currently Ubuntu12 compiled , <br/> debian-armhf (v7cpu) under test <br/>
Reference : <a href="https://github.com/winlinvip/simple-rtmp-server/wiki/SrsLinuxArm"> SrsLinuxArm </ td>
</ tr>
<tr>
<td> librtmp </ td>
<td> optional </ td>
<td> - with-librtmp </ td>
<td> no additional dependent </ td>
<td> SRS provides client libraries <a href="https://github.com/winlinvip/simple-rtmp-server/wiki/SrsLibrtmp"> srs-librtmp </ a>, <br/> If you need support < a href = "https://github.com/winlinvip/simple-rtmp-server/wiki/RTMPHandshake"> complicated handshake </ a> you need to rely on ssl, <br/> support RTMP client push flow SRS, or play RTMP stream <br/> <br/> srs-librtmp use synchronization socket, protocol stacks and SRS <br/> consistent service side , and librtmp as only suitable for the client , <br/> not be used as the server . <br/>
Reference : <a href="https://github.com/winlinvip/simple-rtmp-server/wiki/SrsLibrtmp"> SrsLibrtmp </ td>
</ tr>
<tr>
<td> DEMO </ td>
<td> optional </ td>
<td> - with-ssl \ <br/> - with-hls \ <br/> - with-nginx \ <br/> - with-ffmpeg \ <br/> - with-transcode <br /> </ td>
<td> nginx / cherrypy </ td>
<td> SRS demo player / output stream transcoder / encoder / video conferencing , <br/> because of the need http server, so dependent on nginx, <br/> <br/> addition, video conferencing because of the need to know we publish the stream name , <br/> so need HttpCallback support <br/>
Reference : <a href="https://github.com/winlinvip/simple-rtmp-server/wiki/SampleDemo"> SampleDemo </ td>
</ tr>
<tr>
<td> GPERF </ td>
<td> optional </ td>
<td> - with-gperf </ td>
<td> gperftools </ td>
<td> use Google's tcmalloc memory allocation library , <br/> gmc / gmp / gcp rely on this option , refer to : <a href = "https://github.com/winlinvip/simple-rtmp-server/wiki/GPERF "> GPERF </ a> </ td>
</ tr>
<tr>
<td> GPERF (GMC) </ td>
<td> optional </ td>
<td> - with-gmc </ td>
<td> gperftools </ td>
<td> memory check gperf-memory-check, <br/> gmc rely gperf, Reference : <a href="https://github.com/winlinvip/simple-rtmp-server/wiki/GPERF"> GPERF </ a> </ td>
</ tr>
<tr>
<td> GPERF (GMP) </ td>
<td> optional </ td>
<td> - with-gmp </ td>
<td> gperftools </ td>
<td> memory performance analysis gperf-memory-profile, <br/> gmp dependent gperf, Reference : <a href="https://github.com/winlinvip/simple-rtmp-server/wiki/GPERF"> GPERF < / a> </ td>
</ tr>
<tr>
<td> GPERF (GCP) </ td>
<td> optional </ td>
<td> - with-gcp </ td>
<td> gperftools </ td>
<td> CPU performance analysis gperf-cpu-profile, <br/> gcp rely gperf, Reference : <a href="https://github.com/winlinvip/simple-rtmp-server/wiki/GPERF"> GPERF < / a> </ td>
</ tr>
<tr>
<td> GPROF </ td>
<td> optional </ td>
<td> - with-gprof </ td>
<td> gprof </ td>
<td> GNU CPU profile performance analysis tools , <br/> Reference : <a href="https://github.com/winlinvip/simple-rtmp-server/wiki/GPROF"> GPROF </ a> </ td >
</ tr>
</ table>

# # Custom compiler arguments

SRS can customize the compiler, such as arm compiled using arm-linux-g + + instead of g+ +. Reference [ARM: manual compilation ] (https://github.com/winlinvip/simple-rtmp-server/wiki/SrsLinuxArm #% E6% 89% 8B% E5% 8A% A8% E7% BC% 96% E8% AF % 91srs)

Note : SRS and ST variables can be set by the compiler before compilation, but ssl need to manually modify Makefile. Fortunately, not every compile ssl .

# # Compiler generates the project

configure and make will generate a number of projects in objs directory. Some files in the research catalog , configure will automatically link to the soft objs directory.

HttpCallback ( its server api-server) directories for research / api-server, did not do a soft chain can be started directly . Detailed reference to the following method.

<table>
<tr>
<td> <strong> generation projects </ strong> </ td>
<td> <strong> use </ strong> </ td>
<td> <strong> Description </ strong> </ td>
</ tr>
<tr>
<td>. / objs / srs </ td>
<td>. / objs / srs-c conf / srs.conf </ td>
<td> start SRS server </ td>
</ tr>
<tr>
<td>. / objs / bandwidth </ td>
<td>. / objs / bandwidth-h </ td>
<td> linux speed tool </ td>
</ tr>
<tr>
<td>. / objs / nginx </ td>
<td> sudo. / objs / nginx / sbin / nginx </ td>
<td> HLS / DEMO used nginx server </ td>
</ tr>
<tr>
<td> api-server </ td>
<td> python research / api-server / server.py 8085 </ td>
<td> start HTTP hooks and DEMO video conferencing used api-server </ td>
</ tr>
<tr>
<td> FFMPEG </ td>
<td>. / objs / ffmpeg / bin / ffmpeg </ td>
<td> SRS transcoding using FFMPEG, DEMO flowmakers also use it </ td>
</ tr>
<tr>
<td> librtmp </ td>
<td>. / objs / include / srs_librtmp.h <br/>
. / objs / lib / srs_librtmp.a </ td>
<td> SRS provides client libraries , reference <a href="https://github.com/winlinvip/simple-rtmp-server/wiki/SrsLibrtmp"> srs-librtmp </ a> </ td>
</ tr>
<tr>
<td> DEMO <br/> ( closed HttpCallback) </ td>
<td>. / objs / nginx / html / players </ td>
<td> SRS of DEMO static page , when there is no open HttpCallback </ td>
</ tr>
<tr>
<td> DEMO <br/> ( open HttpCallback) </ td>
<td> research / api-server / static-dir / players </ td>
<td> SRS of DEMO static pages , <br/> inside and nginx static directory is a directory , a soft link to research / players, <br/> 1 when HttpCallback open . (- with-http-callback), <br/> nginx 's default index.html will jump to HttpCallback home , <br/> because DEMO video conferencing needs HttpCallback, <br/> 2. If HttpCallback not open , <br/> default browsing Nginx is inside dEMO, <br/> certainly will not be a video conference presentation </ td>
</ tr>
</ table>

# # Configuration parameters

SRS configuration (configure) parameters are as follows :
* - Help configure help information
* - With-ssl add ssl support , ssl to support complex handshake. Reference : [RTMP Handshake] (https://github.com/winlinvip/simple-rtmp-server/wiki/RTMPHandshake).
* - With-hls support HLS output , slicing into the RTMP stream ts, can be used to support mobile end HLS (IOS / Android), but the PC side jwplayer also support HLS. Reference : [HLS] (https://github.com/winlinvip/simple-rtmp-server/wiki/DeliveryHLS)
* - With-dvr recording support RTMP stream into FLV. Reference : [DVR] (https://github.com/winlinvip/simple-rtmp-server/wiki/DVR)
* - With-nginx compile nginx, using nginx web server as HLS distribute documents and demo static pages and so on.
* - With-http-callback support http callback interface for authentication , statistics, event processing. Reference : [HTTP callback] (https://github.com/winlinvip/simple-rtmp-server/wiki/HTTPCallback)
* - With-http-api open HTTP management interface . Reference : [HTTP API] (https://github.com/winlinvip/simple-rtmp-server/wiki/HTTPApi)
* - With-http-server to open the built-in HTTP server to support HTTP streaming distribution . Reference : [HTTP Server] (https://github.com/winlinvip/simple-rtmp-server/wiki/HTTPServer)
* - With-ffmpeg compiled transcoding / rpm package / collection tool FFMPEG used . Reference : [FFMPEG] (https://github.com/winlinvip/simple-rtmp-server/wiki/FFMPEG)
* - With-transcode live transfer code function . Need to specify transcoding tool in the configuration. Reference : [FFMPEG] (https://github.com/winlinvip/simple-rtmp-server/wiki/FFMPEG)
* - With-ingest capture file / stream / device data package for the RTMP streams , the push to SRS. Reference : [Ingest] (https://github.com/winlinvip/simple-rtmp-server/wiki/Ingest)
* - With-research is compiled research directory files , research directory is some research, such as ts info is doing research HLS ts standards. And SRS function does not matter, for reference only .
* - Unit testing is compiled with-utest SRS , the default is on, you can turn off .
* - With-gperf whether to use google 's tcmalloc library , off by default .
* - With-gmc whether to use gperf memory testing, start srs detects memory errors after compilation. This option will result in poor performance , if only to find memory leaks should be open . Default is off. Reference : [gperf] (https://github.com/winlinvip/simple-rtmp-server/wiki/GPERF)
* - With-gmp whether to use gperf memory performance analysis, memory analysis report will be generated when srs quit after compilation. This option will lead to performance and should only be turned on when tuning. Default is off. Reference : [gperf] (https://github.com/winlinvip/simple-rtmp-server/wiki/GPERF)
* - Whether with-gcp CPU performance gperf analysis will generate CPU analysis reports compiled srs exit enabled . This option will lead to performance and should only be turned on when tuning. Default is off. Reference : [gperf] (https://github.com/winlinvip/simple-rtmp-server/wiki/GPERF)
* - With-gprof gprof profiling is enabled , srs CPU analysis report will be generated after compilation. This option will lead to performance and should only be turned on when tuning. Default is off. Reference : [gprof] (https://github.com/winlinvip/simple-rtmp-server/wiki/GPROF)
* - With-librtmp client push streaming / playback library reference [srs-librtmp] (https://github.com/winlinvip/simple-rtmp-server/wiki/SrsLibrtmp)
* - With-arm-ubuntu12 cross compiler running on ARM SRS, requires the system is Ubuntu12. Reference [srs-arm] (https://github.com/winlinvip/simple-rtmp-server/wiki/SrsLinuxArm)
* - Jobs [= N] opened several compilation process , and make the -j (- jobs) , as may be compiled during configure nginx / ffmpeg and other tools, you can open multiple jobs to compile, can significantly accelerate. Reference : [Build: jobs] (https://github.com/winlinvip/simple-rtmp-server/wiki/Build # wiki-jobs% E5% 8A% A0% E9% 80% 9F% E7% BC% 96% E8% AF% 91)
* - Static use static links. When specifying arm compiler will automatically turn on this option. Users need to manually compile itself open. Reference : [ARM] (https://github.com/winlinvip/simple-rtmp-server/wiki/SrsLinuxArm)

The default set:
* - X86-x64, the default presets , the general x86 or x64 server. release compiled using this configuration .
* - Pi, raspberry pie presets , arm subset. Raspberry faction release compiled with this configuration .
* - Arm, under ubuntu cross-compiler , is equivalent to the - with-arm-ubuntu12. release using this configuration.
* - Dev, development options , as opening function .
* - Fast, turn off all functions , only supports basic RTMP ( not supported h264/aac), the fastest compilation speed .
* - Pure-rtmp, support RTMP ( support h264 + aac), you need to compile ssl.
* - Rtmp-hls, support RTMP and HLS, typical application mode . You can also add built-in http server (- with-http-server).
* - Disable-all, disable all functions only support rtmp (vp6).

Expert Options : There may fail to compile , not an expert not use this .
* - Use-sys-ssl to use the system ssl, not separately compiled ssl ( in the - with-ssl when effective ) .

Winlin 2014.2