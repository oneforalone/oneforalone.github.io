---
title: Web3 Development Toolkits
date: 2022-04-13
categories: Blockchain
tags:
  - Blockchain
  - Ethereum
  - Web3
---

## 序
智能合约，目前公认的是 Ethereum 上的定义，可以简单的理解为运行在 Ethereum 中 EVM 上的程序，
推广一下就是运行在分布式系统上的程序。

而一个程序的开发过程，不外乎来说有三步：编写源代码，编译以及链接。

通常来说，编译和链接都是由一个工具完成的，而对于区块链来说，链接对应的是上链（我喜欢这么叫，反正
就是将编译出来的 EVM 字节码发布到节点上），而上链设计到网络交互，这个差异就导致了编译和链接是
由不同的工具完成。

当然，官方有提供 IDE —— Remix，使用也很简单，但是相信我，作为一个学习者，使用 IDE 不是个
好途径。（因为网络的原因，我经常会遇到要修改一个合约代码时加载不出来，然后又要重写。所以国内的
话，能不用 Remix 就不用）。出了网络的问题，还有一个就是 IDE 有时会掩盖掉一些细节，anyway，
IDE 这个问题只能说是见仁见智，反正我学习时是不喜欢。

以下是我了解到的智能合约开发的 toolkits。

> P.S. 目前我所指得智能合约均指代的是 Etheruem 生态的智能合约，不涉及 NEAR 和 SOLONA 这
> 些链的智能合约开发（这两个链最好还是先把 Rust 学一遍吧，因为他们的合约使用 Rust 去写的）。

NOTE: 因为区块链又和 "Web3" 紧密联系到一起了，所以，在开发智能合约时，最好还是先去学一下
JavaScript (或者 NodeJS)，不然就会像我一开始学开发智能合约一样，两眼懵逼，又要看 Solidity
的文档，还要去查 NodeJS 的文档。

## Hardhat
这个 toolkit 使用起来很简单，我目前使用的就是这个，但是最近准备把 Rust 用起来，准备切换到
Foundry 开发了。首先，先将官方文档的链接放出来：https://hardhat.org/getting-started
如果有条件的话，建议还是去看英文文档。

### 安装
安装有两种选择:

* 安装在对应的项目，只有进入当前项目才能使用：

```bash
npm install --save-dev hardhat
```

* 安装到系统环境中，可以在系统的任意目录下使用：

```bash
npm install -g hardhat
```

### 使用
#### 初始化

```bash
npx hardhat
```

执行完这条有如下输出，会有一些配置选项：

```
888    888                      888 888               888
888    888                      888 888               888
888    888                      888 888               888
8888888888  8888b.  888d888 .d88888 88888b.   8888b.  888888
888    888     "88b 888P"  d88" 888 888 "88b     "88b 888
888    888 .d888888 888    888  888 888  888 .d888888 888
888    888 888  888 888    Y88b 888 888  888 888  888 Y88b.
888    888 "Y888888 888     "Y88888 888  888 "Y888888  "Y888

👷 Welcome to Hardhat v2.9.3 👷‍

? What do you want to do? …
❯ Create a basic sample project
  Create an advanced sample project
  Create an advanced sample project that uses TypeScript
  Create an empty hardhat.config.js
  Quit
```

可以根据自己的需求进行选择，如果不知道该选哪个，直接一路按回车选默认的就好了。默认会创建一些基础
的文件（以下是除了 `node_modules` 的目录结构）：

```
$ tree -I node_module ./
./
├── README.md
├── contracts
│   └── Greeter.sol
├── hardhat.config.js
├── package-lock.json
├── package.json
├── scripts
│   └── sample-script.js
└── test
    └── sample-test.js

3 directories, 7 files
```

* `contracts` 目录：存放 solidity 源代码文件
* `hardhat.config.js`: Hardhat 配置文件
* `scripts`: 存放部署（上链）合约的 JS 脚本文件
* `test`: 存放测试合约的 JS 脚本文件

至于 `package-lock.json` 和 `package.json` 这两个文件是 npm 的配置文件。主要是因为
`node_modules` 目录太大了，不会上传到 Github 上，所以别人使用你的代码时，只要执行
`npm install` 就会把所有的依赖都安装好。

