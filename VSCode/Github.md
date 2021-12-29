## 本地与github进行关联
1. 检查SSHKey是否存在
2. 在本地生成SSHKey
3. 将Key添加到SSH中
4. 添加key到github的SSH设置中
5. 验证SSHKey

## 检查SSHKey是否存在
终端输入：
> ls -al ~/.ssh

其实是在找隐藏文件.ssh以及其里面的id_rsa和id_rsa.pub文件是否在目录里面。

若没找到，就需要自己生成该SSHKey了。

## 在本地生成SSHKey
在终端中输入以下代码：
> ssh-keygen -t rsa -C "your_email@example.com"

其中电子邮箱是在Github中注册的邮箱。
输入代码后会让你确认保存.ssh/id_rsa的路径，以及passphrase等，可直接enter到底，就会出现成功信息。

## 将Key添加到SSH中
终端输入：
> ssh-add ~/.ssh/id_rsa

此时，会要求输入passphrase.
成功后，终端显示：
> Identity added: /Users/xxx/.ssh/id_rsa (/Users/xxx/.ssh/id_rsa)

最后，在XXX/.ssh/中生成了两个文件：id_rsa 和 id_rsa.pub。

此时，SSHKey已经生成了。

## 添加key到github的SSH设置中
首先，复制id_rsa中的所有内容，
其次，通过vim打开id_rsa.pub，将上述复制的内容全部粘贴进id_rsa.pub：
> vim ~/.ssh/id_rsa.pub

或者复制好后不用vim来粘贴：
> pbcopy < ~/.ssh/id_rsa.pub

最后，登陆Github，打开Settings -> SSH and GPG keys -> new SSH key, 出现的输入新创立的SSH keys页面，Title随便写，Key粘贴上面复制的内容。

这样SSHKey就添加到Github中了。

## 验证SSHKey
终端输入：
> ssh git@github.com

此时会验证SSHKey是否可以访问Github，若成功则显示如下：
> Hi your_name! You've successfully authenticated, but GitHub does not provide shell access.Connection to github.com closed.

# VSCode与Github同步

1. 创建仓库
2. 复制仓库的地址(Clone with HTTPS)
3. 在本地存放项目的根目录clone仓库地址
4. 将项目新增的文件或更新的文件添加到仓库中去
5. 将以上新增加的文件commit到仓库中去
6. 将commit的代码push到远程分支中去

**git status** 命令可查看你上次提交之后是否有对文件进行过修改。
**git add** 将代码从工作区添加到暂存区。
* git add -u 表示将已跟踪文件中的修改和删除的文件添加到暂存区，不包括新增的文件
* git add -A 表示将所有的已跟踪的文件的修改与删除和新增的未跟踪的文件都添加到暂存区
* git add 不加参数默认为将修改操作的文件和未跟踪新添加的文件添加到暂存区，但不包括删除操作
* 
**git commit -m "注释"** 将暂存区内容添加到本地仓库
**git pull origin master** 将远程仓库master中的信息同步到本地仓库master中
**git push origin master** 将本地仓库master推送到远程仓库master中
* git push 如果当前分支只有一个远程分支，那么主机名都可以省略。
* git branch -r 可以查看远程的分支名
## 在本地存放项目的根目录clone仓库地址
> git clone https://github.com/xxx/xxx.git

## 将项目新增的文件添加到仓库中去
将所有文件都添加到仓库中：
> git add --all

若只想添加一个文件，则将--all替换成需要提交的文件即可:
> git add ./VSCode/Github.md

文件名强烈建议用英文，中文的话这里会出错。

## 将以上新增加的文件commit到仓库中去
> git commit -m "注释语句,比如20211229之类的都行"

## 将commit的代码push到远程分支中去
> git push

会打开github的网页让登陆授权之类的操作。

最后刷新仓库地址就能看到新增的文件了。