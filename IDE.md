# 集成开发环境

Windows平台，一般中国开发者用IDE还是windows，用什么IDE？推荐如下：
* 建议windows平台：见过有些开发者喜欢用ubuntu的桌面版，说实在的，linux还是擅长服务器，做桌面还不是那么专业。当然mac比windows好，一般来讲，还是windows。
* C代码建议用SI(SourceInsight)：C的跳转，函数定义，SourceInsight都很方便。参考：[SourceInsight](http://sourceinsight.com/)
* C++代码，建议用UltimateC++：主要是SI对于C++的类函数声明和定义跳转不方便，有些宏定义也解析有问题，对于类成员函数的代码提示也不完善，总之，C++那些特性，还是UltimateC++做得好些。参考：[UltimateC++(http://www.ultimatepp.org/)
* SRS是使用UltimateC++做IDE开发的，VS.net也很好不过会在源码目录生成一堆东西，很麻烦。直接设置Assemble的目录为srs/src就可以代码，譬如：Q:\simple-rtmp-server\trunk\src

我也比较过其他的IDE，可以参考：[开源日志：关于IDE/源代码编辑](http://blog.csdn.net/win_lin/article/details/8142981)