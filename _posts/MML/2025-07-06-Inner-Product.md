---
title: "[선형대수] 내적과 각도"
date: 2025-07-06 00:00:00 +/-TTTT
categories: [인공지능 수학, 선형대수]
tags: [선형대수]
math: true
toc: true
author: sunho
---

## 내적 (Inner Product)

$$
\langle\cdot,\cdot\rangle:V\times V\to\mathbb{R}
$$

벡터 공간 내의 임의의 두 벡터를 스칼라로 매핑시키는 함수를 내적이라고 한다.

내적이 정의된 벡터 공간 $(V,\langle\cdot,\cdot\rangle)$를 **inner product space**라고 한다.

Inner product space에서는 norm과 distance가 아래와 같이 정의된다.

$$
\lVert\mathbf{x}\rVert=\sqrt{\langle\mathbf{x},\mathbf{x}\rangle}
$$

$$
d(\mathbf{x},\mathbf{y}):=\lVert\mathbf{x}-\mathbf{y}\rVert=\sqrt{\langle\mathbf{x}-\mathbf{y},\mathbf{x}-\mathbf{y}\rangle}
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

### Inner Product의 종류

내적은 다양한 형태로 정의된다.

- $\langle\mathbf{x},\mathbf y\rangle:=\mathbf x^\top \mathbf y$ → 이런 형태로 정의되는 내적을 <span style="background-color:#fff5b1">점곱 (dot product) 또는 스칼라곱 (scalar product)</span>라고 부른다.
- $\langle\mathbf x,\mathbf y\rangle:=x_1y_1-(x_1y_2+x_2y_1)+2x_2y_2$
- $\langle f,g\rangle:=\int_a^b f(x)g(x)\,dx$ → 함수의 내적

즉, 우리가 흔히 사용하는 **dot product**는 유클리드 공간 $\mathbb{R}^n$에서 사용되는 내적의 한 종류이다.

일반적으로 $\mathbb{R}^n$에서 dot product를 내적이라고 혼용해서 내적이라고 부르지만, '내적 = dot product'라고 정의하는 것은 틀리다.

### Dot Product

두 벡터의 내적은 두 벡터가 서로 얼마나 같은 방향 성분을 공유하는지, 두 벡터가 얼마나 유사한지를 나타내는 값이다.

## 두 벡터가 이루는 각도 (Angle)

$$
\theta=\cos^{-1}\big(\frac{\langle\mathbf{x},\mathbf{y}\rangle}{\lVert\mathbf{x}\rVert\cdot\lVert\mathbf{y}\rVert}\big)
$$

Inner product space에서 두 벡터가 이루는 각도는 위와 같이 정의된다.

## 외적 (Outer Product)

$$
\mathbf{x}\otimes\mathbf{y}:=\mathbf{x}\mathbf{y}^\top
$$

두 벡터의 곱으로 행렬을 생성하는 연산을 외적이라고 한다.

## 벡터곱 (Cross Product)

$$
\mathbf{x}\times\mathbf{y}:=\begin{vmatrix}\mathbf{i}&\mathbf{j}&\mathbf{k}\\x_1&x_2&x_3\\y_1&y_2&y_3\end{vmatrix}=(x_2y_3-x_3y_2)\mathbf{i}-(x_1y_3-x_3y_1)\mathbf{j}+(x_1y_2-x_2y_1)\mathbf{k}
$$

벡터곱은 3차원 벡터에 대해서만 정의되는 연산으로, 두 3차원 벡터에 수직인 벡터를 생성하는 연산이다.

외적 연산으로 생성된 벡터의 방향은 오른손 법칙으로 결정되고, 크기는 두 벡터가 만드는 평행사변형의 넓이와 같다.
