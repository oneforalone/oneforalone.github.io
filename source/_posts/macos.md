---
title: MacOS Utils
date: 2022-01-11
categories: MacOS
tags:
  - MacOS
---

## Mac OS 命令行打开终端

有时候看电影里电脑特效很酷，动不动就自动打开一大堆 terminal，今天闲着无聊 google 了一下，
下面是 MacOS 的：

```zsh
osascript -e 'tell app "Terminal"
    do script "echo hello"
end tell'
```

Linux 的话：

```bash
# terminal -e command
xterm -e ls # 使用  xterm
gnome-terminal -x ls # 使用 gnome-terminal
```

## Mac OS 磁盘空间清理：可清除空间

最近无聊看了下电脑的磁盘使用率，结果发现 512G 的磁盘基本快满了，但是查来查去也没找到大的文件。
然后仔细一看发现其中有近 300 G 的空间标注为可清除（purgeable）。以为是有缓存，毕竟太久没重启
了，就重启了一下，发现并没有释放那部分空间。于是就搜索了一下，然后发现是我的 Timemachine 的
磁盘空间不够，然后我开着 Timemachine，导致本地有很多份系统的快照（snapshot），直接清理一下
Timemachine 备份磁盘空间，再把本地的系统快照直接删掉，空间就释放出来了。

```
# 查看当前本机快照
sudo tmutil listlocalsnapshots /
# 删除单个快照
tmutil deletelocalsnapshots 2022-01-11-135946
# 批量删除
for i in `sudo tmutil listlocalsnapshots / | tail -n +2 | cut -d'.' -f4` ; \
do tmutil deletelocalsnapshots $i; done
```
