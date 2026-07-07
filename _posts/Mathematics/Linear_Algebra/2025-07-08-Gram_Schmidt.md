---
title: "[선형대수] 그람-슈미트 과정 (Gram-Schmidt Process)"
date: 2025-07-08 00:00:00 +/-TTTT
categories: [Mathematics, 선형대수]
tags: [선형대수]
math: true
toc: true
author: sunho
---

**그람 슈미트 과정**은 기저 $B$를, 같은 공간을 span하는 정규 직교 기저 $Q$로 변환하는 방법이다.

$$
B=\lbrace\mathbf{b}_1,\dots,\mathbf{b}_k\rbrace
\quad\to\quad
Q=\lbrace\mathbf{q}_1,\dots,\mathbf{q}_k\rbrace
$$

$Q$의 벡터들은 정규 직교 기저이기 때문에, 다음이 성립한다.

$$
\mathbf{q}_i^\top\mathbf{q}_j=
\begin{cases}
1&i=j\\0&i\not=j
\end{cases}
$$

그람 슈미트 과정은 쉽게 말해, 다음의 과정을 반복하는 것이다.

- 원래 벡터에서 이전에 만든 직교 벡터들의 방향 성분을 빼서, 새로운 직교 벡터를 만든다.

    $$
    \mathbf{u}_k=\mathbf{b}_k-\sum_{i=1}^{k-1}\text{proj}_{\mathbf{q}_i}(\mathbf{b}_k)
    \tag{1}
    $$
- 만들어진 직교 벡터를 정규화하여 길이가 $1$인 벡터로 만든다.

    $$
    \mathbf{q}_k=\frac{\mathbf{u}_k}{\lVert\mathbf{u}_k\rVert}
    \tag{2}
    $$

![fig1](Mathematics/Linear_Algebra/Gram_Schmidt-1.png){: style="display:block; margin:0 auto; width:100%;"}

예를 들어, 3차원 공간에서 기저 $B=\lbrace\mathbf{b}_1,\mathbf{b}_2,\mathbf{b}_3\rbrace$에 대한 그람 슈미트 과정은 아래와 같다.

1. **첫 번째 정규 직교 기저 구하기**

    먼저 기저 벡터에서 하나의 기준 벡터를 정한 후, 해당 벡터를 정규화한다.

    $$
    \mathbf{u}_1=\mathbf{b}_1
    $$

    $$
    \mathbf{q}_1=\frac{\mathbf{b}_1}{\lVert\mathbf{b}_1\rVert}
    $$

2. **두 번째 정규 직교 기저 구하기**

    두 번째 기저 벡터 $\mathbf{b}_2$에서 $\mathbf{q}_1$ 방향의 성분을 제거한다.

    $$
    \mathbf{u}_2=\mathbf{b}_2-\text{proj}_{\mathbf{q}_1}(\mathbf{b}_2)
    $$

    $\mathbf{q}_1$ 방향의 성분은 $\mathbf{b}_2$를 $\mathbf{q}_1$ 벡터로 정사영함으로써 구할 수 있다.

    $$
    \text{proj}_{\mathbf{q}_1}(\mathbf{b}_2)=(\mathbf{b}_2^\top\mathbf{q}_1)\mathbf{q}_1
    $$

    이렇게 만든 $\mathbf{u}_2$는 $\mathbf{q}_1$과 직교한다.

    이후 정규화하여 길이를 $1$로 만든다.

    $$
    \mathbf{q}_2=\frac{\mathbf{u}_2}{\lVert\mathbf{u}_2\rVert}
    $$

