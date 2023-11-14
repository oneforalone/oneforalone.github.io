---
title: analysis-nature-number-solutions
date: 2022-10-26 10:04:56 AM
categories: Mathematic
tags:
  - Mathematic
  - Analysis
---

## 2.2 加法

### 2.2.1

证明命题 2.2.5

命题 $2.2.5$ （加法是可结合的）对任意三个自然数 a、b、c，有 $(a + b) + c = a + (b + c)$
成立。

证明：

设 $a, c$ 为定值，对 $b$ 采取归纳法：
当 $b = 0$ 时：

$$
\begin{align}
左式 = (a + 0) + c = a + c \\\\
右式 = a + (0 + c) = a + c
\end{align}
$$

原式左右两边相等，等式成立。

假设当 $b = b$ 时 $(a + b) + c = a + (b + c)$ 成立，
则当 $b = b++$ 时：

左式为：$(a + b++) + c$，根据引理 $2.2.3. n + (m++) = (n + m)++$ 有：

$$
(a + b++) + c = ((a + b)++) + c
$$

根据引理 $2.2.4. n + m = m + n$ 有：

$$
\begin{align}
((a + b)++) + c &= c + ((a + b)++) \\\\
&= (c + (a + b))++ \\\\
&= ((a + b) + c)++
\end{align}
$$

右式为：

$$
\begin{align}
a + (b++ + c) &= a + ((b + c)++) \\\\
&= (a + (b + c))++
\end{align}
$$

又因为当 $b = b$ 时 $(a + b) + c = a + (b + c)$ 成立，

所以 $(c + (a + b))++ = (a + (b + c))++$，即 左式 = 右式，

因此当 $b= b++$ 时，原式 $(a + b++) + c = a + (b++ + c)$ 成立。

即证：对任意三个自然数 $a$、$b$、$c$，有 $(a + b) + c = a + (b + c)$ 成立。

### 2.2.2

证明引理 2.2.10

引理 $2.2.10$ 令 $a$ 表示一个正自然数，那么恰存在一个自然数 $b$ 使得 $b++ = a$。

证明：

因为 $a \in N^+$，

当 $a = 1$ 时，$0++ = 1 \Rightarrow b = 0$，此时 $b$ 为自然数。

设当 $a = a$ 时，$b++ = a$，则当 $a = a++$时，有：

$$
b++ = a++
$$

此时 $b = a$，因为 $a \in N^+$，所以 $ b \in N^+$，等式成立。

即证：令 $a$ 表示一个正自然数，那么恰存在一个自然数 $b$ 使得 $b++ = a$。

### 2.2.3

证明命题 2.2.12

命题 $2.2.12$ （自然数的序的基本性质）令 a、b、c 为任意自然数，那么：

(a)（序是自反的）$a \geqslant a$。

(b)（序是可传递的）如果 $a \geqslant b$ 并且 $b \geqslant c$，那么 $a \geqslant c$。

(c)（序是反对称的）如果 $a \geqslant b$ 并且 $b \geqslant a$，那么 $a = b$。

(d)（加法保持序不变）$a \geqslant b$，当且仅当 $a + c \geqslant b + c$。

(e) $a < b$，当且仅当 $a++ \leqslant b$。

(f) $a < b$，当且仅当存在正自然数 d 使得 $b = a + d$。

证明：

定义 $2.2.11$（自然数的序）令 $n$ 和 $m$ 表示任意两个自然数。我们称 $n$ 大于等于 $m$，
记作 $n \geqslant m$ 或 $m \leqslant n$，当且仅当存在自然数 $a$ 使得 $n = m + a$。
我们称 $n$ 严格大于 $m$，并且记作 $n > m$ 或 $m < n$，当且仅当 $n \geqslant m$ 且 $n
\ne m$。

(a)

因为 $a = a + 0, 0 \in N$，根据定义 $2.2.11$ 就有 $a \geqslant a$。

(b)

根据定义 $2.2.11$ 有：

$a \geqslant b \Rightarrow a = b + m, m \in N$，

$b \geqslant c \Rightarrow b = c + n, n \in N$

所以：

$a = c + n + m, n + m \in N$。

即 $a \geqslant c$.

因此：如果 $a \geqslant b$ 并且 $b \geqslant c$，那么 $a \geqslant c$。

(c\)

根据定义 $2.2.11$ 有：

$a \geqslant b \Rightarrow a = b + m, m \in N$，

$b \geqslant a \Rightarrow b = a + n, n \in N$

所以：

$$
\begin{align}
&a = a + n + m, n + m \in N \\\\
&\Rightarrow n + m = 0 \\\\
&\Rightarrow m = 0, n = 0 \\\\
&\Rightarrow a = b
\end{align}
$$

即证：如果 $a \geqslant b$ 并且 $b \geqslant a$，那么 $a = b$。

(d)

由定义 $2.2.11$ 有：

