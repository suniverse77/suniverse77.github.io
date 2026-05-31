---
title: "[확률] 마르코프 체인 (Markov Chain)"
date: 2025-08-16 00:00:00 +/-TTTT
categories: [Mathmatics, 확률]
tags: [확률, 머신러닝]
math: true
toc: true
author: sunho
---

마르코프 체인은 마르코프 성질을 지닌 이산 확률 과정(Discrete Stochastic Process)을 의미한다.

- **마르코프 성질:** <span style="background-color:#fff5b1">어떤 시스템의 다음 상태는 오직 현재의 상태에만 영향을 받으며, 그 이전의 과거는 상관이 없다는 성질</span>
- **이산 확률 과정:** 이산적인 시간의 변화에 따라 확률이 변화하는 과정

이를 조건부 확률 수식으로 표현하면 다음과 같다.

$$
P(X_{n+1}\mid X_1,X_2, \dots, X_n) = P(X_{n+1}\mid X_n)
\tag{1}
$$

예를 들어 날씨가 마르코프 성질을 가진다면, 어제나 그저께의 날씨는 알 필요 없이 오직 오늘의 날씨만 알면 내일의 날씨를 예측할 수 있다는 뜻이다.

마르코프 모델은 다음 상태를 예측할 때 얼마나 많은 과거의 상태를 고려하느냐에 따라 차수가 결정된다.

- **1차 마르코프 모델 (1st-order Markov Model):** 오직 바로 직전 1개의 상태만을 기반으로 다음 상태를 예측한다.

    $$
    P(X_{n+1} \mid X_n)
    \tag{2}
    $$
- **2차 마르코프 모델 (2nd-order Markov Model):** 최근 2개의 상태를 함께 고려하여 다음 상태를 예측한다.

    $$
    P(X_{n+1} \mid X_n, X_{n-1})
    \tag{3}
    $$

![fig1](Math/Probability/Markov_Chain-1.png){: style="display:block; margin:0 auto; width:60%;"}
_[[출처]](https://roytravel.tistory.com/358)_

## 결합 확률 분포

일반적인 확률의 Chain Rule에 따르면, 여러 사건이 연속해서 일어날 결합 확률은 아래와 같이 표현된다.

$$
P(X_1,X_2,\dots,X_n)=P(X_1)\times P(X_2\mid X_1)\times P(X_3\mid X_2,X_1)\times\cdots\times P(X_n\mid X_{n-1},\dots X_1)
$$

만약 이 확률 분포가 마르코프 성질을 따른다면, 결합 확률을 다음과 같이 간단하게 표현할 수 있다.

$$
P(X_1,X_2,\dots,X_n)=P(X_1)\times P(X_2\mid X_1)\times P(X_3\mid X_2)\times\cdots\times P(X_n\mid X_{n-1})
$$
