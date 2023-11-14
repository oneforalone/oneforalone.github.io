---
title: CentOS 7 Utils
date: 2022-06-08
categories: CentOS
tags:
  - Linux
  - Network
  - CentOS
---

## CentOS 7 配置 bond

有时候在安装系统时忘了配置 bond，需要用命令手动配置，理论上来说，只需要创建好对应的配置文件应该
就可以，但是那配置文件，根本记不住。google 一下，发现可以使用 `nmcli` 来配置。

```bash
nmcli connection add type bond ifname bond0 mode 4
nmcli connection add type bond-slave ifname enps0f0 master bond0
nmcli connection add type bond-slave ifname enps0f1 master bond0
```

然后在根据自己的需求配置对应的 bond 参数以及网络信息。至于其背后详细的原理，请参考 [bond 技术分析](https://cloud.tencent.com/developer/article/1087312?from=15425)

## CentOS 7 root password crack

通常来说，系统的 root 密码应该是被记录下来的，不会被忘记。但是就是有不一般的情况。
客户直接将服务器寄过来，然后就让我们去检查配置。伞兵客户。没办法，只能强制将 root
的密码修改咯。 直接参考博客——[CentOS 7 root 用户密码忘记，找回密码方法](https://blog.csdn.net/qq_43518645/article/details/105098090)
进行修改。

为了防止 CSDN 访问出现异常，加个简单的记录吧：

1. 按 `e` 修改系统启动项
2. 将以 `linux16` 开头的一行中末尾处的 `ro` 修改成 `rw init=sysroot/bin/sh`
3. 按 `Ctrl+X` 后会直接进入系统
4. 将 `/sysroot` 指定为 `/` ：`chroot /sysroot`
5. 修改密码： `passwd`
6. 更新系统信息：`touch /.autorelabel`
7. 退出 `chroot`：`exit`
8. 重启服务器：`reoobt`

注：如果机器使用了 UEFI 启动，需要先进入 BIOS 关闭 UEFI 然后再启动，不然看不到系统的选择界面。
UEFI 启动加载太快了，根本反应不过来就进入系统了。

## Reference

[1]. [centos7.x 网卡 bond 配置](https://www.cnblogs.com/liwanggui/p/6807212.html)
