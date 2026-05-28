---
title: "[딥러닝] 옵티마이저 (Optimizer)"
date: 2025-02-14 12:00:00 +/-TTTT
categories: [AI, 머신러닝 / 딥러닝 / 컴퓨터 비전]
tags: [딥러닝, 옵티마이저, 모델 학습]
math: true
toc: true
author: sunho
---

그래디언트를 이용해 파라미터를 업데이트하는 최적화 기법에는 여러 가지가 있다.

## SGD (Stochastic Gradient Descent)

전체 학습 데이터에서 1개를 무작위로 샘플링해서 그래디언트를 계산하고 파라미터를 업데이트하는 방법이다.

파라미터 업데이트 수식은 다음과 같다.

$$
\boldsymbol{\theta}_{t+1}=\boldsymbol{\theta}_t-\eta\nabla_{\boldsymbol{\theta}_t}\mathcal{L}_i
\tag{1}
$$

SGD는 1개의 샘플만 사용하기 때문에 loss 값이 매 epoch마다 심하게 흔들리는 oscillation 문제가 존재한다.

### 미니배치 경사 하강법 (Mini-batch GD)

전체 학습 데이터를 일정 크기의 미니배치로 나누고, 매 iteration마다 해당 배치의 데이터를 이용해 파라미터를 업데이트하는 방법이다.
<br>
<span style="background-color:#fff5b1">현대 딥러닝에서 흔히 SGD라고 부르는 것은 사실상 미니배치 GD를 의미한다.</span>

$$
\boldsymbol{\theta}_{t+1}=\boldsymbol{\theta}_t-\eta\frac{1}{B}\sum_{i\in\mathcal{B}}\nabla_{\boldsymbol{\theta}_t}\mathcal{L}_i
\tag{2}
$$

위 수식에서 $\mathcal{B}$는 이번 iteration에서 샘플링된 미니배치 데이터 집합을, $B$는 미니배치의 크기를 의미한다.

> **왜 미니배치라고 부를까?**
> 
> 전통적인 머신러닝 이론에서 배치라는 단어는 쪼개진 묶음이 아니라 전체 데이터를 의미했다.
    <br>
    또한 초창기에는 데이터가 많지 않았기 때문에, 파라미터 업데이트에 모든 학습 데이터를 이용하는 배치 경사 하강법 (Batch GD)를 사용했다.
> 
> 하지만 데이터가 점점 늘어나면서 전체 배치를 한 번에 계산하는 것이 물리적으로 불가능해졌다. 
    <br>
    그래서 전체 배치를 작게 쪼개서 미니배치로 학습하자는 아이디어가 등장한 것이다.
>
> 현대에서는 미니배치 단위로 학습하는 것이 당연한 표준이 되었고, 매번 미니배치라고 길게 부르기 귀찮아서 배치라고 줄여 부르기 시작한 것이다.

## SGD + Momentum

단순히 그래디언트만 이용해서 업데이트하는 대신, 모멘텀 $m_t$까지 고려한 방법이다.

$$
\begin{aligned}
m_t&=\mu m_{t-1}+\nabla_{\boldsymbol{\theta}_t}\mathcal{L}\\
\boldsymbol{\theta}_{t+1}&=\boldsymbol{\theta}_t-\eta m_t
\end{aligned}
\tag{3}
$$

모멘텀 $m_t$는 과거의 그래디언트들을 누적하여 현재 어느 방향으로 가속도가 붙었는지를 나타낸다.
<br>
$\mu$는 모멘텀 계수로, 과거의 속도를 얼마나 반영할지를 결정한다.

가파른 지형에서는 같은 방향의 그래디언트가 반복되면서, 점차 가속되고 진동이 줄어들기 때문에 더 빠르고 안정적인 수렴이 가능하다.

관성 덕분에 완만한 지점이나 얕은 local minimum에서 탈출할 수 있다.

## RMSprop

단순히 모든 파라미터에 고정된 학습률을 동일하게 적용하는 대신, 그래디언트의 크기에 따라 <span style="background-color:#fff5b1">학습률</span>을 개별적으로 조절하는 방법이다.

$$
\begin{aligned}
v_t&=\gamma v_{t-1}+(1-\gamma)\left(\nabla_{\boldsymbol{\theta}_t}\mathcal{L}\right)^2\\
\boldsymbol{\theta}_{t+1}&=\boldsymbol{\theta}_t-\frac{\eta}{\sqrt{v_t}+\epsilon}\nabla_{\boldsymbol{\theta}_t}\mathcal{L}
\end{aligned}
\tag{4}
$$

$v_t$는 그래디언트 제곱의 지수 가중 이동 평균으로, 각 파라미터가 최근까지 얼마나 큰 기울기를 가져왔는지에 대한 정보를 담고 있다.
<br>
$v_t$값을 이용해 그래디언트가 큰 파라미터는 업데이트 폭을 줄이고, 작은 파라미터는 업데이트 폭을 늘린다.

