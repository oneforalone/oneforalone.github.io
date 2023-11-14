---
title: Hacking in Rust
date: 2022-04-12 05:35:31 PM
categories: Programming
tags:
  - Rust
  - Programming
---

## Basic

对于一些基础的数据结构和语法，这里就不作详细的介绍，可自行阅读官方文档：
https://www.rust-lang.org/learn

主要围绕 rust 一些独有的特性来讲。

### 概览

rust 主要特性有：

- Ownership: rust 独有的内存管理方式。
- Shadowing: 变量覆盖
- Generic Types: 泛型
- Trait: 共享特征/接口
- Lifetime: 生命周期

### Ownership

TODO:

### Generic Types

泛型主要是为了处理编程中可能返回 `None`/`NULL`/`Nil` 之类的 bug 问题，同时也解决了处理不同
类型的参数问题，提高代码的复用率。

例如下面这段代码：

```rust
fn largest_i32(list: &[i32]) -> i32 {
  let mut largest = list[0];

  for &item in list {
    if item > largest {
      largest = item;
    }
  }

  largest
}

fn largest_char(list: &[char]) -> char {
  let mut largest = list[0];

  for &item in list {
    if item > largest {
      largest = item;
    }
  }

  largest
}

fn main() {
  let number_list = vec![1, 2, 3, 4, 5];

  let result = largest_i32(&number_list);
  println!("The largest number in {} is {}", number_list, result);

  let char_list = vec!['a', 'b', 'c', 'd', 'e'];
  let result = largest_char(&char_list);
  println!("The largest char in {} is {}", char_list, result);
}
```

上面这段代码中其实 `largest_i32` 和 `largest_char` 函数代码一模一样，只不过是参数的类型
不一样，这样的代码难免有些冗余。有了泛型，上面的代码可以改写成：

```rust
fn largest<T: PartialOrd + Copy>(list: &[T]) -> T {
  let mut largest = list[0];

  for &item in list {
    if item > largest {
      largest = item;
    }
  }

  largest
}

fn main() {
  let number_list = vec![34, 50, 25, 100, 65];

  let result = largest(&number_list);
  println!("The largest number is {}", result);

  let char_list = vec!['y', 'm', 'a', 'q'];

  let result = largest(&char_list);
  println!("The largest char is {}", result);
}
```

忽略上面代码中的 `PartialOrd + Copy`，这个是为了让两个泛型之间能够进行比较。相比之下后面的
代码更加简洁和优雅。

而对于一些可能返回 `None`/`NULL`/`NIL` 的值，有时候会忘了做判断，有了泛型后，如果遇到这种
情况会自动 `panic`（即 rust 中的异常）退出。

对于一些返回值为泛型的函数，想要获取到其中的原型时，有两种方法将原有的类型取出来。

1. 使用 `unwrap()` 函数：

```rust
fn main() {
  let a = Some(1);
  let b = Some(2);
  let sum = a.unwrap() + b.unwrap();
  println!("The sum of {} + {} is {}", a.unwrap(), b.unwrap(), sum);
}
```

2. 使用 `let ... match` 表达式：

```rust
fn main() {
  let s = Some(2);
  // let s = None; // in this case, v = 0;
  let v = match s {
    Some(n) => n,
    None => 0
  };

  println!("The value of v is: {}", v);
}
```

Ok, 以上就是 rust 中泛型的介绍了。

### Trait

TODO:

### Lifetime

TODO:
