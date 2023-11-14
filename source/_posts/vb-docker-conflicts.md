---
title: Win 上 VB 与 Docker 冲突问题
date: 2020-06-30
categories: Windows
tags:
  - Windows
  - VirtualBox
  - Docker
---

今天在 Windows 机子上打开虚拟机时突然报 `VT-x is not available (VERR_VMX_NO_VMX)`，
一开始下意识以为是 BIOS 没有开启虚拟化选项，检查后发现一切设置正常。上网查了下发现，是 Docker
和 VirtualBox 有冲突了，因为 Docker 使用了 Windows 自带的 Hyper-v，而 VirtualBox 和
Heyper-v 是无法同时运行的，只能二选一。

既然发现了问题所在，那么就解决呗。根据问题的原因，那么解决办法只能是 VB 和 Docker 二选一咯。

不管是选择哪个，都需要以管理员权限运行命令行提示符（即 CMD）。

* VirtualBox

  在 CMD 中输入 `bcdedit /set hypervisorlaunchtype off`，重启电脑。

* Docker

  在 CMD 中输入 `bcdedit /set hypervisorlaunchtype auto`，重启电脑。

注：如果要查看 Hyper-v 是否启动，在 CMD 中输入 `bcdedit | findstr hyperv`，输出结果是
`hypervisorlaunchtype Auto` 时表示 Hyper-v 已经开启， `hypervisorlaunchtype off`
表示 Hyper-v 已禁用。

当然，作为全都要的成年人来说，可以参考国外哥们的做法，设置两个启动项，一个使用 Hyper-v，一个不
使用 Hyper-v，文章链接为：
https://marcofranssen.nl/switch-between-hyper-v-and-virtualbox-on-windows/

**Update From 2020-12-20**

最近启动了下 VirtualBox 的一台虚拟机，发现后台 Docker 在运行。回想了一下，是因为我启用了
WSL（Windows Subsystem Linux），更新 Docker 时默认选了 WSL 作为 Docker 后台支持。
虽然可以同时支持 VB 和 Docker，但还是不是很完美，因为我在新建一个 Win 虚拟机时发现安装系统时
会失败，换到 Mac 上就很正常。

That's it.

## Reference
1. [https://forums.virtualbox.org/viewtopic.php?f=38&t=89791](https://forums.virtualbox.org/viewtopic.php?f=38&t=89791)
