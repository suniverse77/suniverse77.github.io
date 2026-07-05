---
title: "[선형대수] Norm & Distance"
date: 2025-07-05 00:00:00 +/-TTTT
categories: [Mathematics, 선형대수]
tags: [선형대수]
math: true
toc: true
author: sunho
---

## Norm

Norm은 벡터의 길이로 정의되며, 벡터를 스칼라로 mapping하는 일종의 함수로 볼 수 있다.

$$
\lVert\cdot\rVert:V→\Bbb R
\tag{1}
$$

Lp Norm은 아래와 같이 정의되며, 주로 사용하는 Norm은 L1 Norm과 L2 Norm이다.

$$
\lVert\mathbf{v}\rVert_p:=\left(\sum_{i=1}^{n}{\vert v_i\vert}^p\right)^{\frac{1}{p}}
\tag{2}
$$

### L1 Norm (Manhattan Norm)

L1 Norm은 벡터 원소 절댓값의 합으로 정의된다.

$$
\lVert\mathbf{v}\rVert_1:=\sum_{i=1}^{n}{\vert v_i\vert}
=\vert v_1\vert+\cdots+\vert v_n\vert
\tag{3}
$$

2차원 공간에서 단위 벡터 $\mathbf{x}$의 L1 norm은 $\vert x_1\vert+\vert x_2\vert=1$이며, L1 norm이 1인 벡터들의 궤적은 정사각형 형태로 나타난다.

### L2 Norm (Euclidean Norm)

L2 Norm은 벡터 원소 제곱합의 제곱근으로 정의된다.

$$
\lVert\mathbf{x}\rVert_2:=\sqrt{\sum_{i=1}^{n}{v_i^2}}
=\sqrt{v_1^2+\cdots+v_n^2}
\tag{4}
$$

2차원 공간에서 단위 벡터 $\mathbf{x}$의 L2 norm은 $x_1^2+x_2^2=1$이며, L2 norm이 1인 벡터들의 궤적은 원의 형태로 나타난다.

아래 그림은 $p$ 값에 따른 궤적의 변화를 나타낸다.

![fig1](Mathematics/Linear_Algebra/Norm_Distance-1.png){: style="display:block; margin:0 auto; width:80%;"}
_[[출처]](https://sooho-kim.tistory.com/85)_

### Norm의 조건

1. **Absolutely homogeneous**

   $\lVert\lambda\mathbf{x}\rVert=\lambda\lVert\mathbf{x}\rVert$

2. **Triangle inequality**

   $\lVert\mathbf{x}+\mathbf{y}\rVert\leq\lVert\mathbf{x}\rVert+\lVert\mathbf{y}\rVert$

3. **Positive definite**

   $\lVert\mathbf{x}\rVert\geq0$

   $\lVert\mathbf{x}\rVert=0\iff\mathbf{x}=\mathbf{0}$

## Distance

Distance는 말 그대로 벡터 공간 $V$에서 두 벡터 $\mathbf{x}$, $\mathbf{y}$ 사이의 거리를 의미하며, <span style="background-color:#fff5b1">벡터 차이의 Norm</span>으로 정의된다.

$$
d(\mathbf{x},\mathbf{y}):=\lVert\mathbf{x}-\mathbf{y}\rVert
\tag{5}
$$


LpNorm을 사용한 Lp Distance는 위와 같이 정의된다.

$$
d_p(\mathbf{x}, \mathbf{y}) := \lVert \mathbf{x} - \mathbf{y} \rVert_p
= \left( \sum_{i=1}^{n} |x_i - y_i|^p \right)^{\frac{1}{p}}
\tag{6}
$$

### L1 Distance (Manhattan Distance)

$$
d_1(\mathbf{x},\mathbf{y}):=\sum_i^n\lvert x_i-y_i\rvert
\tag{7}
$$

### L2 Distance (Euclidean Distance)

$$
d_2(\mathbf{x},\mathbf{y}):=\sqrt{\sum_{i=1}^{n}{(x_i-y_i)^2}}
\tag{8}
$$

### Distance의 조건

1. **Symmetric**

   $d(\mathbf{x},\mathbf{y})=d(\mathbf{y},\mathbf{x})$

2. **Triangle inequality**

   $d(\mathbf{x},\mathbf{z})\leq d(\mathbf{x},\mathbf{y})+d(\mathbf{y},\mathbf{z})$

3. **Positive definite**

   $d(\mathbf{x},\mathbf{y})\geq0$

   $d(\mathbf{x},\mathbf{y})=0\iff \mathbf{x}=\mathbf{y}$
