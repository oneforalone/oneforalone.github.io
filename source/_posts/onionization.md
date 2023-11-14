---
title: Onionization
date: 2023-11-08 16:02:41
tags:
  - Tor
  - Anonymous
  - Proxy
categories: Tor
---

## 序

最近闲着无聊看看了 Onion 的协议，发现 Onion 是真的好，完全可以取代内网穿透，而且还匿名，感觉
没有比这个更方便的了。

Onion 协议的具体原理就不再这里详细展开讲解，你只需要知道，Onion 是对数据进行了加密，而且每一
层都只知道其下一跳路由，就像洋葱一样一层一层剥开。本质上运营商是能知道你是在使用 Tor 进行访问，
只不过无法查看里面的数据内容。即 Tor 的匿名性是由两个性质来保障的，一个是 Tor 的加密算法，
另外一个就是其路由协议，只知道下一跳路由。当然，事无绝对，据传闻是美国 NSA 有能力将 Onion
的加密算法给破解掉，但是成本很高，所以只要抓到你的收益要低于破解的成本的话，完全没必要担心。还有
一个就是 Onion 的 Exit Relay 也是个风险点，如果有人控制了对应的 Exit Relay，那么也可以
监听对应的流量数据，但这个要求更高，Exit Relay是分布的，除非有人和机构能将所有的 Exit Relay
进行监听，这个比 NSA 破解的成本还要高，也可以忽略。风险最高的其实是自己搭建 Exit Relay，然后
只使用自己的 Exit Relay，那么风险点就转移到自建的 Exit Relay 上了。

对于 Onion 的详细介绍直接参考官方社区的文档吧，我这里就不做一些无聊的翻译工作了。
官方社区为：https://community.torproject.org/

本文主要记录一下如何搭建一个匿名的网络服务。

## Why Tor

一般来说，一个能够访问的网站至少需要满足两个条件：

- 公网 IP
- 处理请求的服务程序

当然，为了能跟好的推广，会需要一个域名，然后配上 DNS 解析，这样一个标准的 Web 服务就搭建好了。

通常来说，处理请求的服务程序很容易开发/获取/配置。但是对于公网 IP 来说，不同的国家有不同的
要求，就算是使用云服务厂商的云服务器，也需要遵循当地的政策。这个在大多数国家是个难点，而且一个单
独的公网 IP 的费用也比较贵。

Tor (The Onion Route) 给出了一个很好的解决方案。通过 Tor，只需要配置好 Tor，就可以对自己
的服务进行访问了。当然，everything has a trade-off, Tor 也不例外，那就是 Tor 的服务都
需要通过 Tor 浏览器或者是其代理软件 Tor 进行访问，不能像一般的服务只要连接到了 Internet，
就能直接访问。不过这个 trade-off 对于大部分独立的开发者来说问题不大，因为很多开发环境本身
就不能对外网公开，所以这个 trade-off 很大程度还是一个很好的 feature，不过还是因人而异了。

P.S. 在中国大陆，是用 Tor 需要使用到代理，这里会有一笔支出，不过因为我本身就是要用代理，
所以对我来说这比支出是必不可少的，而且也比申请一个单独的公网 IP 要便宜，同时我也可以将我的
Raspberry PI 完全利用起来。其实我的配置是所谓的 Tor over Proxy，虽然 Proxy 可能会有
日志，但是我已经不 care 了。还有一种就是没有代理的话需要去申请一个 Bridge，这个我没配置，
因为这个在中国大陆有点死锁，需要用的 Telegram 的 Bot，而 Telegram 在中国大陆默认是无法
无法访问的。一个没有代理的方案就是使用邮件，给 `gettor@torproject.org` 这个地址发个邮件，
主题为对应 OS 的名字: "windows", "macos", "linux"。Bridge 的获取方法就是给
`frontdesk@torproject.org` 发个主题为 "private bridge cn" 的邮件。

## Tor relay

Tor browser 默认是集成了 Tor Relay 的服务，其端口是 9051, 如果不想去跑 Tor Relay, 那么
直接打开 Tor browser 就可以使用 Tor。但是我需要对一些服务进行 Onionize，所以我需要单独跑
一下 Tor Relay。Windows 我不太熟，理论上是一样的，只不过需要下载对应的 Tor Relay 软件，而
因为 Windows 没有包管理，所以这个可能会发一点时间，同时配置文件的位置也会有所不同，所以如果是
Windows 用户的话，`DO YOUR OWN RESEARCH`。具体各个 OS 的平台操作可参考：
https://community.torproject.org/relay/setup/guard/. 这个上面有详细的教程。

### MacOS

