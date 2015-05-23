[**HOME**](Home) > [**EN(1.0)**](v1_EN_Home) > [**Git**](v1_EN_Git)

# Git Usage

How to use stable version of SRS? How to update code?

## Checkout Branch

Some features are introduced in SRS2.0, the SRS1.0 does not support.
The wiki url specifies the version of SRS supports it.

To checkout SRS1.0 branch:

```
git pull && git checkout 1.0release
```

To checkout SRS2.0 branch:

```
git pull && git checkout 2.0release
```

To checkout SRS3.0 branch(if no 3.0release branch, it's develop):

```
git pull && git checkout develop
```

Note: The master branch is main release.

## SRS Branches

Each release will branch with hotfix, for example, 1.0release with latest bug fixed.

The main stable branch is the main release branch. The hotfixes will be merged from release to master every 1 or 2 months. For example, the hotfixes of 1.0release will be merged to master for 1.0r1, 1.0r2 to 1.0rN.

The develop is the dev branch, for example, 2.0 dev branch.

The stable is: master >= 1.0release >> develop.

## How to get code?

User can git clone the SRS project:

```bash
git clone https://github.com/simple-rtmp-server/srs
```

Mirrors: https://github.com/simple-rtmp-server/srs/tree/1.0release#mirrors

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

![srs branch](http://winlinvip.github.io/srs.release/wiki/images/srs.branches.png)

Master is the main stable branch. Release is each release with bug fixed. Develop is the development branch.

![Git Branch Model](http://winlinvip.github.io/srs.release/wiki/images/git.branch.png)

Refer to [http://nvie.com/posts/a-successful-git-branching-model/](http://nvie.com/posts/a-successful-git-branching-model/)

Refer to [http://blog.csdn.net/sabalol/article/details/7049851](http://blog.csdn.net/sabalol/article/details/7049851)

Winlin 2014.11
