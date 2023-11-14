---
title: Hacking in Solidity
date: 2022-06-08 12:26:50 PM
categories: Programming
tags:
  - Solidity
  - Blockchain
  - Programming
---

**NOTE: This is a draft**

## Contract Types

contract/abstract/interface/library

- `abstract`: at least one function unimplemented
- `interface`: no function implemented, all functions mark as `external`, no
  constructor/state vars, can not inherit from contracts but can inherit from
  other interfaces.
- `library`: deployed once, using `delegatecall` , no state vars, can not
  inherit or inherited, can not receive ether, can not be destroyed,can only
  call directly, not delegatecall

`using for`, directive using library for specific value types

## Base Class Functions

Inheritance Hierarchy

Derived -> Base

Explicit: contract.function()
One Level Up: super.function()

## Shadowing

state variable shadowing

base -> state var x
derived x-> state var x

not allow in the latest version

## Overriding changes

- function overrideing: `virtual` -> `override`
- visibility: `external` -> `public`
- others: non `payable` -> `view`/`pure`, `view` -> `pure`, payable X -> any

## Virtual Functions

functions without implementation

in interface, all functions considered virtual, no need to add `virtual` keyword,
functions are private visibility cannot be virtual

## State Variables

- public state variables: automatic getters
- public getters can override external functions that matchs params and return
  types and the name.
- public getters can not override

## EVM Storage

`sload` to retrieve value and `sstore` to write value not initialized varaible
is set to 0 store by order of storage slots, each slot is 32 bytes

storage packing: if the size of continulous variables less than 32 bytes, than
can put these varaiable into one slot

due to storage packing, a `uint256` type consumes less gas than `uint128` ...
if you need access a variable

## security:

- lock pragma version
  using the specific version of pragma, such as `pragma solidity 0.8.0` instead
  `pragma solidity ^0.8.0`

- function pattern:
  FIRST (check), function performs checks (who called the function, are the
  arguments in range, did they send enough Ether, does the person have tokens,
  etc.)

SECOND (effect), if al checks passed it's time to make effect to the state
variables of the current contract

LAST (interact), interact with other contracts

use check-effect-interact

```solidity
contract ChecksEffectInteractions {

  mapping(address => uint) balances;

  function deposit() public payable {
	// Check
	balances[msg.sender] = msg.value;
  }

  function withdraw(uint amount) public {
    // Check
    require(balances[msg.sender] >= amount);
    // Effect
    balances[msg.sender] -= amount;
    // Interact
    msg.sender.transfer(amount);
  }
}
```

- random, using chainlink

- loops + state variables = NO GOOD

```solidity
contract CostlyOperationsInLoop {
  uint loop_count = 100;
  uint state_variable = 0;

  function bad() external {
    for (uint i=0; i < loop_count; i++) {
      state_variable++;
	}
  }

  function good() external {
    uint local_variable = state_variable;
    for (uint i=0; i < loop_count; i++) {
	    local_variable++;
    }
    state_variable = local_variable;
  }
}
```

- functions default open (public)
- separation of privileges
  favor multisig address for critical roles or actions, such as pause/unpause/
  shudown, emergency fund drain, upgradeability, allow/deny list and critical
  parameters.
- event logging (transactions + messages)
  ensuring your contract emits the most critical events, as well as indexes the
  "commonly" accept `indexed` (faster access) event... Used for off-chain
  monitoring (helps many Dapps function), as well as important for IR situations.
  commonly accepted indexed events =ERC20 Transfer, Approval, events - NOTE:
  only transactions are on the blockchain, but messages (e.g. SC<>SC) are not,
  unless is explicitly stated within the contract for emit event to occur...

- low level OPCODE

see more on cheatsheet: https://docs.soliditylang.org/en/latest/cheatsheet.html

`call` / `delegatecall` / `staticcall`, in order to interface with contracts
that do not adhere to the ABI, or to get more direct control over the encoding.

```
bytes memory payload = abi.encodeWithSignature("register(string)", "MyName");
(bool success, bytes memory returnDate) = address(contracAddress).call(payload);
require(success);
```

