---
title: "[CS231n] Regularization and Optimization"
date: 2025-09-06 00:00:00 +/-TTTT
categories: [AI, CS231n]
tags: [CS231n]
math: true
toc: true
author: sunho
description: 📖 Stanford CS231n | Spring 2025 | Lecture 3 
---

## Regularization

$$
L(W)=\underbrace{\frac{1}{N}\sum_{i=1}^NL_i(f(x_i,W),y_i)}_{\text{Data loss}}+\underbrace{\lambda R(W)}_{\text{Regularization}}
$$

**Data loss**

모델이 학습 데이터에 대해 올바른 예측을 하도록 유도한다.

**Regularization**

모델이 학습 데이터에 오버피팅되는 것을 방지해 일반화 성능을 높이는 역할을 한다.

입력 데이터와는 독립적인 항으로, 가중치 $W$의 크기나 형태만 제한하기 때문에 가중치가 복잡해지는 것을 방지해 단순하고 안정적인 모델을 만들도록 한다.

### L1 Regularization (Lasso)

$$
R(W)=\sum_k\sum_l\lvert W_{k,l}\rvert
$$

L1 정규화 공식은 위와 같다.

### L2 Regularization (Lidge)

$$
R(W)=\sum_k\sum_lW^2_{k,l}
$$

L2 정규화 공식은 위와 같다.

정규화에 대한 자세한 내용은 [Regularization] 포스터에 정리되어 있습니다.

## Optimization

모델의 가중치를 업데이트하는 데 사용되는 그라디언트를 계산하는 방법에는 두 가지가 있다.

**Numerical gradient**

미분의 수학적 정의를 이용해 그라디언트의 근사치를 계산하는 방법이다.

$$
\frac{df(x)}{dx}=\lim_{h\to0}\frac{f(x+h)-f(x)}{h}
$$

$h$가 완전한 0이 아니므로 근사치이며, 가중치 하나하나에 대해 두 가지 함수 $f(x+h)$, $f(x)$를 호출해야 하므로 매우 느리다.

하지만 수식이 직관적이기 때문에 코드로 구현하기는 쉽다.

**Analytic gradient**

미적분학을 이용해 그라디언트를 계산하는 공식을 유도하여 구현하는 방법이다.

$$
f(x)=2x^3 ~\to~f'(x)=6x^2
$$

수학 공식을 직접 사용하기 때문에 오차가 없고, 한 번의 계산으로 모든 가중치에 대한 그라디언트를 얻을 수 있기 때문에 매우 빠르다.

하지만 복잡한 모델의 그라디언트 공식을 유도하고 코드로 구현하는 것이 어렵다.

### SGD (Stochastic Gradient Descent)

알고리즘 실행마다 데이터 subset을 무작위로 샘플링하기 때문에 stochastic이라고 부른다.

$$
x_{t+1}=x_t-\alpha\nabla f(x_t)
$$

SGD에는 몇 가지 문제점이 존재한다.

1. Oscillation
    
    손실 함수가 어떤 방향에서는 가파르고 다른 방향에서는 완만할 수가 있다. 이런 경우에 Gradient Descent는 경사를 따라 지그재그로 움직이며 진동하면서 천천히 수렴하게 된다.
    
    ![fig2](cs231n/03-2.png){: style="display:block; margin:0 auto; width:100%;"}
    
    행렬의 condition number는 가장 큰 singular value와 가장 작은 singular value의 비율을 의미한다.
    
    Hessian은 loss 함수의 곡률을 나타내는 행렬로, Hessian의 condition number이 크다는 것은 어떤 방향은 가파르고, 어떤 방향은 평평하다는 뜻이다. → 최적화가 불안정해짐

2. Local minima or Saddle point

    손실 함수의 지형에는 여러 개의 local minima와 saddle point가 존재한다. 특히 고차원 고차원 공간에서는 local minima보다 saddle point가 더 흔하며, Saddle point에서는 gradient가 0에 가까워져 학습이 정체될 수 있다.
    
    ![fig3](cs231n/03-3.png){: style="display:block; margin:0 auto; width:70%;"}
    
