---
title: 树莓派 4B
date: 2022-01-15
categories: Raspberry Pi
tags:
  - Raspberry Pi
  - Linux
  - Ubuntu
  - Network
---

## Raspberry Pi 4b 安装 Ubuntu 配置 Wifi

昨天晚上想拿我的 Pi 来做 IPFS 的服务器，然后买了一张 128G 的 SD 卡，本来想着应该很快就能配置
玩系统，谁能想到，这届的博主不给力啊，或者说玩 Pi 的人比较少吧。我就是想没找到一个正确配置的博
客。

没办法咯，只能自己看下相对应的文件然后自己进行修改测试咯。

首先，需要说明一下我的配置：Raspberry Pi 4 Model B，2018。因为目前官网没有 64 bit 的
RaspberryOS，所以操作系统我用的是 Ubuntu Server 20.04.3 LTS 64 bit。

这里要提一下，我没有试过 RaspberryOS，所以我不好评价官网，毕竟我用的是 Ubuntu，同时一些博客
的 Pi 是 3B，我也没用过，所以我也不做评价。自己动手，丰衣足食。

将 SD 卡用官方提供的 [Raspberry Pi Imager][rasp] 刻录好系统，然后看下SD卡中的 README,
按照 README 中的加载顺序逐个看下去，最终确认是在根目录下中的 `network-config`
文件中，可以自己修改添加对应的网络配置。

[rasp]: https://www.raspberrypi.com/software/

> P.S. 刻录时右下方有个可以添加配置的地方，可以直接使用这个配置对用户名、主机名、网络进行
> 配置，如果使用这个配置后，刻录好后可以直接连接wifi，不需要执行下面的操作。但是要注意，
> 主机名设置好后之后如果想要修改，重启后又会恢复到一开始设置的。如果硬是要修改也可以，借助
> `rc.local` 这个服务(系统启动后会自动执行这个文件)，用 `sed` 命令对 `/etc/hosts`
> 文件进行修改。

其中有线网络的默认是已经配置成了 dhcp4，如果有网线可以直接连到路由器，那其实什么都不需要修改，
只需要插上网线，然后登陆路由器的管理界面查看对应的 IP 连接就好，连接上后按照 Ubuntu 的网络
设置配置一下无线网络就好。

但是我就是不想这么做，太麻烦了，我懒得从书包里掏出网线然后去拉线，所以我就去改了一下
`network-config`，其中  `wifi` 部分被注释掉了，我就尝试改一下，看看能不能成功，反正添加
`wpa_suppalicant.conf` 文件是没用任何用。

```yaml
version: 2
ethernets:
  eth0:
    dhcp4: true
    optional: true
wifis:
  wlan0:
    dhcp4: true
    optional: true
    access-points:
      wifi-name:
        password: "wifi-password"
      wifi-name2:
        password: "wifi-password"
```

将 `wifi-name` 和 `password` 替换成对应的 wifi 名和密码，然后保存，将 SD 卡插回 Pi，开机
等待一会就 Pi 就会连上 wifi。至于无法登陆路由器管理界面查看的，方法也很简单，就是将网络配置
换成静态 IP，具体配置参考 [netplan 配置示范](https://netplan.io/examples/)。
经过验证好像是要重启两次才能生效。

如果不想登陆路由器的管理界面的话，也可以使用 `nmap` 扫描一下，就可以定位到树莓派的 IP。

1. 查看自己的子网：`ifconfig` / `ipconfig \a` / `ip a`
2. 查询子网中开机的主机：`nmap -n -sn -T4 <subnet> -oG -`
3. 将上一步中得到的 UP 的 IP 进行 OS 嗅探：`sudo nmap -n -Pn -sS -T4 -O <ip-ranges>`

可以根据第 3 步中的结果看到 `MAC Address: xx:xx:xx:xx:xx:xx (Raspberry Pi Trading)`
的 IP 就是树莓派了。

That's all, Happy Hacking :).
