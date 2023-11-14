---
title: Calculus Formula
date: 2021-09-20
categories: Mathematic
tags:
  - Caculus
  - Mathematic
---

## 微分 —— 积分

$\frac{d}{dx}x^a = ax^{a-x}$ $\qquad$ $\qquad$ $\qquad$ $\int x^adx =
\frac{x^{a+1}}{a+1} + C$

$\frac{d}{dx}\ln(x) = \frac{1}{x}$ $\qquad$ $\qquad$ $\qquad$ &nbsp; $\int
\frac{1}{x}dx = \ln \mid x \mid + C$

$\frac{d}{dx}e^x = e^x$ $\qquad$ $\qquad$ $\qquad$ $\quad$ $\int e^xdx = e^x +
C$

$\frac{d}{dx}b^x = b^x\ln(x)$ $\qquad$ $\qquad$ $\quad$ &nbsp;$\int b^xdx =
\frac{b^x}{\ln(b)} + C$

$\frac{d}{dx}\sin(x) = \cos(x)$ $\qquad$ $\qquad$ &nbsp;&nbsp; $\int \cos(x)dx
= \sin(x) + C$

$\frac{d}{dx}\cos(x) = -\sin(x)$ $\qquad$ $\qquad$ $\int \sin(x)dx = -\cos(x) +
C$

$\frac{d}{dx}\tan(x) = \sec^2(x)$ $\qquad$ $\qquad$ &nbsp; $\int \sec^2(x)dx =
\tan(x) + C$

$\frac{d}{dx}\sec(x) = \sec(x)\tan(x)$ $\qquad$ &nbsp;&nbsp; $\int
\sec(x)\tan(x)dx = \sec(x) + C$

$\frac{d}{dx}\cot(x) = -\csc^2(x)$ $\qquad$ $\quad$ &nbsp; $\int \csc^2(x)dx =
-\cot(x) + C$

$\frac{d}{dx}\csc(x) = -\csc(x)\cot(x)$ $\qquad$ $\int \csc(x)\cot(x)dx =
-\csc(x) + C$

$\frac{d}{dx}\sin^{-1}(x) = \frac{1}{\sqrt{1-x^2}}$ $\qquad$ $\quad$ $\int \frac{1}{\sqrt{1-x^2}}dx = \sin^{-1}(x) + C$

$\frac{d}{dx}\tan^{-1}(x) = \frac{1}{1+x^2}$ $\qquad$ $\qquad$ &nbsp; $\int
\frac{1}{1+x^2} = \tan^{-1} + C$

$\frac{d}{dx}\sec^{-1}(x) = \frac{1}{\mid x \mid\sqrt{x^2-1}}$ $\qquad$ $\quad$ $\int \frac{1}{\mid x \mid\sqrt{x^2-1}}dx = \sec^{-1}(x) + C$

$\frac{d}{dx}\sinh(x) = \cosh(x)$ $\qquad$ $\quad$ &nbsp; $\int \cosh(x)dx =
\sinh(x) + C$

$\frac{d}{dx}\cosh(x) = \sinh(x)$ $\qquad$ $\quad$ &nbsp; $\int \sinh(x)dx =
\cosh(x) + C$

其中:
\
$\tan(x) = \frac{\sin(x)}{\cos(x)}$,
$\sec(x) = \frac{1}{\cos(x)}$, $\csc(x) = \frac{1}{\sin(x)}$,
$\cot(x) = \frac{1}{\tan(x)} = \frac{\cos(x)}{\sin(x)}$,

$e = \lim\limits_{h \rightarrow 0^+} (1+h)^{\frac{1}{h}}$,
$\cosh(x) = \frac{e^x + e^{-x}}{2}$,
$\sinh(x) = \frac{e^x - e^{-x}}{2}$

因此

$$
\cosh^2(x) = (\frac{e^x + e^{-x}}{2})^2 = \frac{e^{2x} + e^{-2x} + 2}{4},
\\\\
\sinh^2(x) = (\frac{e^x - e^{-x}}{2})^2 = \frac{e^{2x} + e^{-2x} - 2}{4}.
\\\\
\Longrightarrow \cosh^2(x) - \sinh^2(x) = \frac{e^{2x} + e^{-2x} + 2}{4} -
\frac{e^{2x} + e^{-2x} - 2}{4} = \frac{4}{4} = 1 \\\\
$$

thus, $\qquad \cosh^2(x) - \sinh^2(x) = 1$

现在来证明 $\frac{d}{dx}sinh(x) = cosh(x)$ 和 $\frac{d}{dx}cosh(x) = sinh(x)$ :

$$
\frac{d}{dx}sinh(x) = \frac{d}{dx}(\frac{e^x - e^{-x}}{2}) = \frac{e^x +
e^{-x}}{2} = cosh(x) \\\\
\frac{d}{dx}cosh(x) = \frac{d}{dx}(\frac{e^x + e^{-x}}{2}) = \frac{e^x -
e^{-x}}{2} = sinh(x)
$$

## 微分法则

1. $\frac{d}{dx}(h(x) \pm g(x)) = \frac{dh}{dx}(x) \pm \frac{dg}{dx}(x)$
2. $\frac{d}{dx}(h(x) \times g(x)) = h(x) \times \frac{dg}{dx}(x) +
\frac{dh}{dx}(x) \times g(x)$
3. $\frac{d}{dx}(\frac{h(x)}{g(x)}) = \frac{h'(x) \cdot g(x) - h(x) \cdot
g'(x)}{g^2(x)}$
4. $\frac{d}{dx}(h(g(x))) = \frac{dh}{dg}(x)\frac{dg}{dx}(x)$

$\frac{d}{dx}a^x = a^xln(a)$

there is: $\frac{de^x}{dx} = e^x$
base on chain rule: $\frac{de^{cx}}{dx} = ce^{ct}$
and the exponet rules: $a^x = e^{ln(a)x}$, cause $e^{ln(a)} = a$
thus, $\frac{d}{dx}a^x = \frac{d}{dx}e^{ln(a)x} = e^{ln(a)x}ln(a) = a^xln(a)$

implicit curve:
a set of all points (x, y) that satisfy some property written in terms of the
two variables x and y, such as $x^2 + y^2 = 5^2$

using implicit curve to deduce/derive $\frac{d}{dx}ln(x) = \frac{1}{x}$

Because $e^{ln(x)} = x$
let $y = ln(x)$
then $e^y = x$
derivative of two sides of equation, $e^ydy = dx$
=> $\frac{dy}{dx} = \frac{1}{e^y}$
and cause $e^y=x$
so, $\frac{dy}{dx} = \frac{1}{x}$

Formal definition of derivatives

$\frac{df}{dx}(x) = \lim\limits_{h \to 0} \frac{f(x+h) - f(x)}{h}$

L'Hopital's rule, discovered by Bernoulli
case $\frac{0}{0}$ : $\lim\limits_{x \to a} \frac{f(x)}{g(x)} =
\frac{\frac{df}{dx}(a)dx}{\frac{dg}{dx}(a)dx} =
\frac{\frac{df}{dx}(a)}{\frac{dg}{dx}(a)}$

## Integrate

inverse of derivatives

$\int_{a}^bf(x)dx = F(b) - F(a)$, $\frac{dF}{dx}(x) = f(x)$ , F(x) is
antiderivative of f(x)
