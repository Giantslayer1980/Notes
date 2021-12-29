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

