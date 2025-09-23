---
title: "[선형대수] 행렬식과 역행렬"
date: 2025-07-12 00:00:00 +/-TTTT
categories: [인공지능 수학, 선형대수]
tags: [선형대수]
math: true
toc: true
author: sunho
img_path: /assets/images/math/
description: ✏️ 행렬식의 기하학적 의미와 가역성
---

## 행렬식 (Determinant)

$$
A=\begin{bmatrix}a&b\\c&d\end{bmatrix}~\to~
\text{det}(A)=\lvert A\rvert=ad-bc
$$

정방 행렬에서만 정의되며, $2\times2$ 행렬에 대해 행렬식은 위와 같이 정의된다.

행렬식의 기하학적 의미는 아래와 같다.

1. 행렬을 열 벡터의 집합으로 본다면, 두 열 벡터가 이루는 영역의 너비를 의미한다.
2. 행렬을 변환으로 본다면, 변환에 의해 늘어나는 영역의 너비 변화율을 의미한다.

<details>
<summary><font color='#FF0000'>Example</font></summary>
<div markdown="1">

$$
A=\begin{bmatrix}3&0\\0&2\end{bmatrix}
$$

---

$(1,0)$과 $(0,1)$이 이루는 정사각형 영역의 너비는 1이다.

변환 후 각 벡터는 $(3,0)$와 $(0,2)$가 되고, 이 벡터들이 이루는 평행사변형 영역의 너비는 6이다.

너비 변화율은 6이고, 이는 $\text{det}(A)$와 일치한다.

$$
\text{det}(A)=6-0=6
$$

</div>
</details>
<br>

행렬식이 0이라는 것은 변환에 의해 공간 전체가 직선 또는 한점으로 찌그러진다는 것을 의미한다. 이 경우 다시 정보를 복원할 수 없기 때문에 역행렬이 존재하지 않는다.

이해하기 쉽게 생각해보면, 행렬식이 0이라는 것은 어떤 숫자에 0을 곱하는 것과 같다.
예를 들어, 숫자 3에 0을 곱하면 0이 된다. 이렇게 0이 되어 버린 결과만 가지고는 원래 숫자가 3이었는지 아니면 다른 어떤 숫자였는지 다시 알아낼 수가 없다.

행렬식이 음수라는 것은 공간의 방향의 뒤집힌 것을 의미한다.

$$
A=\begin{bmatrix}a&b&c\\d&e&f\\g&h&i\end{bmatrix}~\to~
\text{det}(A)=
a\begin{vmatrix}e&f\\h&i\end{vmatrix}
-b\begin{vmatrix}d&f\\g&i\end{vmatrix}
+c\begin{vmatrix}d&e\\g&h\end{vmatrix}
$$

$3\times3$ 행렬에 대해 determinant는 위와 같이 정의된다.

3차원에서는 평행육면체 (parallelepiped)의 부피 또는 변환 후 부피의 변화율을 의미한다.

### 행렬식의 성질

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


## 역행렬 (Inverse Matrix)

역행렬 $A^{-1}$은 어떤 행렬 $A$에 곱했을 때 단위 행렬 $I$를 만들어주는 행렬을 의미한다.

즉, $AA^{-1}=A^{-1}AI$가 성립하며, $3\times\frac{1}{3}=1$과 같은 개념이다.

행렬을 선형 변환 관점에서 보면, 역행렬은 원래 변환을 되돌리는 역할을 한다.

예를 들어, 어떤 행렬이 물체를 시계 방향으로 90도 회전시키는 역할을 한다면, 이 행렬의 역행렬은 물체를 반시계 방향으로 90도 회전시켜서 원래 위치로 되돌려놓는 역할을 한다.

$$
A=\begin{bmatrix}a&b\\c&d\end{bmatrix}
~\to~
A^{-1}=\frac{1}{\text{det}(A)}\begin{bmatrix}d&-b\\-c&a\end{bmatrix}
$$

$2\times2$ 행렬에서 역행렬을 계산하는 공식은 위와 같다.
