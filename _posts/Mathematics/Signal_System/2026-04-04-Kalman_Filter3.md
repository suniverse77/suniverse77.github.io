---
title: "[칼만 필터] Kalman Filter 3 - 확률 분포 관점"
date: 2026-04-04 12:00:00 +/-TTTT
categories: [Mathmatics, 신호 및 시스템]
tags: [칼만 필터]
math: true
toc: true
author: sunho
---

> 해당 포스터 내용은 ['선형 칼만 필터의 원리 이해'](https://gaussian37.github.io/ad-ose-lkf_basic/) 블로그를 참고하였습니다.

## 자동차 주행 예시

엑셀을 통해 자동차에 가속도 $a$가 가해지며, 우리는 자동차의 현재 위치 $p$와 속도 $v$를 알고 싶다고 가정해 보자.
<br>
그리고 자동차에 GPS와 속도계가 모두 장착되어 있어, 센서를 통해 위치 정보와 속도 정보를 함께 측정할 수 있다고 해보자.

![fig1](Math/Signal_System/Kalman_Filter3-1.png){: style="display:block; margin:0 auto; width:70%;"}

이 시스템에서 우리가 추정해야 할 상태 벡터 $\mathbf{x}_t$와 시스템에 가해지는 제어 입력 $u_t$는 다음과 같이 정의된다.

$$
u_t=a~~,~~\hat{\mathbf{x}}_t=\begin{bmatrix}\hat{p}_t\\\hat{v}_t\end{bmatrix}
\tag{1}
$$

뉴턴의 운동 법칙에 따라, $\Delta t$동안 변화한 현재 위치 $p_t$와 속도 $v_t$ 방정식은 다음과 같이 정의된다.

$$
\begin{aligned}
\hat{p}_t&=\hat{p}_{t-1}+\hat{v}_{t-1}\Delta t+\frac{1}{2}a\Delta t^2
\\
\hat{v}_t&=\hat{v}_{t-1}+a\Delta t
\end{aligned}
\tag{2}
$$

이 물리 방정식을 하나의 행렬로 표현하면 다음과 같은 상태 방정식으로 나타낼 수 있다.

$$
\hat{\mathbf{x}}_t=A\hat{\mathbf{x}}_{t-1}+Bu_t
~~\rightarrow~~
\begin{bmatrix}\hat{p}_t\\\hat{v}_t\end{bmatrix}
=\begin{bmatrix}1&\Delta t\\0&1\end{bmatrix}\begin{bmatrix}\hat{p}_{t-1}\\\hat{v}_{t-1}\end{bmatrix}
+\begin{bmatrix}\frac{1}{2}\Delta t^2\\\Delta t\end{bmatrix}a
\tag{3}
$$

그리고 측정값 또한 다음과 같은 관측 방정식으로 나타낼 수 있다.

$$
\hat{\mathbf{z}}_t=H\hat{\mathbf{x}}_t^-
~~\rightarrow~~
\mathbf{z}_t=\begin{bmatrix}1&0\\0&1\end{bmatrix}\begin{bmatrix}\hat{p}_t\\\hat{v}_t\end{bmatrix}
\tag{4}
$$

전체적인 시스템의 데이터 흐름을 블록도로 나타내면 아래와 같다.

![fig2](Math/Signal_System/Kalman_Filter3-2.png){: style="display:block; margin:0 auto; width:70%;"}

### 예측 단계

실제 주행 환경에서는 타이어의 미끄러짐, 바람 등 모델에 반영되지 않은 외란이 존재한다. 
<br>
따라서 모델을 통해 예측한 자동차의 상태는 하나의 점이 될 수 없으며, 아래의 오른쪽 그림과 같이 오차 범위를 가지는 확률 분포 형태로 나타나게 된다.

![fig3](Math/Signal_System/Kalman_Filter3-3.png){: style="display:block; margin:0 auto; width:70%;"}

위 그림을 보면 과거의 예측 상태 $\hat{\mathbf{x}}\_{t-1}^-$보다 현재 예측한 상태 $\hat{\mathbf{x}}\_{t}^-$의 불확실성이 더 커진 것을 확인할 수 있는데, 이는 매순간 모델이 알지 못하는 현실의 노이즈가 계속해서 누적되기 때문이다.

이러한 현상을 반영하여, 예측 단계에서 불확실성이 얼마나 커졌는지를 계산하는 수식이 아래의 오차 공분산 예측식이다.

$$
P_t^-=AP_{t-1}A^\top+Q_t
\tag{5}
$$

이 식에서 기존의 오차 $AP_{t-1}A^\top$에 새롭게 더해지는 $Q_t$가 현실의 외란을 의미하는 프로세스 노이즈 공분산 (Process Noise Covariance)이다.
<br>
위치와 속도를 예측하는 현재 상황에서, $Q$는 다음과 같이 표현될 수 있다.

$$
Q=\begin{bmatrix}\Sigma_{pp}&\Sigma_{pv}\\\Sigma_{vp}&\Sigma_{vv}\end{bmatrix}
\tag{6}
$$

### 보정 단계

센서의 측정값 $\mathbf{z}_t$를 사용하기 위해, 우리가 예측한 prior state $\hat{\mathbf{x}}_t^-$를 센서와 동일한 차원 (관측 공간)으로 변환해야 한다.
이를 위해 관측 행렬 $H$를 사용한다.

$$
\hat{\mathbf{z}}_t=H\hat{\mathbf{x}}_t^-
\tag{7}
$$

![fig4](Math/Signal_System/Kalman_Filter3-4.png){: style="display:block; margin:0 auto; width:70%;"}

실제 센서 측정값 역시 센서 자체의 물리적 노이즈를 포함하고 있기 때문에, 아래의 그림과 같이 확률 분포의 형태로 나타나게 된다.

![fig5](Math/Signal_System/Kalman_Filter3-5.png){: style="display:block; margin:0 auto; width:30%;"}

이제 우리는 모델이 예측한 분포 (보라색)와 센서가 측정한 분포 (초록색)를 통해서, 가장 최적의 상태값을 찾아야 한다.

![fig6](Math/Signal_System/Kalman_Filter3-6.png){: style="display:block; margin:0 auto; width:40%;"}

확률 분포의 관점에서 볼 때, 예측값 $\hat{\mathbf{z}}_t$와 측정값 $\mathbf{z}_t$ 사이의 오차를 최소화하는 과정은, 두 분포가 겹쳐서 만들어지는 새로운 확률 분포에서 확률이 가장 높은 꼭대기 지점을 찾는 것과 같다.

이때 모델의 예측 노이즈와 센서의 측정 노이즈는 서로 독립적으로 발생한다.
<br>
확률론에서 두 독립적인 확률 분포의 교집합은 두 확률의 곱으로 계산되므로, 예측 분포와 측정 분포의 확률 밀도 함수를 곱해서 새로운 분포를 만들 수 있다.

앞서 관측 행렬 $H$를 통해 내부 상태 $\mathbf{x}$와 센서 측정값 $\mathbf{z}$를 수식적으로 연결해 두었기 때문에, <span style="background-color:#fff5b1">$\mathbf{z}$의 오차를 최소화하는 과정은 곧 $\mathbf{x}$의 오차를 줄이는 결과로 직결된다.</span>

따라서 이렇게 두 분포를 곱해 만들어진 새로운 분포의 꼭대기 지점이, 우리가 최종적으로 찾고자 하는 최적의 상태 예측값 $\hat{\mathbf{x}}_t$가 된다.

### Kalman filter와 Kalman gain 정의

위에서 2차원 가우시안 분포를 예시로 들었지만, 계산의 편의성을 위해 1차원 가우시안 분포로 유도한 뒤 2차원으로 확장할 것이다.

모델의 예측이 평균 $\mu_0$, 분산 $\sigma_0^2$인 가우시안 분포를, 센서의 측정이 평균 $\mu_1$, 분산 $\sigma_1^2$인 가우시안 분포를 따른다고 가정하자.

두 분포의 확률 밀도 함수를 곱하여 새로운 분포의 평균 $\mu'$과 분산 $\sigma'^2$을 찾을 것이다.

$$
\mathcal{N}(\mu', \sigma'^2) = \mathcal{N}(\mu_0, \sigma_0^2) \times \mathcal{N}(\mu_1, \sigma_1^2)
\tag{8}
$$

가우시안 분포의 수식은 지수 함수의 형태를 띠므로, 두 함수를 곱하면 지수끼리의 덧셈이 된다.

$$
\mu' = \frac{\mu_0 \sigma_1^2 + \mu_1 \sigma_0^2}{\sigma_0^2 + \sigma_1^2}
~~~,~~~
\sigma'^2 = \frac{\sigma_0^2 \sigma_1^2}{\sigma_0^2 + \sigma_1^2}
\tag{9}
$$

위의 두 수식에는 공통적으로 반복되는 $\frac{\sigma_0^2}{\sigma_0^2 + \sigma_1^2}$ 부분이 있다. 이 부분을 $k$ 라는 변수로 치환해 보자.

$$
k = \frac{\sigma_0^2}{\sigma_0^2 + \sigma_1^2}
\tag{10}
$$

$k$를 이용해 식 (9)를 다시 정리하면 다음과 같다.

$$
\mu'=\mu_0 + k(\mu_1-\mu_0)=(1-k)\mu_0+k\mu_1
\tag{11}
$$

$$
\sigma'^2 = \sigma_0^2 - k\sigma_0^2 = (1 - k)\sigma_0^2
\tag{12}
$$

식 (11)을 보면, 새로운 분포의 평균 $\mu'$은 두 분포의 평균의 가중합으로 계산되는 것을 볼 수 있다.

이러한 결합 과정을 통해 도출된 상태 업데이트 알고리즘을 칼만 필터라고 부르며, 이때 두 데이터 사이의 신뢰도 가중치를 조율하는 비율 $k$를 칼만 이득 (Kalman Gain)이라고 정의하였다.

이제 1차원 분포에 대한 수식을 다차원 분포로 확장하면, 기존의 변수들을 다음과 같이 매핑할 수 있다.

- 모델의 예측치 평균: $\mu_0$ $\rightarrow\hat{\mathbf{x}}_k^-$
- 모델의 예측치 분산: $\sigma_0^2$ $\rightarrow P_k^-$
- 센서의 측정치 평균: $\mu_1$ $\rightarrow z_k$
- 센서의 측정치 분산: $\sigma_1^2\rightarrow R$
- Kalman gain: $k\rightarrow K_k$

변수들이 다차원 공간에 존재한다면, 내부 상태 $\mathbf{x}$와 측정값 $\mathbf{z}$의 차원이 다를 수도 있다.
<br>
따라서 다른 공간에 존재하는 변수의 차원을 맞춰주기 위해 관측 행렬 $H$를 도입한다.

- Kalman gain

    $$
    k = \frac{\sigma_0^2}{\sigma_0^2 + \sigma_1^2}
    ~~~\rightarrow~~~
    K_k=P_t^- H^\top(H P_t^- H^\top + R)^{-1}
    \tag{13}
    $$

- 상태 업데이트

    $$
    \mu' = \mu_0 + k(\mu_1 - \mu_0)
    ~~~\rightarrow~~~
    \hat{\mathbf{x}}_k = \hat{\mathbf{x}}_k^- + K_k(z_k - H\hat{\mathbf{x}}_k^-)
    \tag{14}
    $$

- 오차 공분산 업데이트 

    $$
    \sigma'^2 = \sigma_0^2 - k\sigma_0^2 = (1 - k)\sigma_0^2
    ~~~\rightarrow~~~
    P_k = (I - K_k H)P_k^-
    \tag{15}
    $$
