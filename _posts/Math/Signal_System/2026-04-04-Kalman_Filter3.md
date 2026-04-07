---
title: "[신호 및 시스템] 칼만 필터 유도"
date: 2026-04-01 12:00:00 +/-TTTT
categories: [Mathmatics, 신호 및 시스템]
tags: [신호 및 시스템]
math: true
toc: true
author: sunho
---

## 자동차 주행 예시

> 해당 블로그 내용은 ['선형 칼만 필터의 원리 이해'](https://gaussian37.github.io/ad-ose-lkf_basic/) 블로그를 참고하였습니다.

자동차에 가속도 $a$가 가해지며, 우리는 자동차의 현재 위치 $p$와 속도 $v$를 알고 싶다고 가정해 보자.

![fig4](Math/Signal_System/Kalman_Filter2-4.png){: style="display:block; margin:0 auto; width:70%;"}

이 시스템에서 우리가 추정해야 할 상태 벡터 $\mathbf{x}_t$와 시스템에 가해지는 제어 입력 $u_t$는 다음과 같이 정의된다.

$$
u_t=a~~,~~\mathbf{x}_t=\begin{bmatrix}p_t\\v_t\end{bmatrix}
$$

뉴턴의 운동 법칙에 따라, $\Delta t$동안 변화한 현재 위치 $p_t$와 속도 $v_t$ 방정식은 다음과 같이 정의된다.

$$
p_t=p_{t-1}+v_{t-1}\Delta t+\frac{1}{2}a\Delta t^2
$$

$$
v_t=v_{t-1}+a\Delta t
$$

이 물리 방정식을 칼만 필터의 예측 수식인 $\hat{x}\_k^-=A\hat{x}\_{k-1}+Bu\_k$ 형태의 행렬식으로 변환하면 다음과 같다.

$$
\begin{bmatrix}p_t\\v_t\end{bmatrix}
=\begin{bmatrix}1&\Delta t\\0&1\end{bmatrix}\begin{bmatrix}p_{t-1}\\v_{t-1}\end{bmatrix}
+\begin{bmatrix}\frac{1}{2}\Delta t^2\\\Delta t\end{bmatrix}a
$$

또한 만약 자동차에 GPS와 속도계가 모두 장착되어 있어 센서가 위치 정보와 속도 정보를 함께 알려준다면, 측정값 $\mathbf{z}_t$는 상태 벡터와 동일한 2차원 벡터가 된다 이를 관측 수식 $z_k = Hx_k$으로 나타내면 다음과 같다.

$$
\mathbf{z}_t=\begin{bmatrix}1&0\\0&1\end{bmatrix}\begin{bmatrix}p_t\\v_t\end{bmatrix}
$$

전체적인 시스템의 데이터 흐름을 블록도로 나타내면 아래와 같다.

![fig5](Math/Signal_System/Kalman_Filter2-5.png){: style="display:block; margin:0 auto; width:70%;"}

### 예측 단계

실제 주행 환경에서는 타이어의 미끄러짐, 바람 등 모델에 반영되지 않은 외란이 존재한다. 따라서 다음 시점의 상태를 예측할 때, 자동차의 위치와 속도는 단순히 점에서 점으로 이동하는 것이 아니라 (아래의 왼쪽 그림), 불확실성을 동반한 확률 분포 형태로 이동한다. (아래의 오른쪽 그림)

![fig6](Math/Signal_System/Kalman_Filter2-6.png){: style="display:block; margin:0 auto; width:70%;"}

이러한 불확실성이 추가되면서 예측의 오차 공분산은 $P_t^- = AP_{t-1}A^\top + Q$ 형태로 계산되어 불확실성 영역이 더욱 넓어지게 된다.

이때 더해지는 프로세스 노이즈 공분산 행렬 $Q$는 다음과 같이 나타낼 수 있다.

$$
Q=\begin{bmatrix}\Sigma_{pp}&\Sigma_{pv}\\\Sigma_{vp}&\Sigma_{vv}\end{bmatrix}
$$

### 보정 단계

센서로 측정한 값 $z_t$를 사용하기 전에, 먼저 우리가 추정한 prior state $\mathbf{x}_t^-$를 센서와 동일한 차원 (관측 공간)으로 변환해야 한다.

$$
\hat{\mathbf{z}}_t=H\mathbf{x}_t^-
$$

![fig7](Math/Signal_System/Kalman_Filter2-7.png){: style="display:block; margin:0 auto; width:70%;"}

실제 센서 측정값 역시 센서 자체의 물리적 노이즈를 포함하고 있다. 따라서 측정 노이즈 공분산 $R$을 가지는 확률 분포 (아래 그림의 초록색 타원) 형태로 존재하게 된다.

![fig8](Math/Signal_System/Kalman_Filter2-8.png){: style="display:block; margin:0 auto; width:70%;"}

이제 우리는 두 가지 분포를 융합해서 가장 진짜 위치일 확률이 높은 최적의 점 을 찾아야 한다.

이제 우리는 모델이 예측한 분포 (보라색)와 센서가 측정한 분포 (초록색)라는 두 가지 불확실한 정보를 융합하여, 진짜 상태일 확률이 가장 높은 최적의 추정치를 찾아야 한다.

기하학적으로 보면 두 분포가 겹치는 교집합 영역 (하얀색 타원)이 두 가지 조건을 모두 만족할 확률이 가장 높은 곳이다.

확률론적으로 두 독립적인 확률 분포의 교집합은 두 확률 밀도 함수의 곱셈으로 계산되며, 이 하얀색 타원의 중심이 바로 우리가 찾는 최종 사후 상태 추정치 $\hat{\mathbf{x}}_k$가 된다.

### Kalman gain 유도

위에서 2차원 가우시안 분포를 예시로 들었지만, 계산의 편의성을 위해 1차원 가우시안 분포로 유도한 뒤 2차원으로 확장할 것이다.

모델의 예측이 평균 $\mu_0$, 분산 $\sigma_0^2$인 가우시안 분포를, 센서의 측정이 평균 $\mu_1$, 분산 $\sigma_1^2$인 가우시안 분포를 따른다고 가정하자.

두 분포의 확률 밀도 함수를 곱하여 새로운 분포의 평균 $\mu'$과 분산 $\sigma'^2$을 찾을 것이다.

$$
\mathcal{N}(\mu', \sigma'^2) = \mathcal{N}(\mu_0, \sigma_0^2) \times \mathcal{N}(\mu_1, \sigma_1^2)
$$

가우시안 분포의 수식은 지수 함수의 형태를 띠므로, 두 함수를 곱하면 지수끼리의 덧셈이 된다.

$$
\mu' = \frac{\mu_0 \sigma_1^2 + \mu_1 \sigma_0^2}{\sigma_0^2 + \sigma_1^2}
~~~,~~~
\sigma'^2 = \frac{\sigma_0^2 \sigma_1^2}{\sigma_0^2 + \sigma_1^2}
\tag{1}
$$

위의 두 수식에는 공통적으로 반복되는 $\frac{\sigma_0^2}{\sigma_0^2 + \sigma_1^2}$ 부분이 있다. 이 부분을 $k$ 라는 변수로 치환해 보자.

$$
k = \frac{\sigma_0^2}{\sigma_0^2 + \sigma_1^2}
\tag{2}
$$

$k$를 이용해 식 (1)을 수식을 다시 정리하면 다음과 같다.

$$
\mu' = \mu_0 + k(\mu_1 - \mu_0)~~~,~~~
\sigma'^2 = \sigma_0^2 - k\sigma_0^2 = (1 - k)\sigma_0^2
\tag{3}
$$

전개된 식 (3)은 칼만 필터의 상태 업데이트, 분산 업데이트 수식과 동일한 것을 확인할 수 있다.

즉, 식 (2)는 kalman gain인 것이다.

이제 이 놀라운 1차원 수식을 칼만 필터가 사용하는 다차원 행렬과 관측 행렬($H$)이 포함된 형태로 매핑(Mapping)해 보자.기존 평균 $\mu_0$ $\rightarrow$ 사전 상태 추정치 $\hat{\mathbf{x}}_k^-$기존 분산 $\sigma_0^2$ $\rightarrow$ 사전 오차 공분산 $P_k^-$측정 평균 $\mu_1$ $\rightarrow$ 센서 측정값 $z_k$측정 분산 $\sigma_1^2$ $\rightarrow$ 측정 노이즈 공분산 $R$변수 $k$ $\rightarrow$ 칼만 이득 행렬 $K_k$이 변수들을 앞서 유도한 식에 그대로 대입하고, 상태 공간과 관측 공간을 맞춰주기 위한 관측 행렬 $H$를 알맞게 끼워 넣으면 우리가 아는 칼만 필터의 보정(Update) 수식이 완벽하게 유도된다.칼만 이득 ($K_k$):$$K_k = P_k^- H^\top (H P_k^- H^\top + R)^{-1}$$상태 업데이트 ($\hat{\mathbf{x}}_k$):$$\hat{\mathbf{x}}_k = \hat{\mathbf{x}}_k^- + K_k(z_k - H\hat{\mathbf{x}}_k^-)$$오차 공분산 업데이트 ($P_k$):$$P_k = (I - K_k H)P_k^-$$
