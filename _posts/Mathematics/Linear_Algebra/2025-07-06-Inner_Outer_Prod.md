---
title: "[선형대수] 내적과 외적"
date: 2025-07-06 00:00:00 +/-TTTT
categories: [Mathematics, 선형대수]
tags: [선형대수]
math: true
toc: true
author: sunho
---

## 내적 (Inner Product)

벡터 공간 내의 <span style="background-color:#fff5b1">임의의 두 벡터를 스칼라로 매핑시키는 함수</span>를 **내적**이라고 한다.
<br>
내적의 결과값을 통해 우리는 두 벡터의 방향 유사도나 직교성을 해석할 수 있다.

$$
\langle\cdot,\cdot\rangle:V\times V\to\mathbb{R}
\tag{1}
$$

내적이 정의된 벡터 공간 $(V,\langle\cdot,\cdot\rangle)$를 **Inner Product space**라고 한다.

Inner Product space에서는 Norm과 Distance가 아래와 같이 정의된다.

$$
\lVert\mathbf{x}\rVert=\sqrt{\langle\mathbf{x},\mathbf{x}\rangle}
\tag{2}
$$

$$
d(\mathbf{x},\mathbf{y}):=\lVert\mathbf{x}-\mathbf{y}\rVert=\sqrt{\langle\mathbf{x}-\mathbf{y},\mathbf{x}-\mathbf{y}\rangle}
\tag{3}
$$

### Inner Product의 조건

1. 분배 법칙이 성립

   $\langle\mathbf u+\mathbf w,\mathbf v\rangle=\langle\mathbf u,\mathbf v\rangle+\langle\mathbf w,\mathbf v\rangle$

   $\langle\lambda\mathbf v,\mathbf w\rangle=\lambda\langle\mathbf v,\mathbf w\rangle$
   
3. 교환 법칙이 성립

   $\langle\mathbf v,\mathbf w\rangle=\langle\mathbf w,\mathbf v\rangle$
   
4. 자기 자신과의 내적은 항상 0 이상

   $\langle\mathbf v,\mathbf v\rangle\geq0$

   $\langle\mathbf v,\mathbf v\rangle=0\iff\mathbf v=\mathbf0$

### 두 벡터가 이루는 각도

Inner Product space에서 두 벡터가 이루는 각도는 아래와 같이 정의된다.

$$
\theta=\cos^{-1}\big(\frac{\langle\mathbf{x},\mathbf{y}\rangle}{\lVert\mathbf{x}\rVert\cdot\lVert\mathbf{y}\rVert}\big)
\tag{4}
$$

## Inner Product의 종류

내적은 다양한 형태로 정의된다.

### Dot Product (Scalar Product)

실수 벡터 공간 $\mathbb{R}^n$에서 아래와 같이 정의되는 내적을 **Dot Product** (또는 **Scalar Product**)라고 부른다.

$$
\langle\mathbf{x},\mathbf y\rangle:=\mathbf x^\top \mathbf y
\tag{5}
$$

이는 두 벡터가 서로 얼마나 같은 방향의 성분을 공유하는지, 즉 두 벡터가 얼마나 유사한지를 나타낸다.
<br>
값이 클수록 두 벡터가 비슷한 방향을 향하고, 값이 0이면 두 벡터는 서로 직교한다.

일반적으로 $\mathbb{R}^n$에서 Dot Product를 내적이라고 부르는 경우가 많지만, 엄밀히 말하면 Dot Product는 내적의 한 종류이다.

### 함수의 내적

내적은 벡터뿐만 아니라 함수 공간에서도 정의할 수 있다.

예를 들어, 구간 $[a,b]$에서 정의된 두 함수 $f, g$에 대해 다음과 같이 내적을 정의할 수 있다.

$$
\langle f,g\rangle:=\int_a^b f(x)g(x)\,dx
\tag{6}
$$

이 내적은 두 함수가 구간 $[a,b]$에서 얼마나 비슷한 형태를 가지는지 측정한다.

## 외적 (Outer Product)

두 벡터의 곱으로 행렬을 생성하는 연산을 **외적**이라고 한다.

$$
\mathbf{x}\otimes\mathbf{y}:=\mathbf{x}\mathbf{y}^\top
\tag{7}
$$

$\mathbf{0}$을 제외했을 때, 외적으로 생성된 행렬의 Rank는 항상 1이다.

## 벡터곱 (Cross Product)

**벡터곱**은 3차원 벡터에 대해서만 정의되는 연산으로, 두 3차원 벡터에 수직인 벡터를 생성하는 연산이다.

$$
\mathbf{x}\times\mathbf{y}:=\begin{vmatrix}\mathbf{i}&\mathbf{j}&\mathbf{k}\\x_1&x_2&x_3\\y_1&y_2&y_3\end{vmatrix}=(x_2y_3-x_3y_2)\mathbf{i}-(x_1y_3-x_3y_1)\mathbf{j}+(x_1y_2-x_2y_1)\mathbf{k}
\tag{8}
$$

외적 연산으로 생성된 벡터의 방향은 오른손 법칙으로 결정되고, 크기는 두 벡터가 만드는 평행사변형의 넓이와 같다.

![fig1](Mathematics/Linear_Algebra/Inner_Product-1.png){: style="display:block; margin:0 auto; width:60%;"}
_[[그림 출처]](https://www.khanacademy.org/math/multivariable-calculus/thinking-about-multivariable-function/x786f2022:vectors-and-matrices/a/cross-products-mvc)_
