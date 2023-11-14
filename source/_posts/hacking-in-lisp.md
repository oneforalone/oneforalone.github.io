---
title: Hacking in Lisp
date: 2022-04-10
categories: Programming
tags:
  - Lisp
  - Programming
---

对于 Lisp 来说，与其他语言的主要差别有三个：

- **Lisp 的每个表达式都会返回一个值，没有 statement 和 expression 的分别。**
- **Lisp 的词法规则会比其他的语言简单些，词法树只需要解析小括号、引号、空格以及逗号。引号包括
  双引号、单引号以及反引号。**
- **Lisp 使用小括号作为统一的分隔符，而不是像其他语言一样使用多种组合**
  **对 expression/statement 做分隔。所以 Lisp 把分号当作注释符。**

上面三点是 Lisp 和其他语言的差异，也是为什么从其他语言转到 Lisp 会比较疑惑的点。还有一点就
是，其他语言是不会先对传过来的参数进行求值，然后再将函数运用到这些参数的结果上，但是 Lisp
就是这么做的，**先对参数进行求值，然后再将函数应用到这些参数的结果上计算结果。**

## Basic

如果是其他语言，没必要介绍编译环境的安装配置，因为基本都有官网，官网上也都有对应的安装教程，或者
说网上一搜一大堆。但 Lisp 或者说 Common Lisp（下面不对这两者进行区分，统一使用 Lisp 指代
Common Lisp）不一样，最官方的是 LispWorks，那个 IDE 贵的离谱，具体是 $1,000 还是 $8,000
我忘了，反正这超过普通的人承受范围，虽然有免费版的，但是功能阉割的离谱，想要感受的自行去体验吧。

还有一点就是 Lisp 的编译器其实是比较多的，同时大部分时候又要搭配着 Emacs 使用，Emacs 的配置
需要投入一点时间去学习的。所以总给人一种比较混乱的感觉。而且很多 Lisp 的教材里其实不会花什么
篇幅去介绍环境配置。直接开讲，你自己要去验证代码时就只能自己去查找资料。不过要感谢 Vindarel，
他把这个门槛给砍掉了，让 Lisp 入门变得简单了。强烈推荐去看看他编写的 [The Common Lisp Cookbook][cl-cookbook]，
当然我刚开始时也做了一下中文翻译，如果英文水平不是很好的话可以参考我翻译的 [Common Lisp 秘籍][cl-cookbook-zh]。

废话不多说，let's dive in.

[cl-cookbook]: https://lispcookbook.github.io/cl-cookbook/
[cl-cookbook-zh]: https://oneforalone.github.io/cl-cookbook-cn/#/

### Environment Setups

环境配置看你怎么选，如果你懒得去做一些配置什么的，有人已经写好了配置，直接下载安装就好了，那个就
是 [Portacle][portacle]。这个就是一个 IDE，里面基本的配置都集成好了，开箱即用，版本什么的
也比较新。

[portacle]: https://portacle.github.io

如果喜欢折腾的话，那么就需要自己安装 [sbcl][sbcl]，至于你用什么编辑器编辑，你自己选个喜欢的
就好了，普遍用的都是 sbcl + slime + emacs。不过 vscode 和 vim 之类都也都是可以的。当然
你也可以直接在 sbcl 中调试，但是要注意，sbcl 不支持上下左右键，如果需要支持的话，需要安装
[rlwrap][rlwrap]，然后启动时执行 `rlwrap sbcl`。

[sbcl]: http://www.sbcl.org
[rlwrap]: https://github.com/hanslub42/rlwrap

Lisp 的解释器或者说脚本语言的解释器都是遵循 REPL（Read Eval Print Loop）的原则，只不过在
sbcl 中表达式执行错误的话会进入一个 interactive debugger，要想退出这个 debugger，输入 0
或者按 Ctrl-D。或者更进一步想要去掉这个烦人的 debugger，可以在 sbcl 的配置文件`~/.sbclrc`
中添加以下代码：

```lisp
(defun print-condition-hook (condition hook)
  "Print this error message (condition) and abort the current operation."
  (declare (ignore hook))
  (princ condition)
  (clear-input)
  (abort))

;; WARN: this will
(setf *debugger-hook* #'print-condition-hook)
```

### Hello Lisp

从 C 语言那里流传下来的传统（虽然 Lisp 要比 C 早），接触一门语言的时候都喜欢用打印一个
"Hello World" 开始。其实大部分 Lisp 的教程都不会一开始写 hello world，而是直接从其
[S-expression][s-expr] 开始讲。但是这里我就遵循一下 C 的传统吧。

