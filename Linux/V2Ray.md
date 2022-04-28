# V2Ray的相关笔记整理
> https://www.itblogcn.com/article/1501.html


## 环境信息:
服务器系统：CentOS 7 以上版本系统兼容本教程
VPS：Vultr


## V2Ray搭建
简易安装:
``` Linux
bash <(curl -s -L https://git.io/v2ray-setup.sh)
```
自定义安装:
``` Linux
bash <(curl -s -L https://git.io/v2rayinstall.sh)
```

显示以下信息表示安装成功:
``` 
---------- V2Ray 配置信息 -------------

 地址 (Address) = 207.148.27.37

 端口 (Port) = 8080

 用户ID (User ID / UUID) = 20be1f8e-2169-4aa1-843e-5ead4250a9f7

 额外ID (Alter Id) = 0

 传输协议 (Network) = kcp

 伪装类型 (header type) = dtls

---------- END -------------

V2Ray 客户端使用教程: https://git.io/v2ray-client

提示: 输入 v2ray url 可生成 vmess URL 链接 / 输入 v2ray qr 可生成二维码链接

---------- V2Ray vmess URL / V2RayNG v0.4.1+ / V2RayN v2.1+ / 仅适合部分客户端 -------------

vmess://ewoidiI6I*****g==
```

配置信息记得如下配置,
尝试tcp协议以及未使用type,最终无法使用,
所以严格按照以下要求:
```
Network(传输协议)： kcp
type(伪装类型)：dtls
```
查看配置文件:
``` Linux
cat /etc/v2ray/config.json
```

生成vmess的url链接:
``` Linux
v2ray url
```

v2ray的相关命令格式:
``` Linux
v2ray info 查看 V2Ray 配置信息
v2ray config 修改 V2Ray 配置
v2ray link 生成 V2Ray 配置文件链接
v2ray infolink 生成 V2Ray 配置信息链接
v2ray qr 生成 V2Ray 配置二维码链接
v2ray ss 修改 Shadowsocks 配置
v2ray ssinfo 查看 Shadowsocks 配置信息
v2ray ssqr 生成 Shadowsocks 配置二维码链接
v2ray status 查看 V2Ray 运行状态
v2ray start 启动 V2Ray
v2ray stop 停止 V2Ray
v2ray restart 重启 V2Ray
v2ray log 查看 V2Ray 运行日志
v2ray update 更新 V2Ray
v2ray update.sh 更新 V2Ray 管理脚本
v2ray uninstall 卸载 V2Ray
```


### 客户端链接V2Ray
下载页面:
> https://github.com/xyz690/v2ray
> https://github.com/xyz690/v2ray/wiki/V2Ray%E5%AE%A2%E6%88%B7%E7%AB%AF%E4%BD%BF%E7%94%A8%E6%95%99%E7%A8%8B#macos-v2ray%E5%AE%A2%E6%88%B7%E7%AB%AF

MacOS v2ray客户端:
> https://github.com/Cenmrev/V2RayX/releases


