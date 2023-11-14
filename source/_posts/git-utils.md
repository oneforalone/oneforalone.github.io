---
title: Git utils
date: 2022-05-03
categories: Git
tags:
  - GPG
  - Git
  - Network
  - Proxy
---

## Git clone error

最近在服务器上拉 Github 代码时发现拉不下来，报了以下错误:

```bash
fatal: unable to access 'https://github.com/xxx.git/': gnutls_handshake()
failed: The TLS connection was non-properly terminated.
```

检查一番发现是服务器配置了代理，但代理挂了

### 查看当前代理

- 方法一

```bash
git config --global http.proxy
```

- 方法二

```bash
env | grep -I proxy
```

### 取消代理

- 方法一

```bash
git config --global --unset http.proxy
git config --global --unset https.proxy
```

- 方式二

```bash
export http_proxy=""
export https_proxy=""
export HTTP_PROXY=""
export HTTPS_PROXY=""
```

- 方式三

```bash
unset http_proxy
unset ftp_proxy
unset all_proxy
unset https_proxy
unset no_proxy
```

## Git 使用 GPG 签名

既然开始使用 GPG 了，那么就贯彻到底咯，git 也用上 GPG 签名好了。

### 初始化环境

#### 安装并生成密钥

PGP 的安装和密钥的生成参考 {% post_link gpg-on-macos %} 中的步骤。

#### 导出公钥

- 获取 keyid

```bash
$ gpg2 --list-secret-keys --keyid-format=long | awk -F'[/ ]' '/^sec/ {print $5}'
```

该命令会输出包含私钥的所有 keyid，如果电脑上只有一对 GPG 的公私钥对，那么输出的结果就是所需
要的，如果有多个公私钥对，则根据自己的需求或去对应的 keyid，可以使用命令:
`gpg2 --list-secret-keys --keyid-format=long`，会输出详细的信息，而 keyid 是以 `sec`
开头中 `rsa4096/` / `ed25519/` 后面的那个序列，即 private key id。

- 导出 pubkey

```bash
$ gpg2 --armor --export pub <key-id>
```

这里会在终端输出公钥，复制粘贴到 Github 账号中。

### 配置 git

设置签名时使用的 key：

```bash
$ git config --global user.signingkey <key-id>
```

上面的命令中的 `user.signingkey` 后面接的是你自己的 private key id。

因为 macOS 上安装的 GPG Suit 的命令是 `gpg2`，不是 `gpg`，所以需要指定一下 GPG 的命令：

```bash
$ git config --global gpg.program gpg2
```

如果只是想对单独的 repo 使用 GPG 签名，那么就切换到那个 repo 目录下，然后执行：

```bash
$ git config commit.gpgsign true
```

但是一般既然用了，那么肯定是喜欢全局都使用，那么就执行：

```bash
$ git config --global commit.gpgsign true
```

反正就是对 git 的配置，要是不想敲命令，就直接编辑 `$HOME/.gitconfig`，至于具体的参数格式，
参考官方文档吧：https://git-scm.com/docs/git-config。

Okay，Done。

### Reference:

1. [Telling Git about your signing key](https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key)
2. {% post_link gpg-on-macos %}
3. [使用 GPG 签名你的 Commit](https://www.cnblogs.com/xueweihan/p/5430451.html)
