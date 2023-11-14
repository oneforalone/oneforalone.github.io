---
title: Ubuntu Utils
date: 2022-06-08 04:32:53 PM
categories: Ubuntu
tags:
  - Linux
  - Ubuntu
---

## Cron 任务执行不成功

突然发现配置了一个 cron 任务的脚本，没有得到预期的结果，查看日志发现任务确实执行了。然后查了下
资料发现 cron 的命令是以 sh 执行的，而我用的是 bash 的语法。Well，改了后就执行成功了。其实
就是 sh 中没有 `source` 命令，只有 `.` 命令。

Emmm…… 之后有时间再找找资料详细的对比下 systemd 的 timer 和 crontab 吧。

### Reference

[1]. https://unix.stackexchange.com/questions/278564/cron-vs-systemd-timers

[2]. https://askubuntu.com/questions/752240/crontab-syntax-multiple-commands

## Ubuntu 18.04 apt certificate error

最近在使用 Ubuntu 18.04 安装软件是突然遇到个证书错误：

```
Certificate verification failed: The certificate is NOT trusted. The certificate issuer is unknown.  Could not handshake: Error in the certificate verification.
```

查了下文档，发现是因为服务器走了代理，但因特殊情况又不能关掉代理，那么怎么办呢？直接不进行证书认
证就好了。

```bash
sudo -i
echo "Acquire::https { Verify-Peer \"false\" }" >> /etc/apt/apt.conf.d/99verify-peer.conf
```

Okay, Problem Sovled.

### Reference:

1. [StackExchange: apt-get update failed...](https://askubuntu.com/questions/1095266/apt-get-update-failed-because-certificate-verification-failed-because-handshake)
2. [Ubuntu Manpage: apt-transport-https](http://manpages.ubuntu.com/manpages/bionic/man1/apt-transport-https.1.html)
