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

![fig1](Math/Signal_System/Kalman_Filter2-1.png){: style="display:block; margin:0 auto; width:50%;"}
_[[출처: MATLAB]](https://www.youtube.com/watch?v=4OerJmPpkRg)_

### 예측 (Prediction) 단계

이 단계에서는 센서의 측정값을 보기 전에, 오직 **상태 전이 모델($A, B$)**만을 사용하여 다음 스텝에 시스템이 어디에 있을지 미리 계산한다.

이전 시간의 상태 추정치와 현재의 입력값을 사용하여 시스템 모델을 기반으로 현재 상태를 예측합니다. (이를 **사전 추정치(A priori estimate

$$
\hat{x}_k^-=A\hat{x}_{k-1}+Bu_k
$$



$$
P_k^-=AP_{k-1}A^\top+Q
$$

### 보정 (Update) 단계

- 예측: 이전 상태를 바탕으로 다음 상태를 예측함
- 업데이트: 실제 관측된 데이터를 기반으로 예측된 상태를 수정한다.


### 예시

![fig2](Math/Signal_System/Kalman_Filter2-2.png){: style="display:block; margin:0 auto; width:50%;"}

자동차에 가속도 $a$가 가해지며, 우리는 자동차의 현재 위치 $p$와 속도 $v$를 알고 싶다고 가정해보자.

그렇다면 상태 변수는 아래와 같이 정의될 수 있다.

$$
u=a~~,~~x=\begin{bmatrix}p\\v\end{bmatrix}
$$

뉴턴의 운동 법칙에 따라 방정식은 아래와 같이 정의된다.

$$
p_t=p_{t-1}+v_{t-1}\Delta t+\frac{1}{2}a\Delta t^2
$$

$$
v_t=v_{t-1}+a\Delta t
$$

이를 $\hat{x}_k^-=A\hat{x}_{k-1}+Bu_k$ 형태로 나타내면 아래와 같다.

$$
\begin{bmatrix}p_t\\v_t\end{bmatrix}
=\begin{bmatrix}1&\Delta t\\0&1\end{bmatrix}\begin{bmatrix}p_{t-1}\\v_{t-1}\end{bmatrix}
+\begin{bmatrix}\frac{1}{2}a\Delta t^2\\\Delta t\end{bmatrix}a
$$

또한 현재 GPS만 장착하고 있어서 센서가 위치 정보만 알려주고 속도 정보는 알려주지 않는다면, 측정값 $z$는 단일 스칼라값이 된다.

$$
z=\begin{bmatrix}1&0\end{bmatrix}\begin{bmatrix}p\\v\end{bmatrix}=p
$$
