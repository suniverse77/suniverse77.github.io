---
title: "[선형대수] 행렬식과 역행렬"
date: 2025-07-10 00:00:00 +/-TTTT
categories: [인공지능 수학]
tags: [선형대수]
math: true
toc: true
author: sunho
img_path: /assets/images/math/
description: 👨‍👧‍👧 벡터의 기본 개념
---

## Determinant



Square matrix에 대해 정의되며, 행렬이 나타내는 선형 변환의 부피 변화율 또는 가역성을 나타내는 스칼라 값이다.

$\text{det}(A)=0$이면 선형 변환에 의해 공간의 부피가 0이 된다는 뜻이므로 정보를 완전히 복원할 수 없기 때문에 역행렬이 존재하지 않는다.

$$
A=\begin{bmatrix}a&b\\c&d\end{bmatrix}~\to~\vert A\vert=ad-bc
$$

$2\times2$ 행렬에 대해 determinant는 위와 같이 정의된다.

### Properties of Determinant

1. $\text{det}(AB)=\text{det}(A)\text{det}(B)$
2. $\text{det}(A)=\text{det}(A^\top)$
3. $A$ is invertible $\implies\text{det}(A^{-1})=\frac{1}{\text{det}(A)}$
4. $\text{det}(A)=\text{det}(S^{-1}AS)$
5. $T$ is triangular matrix $\implies\text{det}(T)=\prod_i t_{ii}$
6. 하나의 column(row)에 어떤 숫자를 곱해서 다른 column(row)에 더해도 determinant는 동일
8. 하나의 column(row)에 상수 $\lambda$를 곱하면 $\text{det}(\lambda A)=\lambda^n\text{det}(A)$
9. 두 column(row)를 바꾸는 것은 determinant의 부호를 바꿈

(5), (6), (7), (8)번의 성질을 이용해 행렬을 triangular matrix로 변환하면 determinant를 쉽게 구할 수 있다.

<details>
<summary><font color='red'>Example</font></summary>
<div markdown="1">
  
> $$
> A=\begin{bmatrix}1&2\\3&4\end{bmatrix}
> $$
>
> ---
> 1. Gauss Elimination 수행 → (6)번에 의해 determinant 변화 X
>
>    $$
>    A=\begin{bmatrix}1&2\\0&-2\end{bmatrix}
>    $$
> 2. (5)번 성질 사용
>
>    $\text{det}(A)=-2$

</div>
</details>

## Trace

$$
\displaystyle\text{tr}(A)=\sum_{i=1}^na_{ii}
$$

Square matrix에 대해 정의되며, 대각 성분을 모두 더한 스칼라 값이다.

### Properties of Trace

1. $\text{tr}(A+B)=\text{tr}(A)+\text{tr}(B)$
2. $\text{tr}(\lambda A)=\lambda\text{tr}(A)$
3. $\text{tr}(I_n)=n$
4. $A\in\mathbb{R}^{\color{red}n\times \color{blue}k},B\in\mathbb{R}^{\color{blue}k\times \color{red}n}\implies\text{tr}(AB)=\text{tr}(BA)$
5. $A\in\mathbb{R}^{\color{red}a\times \color{blue}k},B\in\mathbb{R}^{\color{blue}k\times \color{green}l},C\in\mathbb{R}^{\color{green}l\times \color{red}n}\implies\text{tr}(ABC)=\text{tr}(CAB)=\text{tr}(BCA)$
6. $\text{tr}(\mathbf{x}^\top\mathbf{y})=\mathbf{x}^\top\mathbf{y}\in\mathbb{R}$
7. $\text{tr}(A)=\text{tr}(S^{-1}AS)$
8. $\text{det}(I+\Delta)=1+\text{tr}(\Delta)$
