---
title: Filecoin Snap Deals
date: 2022-17-18 03:23:06 AM
categories: Blockchain
tags:
  - Blockchain
  - Filecoin
---

## 序

由于官方文档质量不行，导致很多教程都遗漏了很多细节，导致大部分情况下
需要去 Slack 中咨询和查找。本文将介绍如果使用已经封装好了的 CC 扇区
存储真实数据。


## 前置要求

- 一台已经有封装好了 CC 扇区数据的 Miner 服务器
- lotus/lotus-miner 版本不低于 v1.16

## 真实数据存储

概括的来说，真实数据存储的流程就有三大步：

- snap-up
- make deal
- seal

### 配置

在开始之前，需要先修改一下 miner 的配置 (`config.toml`)，
将对应的配置给 enable。主要修改有:

- Libp2p

```
[Libp2p]
  ListenAddresses = ["/ip4/0.0.0.0/tcp/24001", "/ip6/::/tcp/24001"]
  AnnounceAddress = ["/ip4/<your-public-ip>/tcp/24001"]
```

其中 `ListenAddresses` 可以直接 copy，`AnnounceAddress` 就是情况而定。
如果你只想你自己用，那么就填你的内网 IP，如果你想直接去外面接单，那么你就直接
填你服务器的外网 IP。

- Dealmaking

```
[Dealmaking]
  # When enabled, the miner can accept online deals
  ConsiderOnlineStorageDeals = true
  # When enabled, the miner can accept offline deals
  ConsiderOfflineStorageDeals = true
  # When enabled, the miner can accept retrieval deals
  ConsiderOnlineRetrievalDeals = true
  # When enabled, the miner can accept offline retrieval deals
  ConsiderOfflineRetrievalDeals = true
  # When enabled, the miner can accept verified deals
  ConsiderVerifiedStorageDeals = true
  # When enabled, the miner can accept unverified deals
  ConsiderUnverifiedStorageDeals = true
  # A list made of Data CIDs to reject when making deals
  PieceCidBlocklist = []
  # Maximum expected amount of time getting the deal into a sealed sector will take
  # This includes the time the deal will need to get transferred and published
  # before being assigned to a sector
  # for more info, see below.
  ExpectedSealDuration = "24h0m0s"
  # When a deal is ready to publish, the amount of time to wait for more
  # deals to be ready to publish before publishing them all as a batch
  PublishMsgPeriod = "1h0m0s"
  # The maximum number of deals to include in a single publish deals message
  MaxDealsPerPublishMsg = 8
```

这个配置是开启接单，即开启真实数据存储，默认是 `false`，无法进行
真实数据的存储。

- Storage

```
[Storage]
  AllowAddPiece = true
  AllowPreCommit1 = true
  AllowPreCommit2 = true
  AllowCommit = true
  AllowUnseal = true
  AllowReplicaUpdate = true
  AllowProveReplicaUpdate2 = true
  AllowRegenSectorKey = true
```

这个是配置 miner 是否自己对扇区进行封装，因为我就一台 miner 机，
所以我就让 miner 当 worker 用了。如果有 worker 的话，可以不
修改这个配置。值得注意的是，最好是将 miner 的 `AllowAddPiece`
设置为 `true`，然后原有的 worker 执行命令也需要加上下面参数：

```
   --addpiece                    enable addpiece (default: true)
   --precommit1                  enable precommit1 (32G sectors: 1 core, 128GiB RAM) (default: true)
   --unseal                      enable unsealing (32G sectors: 1 core, 128GiB RAM) (default: true)
   --precommit2                  enable precommit2 (32G sectors: multiple cores, 96GiB RAM) (default: true)
   --commit                      enable commit (32G sectors: multiple cores or GPUs, 128GiB RAM + 64GiB swap) (default: true)
   --replica-update              enable replica update (default: true)
   --prove-replica-update2       enable prove replica update 2 (default: true)
   --regen-sector-key            enable regen sector key (default: true)
```

修改完配置后将 miner 重启。

miner 重启后需要对其 libp2p 进行设置。

- peer-id

```
lotus-miner actor set-peer-id `lotus-miner net id`
```

- multiaddr

```
lotus-miner actor set-addrs <NEW_MULTIADDR>
```

这里的 `<NEW_MULTIADDR>` 就是上面 miner 的配置文件中
`AnnounceAddress` 设置的地址。

- sealing directory

