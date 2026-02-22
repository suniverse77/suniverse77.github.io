---
title: "[NN] 옵티마이저 (Optimizer)"
date: 2025-02-01 12:00:00 +/-TTTT
categories: [AI Theory, 딥러닝]
tags: [딥러닝, 옵티마이저]
math: true
toc: true
author: sunho
---

## 옵티마이저 (Optimizer)

그라디언트를 이용해 파라미터를 업데이트하는 최적화 기법에는 여러 가지가 있다.

### SGD (Stochastic Gradient Descent)

알고리즘 실행마다 데이터 subset을 무작위로 샘플링하기 때문에 stochastic이라고 부른다.

$$
\theta_{t+1}=\theta_t-\eta\nabla\mathcal{L}_\theta(\theta_t)
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

단순히 그라디언트만 이용해서 업데이트하는 대신, 관성 (모멘텀)까지 고려한 방법이다.

$$
\theta_{t+1}=\theta_t-\eta m_t
$$

$m_t$는 모멘텀으로, 과거의 그라디언트들을 누적하여 현재 어느 방향으로 가속도가 붙었는지를 나타낸다.

$$
m_t=\mu m_{t-1}+\nabla\mathcal{L}_\theta(\theta_t)
$$

$\mu$는 모멘텀 계수로, 과거의 속도를 얼마나 반영할지를 결정한다.
값이 클수록 과거 속도를 더 많이 반영한다.

가파른 지형에서는 같은 방향의 그라디언트가 반복되면서, 점차 가속되고 진동이 줄어들기 때문에 더 빠르고 안정적인 수렴이 가능하다.

관성 덕분에 완만한 지점이나 얕은 local minimum에서 탈출할 수 있다.

### RMSprop

단순히 모든 파라미터에 고정된 학습률을 동일하게 적용하는 대신, 그라디언트의 크기에 따라 <span style="background-color:#fff5b1">학습률</span>을 개별적으로 조절하는 적응형 방법이다.

$$
\theta_{t+1}=\theta_t-\frac{\eta}{\sqrt{v_t}+\epsilon}\nabla\mathcal{L}_\theta(\theta_t)
$$

$v_t$는 그라디언트 제곱의 지수 가중 이동 평균으로, 각 파라미터가 최근까지 얼마나 큰 기울기를 가져왔는지에 대한 정보를 담고 있다.

그라디언트가 큰 파라미터는 업데이트 폭을 줄이고 (학습률을 작게), 작은 파라미터는 업데이트 폭을 늘리기 (학습률을 크게) 위해 $v_t$를 분모에 배치하였다.

$$
v_t=\gamma v_{t-1}+(1-\gamma)\left(\nabla\mathcal{L}_\theta(\theta_t)\right)^2
$$

$\gamma$는 과거의 그라디언트 변동량을 얼마나 반영할지 결정하는 계수를 의미한다.

가파른 지형 (큰 그라디언트)에서는 이동을 완화시켜 진동을 방지하고, 평평한 지형 (작은 그라디언트)에서는 이동을 가속하여 최적점에 더 효율적으로 도달할 수 있도록 한다.

### Adam

Momentum과 RMSprop을 결합한 방법이다.

$$
\theta_{t+1}=\theta_t-\eta\frac{\hat{m}_t}{\sqrt{\hat{v}_t}+\epsilon}
$$

$m_t$와 $v_t$는 각각 그라디언트의 모멘텀과 그라디언트 제곱의 평균으로, 지수 가중 이동 평균 (EMA) 방식을 통해 아래와 같이 계산된다.

$$
m_{t+1}=\beta_1m_t+(1-\beta_1)\nabla\mathcal{L}_\theta(\theta_t)
$$

$$
v_{t+1}=\beta_2v_t+(1-\beta_2)\left(\nabla\mathcal{L}_\theta(\theta_t)\right)^2
$$

이때, $m_t$는 어떤 값 (여기서는 그라디언트)의 평균을 추정하므로 1차 모멘트, $v_t$는 어떤 값의 제곱의 평균을 추정하므로 2차 모멘트라고 부른다.