#### 配置
这里需要额外介绍一下 `hardhat.config.js` 文件，最初的文件内容为：

```js
require("nomiclabs/hardhat-waffle");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.4",
};
```

其中配置中可以添加 `task`，上面代码中是一个打印当前配置所以的账户地址，名字叫 `accounts`
—— `task` 函数中第一个参数。执行 `npx hardhat accounts` 就是执行这个 `task` 函数。
如果你喜欢的话，也可以添加一个部署（`deploy`）任务：

```js
task("deploy", "Deploying the contract", async (taskArgs, hre) => {
  // set the first account to deployer
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying contracts with account: ", deployer);
  console.log("Account balance: ", (await deployer.getBalance()).toString());

  // get contract instance
  const Greeter = await hre.ethers.getContractFactory("Greeter");
  const greeter = await Greeter.deploy("Hello, world");
  await greeter.deployed();

  console.log("Greeter deployed to: ", greeter.address);
});
```

保存后需要部署时直接执行：`npx hardhat deploy` 就可以将合约部署到链上了。不过我不推荐，
因为配置文件一旦设置好后，我基本不会去改，而部署的脚本经常要改动的，我更喜欢在 `scripts`
目录下创建一个 `deploy.js` 的部署脚本。

这里稍微讲解一下脚本里的一些方法和属性：

* `hre.ethers.getContractFactory(Greeter"` 函数中的参数是构造一个合约的对象，参数是
  `contracts` 目录下 `.sol` 的文件名，即合约的文件名。
* `Greeter.deploy("Hello, world")`，是将合约部署到链上，其中参数就是合约构造函数的参数，
  如果有多个参数的话，以逗号分隔。
* `await greeter.deployed()`，是等待合约上链成功，因为区块打包需要一定时间。
* `greeter.address`: 合约部署成功后的地址，可以去区块链的 scan 网站查看，Ethereum 的是
   https://etherscan.io。

其实前两个方法可以合并成一段代码：

```js
const greeter = await hre.ethers.getContractFactory("Greeter")
                                .deploy("Hello, world");
```

不过这样看起来有点乱。不优雅。

Whoo, 介绍完 `task` （其实也顺带介绍了部署），然后再介绍一下 `module.exports`。

首先是其中的第一个 key/value：`solidity: "0.8.4"`，这个是制定对应的 `solidity` 的版本，
有一点需要注意，不同版本的 `solidity` 所支持的特性有所不同。

然后可以在其中添加 `network` 的配置，就是指定合约具体要部署到 Ethereum Ecosystem 上具体
的 Network，是 `mainnet`，还是 `testnet`，还是 `sidechain`，亦或是 `layer 2`？以下给出
一些对应的 network 的配置以供参考：

```js
module.exports = {
  // solidity: "0.8.4", // depends on your solidity version
  solidity: {
    version: "0.8.4",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  }
  defaultNetwork: "rinkeby", // defined below
  networks: {
    mainnet: {
      url: "https://xxxxxxxxxxx", // your node provider link
      accounts: [privateKey1, privateKey2, ...], // this array stores your accounts' private key
    },
    rinkeby: {
      url: "https://xxxxx",
      accounts: [privateKey1, privateKey2, ...],
    },
    mumbai: {
      url: "https://xxxxxxx",
      accounts: [privateKey1, privateKey2, ...],
    },
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  mocha: {
    timeout: 40000
  }
}
```

* `networks`: `networks` 中每个网络的 `url` 的值是节点的链接，就是说你需要去连接一个
  **全节点**，通过这个全节点来对链进行操作，可以是第三方（如 Infura、Alchemy）提供的，
  也可以是自己本地运行的，如果是本地运行的全节点，`url` 的值可以设置为:
  `http://127.0.0.1:8545`. 因为第三方提供的服务是有 api key 或是 token 的，所以呢，
  需要进行一个封装，通用的做法是将一些私密性的配置单独存放在项目更目录下的一个文件中：`.env`.
  然后代码就需要改一下，下面只展示需要修改的，若没有出现的，保持原有的不变：

