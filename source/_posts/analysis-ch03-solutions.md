---
title: analysis-set-theory-solutions
date: 2022-10-28 08:38:01 AM
categories: Mathematic
tags:
  - Mathematic
  - Analysis
---

## 3.1 基础知识

### 3.1.1

证明定义 $3.1.4$ 中“相等”的定义是自反的、对称的和可传递的

定义 $3.1.4$ （集合的相等）称两个集合 $A$ 和 $B$ 是相等的，即 $A=B$，当且仅当 $A$ 中的每一
个元素都是 $B$ 中的元素并且 $B$ 中的每一个元素也都是 $A$ 中的元素。也就是说，$A=B$ 当且仅当
$A$ 中的任一元素 $x$ 属于 $B$，同时 $B$ 中的任一元素 $y$ 也属于 $A$。

证明：

自反性：$(\forall x \in A, x \in A) \Rightarrow A = A$

对称性：$(A = B) \Rightarrow (\forall x \in A, x \in B) \land (\forall x \in B,
x \in A) \Rightarrow B = A$

可传递性：

$$
\begin{align}
&(A = B) \land (B = C) \Rightarrow (\forall x \in A, x \in B) \land (\forall x
\in B, x \in C) \Rightarrow (\forall x \in A, x \in C) \\\\
&(A = B) \land (B = C) \Rightarrow (\forall x \in B, x \in A) \land (\forall x
\in C, x \in B) \Rightarrow (\forall x \in C, x \in A) \\\\
&\Rightarrow A = C
\end{align}
$$

### 3.1.2

只利用定义 $3.1.4$、公理 $3.1$、公理 $3.2$ 和公理 $3.3$ 证明集合 $\varnothing$、
$\\{\varnothing\\}$、$\\{\\{\varnothing\\}\\}$ 和 $\\{\varnothing, \\{\varnothing
\\}\\}$ 是互不相同的集合（即任意两个集合彼此互不相等）。

公理 $3.1$ （集合是对象）如果 $A$ 是一个集合，那么 $A$ 也是一个对象。特别地，给定两个集合
$A$ 和 $B$，问 $A$ 是不是 $B$ 中的元素是有意义的。

公理 $3.2$ （空集）存在一个集合 $\varnothing$，被称为**空集**，它不包含任何元素。也就是说，
对于任意的对象 $x$ 均有 $x \notin \varnothing$。

公理 $3.3$ （单元素集与双元素集）如果 $a$ 是一个对象，那么存在一个集合 $\{a\}$ 并且该集合中
唯一的一个元素就是 $a$。也就是说，对于任意一个对象 $y$，我们有 $y \in \{a\}$ 当且仅当 $y =
a$；我们称 $\{a\}$ 是元素为 $a$ 的**单元素集** 。更近一步地，如果 $a$ 和 $b$ 都是对象，那
么存在一个集合 $\{a, b\}$，并且该集合的元素只有 $a$ 和 $b$。换言之，对任意一个对象 $y$，有
$y \in \{a, b\}$ 当且仅当 $y = a$ 或 $y = b$；我们称该集合是由 $a$ 和 $b$ 构成的**双元素集**。

证明：

$$
\begin{aligned}
&\varnothing \in \\{\varnothing\\}, \varnothing \in \\{\varnothing,
\\{\varnothing\\}\\}, \\{\varnothing\\} \in \\{\\{\varnothing\\}\\} \\\\
&\Rightarrow \varnothing \ne \\{\varnothing\\}, \varnothing \ne
\\{\\{\varnothing\\}\\}, \varnothing \ne \\{\varnothing, \\{\varnothing\\}\\} \\\\
\\\\
&\\{\varnothing\\} \in \\{\\{\varnothing\\}\\}, \\{\varnothing\\} \in
\\{\varnothing, \\{\varnothing\\}\\}, \\{\varnothing\\} \in \\{\varnothing\\} \\\\
&\Rightarrow \\{\varnothing\\} \ne \\{\\{\varnothing\\}\\}, \\{\varnothing\\}
\ne \\{\varnothing, \\{\varnothing\\}\\} \\\\
\\\\
&\varnothing \in \\{\varnothing, \\{\varnothing\\}\\}, \varnothing \notin
\\{\\{\varnothing\\}\\} \\\\
&\Rightarrow \\{\\{\varnothing\\}\\} \ne \\{\varnothing, \\{\varnothing\\}\\} \\\\
\\\\
&\Rightarrow \varnothing \ne \\{\varnothing\\} \ne \\{\\{\varnothing\\}\\} \ne
\\{\varnothing, \\{\varnothing\\}\\}
\end{aligned}
$$

