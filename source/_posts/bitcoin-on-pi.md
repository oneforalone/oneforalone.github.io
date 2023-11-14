---
title: Raspberry Pi 安装 bitcoin
date: 2022-04-09
categories: Raspberry Pi
tags:
  - Raspberry Pi
  - Blockchain
  - Bitcoin
  - Linux
  - Ubuntu
---

**声明**：因为用的是 Rapsberry Pi，Arm 架构的，所以就直接从源代码编译，官网有编译好了 ARM
版本的二进制，如果懒得去编译可以直接下载去官网下载就好了，官网下载链接：
https://bitcoin.org/en/download

本文主要是记录 ARM 版从源码编译安装 bitcoin 命令行的记录。

## Enviroment

Raspberry Pi 4 Modle B @2018:

- OS: Ubuntu 22.04.3 LTS (Jammy Jellyfish)
- Mem: 4GiB
- Disk: 128GiB(TF) + 1 TiB(WD HDD)

## Installation

### 1. 安装依赖库

```bash
sudo apt -y install build-essential autoconf libtool pkg-config \
  libdb++-dev libboost-all-dev
```

- `pkg-config` 对应报错：`configure: error: possibly undefined macro: AC_MSG_ERROR`
- `libdb++-dev` 对应报错：`configure: error: libdb_cxx headers missing (netbsd)`
- `libboost-all-dev` 对应报错：
  ```
  checking for boostlib >= 1.47.0 (104700)... configure: We could not detect the
  boost libraries (version MINIMUM_REQUIRED_BOOST or higher). If you have a staged
  boost library (still not installed) please specify $BOOST_ROOT in your environment
  and do not give a PATH to --with-boost option. If you are sure you have boost
  installed, then check your version number looking in <boost/version.hpp>.
  See http://randspringer.de/boost for more documentation.
  ```

### 2. 安装 berkeley-db 4.8

```bash
wget http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz
tar -xf db-4.8.30.NC.tar.gz
cd db-4.8.30.NC/build_unix
../dist/configure --enable-cxx \
  --build=aarch64-unknown-linux-gnu
sudo make install
```

berkeley-db 也是一个依赖，只不过因为被 Oracle 收购了，所以软件源里面没有这个版本的，
需要自己手动进行编译。官方也有一个脚本来安装 berkeley-db（`bitcoin/contrib/install_db4.sh`)，
这里我是自己手动去编译安装的。

这里如果没有安装的话对应的报错是：

```
configure: error: Found Berkeley DB other than 4.8, required for portable wallets
(--with-incompatible-bdb to ignore or --disable-wallet to disable wallet functionality)
```

### 3. 获取源代码

```bash
git clone https://github.com/bitcoin/bitcoin.git
cd bitcoin
git checkout v25.0.0
```

### 4. 编译安装

```bash
./configure CPPFLAGS="-I/usr/local/BerkeleyDB.4.8/include -O2" \
            LDFLAGS="-L/usr/local/BerkeleyDB.4.8/lib" \
            --build=aarch64-unknown-linux-gnu \
            --with-gui=no
make -j4 && sudo make install
```

### 5. 配置

安装好后先生成一下 rpc 的访问认证：

```bash
cd bitcoin/share/rpcauth/
./rpcauth.py your-name
```

执行后会有一个输出，类似于（以用户名 `Alice` 为例）：

```bash
./rpcauth.py alice
String to be appended to bitcoin.conf:
rpcauth=alice:c7659b139bd5850a2d12eb205d7f0a45$83619ae5dfa9819dfdb01af41fcd95fbc3cb3fb75e9b7a2fb614351dbf0b5bb8
Your password:
mwO7F-1njVd3ToTQpLPNHNWe3HxmXYNSuQSPTi6aDzQ=
```

将其中的第二行 `rpcauth=alice:xxxxxx` 添加到 `~/.bitcoin/bitcoin.conf` 中，
若是没有 `~/.bitcoin/bitcoin.conf` 文件，直接复制 Reference 7 链接中的文件，然后
将这一句添加进去就好，同时在里面也可以指定对应的 bitcoin block 的存储目录，关键词为 `datadir`。

之后运行 `bitcoind -daemon` node 就会在后台自动同步。

设置开机自启：

```bash
crontab -e
```

在文件最后添加一行 `@reboot bitcoind -daemon`。

bitcoind 的数据默认保存在 `~/.bitcoin` 路径下，可以在配置文件中修改将数据保存在其他位置：

```
datadir=/data/bitcion/data
```

#### 5.1. 个人配置

以下是我个人的一些配置:

```
# enable transaction index
txindex=1

# chain data
datadir=/data/bitcoin/data

# RPC auth
<your-own-auth-configure>
# allow connect from other machine
rpcallowip=0.0.0.0/0
# RPC address
rpcbind=0.0.0.0:8332
# Listen for RPC connection on this TCP port:
rpcport=8332

# connet to Tor proxy
proxy=127.0.0.1:9050
```

同时，因为我喜欢将配置和数据都放在一起，所以我每次启动需要指定配置文件的位置:

```
bitcoind -conf=</path/to/config>
```

如果配置文件不在默认路径 `~/.bitcoin/bitcoin.conf`, 那么每次执行 `bitcoin-cli` 命令时需
要执行一些参数：

```Shell
bitcoin-cli -rpcconnect=127.0.0.1 \
  -rpcport=8332 \
  -rpcuser=<username> \
  -rpcpassword=<password>
```

嫌麻烦可以对这个命令进行 `alias`, 在 `~/.bashrc` 或 `~/.zshrc` 中加入：

```
alias bitcoin-cli="bitcoin-cli -rpcconnect=127.0.0.1 -rpcport=8332 \
  -rpcuser=<username> --rpcpassword=<password>"
```

当然觉得麻烦的话可以将配置放在 `~/.bitcoin/bitcoin.conf` 路径。

OK，以上 Pi 就能跑 bitcoin 的 full node 了。

同步需要时间，Just wait。

Happy hacking。

## Reference

1. https://stackoverflow.com/questions/8811381/possibly-undefined-macro-ac-msg-error
2. https://github.com/bitcoin/bitcoin/issues/2998
3. https://bitcoin.stackexchange.com/questions/91901/how-to-install-berkeley-db-4-8-on-linux
4. https://stackoverflow.com/questions/4810996/how-to-resolve-configure-guessing-build-type-failure
5. https://www.cnblogs.com/jimaojin/p/13211359.html
6. https://github.com/bitcoinbook/bitcoinbook/blob/develop/ch03.asciidoc
7. https://github.com/bitcoin/bitcoin/blob/v0.16.0/contrib/debian/examples/bitcoin.conf
8. https://bitcoin.org/en/full-node#other-linux-daemon
