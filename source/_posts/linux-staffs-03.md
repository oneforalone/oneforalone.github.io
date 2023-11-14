---
title: 我与 Linux 的那些事03：命令
date: 2021-02-19
categories: Linux
tags:
  - Linux
  - Shell
---

## 序

之前玩过微信公众号，在那上面也写过一篇关于命令行参数的文章。但公众号的文章不支持 [`Markdown`][markdown] 语法，而我也懒得去找第三方插件，就直接销掉了。

今天重新整理一下常用到的命令参数。

## Terminal 之辩

得益与《黑客帝国》，大部分人第一想到的大概是一个闪着绿光的黑黑的窗口，上面有很多字符在滚动。这个大概是，想要在 Linux 中模拟电影里的特效的话，可以试试 [`cmatrix`][cmatrix]。这个窗口广义
的来说，就是 `Terminal`。

`Terminal` 在 Unix 术语里叫终端，而不是`终结者`的 `Terminal`。所谓终端呢，就是最终端（说
了也白说），通俗点讲就是用来和用户交互的，处理显示一些用户输入输出。说起 `Terminal`，就不得不
提与之相关的几个名词了，分别是：

- terminal
- tty
- console
- shell

这几个名词所指代感觉是差不多，但其实还是有差别的。[StackExchange 上的解释][a.1]是:

- terminal = tty = text input/output environment
- console = physical terminal
- shell = command line interpreter

上面解释的很清楚，详细的解释说明参考 A.1。

等等，为什么介绍命令参数要写这些呢？借用鲁迅先生的话来说“凡事总须研究，才会明白。”如果你像我一
样使用的是英文的 Linux distro 的话，那么这几个名词你大概率是会遇到的，还有就是远程登录
Linux 时会看到的名词是`pty` 或 `pts`/`ptmx`。`pty` 是 pseduo-tty，即虚拟终端的缩写。
`pts`/`ptmx` 分别是 pseduo-terminal slave 和 pseduo-terminal master 的简写（Ops，
是不是涉及了敏感词呢？），是 `pty` 的实现方法。

## 常见的 Shell

上面介绍了一些名词术语的区别，接下来就简单的介绍下常见的 Shell 吧。

既然是个 interpreter，那么肯定就有不同的实现方法，就像 Linux distro 一样，常见的 Shell
<sup>A.2</sup>有：

- sh: Bourne shell
- bash: Bourne-again shell
- csh: C shell
- ksh: Korn shell
- tcsh: TENEX C shell
- zsh: Z shell

`sh` 是 Steve Bourne 在贝尔实验室开发的，`bash` 是 GNU 组织为了对抗 Unix 商业化开发出来
的，遵循 POSIX 标准，`csh` 是 Bill Joy 在伯克利开发的，控制流类似 C 语言，目前以不被推荐
使用，(具体参考 A.3)。`ksh` 是 `sh` 的后续者，由 David Korn 在贝尔实验室开发。`tcsh` 是
`csh` 的加强版，从 TENEX 操作系统（1972 年 BBN 公司 开发）借鉴了很多特色。`zsh` 是后起之
秀，其配合 [`oh-my-zsh`][oh-my-zsh] 被广大开发者使用。这些 shell 中，只有 `csh` 和
`tcsh` 不支持兼容 `sh`，其他的都是支持和兼容 `sh` 的语法，并在其基础上进行了扩充。

## 命令参数

总算是介绍完了历史及周边，那么下面将正式介绍一下一些常用的参数。本节的主要意图是如何理解参数，而
不是详细的介绍所有命令的参数。具体到参数的语法和含义找“男人”（i.e. `man` 命令）去吧。

### -v

首先， unix 有个哲学：没有消息便是好消息。这个哲学确实很不错，但是呢，有时候我就想看下这条命令
具体做了什么，这时候就要用到 `-v` 参数了，对于 `v` 无非就代表 verbose、version 和
inverse 这么几个单词。大部分情况下， `-v` 表示的是 verbose，即将命令执行的消息打印到标准
输出，只有 `grep` 命令中的 `-v` 参数是 `inverse`，毕竟 `grep` 本身就是处理文本的，默认
就会将结果打印到标准输出。对于 version 来说，很少命令是用 `-v` 参数的，就我所接触的而言，
一般要获取版本号要么是 `-V`，要么就是 `--version`，极少数命令会使用 `-v` 表示 version，
当然，我说的命令是那些通用的命令，想一些后续安装的软件什么的那都是看开发者的，他们可能就会使用
`-v` 作为 version 的缩写。像通用的 `tar`、`cp`、`mv`、`rm`、`chmod`、`mkdir`……
这一类基础的命令，想要打印信息，直接放心大胆的加上 `-v` 参数。

