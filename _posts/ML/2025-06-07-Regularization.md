---
title: "[정규화] Regularization"
date: 2025-06-07 00:00:00 +/-TTTT
categories: [AI, 머신러닝]
tags: [선형대수]
math: true
toc: true
author: sunho
---

## Regularization

Regularization은 모델의 복잡도를 줄여서 학습 데이터에 너무 오버피팅되는 것을 방지하는 기법이다.

이를 위해 손실 함수에 정규화 term $R(W)$를 추가한다. 이 추가되는 정규화 term의 형태에 따라 L1, L2로 분류된다.

$$
L(W)=\underbrace{\frac{1}{N}\sum_{i=1}^NL_i(f(x_i,W),y_i)}_{\text{Data loss}}+\underbrace{\lambda R(W)}_{\text{Regularization}}
$$

**Data loss**

모델이 학습 데이터에 대해 올바른 예측을 하도록 유도한다.

**Regularization**

정규화 term은 파라미터의 크기에 대한 패널티로 구성된다. 이로 인해 모델은 학습 과정에서 Data loss를 최소화하는 동시에, 가중치의 크기 또한 작게 유지하도록 유도된다.

가중치의 크기가 크다는 것은 모델의 출력이 특정 입력 특징의 작은 변화에도 매우 민감하게 반응한다는 의미이다.

따라서 가중치의 크기가 커지는 것을 방지한다는 것은 모델이 복잡해지는 것을 방지해 단순하고 안정적인 모델을 만든다는 뜻이다.

<details>
<summary><font color='#FF0000'>Example 1</font></summary>
<div markdown="1">

아래의 가중치 행렬에서 첫 번째 행은 '눈', 두 번째 행은 '코', 세 번째 행은 '입'의 특징을 감지한다고 해보자.

$$
W\mathbf{x}=
\begin{bmatrix}5&5&5&5\\1&1&1&1\\1&1&1&1\end{bmatrix}
\begin{bmatrix}2\\1\\3\\1\end{bmatrix}
=\begin{bmatrix}35\\7\\7\end{bmatrix}
$$

위 가중치 행렬에서 '눈'에 대한 가중치 크기가 매우 크다. 이는 모델이 '눈'을 감지하는 특징에 매우 민감하게 반응하며, '눈'의 정보를 다른 정보보다 훨씬 더 중요하게 증폭해서 받아들인다는 의미이다.

만약 입력 $\mathbf{x}$의 값이 $[2, 1, 3, 1]$이 아니라 노이즈가 낀 $[2, 1, 3, 1.1]$로 약간만 변해도, '코'와 '입'의 출력은 $0.1$만큼 변하지만, '눈'의 출력은 $0.5$만큼 변한다. 즉, '눈' 특징이 입력의 사소한 변화나 노이즈에도 크게 휘둘린다.

또한 모델이 학습 데이터의 '눈' 특징에 섞인 노이즈까지 증폭해서 학습하게 되면, 오버피팅으로 이어지게 된다.

</div>
</details>

## L1 Regularization (LASSO)

L1 정규화 공식은 아래와 같으며, 가중치에 L1 Norm을 적용한다.

$$
R(W)=\sum_k\sum_l\lvert W_{k,l}\rvert
$$

가중치에 대한 페널티로 절댓값을 사용합니다. 이로 인해 최적화 과정에서 중요도가 낮은 특징(feature)의 가중치를 정확히 0으로 만듭니다.

특징 선택 (Feature Selection): 가중치가 0이 된다는 것은 해당 특징을 모델이 사용하지 않는다는 의미이므로, L1 정규화는 모델 학습과 동시에 자동으로 특징을 선택하는 효과가 있습니다.

모델의 복잡도를 낮추고, 불필요한 특징이 많은 고차원 데이터에서 유용합니다.

![fig1](ml/regular/1-1.png){: style="display:block; margin:0 auto; width:100%;"}

## L2 Regularization (Ridge)

L2 정규화 공식은 아래와 같으며, 가중치에 L2 Norm을 적용한다.

$$
R(W)=\sum_k\sum_lW^2_{k,l}
$$

2 정규화는 가중치를 0으로 만들기보다는, 전체적인 가중치 값을 0에 가깝게 작게 유지하도록 유도합니다. 가중치가 0이 되는 경우는 거의 없습니다.

모델의 모든 특징을 사용하는 경향이 있으며, 가중치 값을 부드럽게(smooth) 분포시켜 일반화 성능을 높입니다. 가장 널리 사용되는 정규화 기법 중 하나입니다.
