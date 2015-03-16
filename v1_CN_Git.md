[**HOME**](Home) > [**CN(1.0)**](v1_CN_Home) > [**Git**](v1_CN_Git)

# GIT使用和代码更新

如何选择SRS的稳定版本？如何更新代码？

## Checkout Branch

有些功能只有SRS2.0有，SRS1.0没有，请注意看wiki是v1还是v2的。

如果是1.0的功能，更新代码后要改变到1.0分支：

```
git pull && git checkout 1.0release
```

如果是2.0的功能，更新代码后要改变到2.0分支：

```
git pull && git checkout 2.0release
```

如果是3.0的功能，更新代码后要改变到3.0分支（没有单独的3.0release分支就是develop）：

```
git pull && git checkout develop
```

注意：master是作为稳定版本分支。

## SRS Branches

稳定的SRS版本会新建branch，譬如1.0release。1.0release是1.0的release，有最新的bug fix。

Master分支是主要的release，目前就是1.0。对比1.0release分支，master分支bug fix频率低，每隔1-2个月会集中merge 1.0release的bug fix到master。

develop是开发版，目前是2.0。

所以稳定度master >= 1.0release >> develop.

## 如何获取SRS代码

注意：中国国内访问github慢，可以使用oschina或csdn镜像，参考下面的其他镜像。

你可以从github获取SRS的代码，需要先安装git（如何安装git可以百度下）。

安装好git后，执行以下命令获取SRS最新代码：

```bash
git clone https://github.com/winlinvip/simple-rtmp-server
```

其他镜像git地址: https://github.com/winlinvip/simple-rtmp-server/tree/1.0release#mirrors

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

## BranchAndTag

一个仓库(project/repository)可以有多个branch，每个commit都可以作为tag（里程碑，一般release分支有）。

SRS使用的branch策略稍微不一样，SRS不会同时开发多个版本，所以没有feature分支；也没有hotfix分支，直接在对应的release分支hotfix后打tag。

SRS只有master，develop和release分支；master是主要的稳定版本分支，release是各个稳定版本的分支，develop是开发版分支。

![srs branch](http://winlinvip.github.io/srs.release/wiki/images/srs.branches.png)

譬如，develop开发分支在准备Release1.0时，打出Release1.0分支，冻结功能，测试并发布。Release发布后，merge到master作为主要版本发布。

![Git Branch Model](http://winlinvip.github.io/srs.release/wiki/images/git.branch.png)

参考：[http://nvie.com/posts/a-successful-git-branching-model/](http://nvie.com/posts/a-successful-git-branching-model/)

参考：[http://blog.csdn.net/sabalol/article/details/7049851](http://blog.csdn.net/sabalol/article/details/7049851)

## GIT常用命令

### 撤销commit

撤销上次commit（还没有push到服务器时，只是commit到本地git）：

```
git reset --soft HEAD~1
```

执行完后`git status`可以看到有修改的文件，就回退到了`git commit`之前的状态了。

### 撤销push

若已经push到了服务器，就没法撤销commit了，只能撤销本地的commit。

git提供了一个方案，再次提交一次commit正好和上次commit相反，这样的效果也是撤销了：

```
git revert HEAD~1
```

执行完后`git status`可以看到有新的修改，用来覆盖上次的commit。

Winlin 2014.3