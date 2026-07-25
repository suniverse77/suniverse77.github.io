---
title: "[선형대수] Gradient & Jacobian"
date: 2025-08-10 00:00:00 +/-TTTT
categories: [Mathematics, 선형대수]
tags: [선형대수]
math: true
toc: true
author: sunho
---

미분은 입력값을 아주 조금 변화시켰을 때 출력값이 얼마나 변하는지를 나타내는 개념이다.

함수 $f:\mathbb{R}\to\mathbb{R}$의 점 $x$에서 미분계수는 다음과 같이 정의한다.

$$
f'(x)=\lim_{\Delta x\to0}\frac{f(x+\Delta x)-f(x)}{\Delta x}
\tag{1}
$$

여기서 $\Delta y=f(x+\Delta x)-f(x)$ 라고 하면, 미분계수는 $\Delta x$에 대한 $\Delta y$의 순간 변화율이다.

$$
\lim_{\Delta x\to0}\frac{\Delta y}{\Delta x}
\tag{2}
$$

$\Delta x$가 충분히 작을 때 출력 변화량은 다음과 같이 근사할 수 있다.

$$
\Delta y
\approx
f'(x)\Delta x
\tag{3}
$$

즉, <span style="background-color:#fff5b1">미분은 비선형 함수 $f$를 점 $x$ 근처에서 아래의 선형식으로 근사하는 역할을 한다.</span>

$$
f(x+\Delta x)
\approx
f(x)+f'(x)\Delta x
\tag{4}
$$

## 미분계수와 도함수 (Derivative)

함수 $f:\mathbb{R}\to\mathbb{R}$에 대해, 특정 점 $x=x_0$에서의 순간 변화율을 **미분계수**라고 한다.

$$
f'(x_0)=\left.\frac{df}{dx}\right|_{x=x_0}
\tag{5}
$$

각 점 $x$에 미분계수 $f'(x)$를 대응시켜 만든 새로운 함수를 **도함수**라고 한다.

$$
f'(x)=\frac{df}{dx}
\tag{6}
$$

따라서 미분계수는 특정 점에서의 하나의 값이고, 도함수는 그 값들을 입력 $x$에 따라 나타낸 함수이다.

## 그래디언트 (Gradient)

다변수 스칼라 함수 $f:\mathbb{R}^n\to\mathbb{R}$에 대해, 각 입력 변수에 대한 편미분을 모은 벡터를 **그래디언트**라고 한다.

$$
\nabla_\mathbf x f(\mathbf x)=
\frac{\partial f}{\partial\mathbf x}=
\begin{bmatrix}
\frac{\partial f(\mathbf x)}{\partial x_1}\\\vdots\\\frac{\partial f(\mathbf x)}{\partial x_n}
\end{bmatrix}
\in\mathbb{R}^{n\times1}
\tag{7}
$$

여기서 다변수 스칼라 함수는 벡터를 입력으로 받아 하나의 스칼라를 출력하는 함수이다.

$$
y=f(\mathbf x)=f(x_1,\ldots,x_n)\in\mathbb{R}
\tag{8}
$$

입력에 작은 변화 $\Delta\mathbf x$를 주면 출력 변화량은 다음과 같이 근사된다.

$$
f(\mathbf x+\Delta\mathbf x)-f(\mathbf x)
\approx
\nabla_{\mathbf x}f(\mathbf x)^{\mathsf T}\Delta\mathbf x
\tag{9}
$$

그래디언트 $\nabla_{\mathbf x}f(\mathbf x)$의 방향은 해당 점에서 함수값이 가장 빠르게 증가하는 방향이며, 그 크기는 그 방향에서의 최대 순간 변화율을 나타낸다.

## 자코비안 (Jacobian)

벡터 함수 $\mathbf f:\mathbb{R}^n\to\mathbb{R}^m$에 대해, 각 출력 성분 $f_i$를 각 입력 변수 $x_j$에 대해 편미분한 값들을 모은 행렬을 **자코비안**이라고 한다.

$$
J_\mathbf f(\mathbf{x})=
\frac{\partial\mathbf f}{\partial\mathbf x}=
\begin{bmatrix}
\frac{\partial \mathbf f(\mathbf x)}{\partial x_1}&\cdots&\frac{\partial \mathbf f(\mathbf x)}{\partial x_n}
\end{bmatrix}=
\begin{bmatrix}
\frac{\partial f_1(\mathbf x)}{\partial x_1}&\cdots&\frac{\partial f_1(\mathbf x)}{\partial x_n}\\
\vdots&\ddots&\vdots\\
\frac{\partial f_m(\mathbf x)}{\partial x_1}&\cdots&\frac{\partial f_m(\mathbf x)}{\partial x_n}
\end{bmatrix}
\in\mathbb{R}^{m\times n}
\tag{10}
$$

