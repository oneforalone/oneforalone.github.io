---
title: Foundry Tutorial
date: 2022-06-08 12:25:14 PM
categories: Blockchain
tags:
  - Rust
  - Solidity
  - Ethereum
  - Blockchain
---

## Prodromes

前篇 {% post_link web3-development-toolkits %} 中对比的几个通用的 Smart Contract
toolkits，当中介绍的比较详细的是 Hardhat。 但是从切换到 Foundry 后，发现是真的爽。所以就有
了这篇 Foundry101，相信我，Foundry，你值得拥有。其实只要参考官方文档就好了，但是这里我就记录
一下自己使用的一个完整流程吧。

官方文档链接：https://book.getfoundry.sh/index.html

本篇教程的代码托管在 Github 上：[my_nft](https://github.com/oneforalone/my_nft)

## Setup

- rust

```shell
curl https://sh.rustup.rs -sSf | sh
```

- foundry

```shell
curl -L https://foundry.paradigm.xyz | bash
```

安装程序没什么，根据自己的 OS 执行对应的操作就好了，我喜欢 \*nix 的生态，同时使用的是 MacOS，
所以不会介绍 Windows 上的操作。

安装好后在将 zsh 的自动补全也配置一下：

```shell
mkdir -pv $HOME/.zfunc
echo "fpath+=~/.zfunc" >> $HOME/.zshrc
forge completions zsh > $HOME/.zfunc/_forge
cast completions zsh > $HOME/.zfunc/_cast
echo "autoload -Uz compinit && compinit" >> $HOME/.zshrc
```

## Init

创建一个新项目，本教程中项目名为 `my_nft`，所以：

```shell
forge init my_nft
```

然后就会在当前目录下创建一个 `my_nft` 的文件夹。切换到 `my_nft` 目录下。以下的操作无特殊说明
的话都是在 `my_nft` 目录下操作的。

安装 `OpenZeppelin` 和 `forge-std` 依赖库：

```shell
# OpenZeppelin
forge install openzeppelin/openzeppelin-contracts
```

`forge install` 是直接去 gihtub 上下的，后面接 Github 的账号名和对应的 repo 名。`init` 时
会自动安装 `forge-std` 库。

如果是直接使用 Github 上的源代码的话，不需要执行这些操作，直接 clone 下来就可以用，不然我为啥
要上传呢？默认 clone 下来的目录为 `my_nft`。

## Demo

具体的代码直接去 Github 的 repo 上看吧，clone 到本地：

```shell
git clone --recurse-submodules https://github.com/oneforalone/my_nft
```

这里只展示文件目录结构：

```
├── .env
├── foundry.toml
├── lib
│   ├── forge-std
│   ├── openzeppelin-contracts
│   └── solmate
├── remappings.txt
├── script
│   └── MyNFT.s.sol
├── src
│   └── MyNFT.sol
└── test
    └── MyNFT.t.sol
```

- `foundry.toml`：foundry 配置文件
- `lib` 目录：存放 `forge install` 的三方库
- `remappings.txt`：配合 `VSCode`，里面的内容和 `foundry.toml` 中的 `remappings` 是
  一致的。在配置好 `foundry.toml` 后，可执行 `forge remappings > remappings.txt` 生成。
- `script` 目录：存放 solidity 脚本，用来部署合约。
- `test` 测试合约的文件后缀均为 `.t.sol`。
- `.env`：个人配置文件，用来存放部署合约时的账号私钥，RPC_URL，EtherScan 的 API key 之类
  的，该文件要自己自行创建配置。

## Testing

执行全部的测试：

```shell
forge test
```

测试具体的函数：

```shell
forge test -vvvv --match-test=<FunctionName>
```

查看测试的代码可以看出，测试代码的函数名开头均为 `test`，如果反向测试（即测试错误案例），则文件
开头名为 `testFail`，当然，如果是知道 tx 会被 revert 的话，可以直接使用 cheatcode:
`vm.expectRevert`。

再一次强调，foundry 的 cheatcode 是真的 cool，我推测大概率是因为 foundry 引用了
[revm](https://crates.io/crates/revm)，可以直接在本地把 tx 跑一遍，所以，能够使用
cheatcode 也就不足为奇了。

而且 foundry 还可以 fuzz testing，测试时真的是爽到起飞。

忘了说了，foundry 测试也是用的合约，语言当然就是 solidity 咯，这个也要比 hardhat 要舒服，
写合约，测试合约，都是用同一种语言，这样才舒服嘛。

## Deploying

Foundry 原生的部署合约稍微有点麻烦，命令比较长：

```shell
forge create --rpc-url <your_rpc_url> \
  --constructor-args "MyNFT" "MYT" "https://www.example.com" \
  --private-key <your_private_key> \
  src/MyNFT.sol:MyNFT \
  --etherscan-api-key <your_etherscan_api_key> \
  --verify
```

看上去就很烦，而且也不太方便。不过目前已经支持使用 solidity 脚本部署了。

- `script/MyNFT.s.sol`

```
//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.10;

import "@forge-std/Script.sol";
import "../src/MyNFT.sol";

contract DeployMyNFT is Script {
    function run() external {
        address deployer = vm.addr(vm.envUint("PRIVATE_KEY"));

        console.log("The Deployer address:", deployer);
        console.log("Balance is:", deployer.balance);

        vm.startBroadcast(deployer);

        MyNFT nft = new MyNFT("MyNFT", "MYT", "https://www.example.com");
        vm.stopBroadcast();

        console.log("MyNFT deployed at:", address(nft));
    }
}
```

分别在 `.env` 和 `foundry.toml` 添加以下内容：

- `.env`

```
PRIVATE_KEY=
MAINNET_RPC_URL=
RINKEBY_RPC_URL=
ANVIL_RPC_URL="http://localhost:8545"
ETHERSCAN_KEY=
```

然后添加上自己的 private key，RPC URL 和 etherscan 的 api key。

- `foundry.toml`

```
[rpc_endpoints]
mainnet = "${MAINNET_RPC_URL}"
rinkeby = "${RINKEBY_RPC_URL}"
anvil = "${ANVIL_RPC_URL}"

[etherscan]
mainnet = { key = "${ETHERSCAN_KEY}" }
rinkeby = { key = "${ETHERSCAN_KEY}" }
```

`source .env` 后再部署到对应的网络上：

- mainnet

```
forge script DeployMyNFT --rpc-url MAINNET_RPC_URL --broadcast --verify
```

- rinkeby

```
forge script DeployMyNFT --rpc-url RINKEBY_RPC_URL --broadcast --verify
```

- anvil（本地）

```shell
forge script DeployMyNFT --rpc-url $ANVIL_RPC_URL --broadcast
```

如果想要将合于代码开源的话，如果你在配置文件中配置了对应的 api key 的话，可以在上面命令追加
参数 `--verify`。

或者自己手动执行合约代码开源：

```shell
forge verify-contract --chain-id <chain-id> \
  --number-of-optimizations <optimization number> \
  --constructor-args $(cast abi-encode "constructor(<arg1Type>,<arg2Type>,...)" arg1 arg2 ...) \
  --compiler-version <compiler-version> \
  <the-contract-address> \
  src/<contract-file>:<contract-name> \
  <etherscan-api-key>
```

如果不想加这么多参数的话，可以直接在 `foundry.toml` 中配置对应的参数，具体参数的配置参考：
https://book.getfoundry.sh/reference/config.html

## Utils

### Gas Tracking

有时候比较关心合约调用的 gas 怎么办呢？虽然 `web3.js` 有 `estimateGas` 方法，但是要每个
调用都自己手动写，有点麻烦，不过没关系，切换到 foundry，只要在 `foundry.toml` 中添加一行
`gas_reports = ["*"]`，然后执行: `forge test --gas-report` 就能将所有合约中的函数调用
的 gas 都给展示出来，如下：

```
╭──────────────────────────────┬─────────────────┬───────┬────────┬───────┬─────────╮
│ src/MyNFT.sol:MyNFT contract ┆                 ┆       ┆        ┆       ┆         │
╞══════════════════════════════╪═════════════════╪═══════╪════════╪═══════╪═════════╡
│ Deployment Cost              ┆ Deployment Size ┆       ┆        ┆       ┆         │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┤
│ 1163822                      ┆ 6564            ┆       ┆        ┆       ┆         │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┤
│ Function Name                ┆ min             ┆ avg   ┆ median ┆ max   ┆ # calls │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┤
│ mintTo                       ┆ 0               ┆ 46262 ┆ 69393  ┆ 69393 ┆ 3       │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┤
│ owner                        ┆ 2398            ┆ 2398  ┆ 2398   ┆ 2398  ┆ 2       │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┤
│ tokenURI                     ┆ 4271            ┆ 4271  ┆ 4271   ┆ 4271  ┆ 2       │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┤
│ withdrawPayments             ┆ 606             ┆ 4369  ┆ 4369   ┆ 8132  ┆ 2       │
╰──────────────────────────────┴─────────────────┴───────┴────────┴───────┴─────────╯
```

很 cool 吧。这就是原生支持 evm 的好处。我想如果有人用 golang 去写一个 toolkit 的话，也是可
以实现 foundry 所有的功能的。

### Debugger

foundry 还支持 debug 合约，这个就比较难得了。和 Remix 唯一不足的一点是，Remix 能显示
Storage，而 Foundry 的 debuger 中没有 Storage 的展示。使用方法就是：

```shell
forge test --debug <FuncName>
```

如：

```shell
forge test --debug testSetter
```

或是

```shell
forge debug --debug <contract-file> \
  --sig <FuncSig> <FuncArg1> <FuncArg2>
```

## Summary

Anyway, foundry 更新还是比较频繁的，还是尽量去官方的文档吧。

Enjoy.

## Reference

1. [Foundry Book](https://book.getfoundry.sh/index.html)
