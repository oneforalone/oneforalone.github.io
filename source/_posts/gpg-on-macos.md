---
title: GPG on MacOS
date: 2023-10-10 17:46:44
tags:
  - GPG
  - MacOS
categories: GPG
---

## 简介

进入 crypto 了，那么就不得不注重起隐私来了，论隐私来说，那些 IM 的信息没啥好谈的，就连开源界
都要政治正确，所以也就没啥好说的。但是对于一个比较喜欢用邮箱的人来说，可以使用 GPG 来规避信息
内容泄漏的风险。下面是在 Mac OS 使用 GPG Suit 的一些记录。

## 安装

首先，千万不要使用 homebrew 安装 GPG Suit，不然 Apple Mail 的插件你是启用不了的，要去官网
下载 dmg 手动安装。这已经不是我第一次因为 homebrew 安装导致软件版本的问题了，所以，官网没有
推荐使用 homebrew 的，就不要使用，免得又遇到什么问题。

官网地址为：https://gpgtools.org/

## 配置

创建密钥对和在 Apple Mail 中启用 GPG Suit 插件就不用我介绍了，安装完成后会自动弹窗让你选
择，选择是就好。这里所说的配置是，我怎么给在 GPG 中添加了公钥的人发送加密邮件呢？这里需要找一
找官方的论坛。所以说任何产品如果官方提供了论坛的话，一定要去逛一逛，你会找到大部分答案的。

好了，talk is cheap，要使用添加了公钥的地址发送加密邮件需要执行一条命令，然后新建发送邮件时，
如果收件人是那个地址，主题那一栏最右边会有一把小锁的 icon。

- One Recipient One Public Key

```bash
$ defaults write org.gpgtools.common KeyMapping \
    -dict-add <email-address> <fingerprint>
```

- `<email-address>`：公钥的邮箱地址
- `<fingerprint>`：公钥的 fingerprint

如果是有对应整个邮箱的域名是用的都是同一个公钥的话，可以这么添加域名的 mapping：

- Multiple Recipients One Public Key

```bash
$ defaults write org.gpgtools.common KeyMapping \
    -dict-add '*@<domain-name>' <fingerprint>
```

- One Recipient Multiple Public Keys

```bash
vi ~/.gnupg/gpg.conf

## add one line at the end of the file
group <email-address> = <fingerprint1> <fingerprint2> ...
```

- Check the Results

如果要查看是否添加正确，可以使用命令：

```bash
$ defaults read org.gpgtools.common KeyMapping
```

Okay, 那么现在你就可以发送加密邮件或者对邮件进行签名了。

> **注**：如果没有收件地址的公钥，只能对邮件进行签名，不能加密，这个是密码学的知识，这里就不
> 介绍了。收件人收到的邮件会附带一个公钥文件，用来验证签名的。如果邮件加密了的话，没有插件的话
> 是会有两个文件的，一个是加密文件，一个是个加密协议的文件。如果对文件进行了加密，
> 记得备份自己的密钥对哦。

## Command Line

- Generate/Revoke/Delete Key Pair

```bash
# generate key pair
gpg --gen-key

# revoke key pair
gpg --gen-revoke <user-id>

# delete key pair
gpg --delete-key <user-id>
```

`<user-id>` 可以是邮箱地址，也可以是 Hash 字符串，一下所指的 `<user-id>` 都是同样的指代。

- List Keys

```bash
gpg --list-keys
```

- Export/Import Private/Public Key

```bash
# Export Public Key
gpg --armor --output public-key.asc --export <user-id>

# Export Private Key
gpg --armor --output private-key.prv --export-secret-keys <user-id>

# Import Public/Private Keys
gpg --import <key-file>
```

- Send/Retrieve Public Keys to/from Server

```bash
# Send Public Keys to Server
gpg --send-keys <user-id> --keyserver hkps://keys.openpgp.org

# Retrieve Public Keys from Server
gpg --keyserver hkps://keys.openpgp.org --search-keys <user-id>

# Verify a Fingerprint from Server
gpg --fingerprint <user-id>
```

- Sign/Verify Files

```bash
# Sign a file
gpg --armor --detach-sign <filename>

# Verify a file
gpg --verify <sign-file> <filename>
```

默认的签名是 `--sign`，会直接生成个二进制文件，如果像生成 ASCII码的文件，使用
`--clearsign` 参数，如果想将原文件和签名文件分开，使用 `--detach-sign` 参数，这个参数生成
的签名文件是二进制的，要生成单独的 ASCII 的签名文件，则使用`--armor --detach-sign`参数。

- Encrypt/Decrypt Files

```bash
# Encrypt file
gpg --recipient <user-id> --output <encrypted-filename> \
  --encrypt <filename>

# Decrypt file
gpg --output <filename> --decrypt <encrypted-filename>
```

`<output-filename>` 是加密后的文件，`<filename>` 是需要加密
的文件。注意 `--output` 和 `--decrypt/encrypt` 的顺序不能变。

P.S. 同时进行加密签名的命令为：

```
gpg --local-user <user-id> --recipient <recipient-address> \
  --armor --sign --encrypt <filename>
```

其实这些命令使用 `pgp --help` 就能查到，但还是记录一下吧，有总比没有要好。

## Reference

1. https://gpgtools.org/
2. https://gpgtools.tenderapp.com/kb/how-to/add-email-address-to-existing-public-key-domain-mapping-group-feature
3. https://www.gnupg.org/gph/en/manual.html
