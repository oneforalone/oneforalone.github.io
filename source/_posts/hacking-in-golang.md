---
title: Hacking in Golang
date: 2022-04-17 09:28:40 AM
categories: Programming
tags:
  - Golang
  - Programming
---

**NOTE: This is a scratch**

## Variables and Types

```go
var i int
```

变量声明和赋值

全局作用域中，不能使用 `:=`, 词法作用域中可以使用

```
test := “hello” // error

func main() {
  test := “hello”
  var i int = 1
  fmt.Println(test, i)
}
```

基本类型

```
 bool

string

int int8 int16 int32 int64
uint uint8 uint16 uint32 uint64 uintptr

byte // uint8 的别名

rune // int32 的别名, 表示一个 Unicode 码点

float32 float64

complex64 complex128
```

变量可以以分组的方式组成一个语法块

```go
var (
  is_true bool = false
  max_int uint64 = 1<<64 -1
  z complex128 = cmplx.Sqrt(-5 + 12i)
)
```

类型转换需要显示声明，变量类型未指定时根据右值推导变量

常量使用关键字 `const`，不能使用 `:=` 语法

## Flow Control

循环： for

```go
sum := 0
for i := 0; i < 10; i++ {
  sum += i
}
```

`for` 是 Go 中的 _while_

```go
sum := 1
for sum < 1000 {
   sum += sum
 }
```

`if x < 0 { statement }`
`if v := math.Pow(x); v < lim { statement }`
`condition` 前可以执行一个简单的语句

```Go
switch os := runtime.GOOS; os {
case “darwin”:
    fmt.Println(“OS X”)
case “linux”:
     fmt.Println(“Linux.”)
default:
    fmt.Println(“%s.\n”, os)
```

`case` 中没有语句是则顺序执行，没有 condition 时等同于 `switch true`

```Go
t := time.Now()
switch {
case t.Hour() < 12:
    fmt.Println(“Good morning”)
case t.Hour() < 17:
    fmt.Println(“Good afternoon”)
default:
    fmt.Println(“Good evening”)
```

`defer`: 将 statement 在当前函数执行后再执行，多个 `defer`，则是栈的结构

```Go
func main() {
    fmt.Println(“counting”)
    for i := 0; i < 10; i++ {
        defer fmt.Println(i)
    }
    fmt.Println(“done”)
}
```

## More Structures

- 指针：是 C 指针的子集，Go 中没有指针运算
- 结构体：与 C 基本一致，Go 中结构体指针访问结构体的字段和结构体一致，都是使用点(`.`)，而 C
  中使用 `->`
- 数组：与 C 一致，但是可以切片，下面的几个表达式都是等价的

```Go
a[0:10]
a[:10]
a[0:]
a[:]
```

a. 切片有长度和容量; b. 切片的长度就是它所包含的元素个数。c. 切片的容量是从它的第一个元素开始
数，到其底层数组元素末尾的个数。切片的零值（`[]`）为 `nil`。GO 里的切片有点意思，这里应该
是有两个指针指向了对应的数组，而后的切片是改变指针的值。

可以使用 `make` 创建切片（动态数组） `a := make([]int, 5, 5)`，第一个参数为类型，第二个
参数为 `len`，第三个参数为 `cap`。切片可以包含任何类型。追加使用 `append`，`append` 追加
多个元素时，会自动分配一个更大的数组，数组的大小可能会比数组的元素要大一点。遍历切片时可以使用
`range`，`range` 返回两个值，一个是下标，一个是下标所对应的值的副本，可使用 `_` 来忽略。

```go
package main

import "fmt"

func main() {
	s := []int{2, 3, 5, 7, 11, 13}
	printSlice(s) // len = 6, cap = 6

	// 截取切片使其长度为 0
	s = s[:0]
	printSlice(s) // len = 0, cap = 6

	// 拓展其长度
	s = s[:4]
	printSlice(s) // len = 4, cap = 6

	// 舍弃前两个值
	s = s[2:]
	printSlice(s) // len = 2, cap = 4
}

func printSlice(s []int) {
	fmt.Printf("len=%d cap=%d %v\n", len(s), cap(s), s)
}
```

映射：字典，`map[keyType]ValueType`，若 `ValueType` 是个类型名，可以直接省略

```go
type Vertex struct {
  Lat, Long float64
}

var m = map[string]Vertex {
  "Bell Labs": Vertex {
    40.68433, -74.39967,
  },
  "Google": Vertex {
    37.42202, -122.08408,
  },
}

// equal to
var m = map[string]Vertex {
  "Bell Labs": { 40.68433, -74.39967 },
  "Google": { 37.42202, -122.08408 }
}

```

添加和获取 k/v 与其他语言的字典一致，删除使用 `delete(mapname, key)`，还一个特殊的就是检测
对应的 key 是否存在的语句：`elem, ok = m[key]`，`ok` 为 `bool`

函数也可以作为参数或返回值，所以有闭包

## 方法和接口

没有类，但是可以给结构体或非结构体实现方法，与 Rust 的 `trait` 类似，方法即函数，方法只是个
带接受者的函数。但是不能给基础类型的指针添加方法。`func (s *StrutureType) methodName()
returnType {}` 是可以的，但是 `func (i *int) methodName() returnType {}` 是不允许的。
使用指针才能修改对应结构体中字段的值，否则不会对结构体中的值进行修改，和 C 语言中函数的参数传递
类似，如果需要对参数进行修改，需要传递指向参数的指针，否则不会对参数的值进行修改。

参数必须匹配类型，但是对于接受者（即方法名前面的那个表达式），类型及其指针都可以正常使用