$$
\begin{align}
a \geqslant b &\Leftrightarrow a = b + m, m \in N \\\\
&\Leftrightarrow a + c = b + m + c = b + c + m, m \in N \\\\
&\Leftrightarrow a + c \geqslant b + c
\end{align}
$$

即证：$a \geqslant b$，当且仅当 $a + c \geqslant b + c$

(e)

$$
\begin{align}
a < b &\Leftrightarrow ((a \leqslant b) \land (a \ne b)) \\\\
&\Leftrightarrow ((a + m = b, m \in N) \land (a \ne b)) \\\\
&\Leftrightarrow m \ne 0 \\\\
&\Leftrightarrow \exists n \in N, n++ = m \\\\
&\Leftrightarrow a + (n++) = b, n \in N \\\\
&\Leftrightarrow (a++) + n = b, n \in N \\\\
&\Leftrightarrow a++ \leqslant b
\end{align}
$$

(f)

$$
\begin{align}
a < b &\Leftrightarrow ((a < b) \land ( a \ne b)) \\\\
&\Leftrightarrow ((a + d = b, d \in N) \land (d \ne 0)) \\\\
&\Leftrightarrow a + d = b, d \in N^+
\end{align}
$$

### 2.2.4

证明在命题 2.2.13 证明中标注了（为什么？）的三个命题：

1. 当 $a = 0$ 时，对所有的 b 均有 $0 \leqslant b$
2. 如果 $a > b$，那么有 $a++ > b$
3. 如果 $a = b$，那么 $a++ > b$

证明：

1.

$$
(0 + b = b, b \in N) \Rightarrow (0 \leqslant b, b \in N)
$$

2.

$$
\begin{align}
a > b &\Rightarrow ((a = b + m, m \in N) \land (a \ne b)) \\\\
&\Rightarrow a++ = (b + m)++ = b + (m++), m \in N \\\\
&\Rightarrow a++ > b
\end{align}
$$

3.

$$
\begin{align}
a = b &\Rightarrow a++ = b++ = (b + 0)++ = b + (0++) = b + 1 \\\\
&\Rightarrow a++ > b
\end{align}
$$

### 2.2.5

证明命题 2.2.14（提示：定义 $Q(n)$ 是关于 n 的一个如下性质：$P(m)$对任意满足 $m_0
\leqslant m \leqslant n$ 的 m 均为真；注意，当 $n < m_0$ 时，$Q(n)$为真，因为此时 m 的
取值范围为空。）

命题 2.2.14（强归纳法原理）令 $m_0$ 表示一个自然数，$P(m)$ 表示与任意自然数 m 有关的性质。
假设对任意满足 $m \geqslant m_0$ 的自然数 m，均有如下内容成立：若 $P(m')$ 对任意满足
$m_0 \leqslant m' < m$ 的自然数 $m'$ 均为真，那么 $P(m)$ 也为真。（特别地，这意味着
$P(m_0)$ 为真，因为当 $m = m_0$ 时，前提中的 $m'$ 的取值范围为空。）于是我们能够断定，对于
任意满足 $m \geqslant m_0$ 的自然数 m，$P(m)$ 为真。

证明：

令 $Q(n) := \{P(m) 为真，\forall m_0 \leqslant m < n\}$，当 $n < m_0$ 时 $Q(n)$ 为真。

等价于 $\forall n \geqslant m_0, Q(n) 为真$。

当 $n = m_0$ 时，因为 $m_0 \leqslant m < m_0$ 不成立，所以 $Q(m_0) 为真。

设当 $n = n$ 时，$Q(n)$ 为真。

则当 $n = n++$ 时，因为 $Q(n)$ 为真，所以对 $\forall m_0 \leqslant k < n$ 有 $P(k)$为
真，因此 $P(n)$ 也为真，从而推出 $Q(n++)$ 也为真，即 $Q(n++) = \{P(k) 为真， m_0
\leqslant k < n++\}$

### 2.2.6

令 n 表示一个自然数，令 $P(m)$ 是关于自然数的一个性质并且满足：只要 $P(m++)$ 为真，$P(m)$
就为真。假设 $P(n)$ 也为真，证明：$P(m)$ 对任意满足 $m \leqslant n$ 的自然数 $m$ 均为真；
这被成为**逆向归纳法原理**。（提示：对变量 $n$ 使用归纳法）

证明：

令 $Q(n) := \{P(m) 为真，\forall m \leqslant n\}$

当 $n = 0$ 时，条件成立.

设当 $n = k$ 时， $Q(k) := \{P(m) 为真，\forall m \leqslant k\}$，

则当 $n = k++$ 时，因为 $Q(k)$ 成立，所以 $P(k++)$，所以 $Q(k++)$ 为真，

因此 $Q(k++) = \{P(m) 为真，\forall m \leqslant k++\}$。

## 2.3 乘法

### 2.3.1

证明引理 $2.3.2$（提示：修改引理 $2.2.2$、引理 $2.2.3$ 以及命题 $2.2.4$ 的证明）

引理 $2.3.2$（乘法交换律）令 $n$ 和 $m$ 表示任意两个自然数，那么有 $n \times m = m
\times n$ 成立。

证明：

a). 对 $m \times 0 = 0, \forall m \in N$ 成立进行归纳：