```js
// ..., the same as before
require('dotenv').config();
require('@nomiclabs/hardhat-ethers');
const { PROVIDER_URL, PRIVATE_KEY } = process.env;
// or you can write like this:
// const PROVIDER_URL = process.env.PROVIDER_URL;
// const PRIVATE_KEY = process.env.PRIVATE_KEY;

module.exports = {
  // ...
  networks {
    mainnet: {
      url: PROVIDER_URL, // your node provider link
      accounts: [`0x${PRIVATE_KEY}`], // this array stores your accounts' private key
    },
    rinkeby: {
      url: PROVIDER_URL,
      accounts: [`0x${PRIVATE_KEY}`],
    },
    mumbai: {
      url: PROVIDER_URL,
      accounts: [`0x${PRIVATE_KEY}`],
    },
  }
  // ...
}
```

`.env` 文件里的内容为：

```
PROVIDER_URL="https://eth-rinkeby.alchemyapi.io/v2/123abc123abc123abc123abc123abcde"
PRIVATE_KEY="" # fill your own private key
```

注：这里的 `PROVIDER_URL` 不同的网络对应不同的 URL，不能像上面示例一样使用同样的，否则无法
连上 full node。

`accounts` 字段的值是一个数组，数组中是账号的私钥，这里需要在导出的私钥前面添加`0x`字符串。
当然，如果代码要上传到 Github 上，私钥泄露的话，你这个地址基本也就废了，所以呢，也需要放在
`.env` 文件中。

* `solidity`: 除了可以指定版本外，还可以设置编译是是否进行优化。
* `path`: 指定了对应的源代码文件路径，`sources` 指定合约代码路径，`tests` 指定测试代码
  的路径，`cache` 指定缓存目录路径，`artifacts` 指定了合约代码编译后生成的 abi 文件的
  存放路径。
* `mocha`: 执行测试时的一些配置，上面只配置了超时时间，更多的配置参考：
  https://mochajs.org/#command-line-usage, 其中的参数是一致的。

更多相关的配置介绍，参考：https://hardhat.org/config/#path-configuration

#### 编译

```bash
npx hardhat compile
```

编译没啥好介绍的，通过了就通过了，出错了就自己去修复。

#### 上链（部署）
在 `scripts` 目录下创建一个 `deploy.js`（或者你自己取个名字，我用 deploy 命名）的文件，
文件内容如下：

```js
const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account: ", deployer.address);
  console.log("Account balance: ", (await deployer.getBalance()).toString());

  const Greeter = await ethers.getContractFactory("Greeter");
  const greeter = await Greeter.deploy("Hello, world");

  await greeter.deployed();

  console.log("Contract deployed at: ", greeter.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  })
```

然后执行：

```bash
npx hardhat run scripts/deploy.js
```

正常的话你将你的合约部署好了。后面可以加一个 `--network=<network-name>` 用来指定对应的网络
的。

Update[Fir Apr. 15 2022]: 这两天又仔细瞄了一眼 Hardhat 的文档，发现 `scripts` 目录下的
脚本是完全不依赖 Hardhat 的，如果使用 `web3.js`/`etheres.js` 库的话，可以直接用 nodejs
执行。

对了，忘了写怎么测试了，我测试的话直接是用的 `web3.js`，直接部署到测试网上测试的，反正不要钱。

## Truffle
今天试着用了一下 Truffle，发现是真的难用（可能是我水平不够），反正我不喜欢。Truffle 基础的
使用是真的简单，但是它的配置和部署不是很适合我。最主要的原因还是，在里面需要额外多加一个
`Migrate.sol` 的合约，部署时也要先部署`Migrate`，官网的解释是说确保安全，同时说也可以自己
去修改 `Migrate.sol` 合约。我比较喜欢 KISS( Keep It Simple and Stupid) 的准则。额外
多加一个合约，部署时就得付 gas fee，安全的话直接使用 Openzeppelin 的库就好了。还有一个就是
如果合约要引用 npm 安装的库的话，不能使用通用的引用格式。这个也让我不太喜欢。

当然也不是没有优点的，那就是 truffle 可以和 ganache 直接交互，使用命令 `truffle develop`
或是 `truffle console` 就可以直接进入交互模式，前提是需要先启动 ganache。

好了，介绍就说到这里了，下面简单介绍下怎么使用吧。

### 安装
说到安装，在国内的环境是真的很痛苦，除非使用代理，不过代理最好是稳定一点的，我就是因为代理稍微有
点不稳定（可能是我用的设备比较多），导致出错好几次，浪费我将近一个小时的时间。