### -f

`-f` 能表示的单词也就 force 和 file，对于文本处理的命令三剑客（之后会用另外的文章专门
介绍）——`awk`、`grep` 和 `sed` 来说，没有所谓的 force 一说，所以就只能是表示 file 的
意思了，或是 input-file，或是 pattern-file，亦或是 program-file，反正无论怎么说后面都是
要接一个文件名参数，具体情况请查阅 man page。对于其他命令来说，`-f` 就是 force 的意思，
表强制。知名的例子就是 `rm -rf /` 删盘命令。

### -i

`-i` 能代表的单词也就只有 interactive、ignore-case、in-place、input-file。对于常见的
文件操作 `cp`、`mv` 和 `rm` 来说，`-i` 就是表示 interactive，尤其是对 `rm` 命令来说，
一般都会在删除时加个 `-i` 参数，防止误操作。ignore-case 是在 `grep` 中表示忽略大小写，
in-place 是 `sed` 中的替换参数，input-file 是 `wget` 中一连串下载链接文件。其他的命令
也没怎么接触到这个参数。

### -r/-R

`-r` 一般就是 recursive，表示递归操作。这个通常是在拷贝文件（`cp` 不能直接拷贝文件夹）或修改
文件夹权限、所属用户/组之类（这里使用的是 `-R`）的时候常用，或者说是 `grep` 对文件夹中的所有
文件进行检索。反正不是 `-r` 就是 `-R`，两个之中总有一个表示递归。

### -h

`-h` 无外乎就两个意思，一个是 help，另个是 human-readable，一般来说就是将文件的大小显示为
Mb 或 Gb，默认单位是 Kb。但有时大文件比较多的时候看着那些数字有些烦，加个 -h 显示成 Mb 或
Gb 更加清晰直观。

### -e

`-e` 在命令中一般都是后面接脚本或表达式之类的。比如说 `grep` 中的 `-e` 是接正则表达式
（`grep -e` 等效于 `egrep`），`perl` 中的 `-e` 后接的是 perl 的脚本。注意，这里不要和
`-f` 参数搞混淆， `-f` 是将脚本语句写到一个文件中，然后用 `-f` 参数指定需要执行的脚本文件，
适用于多条脚本语句，`-e` 是直接写脚本的语句，适用于单条脚本语句。

### 其他

对于 `mkdir`、`touch`、`cp`、`mv` 这些文件/文件夹操作命令来说，可以使用 perl 的语法，如
创建多个文件/文件夹：

```bash
touch test{1..9}
mkdir dir{1..9}
```

拷贝或移动多个无规律文件:

```bash
cp ./{hello,world,test} /tmp/
mv ./{hello,world,test} /tmp/
```
**注**：其中大括号里不能出现空格

当然，如果是有规律的，直接使用通配符就好。

`-o` 一般也就是 options 或 output，作为 options 时，后面接的参数用逗号隔开时不能有空格。
大部分命令的参数也都遵循这个原则，就是如果参数后要接多个使用逗号分隔的实参时，中间不能有空格。
如：

```bash
usermod -aG sudo,wheel,root username
mount -o remount,ro /dev/sdX /mnt
```

`-a` 一般表示 all，当然还有 append 的意思。`-l` 一般表 list，`-p` 一般就是 print 或
port，表示 port 有时是`-P`，反正在涉及端口时，`-p` 或 `-P` 总有一个是要接端口号的。

## 结语

当然，要想记住所有命令的参数基本不可能，反正我是记不住那么多，反正只要理解这些参数所代表的英文单
词，然后再类推，常用的命令还是很容易记住的（谁说学计算机对英语没有要求的）。

最后的最后，记住一句话，有事找男人（`man`）。

## Reference

A.1. https://unix.stackexchange.com/questions/4126/what-is-the-exact-difference-between-a-terminal-a-shell-a-tty-and-a-con

A.2. Advanced Programming in the Unix Environment. Third Edition. Page 3.

A.3. http://doc.novsu.ac.ru/oreilly/unix/upt/ch47_02.htm

[oh-my-zsh]: https://ohmyz.sh
[markdown]: https://markdown.com.cn/basic-syntax/
[cmatrix]: https://github.com/abishekvashok/cmatrix
[a.1]: https://unix.stackexchange.com/questions/4126/what-is-the-exact-difference-between-a-terminal-a-shell-a-tty-and-a-con