配置完 libp2p 后，需要配置一下 `sealing` 的目录，如果 miner
已经 attach 了 `sealing` 的目录可以略过这个配置：

```
# make the directory
mkdir -pv /storage/sealing
# attach to miner as sealing directory
lotus-miner storage attach -init -seal /storage/sealing
```

其中 `/storage/sealing` 根据自己的系统进行配置。

- storage-deals

storage-deals 是设置存数据是客户需要支付的费用。如果只是自己
使用，不对外开放接单，可以直接设置为 0。

```
lotus-miner storage-deals set-ask \
    --price 0.0000000 \
    --verified-price 0.0000000  \
    --min-piece-size 256KiB \
    --max-piece-size 32GB
```

其中 `--min-piece-size` 是接受的最小存储的大小，如果存储的
数据小于这个值的话，miner 会直接 reject 掉。同理，
`max-piece-size` 就是接受的最大的存储的大小。

验证是否设置成功：

```
lotus-miner storage-deals get-ask
```

- retrieval-deals

和上面的存储一样，filecoin 存和取都会收费。自己用的话当然是
直接设为 0 咯。

```
lotus-miner retrieval-deals set-ask \
    --price 0.0000000 \
    --unseal-price 0.0000000 \
    --payment-interval 1GiB \
    --payment-interval-increase 1GiB
```

其中的 `--payment-interval` 和 `--payment-interval-increase`
就是字面意思。不懂就看下 help 然后翻译一下吧。

验证的方法和上面一致：

```
lotus-miner retrieval-deals get-ask
```

### snap-up

Phew! 总算是配置好了，那么接下来就很快了。

先将 `proving` 的 cc 扇区给 `snap-up` 一下。

```
lotus-miner sectors list --fast
lotus-miner sectors snap-up <sector-id>
```

执行完后对应的扇区的状态会变为 `Avaiable`。
查看扇区的状态：`lotus-miner sectors status <sector-id>`

### 存

存数据的话分五步走：

1). 生成 car

这里介绍的是大文件 (>1GiB)，如果文件比较小的话，可以跳过这一步。

```
lotus client generate-car </path/to/inputfile> </path/to/outputfile>
```

注意，其中对应的文件路径需要是绝对路径，否则会报错。`outputfile`
就是 `car` 格式的文件，推荐以 `.car` 为后缀。

2). 生成 piece cid 和 piece size

无论是 online deal，还是 offline deal，大文件的话都需要
做这一步，否则的话会出现 `commP mismatch` 的错误。

```
lotus client commP </path/to/car-file>
```

这个命令会输出一个 CID 和 Piece size，这个 CID 是 `piece-cid`，
需要记录下来，下面的 make deal 时需要用到。

然后将得到的 Piece size 转换成字节。这里的转换不是简单的 GiB -> bytes
的单位换算，而是需要用到特殊的公式来计算。有两种方法计算：

a). 通过 shell 脚本

脚本 (piece_size.sh) 代码如下：

```shell
#!/bin/bash

# Usage method：(bash ./piece_size.sh 3.969 GiB) 

Size=$1

Type=$2

mm=`echo $Size|awk -F"." '{print $1}'`

for (( i=1;i<=10;i++ )) ; do  let "n=2**$i" ; if [ $mm -le $n ] ; then PieceSize_=$n ; break ; fi ; done

if [[ $Type == "GiB" ]];then let "PieceSize=$PieceSize_*254*1024*1024*1024/256" ; elif [[ $Type == "MiB" ]];then let "PieceSize=$PieceSize_*254*1024*1024/256" ; elif [[ $Type == "KiB" ]];then let "PieceSize=$PieceSize_*254*1024/256" ; else  echo "Type is err" ; fi

echo manual-piece-size=$PieceSize
```

用法: `bash ./piece_size.sh 3.969 GiB`

b). 通过wolframalpha

这个就更简单，访问下面这个链接：

[https://www.wolframalpha.com/input/](https://www.wolframalpha.com/input/?i=x+%3D+1024+*+1024+*+1%3B+127*%28+2%5E%28+ceil%28+log2%28+ceil+%28+x+%2F127+%29+%29+%29+%29+%29)

然后修改 `x` 的值，其中 `x` 就是正常的单位转换 (链接中是 1 GiB)。

或者更加简单的做法是对 `Piece size` 向下取整，然后转换成字节。
至于为什么要这么做的原因，参考官方文档: https://lotus.filecoin.io/tutorials/lotus/large-files/

3). 生成 data cid