### 3.1.3

证明引理 $3.1.13$ 剩下的论述

引理 $3.1.13$ 如果 $a$ 和 $b$ 都是对象，那么 $\{a, b\} = \{a\} \cup \{b\}$。如果 $A$、
$B$ 和 $C$ 都是集合，那么求并运算时可交换的（即 $A \cup B = B \cup A$），而且可使可结合的
（即 $(A \cup B) \cup C = A \cup (B \cup C)$）。另外有 $A \cup A = A \cup
\varnothing = \varnothing \cup A = A$。

证明：

$$
\begin{align}
&{a, b} \Rightarrow (a \in {a, b}, b \in {a, b}) \\\\
&({a} \cup {b}) \Rightarrow (a \in ({a} \cup {b}), b \in ({a} \cup {b})) \\\\
&\Rightarrow {a, b} = {a} \cup {b} \\\\
\end{align}
$$

同理，

$$
\begin{align}
A \cup B = B \cup A \\\\
\\\\
&x \in A \Leftrightarrow (x \in A) \lor (x \in A) \Leftrightarrow x \in A \cup
A \\\\
&x \in A \Leftrightarrow (x \in A) \lor (x \in \varnothing) \Leftrightarrow x
\in A \cup \varnothing \\\\
&\Rightarrow A \cup \varnothing = \varnothing \cup A
\end{align}
$$

### 3.1.4

证明命题 $3.1.18$ 剩下的论述

命题 $3.1.18$ （集合的包含关系使集合是偏序的）设 $A$、$B$、$C$ 是集合。如果 $A \subseteq
B$ 并且 $B \subseteq C$，那么 $A \subseteq C$。如果 $A \subseteq B$ 并且 $B
\subseteq A$，那么 $A = B$。最后，如果 $A \subsetneq B$ 并且 $B \subsetneq C$，那么
$A \subsetneq C$。

证明：

证 $(A \subseteq B) \land (B \subseteq A) \Rightarrow A = B$ ：

$$
(A \subseteq B) \land (B \subseteq A) \Rightarrow (\forall x \in A, x \in B)
\land (\forall x \in B, x \in A) \Rightarrow (A = B)
$$

证 $(A \subsetneq B) \land (B \subsetneq C) \Rightarrow A \subsetneq C$ ：

$$
\begin{align}
(A \subsetneq B) \land (B \subsetneq C) &\Rightarrow ((A \subseteq B) \land (B
\subseteq C)) \land (\exists c \in C, c \notin B) \\\\
&\Rightarrow (A \subseteq C) \land (\exists c \in C, c \notin A) \\\\
&\Rightarrow (A \subseteq C) \land (A \neq C) \\\\
&\Rightarrow A \subsetneq C
\end{align}
$$

### 3.1.5

设 $A$ 和 $B$ 是集合，证明命题 $A \subseteq B$、$A \cup B = B$ 和 $A \cap B = A$
在逻辑上是等价的（其中任意一个命题都蕴含着其余两个命题）。

证明：

$A \subseteq B \Rightarrow A \cup B = B$：

$$
x \in (A \subseteq B) \Rightarrow (x \in A) \lor (x \in B) \Rightarrow x \in B
\Rightarrow x \in A \cup B
$$

$A \cup B = B \Rightarrow A \subseteq B$：

假设 $A \nsubseteq B$，有 $\exists a \in A, a \notin B$，而 $a \in A \Rightarrow
(a \in A \cup B) \Rightarrow  a \in B$，

