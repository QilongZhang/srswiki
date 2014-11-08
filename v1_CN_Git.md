# GIT使用和代码更新

如何选择SRS的稳定版本？如何更新代码？

## Checkout Branch

有些功能只有SRS2.0有，SRS1.0没有，请注意看wiki是v1还是v2的。

如果是1.0的功能，更新代码后要改变到1.0分支：

```
git pull && git checkout 1.0release
```

如果是2.0的功能，更新代码后要改变到2.0分支（没有2.0release就是master）：

```
git pull && git checkout master
```

## SRS稳定版本

目前还没有稳定版本，还在测试中。

## 如何获取SRS最新代码

你可以从github获取SRS的代码，需要先安装git（如何安装git可以百度下）。

安装好git后，执行以下命令获取SRS最新代码：

```bash
git clone https://github.com/winlinvip/simple-rtmp-server
```

## 如何更新SRS最新代码

SRS包含的软件很多，不需要额外下载其他的包就可以编译。所以第一次从github上下载后，不需要每次都git clone，用以下命令即可更新：

```bash
git pull
```

另外，不需要删除objs后编译srs，只需要make就可以编译。若make出错，则执行configure之后再make，可能有配置项更新。

## 如何和主分支保持同步

fork之后，可以在github上点击pull request和主分支保持同步。

下面以和angularjs同步为例，我fork了angularjs，然后一个月之后和主分支同步。

**step 1：点击pull request**

![pull request](http://winlinvip.github.io/srs.release/wiki/images/sync.master/01.pull.png)

**step 2: 切换为同步模式**

![switch to sync](http://winlinvip.github.io/srs.release/wiki/images/sync.master/02.switch.png)

默认是将你的修改同步给作者，也就是作者在左边，你的修改在右边。

点击`switching the base`会将你放在左边，作者放在右边，同步总是从右边同步到左边。

**step 3: 提交同步请求**

![create pull request](http://winlinvip.github.io/srs.release/wiki/images/sync.master/03.create.png)

点击`Create pull request`按钮，开始将作者的修改同步到你的github分支。

注意：点击一次后开始发起请求，有时候请求完了也没有响应，再点一次`Create pull request`按钮就好了。

**step 4: 创建请求**

![create pull request](http://winlinvip.github.io/srs.release/wiki/images/sync.master/04.create2.png)

输入信息，点击`Create pull request`按钮。

**step 5: 创建请求成功**

![create pull request](http://winlinvip.github.io/srs.release/wiki/images/sync.master/05.create3.png)

可以看到成功创建了同步请求，提交到自己的分支的pull request中了。

拖动滚动条到页面最后，开始合并请求，即和作者同步。

**step 6: 合并修改**

![merge pull request](http://winlinvip.github.io/srs.release/wiki/images/sync.master/06.merge.png)

点击按钮合并请求。

**step 7: 确认合并**

![merge confirm](http://winlinvip.github.io/srs.release/wiki/images/sync.master/07.merge2.png)

**step 8: 同步成功**

![sync ok](http://winlinvip.github.io/srs.release/wiki/images/sync.master/08.ok.png)

然后在自己的虚拟机上`git pull`就可以将自己的github的项目同步到虚拟机。

## 为何更新失败？

如果本地有修改，譬如改了SRS的代码，那么git pull会提示无法更新。这时候可以撤销所有本地的修改，然后更新：

```
git reset --hard
git pull
```

注意，这个会导致所有的修改都丢弃，只适用于不需要保留修改代码的情况。如果你需要提交代码，请参考git详细的用法。

## CSDN-Mirror

SRS在CSDN上有镜像，参考网址：https://code.csdn.net/winlinvip/srs-csdn

SRS会不定期将代码更新到CSDN，基本上是同步的。csdn的git仓库是：

```bash
git clone https://code.csdn.net/winlinvip/srs-csdn.git
```

可以在CSDN上建立自己的仓库，然后和github上的srs同步，可以运行脚本：

```bash
bash scripts/csdn.mirror.sh 
```

可以参考脚本中的提示，创建自己的分支，每次可执行该脚本和github的srs同步。

## BranchAndTag

一个仓库(project/repository)可以有多个branch，每个branch上都可以有tag（里程碑，一般release分支有）。

SRS使用的branch策略稍微不一样，SRS不会同时开发多个版本，所以没有feature分支；也没有hotfix分支，直接在对应的release分支hotfix后打tag；SRS也没有develop分支，把master作为develop分支。

SRS只有master（develop）和release分支，假设现在是SRS4.0时代，那么master就是正在开发的SRS4.0，有三个release分支分别是1.0release、2.0release和3.0release。

SRS的默认分支是最新的release，github上可以设置默认分支（由于master和develop是一个分支）。

也就是说SRS的master是开发版，其他的release分支是发行版；默认的是最新的发行版。这个是最简单的git分支使用了。

![Git Branch Model](http://winlinvip.github.io/srs.release/wiki/images/git.branch.png)

参考：[http://nvie.com/posts/a-successful-git-branching-model/](http://nvie.com/posts/a-successful-git-branching-model/)

参考：[http://blog.csdn.net/sabalol/article/details/7049851](http://blog.csdn.net/sabalol/article/details/7049851)

Winlin 2014.3