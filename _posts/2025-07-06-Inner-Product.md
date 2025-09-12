---
title: "[선형대수] 내적과 각도"
date: 2025-07-06 00:00:00 +/-TTTT
categories: [인공지능 수학]
tags: [선형대수]
math: true
toc: true
author: sunho
img_path: /assets/images/math/
description: 👨‍👧‍👧 벡터의 기본 개념
---

## Inner Product

$$
\langle\cdot,\cdot\rangle:V\times V\to\mathbb{R}
$$

벡터 공간 내의 임의의 두 벡터를 스칼라로 매핑시키는 함수를 inner product라고 한다.

Inner product가 정의된 vector space $(V,\langle\cdot,\cdot\rangle)$를 **inner product space**라고 한다.

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

Inner product는 다양한 형태로 정의된다.

- $\langle\mathbf{x},\mathbf y\rangle:=\mathbf x^\top \mathbf y$ → 이런 형태로 정의되는 내적을 **Dot Product**라고 부른다.
- $\langle\mathbf x,\mathbf y\rangle:=x_1y_1-(x_1y_2+x_2y_1)+2x_2y_2$
- $\langle f,g\rangle:=\int_a^b f(x)g(x)\,dx$ → 함수의 내적

### Symmetric, Positive Definite

대칭 행렬 $A$에 대해 $\mathbf{x}^\top A\mathbf{x}$가 $\mathbf{0}$이 아닌 모든 $\mathbf{x}$에 대해 양수일 때, $A$를 symmetric, positive definite matrix라고 부른다.

$$
\langle\mathbf{x},\mathbf y\rangle:=\mathbf{x}^\top A\mathbf{y}
$$

행렬 $A$가 symmetric, positive definite matrix라면, 내적을 위와 같이 정의할 수 있다.

<details>
<summary><font color='red'>Example</font></summary>
<div markdown="1">
  

---

<br>
$\mathbf{x}\not=\mathbf{0}$일 때 항상 양수이므로, $A$는 symmetric, positive definite matrix이다.

</div>
</details>

## Outer Product

$$
\mathbf{x}\otimes\mathbf{y}:=\mathbf{x}\mathbf{y}^\top
$$

두 벡터의 곱으로 행렬을 생성하는 연산을 outper product라고 한다.

## Cross Product

$$
\mathbf{x}\times\mathbf{y}:=\begin{vmatrix}\mathbf{i}&\mathbf{j}&\mathbf{k}\\x_1&x_2&x_3\\y_1&y_2&y_3\end{vmatrix}=(x_2y_3-x_3y_2)\mathbf{i}-(x_1y_3-x_3y_1)\mathbf{j}+(x_1y_2-x_2y_1)\mathbf{k}
$$

두 3차원 벡터에 수직인 벡터를 생성하는 연산을 cross product라고 한다.

## Angle

$$
\theta=\cos^{-1}\big(\frac{\langle\mathbf{x},\mathbf{y}\rangle}{\lVert\mathbf{x}\rVert\cdot\lVert\mathbf{y}\rVert}\big)
$$

Inner product space에서 두 벡터의 각도는 위와 같이 정의된다.

## Orthogonality

두 벡터 $\mathbf{x}$, $\mathbf{y}$의 내적이 0이라면, 두 벡터는 **orthogonal**하다고 한다.

직교하고 있는 두 벡터의 크기가 1이라면, **orthonormal**하다고 한다.

Square matrix $A$의 column vector들이 orthonormal하면, $A$를 **orthogonal matrix**라고 한다.

- $A$, $B$가 orthogonal matrix라면, $AB$도 orthogonal matrix다.
- $A$가 orthogonal matrix라면, $\text{det}(A)=\pm1$이다.

## Orthonormal Basis

Basis $B=\lbrace\mathbf{b}_1,\dots,\mathbf{b}_n\rbrace$를 orthonormal basis로 변환하는 방법에는 크게 2가지가 있다.

**1. $[BB^\top\vert B]$에 대해 Gauss Elimination 수행**

<details>
<summary><font color='red'>Example</font></summary>
<div markdown="1">



---



가우스 소거법을 적용해서 아래와 같은 orthonormal basis를 얻을 수 있다.

</div>
</details>
<br>
**2. Gram-Schmidt method 적용**

  <details>
  <summary><font color='red'>Example</font></summary>
  <div markdown="1">
  

  
  ---
  1. $\mathbf{b}_2$를 $\mathbf{b}_1$ 방향과 $\mathbf{b}_1$에 수직한 벡터의 합으로 분리

  3. $\mathbf{b}_1$에 수직한 벡터를 구함

  5. 크기를 1로 조절해 orthonormal basis로 변환

  
  </div>
  </details>