[s-expr]: https://baike.baidu.com/item/S-表达式/4409560

下面是 `hello.lisp` 的代码：

```lisp
(defun hello ()
  "say hello"
  (format t "hello lisp"))

(hello)
```

然后直接使用 sbcl 的 `--script` 参数加载 `hello.lisp` 文件就好，会在命令行中输出
`hello lisp` 字符。

```bash
$ sbcl --script hello.lisp
hello lisp
```

如果源代码中调用了其他的库/包，需要再代码的最上面添加一行：

```
(require :asdf)
```

如果想执行 `hello.lisp` 之后进入 sbcl，可以使用 `--load` 参数，这个参数是先启动 sbcl，
再执行 `hello.lisp` 。

```bash
$ sbcl --load hello.lisp
This is SBCL 2.1.9, an implementation of ANSI Common Lisp.
More information about SBCL is available at <http://www.sbcl.org/>.

SBCL is free software, provided as is, with absolutely no warranty.
It is mostly in the public domain; some portions are provided under
BSD-style licenses.  See the CREDITS and COPYING files in the
distribution for more information.
hello lisp
```

简单的讲一下 `hello.lisp`，`defun` 是函数定义宏，后面接函数名，然后是函数的参数，再然后是
使用双引号的文档注释，最后是函数的主体。格式就是 S-expression 的格式，开头使用小括号，接一个
函数或宏的名字，然后是其参数。至于 `format`，就是一个输出的函数，可以类比其他语言的 `print`/
`printf` 函数，不过这个字符串对应的转移符和类 C 的不一致，其转译符使用的是 `~`，而不是 `\`，
所以换行是 `~%`，和 `\n` 一样的效果。更具体详细的介绍，参看 [wiki][format-wiki] 和
[Lisp Hyper Spec: format][format]。

[format-wiki]: https://en.wikipedia.org/wiki/Format_(Common_Lisp)
[format]: http://www.lispworks.com/documentation/lw50/CLHS/Body/22_c.htm

### `defvar`/`defparameter`/`setf`/`setq`

refer to [what's difference between defvar defparameter setf and setq](https://stackoverflow.com/questions/8927741/whats-difference-between-defvar-defparameter-setf-and-setq)

#### `defvar`/`defparameter`

`defvar` 和 `defparameter` 这两个内置函数都是用来定义全局变量的。区别在于 `defvar` 在第一
次定义赋值后，之后都不能修改这个变量的值，而 `defparameter` 是可以修改的。`defvar` 相当于
是定义了一个全局常量，而 `defparameter` 只是定义了一个全局变量而已。具体表现形式见如下代码：

```
> (defparameter a 1)
A
> a
1
> (defparameter a 2)
A
> a
2
> (defvar b 1)
B
> b
1
> (defvar b 2)
B
> b
1
```

有一点需要注意的是，定义全局变量时，有一部分 lisper 喜欢使用 `*` 将变量包起来，用来标识这
是个全局变量，这个看自己的习惯吧，但是之后肯定会遇到这种情况的。例如之后介绍的 `*features*`。

#### `setf`/`setq`

`setf` 和 `setq` 都是修改变量的值，区别是 `setf` 是使用了 `setq` 的宏，对 `setq` 进行了
拓展。因为 `setq` 不能对表达式的结果的值进行修改。具体的差别参考下面的代码：

```
> (defparameter c (list 1 2 3))
C
> (setf (car c) 42)
42
> c
(42 2 3)
> (setq (car c) 42)
; in: SETQ (CAR C)
;     (SETQ (CAR C) 42)
;
; caught ERROR:
;   Variable name is not a symbol: (CAR C).
;
; compilation unit finished
;   caught 1 ERROR condition

debugger invoked on a SB-INT:COMPILED-PROGRAM-ERROR in thread
#<THREAD "main thread" RUNNING {70085E3DB3}>:
  Execution of a form compiled with errors.
Form:
  (SETQ (CAR C) 42)
Compile-time error:
  Variable name is not a symbol: (CAR C).

Type HELP for debugger help, or (SB-EXT:EXIT) to exit from SBCL.

restarts (invokable by number or by possibly-abbreviated name):
  0: [ABORT] Exit debugger, returning to top level.

((LAMBDA ()))
   source: (SETQ (CAR C) 42)