3. **세 번째 정규 직교 기저 구하기**

    세 번째 기저 벡터 $\mathbf{b}_3$에서 $\mathbf{q}_1$과 $\mathbf{q}_2$ 방향의 성분을 제거한다.

    $$
    \mathbf{u}_3=\mathbf{b}_3-\text{proj}_{\mathbf{q}_1}(\mathbf{b}_3)-\text{proj}_{\mathbf{q}_2}(\mathbf{b}_3)
    $$

    이렇게 만든 $\mathbf{u}_3$는 $\mathbf{q}_1,\mathbf{q}_2$와 모두 직교한다.

    이후 정규화하여 길이를 $1$로 만든다.

    $$
    \mathbf{q}_3=\frac{\mathbf{u}_3}{\lVert\mathbf{u}_3\rVert}
    $$

    아래의 왼쪽 그림에서 $\mathbf{a}$들은 서로 직교하지 않았지만, 오른쪽 그림에서 $\mathbf{b}$들은 서로 직교한다. 

![fig2](Mathematics/Linear_Algebra/Gram_Schmidt-2.png){: style="display:block; margin:0 auto; width:70%;"}
_[[출처]](https://interactivetextbooks.tudelft.nl/linear-algebra/Chapter7/GramSchmidt.html)_

<details>
<summary><font color='#FF0000'><strong>Example:</strong> Gram-Schmidt 과정으로 기저를 직교화</font></summary>
<div markdown="1">

> $$B=\begin{bmatrix}1&1&2\\1&3&0\\0&2&1\end{bmatrix}$$
>
> 1. **첫 번째 정규 직교 기저 구하기**
>
>   $$\mathbf{u}_1=\mathbf{b}_1=\begin{bmatrix}1\\1\\0\end{bmatrix}$$
>
>   $$\mathbf{q}_1=\frac{\mathbf{u}_1}{\lVert\mathbf{u}_1\rVert}=\frac{1}{\sqrt2}\begin{bmatrix}1\\1\\0\end{bmatrix}$$
>
> 2. **두 번째 정규 직교 기저 구하기**
>
>   $$\mathbf{u}_2=\mathbf{b}_2-(\mathbf{b}_2^\top\mathbf{q}_1)\mathbf{q}_1=\begin{bmatrix}1\\3\\2\end{bmatrix}-2\sqrt{2}\begin{bmatrix}\frac{1}{\sqrt2}\\\frac{1}{\sqrt2}\\0\end{bmatrix}=\begin{bmatrix}-1\\1\\2\end{bmatrix}$$
>
>   $$\mathbf{q}_2=\frac{\mathbf{u}_2}{\lVert\mathbf{u}_2\rVert}=\frac{1}{\sqrt6}\begin{bmatrix}-1\\1\\2\end{bmatrix}$$
>
> 3. **세 번째 정규 직교 기저 구하기**
> 
>   $$\mathbf{u}_3=\mathbf{b}_3-(\mathbf{b}_3^\top\mathbf{q}_1)\mathbf{q}_1-(\mathbf{b}_3^\top\mathbf{q}_2)\mathbf{q}_2=\begin{bmatrix}2\\0\\1\end{bmatrix}-\sqrt{2}\begin{bmatrix}\frac{1}{\sqrt2}\\\frac{1}{\sqrt2}\\0\end{bmatrix}-0\begin{bmatrix}-\frac{1}{\sqrt6}\\\frac{1}{\sqrt6}\\\frac{2}{\sqrt6}\end{bmatrix}=\begin{bmatrix}1\\-1\\1\end{bmatrix}$$
>
>   $$\mathbf{q}_3=\frac{\mathbf{u}_3}{\lVert\mathbf{u}_3\rVert}=\frac{1}{\sqrt3}\begin{bmatrix}1\\-1\\1\end{bmatrix}$$
>
> 최종적으로 얻은 정규 직교 기저는 아래와 같다.
>
> $$Q=\begin{bmatrix}\frac{1}{\sqrt2}&-\frac{1}{\sqrt6}&\frac{1}{\sqrt3}\\\frac{1}{\sqrt2}&\frac{1}{\sqrt6}&-\frac{1}{\sqrt3}\\0&\frac{2}{\sqrt6}&\frac{1}{\sqrt3}\end{bmatrix}$$

</div>
</details>