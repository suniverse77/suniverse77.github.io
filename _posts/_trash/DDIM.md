# DDIM

#### Generative Process and Unified Variational Inference Objective

Reverse process에서 각 $p_\theta^{(t)}(\mathbf{x}\_{t-1}\mid\mathbf{x}\_t)$는 $q\_\sigma(\mathbf{x}\_t \mid \mathbf{x}\_{t-1}, \mathbf{x}\_0)$에 대한 지식을 활용한다.

직관적으로, noisy한 관측값 $\mathbf{x}\_t$가 주어졌을 때, 먼저 그에 대응되는 $\mathbf{x}\_0$를 예측하고, $q_\sigma(\mathbf{x}\_t \mid \mathbf{x}\_{t-1}, \mathbf{x}\_0)$를 이용해 $\mathbf{x}\_{t-1}$을 생성한다.

$$
\mathbf x_t=\sqrt{\bar{\alpha}_t}\mathbf x_0+\sqrt{(1-\bar{\alpha}_t)}\boldsymbol\epsilon
$$

위의 식은 DDPM에서 정의된 forward sampling을 나타내는데, 모델은 $\epsilon_\theta(\mathbf{x}_t,t)$는 $\mathbf{x}_t$로부터 노이즈 $\epsilon_t$를 예측하기 때문에 위의 식을 아래와 같이 다시 정리할 수 있다.

$$
f_\theta^{(t)}(\mathbf{x}_t):=
\frac{\mathbf{x}_t-\sqrt{1-\bar\alpha_t}\cdot\boldsymbol\epsilon_\theta^{(t)}(\mathbf{x}_t)}{\sqrt{\bar\alpha_t}}
$$

$f_\theta^{(t)}(\mathbf{x}_t)$는 $\mathbf{x}_t$로부터 $\mathbf{x}\_0$를 예측하는 함수이다.

최종적으로 학습 가능한 생성 과정 $p_\theta(\mathbf{x}_{0:T})$는 아래와 같이 정의된다.

$$
p_\theta^{(t)}(x_{t-1} \mid x_t) = 
\begin{cases}
\mathcal{N}(f_\theta^{(t)}(x_1),\, \sigma_1^2 \mathbf{I}) & \text{if } t = 1 \\
q_\sigma(x_{t-1} \mid x_t,\, f_\theta^{(t)}(x_t)) & \text{if } t > 1
\end{cases}
$$

---

$$
J_\sigma(\boldsymbol{\epsilon}_\theta) :=
\mathbb{E}_{\mathbf{x}_{0:T} \sim q_\sigma(\mathbf{x}_{0:T})}
\left[
\log q_\sigma(\mathbf{x}_{1:T} \mid \mathbf{x}_0)
- \log p_\theta(\mathbf{x}_{0:T})
\right]
\\
=
\mathbb{E}_{\mathbf{x}_{0:T} \sim q_\sigma(\mathbf{x}_{0:T})}
\left[
\log q_\sigma(\mathbf{x}_T \mid \mathbf{x}_0)
+ \sum_{t=2}^{T} \log q_\sigma(\mathbf{x}_{t-1} \mid \mathbf{x}_t, \mathbf{x}_0)
- \sum_{t=1}^{T} \log p_\theta^{(t)}(\mathbf{x}_{t-1} \mid \mathbf{x}_t)
- \log p_\theta(\mathbf{x}_T)
\right]
$$

위 목적 함수 $J_\sigma$의 정의로부터, $\sigma$ 선택에 따라 다른 목적 함수가 생기기 때문에, 각 $\sigma$ 마다 다른 모델을 학습해야 할 것처럼 보일 수 있다.

하지만 Theorem 1에 의해, 특정 가중치 $\gamma$에 대해 $J_\sigma$와 $L_\gamma$는 동일하다.

> **Theroem 1**
> 
> 0보다 큰 모든 $\sigma$에 대해 $J_\sigma=L_\gamma+C$를 만족시키는 $\gamma\in\mathbb{R}^T_{>0}$와 $C\in\mathbb{R}$가 존재한다.
>
> ---
>
> $J_\sigma$: non-Markovian variational 목적함수
> 
> $L_\gamma$: DDPM의 일반화된 목적함수 (각 시간 $t$마다 가중치 $\gamma_t$ 적용)
>
> 이 정리는 DDPM에서 사용되는 $L_1$ 목적함수가 DDIM 등 다른 생성 과정에도 그대로 사용될 수 있음을 이론적으로 보장한다.

#### Relevance to Neural ODEs

DDIM 반복 과정을 아래와 같이 다시 정리할 수 있으며, 이는 ODE를 풀기 위한 Euler 적분 방식과 구조적으로 유사하다.

$$
\frac{\mathbf{x}_{t - \Delta t}}{\sqrt{\bar\alpha_{t - \Delta t}}}
=
\frac{\mathbf{x}_t}{\sqrt{\bar\alpha_t}}
+
\left(
\sqrt{\frac{1 - \bar\alpha_{t - \Delta t}}{\bar\alpha_{t - \Delta t}}}
-
\sqrt{\frac{1 - \bar\alpha_t}{\bar\alpha_t}}
\right)
\boldsymbol{\epsilon}_\theta^{(t)}(\mathbf{x}_t)
$$

이에 대응하는 ODE를 유도하기 위해 $\frac{\sqrt{1-\bar\alpha}}{\sqrt{\bar\alpha}}=\sigma$, $\frac{\mathbf{x}}{\sigma}=\bar{\mathbf{x}}$로 치환하여 아래의 식으로 정리하였다.

$\sigma(0)=0$일 때, 위의 식은 아래의 ODE를 풀기 위한 Euler method로 다뤄질 수 있다.

$$
\mathrm{d}\bar{\mathbf{x}}(t)
=
\boldsymbol{\epsilon}_\theta^{(t)}\left(
\frac{\bar{\mathbf{x}}^{(t)}}{\sqrt{\sigma^2 + 1}}
\right)
\, \mathrm{d}\sigma(t)
$$

충분한 discretization step들을 거치면, 위 식의 ODE를 reverse해서 generation process의 reverse도 가능해진다.

즉, $\mathbf{x}_0$를 $\mathbf{x}_T$로 인코딩이 가능해진다.

--------------------------------------------------------------------------