假设不成立，即 $A \cup B = B \Rightarrow A \subseteq B$。

同理可证 $A \subseteq B \Leftrightarrow A \cap B = A$。

### 3.1.6

证明命题 $3.1.28$。（提示：我们可以用其中的一些论述去证明另一些论述，有些论述曾在引理$3.1.13$
中出现过。）

命题 $3.1.28$ （集合构成布尔代数）设 $A$、$B$、$C$ 都是集合，令 $X$ 表示包含 $A$、$B$、
$C$ 作为其自己的集合。

a). （最小元）$A \cup \varnothing = A$ 和 $A \cap \varnothing = \varnothing$

b). （最大元）$A \cup X = A$ 和 $A \cap X = X$

c). （恒等式）$A \cap A = A$ 和 $A \cup A = A$

d). （交换律）$A \cup B = B \cup A$ 和 $A \cap B = B \cap A$

e). （结合律）$(A \cup B) \cup C = A \cup (B \cup C)$ 和 $(A \cap B) \cap C = A
\cap (B \cap C)$

f). （分配律）$A \cap (B \cup C) = (A \cap B) \cup (A \cap C)$ 和 $A \cup (B \cap
C) = (A \cup B) \cap (A \cup C)$

g). （分拆法）$A \cup (X \setminus A) = X$ 和 $A \cap (X \setminus A) = \varnothing$

h). （德·摩根定律）$X \setminus (A \cup B) = (X \setminus A) \cap (X \setminus B)$ 和 $X \setminus (A \cap B) = (X \setminus A) \cup (X \setminus B)$

证明：

a).

$$
\begin{align}
&(x \in A \cup \varnothing) \Rightarrow ((x \in A) \lor (x \in \varnothing))
\Rightarrow x \in A \\\\
&x \in A \Rightarrow x \in A \cup \varnothing \\\\
&(x \in A \cap \varnothing) \Rightarrow ((x \in A) \land (x \in \varnothing)) \\\\
&\Rightarrow A \cap \varnothing = \varnothing
\end{align}
$$

b).

$$
\begin{align}
&(x \in A \cup X) \Rightarrow((x \in A) \lor (x \in X)) \Rightarrow x \in X \\\\
&x \in X \Rightarrow x \in A \cup X \\\\
&(x \in A \cup X) \Leftrightarrow ((x \in A) \land (x \in X)) \Leftrightarrow x
\in A
\end{align}
$$

c).

$$
\begin{align}
&(x \in A \cap A) \Leftrightarrow ((x \in A) \land (x \in A)) \Leftrightarrow x
\in A \\\\
&(x \in A \cup A) \Leftrightarrow ((x \in A) \lor (x \in A)) \Leftrightarrow x
\in A
\end{align}
$$

d). 习题 $3.1.3$ 中已经证明。

e). 因为 $\lor$ 和 $\land$ 是可结合的，所以结论显然成立。

f).

证 $A \cap (B \cup C) = (A \cap B) \cup (A \cap C)$：

$$
\begin{align}
(x \in A \cap (B \cup C)) &\Leftrightarrow ((x \in A) \land ((x \in B) \lor (x
\in C))) \\\\
&\Leftrightarrow ((x \in A) \land (x \in B)) \lor ((x \in A) \land (x \in C)) \\\\
&\Leftrightarrow (x \in (A \cap B)) \lor (x \in (A \cap C)) \\\\
&\Leftrightarrow x \in (A \cap B) \cup (A \cap C)
\end{align}
$$

同理可证：$A \cup (B \cap C) = (A \cup B) \cap (A \cup C)$

g).

证 $A \cup (X \setminus A) = X$：

显然 $A \cup (X \setminus A) \subseteq X$，对 $\forall x \in X$，$x \in A$ 或 $x
\notin A$

$x \notin A \Rightarrow x \in X \setminus A \Rightarrow x \in A \cup (X
\setminus A)$

证 $A \cap (X \setminus A) = \varnothing$：