当 $m = 0$ 时，$0 \times 0 = 0$，等式成立，

设 $m = m$ 时成立，则有 $m \times 0 = 0$ 成立，

当 $m = m++$ 时，有 $(m++) \times 0 = (m + 0) + 0 = 0 + 0 = 0$ 等式依然成立。

b). 对 $n \times (m++) = (n \times m) + n, \forall m, n \in N$ 成立进行归纳：

当 $n = 0$ 时，$0 \times (m++) = 0 = 0 \times m = 0$，等式成立，

设 $n = n$ 时成立，则有 $n \times (m++) = (n \times m) + n$ 成立，

当 $n = n++$ 时，有

$$
\begin{align}
(n++) \times (m++) &= n \times (m++) + (m++) \\\\
&= n \times m + n + (m++) \\\\
&= n \times m + m + (n++) \\\\
&= (n++) \times m + (n++)
\end{align}
$$

等式 $(n++) \times (m++) = (n++) \times m + (n++)$ 成立。

c). 对 $n \times m = m \times n, \forall m, n \in N$ 成立进行归纳：

当 $n = 0$ 时，$ 0 \times m = 0 = m \times 0$，等式成立，

设 $n = n$ 时成立，则有 $ n \times m = m \times n$ 成立，

当 $n = n++$ 时，有：

$$
(n++) \times m = n \times m + n = m \times n + m = m \times (n++)
$$

即等式 $ n \times m = m \times n, \forall m, n \in N$ 成立。

### 2.3.2

证明引理 $2.3.3$（提示：首先证明第二个命题）

引理 $2.3.3$ （正自然数没有零因子）设 $n$、$m$ 为自然数。那么 $n \times m = 0$，当且仅当
$n$ 和 $m$ 中至少有一个为零。特别的，如果 $n$ 和 $m$ 均为正，那么 $nm$ 也是正的。

证明：

有题意有：

$$
\begin{align}
&(n \in N+) \land (m \in N^+) \\\\
&\Rightarrow \exists c, d \in N, c++ = n, d++ = m \\\\
&\Rightarrow nm = (c++) \times (d++) = c \times (d++) + (d++) = (c \times (d++) + d)++ \\\\
&\Rightarrow nm \in N^+
\end{align}
$$

### 2.3.3

证明命题 2.3.5（提示：修改命题 2.2.5 的证明并利用分配律）

命题 2.3.5（乘法结合律）对任意自然数 $a$、$b$、$c$ ，$(a \times b) \times c = a \times
(b \times c)$ 均成立.

证明：

对 $b$ 进行归纳：

当 $b = 0$ 时，$(a \times 0) \times c = 0 \times c = 0, a \times (0 \times c) = a
\times 0 = 0$，左边 = 右边，等式成立，

设当 $b = b$ 时成立，则有 $(a \times b) \times c = a \times (b \times c)$ 成立，

当 $b = b++$ 时，有：

$$
\begin{align}
&(a \times (b++)) \times c = (a \times b + a) \times c = (a \times b) \times c + a \times c \\\\
&a \times ((b++) \times c) = a \times ((b \times c) + c) = a \times (b \times c) + a \times c = (a \times b) \times c + a \times c \\\\
&\Rightarrow (a \times (b++)) \times c = a \times ((b++) \times c)
\end{align}
$$

### 2.3.4

证明等式 $(a + b)^2 = a^2 + 2ab + b^2$ 对任意自然数 $a$ 和 $b$ 均成立

证明：

$$
\begin{align}
&(a + b)^2 = (a + b)(a + b) \\\\
&=a(a + b) + b(a + b) \\\\
&=a^2 + ab + ba + b^2 \\\\
&=a^2 + 2ab + b^2
\end{align}
$$

### 2.3.5

证明命题 2.3.9（提示：固定 $q$ 并对 $n$ 进行归纳）

命题 2.3.9（欧几里得算法）设 $n$ 是一个自然数，$q$ 表示一个正自然数，那么存在自然数 $m$ 和
$r$ 使得 $0 \leqslant r < q$ 并且 $n = mq + r$。

证明：

固定 $q$，对 $n$ 进行归纳：

当 $n = 0$ 时，$0 = m \times q + r, m = 0, r = 0 < q$，等式成立，

假设 $n = n$ 时成立，则有 $n = mq + r, 0 \leqslant r < q$ 成立，

当 $n = n++$ 时，有：

$$
n++ = (mq + r)++ = mq + (r++) \\\\
r < q \Rightarrow (r++) \leqslant q \Rightarrow ((r++) < q) \lor ((r++) = q)
$$

当 $r++ < q$ 时，等式成立，

当 $r++ = q$ 时，有：

$$
n++ = (mq + r)++ = mq + (r++) = mq + q = (m++)q + 0
$$

等式依然成立，即证。
