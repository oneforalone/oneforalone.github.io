---
title: CentOS 6 Utils
date: 2022-06-08
categories: CentOS
tags:
  - Linux
  - Network
  - CentOS
---

## CentOS 6 使用国内 yum 源

虽然说 CentOS 已经被收购了，但是国内还是有部分服务器使用的是 CentOS 6 的系统，这时要想安装
一些软件就会有点问题，官网给的源在国内的话速度很慢。解决办法有：

- 自己将 CentOS 的镜像下载到本地，搭建个本地源
- 替换成国内的源

方法一操作简单，这里不做介绍，记录下方法二的操作。经过一番 googling 和尝试，发现国内无论是中科
大还是网易，都没有 CentOS 6 的 yum 源了，最后发现清华大学的源很流畅。以下是 CentOS 6.10
更换清华大学源的操作。

**注：** 以下操作都是在 `root` 用户下执行的。

### 将官方源给禁掉

```bash
sed -i 's/enable=1/enable=0/g' /etc/yum.repos.d/CentOS-Base.repo
```

### 替换 vault 源

```bash
sed -i 's#vault.centos.org#mirrors.tuna.tsinghua.edu.cn/centos-vault#g' \
  /etc/yum.repos.d/CentOS-Vault.repo
```

### 生成本地缓存

```bash
yum makecache
```

这里会有多个版本的源，如果觉得太多，可以直接将除自己系统对应版本都删掉，只保留系统版本的源。即
自行删除 `/etc/yum.repos.d/CentOS-Vault.repo` 中其他版本的源。

That's it.

### Reference

[1]. [CentOS 6 镜像源更换方法](https://support.huaweicloud.com/ecs_faq/ecs_faq_1009.html)

## CentOS 6 网卡名 em -> eth

有些 Dell 的服务器和 Redhat/CentOS 组合一起就是会出现某些特殊的反应，比如，网卡名不是 `eth`
而是 `em`。这个本来也没啥大问题，但是和一些工业设计软件搭配在一起，就出了个大问题，license
激活不了。怎么解决呢？

### 修改 grub 配置文件

```bash
sed -i 's/quiet/quiet biosdevname=0/' /etc/grub.conf
```

如果对 `sed` 不熟的话，直接用 vi 或 nano 去编辑 `/etc/grub.conf`，找到以 `kernel` 开头，
`quiet` 结尾的一行，在 `quiet` 后面添加 `biosdevname=0`，保存。

### 修改网卡的配置文件

```
cd /etc/sysconfig/network-scripts

for i in {1..4}; do sed -i "s/em$i/eth$(( i-1 ))/" ifcfg-em$i; \
  mv ifcfg-em$i ifcfg-eth$(( i-1 )); done
```

第二步的具体操作是将 ifcfg-em1 到 ifcfg-em4 这四个文件中的 `em1` / `em2` / `em3` /
`em4` 改为 `eth0` / `eth1` / `eth2` / `eth3`，然后将 `ifcfg-em1` / `ifcfg-em2` /
`ifcfg-em3` / `ifcfg-em4` 分别改名为 `ifcfg-eth0` / `ifcfg-eth1` / `ifcfg-eth2` /
`ifcfg-eth3`

### 重启服务器

```bash
reboot
```

### **Update from 2021-11-24**

最近又被这个问题折磨了一下，正常来说上面这个操作步骤是能够 work 的，但是总是会有不正常的时候，
就比如说我前几天遇到的。

具体情况是这样的：

情况是这样的，我根据之前的经验，改了 `/etc/grub.conf`，然后一改网卡配置文件名，远程就断掉，
沟通后知道路由器那边对服务器的网络进行了限制，一开始我以为是配置文件里面的内容没改导致的，然后
就叫机房的人协助改一下，结果发现将 `em1` 改为 `eth1` 后，竟然不能获取到 IP，配置静态 IP 也
不行。无奈之下，只能先恢复成原有的情况，继续使用 `em1`，将一些不依赖网卡名的服务给配置上。过了
一两天，机房那边想要复现这个问题，结果发现改了配置文件重启后用 `ip a` 命令看到的网卡名并没有
变化，还是 `em1`。

那么问题出在哪里呢？然后就对比一下配置成功且正常 work 的配置文件，一开始以为是配置文件中少了
`NAME="System eth0"` 这一行配置，结果发现其他的网卡都可以，就是这个 `em1` 变不成 `eth0`。
通过使用 `nmcli` 查看分析，改完后 `nmcli con` 看到的是 `eth0`，`nmcli dev` 看到的却是
`em1`。

Ok，检查到这，那么问题很清晰了，`nmcli con` 查看的是 NetworkManager 中的 connection，
`nmcli dev` 查看的是 NetworkManager 管理的 device 名，那么就是配置是生效了的，但是在
device 的管理识别中有问题。然后就去 `/etc/udev/rules.d/70-persistent-net.rules`
中一看，终于找到问题了，其中 `em1` 的配置要在 `eth0` 后面，这就难怪为什么改完网卡配置连接显示
的是配置文件中的配置，但是设备名却是 `em1` 了，根据现象我可以确定对于同一个设备，最新的配置会
覆盖掉之前的配置，而这台机器产生这个的原因是因为一开始改成功了，但是没有获取到 IP，之后有改回去，
就导致 `em1` 成为最新的了，然后之后修改并没有出现新的命名，所以 device 的配置文件中就不会再
更新。所以解决办法就是：

**直接注释掉 `/etc/udev/rules.d/70-persistent-net.rules` 中 `em1` 的配置。**

Problem Solve。

因此，最完美的方案是：

1. 修改 `/etc/grub.conf`
2. 修改 `/etc/udev/rules.d/70-persistent-net.rules`，如果文件不存在的话，修改完
   `/etc/grub.conf` 重启后系统会生成，之后再修改
3. 修改网卡配置文件然后重命名网卡配置文件

### Reference

[1]. [CentOS 6.4 安装后网卡 em 改回 eth 的两种方法](https://www.linuxidc.com/Linux/2013-07/86885.htm)
