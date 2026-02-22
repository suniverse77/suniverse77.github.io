---
title: "[NN] 신경망에서의 Regularization과 Normalization"
date: 2025-02-02 00:00:00 +/-TTTT
categories: [AI Theory, 딥러닝]
tags: [딥러닝, 정규화]
math: true
toc: true
author: sunho
---

## Regularization vs Normalization

### 규제 (Regularization)

Regularization은 모델이 학습 데이터에 너무 오버피팅되는 것을 방지하는 기법이다.

[L1/L2 Regularization], Dropout 등의 기법이 존재한다.

### 정규화 (Normalization)

Normalization은 학습 속도와 안정성을 향상시키기 위해 데이터의 분포를 안정화하는 기법으로, 사용되는 위치에 따라 목적이 다르다.

#### 데이터 전처리 단계에서의 Normalization

모델 <span style="background-color:#fff5b1">입력이 안정적 분포</span>를 가지도록 하여 초기 학습이 더 잘 되도록 한다.

Standardization (표준화), Min-Max Scaling 등의 기법이 존재한다.

#### 신경망 내부에서 동작하는 Normalization

각 layer의 <span style="background-color:#fff5b1">출력을 안정적인 분포</span>로 맞춰서 학습이 발산하지 않고 빠르게 수렴하도록 한다.

Batch/Layer Normalization 등의 기법이 존재한다.

## Dropout

Dropout은 오버피팅을 방지하기 위해 MLP에서 학습 중에 확률적으로 뉴런을 꺼서 모델이 특정 뉴런에 오버피팅되는 것을 막는 기법이다.

Dropout에서 사용되는 하이퍼파라미터 $p$는 뉴런이 제거될 확률이다. 즉, 뉴런이 살아남을 확률은 $1-p$이다.

매번 다른 뉴런이 꺼지기 때문에 일종의 앙상블 학습 효과를 낸다.

![fig1](dl/nn/4-1.png){: style="display:block; margin:0 auto; width:80%;"}
_출처: Stanford CS231n, Lecture 6 (CNN Architectures)_

### 추론 단계에서의 Dropout

추론 때에도 dropout을 적용하면 같은 이미지를 넣어도 매번 출력이 달라지기 때문에 예측의 일관성이 없어진다. 따라서 dropout은 학습에서만 사용하고 추론 단계에서는 사용하지 않는다.

하지만 학습에서만 사용할 경우 학습과 테스트 때 활성된 뉴런의 개수가 달라지기 때문에 각 뉴런의 출력값의 스케일이 달라지는 현상이 발생한다.

이러한 현상을 방지하기 위해 학습 때 출력값에 $\frac{1}{1-p}$를 곱해서 학습과 추론 때의 출력 분포가 동일하도록 맞춘다.

<details>
<summary><font color='#FF0000'>Example 1</font></summary>
<div markdown="1">

$p=0.5$의 Dropout 적용했을 때, 신경망의 출력값은 $2$가 된다.

$$
\mathbf{x}^\top\mathbf{w}=
\begin{bmatrix}1\\1\\1\\1\end{bmatrix}
\begin{bmatrix}1&0&1&0\end{bmatrix}=2
$$

추론 때는 Dropout을 적용하지 않기 때문에, 신경망의 출력값은 $4$가 된다.

$$
\mathbf{x}^\top\mathbf{w}=
\begin{bmatrix}1\\1\\1\\1\end{bmatrix}
\begin{bmatrix}1&1&1&1\end{bmatrix}=4
$$

학습과 추론 때의 출력 스케일이 다르기 때문에, 학습 때 출력값에 $\frac{1}{1-0.5}=2$를 곱해서 스케일을 맞춘다.

---

</div>
</details>

## Normalization

![fig2](dl/nn/4-2.png){: style="display:block; margin:0 auto; width:80%;"}
_출처: Stanford CS231n, Lecture 6 (CNN Architectures)_

### Batch Normalization

<span style="background-color:#fff5b1">배치를 기준으로 수행된다.</span>

배치 내에서 각 feature 별로 정규화를 수행

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

<span style="background-color:#fff5b1">배치와 독립적으로 수행된다.</span>

모든 feature에 걸친 각 샘플의 평균과 분산을 구합니다.

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
