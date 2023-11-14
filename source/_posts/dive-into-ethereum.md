---
title: Dive into Ethereum
date: 2022-05-05 02:45:08 PM
categories: Blockchain
tags:
  - Blockchain
  - Ethereum
---

**NOTE**: This is a draft.

在上篇 {% post_link overview-of-ethereum %} 中，只是粗略的去了解了一下 ethereum 中的一
些基础概念。而要想深入 Ethereum，必然少不了 EVM。EVM 就是 Ethereum 的灵魂。

## EVM

### EVM execution context:

- The Code: smart contract byte code which is immutable, it is stored on-chain
  and referenced using a contract address
- The Stack: call stack, an empty stack is initialized for each EVM contract
  execution
- The Memory: contract memory, a clean memory is initialized for each EVM
  contract execution
- The Storage: contract storage which is persisted across executions, it’s
  stored on-chain and is referenced via a contract address and its storage slot.
- The Call Data: the input data for a transaction
- The Return Data: the data returned from a contract function call

Tips: zero function signature selector: `wfjizxua()`, it's signature is
`0x00000000`

The main difference between `DELEGATECALL` and `CALL` is which storage the
contract access. `CALL` will access the contract’s storage which contains the
function, `DELEGATECALL` will access the contract’s storage which call this
function.

`JUMP`: jump to the location of the top of the stack value
`JUMPI`: if the top of the stack value is 0 , jump to the location of the second
of the stack value, otherwise no jump
`JUMPDEST`: mark a location as a valid jump target. If the target location do
not contain a JUMPDEST opcode, the execution will fail.

### OPCODES

#### contract creation

push1 80
push1 40

a sign for contract creation
`0x60806040`

opcode: push1 -> 60

evm operation base on 32 bytes

why 80 and 40, this is hex,

`0x80` is 128 in decimal, one hex stands for 4 bits,

32 bytes = 256 bits = 64 hex string = `0x40`

in memory:
80 stands for start point of the memory pointer, max length 32 bytes
`0x00` - `0x40` reserver for hash compute
`0x40` - `0x80` storing the memory pointer

more details:
`0x00` - `0x3f` (64 bytes): scratch space, can be used between statements i.e.
within inline assembly and for hashing methods.
`0x40` - `0x5f` (32 bytes): free memory pointer, free memory pointer, currently
allocated memory size, start location of free memory, `0x80` initially
`0x60` - `0x7f` (32 bytes): zero slot, is used as an initial value for dynamic
memory arrays and should never be written to.

so free memory pointer assambly is:

```
PUSH1 80
PUSH1 40
MSTORE
```

The hex code is : `0x6080604052`

#### function selector

In EVM OPCODE:

function signature (4 bytes) + function arguments ( each is 32 bytes)

function signature:
keccak256("function-name(arg1-type, arg2-type, ...)") and get the first 4 bytes,
8 hex string.

function selector, compare with the function signature, with the function entry
program counter(PC), if eq, then jump to the location which pc point to.

```
PUSH1 0x0

CALLDATALOAD // load the arguments after the function signature

PUSH1 0xe0   // 0xe0 = bits_of(calldataload, in this case is 32bytes, 256 bits)
             // - bits_of(function siganatures, normally is 4 bytes, 32 bits),
             // thus 0xe0(224) = 0x100(256) - 0x20(32)

SHR // bit shift right, the first item on the top of stack is the how much to
    // shift, and the second item on the top of stack is value need to shifting.
    // This step is to get the function signature

DUP1

PUSH4 0x2E64CEC1

EQ // compare the two items on the top of stack, if equal, then push 1 to the
   // stack, otherwise push 0

PUSH2 0x3b // the entry of function signature 0x2E64CEC1

JUMPI // jump to 0x3b if the second item on the top of stack is 1, otherwise
      // continue to the next operation

DUP1 // Offset 17

PUSH4 0x6057361D // Offset 18

EQ // Offset 23 (previous instruction occupies 5 bytes)

PUSH2 0x59 // Offset 24

JUMPI // Offset 27 (previous instruction occupies 3 bytes)

// These are just padding to enable us to get to program counter 59 & 89
PUSH30 0x0 // Offset 28


// retrieve() bytecode
JUMPDEST // Offset 59 (previous instruction occupies 31 bytes)
PUSH1 0x1 // Offset 60 (retrieve() function execution...)


// These are just padding to enable us to get to program counter 59 & 89
PUSH26 0x0 // Offset 62 (previous instruction occupies 2 bytes)


// store(uint256) bytecode
JUMPDEST // Offset 89 (previous instruction occupies 27 bytes)
PUSH1 0x0 // Continue function execution....
```

step 1: free memory pointer

```
PUSH1 80
PUSH1 40
MSTORE
```

step 2: calldata check

```
PUSH1 04
CALLDATASIZE
LT
PUSH2 0056 // position of revert
JUMPI
```

step 3: function selector

```
// extract first four bytes of calldata(function signature hash)
013 PUSH4 ffffffff
018 PUSH29 0100000000000000000000000000000000000000000000000000000000
048 PUSH1 00
050 CALLDATALOAD
051 DIV
052 AND
// matches the first function, here is totalSupply(), if matches, jump to 091
053 PUSH4 18160ddd
058 DUP2
059 EQ
060 PUSH2 005b // 0x005b = 091
063 JUMPI
// matches the second function, here is balanceOf(address), if matches, jump
// to 130
064 DUP1
065 PUSH4 70a08231
070 EQ
071 PUSH2 0082 // 0x0082 = 130
074 JUMPI
// matches the third function, here is transfer(address, uint256), if matches,
// jump to 176
075 DUP1
076 PUSH4 a9059cbb
081 EQ
082 PUSH2 00b0 // 0x00b0 = 176
085 JUMPI
// no match (and no fallback function), revert, terminate execution
086 JUMPDEST
087 PUSH1 00
089 DUP1
090 REVERT
```

#### function wrapper

function entry point

#### function body

the content of a function

#### Metahash

associate with swarm storing the source code.
