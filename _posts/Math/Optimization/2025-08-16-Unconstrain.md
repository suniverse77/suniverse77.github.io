---
title: "[최적화] 비제약 최적화 문제"
date: 2025-08-16 00:00:00 +/-TTTT
categories: [Mathmatics, 최적화]
tags: [최적화]
math: true
toc: true
author: sunho
---

## 비제약 최적화 (Unconstrained Optimization)

아무런 제약 조건 없이, 목적 함수 $f(x)$의 값을 최소화하는 변수 $x$를 찾는 기본적인 최적화 문제이다.

$$
x^*=\min_{x}f(x)
$$

## 최적해의 조건

어떤 지점이 최소점인지 판단하기 위한 수학적 조건으로, 1차 필요 조건과 2차 충분 조건이 있다.

이를 판별하기 위해 그라디언트와 Hessian을 사용한다.

### 그라디언트 (Gradient)

함수 $f:\mathbb{R}^n\to\mathbb{R}$를 각 변수에 대해 편미분한 값을 모은 열 벡터를 그라디언트라고 한다.

$$
\nabla_\mathbf{x} f(\mathbf{x})
=\begin{bmatrix}\frac{\partial f}{\partial x_1}\\\vdots\\\frac{\partial f}{\partial x_n}\end{bmatrix}\in\mathbb{R}^n
$$

그라디언트는 특정 지점에서 함수 값이 가장 가파르게 증가하는 방향을 가리키며, 최소값을 찾기 위해서는 그라디언트의 반대 방향으로 나아가야 한다.

**1차 필요 조건**

어떤 점에서 최소가 되기 위한 필수 조건은 해당 지점에서의 그라디언트가 0이어야 한다는 것이다.

$$
\nabla f(\mathbf{x}^*)=0
$$

이를 만족하는 점을 정상점 (Stationary Point)이라고 부른다.

정상점은 최소점이 될 수도 있지만, 최대점 또는 안장점 (Saddle Point)일 수도 있기 때문에 Hessian을 보고 판단해야 한다.

### 헤시안 행렬 (Hessian Matrix)

함수 $f:\mathbb{R}^n\to\mathbb{R}$의 2차 편미분을 모두 모은 정사각 행렬을 Hessian 행렬이라고 한다.

$$
H(f)=\nabla^2_\mathbf{x}f(\mathbf{x})
=\begin{bmatrix}
\frac{\partial^2 f}{\partial x^2_1}&\cdots&\frac{\partial^2 f}{\partial x_1\partial x_n}\\
\vdots&\ddots&\vdots\\
\frac{\partial^2 f}{\partial x_n\partial x_1}&\cdots&\frac{\partial^2 f}{\partial x_n^2}
\end{bmatrix}\in\mathbb{R}^{n\times n}
~~,~~
H_{ij}(f)=\frac{\partial}{\partial x_i}\left(\frac{\partial f}{\partial x_j}\right)
$$

Hessian은 함수의 곡률을 나타내며, 특정 지점 주변이 위로 볼록한지 아래로 볼록한지를 알려준다.

**2차 충분 조건**

정상점이 최소점임을 확신하기 위한 충분 조건은 Hessian 행렬이 [양의 정부호 (Positive Definite)](https://suniverse77.github.io/posts/Positive/)여야 한다는 것이다.

$$
\mathbf{y}^\top H(\mathbf{x}^*)\mathbf{y}>0
$$

행렬이 양의 정부호라는 것은 그 지점에서 함수가 아래로 볼록한 그릇 모양이라는 의미이다.

![fig1](mlm/o16-1.png){: style="display:block; margin:0 auto; width:60%;"}
_[[출처]](https://medium.com/ai-saturdays-lagos-articles/tensorboard-hessian-matrices-and-linear-regression-39fe2f28de0f)_

따라서 <span style="background-color:#fff5b1">그라디언트가 0이면서 Hessian이 양의 정부호이면, 해당 점은 지역 최소점 (Local Minimum)</span>이다.

## 수치적 해법

목적 함수가 복잡해서 $\nabla f(x)=0$을 손으로 풀 수 없을 때, 컴퓨터를 이용해 점진적으로 최적해를 찾아가는 방법이다.

### 경사 하강법 (Gradient Descent)

현재 위치에서 그라디언트의 반대 방향으로 조금씩 이동하여 함수의 최소값을 찾아 나가는 알고리즘이다.

$$
x_{k+1}=x_k-\eta\nabla f(x_k)
$$

- $x_k$는 현재 위치, $x_{k+1}$은 다음 위치를 의미한다.
- $\eta$는 학습률 (Learning Rate)으로, 한 번에 얼마나 크게 이동할지를 결정한다.

![fig2](mlm/o16-2.png){: style="display:block; margin:0 auto; width:60%;"}
_[[출처]](https://mlpills.dev/machine-learning/gradient-descent/)_

### 뉴턴 방법 (Newton's Method)

함수를 2차 함수로 근사하여, 그 근사된 함수의 최소점으로 한 번에 이동하는 방식이다.

즉, 현재 지점의 기울기와 볼록성을 모두 고려하여, '진짜 최소점이 저기쯤 있겠다'라고 예측하며 점프하는 방식이다.

$$
x_{k+1}=x_k-\left[\nabla^2f(x_k)\right]^{-1}\nabla f(x_k)
$$

경사 하강법에 비해 수렴 속도가 빠르지만, Hessian 행렬의 역행렬을 계산해야 하기 때문에 계산 비용이 매우 높다.
