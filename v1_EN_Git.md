# Git Usage

How to use stable version of SRS? How to update code?

## Checkout Branch

Some features are introduced in SRS2.0, the SRS1.0 does not support.
The wiki url specifies the version of SRS supports it.

To checkout SRS1.0 branch:

```
git pull && git checkout 1.0release
```

To checkout SRS2.0 branch(if no 2.0release branch, it's master):

```
git pull && git checkout master
```

Note: The master branch is used as dev branch.

## SRS Stable Version

The stable SRS will create a new branch, for example, branch 1.0release.

## How to get code?

User can git clone the SRS project:

```bash
git clone https://github.com/winlinvip/simple-rtmp-server
```

Mirrors: https://github.com/winlinvip/simple-rtmp-server/tree/1.0release#mirrors

## How to update code?

Use git pull to update code, never git clone everytime.

```bash
git pull
```

Do not need to delete the objs, just update code and make. 
Use configure when make failed.

## How to sync with SRS project

When user fork the SRS repository, user can pull request to sync with me.

For example, I fork the angularjs repository, sync after a month:

**step 1：Click pull request**

![pull request](http://winlinvip.github.io/srs.release/wiki/images/sync.master/01.pull.png)

**step 2: Switch to sync mode**

![switch to sync](http://winlinvip.github.io/srs.release/wiki/images/sync.master/02.switch.png)

Default is the original project on left, to pull to original project.

Click `switching the base`, put the original project on right, to pull from original project.

**step 3: Create pull request**

![create pull request](http://winlinvip.github.io/srs.release/wiki/images/sync.master/03.create.png)

Click `Create pull request`, sync with original project.

Note: Click twice for sometimes one-click not work.

**step 4: Pull request create**

![create pull request](http://winlinvip.github.io/srs.release/wiki/images/sync.master/04.create2.png)

Input the message, Click `Create pull request`

**step 5: Pull request crote**

![create pull request](http://winlinvip.github.io/srs.release/wiki/images/sync.master/05.create3.png)

The pull request is submit to the forked repository.

Merge the pull request, sync with author.

**step 6: Merge request**

![merge pull request](http://winlinvip.github.io/srs.release/wiki/images/sync.master/06.merge.png)

Click to merge.

**step 7: Confirm merge**

![merge confirm](http://winlinvip.github.io/srs.release/wiki/images/sync.master/07.merge2.png)

**step 8: Sync ok**

![sync ok](http://winlinvip.github.io/srs.release/wiki/images/sync.master/08.ok.png)

Then, git pull on your local linux.

## Why git pull failed?

When local modified, git pull maybe failed, you can reset your changes:

```
git reset --hard
git pull
```

Note: The git reset will lost all changes.

## BranchAndTag

A project/repository can use multiple branches, and each commit can used as tag.

SRS use simple branch strategy, no feature branch, no hotfix branch.
The master is used as develop branch, each release will create branch, 
for example, 1.0release.

That is, master is develop branch, other branches is releaase.

![Git Branch Model](http://winlinvip.github.io/srs.release/wiki/images/git.branch.png)

Refer to [http://nvie.com/posts/a-successful-git-branching-model/](http://nvie.com/posts/a-successful-git-branching-model/)

Refer to [http://blog.csdn.net/sabalol/article/details/7049851](http://blog.csdn.net/sabalol/article/details/7049851)

Winlin 2014.11