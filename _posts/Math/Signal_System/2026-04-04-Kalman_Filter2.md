---
title: "[칼만 필터] Kalman Filter 2 - 알고리즘"
date: 2026-04-04 06:00:00 +/-TTTT
categories: [Mathmatics, 신호 및 시스템]
tags: [칼만 필터]
math: true
toc: true
author: sunho
---

## 알고리즘 예시

우리가 로켓 엔진의 내부 온도 $T_{\text{in}}$를 알고 싶은 상황을 가정해 보자.

하지만 수천 도에 달하는 엔진 내부에 온도 센서를 직접 넣으면 열기 때문에 센서가 녹아버리므로, 내부 온도를 직접 측정하는 것은 불가능하다.

대신 우리는 현재 로켓에 주입되는 연료량 $W_{\text{fuel}}$을 정확히 알고 있고, 센서를 통해 상대적으로 덜 뜨거운 엔진의 외부 온도 $T_{\text{ext}}$를 측정할 수 있다.
<br>
그리고 $W_{\text{fuel}}$이 주어졌을 때, $T_{\text{in}}$과 $T_{\text{ext}}$를 계산할 수 있는 수학적 모델을 가지고 있다.

이론적으로라면 모델이 계산한 외부 온도 $\hat{T}\_{\text{ext}}$와 실제 센서로 읽어들인 외부 온도 $T\_{\text{ext}}$는 완벽하게 똑같아야 한다. 하지만 현실에는 수학적 모델이 담아내지 못하는 노이즈와 센서 자체의 노이즈도 존재하기 때문에, 이 두 값 사이에는 항상 오차가 발생하게 된다.

