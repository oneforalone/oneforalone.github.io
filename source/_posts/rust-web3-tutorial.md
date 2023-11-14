---
title: Rust Web3 Tutorial
date: 2022-04-12
categories: Blockchain
tags:
  - Rust
  - Web3
  - Blockchain
---

## 使用 rust web3 获取最新区块

1. 创建项目
```bash
cargo new get-block
cd get-block
```
项目目录结构为：
```bash
$ tree ./
./
├── Cargo.toml
└── src
    └── main.rs
```

2. 添加依赖库

在 `Cargo.toml` 中的 `[dependencies]` 下添加两个依赖库：

```
[dependencies]
web3 = "0.18.0"
tokio = { version = "0.17.0", features = ["full"] }
```

3. 编写代码

`src/main.rs`:
```rust
use web3::types::{U64, BlockId, BlockNumber};

#[tokio:main]
async fn main() -> web3::Result<()> {
  let provider_url = "http://127.0.0.1:8545";
  let transport = web3::transports::Http::new(provider_url)?;
  let web3 = web3::Web3::new(transport);
  // get the latest block number/height
  let block_number: U64 = web3.eth().block_number().await?;
  println!("The latest block number is: {}", block_number);

  // get the latest block via block number
  let block_id = BlockId::Number(BlockNumber::Number(block_number));
  let block = web3.eth().block(block_id).await?.unwrap();
  println!("The block is: {:?}", block);

  Ok(())
}
```

4. 启动 ganache-cli

```bash
ganache-cli --fork.network mainnet
```

没有安装 `ganache-cli` 的需要使用 `nodejs` 的 `npm` 安装：

```bash
npm install ganache -g
```

5. 编译执行

```bash
cargo run
```

执行结果如下：

```
The latest block number is: 14571627
The block is: Block { hash: Some(0x539eec4efc530cee8931265f0362c8d6e51f409d746a60176a5c4efd7da4fa79), parent_hash: 0x8fe6477d17d988aa7e275f6cfd330acc0926061ac71a226387c618f9e16263e4, uncles_hash: 0x1dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347, author: 0x0000000000000000000000000000000000000000, state_root: 0x2fed728ac42e8c196df8ba629d499fc73a666869b8ebfa586ffa430a9f8d5cbe, transactions_root: 0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421, receipts_root: 0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421, number: Some(14571627), gas_used: 0, gas_limit: 30000000, base_fee_per_gas: Some(65083191975), extra_data: Bytes([]), logs_bloom: Some(0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000), timestamp: 1649778365, difficulty: 1, total_difficulty: Some(46186172474616782016825), seal_fields: [], uncles: [], transactions: [], size: Some(518), mix_hash: Some(0x0000000000000000000000000000000000000000000000000000000000000000), nonce: Some(0x0000000000000000) }
```
