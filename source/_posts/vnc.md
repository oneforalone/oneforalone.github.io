---
title: VNC 常见问题及解决方案
date: 2021-12-05 09:39:43 AM
categories: VNC
tags:
  - Linux
  - CentOS
  - Network
  - VNC
---

关于 VNC，我只想说，一般的 Linuxer 基本不会用这玩意，毕竟远程连接 CLI 的效率要比 GUI 的高
很多，且对带宽要求也不在同一个量级。那为什么要写这部分文档呢？因为支持过 ICer，那群 ICer 对
IT 知识懂得比较少，而且都他们的工作环境确实离不开 GUI。现在来跟新下 VNC 出错的情况和解决方法
吧（系统版本为 Redhat/CentOS6 为准）。

## 连接问题

首先，在出现 vnc 客户端连接不上服务端时，要先确认服务端的 vnc 成功配置并启动了，也就是说，
服务器上的端口（ vncserver 的端口是 5900 + vnc-port）是 LISTEN 的状态。

* `netstat`

```bash
netstat -lnt | grep <port>
```

* `lsof`

```bash
lsof -i :<port>
```

### Connection Refuse

如果连接时报错提示中有 **refuse**，那么，就该检查主机名了，因为已经排除了服务端端口没有打开的
问题，那么只能说是没有找到正确的主机了。CentOS/RedHat 的主机名有两个配置文件，一个是
`/etc/hosts`，这个是配置 shell 中命令提示符主机名，还有一个是
`/etc/sysconfig/network`，这个是配置该主机在网络上的主机名。这两个配置文件中的主机名保持一
致。

### Connection Timeout

如果连接时报错提示中有 **timeout**，这个问题一般是 Iptables （软件防火墙）引起的，系统的
Iptables 开着，同时没有 vnc 端口的策略，所以收到连接请求后或直接将数据包丢掉，所以就
timeout 咯。解决方法当然就是添加对应的 Iptables 策略，但我比较懒，我就直接把 Iptables
服务关掉。

```bash
service iptables stop
chkconfig iptables off # disable auto start with system boot"
```

P.S. 关于连接出错问题，不排除中间网络链路多，其中硬件防火墙做了对应的策略可能。

## 灰/黑屏问题

### 连接后灰屏

好吧，是一个前同事遇到的问题，TA 在服务端启动了 vncserver 后，登录时发现界面是灰色的，然后又
来问我，这个问题呢，其实吧，看下官方文档就能解决的，但是却耗了我半个小时，为什么，因为我没想到
他们服务器是 RedHat 5。那么解决办法就是：去掉 `~/.vnc/xstartup`  中前两行的注释。

以下是 `xstartup` 文件的内容：

```bash
# Uncomment the following two lines for normal desktop:
# unset SESSION_MANAGER
# exec /etc/X11/xinit/xinitrc
[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
xsetroot -solid grey
vncconfig -iconic &
xterm -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop" &
twm &
```

这是官网给的说明，最后一句说明了这个现象：

> Add the line indicated below to assure that an xterm is always present, and
> uncomment the two lines as directed if you wish to run the user's normal
> desktop window manager in the VNC. Note that in the likely reduced resolution
> and color depth of a VNC window the full desktop will be rather cramped and a
> look bit odd. If you do not uncomment the two lines you will get a gray
> speckled background to the VNC window.

修改后应该是这样的：

```bash
# Uncomment the following two lines for normal desktop:
unset SESSION_MANAGER
exec /etc/X11/xinit/xinitrc
[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
xsetroot -solid grey
vncconfig -iconic &
xterm -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop" &
twm &
```

Okay, problem solved.

### 黑屏

还有一种就是连接上了但是是黑屏，请注意黑屏和灰屏不是个概念，应该没有黑灰色盲吧。灰屏的解决方法参
看上面，黑屏的话其实也是比较简单，这个在创建 vnc session 时是会出现一个错误提示：`timeout
in locking authority file ...`。最大的可能就是之前的 vncserver 的 session 没有正常关闭
退出，然后导致 `/tmp` 目录下还存在 `.X` 开头的目录，里面的文件被占用没有释放，问题的原因
说明了，那么解决方法当然就是：直接删掉对应的 `.X` 开头的目录了。

其他的可能原因也没遇到过，等遇到在更新吧。

## Reference

[1]. [wiki:how-to:vnc#section 2.5](https://wiki.centos.org/HowTos/VNC-Server#Create_xstartup_scripts_.28_You_may_omit_this_step_for_CentOS_6_.29)

[2]. [timeout in locking authority file (vnc service)](https://unix.stackexchange.com/questions/285352/timeout-in-locking-authority-file-vnc-service)