여기서 벡터 함수는 벡터를 입력 받아 벡터를 출력하는 함수이다.

$$
\mathbf{y}=
\mathbf f(\mathbf x)=
\begin{bmatrix}
f_1(\mathbf x)\\\vdots\\ f_m(\mathbf x)
\end{bmatrix}=
\begin{bmatrix}
f_1(x_1,\ldots,x_n)\\\vdots\\ f_m(x_1,\ldots,x_n)
\end{bmatrix}
\in\mathbb{R}^m
\tag{11}
$$

입력 벡터에 작은 변화 $\Delta\mathbf x$가 주어지면 출력 벡터의 변화는 다음과 같이 근사된다.

$$
\mathbf f(\mathbf x+\Delta\mathbf x)\approx
\mathbf f(\mathbf x)+
J_{\mathbf f}(\mathbf x)\Delta\mathbf x
\tag{12}
$$

즉, 자코비안은 벡터 함수가 점 $\mathbf x$ 근처에서 입력의 작은 변화를 출력의 작은 변화로 어떻게 변환하는지를 나타내는 선형 변환이다.

<span style="background-color:#fff5b1">그래디언트는 자코비안의 특별한 경우이다.</span>
<br>
출력 차원이 $m=1$인 스칼라 함수에서는 자코비안이 $1\times n$ 행벡터가 되며, 이는 사실상 그래디언트의 전치와 같다.

$$
J_\mathbf f(\mathbf{x})=\nabla_{\mathbf x}f(\mathbf x)^{\mathsf T}
\tag{13}
$$

## 그래디언트 계산법

들어가기에 앞서, 계산 과정에서 $\nabla\mathbf{x}^\top\nabla\mathbf{x}$와 같은 2차항은 무시 가능하다는 것을 참고 바란다.

딥러닝에서는 입력이 행렬이고 출력이 스칼라인 함수에서의 미분도 그래디언트라고 부른다.

### 벡터 미분

입력이 벡터이고 출력이 스칼라인 함수 $f:\mathbb{R}^{n}\to\mathbb{R}$에 대해, 그래디언트는 아래와 같은 선형 근사 식이 성립하도록 정의된다.

$$
f(\mathbf x+\Delta\mathbf x)-f(\mathbf x)\approx
\left(\nabla f(\mathbf{x})\right)^\top\Delta\mathbf x
\tag{8}
$$

<details>
<summary><font color='red'><strong>Example:</strong> 벡터 미분 1</font></summary>
<div markdown="1">

> $$\frac{\partial \mathbf x^\top A\mathbf x}{\partial\mathbf x}$$
>
> 1. 함수 정의
>
>       $$f(\mathbf{x})=\mathbf x^\top A\mathbf x$$
>
> 2. 선형 근사 식
>
>       $$f(\mathbf x+\Delta\mathbf x)-f(\mathbf x)=(\mathbf x+\Delta\mathbf{x})^\top A(\mathbf x+\Delta\mathbf{x})-\mathbf x^\top A\mathbf x=\mathbf x^\top(A+A^\top)\Delta\mathbf{x}$$
>
> 따라서 그래디언트는 다음과 같다.
>
> $$\nabla f(\mathbf{x})=(A+A^\top)\mathbf x$$

</div>
</details>

<details>
<summary><font color='red'><strong>Example:</strong> 벡터 미분 2</font></summary>
<div markdown="1">

> $$\frac{\partial\left<\mathbf x\cdot\mathbf x\right>}{\partial\mathbf x}$$
>
> 1. 함수 정의
>
>       $$f(\mathbf{x})=\left<\mathbf x\cdot\mathbf x\right>=\mathbf{x}^\top\mathbf{x}$$
>
> 2. 선형 근사 식
>
>       $$f(\mathbf x+\Delta\mathbf x)-f(\mathbf x)=(\mathbf{x}+\Delta\mathbf{x})^\top(\mathbf{x}+\Delta\mathbf{x})-\mathbf{x}^\top\mathbf{x}=2\mathbf x^\top\Delta\mathbf{x}$$
>
> 따라서 그래디언트는 다음과 같다.
>
> $$\nabla f(\mathbf{x})=2\mathbf{x}$$

</div>
</details>

### 행렬 미분

입력이 행렬이고 출력이 스칼라인 함수 $f:\mathbb{R}^{m\times n}\to\mathbb{R}$에 대해, 그래디언트는 아래와 같은 선형 근사 식이 성립하도록 정의된다.

$$
f(X+\Delta X)-f(X)\approx
\text{tr}\left(\left(\nabla_X f(X)\right)^\top\Delta X\right)
\tag{9}
$$