```bash
# configure your proxy first
export https_proxy=http://127.0.0.1:7890 \
       http_proxy=http://127.0.0.1:7890 \
       all_proxy=socks5://127.0.0.1:7890
node install -g truffle
```

### 使用
#### 初始化

```bash
mkdir my-project
truffle init
```

#### 配置
编辑项目目录下的 `truffle-config.js`:

```js
module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*"
    },
    test: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*"
    }
  },

  compilers: {
    solc: {
      version: "^0.8.0"
    }
  }

}
```

上面只配置了测试开发的网络，主网的话需要配置一样，只不过是 `host` 的值设为全节点的 IP 或
URL，和 hardhat 配置中的网络配置的 `url` 参数去掉端口的值，然后 `port` 就写成对应的端口就
好，本地的 ganache-cli 的话是 8545，ganache GUI 版本的话端口就是 7545，如果是第三方提供
的全节点的话，那么就是 80/443。或者是直接不使用 host 参数，而是使用 `provider` 参数，值
设置为 `new Web3.providers.HttpProvider("https://<host>:<port>)`。当然 `network`
里面也可以设置 `gas`、`gasPrice`、`from` 等参数。详细的配置说明见：
https://trufflesuite.com/docs/truffle/reference/configuration

#### 编译
编译很简单，直接执行 `truffle compile` 就可以了，编译好的 abi 文件默认存放在 `build` 目录
下。这个目录路径也可以在 `truffle-config.js` 中配置，在其中添加一行：

```js
contracts_build_directory: "/path/to/the/abi/output/director"
```

路径自己定义，不要照抄。


#### 部署
首先要在 `migrations` 目录下创建一个对应的脚本，一般习惯命名为 `2_deploy_contracts.js`,
因为该目录下已经有一个 `1_initial_migration.js` 文件了。这里以官方给的例子讲解：

```bash
mkdir MetaCoin
cd MetaCoin
truffle unbox metacoin
truffle migrate
```

`truffle migrate` 会自动执行 `migrations` 目录下所有的脚本。MetaCoin 的目录结构如下：

```
$ tree ./
./
├── LICENSE
├── contracts
│   ├── ConvertLib.sol
│   ├── MetaCoin.sol
│   └── Migrations.sol
├── migrations
│   ├── 1_initial_migration.js
│   └── 2_deploy_contracts.js
├── test
│   ├── TestMetaCoin.sol
│   └── metacoin.js
└── truffle-config.js

3 directories, 9 files
```

其中 `MetaCoin.sol` `import` 了 `ConvertLib.sol`。

MetaCoin 的 `2_deploy_contracts.js` 如下：

```js
const ConvertLib =artifacts.require("ConvertLib");
const MetaCoin = artifacts.require("MetaCoin");

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, MetaCoin);
  deployer.deploy(MetaCoin);
}
```

前两行没啥可讲的，就是导入合约的 abi，即 json 文件。然后先部署被 `import` 的合约
（`ConvertLib.sol`)，将两个合约链接到一起（`deployer.link(ConvertLib, MetaCoin)`，
最后在部署调用其他合约的合约。

这里的部署函数被完全封装起来了，我也不想去扒其中的代码了，所以不要问 `deployer` 是什么了，具
体是什么我没去看源代码，不确定，但可以推测出 truffle 封装了一个根据配置文件中的一些配置生成了
个 `web3.eth.Contract` 对象传进去了。所以说我不太喜欢它，封装的有点过了，虽然可以完全用
`web3.js` 写一个部署脚本，但那样的话我为什么不用 hardhat 呢？

Truffle 介绍也就到这里了，最后再附上官方文档地址：
https://trufflesuite.com/docs/truffle/quickstart/

> P.S. truffle 还有一个槽点就是团队不怎么维护了，所以不推荐使用。

Update[Sun Apr. 17 2020]: 忘了介绍怎么在 truffle 的项目中使用第三方的合约了，这也是我吐槽
的一个槽点，标准的 Solidity 语法是：
`import "@OpenZeppelin/contracts/token/ERC20/ERC20.sol";`

而到了 truffle 项目中，引用是这样的：
`import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";`

所以 truffle 在引用三方的合约时，需要注意。