run the contract methods by `call`

```
address(contracAddress).call{gas: 10000, value: 1 ether}(
  abi.encodeWithSignature("register(string)", "MyName"));
```

`delegatecall` only the code of the given address is used, all other aspects
(storage, balance, ...) are taken from the current contract, i.e. the caller
contract. However, change the storage based on the order of contract varaiable
define, is the order is not the same, there would be some problem. And do not
support `value` option in tx

`staticcall` is same as `call` expect that `staticcall` do not change the state
of the contract, if it does, then it will revert

`callcode` di not provide access to the original `msg.sender` and `msg.value`.
And this function was removed in version 0.5.0.

`selfdestruct(address)` will destory the contract and send all the balance of
the contract to the `address` passing by.

`private` variable does not mean it private to all, it can still be retrieve by
it's storage order, such as
`web3.eth.getStroageAt(address, position [, defaultBlock] [, callback])`.

while running construtor, the contract codesize is 0. that's to say, when
calling other contract in a contract, the contract size in other contract view
is 0.

- gas usage:
  stack < memory < storage

storage collision attacks

### Error Handling

https://docs.soliditylang.org/en/v0.8.15/control-structures.html?highlight=require#error-handling-assert-require-revert-and-exceptions

- `assert`
- `require`
- `revert`

Exceptions can contain error data that is passed back to the caller in the form
of [error instances](https://docs.soliditylang.org/en/v0.8.15/contracts.html#errors).
The built-in errors `Error(string)` and `Panic(uint256)` are used by special
functions, as explained below. `Error` is used for “regular” error conditions
while `Panic` is used for errors that should not be present in bug-free code.

`assert` creates an error of type `Panic(uint256)`, Assert should only be used
to test for internal errors, and to check invariants.

`require` creates an error without any data or an error of type `Error(string)`.
It should be used to ensure valid conditions that cannot be detected until
execution time.

You can optionally provide a message string for `require`, but not for `assert`.

`revert` uses parentheses and accepts a string:

> revert(); revert(“description”);

The error data will be passed back to the caller and can be caught there. Using
`revert()` causes a revert without any error data while `revert("description")`
will create an `Error(string)` error.

The two ways `if (!condition) revert(...);` and `require(condition, ...);` are
equivalent as long as the arguments to `revert` and `require` do not have
side-effects, for example if they are just strings.

**Use** `require()`**to:**

- Validate user inputs ie. `require(input<20);`
- Validate the response from an external contract i.e.
  `require(external.send(amount));`
- Validate state conditions prior to execution, ie. 
  `require(block.number > SOME_BLOCK_NUMBER)` or 
  `require(balance[msg.sender]>=amount)`
- Generally, you should use `require` most often
- Generally, it will be used towards **the beginning** of a function

There are many examples of `require()` in use for such things in our
[Smart Contract Best Practices](https://github.com/ConsenSys/smart-contract-best-practices).

**Use** `revert()`**to:**

- Handle the same type of situations as `require()`, but with more complex logic.

If you have some complex nested `if/else` logic flow, you may find that it makes
sense to use `revert()` instead of `require()`. Keep in mind though,
[complex logic is a code smell](https://github.com/ConsenSys/smart-contract-best-practices#fundamental-tradeoffs-simplicity-versus-complexity-cases).

**Use** `assert()` **to:**

- Check for [overflow/underflow](https://github.com/ConsenSys/smart-contract-best-practices#integer-overflow-and-underflow), i.e. `c = a+b; assert(c > b)`
- Check [invariants](<https://en.wikipedia.org/wiki/Invariant_(computer_science)>), i.e. `assert(this.balance >= totalSupply);`
- Validate state after making changes
- Prevent conditions which should never, ever be possible
- Generally, you will probably use `assert` less often
- Generally, it will be used towards **the end** of a function.

Basically, `require()` should be your go to function for checking conditions,
`assert()` is just there to prevent anything really bad from happening, but it
shouldn’t be possible for the condition to evaluate to `false`.
