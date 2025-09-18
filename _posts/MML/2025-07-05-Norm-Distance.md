---
title: "[선형대수] 노름(Norm)과 거리"
date: 2025-07-05 00:00:00 +/-TTTT
categories: [인공지능 수학]
tags: [선형대수]
math: true
toc: true
author: sunho
img_path: /assets/images/math/
description: ✏️ 벡터의 크기 / 두 벡터 사이의 거리
---

## 노름 (Norm)

$$
\lVert\cdot\rVert:V→\Bbb R
$$

벡터의 길이를 norm이라고 하며, 벡터를 스칼라로 mapping하는 일종의 함수로 볼 수 있다.

$$
\lVert\mathbf{v}\rVert_p:=\left(\sum_{i=1}^{n}{\vert v_i\vert}^p\right)^{\frac{1}{p}}
$$

Lp norm은 위와 같이 정의되며, 주로 사용하는 norm은 L1 norm과 L2 norm이다.

### L1 norm (Manhattan Norm)

$$
\lVert\mathbf{v}\rVert_1:=\sum_{i=1}^{n}{\vert v_i\vert}
=\vert v_1\vert+\cdots+\vert v_n\vert
$$

2차원 공간에서 단위 벡터 $\mathbf{x}$의 L1 norm은 $\vert x_1\vert+\vert x_2\vert=1$이며, L1 norm이 1인 벡터들의 궤적은 정사각형 형태로 나타난다.

### L2 norm (Euclidean Norm)

$$
\lVert\mathbf{x}\rVert_2:=\sqrt{\sum_{i=1}^{n}{v_i^2}}
=\sqrt{v_1^2+\cdots+v_n^2}
$$

2차원 공간에서 단위 벡터 $\mathbf{x}$의 L2 norm은 $x_1^2+x_2^2=1$이며, L2 norm이 1인 벡터들의 궤적은 원의 형태로 나타난다.

### Norm의 조건

1. Absolutely homogeneous

   $\lVert\lambda\mathbf{x}\rVert=\lambda\lVert\mathbf{x}\rVert$

2. Triangle inequality

   $\lVert\mathbf{x}+\mathbf{y}\rVert\leq\lVert\mathbf{x}\rVert+\lVert\mathbf{y}\rVert$

3. Positive definite

   $\lVert\mathbf{x}\rVert\geq0$

   $\lVert\mathbf{x}\rVert=0\iff\mathbf{x}=\mathbf{0}$

## 거리 (Distance)

$$
d(\mathbf{x},\mathbf{y}):=\lVert\mathbf{x}-\mathbf{y}\rVert
$$

벡터 공간 $V$에서 두 벡터 $\mathbf{x}$, $\mathbf{y}$ 사이의 거리는 벡터 차이의 norm으로 정의된다.

$$
d_p(\mathbf{x}, \mathbf{y}) := \lVert \mathbf{x} - \mathbf{y} \rVert_p
= \left( \sum_{i=1}^{n} |x_i - y_i|^p \right)^{\frac{1}{p}}
$$

Lp norm을 사용한 Lp distance는 위와 같이 정의된다.

### L1 distance (Manhattan Distance)

$$
d_1(\mathbf{x},\mathbf{y}):=\sum_i^n\lvert x_i-y_i\rvert
$$

### L2 distance (Euclidean Distance)

$$
d_2(\mathbf{x},\mathbf{y}):=\sqrt{\sum_{i=1}^{n}{(x_i-y_i)^2}}
$$

### Distance의 조건

1. Symmetric

   $d(\mathbf{x},\mathbf{y})=d(\mathbf{y},\mathbf{x})$

2. Triangle inequality

   $d(\mathbf{x},\mathbf{z})\leq d(\mathbf{x},\mathbf{y})+d(\mathbf{y},\mathbf{z})$

3. Positive definite

   $d(\mathbf{x},\mathbf{y})\geq0$

   $d(\mathbf{x},\mathbf{y})=0\iff \mathbf{x}=\mathbf{y}$
