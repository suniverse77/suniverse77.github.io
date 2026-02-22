---
title: "[생성 모델] Score Matching"
date: 2025-10-08 00:00:00 +/-TTTT
categories: [AI, 생성 모델]
tags: [생성 모델, Diffusion]
math: true
toc: true
author: sunho
---

> [NeurIPS 2019] [Generative Modeling by Estimating Gradients of the Data Distribution](https://arxiv.org/abs/1907.05600)

> [ICLR 2021] [Score-Based Generative Modeling through Stochastic Differential Equations](https://arxiv.org/abs/2011.13456)

## Score Function

여러 개의 산이 있는 확률 공간에서 데이터가 밀집된 곳은 산의 정상이고, 산 아래는 노이즈로 생각할 수 있다.

산 아래에서 정상으로 가기 위해서는 어느 방향으로 가야 정상인지를 알려주는 가이드가 필요하다. 이 방향을 알려주는 것이 gradient이다.

![fig1](AI/Generative/Score_Matching-1.png){: style="display:block; margin:0 auto; width:80%;"}
_[[출처]](https://jmtomczak.github.io/blog/16/16_score_matching.html)_

이 기울기 값을 수학적으로 Score라고 하며, log-likelihood의 gradient로 정의된다.

$$
\nabla_\mathbf{x}\log p(\mathbf{x})
$$

또는 위의 식 자체를 함수로 보고, Score Function이라고도 한다.

$$
s(\mathbf{x})=\nabla_\mathbf{x}\log p(\mathbf{x})
$$

## Score Matching

Score Matching은 말 그대로 데이터 분포의 기울기인 score function을 예측하는 것이다.

![fig2](AI/Generative/Score_Matching-2.png){: style="display:block; margin:0 auto; width:80%;"}

즉, 모델이 예측한 score와 실제 데이터의 score 간의 차이를 줄이도록 학습한다.

$$
\mathcal{L}=\frac{1}{2}\mathbb{E}_{p_{data}(\mathbf{x})}\left[\lVert s_\theta(\mathbf{x})-\nabla_\mathbf{x}\log p_{data}(\mathbf{x})\rVert_2^2\right]
$$

하지만 여기에는 치명적인 모순이 있다. 우리가 모델을 학습시키는 이유는 실제 데이터 분포 $p_{data}(\mathbf{x})$를 모르기 때문인데, 위 식을 계산하려면 실제 데이터 분포의 기울기를 알아야 한다. 즉, 정답을 모르는데 정답과 비교해야 하는 상황인 것이다.

이 문제를 해결하기 위해 등장한 기법들이 바로 Score Matching이다.

### Implicit Score Matching

2005년 Hyvärinen은 부분 적분을 이용해, 실제 데이터의 분포를 몰라도 위 목적 함수를 최소화할 수 있음을 수학적으로 증명했다. 유도 과정을 거친 목적 함수는 아래와 같다.

$$
\mathcal{L}=\mathbb{E}_{p_{data}(\mathbf{x})}\left[\text{tr}\left(\nabla_\mathbf{x}s_\theta(\mathbf{x})\right)
+\frac{1}{2}\lVert s_\theta(\mathbf{x})\rVert_2^2\right]
$$

하지만 식에 포함된 $\text{tr}(\nabla_\mathbf{x} s_\theta(\mathbf{x}))$ 항은 모델 출력의 입력에 대한 미분값(Jacobian)의 대각합을 구해야 한다. 

이는 데이터 차원이 커질수록 계산량이 기하급수적으로 늘어나기 때문에, 딥러닝에 직접 적용하기엔 너무 무거웠다.

### Denoising Score Matching

Score estimation에서는 문제가 하나 있는데, 데이터가 없는 영역에서는 정확한 score를 추정하기 어렵다는 것이다.

![fig3](AI/Generative/Score_Matching-3.png){: style="display:block; margin:0 auto; width:80%;"}

이를 완화하기 위해 데이터에 분산이 $\sigma^2$인 가우시안 노이즈를 더하고, 노이즈가 섞인 분포의 score를 추정하도록 하였다.

$$
p(\tilde{\mathbf{x}}\mid\mathbf{x})=\mathcal{N}(\tilde{\mathbf{x}};\mathbf{x},\sigma^2\mathbf{I})
$$

위 조건부 확률은 우리가 직접 정의한 가우시안 분포이기 때문에, 미분 또한 간단하게 계산할 수 있다.

$$
\nabla_{\tilde{\mathbf{x}}}\log p(\tilde{\mathbf{x}}\mid\mathbf{x})
=-\frac{\tilde{\mathbf{x}}-\mathbf{x}}{\sigma^2}
$$

이때, 추가하는 노이즈의 양이 많다면 원본 데이터의 분포 자체가 손상되는 문제가 발생하기 때문에 적절한 조정이 필요하다.

![fig4](AI/Generative/Score_Matching-4.png){: style="display:block; margin:0 auto; width:80%;"}

Vincent는 노이즈가 섞인 데이터 $\tilde{\mathbf{x}}$의 Score를 추정하는 것이, 원본 데이터 $\mathbf{x}$의 Score를 추정하는 것과 최적화 관점에서 동치임을 증명했다.

$$
\mathcal{L}=\mathbb{E}\left[\lVert s_\theta(\tilde{\mathbf{x}})-\nabla_{\tilde{\mathbf{x}}}\log p_{data}(\tilde{\mathbf{x}}\mid\mathbf{x})\rVert_2^2\right]
=\mathbb{E}\left[\left\lVert s_\theta(\tilde{\mathbf{x}})-\frac{\tilde{\mathbf{x}}-\mathbf{x}}{\sigma^2}\right\rVert_2^2\right]
$$