0] abort
```

#### `*features*`

预定义的一个列表，可以自己添加一些自定义的特性，主要是用来根据不同的环境来执行不同的代码。

```
#+unix
(print "We are on linux")
```

### Iteration

Lisp 中控制循环迭代最原生的是 `loop`，其他的都是后面衍生出来的。`dolist` 是遍历列表，
`dotimes` 是已知循环的次数，`maphash` 是遍历 hash table 的。具体用法见下面代码。

- `loop`:

```
* (loop for x in '(1 3 5)
     do (print x))
1
3
5
NIL ; return value

* (loop for x in '(1 3 5)
     collect (print x))
1
3
5
(1 3 5) ; return value

* (loop for x in '(1 3 5)
     sum (print x))
1
3
5
9 ; return value

* (loop for x in '(1 3 5)
     count (print x))
1
3
5
3 ; return value

* (loop for x in '(1 3 5)
     maximize (print x))
1
3
5
5 ; return value
```

- `dolist`

```
* (dolist (x '(1 3 5))
           x ; this is the return value of the last eval of x
    (print x))
1
3
5
NIL ; return value
```

- `for`

```
* (ql:quickload "for")

* (for:for ((x over #(0 2 4))
            (y over (list 1 3 5)))
    (format t "~a - ~a ~%" x y))
0 - 1
2 - 3
4 - 5
NIL
```

注，以上的循环中，`for` 的效率最低，所以慎用，个人还是比较喜欢用 `loop`。

- `maphash`

```
* (let ((ht (make-hash-table)))
    (setf (gethash :a ht) 1)
    (setf (gethash :b ht) 2)
    (loop :for k :being :the :hash-key
       :using (:hash-value v)
       :of ht
       do (print (list k v))))
(:A 1)
(:B 2)
NIL

* (let ((ht (make-hash-table)))
    (setf (gethash :a ht) 1)
    (setf (gethash :b ht) 2)
    (maphash (lambda (k v)
                (print (list k v)))
             ht))
(:A 1)
(:B 2)
NIL

* (ql:quickload "alexandria")
* (let ((ht (make-hash-table)))
    (setf (gethash :a ht) 1)
    (setf (gethash :b ht) 2)
    (alexandria:hash-table-keys ht))
(:B :A)

* (ql:quickload "for")
* (let ((ht (make-hash-table)))
    (setf (gethash :a ht) 1)
    (setf (gethash :b ht) 2)
    (for:for ((key/value over ht))
      (print key/value)))
;; or using trivial-do https://github.com/yitzchak/trivial-do/
(:A 1)
(:B 2)
NIL
```

- `dotimes`

```
* (dotimes (i 3)
    (print i))
0
1
2
NIL

* (loop repeat 3
     do (print "hello"))
"hello"
"hello"
"hello"
NIL

;; REPL: READ EVAL PRINT LOOP
(loop (print (eval (read))))
```

### LOOP: Hight-level Overview

2 rules:

- respect the order
- don't nest accumulating clauses

```lisp
;; Iteration:
;; LOOP overview
(loop
  ;; Initialize variables we loop over
  :for x :in '(1 3 5)
  :for i :from 1 :to 2 ;; ranges: to,below,downto...
  :for y := i :then 99

  ;; Use intermediate variables
  :with z := "z" ;; set once, not iterated.

  ;; Initial clause
  :initially (format t "initially, i = ~S" i)

  ;; Body
  ;; Conditionals: if/else, when
  ;; While, until, repeat
  :if (> i 90)
  :do (return i)  ;; early exit

  ;; Main clauses: ;; do, collect... into,
  ;; count, sum, maximize
  ;; thereis, always, never
  :sum x :into res

  ;; Final clause
  :finally (return (list i res)))
```

### Functions

- `defun`：定义一个函数
- `apropos`：查看符号是否被定义
- `documentation`：查看对应的文档
- `inspect`：查看具体的细节

使用 `funcall` 调用函数时，可以使用 `#'` 或 `'`，两者的区别是：

- `#'`：表示调用当前词法作用域中定义的函数
- `'`：大部分时候是只 top-level 的函数，即全局作用域中的函数

```lisp
(defun hello (name &key (happy t happy-p))
  "Say hello to NAME."
  (format t "happy is: ~S~&" happy)
  (format t "Hello ~a" name)
  (when happy-p
    (if happy
        (format t " :)")
        (format t " :(((("))))

(flet ((hello (x)
         (format nil "*** hello ~a was overriden!~&" x)))
  (format t "What is 'hello?~&")
  (describe 'hello)
  (format t "What is #'hello? ~a" #'hello)
  (describe #'hello)
  (print (hello "me"))
  (print "Calling 'hello:")
  (funcall 'hello "with quote")
  (print "Calling #'hello:")
  (funcall #'hello "with #'"))
```

`flet` ~ `let`，`let` 是对变量的绑定，`flet` 是对函数的绑定。`labels` ~ `let*` 类似。

### Multiple return values

`values` 会输出多个值，但返回的是多个值中的第一个，可以使用 `nth-value` 获取到对应的元素，
使用 `multiple-value-bind` 将 `values` 返回的多个值绑定到多个变量上。

### Higher order functions

Lisp 还有个优点是函数可以作为参数使用，这个后续的语言都是从 Lisp 模仿过去的。

```lisp
(defun compute (x y &key operation #'+)
  (funcall operation x y))

(compute 1 2) ;; => 3
(compute 1 2 :operation #'-) ;; => -1

(member 2 '(1 2 3)) ;; => (2 3)
(member "foo" '("rst" "foo") :test #'string-equal) ;; => ("foo")
```

既然函数都能当参数使用，那么当作返回值也就没啥例外的了：

```lisp
(lambda (x)
  (1+ x))

(compute 1 2 :operation (lambda (x y)
                           (+ 10 x y)) ;; => 13
;; or
(defun add10 (x y)
   (+ 10 x y))
(compute 1 2 :operation #'add10)

(mapcar (lambda (x y) (+ x y))
  '(1 2 3) '(10 20 30)) ;; => (11 22 33)
```

同时还有个 `setf` 的属性

```lisp
(let ((counter 0))
  (defun counter-inc ()
    (incf counter))

  (defun counter-init ()
    (setf counter 0))

  (defun counter-value ()
     counter)

  (defun (setf counter-value) (new-value)
    (setf counter new-value)))

(counter-inc) ;; => 1

(setf (counter-value) 9) ;; => 9
```

`defmethod`/`defgeneric` 用来定义泛型函数，区别在于 `defmethod` 是对每个具体实现的定义，
而 `defgeneric` 可以使用 `:method` 关键词一次性定义多个实现。

- `defmethod`

```lisp
* (defmethod hello (name)
    (print name))

* (defmethod hello ((obj hash-table))
    (format t "rrr we have a HT"))

* (hello (make-hash-table))
;; => rrr we have a HT
;; NIL
* (hello "me")
;; "me"
;; "me"

```

- `defgeneric`

```lisp
(defgeneric hello (sthg)
  (:method ((sthg t))
      (print sthg))
  (:method ((sthg hash-table))
      (format t "rrr we have a HT"))

```

## Create a new project:

- `my-project.asd`:

```lisp
(in-package #:asdf-user)

(defsystem :my-project
  :depends-on (:alexandria :str :cl-ppcre :clingon)
  ;; flat source tree:
  ;; - .asd
  ;; - .lisp
  :components ((:file "my-project") ;; .lisp file
               (:static-file "README.md")))

#|
With .lisp file in a src/ directory:

  :components ((:module "src"
                :components
                ((:file "utils")
                 (:file "my-project")
                 (:file "config")))
                (:module-2 ...))
```

- `my-project.lisp`:

```lisp
(defpackage #:mypackage
  (:use :cl)
  (:export :my-entry-point))

(in-package :mypackage)

(defun my-entry-point ()
  "Say hello to current user."
  (format t "Hello ~a!" (uiop:getenv "USER")))
```

在 package 的定义和使用中，`#:` 和 `:` 用法基本是一致，只是有细微的差别，就是 `:` 会在当前
的 image 中将后面的符号给占用，符号补全时能找到，而 `#:` 不会占用符号，因此推荐使用 `#:`，
而不是 `:`。

`systems`: like Debian packages

`packages`: containers for symbols. Namespaces

### Alist/Plist

这两种数据结构是轻量的 hash-table

- alist 的格式如下：

```
( (:a . 1) (:b . 2) )
```

- plist 的格式如下：

```
(:a 1 :b 2)
```

总的看来就是 alist 使用的是 `cons` 结构来关联 key-values，内部是嵌套的，而 plist 是
flatten 的 alist，偶数索引的元素为 key，索引为奇数的是 value（索引从 0 开始）。

详细的讲解参考下面这两篇文章：

- https://dnaeon.github.io/common-lisp-lookup-tables-alists-and-plists/
- https://gigamonkeys.com/book/beyond-lists-other-uses-for-cons-cells.html