## Brownie
Brownie，一个由 python 和 web3.py 实现的一个 toolkit，或者说 framework 吧。怎么叫随你
了。其中 brownie 的优势是，其提供了 GUI 界面显示合约的 opcode，可以对合约进行 evm 级别的
优化。当然，前提是你要了解 evm 的 opcode 具体含义，这个有点 hardcore，因为 evm 的 opcode
类似于汇编语言，所以比较难写。

### 安装

```bash
python3.9 -m pip install --user pipx
python3.9 -m pipx ensurepath
source ~/.zshrcr
pipx install eth-brownie
```

**注**：这里需要使用 python3.9 或相近的版本，但不能高于 3.9，比如 3.10 安装会出错的。
我只验证过 python3.9，3.8 和 3.7 没有验证过。

### 使用
#### 初始化
初始化项目很简单，基本命令都是通用的，就一句：

```bash
brownie init
```

执行后会在目录下自动生成一些目录，目录结构为：
```
$ tree ./
./
├── build
│   ├── contracts
│   ├── deployments
│   └── interfaces
├── contracts
├── interfaces
├── reports
├── scripts
└── tests

9 directories, 0 files
```

* `contracts`：存放合约源代码
* `interfaces`：存放合约的 interface 源代码
* `scripts`：存放合约部署、交互的脚本
* `tests`：存放测试脚本
* `build`：存放编译后的文件代码以及测试结果
* `reports`：可选的，这里放的是 JSON 报告文件，供 GUI 中使用

#### 配置
`brownie init` 不会像 truffle 和 hardhat 那样提供一些初始的配置文件和示例代码，所以需要
自己手动创建配置文件，配置文件名为：`brownie-config.yaml`。

```yaml
dependencies:
  - OpenZeppelin/openzeppelin-contracts@4.1.0

compiler:
  solc:
    version: '0.8.4'
    optimizer:
      enabled: true
      runs: 200
    remappings:
      - '@OpenZeppelin=OpenZeppelin/openzeppelin-contracts@4.1.0'

# Automatically fetch contract sources from Etherscan
autofetch_sources: true
dotenv: .env
networks:
  defaults: development
  development:
    verify: false
  rinkeby:
    verify: false
  ganache:
    verify: false
wallets:
  private_key: ${PRIVATE_KEY}
  mnemonic: ${MNEMONIC}
```

配置和前面的两个也是大同小异，基本的网络、编译器的配置参数基本一致，只要在 brownie 中的编译
的配置中，多了 `dependencies` 和 `remapping` 这两个参数，这里 `dependencies` 下值是
`<Github Name>/<repo-name>@<version>`，通过这个配置 brownie 会自动去 Github 上拉取
对应的代码，然后通过 `remappings` 来映射成合约中的引用。

因为 `solidity` 引用三方库的标准语法是 `@OpenZeppelin/.....`，所以就写成
`@OpenZeppelin=OpenZeppelin/openzeppelin-contracts@4.1.0`

而 `networks` 中每个 network 的 `verify` 是用来是否是在 `etherscan.io` 上开源代码，
因为默认部署后并不是开源的，而是一堆 EVM 的 OP Code。

`dotenv` 业内通用，一些比较私密性的配置，都喜欢放到 `.env` 文件中，这里的也需要创建一个
`.env` 文件，文件中一般需要设置为：

```
export WEB3_INFURA_PROJECT_ID=''
export PRIVATE_KEY=''
export MNEMONIC=''
export ETHERSCAN_TOKEN=''
```

首先是全节点的信息，如果你自己本地有全节点的话，可以不用配置，直接在部署测试中写就好了，毕竟
brownie 使用的是 `web3.py`，和 `web3.js` 基本没差。其他的配置都可以直接通过名字就知道其
配置是干啥的，私钥，助记词，etherscan 的 token。

#### 编译
编译和其他的一样，都是后面加个 `compile` 就好了

```bash
brownie compile
```

#### 部署

```bash
brownie run scripts/deploy.py
```

部署命令都可以手动指定网络的，通过 `--network <network-name>`。这也是 brownie一个优点，
就是其默认内部集成了很多的网络，可以使用 `brownie networks list` 来查看。

以合约源文件为 `Hello.sol` 为例，其中 `deploy.py` 的如下：