<details>
<summary><font color='red'><strong>Example:</strong> 행렬 미분 1</font></summary>
<div markdown="1">

> $$\frac{\partial \mathbf{a}^\top X\mathbf{b}}{\partial X}$$
>
> 1. 함수 정의
>
>       $$f(X)=\mathbf{a}^\top X\mathbf{b}$$
>
> 2. 선형 근사 식
>
>       $$f(X+\Delta X)-f(X)=\mathbf{a}^\top (X+\Delta X)\mathbf{b}-\mathbf{a}^\top X\mathbf{b}=\mathbf{a}^\top \Delta X\mathbf{b}$$
>
> 3. Trace로 표현
>
>       $$\mathbf{a}^\top \Delta X\mathbf{b}=\text{tr}(\mathbf{a}^\top \Delta X\mathbf{b})=\text{tr}(\mathbf{b}\mathbf{a}^\top \Delta X)$$
>
> 따라서 그래디언트는 다음과 같다.
>
> $$\nabla_X f(X)=\mathbf{b}\mathbf{a}^\top$$

</div>
</details>

<details>
<summary><font color='red'><strong>Example:</strong> 행렬 미분 2</font></summary>
<div markdown="1">

> $$\frac{\partial \log \lvert X^{-1}\rvert}{\partial X}=X^{-1}$$
>
> 1. 함수 정의
>
>       $$f(X)=\log \lvert X^{-1}\rvert$$
>
> 2. $Y=X^{-1}$라고 가정한 후, $\Delta Y$ 구하기
> 
>       $$XY=I\to(X+\Delta X)(Y+\Delta Y)=I$$
>
>       $$(X+\Delta X)(Y+\Delta Y)=XY+X\Delta Y+\Delta XY=I\rightarrow I+X\Delta Y+\Delta XY=I$$
>
>       $$X\Delta Y+\Delta XY=0\to\Delta Y=-X^{-1}\Delta XX^{-1}$$
>
> 3. 선형 근사 식
>
>       $$f(X+\Delta X)-f(X)=\log\lvert(X+\Delta X)^{-1}\rvert-\log \lvert X^{-1}\rvert=\log\lvert Y+\Delta Y\rvert-\log \lvert Y\rvert$$
>
>       $$\log\lvert Y+\Delta Y\rvert-\log \lvert Y\rvert=\log\left\lvert\frac{Y+\Delta Y}{Y}\right\lvert=\log\lvert I+Y^{-1}\Delta Y\rvert$$
>
> 4. Trace로 표현
> 
>       [Trace 성질](https://suniverse77.github.io/posts/Trace/#trace의-성질)의 8번 식과 1차 근사 $\log(1+x)\approx x$ 사용
>
>       $$\log\lvert I+Y^{-1}\Delta Y\rvert=\log\left(1+\text{tr}(Y^{-1}\Delta Y)\right)\approx \text{tr}(Y^{-1}\Delta Y)$$
>
> 5. 다시 $X$에 대한 식으로 표현
>
>       $$\text{tr}(Y^{-1}\Delta Y)=\text{tr}(-XX^{-1}\Delta XX^{-1})=\text{tr}(-X^{-1}\Delta X)$$
>
> 따라서 그래디언트는 다음과 같다.
> 
> $$\nabla_X f(X)=-X^{-\top}$$

</div>
</details>

## 자코비안 계산법

입력이 벡터이고 출력도 벡터인 함수 $\mathbf{f}:\mathbb{R}^{n}\to\mathbb{R}^m$에 대해, 자코비안 아래와 같은 선형 근사 식이 성립하도록 정의된다.

$$
\mathbf{f}(\mathbf{x}+\Delta \mathbf{x})-\mathbf{f}(\mathbf{x})\approx
J_{\mathbf{f}}(\mathbf{x})\Delta\mathbf{x}
\tag{10}
$$

<details>
<summary><font color='red'><strong>Example:</strong> 자코비안 계산</font></summary>
<div markdown="1">

> $$\frac{\partial A\mathbf x}{\partial\mathbf x}$$
>
> 1. 함수 정의
>
>       $$\mathbf{f}(\mathbf{x})=A\mathbf{x}$$
>
> 2. 선형 근사 식
>
>       $$\mathbf{f}(\mathbf{x}+\Delta \mathbf{x})-\mathbf{f}(\mathbf{x})=A(\mathbf{x}+\Delta\mathbf{x})-A\mathbf{x}=A\Delta\mathbf{x}$$
>
> 따라서 자코비안은 다음과 같다.
>
> $$J_{\mathbf{f}}(\mathbf{x})=A$$

</div>
</details>
