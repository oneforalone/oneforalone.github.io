---
title: Ethereum 2.0
date: 2022-09-19 01:47:59 PM
categories: Blockchain
tags:
  - Blockchain
  - Ethereum
---

## Introduction
最近这段时间区块链内比较大的消息就是 Ethereum 2.0 的 The Merge 了。本文将介绍一下
Ethereum 2.0。

Ethereum 2.0，即 Ethereum 的升级版，其主要目的主要有两个：
1. 降低能源消耗，即共识从 PoW 转为 PoS；
2. 扩容，也称为分片（sharding），即提高 Ethereum 的 TPS（Transactions Per Second）。

目前（2022-09-15），The Merge 完成了第一个目标，第二个目标预计是在 2023 年完成。

## The Beacon Chain
The Beacon Chain 于 2020 年 12 月 01 日上线，简单的来说就是 Ethereum 2.0 的先行网，
PoW 转 PoS 以及 sharding 都先在 Beacon Chain 上测试，最终于 2022 年 09 月 15 日和
Ethereum 主网合并，即 The Merge。

## The Merge
北京时间 2022 年 09 月 15 日下午 03:00，Ethereum 合并成功， 即 Beacon Chain 和之前的
PoW 的 Ethereum 合并成功，Ethereum 正式从 PoW 转为了 PoS。这就是 The Merge 带来的
改变，Ethereum 不再需要消耗比较多的的能源来进行挖矿了，由 PoW 共识转为了 PoS 共识，大概减少
了 99.95% 的能源消耗。

这次升级，除了降低了挖矿的能源消耗，还带来了以下两个改变：
1. ETH token 开始进入通缩
2. 节点架构改变

### ETH 通缩
在 The Merge 前，每天 PoW（Ethereum Mainnet）上大概可以挖出 13,000 ETH，PoS（Beacon
Chain）大概可以挖出 1,600 ETH。 Merge 之后，PoW 去除，只保留了 PoS 上的奖励，即每天 ETH
的新增量变为原来的 $\frac{1600}{13000 + 16000} \approx 10.96\%$， 减少了
$\frac{13000}{13000 + 16000} \approx 89.04\%$。而 London Upgrade 之后，即
[EIP-1159][eip-1159] 之后，每个 tx 都会销毁一定数量的 ETH。假设 gas 的平均价格最低为
16 gwei，那么一天销毁的 gas 会大于或等于 1,600 ETH，即每天销毁的 ETH 会大于或等于新增的
ETH。所以 The Merge 之后 ETH 会进入通缩的阶段，如果 gas 的平均价格超过 16 gwei 的话，
那么ETH 的通缩就会加速。

> P.S 通过 https://ultrasound.money/#burn 的数据来看，在 gas 的平均价格为 11 gwei
> 时，每分钟会销毁大概 0.80 ETH，即一天大概会销毁 0.80 * 60 * 24 = 1,152 ETH。如果 gas
> 的平均价格为 16 gwei 的话，则 ETH 一天的销毁量大概为：1,152 * (16 / 11) = 1,675。

[eip-1159]: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1559.md

具体详细的数据都可以在 https://ultrasound.money 这个网站上查看。

### 节点架构改变
因为共识机制的改变，所以节点架构也就不得不变了。The Merge 前只需要执行一个程序，就能进行挖矿。
The Merge 后需要执行两个程序：一个执行层，一个共识层。其中执行层的是原有的 PoW 的软件的，
用来执行验证 tx，公式层是新增的，用来出块的。如下图：

![eth2-node.png](/images/ethereum/eth2-node.png)