```python
#!/usr/bin/python3

from brownie import (
  config,
  network,
  accounts,
  Hello,
)

import eth_utils

NON_FORKED_LOCAL_BLOCKCHAIN_ENVIROMENTS = ["development", "ganache"]
LOCAL_BLOCKCHAIN_ENVIROMENTS = NON_FORKED_LOCAL_BLOCKCHAIN_ENVIROMENTS + [
  "mainnet-fork",
  "binance-fork",
  "matic-fork",
]

def get_account(number=None):
  if network.show_active() in LOCAL_BLOCKCHAIN_ENVIROMENTS:
    return accounts[0]
  if number:
    return accounts[number]
  if network.show_active() in config["networks"]:
    return accounts.add(config["wallets"]["from_key"])
  return None

def main():
  account = get_account()
  print(f"Deploying to {network.show_active()}")
  hello = Hello.deploy({"from": account})
  # hello = Hello.deploy(
  #   {"from": account},
  #   publish_source=config["networks"][network.show_active()]["verify"]
  # )
  print(f"Deployed to: { hello.address }")

```

`Hello.deploy()` 中 `Hello` 为合约名，需要从 brownie 中导入，`deploy()` 中首先是要有
合约构造时的参数，如果构造函数没有参数那就不用写，然后后面就是跟对应的 transaction 中的属性
了，如果想部署时同时发布源代码，就使用 `publish_source` 来指定是否发布，`publish_source`
的类型为 `boolean`，可以通过在配置文件中配置对应网络的值。

> P.S. 这里需要注意的是，因为 Github 增加了其安全性，所以需要自己到 Github 上生成一下
> Token，然后在 `.zshrc` / `.bashrc` 中添加 `GITHUB_TOKNE="<your-github-token>"`

如果要与合约进行交互的话，就需要从 brownie 中导入 `Contract` 模块：

```python
from brownie import Contract
```

然后构建一个 Contract 的对象：

```python
hello_contract = Contract.from_abi("Hello", hello.address, Hello.abi)
```

部署后可以使用 `brownie gui` 查看对应合约的 opcode。这个我就看到文档可以这样做，但是具体
我没操作过，毕竟还没达到那个水平。

最后同样是附上官方文档： https://eth-brownie.readthedocs.io/en/stable/

## Foundry
Foundry 是个用 rust 实现的 toolkit，用法和 Brownie 差不多。要注意的一点就是 Foundry
是这个 toolkit 的名字，但是内部命令不是 foundry，而是 `forge` 和 `cast` 两个命令。

### 安装
官方提供的安装二进制的方法我在 M1 上失败了，所以我就从源代码直接编译出来了。

官方的安装二进制的命令：

```bash
curl -L https://foundry.paradigm.xyz | bash
```

在从源代码编译安装之前，需要首先安装好 Rust 和 Cargo，不然你怎么编译呢？

从源代码编译安装官方也提供了对应的命令：

```bash
cargo install --git https://github.com/foundry-rs/foundry --bins --locked
```

### 使用
#### 初始化
这些 toolkits 的初始化命令大同小异，这个因为是 rust 开发的，所以就会继承 rust 的一些特性，
比如，创建新项目可以直接指定项目名。

```bash
forge init hello
```

这条命令会在当前目录下创建一个 hello 的文件夹，文件夹的目录结构为：

```
$ cd hello
$ tree ./
./
├── foundry.toml
├── lib
│   └── ds-test
│       ├── LICENSE
│       ├── Makefile
│       ├── default.nix
│       ├── demo
│       │   └── demo.sol
│       └── src
│           └── test.sol
├── src
│   └── Contract.sol
└── test
    └── Contract.t.sol

6 directories, 8 files
```

* `foundry.toml`：配置文件
* `lib`：存放一些依赖库、模版
* `src`：存放合约源代码文件
* `test`：存放测试合约代码，一般都是 `ContractName.t.sol`

编译后会多出两个文件夹，一个是 `out`，里面存放的是合约的 abi等文件，`cache` 就是一些缓存，
重新编译时会检查里面的文件来进行对应的编译。

#### 配置
Foundry 的配置文件为 `foundry.toml`