在 MacOS 上，直接使用 [Homebrew](https://brew.sh/) 进行安装：

```shell
brew install tor
```

安装好后在配置文件 `torrc` 中添加：

```
HiddenServiceDir /var/lib/tor/<service-name>/
HiddenServicePort <port> <service-listening-ip-address>:<port>
# Tor over proxy
Socks5Proxy 127.0.0.1:7890
```

因为 MacOS 中默认没有 `torrc`, 只有 `torrc.sample`，所以需要先将 `torrc.sample` copy
到 `torrc`。

注：Intel Chip 和 Apple Silicon Homebrew 安装位置不一样，所以配置文件的路径也不一样:

- Intel Chip: `/usr/local/etc/tor/torrc`
- Apple Silicon: `/opt/homebrew/etc/tor/torrc`

其实默认配置文件的路径就是 `/etc/tor/torrc`，只不过因为 MacOS 是用 Homebrew 管理，就在其
默认目录下的 `/etc/tor/torrc`。那个 `HiddenServiceDir` 的路径也推荐改到 Homebrew 的
对应目录下。

同时，为了安全起见，推荐服务只监听本地回环地址（127.0.0.1）, 这样就只能通过 Tor 进行访问，
外部无法访问。

## Debian/Ubuntu

Deb 系的要安装 Tor 其实很简单，配置一下源，然后 `apt install` 一下就好。

```shell
sudo apt install apt-transport-https
sudo tee -a /etc/apt/sources.list.d/tor.list <<-EOF
deb     [signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org <DISTRIBUTION> main
deb-src [signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org <DISTRIBUTION> main
EOF
sudo wget -qO- https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | sudo gpg --dearmor | sudo tee /usr/share/keyrings/tor-archive-keyring.gpg >/dev/null
sudo apt update
sudo apt install tor deb.torproject.org-keyring
```

其中的 `<Distribution>` 根据自己系统的版本替换成对应的版本名。使用 `lsb_release -c` 或是
`cat /etc/debian_version` 来获取对应的版本名。

P.S. 我在 Rapsberry Pi 上试过，Ubuntu 22.04.3 LTS 通过 apt 安装会因为部分库的版本过低而
失败，所以我直接从源代码编译出来的，也不难，直接四步走：

```
./autogen.sh
./configure
make -j4
make install -j4
```

根据 configure 时的报错，缺什么库就装什么库。

## SSH Example

对我来说，一直想要访问家里的 Raspberry PI，但是之前一直都是只能在家里才能访问，在外面就无法
访问了，虽然有 frp 这样的内网穿透的软件，但前提还是需要一台有公网 IP 的服务器。

### Raspberry PI (Server)

服务端需要对服务和 Tor 都进行配置，其实就是将 SSH 的监听地址改为只能本地访问，然后再在 Tor
的配置中配置一下端口和地址重启一下服务就 Ok。

- SSH service:

```shell
sudo tee -a /etc/ssh/sshd_config <<-EOF
ListenAddress 127.0.0.1
EOF
sudo systemctl restart ssh
```

- Tor service:

```shell
sudo apt install tor
sudo tee -a /etc/tor/torrc <<-EOF
HiddenServiceDir /var/lib/tor/ssh/
HiddenServicePort 22 127.0.0.1:22
# Tor over Proxy
Socks5Proxy 192.168.0.106:7890
EOF
sudo systemctl restart tor@default.service

sudo cat /var/lib/tor/ssh/hostname
```

最后一行的命令是获取对应的 onion 地址，访问时使用。

### Client

Client 侧也需要安装好 Tor，并给 Tor 配上代理，如果是能够直接连到外网，就不需要配置代理，直接
启动 Tor Relay 就好了，因为我是用的平台是 MacOS，所以命令为：

```shell
brew services start tor
```

启动完 Tor 后，需要对 SSH 进行配置，有两种方法：

1. SSH config

在 `~/.ssh/config` 文件中，添加如下配置：

```
Host opi
  Hostname <onion-address>
  ProxyCommand nc -x 127.0.0.1:9050 -X5 %h %p
  User <user-name>
```

其中 `Honstname` 的值是在服务端的 `/var/lib/tor/ssh/hostname` 的值。配置好之后就可以
直接在 terminal 中使用 `ssh opi` 对 Raspberry PI 进行连接了。

2. Torify

Torify 会自动将流量转到 Tor Relay 上。

```shell
brew install torify torsocks
torify ssh <onion-address>
```

注：是用 Torify 时需要将 MacOS 的 System Integrity Protection (SIP) 给关掉, 具体参考
https://developer.apple.com/documentation/security/disabling_and_enabling_system_integrity_protection

关掉 MacOS 的 SIP 会有一定的风险，而且配置起来还比较麻烦，所以还是推荐使用 SSH config 这种
方法更加简单。

## Summary

以上就是使用 Tor 将自己的服务提供给外网访问，其他的服务也是类似的，只需要在服务端的 `torrc`
中加上对应的服务的目录和端口配置，就可以通过 Tor 进行访问了。其实，掌握了这个，可以对所以的服务
都进行 Onionize，将服务设置为只监听本地服务，然后让 Tor 给代理出来，既安全，又匿名。
