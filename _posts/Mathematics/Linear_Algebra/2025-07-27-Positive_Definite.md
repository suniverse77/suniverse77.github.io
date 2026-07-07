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
<summary><font color='#FF0000'><strong>Example:</strong> Positive Definite 판별</font></summary>
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

Positive Definite Matrix의 성질을 여러 관점에서 해석할 수 있다.

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

![fig1](Mathematics/Linear_Algebra/Positive_Definite-1.png){: style="display:block; margin:0 auto; width:40%;"}

이렇게 원점에서 최솟값을 갖고 위로 열린 그릇 모양의 곡면을 **타원 포물면 (Elliptic Paraboloid)** 이라고 한다.

### 내적 관점

<span style="background-color:#fff5b1">$A$가 Positive Definite하다면, $A$에 의한 변환은 벡터의 방향성을 어느 정도 보존한다.</span>

Quadratic Form은 벡터 $\mathbf{x}$와 변환된 벡터 $A\mathbf{x}$의 내적으로도 볼 수 있다.

$$
\mathbf{x}\cdot (A\mathbf{x})=\mathbf{x}^\top (A\mathbf{x})
$$

이때 $A$가 Positive Definite하다면 $\mathbf{x}^\top A\mathbf{x}>0$이기 때문에, 변환된 벡터 $A\mathbf{x}$는 원래 벡터 $\mathbf{x}$와 90º보다 작은 각을 이룬다.

즉, Positive Definite 변환은 벡터의 방향성을 어느 정도 보존하는 선형 변환으로 볼 수 있다.

![fig2](Mathematics/Linear_Algebra/Positive_Definite-2.png){: style="display:block; margin:0 auto; width:60%;"}
_[[출처]](https://angeloyeo.github.io/2021/12/20/positive_definite.html)_

## 딥러닝에서의 활용

손실 함수, 확률 분포, 분산 등 Quadratic Form $\mathbf{x}^\top A\mathbf{x}$는 어디에서든지 반복해서 등장한다.
<br>
이때 $A$의 정부호성이 손실 함수의 최솟값이 존재하는지, 유효한 분포인지, 유효한 분산인지 등을 결정하게 된다.

### 볼록성 (Convexity)

임의의 손실 함수 $\mathcal{L}({\boldsymbol{\theta}})$를 한 점 $\boldsymbol{\theta}_0$​ 근처에서 2차 테일러 전개하면 다음과 같다.

$$
\mathcal{L}(\boldsymbol{\theta}_0+\Delta)\approx \mathcal{L}(\boldsymbol{\theta}_0)+\nabla \mathcal{L}^\top\Delta+\tfrac{1}{2}\,\Delta^\top H\,\Delta
$$

여기서 $\tfrac{1}{2}\Delta^\top H\Delta$라는 Quadratic Form이 손실 함수의 Local 지형을 결정한다.
<br>
즉, Hessian $H$가 Positive Definite하면 그 점은 그릇 모양의 국소 최솟값이 된다.

만약 모든 점에서 $H$가 Positive Definite하다면, 손실 함수는 볼록 함수가 되고 국소 최솟값이 곧 전역 최솟값이 된다.

### 가우시안 분포

다변량 가우시안 분포의 수식을 보면, 지수 안에 Quadratic Form $(\mathbf{x}-\boldsymbol\mu)^\top\boldsymbol\Sigma^{-1}(\mathbf{x}-\boldsymbol\mu)$가 포함되어 있는 것을 확인할 수 있다.

$$
p(\mathbf{x})=\frac{1}{\sqrt{(2\pi)^D|\boldsymbol\Sigma|}}\exp(-\frac{(\mathbf{x}-\boldsymbol\mu)^\top\boldsymbol\Sigma^{-1}(\mathbf{x}-\boldsymbol\mu)}{2})
$$

위의 가우시안 분포 공식이 유효하기 위해서는, 공분산 $\Sigma$가 Positive Definite해야 한다.
<br>
이유는 다음과 같다.

- $\Sigma$가 Positive Definite하면 고유값이 모두 양수(0이 없음)이므로 $\Sigma^{-1}$이 존재하고, 이 역행렬 또한 Positive Definite하다.
- $\Sigma^{-1}$이 Positive Definite하므로, 지수 안의 Quadratic Form은 평균이 아닌 모든 점에서 양수이다. <br> 따라서 지수는 $0$ 이하가 되어, 밀도는 평균에서 최대이고 멀어질수록 감소한다. <br> 이로 인해 적분이 유한($=1$)해져 확률 분포가 될 수 있다.
- $\Sigma$가 Positive Definite하면 행렬식이 양수이므로, 분모의 $\lvert\boldsymbol\Sigma\rvert^{\frac{1}{2}}$이 정의된다.

기하학적으로, $\Sigma$의 고유값이 모두 양수라는 것은, 분포가 모든 방향으로 퍼져있다는 뜻이다.
<br>
반대로 $\Sigma$가 Positive Definite하지 않아 어떤 방향의 분산(고유값)이 $0$이 되면, $\Sigma^{-1}$와 $|\Sigma|^{\frac{1}{2}}$이 정의되지 않고 분포가 저차원으로 붕괴한다.
