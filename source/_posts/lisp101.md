---
title: Lisp 101
date: 2023-09-10 04:05
categories: Programming
tags:
  - Lisp
  - Programming
---

So, you want to write some Lisp codes?

Lisp's syntax is simple, just parentheses and space.

However, there's few documents for how to start it like other languages, such as
C/C++, Python, Java, and ect. Even in [The Commonlisp Cookbook][cookbook], it's
kinda vague. So, that why I wrote this blog for.

[cookbook]: https://lispcookbook.github.io/cl-cookbook/

This article is complete for those who are new to Lisp/Programming. Just keep
in mind, Lisp has some dialects: Common Lisp, Scheme, Clojure and etc. In the
rest of this page, Lisp is stands for Common Lisp.

## Before start

Generally speaking, programming is just write some codes(i.e. source codes) in
a specific language(i.e. programming language), and translate these source codes
to machine code or binary code for specific operating system (OS) and hardwares(
mainly for CPU architectures).

More briefly, thers are three steps for programming: coding, compling, running.

For coding, you can choose any text editor you want. However, there're some
popular editors for coding: Vim, Emacs, Visual Studio Code, Sublime, Atom and
so on. Just do some researches before you move on. For a new starter, I would
recommand Visual Studio Code. It's easy to using, and has lots of extensions.

For compling, you need a compiler/interpreter, or let's say implementation in
Lisp. There also are some implementations for Lisp. The common used is
[SBCL][sbcl]. For a complete list for Lisp's implementation, please refer to:
https://common-lisp.net/implementations

[sbcl]: https://www.sbcl.org/

As for running, I assume that everyone who knows how to use computer know how
to run a program.

Also, for convinience, there's also tools called Integrated Development
Environment (IDE). For a beginner, I don't suggest using an IDE, but if you
were super lazy or have a hard time with setting up a programming environment,
just use it as needed. [Portacle][portacle] is the one you may looking for. If
you don't care about performance or got enough money, you can try
[Lispworks][lispworks].

[portacle]: https://portacle.github.io/
[lispworks]: http://www.lispworks.com/

Here, I choose SBCL + Emacs. And my daily operating system is \*nix: MaoOS and
Linux.

Just a remaind: **DO NOT** spend too much time on Emacs configuration.
[Slime][slime] is just enough.

[slime]: https://github.com/slime/slime

## Start

If you have other programming language exprience, you may know how to run the
source codes properly. For C/C++/Java, just compile it to binary file, and run
it. For Python/Ruby/Perl/Lua/Shell, just edit the source codes, save it to a
file, and run it with `python <filename>` (Python for example). But in Lisp,
things are different, you may know how to run Lisp codes in SBCL, but don't know
how to compile it to binary file. Let's using a very basic "hello world!"
programming for illustration.

In C, you just create a `.c` file, let's say it `hello.c`:

```C
#include <stdio.h>

int main(int argc, char** argv) {
  printf("Hello, World!\n");

  return 0;
}
```

and then compile it: `gcc -o hello hello.c` and run it: `./hello`. Then you will
see the "Hello, World" string on you screen.

In Python, create a `hello.py`:

```Python
#!/usr/bin/env python3

print("Hello, World")
```

and run it: `python3 hello.py` or if you're on \*nix system, you can run
following commands:

```Shell
chmod +x hello.py
./hello.py
```

and bang, the terminal will output "Hello, World" characters.

But how to make it in Lisp. Well, if you just want to write some simple codes,
you can just start sbcl and write you codes:

```Lisp
(defun hello ()
  (format t "Hello, World~%"))
```

then input:
`(sb-ext:save-lisp-and-die #p"hello" :toplevel #'hello :executable t)`.
After running this form (i.e. Lisp codes), SBCL will exit and compile the lisp
codes which called Lisp image into an file named `hello` in current directory.
You can change the binary file with modifing `#p"hello"`, and `:toplevel`
specify which function would evaluate when running `hello` binary file.

So, how can we compile a lisp file to binary?

We can utilize [GNU Make][make] and [quicklisp][quicklisp], and let's continue
it in next section, which I call projecting.

[make]: https://www.gnu.org/software/make/
[quicklisp]: https://www.quicklisp.org/beta/

## Projecting

Before projecting, make sure you've installed `GNU Make` and `quicklisp` on your
OS.

**NOTE**: The following steps are running on macOS Ventura 13.5.2, it's just the
same if you are on a Linux Distribution. On Windows, you should to adjust some
commands.

Firstly, create a directory named `hello` and switch to it.

```Bash
mkdir hello
cd hello
```

Then create `hello.lisp` with command `touch hello.lisp`.

After that, edit `hello.lisp` with following content:

```Lisp
(defpackage #:hello
  (:use :cl)
  (:export :hello))

(in-package :hello)

(defun hello ()
  (format t "Hello, World~%"))

```

A `.asd` file `hello.asd`:

```Lisp
(in-package #:asdf-user)

(defsystem :hello
  :components ((:file "hello"))
  :build-operation "program-op"
  :build-pathname "bin/hello"
  :entry-point "hello:hello")
```

In `hello.asd`, you may add as many `.lisp` files as you want after `:components`
keywords. You may also add sub-directory file:

```
:components ((:module "src"
              :components ((:file "file1")
                           (:file "file2"))))
```

to add a readme file, use `:static-file` keyword:

```
:components ((:file "hello")
             (:static-file "README.md"))
```

and then create a file named `Makefile` with:

```Makefile
LISP ?= sbcl

build:
  $(LISP) --load hello.asd \
  --eval '(ql:quickload :hello)' \
  --eval '(asdf:make :hello)' \
  --eval '(quit)'
```

finally, run `make` command, and it would compile the `hello.lisp` file, save
the binary file into `bin/hello` file. Now, you can get the "Hello, World"
outputs with `./bin/hello` command.

Congratuates, you now know how to compile Lisp codes to binary file. All you
should do next is to grabe a book and dive in. Here are some awesome Lisp books:

- The Common Lisp Cookbook: https://lispcookbook.github.io/cl-cookbook/
- Successful Lisp: https://dept-info.labri.fr/~strandh/Teaching/MTP/Common/David-Lamkins/cover.html
- On Lisp: http://www.paulgraham.com/onlisptext.html
- Let Over Lambda: https://letoverlambda.com/

For specification/reference:

- The Common Lisp HyperSpec: http://www.lispworks.com/documentation/HyperSpec/Front/index.htm

That's it. Happy Lisping ^\_^
