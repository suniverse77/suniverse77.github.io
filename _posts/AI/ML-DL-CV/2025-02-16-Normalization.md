---
title: "[정규화] Normalization"
date: 2025-02-16 00:00:00 +/-TTTT
categories: [AI, 머신러닝 / 딥러닝 / 컴퓨터 비전]
tags: [딥러닝, 정규화]
math: true
toc: true
author: sunho
---

Normalization은 <span style="background-color:#fff5b1">학습 속도와 안정성을 향상시키기 위해 데이터의 분포를 안정화</span>하는 기법으로, 사용되는 위치에 따라 목적이 다르다.

## 데이터 전처리 단계에서의 Normalization

모델 <span style="background-color:#fff5b1">입력이 안정적 분포</span>를 가지도록 하여 초기 학습이 더 잘 되도록 한다.

Standardization (표준화), Min-Max Scaling 등의 기법이 존재한다.

## 신경망 내부에서 동작하는 Normalization

각 layer의 <span style="background-color:#fff5b1">출력을 안정적인 분포</span>로 맞춰서 학습이 발산하지 않고 빠르게 수렴하도록 한다.

![fig1](AI/ML-DL/Normalization-1.png){: style="display:block; margin:0 auto; width:80%;"}
_출처: Stanford CS231n, Lecture 6 (CNN Architectures)_

### Batch Normalization

이름 그대로 <span style="background-color:#fff5b1">정규화 과정에 배치가 포함된다.</span>
<br>
하나의 배치 내에서 모든 샘플에 걸친 각 feature의 평균과 분산을 구한다.

배치 크기가 너무 작으면, 평균과 분산이 매우 불안정해져서 성능이 오히려 떨어질 수도 있다.

#### 추론 단계에서의 Batch Normalization

추론 단계에서는 배치가 없기 때문에, 학습 과정에서 계산해 놓은 평균과 분산 $\mu_{running}~,\sigma_{running}^2$을 사용한다.

학습 과정에서는 현재 배치의 통계값 $\mu_B~,\sigma_B^2$을 이용해 학습 데이터 전체의 평균 통계값 $\mu_{running}~,\sigma_{running}^2$을 EMA 방식으로 계속 업데이트한다.

$$
\begin{aligned}
\mu_{running}\leftarrow m\cdot\mu_{running}+(1-m)\cdot\mu_B\\
\sigma_{running}^2\leftarrow m\cdot\sigma_{running}^2+(1-m)\cdot\sigma_B^2
\end{aligned}
$$

위의 식에서 $m$은 모멘텀으로, 보통 $0.9$ 또는 $0.99$의 값으로 설정한다.

### Layer Normalization

<span style="background-color:#fff5b1">정규화 과정이 배치와 독립적으로 하나의 데이터 내에서만 수행된다.</span>
<br>
모든 feature에 걸친 각 샘플의 평균과 분산을 구한다.

배치 크기에 전혀 영향을 받지 않기 때문에, 배치 크기가 작거나 트랜스포머처럼 시퀀스 길이가 샘플마다 달라 배치를 묶기 애매할 때도 안정적으로 작동한다.

#### 추론 단계에서의 Layer Normalization

추론 단계에서는 현재 입력된 현재 샘플의 평균과 분산을 실시간으로 계산해서 바로 사용한다.

### Normalization에서의 학습 가능한 파라미터

Batch Norm과 Layer Norm는 두 단계로 작동한다.

1. 데이터를 평균 0, 분산 1로 변환한다.

    $$
    \hat{x}_i=\frac{x_i-\mu}{\sqrt{\sigma^2+\epsilon}}
    $$

2. $\gamma$와 $\beta$를 이용해 scale과 shift를 수행 후, 다음 layer로 전달한다.

    $$
    y_i=\gamma\cdot\hat{x}_i+\beta
    $$

단순히 정규화만 한다면 모든 layer의 출력은 무조건 평균 0, 분산 1인 분포를 가져야만 한다. 이는 학습을 안정화시키는 데는 좋지만, 신경망의 표현력을 심각하게 제한할 수 있다.

따라서 학습 가능한 파라미터 $\gamma$와 $\beta$를 통해 정규화로 인해 잃어버릴 수 있는 모델의 표현력을 다시 복원할 수 있도록 한다.

$\gamma$와 $\beta$를 통해 출력이 다시 불안정해질 수 있다고 생각할 수 있지만, 안정화된 상태에서 최적의 위치를 찾아가도록 돕는 역할을 한다.