以下是对应的节点的软件：
- 执行层：
  - [Besu](https://github.com/hyperledger/besu/releases)
  - [Erigon](https://github.com/ledgerwatch/erigon#usage)
  - [Geth](https://geth.ethereum.org/downloads/)
  - [Nethermind](https://downloads.nethermind.io/)
- 共识层：
  - [Lighthouse](https://github.com/sigp/lighthouse/releases/latest)
  - [Lodestar](https://chainsafe.github.io/lodestar/install/source/)
  - [Nimbus](https://github.com/status-im/nimbus-eth2/releases/latest)
  - [Prysm](https://github.com/prysmaticlabs/prysm/releases/latest)
  - [Teku](https://github.com/ConsenSys/teku/releases)

各个软件的使用占比参考：https://clientdiversity.org/#distribution

> **NOTE**：如果自己不想跑节点的话，可以直接使用第三方的节点，比较知名的有三个：
> [Infura][infura]，[Alchemy][alchemy] 和 [QuickNode][quicknode]。其中 Infura
> 支持主网和所有的测试网，但 Alchemy 只支持主网和 Goerli 测试网。更多三方的节点供应商可到
> https://ethereumnodes.com/ 查看。
>
> 如果想自己跑节点的话，现在也有集成的环境，[DappNode][dapp-node] 和 [Avado][avado]。
> 其中 DappNode 可以自己安装，也可以直接购买预装好的硬件，Avado 是软硬件一体化，只能购买，
> 不能自己安装配置。

[infura]: https://infura.io/
[alchemy]: https://www.alchemy.com/
[quicknode]: https://www.quiknode.io/
[dapp-node]: https://github.com/dappnode/DAppNode
[avado]: https://ava.do/

### 开发者须知
既然共识变了，block 也会做出对应的改变。The Merge 后区块主要有三个变化：block 结构，OPCODE
和区块的出块时间与状态。

#### Block 结构
The Merge 后，区块结构变得更复杂了，增加了以共识层的一些字段，同时对于原有的共识层（现在的
执行层）的一些字段做了一些改变。下图是 The Merge 之后一个区块的结构图：

![eth2-block](/images/ethereum/eth2-block.png)

在 PoW 的共识中，是有一定的概率出现叔块（ommer/uncle block）的，所以之前的区块结构中会有
ommer block 的相关字段。但是在 PoS 中，出块是确定的，不可能出现 ommer block，因此 The
Merge 之后区块执行层生成的区块的中 `ommers` 为空数组 `[]`，封装成 tx 就是：
`RLP([]) = 0xc0`，即 `ommers` 字段的值为 `0xc0`。因此 `ommersHash` 的值为
`0x1dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347`
（`Keccak256(RLP([]))`）。

同时，PoW 中最关键的两个字段 `difficulty` 和 `nonce` 也都设置为零，即 `difficulty`
的值为 0，`nonce` 的值为 `0x0000000000000000`（`nonce` 类型为`uint64`，8 bytes）。
汇总起来如下表：

| FIELD | CONSTANT VALUE | COMMENT |
| :--   | :---- | :---- |
| `ommers` | `[]`/ `0xc0` | `RPL([]) = 0xc0` |
| `ommersHash` | `0x1dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347` | `= Keccak256(RLP([]))` |
| `difficulty` | `0` | |
| `nonce` | `0x0000000000000000` | |

又因为出块由共识层出，所以在 PoW 中用来验证是否具有出块权的 `mixHash` 字段用来存储上一个
出块者选出的这一轮的出块者，用来证明自己有出块权，并命名为 `prevRandao`。`prevRandao`
是根据 slot number 算出来的随机数。具体的可参见：[EIP-4399][eip-4399] 及其讨论
[EIP-4399: Supplant DIFFICULTY opcode with RANDOM][eip-4399-discuss]
和 [EIP-4788][eip-4788]。

**注**：Ethereum 2.0 中 slot 可对应 1.0 中的 block，但严格来说 slot 是 block 的超集，
因为 slot 可以包含 block，也可以没有 block。32Slots = 1Epoch，这是在为后续的sharding
做准备。

[eip-4399]: https://eips.ethereum.org/EIPS/eip-4399
[eip-4399-discuss]: https://ethereum-magicians.org/t/eip-4399-supplant-difficulty-opcode-with-random/7368
[eip-4788]: https://ethereum-magicians.org/t/eip-4788-beacon-state-root-in-evm/8281

#### OPCODEs
The Merge 只改动了两个 OPCODE：

- `BLOCKHASH(0x40)`：准备弃用，虽然还可以正常执行，但是其安全程度变得很低，因为不是由 PoW
  来算 Hash 了。
- `DIFFICULTY(0x44)`：改名为 `PREVRANDAO`，可以用来获取随机数。

#### Block Time and states
因为 PoS 出块时就是由一个质押者（Staker）来出，所以时间 PoW 的更具有确定性，PoS 每 12s
出一个块，PoW 是平均 13s 出一个块。

同时 PoS 中没有 PoW 的 confirm 状态，而是将区块分为四种：

- head，就是刚出的块，状态为 `unfinalized`
- safe head，出块一段时间后，有超过 2/3 的验证者验证过，状态为 `safe`
- confirmed，由 `safe` 状态转为 `finalized` 过渡类型，在被其他的节点添加到链上
- finalized，有超过 2/3 的验证者将这个区块添加到链上，状态变为 `finalized`

状态为 `finalized` 的区块被视为可信任区块，即对应 PoW 中的 `confirmed` 的区块。

### 常见误区

- Ethereum 2.0 的 token 为 ETH2：错。不论是 PoW 的 Ethereum 和 PoS 的 Ethereum，其
  token 都是 ETH，从来都没有 ETH2 的 token，ETHW 也不是 Ethereum 之前的 token，而是
  有人在 The Merge 时进行分叉，利用大量矿工手里的显卡。在术语中，eth1 指代的是 Ethereum
  中的执行层（execution layer），eth2 指代的是 Ethereum 中的共识层（consensus
  layer）。
- 运行一个节点需要质押 32 ETH：错。不质押 ETH 也可以运行一个节点，只是没有出块权。
- The Merge 降低了 gas fee：错。The Merge 是共识的替换，并没有降低 gas fee。
- The Merge 提高了 TPS：错。The Merge 后 Ethereum 的 TPS 并没有显著的提高，出块的速度
  只是从原来的平均 13s 一个块到每 12s 一个块。提高 TPS 是 sharding的目标，而不是 The
  Merge 的目标。
- The Merge enabled staking withdrawal：错。取消质押需要等 Shanghai Upgrade 后才能
  操作。The Merge 时 Shanghai Upgrade 还没完成，所以 The Merge 后不能马上取消质押。
- 验证者不能收到出块奖励直到 Shanghai Upgrade：错。只要出块，就能得到出块奖励。
- 如果可以取消质押，所以的质押者（验证者）会同时取消质押：错。每个 epoch（6.4 mins）内最多
  允许 6 个质押者退出，如果退出者过多，会动态调节每个 epoch 的最大退出数，同时还在质押的人
  的 APR 提高，以吸引更多的人进行质押。

## Sharding

Sharding，称为分片，即在水平方向拆分数据库，分散数据库的负载，以达到扩容的目的。Ethereum 2.0
的 sharding 和 Layer 2 一起来分摊负载，这样就可以减少网络拥堵，提高 Ethereum 的 TPS。

Sharding 的特性可以让运行 Ethereum 节点的门槛降低，让更多的人运行节点，构建更稳定的共识
网络。

Sharding 的实现分两步：
1. Data availability
2. Code execution

Data availability 是在提高 TPS 的同时，保证之前的数据（即 state）是可用的；Code
execution 是在 state 都可用的情况下执行执行智能合约（Smart Contract），这一步需要引入
zk-snarks（零知识证明）。

## Conclusion
总的来说，这次 Ethereum 的 Merge 并没有完全的升级为 Ethereum 2.0，最多算是 Ethereum
1.5，毕竟目前 Ethereum 或者说整个区块链都在突破“不可能三角”[^impossible-triangle]，
其中已经有其他的公链走在 Ethereum 前面。但是只能说 Ethereum 在前期积累了较多的 dapp 和
用户，形成了聚集效应，但是 Ethereum 能否赶在其他新的公链之前突破这个三角，这个没人能预测。
从这次 Merge 来看，我们能知道的是 ETH 的供应有通缩的趋势，同时 PoW 转为 PoS 变成了有钱的
更有钱，没钱的会更没钱，会逐渐形成两极分化。而且因为 PoS，运行节点的矿工会减少，虽然有机制
来保证质押者不会一次性大量撤出，但是没有质押的人不太会去维护一个节点。

Anyway，去中心化是一种趋势，最终谁能胜出，让我们拭目以待吧。

[^impossible-triangle]:区块链不可能三角指的是目前区块链不能同时实现去中心化、可拓展性和安全性。

## Reference

1. The Beacon Chain. https://ethereum.org/en/upgrades/beacon-chain/
2. The Merge. https://ethereum.org/en/upgrades/merge/
3. How The Merge impacts ETH supply. https://ethereum.org/en/upgrades/merge/issuance/
4. Tim Beiko. 2021. How The Merge Impacts Ethereum's Application Layer. https://blog.ethereum.org/2021/11/29/how-the-merge-impacts-app-layer
5. Tim Beiko. 2022. Shanghai Planning. https://github.com/ethereum/pm/issues/450
6. Wackerow. 2022. SPIN UP YOUR OWN ETHERUM NODE. https://ethereum.org/en/developers/docs/nodes-and-clients/run-a-node/
7. Ethereum 2.0 Knowledge Base. https://kb.beaconcha.in/glossary

## Appendix
### Appendix A. Shanghai Upgrade
Shanghai Upgrade 需要实现以下的 EIP：

- EIP-1153: Transient storage opcodes
- EIP-2537: Precompile for BLS12-381 curve operations
- EIP-2935: Save historical block hashes in state
- EIP-3651: Warm COINBASE
- EIP-3540: EVM Object Format (EOF) v1 + EIP-3670, EIP-3690, EIP-4200
- EIP-3855: PUSH0 instruction
- EIP-3860: Limit and meter initcode
- EIP-4396: Time-Aware Base Fee Calculation
- EIP-4444: Bound Historical Data in Execution Clients
- EIP-4488: Transaction calldata gas cost reduction with total calldata limit
- Statelessness gas cost changes (Verkle Tree HF1) and the groundwork necessary for it (unhashed state + sync)