这里的生成 data cid 将 car 文件导入到 `client` 端

```
lotus client import --car <car-file>
```

这个命令会输出 `Import xxx, Root xxxxx` 的结果，
将 `Root` 后面的那一串值记录下来。这个值就是 `data-cid`。
其中 `--car` 是导入 `car` 格式的文件，如果是小文件
且没有生成 car 文件，那么可以不加这个参数。

**注**：这个 `data-cid` 很重要，取数据时就看这个和
`miner-id`，如果将 `data-cid` 弄丢了，那存进去的
数据就取不出来了。如果一时忘了记，可通过
`lotus client local` 查看。

4). make a deal

deal 有两种，一种是 online，一种是 offline。
大文件最好还是走 offline 吧。

a). online

online 的比较适合小文件，比如说几十兆的文件。

```
lotus client deal <data-cid> <miner-id> <price> <duration>
```

其中 `<data-cid>` 就是第 3 步中得到的 `Root` 后面的
那一串值。`<miner-id>` 和 `<price>` 字面意思，不讲。
`duration` 是需要保存周期，单位是 `epoch` ，最小是
 `518400`，即 180 天。这里要注意已封装好的扇区的时间
要大于这个周期，否则存不了。

当然，如果不想记得这么清楚的话，直接输入 `lotus client deal`，
会出现交互的界面。

b). offline

个人是推荐 offline 的 deal 的，因为快。

```
lotus client deal \
  --manual-piece-cid=<piece-id> \
  --manual-piece-size=<piece-size> \
  <data-cid> <miner-id> 0 518400
```

其中 `<piece-id>` 和 `<piece-size>` 是第二步得到的结果。

操作完成后会返回一串字符，这串字符叫做 `Proposal CID`。
可以在通过 `lotus-miner storage-deals list -v` 查到。

这部操作的关键是需要保证 `lotus client query-ask <miner-id>`
这个命令执行成功，否则的话这个 deal 不能传到 miner 上，
也就无法进行后续操作。

如果 `lotus client query-ask <miner-id>` 卡住了的话，最直接
有效的办法就是重启一下 miner，在重启后的一段时间内这个命令是可以
正常执行，这个问题来源于 libp2p 的连接，具体内部不是很清楚，但是
重启 miner 这个方法很管用。如果 miner 不好随便重启，那么就建议
将 miner 拆分出 market，然后只需要重启 market 就好。

拆分 market 的操作链接：https://lotus.filecoin.io/storage-providers/advanced-configurations/split-markets-miners/

5). 导入数据

如果 miner 和 node 是分开的，那么需要将 car 文件从 node
传到 miner 上。

在导入数据之前，一定通过 `lotus-miner storage-deals list`
确认 client 端的 deal 传给 miner 了，有时如果 client 上的
钱包余额不足的话，deal 是不会传给 miner 的。

```
lotus-miner storage-deals import-data <proposal-cid> </path/to/car-file>
```

其中 `<proposal-cid>` 就是上一步 `lotus client deal` 得到的结果，`</path/to/car-file>`
就是 car 文件。

导入后 deal 的状态就会变成 `StorageDealProviderFunding`，等待大概 10 mins 后，
deal 的状态会变成 `StorageDealPublish`。这个默认会等待 1 hr 或者是有 8 个 deal
了，才会发布。可以通过 `lotus-miner storage-deals pending-publish` 来查看在等待
发布的 deal，通过 `lotus-miner storage-deals pending-publish --publish-now=true`
手动将 deal 发布。这时 deal 的状态就变成了 `StorageDealPublishing`，
再次等待 10 mins 左右，deal 发布成功后状态会变成 `StorageDealAwaitingPreCommit`。
最后手动 seal 扇区：`lotus-miner sectors seal <sector-id>`。至此，就开始将真实
数据替换 cc 数据。等待大概 1 hr 后，扇区状态就会变成 `UpdateActivating`。

具体 seal 过程中扇区的各个阶段在干啥，参考：https://github.com/filecoin-project/lotus/discussions/8141

不同配置机器 snap deal 的 benchmark 数据参考：https://github.com/filecoin-project/lotus/discussions/8127

### 取

取文件的话很简单，一条命令搞定：

```
lotus client retrieve --provider <miner-id> <data-cid> </path/to/outputfile>
```
