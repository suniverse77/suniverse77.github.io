---
title: "[신호 및 시스템] 칼만 필터의 수학적 원리"
date: 2026-04-01 06:00:00 +/-TTTT
categories: [Mathmatics, 신호 및 시스템]
tags: [신호 및 시스템]
math: true
toc: true
author: sunho
---

칼만 필터는 크게 예측과 보정의 두 단계를 끊임없이 반복하는 구조로 되어 있다.

![fig1](Math/Signal_System/Kalman_Filter2-1.png){: style="display:block; margin:0 auto; width:70%;"}

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

### 예시

자동차에 가속도 $a$가 가해지며, 우리는 자동차의 현재 위치 $p$와 속도 $v$를 알고 싶다고 가정해보자.

![fig4](Math/Signal_System/Kalman_Filter2-4.png){: style="display:block; margin:0 auto; width:70%;"}

그렇다면 상태 변수는 아래와 같이 정의될 수 있다.

$$
u=a~~,~~\mathbf{x}=\begin{bmatrix}p\\v\end{bmatrix}
$$

뉴턴의 운동 법칙에 따라 방정식은 아래와 같이 정의된다.

$$
p_t=p_{t-1}+v_{t-1}\Delta t+\frac{1}{2}a\Delta t^2
$$

$$
v_t=v_{t-1}+a\Delta t
$$

이를 $\hat{x}\_k^-=A\hat{x}\_{k-1}+Bu\_k$ 형태로 나타내면 아래와 같다.

$$
\begin{bmatrix}p_t\\v_t\end{bmatrix}
=\begin{bmatrix}1&\Delta t\\0&1\end{bmatrix}\begin{bmatrix}p_{t-1}\\v_{t-1}\end{bmatrix}
+\begin{bmatrix}\frac{1}{2}a\Delta t^2\\\Delta t\end{bmatrix}a
$$

또한 현재 GPS만 장착하고 있어서 센서가 위치 정보만 알려주고 속도 정보는 알려주지 않는다면, 측정값 $z$는 단일 스칼라값이 된다.

$$
z=\begin{bmatrix}1&0\end{bmatrix}\begin{bmatrix}p\\v\end{bmatrix}=p
$$

![fig5](Math/Signal_System/Kalman_Filter2-5.png){: style="display:block; margin:0 auto; width:50%;"}
