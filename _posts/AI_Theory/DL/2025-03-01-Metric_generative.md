---
title: "[평가지표] 생성 모델 성능 평가"
date: 2025-03-01 18:00:00 +/-TTTT
categories: [AI, 딥러닝]
tags: [3D Vision]
math: true
toc: true
author: sunho
---

## IS (Inception Score)

IS는 생성된 이미지가 얼마나 고품질이고 얼마나 다양한지를 동시에 평가하는 지표이다.

이 지표는 생성된 이미지 $x$를 Inception 모델에 통과시켜 평가한다.

$$
\text{IS}=\exp\left(\mathbb{E}_{x\sim p_g}\left[D_{KL}(p(y\mid x)~||~p(y))\right]\right)
$$

- **높은 품질**

    Inception 모델에 생성된 이미지 $x$를 입력했을 때, 특정 클래스 $y$로 정확하게 분류되어야 한다. (엔트로피가 낮은 분포)

    즉, 조건부 확률 분포 $p(y\mid x)$의 엔트로피는 뾰족한 분포여야 한다.
- **높은 다양성**

    전체 클래스에 대한 주변 확률 분포 $p(y)$는 균등한 분포여야 한다. (엔트로피가 높은 분포)

IS가 높다는 것은 두 확률 분포 $p(y\mid x)$와 $p(y)$의 차이가 크다는 것을 의미한다. 즉, <span style="background-color:#fff5b1">IS는 높을수록 좋다.</span>

하지만 실제 이미지와 비교하지 않고, 생성된 이미지 자체로만 평가하기 때문에 현실성이 떨어질 수 있다는 단점이 있다.

## FID (Fréchet Inception Distance)

FID는 생성된 이미지의 통계적 분포가 실제 이미지의 통계적 분포와 얼마나 유사한지를 측정하는 지표이다.

마찬가지로, Inception 모델을 이용해서 평가한다.

$$
\text{FID}=\lVert\mu_r-\mu_g\rVert^2+\text{tr}\left(\Sigma_r+\Sigma_g-2(\Sigma_r\Sigma_g)^{\frac{1}{2}}\right)
$$

실제 이미지와 생성된 이미지를 Inception 모델에 통과시켜 중간 레이어의 특징 벡터를 추출한다.

이후 두 분포의 평균 $\mu$와 공분산 $\Sigma$를 구한 뒤, Fréchet Distance 공식을 사용해 두 분포 간의 거리를 계산한다.

FID가 낮다는 것은 실제 이미지와 생성된 이미지의 분포가 통계적으로 거의 동일하다는 의미이다. 즉, <span style="background-color:#fff5b1"> FID는 낮을수록 좋다.</span>

## CLIP Score

CLIP Score는 텍스트와 이미지 간 의미적 일치도를 측정하는 지표이다.

이 지표는 CLIP 모델을 이용해서 평가한다.

$$
\text{CLIP Score}=\frac{\vphantom{\big(}E_I\cdot E_T}{\lVert E_I\rVert\cdot\lVert E_T\rVert}
$$

텍스트 프롬프트 $T$와 생성 이미지 $I$ 각각을 CLIP의 텍스트 인코더와 이미지 인코더에 통과시켜, 임베딩 벡터 $E_T$와 $E_I$를 추출한다.

이후 두 벡터 간의 코사인 유사도 계산를 계산한다.

CLIP Score가 높다는 것은 텍스트와 이미지의 의미가 잘 일치한다는 의미이다. 즉, <span style="background-color:#fff5b1">CLIP Score는 값이 높을수록 좋다.</span> 
