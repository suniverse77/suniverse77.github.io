---
title: "Norm & Distance"
date: 2025-07-05
categories: [Mathematics, Linear Algebra, Vectors & Spaces]
math: true
toc: true
published: true
---

## Norm

**Norm**은 벡터의 길이로 정의되며, 벡터를 스칼라로 mapping하는 일종의 함수로 볼 수 있다.

$$
\lVert\cdot\rVert:V→\Bbb R
\tag{1}
$$

Lp Norm은 아래와 같이 정의되며, 주로 사용하는 Norm은 L1 Norm과 L2 Norm이다.

$$
\lVert\vv\rVert_p:=\left(\sum_{i=1}^{n}{\vert v_i\vert}^p\right)^{\frac{1}{p}}
\tag{2}
$$

### L1 Norm (Manhattan Norm)

**L1 Norm**은 벡터 원소 절댓값의 합으로 정의된다.

$$
\lVert\vv\rVert_1:=\sum_{i=1}^{n}{\vert v_i\vert}
=\vert v_1\vert+\cdots+\vert v_n\vert
\tag{3}
$$

2차원 공간에서 단위 벡터 $\vx$의 L1 norm은 $\vert x_1\vert+\vert x_2\vert=1$이며, L1 norm이 1인 벡터들의 궤적은 정사각형 형태로 나타난다.

### L2 Norm (Euclidean Norm)

**L2 Norm**은 벡터 원소 제곱합의 제곱근으로 정의된다.

$$
\lVert\vx\rVert_2:=\sqrt{\sum_{i=1}^{n}{v_i^2}}
=\sqrt{v_1^2+\cdots+v_n^2}
\tag{4}
$$

2차원 공간에서 단위 벡터 $\vx$의 L2 norm은 $x_1^2+x_2^2=1$이며, L2 norm이 1인 벡터들의 궤적은 원의 형태로 나타난다.

아래 그림은 $p$ 값에 따른 궤적의 변화를 나타낸다.

![fig1](Norm-Distance-1.png)
_[[출처]](https://sooho-kim.tistory.com/85)_

### Norm의 조건

1. **Absolutely homogeneous**

   $\lVert\lambda\vx\rVert=\lambda\lVert\vx\rVert$

2. **Triangle inequality**

   $\lVert\vx+\vy\rVert\leq\lVert\vx\rVert+\lVert\vy\rVert$

3. **Positive definite**

   $\lVert\vx\rVert\geq0$

   $\lVert\vx\rVert=0\iff\vx=\mathbf{0}$

## Distance

**Distance**는 말 그대로 벡터 공간 $V$에서 두 벡터 $\vx$, $\vy$ 사이의 거리를 의미하며, ==벡터 차이의 Norm==으로 정의된다.

$$
d(\vx,\vy):=\lVert\vx-\vy\rVert
\tag{5}
$$


LpNorm을 사용한 Lp Distance는 위와 같이 정의된다.

$$
d_p(\vx, \vy) := \lVert \vx - \vy \rVert_p
= \left( \sum_{i=1}^{n} |x_i - y_i|^p \right)^{\frac{1}{p}}
\tag{6}
$$

### L1 Distance (Manhattan Distance)

$$
d_1(\vx,\vy):=\sum_i^n\lvert x_i-y_i\rvert
\tag{7}
$$

### L2 Distance (Euclidean Distance)

$$
d_2(\vx,\vy):=\sqrt{\sum_{i=1}^{n}{(x_i-y_i)^2}}
\tag{8}
$$

### Distance의 조건

1. **Symmetric**

   $d(\vx,\vy)=d(\vy,\vx)$

2. **Triangle inequality**

   $d(\vx,\vz)\leq d(\vx,\vy)+d(\vy,\vz)$

3. **Positive definite**

   $d(\vx,\vy)\geq0$

   $d(\vx,\vy)=0\iff \vx=\vy$