학습 초기 $m_t$와 $v_t$가 $0$에 편향되는 것을 막기 위해 아래 식을 거친 후 업데이트에 사용한다.

$$
\hat{m}_t=\frac{m_t}{1-\beta_1^t}~,~\hat{v}_t=\frac{v_t}{1-\beta_2^t}
$$

<details>
<summary><font color='#FF0000'>Why?</font></summary>
<div markdown="1">

Adam은 처음 시작할 때, $m_0$와 $v_0$를 $0$으로 초기화한다. 

만약 $\beta_1=0.9$라면, 첫 번째 스텝에서 $m_1$은 실제 그라디언트의 값보다 매우 작아지게 된다.

$$
m_1=0.9\cdot0+0.1\nabla\mathcal{L}_\theta(\theta_t)=0.1\nabla\mathcal{L}_\theta(\theta_t)
$$

하지만 편향 보정을 사용할 경우, 분모와 분자가 약분되어 아래와 같은 결과로 이어진다.

$$
\hat{m}_1=\frac{m_1}{1-0.9}=\frac{0.1\nabla\mathcal{L}_\theta(\theta_t)}{0.1}=\nabla\mathcal{L}_\theta(\theta_t)
$$

---

</div>
</details>

### AdamW

기존 Adam에서 L2 정규화를 쓰면, 기울기가 큰 파라미터는 정규화가 약하게 되고, 기울기가 작은 파라미터는 정규화가 강하게 되는 의도치 않은 현상이 발생한다.

이러한 현상을 방지하기 위해 Adam에서 Weight Decay를 최적화 과정에서 분리한 방법이 AdamW이다.

$$
\theta_{t+1} = \theta_t - \eta \left( \frac{\hat{m}_t}{\sqrt{\hat{v}_t} + \epsilon} + \lambda \theta_t \right)
$$

#### Adam에서 L2 정규화의 문제점

$$
\mathcal{L}_{\text{regular}}=\mathcal{L}+\frac{\lambda}{2}\lVert\theta\rVert^2
$$

L2 정규화를 포함한 손실 함수는 위와 같고, 이 손실 함수의 그라디언트는 아래와 같다.

$$
\nabla_\theta\mathcal{L}_{\text{regular}}(\theta_t)=\nabla_\theta\mathcal{L}(\theta_t)+\lambda\theta_t
$$

$\lambda\theta_t$ 항은 파라미터 업데이트 때 가중치를 더 작게 만들기 때문에 Weight Decay 항으로 불린다.

$$
\theta_{t+1}=\theta_t-\eta\left(\nabla_\theta\mathcal{L}(\theta_t)+\lambda\theta_t\right)
$$

이제 Adam 업데이트 수식에 L2 정규화 손실 함수의 그라디언트를 대입하면 아래와 같다. (편의상 보정은 제외)

$$
\theta_{t+1}=\theta_t
-\eta\left(
\frac{\beta_1m_t}{\sqrt{v_t}+\epsilon}
+\frac{(1-\beta_1)\nabla_\theta\mathcal{L}(\theta_t)}{\sqrt{v_t}+\epsilon}
+\frac{(1-\beta_1)\lambda\theta_t}{\sqrt{v_t}+\epsilon}
\right)
$$

Weight Decay 항 $\frac{(1-\beta_1)\lambda\theta_t}{\sqrt{v_t}+\epsilon}$의 강도가 $\frac{1}{\sqrt{v}_t}$에 의해 조절되고 있는 것을 확인할 수 있다.

즉, 기존 Adam에서 L2 정규화를 사용할 경우 아래와 같은 문제가 발생한다.

- 그라디언트가 큰 파라미터는 $v_t$ 값이 크기 때문에 Weight Decay 값이 작아진다. 따라서 정규화가 의도보다 약하게 작용한다.
- 그라디언트가 작은 파라미터는 $v_t$ 값이 작기 때문에 Weight Decay 값이 커진다. 따라서 정규화가 의도보다 강하게 작용한다.