设 $\exists x \in X, x \in A \cap (X \setminus A)$，那么有：

$(x \in A) \land (x \notin A)$，结果不成立，假设不成立，即有：

$A \cap (X \setminus A) = \varnothing$

h). 显然成立

### 3.1.7

设 $A$、$B$、$C$ 都是集合，证明 $A \cap B \subseteq A$ 和 $A \cap B \subseteq B$。
更进一步地，证明 $C \subseteq A$ 且 $C \subseteq B$，当且仅当 $C \subseteq A \cap B$。
类似地，证明 $A \subseteq A \cup B$ 和 $B \subseteq A \cup B$，且进一步证明 $A
\subseteq C$ 且 $B \subseteq C$，当且仅当 $A \cup B \subseteq C$。

证明：

$$
(x \in A \cap B) \Rightarrow (x \in A) \land (x \in B) \Rightarrow (A \cap B
\subseteq A) \land (A \cap B \subseteq B)
$$

$$
\begin{align}
(C \subseteq A) \land (C \subseteq B) &\Leftrightarrow (\forall x \in C, x \in
A) \land (\forall x \in c, x \in B) \\\\
&\Leftrightarrow (\forall x \in C, x \in A \cap B) \\\\
&\Leftrightarrow C \subseteq A \cap B
\end{align}
$$

同理：

$$
(x \in A) \Rightarrow (x \in A) \lor (x \in B) \Rightarrow x \in A \cup B
\Rightarrow A \subseteq A \cup B \\\\
(x \in B) \Rightarrow (x \in A) \lor (x \in B) \Rightarrow x \in A \cup B
\Rightarrow B \subseteq A \cup B
$$

$$
\begin{align}
(A \subseteq C) \land (B \subseteq C) &\Leftrightarrow (\forall x \in A, x \in
C) \land (\forall x \in B, x \in C) \\\\
&\Leftrightarrow ((\forall x \in A, x \in B) \Rightarrow (x \in C)) \\\\
&\Leftrightarrow A \cup B \subseteq C
\end{align}
$$

### 3.1.8

设 $A$ 和 $B$ 是集合，证明**吸收率** $A \cap (A \cup B) = A$ 和 $A \cup (A \cap B)
= A$。

证明：

$$
x \in A \cap (A \cup B) \Leftrightarrow (x \in A) \land (x \in A \cup B)
\Leftrightarrow x \in A，即 A \cap (A \cup B) = A \\\\
x \in A \cup (A \cap B) \Leftrightarrow (x \in A) \lor (x \in A \cap B)
\Leftrightarrow x \in A，即 A \cup (A \cup B) = A
$$

### 3.1.9

令 $A$、$B$、$X$ 表示集合，并且它们满足 $A \cup B = X$ 和 $A \cap B = \varnothing$。
证明 $A = X \setminus B$ 和 $B = X \setminus A$。

证明：

由题意可知 $A$ 和 $B$ 是对称的，所以只需证 $A = X \setminus B$

$$
\begin{align}
&((x \in A) \land (A \cap B) = \varnothing) \Rightarrow x \notin B \\\\
&x \in X \setminus B \Rightarrow (x \in X) \land (x \notin B) \Rightarrow (x \in
A \cup B) \land (x \notin B) \Rightarrow x \in A
\end{align}
$$

因此 $A = X \setminus B$

### 3.1.10

设 $A$ 和 $B$ 是集合，证明三个集合 $A \setminus B$、$A \cap B$、$B \setminus A$ 是不
相交的，并且它们的并集时 $A \cup B$。

证明：

$$
\begin{align}
&x \in A \setminus B \Rightarrow (x \in A) \land (x \notin B) \Rightarrow (x
\notin A \cap B) \land (x \notin B \setminus A) \\\\
&\Rightarrow A \setminus B \neq A \cap B, A \setminus B \neq B \setminus A
\end{align}
$$

同理：$A \cap B \neq A \setminus B, A \cap B \neq B \setminus A$，$B \setminus A
\neq A \cap B, B \setminus A \neq A \setminus A$。