```
[default]
# The source directory
src = 'src'
# The test directory
test = 'test'
# The artifact directory
out = 'out'
# A list of paths to look for libraries in
libs = ['lib']
# A list of remappings
remappings = []
# A list of deployed libraries to link against
libraries = []
# Whether to cache builds or not
cache = true
# Whether to ignore the cache
force = false
# The EVM version by hardfork name
evm_version = 'london'
# Override the Solidity version (this overrides `auto_detect_solc`)
#solc_version = '0.8.10'
# Whether or not Forge should auto-detect the solc version to use
auto_detect_solc = true
# Disables downloading missing solc versions
offline = false
# Enables or disables the optimizer
optimizer = true
# The number of optimizer runs
optimizer_runs = 200
# The verbosity of tests
verbosity = 0
# A list of ignored solc error codes
ignored_error_codes = []
# The number of fuzz runs for fuzz tests
fuzz_runs = 256
# The max number of individual inputs that may be rejected before a fuzz test aborts
fuzz_max_local_rejects = 65536
# The max number of combined inputs that may be rejected before a fuzz test aborts
fuzz_max_global_rejects = 1024
# Whether or not to enable `cheats.ffi`
ffi = false
# The address of `msg.sender` in tests
sender = '0x00a329c0648769a73afac7f9381e08fb43dbea72'
# The address of `tx.origin` in tests
tx_origin = '0x00a329c0648769a73afac7f9381e08fb43dbea72'
# The initial balance of the test contract
initial_balance = '0xffffffffffffffffffffffff'
# The block number we are at in tests
block_number = 0
# The chain ID we are on in tests
chain_id = 99
# The gas limit in tests
gas_limit = 9223372036854775807
# The gas price in tests (in wei)
gas_price = 0
# The block basefee in tests (in wei)
block_base_fee_per_gas = 0
# The address of `block.coinbase` in tests
block_coinbase = '0x0000000000000000000000000000000000000000'
# The block timestamp in tests
block_timestamp = 0
# The block difficulty in tests
block_difficulty = 0
# A list of contracts to output gas reports for
gas_reports = ["*"]
# Enables or disables RPC caching when forking
no_storage_caching = false
# Caches storage retrieved locally for certain chains and endpoints
# Can also be restricted to multiple chains
# By default only remote endpoints will be cached
# To disable storage caching, set `no_storage_caching = true`
rpc_storage_caching = { chains = "all", endpoints = "remote" }
# Extra output to include in the contract's artifact.
extra_output = []
# Extra output to write to separate files.
extra_output_files = []
# Use the given hash method for the metadata hash that is appended
# to the bytecode.
# The metadata hash can be removed from the bytecode by setting "none"
bytecode_hash = "ipfs"
# If enabled, the Solidity compiler is instructed to generate bytecode
# only for the required contracts. This can reduce compile time
# for `forge test`, but is experimental.
sparse_mode = false
```

上面的配置文件包含了大部分参数，注意也讲解的很清楚，这里只想介绍一下 `remapping`。因为现在
大部分合约都会调用 `OpenZeppelin` 的库，所以本文档中的第三方库都是以 `OpenZeppelin` 的
为例。

不同于上面三个 toolkit，foundry 安装三方库不是使用 npm 安装保存在项目目录下的，而是通过
`forge` 进行安装的：

```bash
forge install openzeppelin/openzeppelin-contracts
```

然后再在配置文件中添加 `remmappings` 的配置:

```
remappings= ['@openzeppelin=lib/openzeppelin-contracts']
```

这个其实和 brownie 比较类似，都是去 Github 上下载源代码。当然，测试合约中就是这样调用的，
也可以将测试合约调用的库进行 *remapping* 一下：

```
remappings = [
  '@openzeppelin=lib/openzeppelin-contracts',
  '@ds-test=lib/ds-test/src/'
]
```

然后测试合约中的 `import "ds-test/test.sol";` 就可以改写成
`import "@ds-test/test.sol";`

好像有点脱裤子放屁的感觉，因为测试合约中本生就是调用本地的，无所谓了，这样更符合标准一点，毕竟
`ds-test` 是创建项目时默认添加的库，第三方库的引用还是统一用 Solidity 的标准的好。

> P.S. 就是不知道为什么 truffle 不支持 remapping。

#### 编译
和上面三个不同的是，foundry 的编译用的是 build 命令，这和其实现有关，毕竟是 rust 写的。

