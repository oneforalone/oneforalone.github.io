---
title: FreeBSD 12 安装图形界面
date: 2020-07-02
categories: FreeBSD
tags:
  - Unix
  - FreeBSD
  - Xorg
---

没事玩了会 FreeBSD，安装完系统后发现，只有个黑黑的 terminal，这怎么能行呢？本意是想要作为
桌面系统的。去社区和官网溜达一下，参照 [FreeBSD Handbook][FreeBSD-Handbook] 中的
[I.5 节][I.5]就开始折腾了。

对了，在国内的伙伴千万要记得，换成国内的 pkg 源哦，另外，官网给的镜像已经挂了，建议使用
[中科大的镜像][ustc-mirror-freebsd]

## 安装 Xorg

因为 \*nix 的桌面环境都是基于 [X Windows System][XWindowsSystem] 的，所以，需要先安装
X Windows System，该套件包名叫 `xorg`：

```bash
# pkg install xorg
```

## 安装配置 XDM

安装完 `xorg` 后，就需要安装登陆界面的管理器了。当然，不同的桌面环境有不同的 `XDM`。我这里就
直接装默认的，虽然很丑，但是好用啊。

```bash
# pkg install x11/xdm
```

安装好后编辑 `/etc/ttys`，将其中的：

```
ttyv8 "/usr/local/bin/xdm -nodaemon" xterm off secure
```

这一行中的 `off` 改为 `on` 保存。这行配置会让 `XDM` 随系统启动而启动。

## 安装配置 Xfce

最后，安装 `Xfce`

```bash
# pkg install xfce
```

因为 `Xfce` 是用 [`D-Bus`][dbus] 作为消息总线的，所以需要将 `D-Bus` 设为开机自启动：

```bash
# sysrc dbus_enable=YES
```

另外，官方手册中没有写要配置鼠标的服务.安装好后发现没有鼠标，所以，还需要将鼠标的服务设为开机
自启动：

```bash
# sysrc moused_enable=YES
```

用以下命令创建 `~/.xinitrc`:

```bash
% echo ". /usr/local/etc/xdg/xfce4/xinitrc" > ~/.xinitrc
```

设置使用 `XDM`

```bash
% echo ". /usr/local/etc/xdg/xfce4/xinitrc" > ~/.xsession
```

**注**：以上两个命令都是以用户权限执行的，如果没有切换，那么默认是进入 `root` 用户的桌面。

P.S. 什么，`GNOME` 和 `KDE`？自己看文档去，反正我不用这些桌面。

[FreeBSD-Handbook]: https://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/index.html
[I.5]: https://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/x11.html
[ustc-mirror-freebsd]: http://mirrors.ustc.edu.cn/help/freebsd-pkg.html
[XWindowsSystem]: https://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/x-understanding.html
[dbus]: https://www.freedesktop.org/wiki/Software/dbus/