$\gamma$는 과거의 그래디언트 변동량을 얼마나 반영할지 결정하는 계수를 의미한다.

가파른 지형 (큰 그래디언트)에서는 이동을 완화시켜 진동을 방지하고, 평평한 지형 (작은 그래디언트)에서는 이동을 가속하여 최적점에 더 효율적으로 도달할 수 있도록 한다.

## Adam

Momentum과 RMSprop을 결합한 방법이다.

$$
\begin{aligned}
m_{t+1}&=\beta_1m_t+(1-\beta_1)\nabla_{\boldsymbol{\theta}_t}\mathcal{L}\\
v_{t+1}&=\beta_2v_t+(1-\beta_2)\left(\nabla_{\boldsymbol{\theta}_t}\mathcal{L}\right)^2\\
\boldsymbol{\theta}_{t+1}&=\boldsymbol{\theta}_t-\eta\frac{\hat{m}_t}{\sqrt{\hat{v}_t}+\epsilon}
\end{aligned}
\tag{5}
$$

$m_t$와 $v_t$는 EMA 방식으로 계산된다.

이때, $m_t$는 어떤 값 (여기서는 그래디언트)의 평균을 추정하므로 1차 모멘트, $v_t$는 어떤 값의 제곱의 평균을 추정하므로 2차 모멘트라고 부른다.

각 파라미터마다 그래디언트 외에 $m$과 $v$를 추가로 저장해놓고 있어야 하기 때문에, 메모리 사용량이 더 늘어난다는 단점이 있다.

학습 초기 $m_t$와 $v_t$가 $0$에 편향되는 것을 막기 위해 아래 식을 거친 후 업데이트에 사용한다.

$$
\hat{m}_t=\frac{m_t}{1-\beta_1^t}~,~\hat{v}_t=\frac{v_t}{1-\beta_2^t}
\tag{6}
$$

<details>
<summary><font color='#FF0000'>Why?</font></summary>
<div markdown="1">

Adam은 처음 시작할 때, $m_0$와 $v_0$를 $0$으로 초기화한다. 

만약 $\beta_1=0.9$라면, 첫 번째 스텝에서 $m_1$은 실제 그래디언트의 값보다 매우 작아지게 된다.

$$
m_1=0.9\cdot0+0.1\nabla\mathcal{L}_\theta(\theta_t)=0.1\nabla\mathcal{L}_\theta(\theta_t)
\tag{7}
$$

하지만 편향 보정을 사용할 경우, 분모와 분자가 약분되어 아래와 같은 결과로 이어진다.

$$
\hat{m}_1=\frac{m_1}{1-0.9}=\frac{0.1\nabla\mathcal{L}_\theta(\theta_t)}{0.1}=\nabla\mathcal{L}_\theta(\theta_t)
$$

---

</div>
</details>

## AdamW

기존 Adam에서 L2 정규화를 쓰면, 기울기가 큰 파라미터는 정규화가 약하게 되고, 기울기가 작은 파라미터는 정규화가 강하게 되는 의도치 않은 현상이 발생한다.

이러한 현상을 방지하기 위해 Adam에서 Weight Decay를 최적화 과정에서 분리한 방법이 AdamW이다.

$$
\theta_{t+1} = \theta_t - \eta \left( \frac{\hat{m}_t}{\sqrt{\hat{v}_t} + \epsilon} + \lambda \theta_t \right)
$$

### Adam에서 L2 정규화의 문제점

$$
\mathcal{L}_{\text{regular}}=\mathcal{L}+\frac{\lambda}{2}\lVert\theta\rVert^2
$$

L2 정규화를 포함한 손실 함수는 위와 같고, 이 손실 함수의 그래디언트는 아래와 같다.

$$
\nabla_\theta\mathcal{L}_{\text{regular}}(\theta_t)=\nabla_\theta\mathcal{L}(\theta_t)+\lambda\theta_t
$$

$\lambda\theta_t$ 항은 파라미터 업데이트 때 가중치를 더 작게 만들기 때문에 Weight Decay 항으로 불린다.

$$
\theta_{t+1}=\theta_t-\eta\left(\nabla_\theta\mathcal{L}(\theta_t)+\lambda\theta_t\right)
$$

이제 Adam 업데이트 수식에 L2 정규화 손실 함수의 그래디언트를 대입하면 아래와 같다. (편의상 보정은 제외)

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

- 그래디언트가 큰 파라미터는 $v_t$ 값이 크기 때문에 Weight Decay 값이 작아진다. 따라서 정규화가 의도보다 약하게 작용한다.
- 그래디언트가 작은 파라미터는 $v_t$ 값이 작기 때문에 Weight Decay 값이 커진다. 따라서 정규화가 의도보다 강하게 작용한다.