```bash
forge build
```

#### 部署
Foundry 的部署上面三个要稍微繁琐一点，不支持脚本。没办法，编译型语言和解释型语言的差异。

```bash
$ forge create --rpc-url <your-rpc-url> \
    --constructor-args "Arg1" "Arg2" ... \
    --private-key <your-private-key> \
    src/<ContractSourceFileName>:<ContractName>
```

这些关键信息需要自己手动指定，配置文件中也配置不了。

如果要将合约代码开源的话，需要使用 `forge verify-contract` 命令：

```bash
$ forge verify-contract --chain-id <chainId> \
    --num-of-optimizations <Optimization Number> \
    --constructor-args \
    (cast abi-encode "constructor(arg1, arg2, ...)" "Arg1" "Arg2") \
    --compiler-version <solc version> \
    <Contract Address> \
    src/<ContractSourceFileName>:<ContractName> \
    <your-etherscan-api-key>
```

Whoo, 这个参数有够多的，没有脚本语言舒服，希望后续可以放到配置文件中吧。

#### 交互
如果要与链进行交互的话，Foundry 使用的是另一个命令：`cast`。

这种编译型语言就是这点不太方便，不能像解释型那样直接写一个脚本然后运行就完事。所以，如果要和链上
的合约交互的话，也需要指定一些信息（个人感觉这个可以通过 rust 的 web3 写个 lib 来调用，不过
这个库更新不是很频繁）。

```bash
$ cast call <contract-address> <contract-method-signature> \
    --rpc-url <your-rpc-provider-url>
```

`cast` 还可以对 opcode 进行解码，不过前提是你要有合约中的方法的原型：

```bash
$ bash 4byte-decode <op-code> <contract-method-signature>
```

更多的去官方文档上查看吧。

官网文档：https://book.getfoundry.sh/getting-started/installation.html

## 总结
上面的使用中我都没有介绍怎么进行测试，因为我都是直接部署到测试网上，然后进行交互式的验证，反正
测试网上不要钱，直接测就好，或者本地起一个 ganache，也可以直接测试，至于具体怎么测，那肯定是看
具体的合约是什么了。你已经步入 web3 的开发了，是个成熟的开发者了，我相信你自己会对自己的合约
设计一些 TC（Test Case）的。你要是自己懒得测，被科学家们给割了那就只能是怪自己咯。

以上，简单的介绍了一下目前我所接触的一些智能合约开发所用到的 toolkit，下面就做个简单的对比吧。

| Toolkits | 实现语言    | 上手难度   | 优点               | 缺点                    | 总体评分 |
| :------- | :--------: | :------: | ------------------ | ---------------------- | ------- |
| Hardhat  | JavaScript | 1   星   | 文档全，用户多        | 无                     | 4       |
| Truffle  | JavaScript | 1   星   | 使用简单             | 项目不再更新，可配置性不高 | 3       |
| Brownie  | Python     | 2   星   | 使用方便，集成功能较多 | Python 在速度上比较慢    | 4       |
| Foundry  | Rust       | 2.5 星   | 一个字，快           | 部署和交互比较麻烦        | 3.5     |

对于刚接触 Web3 的新手来说，最推荐的还是 Hardhat，如果是说有 Python 背景的人，那么 Brownie
是个很不错的选择，毕竟不用再去学习 JavaScript，直接上手。如果是有 Rust 背景，且比较在意速度
和只想用 Solidity 写合约已经测试，那么 Foundry 是你的不二之选。要知道，没有最好，只有最
适合，所以选择时不要过于纠结，选一个适合自己的，然后专注合约的开发就好了，毕竟工具只是辅助而已，
如果你想 hardcore 一点，那么不用这些 toolkit 也是可以的，直接手动编译成 abi，然后调用 web3
的库直接部署也是可以的。

> The choice is yours.

好了，所有的介绍就到这里了。

**Update from Jun. 8 2022**

从最近使用 Foundry 的体验来看，foundry 的测试真的太爽了，尤其是其中的 cheetcodes，还有
Fuzzing，爽到起飞。具体参考：{% post_link foundry101 %}

One more thing，一个很不错的资源合集的链接：

https://github.com/OpenZeppelin/awesome-openzeppelin

Happy Crypting :)
