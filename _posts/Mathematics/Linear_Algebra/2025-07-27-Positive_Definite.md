---
title: "[선형대수] Qudratic Form과 Positive Definite"
date: 2025-07-27 00:00:00 +/-TTTT
categories: [Mathematics, 선형대수]
tags: [선형대수]
math: true
toc: true
author: sunho
---

## Qudratic Form
Qudaratic Form은 어떤 벡터 $\mathbf{x}$를 넣었을 때 2차식이 나오는 형태라고 생각하면 된다.

가장 기본적인 형태는 다음과 같다.

$$
f(\mathbf{x})=\mathbf{x}^\top A\mathbf{x}
\tag{1}
$$

예를 들어 2차원 벡터 $\mathbf{x}$와 대칭 행렬 $A$에 대해 Quadratic Form을 계산하면 다음과 같다.

$$
\mathbf{x}=\begin{bmatrix}x_1\\x_2\end{bmatrix}~,~
A=\begin{bmatrix}a & b\\b & c\end{bmatrix}
\quad\to\quad
f(\mathbf{x})=ax_1^2+2bx_1x_2+cx_2^2
$$

즉, 행렬 $A$는 벡터 $\mathbf{x}$에 대해 2차식의 계수를 결정하는 역할을 한다.

## Positive Definite Matrix

대칭 행렬 $A\in\mathbb{R}^{n\times n}$와 영벡터가 아닌 벡터 $\mathbf{x}$에 대해서 Qudratic Form이 항상 양수값을 가질 때, $A$를 **Positive Definite**하다고 부른다.

$$\vphantom{\Big(}
\mathbf{x}^\top A\mathbf{x}>0
\;,\quad\text{where }\forall \mathbf{x}\not=\mathbf{0}
\tag{2}
$$

Positive Definite Matrix는 다음과 같은 특징을 가진다.

- $A$의 고유값은 모두 양수이다.
- $A$의 행렬식은 양수이다.
- $A$를 이용해 새로운 내적 $\langle\mathbf{x},\mathbf{y}\rangle_A=\mathbf{x}^\top A\mathbf{x}$를 정의할 수 있다.

만약 $\mathbf{x}^\top A\mathbf{x}=\mathbf{0}$을 만족하는 $\mathbf{0}$이 아닌 벡터가 존재하면, $A$를 **Positive Semi-Definite**하다고 부른다.

$$\vphantom{\Big(}
\mathbf{x}^\top A\mathbf{x}\geq0
\;,\quad\text{where }\forall \mathbf{x}\not=\mathbf{0}
\tag{3}
$$

<details>
<summary><font color='#FF0000'>**Example:** Positive Definite 판별하기</font></summary>
<div markdown="1">

> $$A=\begin{bmatrix}2&1\\1&2\end{bmatrix}$$
>
> **정의로 판별**
>
> $$\mathbf{x}^\top A\mathbf{x}=\begin{bmatrix}x_1&x_2\end{bmatrix}\begin{bmatrix}2&1\\1&2\end{bmatrix}\begin{bmatrix}x_1\\x_2\end{bmatrix}=2x_1^2+2x_1x_2+2x_2^2=2(x_1+\frac{1}{2}x_2)^2+\frac{3}{2}x_2^2$$
>
> $x_1,x_2\neq0$일 때 $2(x_1+\frac{1}{2}x_2)^2+\frac{3}{2}x_2^2$는 항상 양수이므로, $A$는 Positive Definite하다.
>
> **고유값으로 판별**
>
> $$\text{det}(A-\lambda I)=\begin{vmatrix}2-\lambda&1\\1&2-\lambda\end{vmatrix}=\lambda^2-4\lambda+3=(\lambda-1)(\lambda-3)=0$$
>
> $A$의 고유값 $\lambda_1=3$과 $\lambda_2=1$은 모두 양수이다. <br> $A$는 대칭 행렬이고 고유값이 모두 양수이므로, Positive Definite하다.

</div>
</details>
<br>

Positive Definite Matrix를 여러 관점에서 해석할 수 있다.

### 기하학적 관점

<span style="background-color:#fff5b1">$A$가 Positive Definite하다면, Qudratic Form의 곡면은 아래로 볼록한 그릇 모양이 된다.</span>

Quadratic Form $f(\mathbf{x})=\mathbf{x}^\top A\mathbf{x}$를 3차원 공간 $(x_1,x_2,f)$의 곡면으로 그려 보면, $A$의 고유값의 부호에 따라 원점 주변의 모양이 다음과 같이 달라진다.

- **고유값이 모두 양수:** 원점에서 최솟값 $0$을 갖고 모든 방향으로 위로 증가하는 그릇 모양
- **고유값이 모두 음수:** 원점에서 최댓값을 갖는 뒤집힌 돔 모양
- **고유값의 부호가 섞임:** 한 방향은 올라가고 다른 방향은 내려가는 안장 모양 (Saddle point)

즉, 행렬 $A$가 Positive Definite하다는 것은, 행렬 $A$가 만드는 2차식이 원점을 제외하면 항상 양수라는 의미이다.

$$
f(\mathbf{x})>0\;,\quad\text{where }\forall \mathbf{x}\not=\mathbf{0}
$$

![fig1](Mathematics/Linear_Algebra/Positive_Definite-1.png){: style="display:block; margin:0 auto; width:60%;"}

이렇게 원점에서 최솟값을 갖고 위로 열린 그릇 모양의 곡면을 **타원 포물면 (Elliptic Paraboloid)** 이라고 한다.

![fig2](Mathematics/Linear_Algebra/Positive_Definite-2.png){: style="display:block; margin:0 auto; width:70%;"}

### 내적 관점

<span style="background-color:#fff5b1">$A$가 Positive Definite하다면, $A$에 의한 변환은 벡터의 방향성을 어느 정도 보존한다.</span>

Quadratic Form은 벡터 $\mathbf{x}$와 변환된 벡터 $A\mathbf{x}$의 내적으로도 볼 수 있다.

$$
\mathbf{x}\cdot (A\mathbf{x})=\mathbf{x}^\top (A\mathbf{x})
$$

이때 $A$가 Positive Definite하다면 $\mathbf{x}^\top A\mathbf{x}>0$이기 때문에, 변환된 벡터 $A\mathbf{x}$는 원래 벡터 $\mathbf{x}$와 90º보다 작은 각을 이룬다.

즉, Positive Definite 변환은 벡터의 방향성을 어느 정도 보존하는 선형 변환으로 볼 수 있다.

![fig3](Mathematics/Linear_Algebra/Positive_Definite-3.png){: style="display:block; margin:0 auto; width:60%;"}
_[[출처]](https://angeloyeo.github.io/2021/12/20/positive_definite.html)_
