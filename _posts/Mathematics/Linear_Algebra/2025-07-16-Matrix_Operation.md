---
title: "[선형대수] 행렬의 기본 연산"
date: 2025-07-16 00:00:00 +/-TTTT
categories: [Mathematics, 선형대수]
tags: [선형대수]
math: true
toc: true
author: sunho
---

## 행렬 덧셈

두 행렬 $A$, $B$의 덧셈은 다음과 같다.

$$
A+B=C
\tag{1}
$$

행렬의 덧셈은 같은 위치의 성분끼리 더하면 된다.

$$
\begin{bmatrix}1&2\\3&4\end{bmatrix}+
\begin{bmatrix}5&6\\7&8\end{bmatrix}=
\begin{bmatrix}6&8\\10&12\end{bmatrix}
$$

이때, 더하는 두 행렬의 크기는 반드시 동일해야 한다.
<br>
즉, $A\in\mathbb{R}^{m\times n}$와 $B\in\mathbb{R}^{m\times n}$를 더해 얻은 행렬의 크기도 $C\in\mathbb{R}^{m\times n}$가 된다.

## 행렬곱 (Matrix Multiplication)

두 행렬 $A$, $B$의 곱은 다음과 같다.

$$
AB=C
\tag{2}
$$

행렬곱이 정의되기 위해서는 반드시 앞 행렬의 열 개수와 뒤 행렬의 행 개수가 같아야 한다.
<br>
즉, $A\in\mathbb{R}^{m\times n}$와 $B\in\mathbb{R}^{n\times k}$를 곱해 얻은 행렬의 크기는 $C\in\mathbb{R}^{m\times k}$가 된다.

행렬곱은 여러 관점에서 해석할 수 있다.
<br>
여기서는 행렬곱 $C=AB$를 이해하는 대표적인 3가지 관점을 살펴볼 것이다.

### 1. 내적 관점

행렬곱의 가장 기본적인 계산 방식은 행벡터와 열벡터의 내적이다.

$C$의 $(i,j)$번째 원소 $c_{ij}$는 $A$의 $i$번째 행벡터와 $B$의 $j$번째 열벡터의 내적으로 계산된다.

$$
c_{ij}=\mathbf{a}_{i}\cdot\mathbf{b}_{j}=\sum_{k=1}^na_{ik}b_{kj}
\tag{3}
$$

<details>
<summary><font color='#FF0000'>Example 1</font></summary>
<div markdown="1">

> $$A=\begin{bmatrix}2&3&1\\4&2&0\end{bmatrix}~,~B=\begin{bmatrix}3&2\\1&0\\4&3\end{bmatrix}$$
>
> - $c_{11}=\mathbf{a}_1\cdot\mathbf{b}_1~\rightarrow~13=2\cdot3+3\cdot1+1\cdot4$
> - $c_{12}=\mathbf{a}_1\cdot\mathbf{b}_2~\rightarrow~10=2\cdot2+3\cdot0+1\cdot6$
> - $c_{21}=\mathbf{a}_2\cdot\mathbf{b}_1~\rightarrow~14=4\cdot3+2\cdot1+0\cdot4$
> - $c_{22}=\mathbf{a}_2\cdot\mathbf{b}_2~\rightarrow~8=4\cdot2+2\cdot0+0\cdot6$
>
> $$C=\begin{bmatrix}13&10\\14&8\end{bmatrix}$$

</div>
</details>
<br>

### 2. 앞 행렬의 열벡터들의 선형 결합 관점

행렬곱을 $A$의 열벡터들의 선형결합으로 바라볼 수 있다.

그러면 $C$의 $j$번째 열벡터 $\mathbf{c}_j$는 $A$의 열벡터들을 선형 결합하여 계산된다.

$$
\mathbf{c}_j=A\mathbf{b}_j=\sum_{k=1}^nb_{kj}\mathbf{a}_k
\tag{4}
$$

- $\mathbf{a}_k$: $A$의 $k$번째 열벡터
- $b_{kj}$: $B$의 $j$번째 열벡터 $\mathbf{b}_j$​의 $k$번째 성분

<details>
<summary><font color='#FF0000'>Example 2</font></summary>
<div markdown="1">

> $$A=\begin{bmatrix}2&3&1\\4&2&0\end{bmatrix}~,~B=\begin{bmatrix}3&2\\1&0\\4&3\end{bmatrix}$$
>
> $A$와 $C$를 열벡터로 표현
>
> $$A=\begin{bmatrix}|&|&|\\\mathbf{a}_1&\mathbf{a}_2&\mathbf{a}_3\\|&|&|\end{bmatrix}~,~C=\begin{bmatrix}|&|\\\mathbf{c}_1&\mathbf{c}_2\\|&|\end{bmatrix}$$
>
> 1. $C$의 첫 번째 열 벡터
>
> $$\mathbf{c}_1=3\cdot \mathbf{a}_1+1\cdot \mathbf{a}_2+4\cdot \mathbf{a}_3=\begin{bmatrix}13\\14\end{bmatrix}$$
>
> 2. $C$의 두 번째 열 벡터
>
> $$\mathbf{c}_2=2\cdot \mathbf{a}_1+0\cdot \mathbf{a}_2+3\cdot \mathbf{a}_3=\begin{bmatrix}10\\8\end{bmatrix}$$

</div>
</details>
<br>

### 3. 뒤 행렬 행벡터들의 선형 결합

행렬곱을 $B$의 행벡터들의 선형결합으로 바라볼 수 있다.

그러면 $C$의 $i$번째 행벡터 $\mathbf{c}_i$는 $B$의 행벡터들을 선형 결합하여 계산된다.

$$
\mathbf{c}_i=\mathbf{a}_iB=\sum_{k=1}^na_{ik}\mathbf{b}_k
\tag{5}
$$

- $a_{ik}$: $A$의 $i$번째 행벡터의 $k$번째 성분
- $\mathbf{b}_k$: $B$의 $k$번째 행벡터

<details>
<summary><font color='#FF0000'>Example 3</font></summary>
<div markdown="1">

> $$A=\begin{bmatrix}2&3&1\\4&2&0\end{bmatrix}~,~B=\begin{bmatrix}3&2\\1&0\\4&3\end{bmatrix}$$
>
> $B$와 $C$를 행 벡터로 표현
> 
> $$B=\begin{bmatrix}-\mathbf{b}_1-\\-\mathbf{b}_2-\\-\mathbf{b}_3-\end{bmatrix}~,~C=\begin{bmatrix}-\mathbf{c}_1-\\-\mathbf{c}_2-\end{bmatrix}$$
>
> 1. $C$의 첫 번째 행 벡터
>
> $$\mathbf{c}_1=\begin{bmatrix}13&10\end{bmatrix}=2\cdot \mathbf{b}_1+3\cdot \mathbf{b}_2+1\cdot \mathbf{b}_3$$
>
> 2. $C$의 두 번째 행 벡터
>
> $$\mathbf{c}_2=\begin{bmatrix}14&8\end{bmatrix}=4\cdot \mathbf{b}_1+2\cdot \mathbf{b}_2+0\cdot \mathbf{b}_3$$

</div>
</details>


## 전치 (Transpose)

행렬의 열과 행을 바꾸는 연산을 의미한다.

### 전치의 성질

- $(A^\top)^\top=A$
- $(A+B)^\top=A^\top+B^\top$
- $(AB)^\top=B^\top A^\top$
- $(A^\top)^{-1}=(A^{-1})^\top=A^{-\top}$