3. Stochasticity
    
    미니배치를 사용하기 때문에 loss 값이 매 스텝마다 심하게 흔들릴 수 있다.
    
    ![fig4](cs231n/03-4.png){: style="display:block; margin:0 auto; width:30%;"}

### SGD + Momentum

단순히 gradient만 보는 대신, 속도를 고려한 방법이다.

$$
v_{t+1}=\rho v_t+\alpha\nabla f(x_t)
$$

$$
x_{t+1}=x_t-\alpha v_{t+1}
$$

- $v$ (velocity): 이전까지의 여러 step의 누적 업데이트 방향을 나타낸다.
- $\rho$ (momentum): 과거 속도를 얼마나 반영할지를 결정한다. (클수록 과거 속도를 더 많이 반영한다.)

같은 방향의 그라디언트가 반복되면 점차 속도가 붙어 더 빨라지며, 곡률 차이가 큰 지형에서 진동을 줄이고 더 안정적인 방향으로 이동할 수 있다.

반드시 빠른 수렴을 보장하진 않지만, 더 나은 minimum을 찾도록 도와준다.

### RMSprop

그라디언트의 크기를 요소별로 조정하여 학습률을 스케일링한 방법이다.

$$
g_{t+1}=\gamma g_t+(1-\gamma)\left(\nabla f(x_t)\right)^2
$$

$$
x_{t+1}=x_t-\frac{\alpha}{\sqrt{g_{t+1}+\epsilon}}\nabla f(x_t)
$$

그라디언트가 큰 파라미터는 업데이트 폭을 줄이고, 작은 파라미터는 더 크게 업데이트하도록 하였다. 

직관적으로 평평한 영역 (그라디언트가 작은 영역)에서는 이동을 가속, 가파른 영역 (그라디언트가 큰 영역)에서는 이동을 완화시켜 방향마다 다른 스케일을 자동으로 보정해 학습을 안정화한다.

### Adam

Momentum + RMSprop을 결합한 방식이다.

- **Momentum**: 1차 모멘트(gradient 평균)를 추적
- **RMSprop**: 2차 모멘트(gradient 제곱 평균)를 추적

$$
m_{t+1}=\beta_1m_t+(1-\beta_2)\nabla f(x_t)~,~v_{t+1}=\beta_1v_t+(1-\beta_2)\left(\nabla f(x_t)\right)^2
$$

$$
\hat{m}_{t+1}=\frac{m_{t+1}}{1-(\beta_1)^{t+1}}~,~\hat{v}_{t+1}=\frac{v_{t+1}}{1-(\beta_2)^{t+1}}
$$

$$
x_{t+1}=x_t-\alpha\frac{\hat{m}_t}{\sqrt{\hat{v}_t}+\epsilon}
$$

### AdamW

Adam의 변형으로, Regularization문제를 개선하기 위해 고안되었다.

## Learning Rate Decay

학습률 (learning rate)을 고정하는 방법 외에도 다양한 전략이 존재한다.

경험적으로 배치 크기를 $k$배 증가시키면 학습률도 $k$배 증가시키는 것이 효과적이라고 한다. (이를 linear scaling rule이라고 함)

### Step

특정 epoch마다 learning rate를 감소시키는 방식이다.

![fig5](cs231n/03-5.png){: style="display:block; margin:0 auto; width:40%;"}

### Cosine

$$
\alpha_t=\frac{1}{2}\alpha_0(1+\cos(t\pi/T))
$$

![fig6](cs231n/03-6.png){: style="display:block; margin:0 auto; width:40%;"}

### Linear

선형적으로 감소시키는 방식이다.

$$
\alpha_t=\alpha_0(1-t/T)
$$

![fig7](cs231n/03-7.png){: style="display:block; margin:0 auto; width:40%;"}

### Invert Sqrt

$$
\alpha_t=\frac{\alpha_0}{\sqrt{t}}
$$

![fig8](cs231n/03-8.png){: style="display:block; margin:0 auto; width:40%;"}

### Linear Warmup

초기에 선형적으로 learning rate를 증가시킨 후 cosine 또는 invert sqrt 방법을 따라가는 방식이다.

![fig9](cs231n/03-9.png){: style="display:block; margin:0 auto; width:40%;"}