由题意可得 $A \setminus B \subseteq A \cup B, A \cap B \subseteq A \cup B, B
\setminus A \subseteq A \cup B$，

当 $x \in A \cup B$ 时，$(x \in A) \lor (x \in B)$，因此 $x \in A \setminus B, x
\in A \cap B, x \in B \setminus A$ 即：

$(A \setminus B) \cup (A \cap B) \cup (B \setminus A) = A \cup B$

### 3.1.11

证明替代公理能够推导出分类公理。

公理 $3.6$（替代）设 $A$ 是一个集合，对任意的 $x \in A$ 和任意的一个对象 $y$，假设存在一个
关于 $x$ 和 $y$ 的命题 $P(x, y)$ 使得对任意的 $x \in A$，最多能够找到一个 $y$ 使得
$P(x, y)$ 为真。那么存在一个集合 $\{y: P(x, y) 对某 x \in A 为真\}$ 使得对任意的对象
$z$，$z \in \{y: P(x, y) 对某 x \in A 为真\} \Leftrightarrow 对某 x \in A, P(x, z)
为真$。

公理 $3.5$ （分类/分离）设 $A$ 是一个集合，对任意的 $x \in A$，令 $P(x)$ 表示关于 $x$ 的
一个性质（即 $P(x)$ 要么时真命题，要么是假命题）。那么存在一个集合，记作 $\{x \in A: P(x)
为真\}$（或者简记为 $\{x \in A: P(x)\}$），该集合恰好时由 A 中那些使得 $P(x)$ 为真的元素
$x$ 构成的。换言之，对任意的对象 $y$，$y \in \{x \in A: P(x) 为真\} \Leftrightarrow
(y \in A 并且 P(y) 为真)$。

证明：

设 $ x \in A$，$P(x)$ 为 $x$ 的某一属性，$P(x, y)$ 为 $x, y$ 的某一属性，记作：

$$
P(x, y) = \{P(y) 为真，y \in \{x\}\}
$$

由公理 $3.3$ 只有当 $\{x\}$ 存在时，上面等式才成立。

即对每个 $x \in A$，最多只有一个 $y$ 使得 $P(x, y)$ 为真，当且仅当 $y = x$ 时，$P(x)$
为真，否则为假。

因此有存在一个集合 $\{x \in A: P(x) 为真\}$，使得 $\{y: P(y) 为真，x \in A\}$：

$$
\begin{align}
&y \in \{y: P(y) 为真, x \in A\}, P(y) 为真 \\\\
&(y \in \{x\}) \land (x \in A) \Rightarrow y \in A \\\\
&\Rightarrow y \in \{x \in A: P(x) 为真\}
\end{align}
$$

同时：

$$
\begin{align}
&z \in \{x \in A: P(x) 为真\}, P(x) 为真 \\\\
&z \in \{z\} \Rightarrow P(z, z) 为真 \\\\
&\Rightarrow z \in \{y: P(y) 为真, x \in A\}
\end{align}
$$

## 3.2 罗素悖论

公理 $3.8$（万有分类）假设对任意的对象 $x$，存在关于 $x$ 的性质 $P(x)$（于是对每一个 $x$，
$P(x)$ 要么为真命题，要么为假命题）。那么存在一个集合 $\{x: P(x) 为真\}$ 使得对任意的对象
$y$，

$$
y \in \{x: P(x) 为真\} \Leftrightarrow P(y) 为真
$$

### 3.2.1

证明：如果我们假定万有分类定理（即公理 $3.8$）为真，那么它能推出公理 $3.2$（空集）、$3.3$
（单元素集和双元素集）、$3.4$（两集合的并集）、$3.5$（分类公理）和 $3.6$（替代公理）。（如果
我们假定所有的自然数都是对象，那么也可以得到公理 $3.7$。）因此，如果这个公理被认可，那么它将极
大地简化集合轮的基础（而且它将被看作人们称之为“朴素集合论”的一个直观模型基础）。遗憾的是，正如
我们所看到的那样，公理 $3.8$ “太好以至于不现实”！

