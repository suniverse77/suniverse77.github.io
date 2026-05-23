---
title: "[딥러닝] 경사 하강법 (Gradient Descent)"
date: 2025-02-11 00:00:00 +/-TTTT
categories: [AI, 머신러닝 / 딥러닝]
tags: [딥러닝, 역전파]
math: true
toc: true
author: sunho
---

## 경사 하강법 (Gradient Descent)

모델이 학습한다는 것은 파라미터 $\theta=\lbrace w,b\rbrace$를 업데이트한다는 의미이다.
<br>
그럼 어떤 기준과 방법으로 파라미터들을 업데이트할까?

모델이 파라미터를 업데이트하는 기준은 손실 함수 $\mathcal{L}$의 값을 최소화하는 것이다.
<br>
이를 위해 손실 함수의 그래디언트를 이용한다.

기본적인 파라미터 업데이트 수식은 다음과 같다.

$$
\theta_{t+1}=\theta_t-\eta\nabla_{\theta_t}\mathcal{L}
\tag{1}
$$

위의 수식에서 $\eta$는 학습률 (Learning Rate)로, 한 번에 얼마나 이동할지인 보폭을 의미한다.

식 (1)은 손실 함수값이 작아지는 방향으로 파라미터를 업데이트한다는 의미이다.
<br>
이 과정이 마치, 손실 함수의 최소값을 찾기 위해 그래디언트를 이용해 경사를 따라 내려가듯 파라미터를 업데이트한다고 해서 경사 하강법이라고 부른다.

![fig1](AI/ML-DL/Gradient_Descent-1.png){: style="display:block; margin:0 auto; width:50%;"}
_[[출처]](https://blog.ex-em.com/1750)_

### 손실 함수 (Loss Function)

손실 함수는 모델의 예측값 $\hat{y}$과 실제 정답(Ground Truth) $y$ 사이의 오차를 수치화한 지표로, 모델이 학습 과정을 통해 최종적으로 최소화해야 하는 목표이다.

$$
\mathcal{L}(\hat{y},y)=Error(\hat{y},y)
\tag{2}
$$

일반적으로 모델의 파라미터가 최적값에서 멀어질수록 오차가 커지도록 설계된다.
<br>
즉, <span style="background-color:#fff5b1">손실 함수의 값이 클수록 현재 모델의 상태가 최적값에서 멀리 떨어져 있음</spn>을 의미한다.

### 그래디언트의 의미

모델에 여러 개의 파라미터 $\boldsymbol{\theta}=[\theta_1,\dots,\theta_N]$이 존재할 때, 손실 함수 $\mathcal{L}$에 대한 그래디언트는 각 파라미터에 대한 편미분 벡터로 나타난다.

$$
\nabla_{\boldsymbol{\theta}}\mathcal{L}=
[\frac{\partial\mathcal{L}}{\partial\theta_1},\dots,\frac{\partial\mathcal{L}}{\partial\theta_N}]
\tag{3}
$$

이 그래디언트는 최적화를 위해 다음의 정보를 제공한다.

- **크기 (Magnitude)**

    $$\left|\frac{\partial\mathcal{L}}{\partial\theta_n}\right|$$

    현재 스텝에서 해당 파라미터 $\theta_n$이 손실 함수에 끼치는 영향력을 의미한다.
    <br>
    <span style="background-color:#fff5b1">이 값이 클수록, 해당 파라미터를 아주 조금만 변경해도 손실 함수의 값이 크게 변한다.</span>

    매 스텝마다 어떤 파라미터가 중요한지는 계속 바뀐다.

- **방향 (Direction)**

    $$\frac{\partial\mathcal{L}}{\partial\theta_n}$$

    현재 해당 파라미터의 위치에서 손실 함수 값이 가장 가파르게 증가하는 방향을 의미한다.

![fig2](AI/ML-DL/Gradient_Descent-2.png){: style="display:block; margin:0 auto; width:50%;"}

## 그래디언트 계산 방법

컴퓨터가 그래디언트를 계산하는 방법에는 크게 두 가지가 있다.

### Numerical gradient

미분의 수학적 정의를 이용해 그래디언트의 근사치를 계산하는 방법이다.

$$
\frac{df(x)}{dx}=\lim_{h\to0}\frac{f(x+h)-f(x)}{h}
\tag{4}
$$

$h$가 완전한 0이 아니므로 근사치이며, 가중치 하나하나에 대해 두 가지 함수 $f(x+h)$, $f(x)$를 호출해야 하므로 매우 느리다.

하지만 수식이 직관적이기 때문에 코드로 구현하기는 쉽다.

### Analytic gradient

미적분학을 이용해 그래디언트를 계산하는 공식을 유도하여 구현하는 방법이다.

$$
f(x)=2x^3 ~\to~f'(x)=6x^2
$$

수학 공식을 직접 사용하기 때문에 오차가 없고, 한 번의 계산으로 모든 가중치에 대한 그래디언트를 얻을 수 있기 때문에 매우 빠르다.

하지만 복잡한 모델의 그래디언트 공식을 유도하고 코드로 구현하는 것이 어렵다.