```go
package main

import (
  "fmt"
  "math"
)

type Vertex struct {
  X, Y float64
}

func (v Vertex) Abs() float64 {
  return math.Sqrt(v.X * v.X + v.Y * v.Y)
}

func Abs(v Vertex) float64 {
  return math.Sqrt(x.X * v.X + v.Y * v.Y)
}

type MyFloat float64
func (f MyFloat) Abs() float64 {
  if f < 0 {
    return float64(-f)
  }
  return float64(f)
}

func main() {
  v := Vertex{3, 4}
  fmt.Println(v.Abs())

  fmt.Println(Abs(v))

  f := MyFloat(-math.Sqrt2)
  fmt.println(f.Abs())

  p := &v
  fmt.Println((*p).Abs())
  fmt.Println(p.Abs())
  fmt.Println(Abs(*p))
  fmt.Println(Abs(p)) // this would cause an error.
}
```

接口，方法/函数定义的集合，接口是通过隐式声明的，接口的实现若没有值的话，则为 `nil`（接口是
`(value, type)` 的类型），没有方法的接口为空接口，可以保存任何类型的值，用来处理未知类型
的值。接口提供了断言（assert）访问底层的值和具体类型，`var i interface{} = "hello"`，
如果是 `s, ok := i.(string)` 和 `f, ok := i.(float64)` 能正常执行，但是
`f := i.(float64)` 会 panic（为什么 GO 的异常错误和 Rust 一样也叫 `panic` 呢？）

```go
package main

import "fmt"

type I interface {
  M()
}

type T struct {
  S string
}

func (t T) M() {
  fmt.Println(t.S)
}

func main() {
  var i I = T{"hello"}
  i.M()
}
```

通常使用 `fmt.Println` 打印一个自定义结构时，需要
对改结构添加一个 `String()` 的方法

```go
type Person struct {
  Name string
  Age int
}

func (p Person) String() string {
  return fmt.Sprintf("%v (%v years)",
                     p.Name, p.Age)
}
```

错误使用 `Error()`，通常函数会返回一个 error 值，调用的它的代码应当判断这个错误是否等于
`nil` 来进行错误处理。

```go
i, err := strconv.Atoi("42")
if err != nil {
    fmt.Printf("couldn't convert number: %v\n", err)
    return
}
fmt.Println("Converted integer:", i)
```

可以自定义 `error`：

```go
type MyError struct {
	When time.Time
	What string
}

func (e *MyError) Error() string {
	return fmt.Sprintf("at %v, %s",
		e.When, e.What)
}

func run() error {
	return &MyError{
		time.Now(),
		"it didn't work",
	}
}

func main() {
	if err := run(); err != nil {
		fmt.Println(err)
	}
}
```

## 泛型

```go
func Index[T comparable](s []T, x T) int
```

函数 Index 接受参数为 comparable 类型的一个数组和一个值，返回一个 `int`

接受任何类型的链表结构

```go
type List[T any] struct {
  next *List[T]
  val T
}

lst = List[int] { nil, 4 }
```

## Concurrency

goroutine，运行时的轻量级线程，调用 `go f(x, y, z)`，和 C 的子进程类似

```go
package main

import (
  "fmt"
  "time"
)

func say(s string) {
  for i := 0; i < 5; i++ {
    time.Sleep(100 * time.Millisecond)
    fmt.Println(s)
  }
}

func main() {
  go say("world")
  say("hello")
}
```

channel，带有类型的管道 `ch <- v` 将 `v` 发送给 `ch`，`v := <-ch` 将 `ch` 中接收值并赋
给 `v`，创建信道 `ch := make(chan <Type>, [buffer_size])`。所以 channel 也是个切片，
发送者可以使用 `close(ch)` 来关闭 channel，接受者不能。channel 关闭后不能再向其中发送
数据。

```go
package main

import (
  "fmt"
)

func fibonacci(n int, c chan int) {
  x, y := 0, 1
  for i := 0; i < n; i ++ {
    c <- x
    x, y = y, x+y
  }
  close(c)
}

func main() {
  c := make(chan int, 10)
  go fibonacci(cap(c), c)
  for i := range c {
    fmt.Println(i)
  }
}
```

使用 `select` 进行阻塞

```go
pacakge main

import "fmt"

func fibonacci(c, quit chan int) {
  x, y := 0, 1
  for {
    select {
    case c <- x:
      x, y = y, x+y
    case <-quit:
      fmt.Println("quit")
      return
    }
  }
}

func main() {
  c := make(chan int)
  quit := make(chan int)
  go func () {
    for i := 0; i < 10; i++ {
      fmt.Println(<-c)
    }
    quit <- 0
  }()
  fibonacci(c, quit)
}
```

如果有多个分支的话会随机选择一个执行，`default` 分支再其他的分支没有值时默认执行的。

```go
select {
case i := <-c:
  // use i
default:
  // receiving from c would block
}
```

mutex, 互斥锁，因为有并发，就会需要到互斥锁，来保证数据一致性，互斥锁有在 `sync` 包中，
有 `Lock` 和 `Unlock` 两个方法，`sync.Mutex` 为互斥锁类型结构。

```go
package main

import (
  "fmt"
  "sync"
  "time"
)

type SafeCounter struct {
  v map[string]int
  mux sync.Mutex
}

func (c *SafeCounter) Inc(key string) {
  c.mux.Lock()
  c.v[key]++
  c.mux.Unlock()
}

func (c *SafeCounter) Value(key string) {
  c.mux.Lock()
  defer c.mux.Unlock()
  return c.v[key]
}

func main() {
  c := SafeCounter{ v: make(map[string]int)}
  for i := 0; i < 1000; i++ {
    go c.Inc("somekey")
  }

  time.Sleep(time.Second)
  fmt.Println(c.Value("somekey"))
}
```
