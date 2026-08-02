

[[Paper]](https://arxiv.org/abs/2011.13456)
[[GitHub]](https://github.com/yang-song/score_sde)

<details>
<summary><font color='#FF8C00'>📝 Summary</font></summary>
<div markdown="1">
<br>
하나의 모델을 학습해두면, 이후 생성 단계에서 원하는 샘플링 경로(길이/간격)를 선택하여 유연하고 빠르게 생성할 수 있다.

</div>
</details>

## Introduction

Score Matching with Langevin Dynamics (SMLD)는 각 노이즈 수준에서 데이터에 대한 score를 추정하고, 생성 시에는 점차 노이즈가 줄어드는 과정을 따라 Langevin dynamics로 샘플을 생성한다.

Denoising Diffusion Probabilistic Models (DDPM)는 역분포의 함수적 형태를 알고 있다는 가정 하에 노이즈가 추가되는 각 단계를 역전시키는 확률 모델을 학습한다. 연속적인 상태 공간에서는 DDPM의 학습 목적 함수가 각 노이즈 수준의 스코어를 암묵적으로 계산하게 된다.

이러한 이유로 위 두 모델을 통틀어 score-based generative models이라고 부른다.

**제안하는 방법**

스코어 기반 생성 모델의 새로운 샘플링 방법을 가능하게 하기 위해, 기존 접근 방식을 SDE 관점에서 일반화하는 통합 프레임워크를 제안한다.

<details>
<summary><font color='purple'>SDE (Stochastic Differential Equation)</font></summary>
<div markdown="1">

![fig1](/assets/images/paper/Score Diffusion-1.png){: style="display:block; margin:0 auto; width:100%;"}

<br>
미분방정식이란 미분을 포함하는 방정식으로, 어떤 값 $y$가 시간에 따라 어떻게 변하는지를 수식으로 표현한 것이다.

$$
\frac{dx}{dt}=f(x,t)
$$

위의 식에서 $f(x,t)$는 시간 $t$에 따른 $y$의 변화율을 의미한다.

미분방정식을 풀면 $x(t)$를 구할 수 있으며, 이는 시간 $t$에 따른 상태값을 의미한다.

변수 하나에 대해서만 미분이 일어나는 미분방정식을 ODE라고 부른다.

---

SDE는 아래와 같이 ODE에서 randomness가 추가된 형태이다.

$$
\underbrace{d\mathbf x=\mathbf f(\mathbf x,t)dt}_{\text{ODE}}+\underbrace{g(t)d\mathbf w}_{\text{Randomness}}
$$

Randomness 때문에 시간의 흐름에 따라 process가 항상 같은 것이 아니라 조금씩 달라진다.

즉, SDE를 풀면 여러 개의 확률적인 경로(Stochastic process) 중 하나의 경로가 나온다.

$f(\mathbf x,t)$, $g(t)$는 사전에 정의된 함수로 학습 파라미터가 없으며, 이 forward process는 입력 데이터와 무관하게 데이터를 무작위 노이즈로 바꾼다.

</div>
</details>

![fig2](/assets/images/paper/Score Diffusion-2.png){: style="display:block; margin:0 auto; width:90%;"}

## Methods

### 1. Score-based Generative Modeling with SDEs

#### Perturbing Data with SDEs

Diffusion process는 아래의 $\text{It\hat{o} SDE}$의 해로 모델링될 수 있다.

$$
d\mathbf{x}=\mathbf{f}(\mathbf{x},t)dt+g(t)d\mathbf{w}
$$

이후부터 아래의 notation을 사용한다.

- $p_t(\mathbf{x})$: $\mathbf{x}(t)$의 확률 밀도 함수
- $p_{st}(\mathbf{x}(t)\mid\mathbf{x}(s))$: $\mathbf{x}(s)$에서 $\mathbf{x}(t)$로의 transition kernel

#### Generating Samples by Reversing the SDE

Reverse-time SDE는 아래와 같이 주어진다.

$$
d\mathbf{x}=
\left[
\mathbf{f}(\mathbf{x},t)-g(t)^2\nabla_{\mathbf{x}}\log p_t(\mathbf{x})
\right]dt+g(t)d\bar{\mathbf{w}}
$$

여기서 $\bar{\mathbf{w}}$는 $T\to0$처럼 시간이 역으로 흐를 때의 standard Wiener process를, $dt$는 매우 작은 negative timestep을 의미한다.

각 $t$에서 marginal 분포의 score $\nabla_{\mathbf{x}}\log p_t(\mathbf{x})$를 모두 알고 있다면, 위의 식을 통해 reverse diffusion process를 유도할 수 있으며, $\mathbf{x}_0$ 또한 샘플링할 수 있다.

#### Estimating Scores for the SDE

확률 분포의 score는 score matching을 사용하여 학습된 score-based 모델을 통해 추정할 수 있다.

Score를 추정하기 위해 아래와 같은 손실함수를 최소하하여 학습한다.

$$
\boldsymbol{\theta}^*=\underset{\boldsymbol{\theta}}{\arg\min}~\mathbb{E}_t 
\left\{
\lambda(t)\mathbb{E}_{\mathbf{x}(0)}\mathbb{E}_{\mathbf{x}(t) \mid \mathbf{x}(0)}
\left[\lVert
\mathbf{s}_{\boldsymbol{\theta}}(\mathbf{x}(t), t)
- \nabla_{\mathbf{x}(t)} \log p_{0t}(\mathbf{x}(t) \mid \mathbf{x}(0)) 
\rVert_2^2\right]
\right\}
$$

충분한 데이터와 모델 용량이 있다면, score matching은 모든 $\mathbf{x}\_t$와 $t$에 대해서 optimal solution $\mathbf{s}\_{\boldsymbol{\theta}^*}(\mathbf{x}, t)$와 $\nabla_{\mathbf{x}(t)}\log p_t(\mathbf{x})$를 동일하게 만들어 준다.

SMLD와 DDPM에서와 같이 일반적으로 아래의 값을 선택한다.

$$
\lambda \propto \frac{1}{\mathbb{E} \left[
\left\| \nabla_{\mathbf{x}(t)} \log p_{0t}(\mathbf{x}(t) \mid \mathbf{x}(0)) \right\|_2^2
\right]}
$$

#### Examples: VE, VP SDEs and Beyond

SMLD와 같은 NCSN 모델의 계열에서 사용하는 forward SDE 형태는 아래와 같다.

$$
d\mathbf x=\sqrt{\frac{d[\sigma^2(t)]}{dt}}d\mathbf w
$$

timestep $t$가 커질수록 분산이 점점 커진다. → Variance Exploding SDE (VE-SDE)

DDPM에서 사용하는 forward SDE 형태는 아래와 같다.

$$
d\mathbf x=-\frac{1}{2}\beta(t)\mathbf xdt
+\sqrt{\beta(t)}d\mathbf w
$$

$\beta(t)$에 따라 분산이 일정하게 유지된다. → Variance Preserving SDE (VP-SDE)

### 2. Solving the Reverse SDE

Score-based 모델 $\mathbf{x}_\theta$가 학습되었다면 이를 사용해 reverse-time SDE를 구할 수 있으며, 수치적인 접근을 통해 $p_0$로부터 샘플을 생성할 수 있다.

아래는 reverse-time SDE를 구하기 위한 여러 가지 방법이다.

- General-purpose Numerical SDE Solvers

    Euler-Maruyama, stochastic Runge-Kutta와 같은 일반적인 수치적 SDE solver를 적용하여 역방향 SDE를 직접 시뮬레이션한다.
- Predictor-Corrector (PC) Sampler

    수치 해석으로 예측한 다음, Langevin dynamics와 같은 score 기반 MCMC를 사용해 분포를 보정함으로써 샘플 품질을 높인다.
- Probability Flow ODE

    Revser-time SDE와 동일한 주변 분포를 따르는 deterministic한 ODE를 정의하고, 이를 Neural ODE 방식으로 해결하여 샘플을 생성하고 likelihood 계산도 수행한다.
- 아키텍처 개선

    VE/VP/sub-VP SDE에 적합하도록 설계된 NCSN++, DDPM++ 등의 새로운 네트워크 아키텍처를 통해 샘플 품질 및 likelihood를 향상시킨다.

## Experiments

![fig3](/assets/images/paper/Score Diffusion-3.png){: style="display:block; margin:0 auto; width:100%;"}
