---
title: "[CNN] 데이터 정규화"
date: 2025-02-05 12:00:00 +/-TTTT
categories: [AI, 딥러닝]
tags: [CS231n]
math: true
toc: true
author: sunho
---

데이터 정규화 기법에는 크게 Regularization과 Normalization이 있다.

- **Regularization**: 모델의 복잡도에 제약을 가하는 기법이다. 학습 데이터에 과적합 (Overfitting)되는 것을 방지하기 위해 사용한다.
- **Normalization**: 모델에 입력되는 데이터의 scale을 조정하는 기법이다. 학습을 안정적이게 하기 위해 사용한다.

## Regularization

Regularization은 아래와 같이 Data loss에 Regularization term을 더하는 형태로 표현된다.

$$
L(W)=\underbrace{\frac{1}{N}\sum_{i=1}^NL_i(f(x_i,W),y_i)}_{\text{Data loss}}+\underbrace{\lambda R(W)}_{\text{Regularization}}
$$

- **Data loss**: 모델이 학습 데이터에 대해 올바른 예측을 하도록 유도한다.
- **Regularization term**: 모델이 학습 데이터에 오버피팅되는 것을 방지해 일반화 성능을 높이는 역할을 한다.

Regularization term은 입력 데이터와는 독립적인 항으로, 가중치 $W$의 크기나 형태만 제한하기 때문에 가중치가 복잡해지는 것을 방지해 단순하고 안정적인 모델을 만들도록 한다.

### L1 Regularization (Lasso)

L1 정규화 공식은 아래와 같다.

$$
R(W)=\sum_k\sum_l\lvert W_{k,l}\rvert
$$

L1 궤적은 

### L2 Regularization (Lidge)

L2 정규화 공식은 아래와 같다.

$$
R(W)=\sum_k\sum_lW^2_{k,l}
$$

L2 궤적은

## Normalization

### Min-Max Scaling

공식은 아래와 같으며, 데이터의 범위를 $[0,1]$ 또는 $[-1,1]$ 사이로 스케일링한다.

$$
x'=\frac{x-x_{min}}{x_{max}-x_{min}}
$$

### Standardization

공식은 아래와 같으며, 데이터의 분포를 평균 0, 분산 1로 변환한다.

$$
x'=\frac{x-\mu}{\sigma}
$$

- $x$는 입력, $\mu$는 평균, $\sigma$는 표준편차를 의미한다.

### Covariate Shift