![fig1](Math/Signal_System/Kalman_Filter2-1.png){: style="display:block; margin:0 auto; width:40%;"}
_[[출처: MATLAB]](https://www.youtube.com/watch?v=4OerJmPpkRg)_

이 오차를 줄이기 위해 피드백 루프를 설계한다.

우리는 오차 $T_{\text{ext}}-\hat{T}_{\text{ext}}$를 다시 모델로 되돌려 보내고, 이를 바탕으로 모델 내부의 상태를 다시 수정한다.
<br>
이 피드백 과정을 여러 번 반복하면서, 모델은 오차를 0으로 만들기 위해 스스로를 계속 보정한다. 그 결과 모델이 예측한 외부 온도가 실제 외부 온도에 점차 가까워지게 된다.

마침내 $T_{\text{ext}}\approx\hat{T}_{\text{ext}}$가 되는 순간, 모델 내부에서 외부 온도와 함께 계산되고 있던 내부 온도 $\hat{T}\_{\text{in}}$ 또한 우리가 알고 싶어 했던 진짜 내부 온도 $T\_{\text{in}}$와 완벽하게 일치하게 된다.

이때 오차를 0으로 만들기 위해 모델을 수정하는 피드백 과정에서, <span style="background-color:#fff5b1">오차를 얼마나 강하게 반영할 것인지를 결정하는 Kalman Gain $K$를 최적으로 계산해 주는 알고리즘이 칼만 필터이다.</span>

![fig2](Math/Signal_System/Kalman_Filter2-2.png){: style="display:block; margin:0 auto; width:40%;"}
_[[출처: MATLAB]](https://www.youtube.com/watch?v=4OerJmPpkRg)_

즉, 아래와 같이 요약할 수 있다.

1. 우리는 $T_{\text{in}}$을 알고 싶지만 직접 측정할 수 없고, 대신 $W_{\text{fuel}}$과 $T_{\text{ext}}$를 알고 있다.
2. 우리는 $W_{\text{fuel}}$을 입력하면 $\hat{T}\_{\text{in}}$과 $\hat{T}\_{\text{ext}}$을 계산해주는 수학적 모델을 가지고 있다.
3. 하지만 수학적 모델은 이상적인 상황을 가지고 설계되었기 때문에, 예측값 $\hat{T}\_{\text{ext}}$과 측정값 $T\_{\text{ext}}$에는 항상 오차가 발생하게 된다.
4. 우리는 피드백 루프를 통해, 수학적 모델이 $\hat{T}\_{\text{ext}}\approx T\_{\text{ext}}$가 되도록 내부 상태를 계속 보정한다.
5. 마침내 $\hat{T}\_{\text{ext}}\approx T\_{\text{ext}}$가 달성되면, 이때 수학적 모델이 계산한 $\hat{T}\_{\text{in}}$ 또한 현실의 $T\_{\text{in}}$에 수렴하게 된다.

## 수학적 알고리즘

블랙박스로 표현되어 있던 블록도를 구체적으로 표현하면 아래와 같다.

![fig3](Math/Signal_System/Kalman_Filter2-3.png){: style="display:block; margin:0 auto; width:100%;"}

위 블록도에서 $\hat{x}\_k^-=A\hat{x}_{k-1}+Bu\_k$를 상태 방정식, $\hat{z}\_k=H\hat{x}\_k^-$를 관측 방정식이라고 한다.

- **상태 방정식:** 과거의 추정된 내부 상태와 현재의 외부 입력을 통해, 현재의 내부 상태를 예측하는 수식
- **관측 방정식:** 보이지 않는 내부 상태값을 우리가 실제로 읽을 수 있는 센서 측정값의 형태로 변환해 주는 수식

위의 블록도를 바탕으로, 칼만 필터의 전체 동작 알고리즘을 도식화하면 아래와 같다.
<br>
그림에서 볼 수 있듯이, 칼만 필터는 예측 단계와 보정 단계를 끊임없이 반복하는 구조로 이루어져 있다.

![fig4](Math/Signal_System/Kalman_Filter2-4.png){: style="display:block; margin:0 auto; width:100%;"}

- **예측 단계:** 모델이 과거의 상태를 바탕으로 현재의 상태를 예측하는 단계
- **보정 단계:** 실제 센서 측정값을 반영해 모델의 예측값과 센서의 측정값 사이의 오차를 줄여나가는 단계

### 예측 (Prediction) 단계

예측 단계에서는 센서의 측정값을 확인하기 전에, 모델이 과거의 상태와 외부 입력값만을 사용하여 현재의 상태를 미리 계산한다.

먼저, 우리가 알 수 없는 진짜 상태 $x_k$는 시스템 노이즈 $w_k$의 영향을 받으며 움직인다. 따라서 시스템의 상태 방정식은 다음과 같이 표현된다.

$$
{x}_k=A{x}_{k-1}+Bu_k+w_k~~,~~w_k\sim\mathcal{N}(0,Q)
\tag{1}
$$

위 식에서 $w_k$를 프로세스 노이즈 (Process noise)라고 부르며, 칼만 필터에서는 평균이 $0$, 분산이 $Q$인 가우시안 분포를 따른다고 가정한다.

일반적으로 우리는 미래를 예측할 때, 기댓값을 사용한다.
<br>
앞서 프로세스 노이즈의 평균을 0이라고 가정했기 때문에 모델의 상태 방정식을 다음과 같이 정의할 수 있다.

$$
\hat{x}_k^-=A\hat{x}_{k-1}+Bu_k
\tag{2}
$$

$\hat{x}_k^-$는 실제 측정값을 반영하기 전에 모델의 미리 예측해본 값이기 때문에, 이 값을 사전 상태 측정값 (A priori state estimate)이라고 표현한다.

칼만 필터에서는 이렇게 모델의 상태 방정식에서는 노이즈를 빼는 대신, 오차 공분산 $P_k$ 예측식에 프로세스 노이즈의 불확실성 $Q$를 더한다.

$$
P_k^-=AP_{k-1}A^\top+Q
\tag{3}
$$

마찬가지로 $P_k^-$ 또한 사전 오차 공분산 (A priori error covariance)이라고 부른다.

아래 그림은 시간에 따른 자동차의 위치 $x$를 나타낸 것이다.
<br>
$\hat{x}\_{k}^-$는 모델이 예측한 자동차의 현재 위치이며, $P\_k^-$는 그 예측된 위치의 불확실성을 나타낸다. (자동차의 위치가 실제로 존재할 수 있는 범위)

![fig5](Math/Signal_System/Kalman_Filter2-5.png){: style="display:block; margin:0 auto; width:90%;"}
_[[출처: MATLAB]](https://www.youtube.com/watch?v=VFXf1lIZ3p8)_

### 보정 (Update) 단계

보정 단계에서는 새롭게 들어온 센서 측정값을 활용하여 예측 단계에서 구한 사전 예측값을 수정하고 보완한다.

먼저, 센서 또한 물리적/기술적 한계로 인해 완벽하게 값을 읽어낼 수 없다. 따라서 시스템의 관측 방정식 역시 노이즈를 포함해 다음과 같이 표현된다.

$$
z_k=Hx_k+v_k~~,~~v_k\sim\mathcal{N}(0,R)
\tag{4}
$$

위 식에서 $v_k$를 측정 노이즈 (Measurement Noise)라고 부르며, 칼만 필터에서는 평균이 $0$, 분산이 $R$인 가우시안 분포를 따른다고 가정한다.

현재 예측 단계에서의 불확실성 $P_k^-$와 보정 단계에서의 불확실성 $R$이 존재하는 상황에서, 우리는 둘 중 어느 것을 더 신뢰할지 결정해야 한다.
<br>
이 딜레마를 해결해 주는 것이 칼만 이득 (Kalman Gain) $K_k$이며, 다음과 같이 정의된다.

$$\vphantom{\Big(}
K_k=P_k^-H^\top(HP_k^-H^\top+R)^{-1}
\tag{5}
$$

칼만 이득은 모델의 예측 불확실성 $P_k^-$와 센서의 측정 불확실성 $R$ 중 어느 것을 더 신뢰할지 결정하는 가중치 역할을 한다. 
<br>
센서 노이즈가 작다면 측정값에, 모델 오차가 작다면 예측값에 더 큰 비중을 두게 된다.

계산된 칼만 이득 $K_k$와 실제 센서 측정값 $z_k$를 결합하여, 최종적인 사후 상태 추정치 (A posteriori state estimate) $\hat{x}_k$를 계산한다.

$$
\hat{x}_k=\hat{x}_k^-+K_k(z_k-H\hat{x}_k^-)
\tag{6}
$$

위 수식에서 $z_k - H\hat{x}_k^-$ 부분은 실제 센서 측정값 $z_k$와 모델이 예상한 측정값 $\hat{z}_k=H\hat{x}_k^-$ 간의 차이인 잔차 (Residual)를 의미한다. 즉, 이 잔차에 칼만 이득이라는 가중치를 곱하여 기존의 예측값을 보정하는 형태이다.

> **여기서 왜 $K_k$가 가중치 역할을 할까?**
> 
> 단위를 맞춰주는 행렬 $H$를 단위 행렬 $I$라고 가정해 보자.
> 
> 그러면 식 (5)의 역행렬 연산이 다음과 같이 단순한 나눗셈으로 바뀐다.
> 
> $$K=\frac{P}{P+R}$$
> 
> 공식을 보면, $K$는 전체 불확실성 중에서 모델 자신의 불확실성이 차지하는 비율을 의미한다.
> 
> 식 (6) 또한 다음과 같이 정리할 수 있다.
> 
> $$\hat{x}_k=\hat{x}_k^-+K_k(z_k-\hat{x}_k^-)=(1-K_k)\hat{x}_k^-+K_kz_k$$
> 
> 이는 가중 평균 형태로, $K$는 센서 측정값을 믿는 가중치, $(1 - K)$는 모델 자신의 예측값을 믿는 가중치로 작동한다.
> 
> 즉, <span style="background-color:#fff5b1">Kalman gain $K$가 커질수록 모델은 센서의 측정값을 더 신뢰하고, 작아질수록 모델 자신의 예측값을 더 신뢰하게 된다.</span>

센서 측정값을 반영하여 현재 상태를 보정했으므로, 예측의 불확실성 또한 이전보다 줄어들게 된다. 이를 반영하여 최종적인 사후 오차 공분산 $P_k$를 계산한다.

$$
P_k=(I-K_kH)P_k^-
\tag{7}
$$

위 수식을 보면, Kalman gain이 커질수록 오차 공분산이 줄어드는 형태이다.
<br>
즉, 센서의 측정값을 100% 신뢰하면 불확실성을 $0$으로 만들고, 센서의 측정값을 전혀 신뢰할 수 없다면 불확실성을 그대로 유지한다.

이렇게 보정된 $\hat{x}_k$와 $P_k$는 다음 스텝의 예측 단계를 위한 이전 값으로 전달되면서 재귀적인 루프를 형성한다.

아래 그림에서 $z_k$는 GPS와 같은 실제 센서를 통해 측정한 자동차의 위치를 의미한다.
<br>
칼만 필터를 거쳐 최종적으로 예측한 자동차의 위치 $\hat{x}_k$는, 모델이 예측한 위치 $\hat{x}_k^-$와 센서가 측정한 위치 $z_k$ 사이의 조율된 지점에 형성된다.

![fig6](Math/Signal_System/Kalman_Filter2-6.png){: style="display:block; margin:0 auto; width:90%;"}
_[[출처: MATLAB]](https://www.youtube.com/watch?v=VFXf1lIZ3p8)_

전체 과정을 그림으로 나타내면 아래와 같다.

![fig7](Math/Signal_System/Kalman_Filter2-7.png){: style="display:block; margin:0 auto; width:90%;"}_출처: [Notes on Kalman Filter (KF, EKF, ESKF, IEKF, IESKF))](https://arxiv.org/abs/2406.06427)_
