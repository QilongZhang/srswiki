# 集成开发环境

Windows平台，一般中国开发者用IDE还是windows，用什么IDE？推荐如下：
* 建议windows平台：见过有些开发者喜欢用ubuntu的桌面版，说实在的，linux还是擅长服务器，做桌面还不是那么专业。当然mac比windows好，一般来讲，还是windows。
* C代码建议用SI(SourceInsight)：C的跳转，函数定义，SourceInsight都很方便。参考：[SourceInsight](http://sourceinsight.com/)
* C++代码，建议用UltimateC++：主要是SI对于C++的类函数声明和定义跳转不方便，有些宏定义也解析有问题，对于类成员函数的代码提示也不完善，总之，C++那些特性，还是UltimateC++做得好些。参考：[UltimateC++(http://www.ultimatepp.org/)
* SRS是使用UltimateC++做IDE开发的，VS.net也很好不过会在源码目录生成一堆东西，很麻烦。直接设置Assemble的目录为srs/src就可以代码，譬如：Q:\simple-rtmp-server\trunk\src
* SRS编译和调试当然还是在linux，windows下只是编辑，让他们做各自擅长的事情。

我也比较过其他的IDE，可以参考：[开源日志：关于IDE/源代码编辑](http://blog.csdn.net/win_lin/article/details/8142981)

## UPP开发SRS

SRS使用UPP的开发，好处是：
* 只需要一个配置文件，不会在源码生成乱七八糟的文件。像vs之类就讨厌这个。
* 不编译，只用来编辑代码，因为windows下面编译过不了。在linux编译和调试。
* hpp和cpp之间跳转方便，可以方便的在类成员函数和实现之间跳转。
* 解析宏定义，类定义和函数，模板函数等等，解析都正确，不像SourceInsight解析不对。

下面讲讲使用过程：

<strong>第一步，下载和安装upp</strong>

http://sourceforge.net/project/downloading.php?group_id=93970&filename=upp-win32-5485.exe

<strong>第二步，打开UPP后，新建assembly</strong>

![新建assembly](http://winlinvip.github.io/srs.release/wiki/images/upp/001.new.assembly.png)

<strong>第三步，导入srs</strong>

![导入srs](http://winlinvip.github.io/srs.release/wiki/images/upp/002.setup.assembly.png)

![导入srs](http://winlinvip.github.io/srs.release/wiki/images/upp/003.open.assembly.png)

<strong>OK</strong>

![导入srs](http://winlinvip.github.io/srs.release/wiki/images/upp/004.ok.png)

<strong>设置智能补全键，按CTRL+J出现说明</strong>4

默认的智能补全键是CTRL+空格键，这个组合键实际上用来切换输入法。

打开 Setup=>Keyboard shortcuts，找到Assist并设置（在最后），设置如下图：

![智能补全键](http://winlinvip.github.io/srs.release/wiki/images/upp/005.assist.shortcuts.png)

非常简单！

Winlin 2014.2