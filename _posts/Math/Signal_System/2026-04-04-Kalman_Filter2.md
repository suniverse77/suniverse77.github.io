---
title: "[신호 및 시스템] 칼만 필터 2 - 알고리즘"
date: 2026-04-01 06:00:00 +/-TTTT
categories: [Mathmatics, 신호 및 시스템]
tags: [신호 및 시스템]
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

![fig3](Math/Signal_System/Kalman_Filter1-3.png){: style="display:block; margin:0 auto; width:50%;"}
_[[출처: MATLAB]](https://www.youtube.com/watch?v=4OerJmPpkRg)_

이 오차를 줄이기 위해 피드백 루프를 설계한다.

우리는 오차 $T_{\text{ext}}-\hat{T}_{\text{ext}}$를 다시 모델로 되돌려 보내고, 이를 바탕으로 모델 내부의 상태를 다시 수정한다.
<br>
이 피드백 과정을 여러 번 반복하면서, 모델은 오차를 0으로 만들기 위해 스스로를 계속 보정한다. 그 결과 모델이 예측한 외부 온도가 실제 외부 온도에 점차 가까워지게 된다.

마침내 $T_{\text{ext}}\approx\hat{T}_{\text{ext}}$가 되는 순간, 모델 내부에서 외부 온도와 함께 계산되고 있던 내부 온도 $\hat{T}\_{\text{in}}$ 또한 우리가 알고 싶어 했던 진짜 내부 온도 $T\_{\text{in}}$와 완벽하게 일치하게 된다.

이때 오차를 0으로 만들기 위해 모델을 수정하는 피드백 과정에서, <span style="background-color:#fff5b1">오차를 얼마나 강하게 반영할 것인지를 결정하는 Kalman Gain $K$를 최적으로 계산해 주는 알고리즘이 칼만 필터이다.</span>

![fig4](Math/Signal_System/Kalman_Filter1-4.png){: style="display:block; margin:0 auto; width:40%;"}
_[[출처: MATLAB]](https://www.youtube.com/watch?v=4OerJmPpkRg)_

즉, 아래와 같이 요약할 수 있다.

1. 우리는 $T_{\text{in}}$을 알고 싶지만 직접 측정할 수 없고, 대신 $W_{\text{fuel}}$과 $T_{\text{ext}}$를 알고 있다.
2. 우리는 $W_{\text{fuel}}$을 입력하면 $\hat{T}\_{\text{in}}$과 $\hat{T}\_{\text{ext}}$을 계산해주는 수학적 모델을 가지고 있다.
3. 하지만 수학적 모델은 이상적인 상황을 가지고 설계되었기 때문에, 예측값 $\hat{T}\_{\text{ext}}$과 측정값 $T\_{\text{ext}}$에는 항상 오차가 발생하게 된다.
4. 우리는 피드백 루프를 통해, 수학적 모델이 $\hat{T}\_{\text{ext}}\approx T\_{\text{ext}}$가 되도록 내부 상태를 계속 보정한다.
5. 마침내 $\hat{T}\_{\text{ext}}\approx T\_{\text{ext}}$가 달성되면, 이때 수학적 모델이 계산한 $\hat{T}\_{\text{in}}$ 또한 현실의 $T\_{\text{in}}$에 수렴하게 된다.

## 수학적 알고리즘

칼만 필터는 크게 예측과 보정의 두 단계를 끊임없이 반복하는 구조로 되어 있다.

![fig1](Math/Signal_System/Kalman_Filter2-1.png){: style="display:block; margin:0 auto; width:100%;"}

### 예측 (Prediction) 단계

예측 단계에서는 센서의 측정값을 얻기 전에, 오직 수학적 모델만을 사용하여 다음 스텝의 상태를 미리 계산한다.

먼저, 우리가 추정하고자 하는 현실 세계의 시스템은 외란 등에 의해 완벽한 수학적 모델로 표현하기 어렵다. 이러한 <span style="background-color:#fff5b1">모델의 불확실성을 프로세스 노이즈 (Process Noise)</span> $w_k$라고 부르며, 실제 시스템의 상태 방정식은 다음과 같이 표현된다.

$$
{x}_k=A{x}_{k-1}+Bu_k+w_k~~,~~w_k\sim\mathcal{N}(0,Q)
$$

하지만 우리의 모델은 미래에 발생할 무작위 노이즈의 정확한 값을 미리 알 수 없다. 노이즈의 기대값이 0으로 가정되므로, 이전 시간의 상태 추정치 $\hat{x}_{k-1}$과 현재의 입력값 $u_k$를 기반으로 현재 상태를 예측하는 수식에서는 $w_k$가 0으로 소거된다. 실제 측정이 반영되기 전의 이 값을 사전 상태 추정치 (A priori state estimate) $\hat{x}_k^-$라고 표현한다.

$$
\hat{x}_k^-=A\hat{x}_{k-1}+Bu_k
$$

상태를 예측하는 것과 동시에, 그 예측이 얼마나 불확실한지도 함께 계산해야 한다. 상태 추정 수식에서 소거되었던 프로세스 노이즈가 유발하는 시스템의 불확실성 $Q$는 이 오차 공분산 예측 수식에 반영되어 알고리즘에 영향을 미치게 된다.

즉, 이전 단계의 불확실성 $P_{k-1}$이 시간에 따라 어떻게 전파되는지 계산하고, 여기에 모델 자체가 가지는 내재적 불확실성인 프로세스 노이즈의 공분산 $Q$를 더해 사전 오차 공분산 $P_k^-$를 구한다.

$$
P_k^-=AP_{k-1}A^\top+Q
$$

아래 그림에서 $\hat{x}\_{k}^-$는 수학적 모델을 통해 자동차가 이전 위치 $\hat{x}\_{k-1}$에서 이동할 다음 위치를 예측한 값이며, $P\_k^-$는 그 예측된 위치가 실제로 존재할 수 있는 오차 범위를 의미한다.

![fig2](Math/Signal_System/Kalman_Filter2-2.png){: style="display:block; margin:0 auto; width:90%;"}
_[[출처: MATLAB]](https://www.youtube.com/watch?v=VFXf1lIZ3p8)_

### 보정 (Update) 단계

보정 단계에서는 새롭게 들어온 센서 측정값을 활용하여 앞서 구한 사전 예측값을 수정하고 보완한다.

먼저, 센서 또한 물리적/기술적 한계로 인해 완벽하게 정확한 값을 읽어낼 수 없다. 이러한 <span style="background-color:#fff5b1">센서의 불확실성을 측정 노이즈 (Measurement Noise)</span> $v_k$라고 부르며, 실제 센서의 측정 방정식은 다음과 같이 표현된다.

$$
z_k=Hx_k+v_k~~,~~v_k\sim\mathcal{N}(0,R)
$$

이러한 불확실성 속에서 최적의 추정치를 찾기 위해, 가장 먼저 칼만 이득 (Kalman Gain) $K_k$를 계산해야 한다.

$$\vphantom{\Big(}
K_k=P_k^-H^\top(HP_k^-H^\top+R)^{-1}
$$

칼만 이득은 모델의 예측 불확실성 $P_k^-$와 센서의 측정 불확실성 $R$ 중 어느 것을 더 신뢰할지 결정하는 가중치 역할을 한다. 센서 노이즈가 작다면 측정값에, 모델 오차가 작다면 예측값에 더 큰 비중을 두게 된다.

계산된 칼만 이득 $K_k$와 실제 센서 측정값 $z_k$를 결합하여 최종적인 사후 상태 추정치 (A posteriori state estimate) $\hat{x}_k$를 도출한다.

$$
\hat{x}_k=\hat{x}_k^-+K_k(z_k-H\hat{x}_k^-)
$$

위 수식에서 $z_k - H\hat{x}_k^-$ 부분은 실제 센서 측정값 $z_k$와 모델이 예상한 측정값 $\hat{z}_k=H\hat{x}_k^-$ 간의 차이인 잔차 (Residual)를 의미한다. 즉, 이 잔차에 칼만 이득이라는 가중치를 곱하여 기존의 예측값을 보정하는 형태이다.

센서 측정값을 반영하여 현재 상태를 업데이트했으므로, 추정의 불확실성 또한 이전보다 줄어들게 된다. 이를 반영하여 최종적인 사후 오차 공분산 $P_k$를 계산한다.

$$
P_k=(I-K_kH)P_k^-
$$

이렇게 업데이트된 $\hat{x}_k$와 $P_k$는 다음 스텝의 예측 단계를 위한 이전 값으로 전달되면서 재귀적인 루프를 형성한다.

아래 그림에서 $z_k$는 GPS와 같은 실제 센서를 통해 측정한 자동차의 위치를 의미한다. 칼만 필터를 거쳐 최종적으로 계산된 최적의 위치 $\hat{x}_k$는, 모델이 예측한 위치 $\hat{x}_k^-$와 센서가 측정한 위치 $z_k$ 사이의 조율된 지점에 형성된다.

![fig3](Math/Signal_System/Kalman_Filter2-3.png){: style="display:block; margin:0 auto; width:90%;"}
_[[출처: MATLAB]](https://www.youtube.com/watch?v=VFXf1lIZ3p8)_