证：

- 公理 $3.2$

令 $P(x)$ 为：$x$ 与 $x$ 不同，则集合 $\{x: P(x) 为真\}$ 为空集。

- 公理 $3.3$

令 $a$ 为一个对象，则 $\{x: x = a\}$ 为单元素集；

令 $a$、$b$ 均为对象，则 $\{x: (x = a) \lor (x = b)\}$ 为双元素集。

- 公理 $3.4$

并集为 $\{x: (x \in A) \lor (x \in B)\}$

- 公理 $3.5$

$3.8$ 能直接推导出 $3.5$，两个公理均为分类公理。

- 公理 $3.6$

令 $P(y)$ 为：$\exists x \in A, P(x, y)$ 为真，则由 $3.8$ 有：

$$
\{y: P(y) 为真\} = \{y: P(x, y) 为真，当 x \in A\}
$$

- 公理 $3.7$

令 $P(x)$ 为 $P_1(x) \land P_2(x)$ 的属性，则：

$$
P_1(x) = (x = 0) \lor ((x \neq 0) \land (x++ \neq 0) \land (\exists ! y, y++ =
x, y \in N)) \\\\
P_2(x) = (Q(0) 为真) \land ((Q(n) 为真 \Rightarrow Q(n++) 为真) \Rightarrow Q(x)
为真)，Q 为自然数 n 的任意属性
$$

因此： $N = \{x: P(x) 为真\}$

### 3.2.2

利用正则性公理（和单元素集公理）证明：如果 $A$ 是一个集合，那么 $A \notin A$。进一步证明：
如果 $A$ 和 $B$ 是两个集合，则要么 $A \notin B$，要么 $B \notin A$（要么 $A \notin B$
且 $B \notin A$）。

证：

假设 $A$ 为集合，如果 $A = \varnothing$，则 $A$ 中没有任何元素，从而 $A \notin A$；

假设 $A \neq \varnothing, A \in A$，由 $3.3$ 单元素集有 $\\{A\\}$ 是个集合。

由 $3.9$ 正交性有集合 $\\{A\\}$ 中至少存在一个元素 $x$ 满足：$x$ 要么不是集合，要么 $x$ 与
$\\{A\\}$ 不相交。

而 $\\{A\\}$ 只有一个元素 $A$，而 $A$ 是集合，那么 $A$ 与 $\\{A\\}$ 不相交。但 $A \in A,
A \in \\{A\\} \Rightarrow A \cap \\{A\\} = A$, 结果矛盾，假设不成立。

再假设 $A$、$B$ 均为集合且 $A \in B, B \in A$，则集合 $\\{A, B\\}$ 根据 $3.9$ 有 $A$
与 $\\{A, B\\}$ 不相交或 $B$ 与 $\\{A, B\\}$ 不相交，而根据假设有：$ B \in A \cap
\\{A, B\\}$ 和 $A \in B \cap \\{A, B\\}$，结果矛盾，假设不成立。

即证。

### 3.2.3

在假定集合论其他公理成立的前提下，验证万有分类公理（即公理 $3.8$）与这样一个公理是等价的：该
公理嘉定存在一个由一切对象所构成的“万有集合” $\Omega$（即对任意一个对象 $x$，都有 $x \in
\Omega$）。换言之，如果公理 $3.8$ 为真，那么就存在一个万有集合；反之，如果存在一个万有集合，
那么公理 $3.8$ 就为真。（这或许就解释了为什么公理 $3.8$ 被称为万有分类公理。）注意，如果存在
一个万有集合 $\Omega$，那么利用公理 $3.1$ 可知 $\Omega \in \Omega$，这与习题 $3.2.2$
相矛盾。因此，基本公理明确排除了万有分类公理。

证：

假设存在万有集合 $\Omega$，根据公理 $3.5$ 直接能得到公理 $3.8$。

假设公理 $3.8$ 为真，则可得到一个包含所有对象的集合（万有集合 $\Omega$）：

$$
\\{x: x \notin \varnothing\\}
$$
