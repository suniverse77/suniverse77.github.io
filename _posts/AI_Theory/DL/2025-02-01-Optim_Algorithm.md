---
title: "[NN] 최적화 기법"
date: 2025-02-01 12:00:00 +/-TTTT
categories: [AI, 딥러닝]
tags: [신경망]
math: true
toc: true
author: sunho
---

## 최적화 기법

### SGD (Stochastic Gradient Descent)

알고리즘 실행마다 데이터 subset을 무작위로 샘플링하기 때문에 stochastic이라고 부른다.

$$
x_{t+1}=x_t-\alpha\nabla f(x_t)
$$

SGD에는 몇 가지 문제점이 존재한다.

1. Oscillation
    
    손실 함수가 어떤 방향에서는 가파르고 다른 방향에서는 완만할 수가 있다. 이런 경우에 Gradient Descent는 경사를 따라 지그재그로 움직이며 진동하면서 천천히 수렴하게 된다.
    
    ![fig1](dl/nn/3-1.png){: style="display:block; margin:0 auto; width:80%;"}
    _출처: Stanford CS231n, Lecture 3 (Regularization and Optimization)_
    
    행렬의 condition number는 가장 큰 singular value와 가장 작은 singular value의 비율을 의미한다.
    
    Hessian은 loss 함수의 곡률을 나타내는 행렬로, Hessian의 condition number이 크다는 것은 어떤 방향은 가파르고, 어떤 방향은 평평하다는 뜻이다. → 최적화가 불안정해짐

2. Local minima or Saddle point

    손실 함수의 지형에는 여러 개의 local minima와 saddle point가 존재한다. 특히 고차원 고차원 공간에서는 local minima보다 saddle point가 더 흔하며, Saddle point에서는 gradient가 0에 가까워져 학습이 정체될 수 있다.
    
    ![fig2](dl/nn/3-2.png){: style="display:block; margin:0 auto; width:70%;"}
    _출처: Stanford CS231n, Lecture 3 (Regularization and Optimization)_
    
3. Stochasticity
    
    미니배치를 사용하기 때문에 loss 값이 매 스텝마다 심하게 흔들릴 수 있다.
    
    ![fig3](dl/nn/3-3.png){: style="display:block; margin:0 auto; width:30%;"}
    _출처: Stanford CS231n, Lecture 3 (Regularization and Optimization)_

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
