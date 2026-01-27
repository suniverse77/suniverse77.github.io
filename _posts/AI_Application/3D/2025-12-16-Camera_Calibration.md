---
title: "[3D 비전] 카메라 캘리브레이션 (Camera Calibration)"
date: 2025-12-16 00:00:00 +/-TTTT
categories: [AI, 3D 비전]
tags: [3D 비전]
math: true
toc: true
author: sunho
---

## 핀홀 카메라 모델

핀홀 카메라는 렌즈 없이 아주 작은 구멍 (핀홀)을 통해 빛을 받아들여 이미지를 맺는 가장 단순한 형태의 카메라이다. 이러한 원리 때문에 이미지 센서 (필름)에는 상하좌우가 뒤집힌 상이 맺힌다.

![fig1](AI/3D/Camera_Calibration-1.png){: style="display:block; margin:0 auto; width:100%;"}
_[[출처]](https://ko.wikipedia.org/wiki/%ED%95%80%ED%99%80_%EC%B9%B4%EB%A9%94%EB%9D%BC_%EB%AA%A8%EB%8D%B8)_

실제 카메라에서는 렌즈를 통과한 빛이 렌즈 뒤쪽에 있는 이미지 센서에 맺히고, 이 센서의 표면이 물리적인 이미지 평면 역할을 한다.

![fig2](AI/3D/Camera_Calibration-2.png){: style="display:block; margin:0 auto; width:80%;"}
_[[출처]](https://mvje.tistory.com/81#google_vignette)_

위의 그림처럼 실제 카메라의 이미지 이미지 평면은 렌즈 뒤 쪽에 존재하지만, 컴퓨터 비전에서는 수학적 편의를 위해 아래 그림처럼 렌즈 앞쪽에 있는 가상의 이미지 평면을 사용한다.

![fig3](AI/3D/Camera_Calibration-3.png){: style="display:block; margin:0 auto; width:80%;"}
_[[출처]](https://cho001.tistory.com/245)_

주요 구성 요소는 아래와 같다.

- **광학 중심 (Optical Center, Pinhole)**: 렌즈의 중심점으로, 카메라 좌표계의 원점에 해당
- **이미지 평면 (Image Plane)**: 상이 맺히는 가상의 평면
- **정규화 이미지 평면(Normalized Image Plane)**: 핀홀로부터 거리가 $1$인 가상의 평면
- **초점 거리 (Focal Length, $f$)**: 핀홀과 이미지 평면 사이의 거리

## 카메라 외부 파라미터 (Camera Extrinsic Parameter)

카메라 외부 파라미터는 3D 공간의 월드 좌표계를 기준으로 정의된 점들을 3D 공간의 카메라 좌표계로 변환하는 역할을 한다.

카메라 외부 파라미터에는 회전 행렬 $R$과 이동 벡터 $\mathbf{t}$가 존재하며, 이들을 합친 $[R\mid\mathbf{t}]$ 행렬을 카메라 외부 파라미터 행렬이라고 부른다.

$$
[R\mid\mathbf{t}]=\begin{bmatrix}
r_{11}&r_{12}&r_{13}&t_1\\
r_{21}&r_{22}&r_{23}&t_2\\
r_{31}&r_{32}&r_{33}&t_3
\end{bmatrix}
$$

$R$은 카메라 좌표계가 월드 좌표계에 비해 얼마나 회전되어 있는지를, $\mathbf{t}$는 카메라 좌표계에서 바라본 월드 좌표계 원점의 위치를 의미한다.

따라서 월드 좌표계에서 정의된 점 $\mathbf{P}_w$를 카메라 좌표계의 점 $\mathbf{P}_c$로 변환하기 위해서 아래의 식을 사용할 수 있다. 

$$
\mathbf{P}_c=R\mathbf{P}_w+\mathbf{t}
$$

동차 좌표계를 사용하면, 회전과 이동 연산을 하나의 행렬 곱으로 처리할 수 있다.

$$
\begin{bmatrix}X_c\\Y_c\\Z_c\\1\end{bmatrix}=
\begin{bmatrix}
r_{11}&r_{12}&r_{13}&t_1\\
r_{21}&r_{22}&r_{23}&t_2\\
r_{31}&r_{32}&r_{33}&t_3\\
0&0&0&1
\end{bmatrix}
\begin{bmatrix}X_w\\Y_w\\Z_w\\1\end{bmatrix}
$$

![fig4](AI/3D/Camera_Calibration-4.png){: style="display:block; margin:0 auto; width:50%;"}
_[[출처]](https://mvje.tistory.com/81#google_vignette)_

### 회전 행렬 (Rotation)

회전 행렬 $R$은 카메라 좌표계가 월드 좌표계에 비해 얼마나 회전되어 있는지를 의미한다.

$$
R=\begin{bmatrix}
r_{11}&r_{12}&r_{13}\\
r_{21}&r_{22}&r_{23}\\
r_{31}&r_{32}&r_{33}
\end{bmatrix}
$$

각 행 벡터는 월드 좌표계의 $x,y,z$ 축이 카메라 좌표계에서 어느 방향을 향하고 있는지를 나타내는 단위 벡터를 의미한다.

회전 행렬은 직교 행렬이므로, 항상 $R^\top R=I$를 만족한다.

### 이동 벡터 (Translation)

이동 벡터 $t$는 카메라 좌표계에서 바라본 월드 좌표계 원점의 위치를 의미한다.

$$
\mathbf{t}=\begin{bmatrix}t_1\\t_2\\t_3\end{bmatrix}
$$

이는 월드 좌표계 원점이 카메라가 좌표계 상에서 $(x,y,z)=(t_1, t_2, t_3)$ 위치에 있다는 의미이다.

월드 좌표계에서 카메라가 어디에 있는지를 알고 싶다면 아래의 식을 사용해야 한다.

$$
C=-R^\top\mathbf{t}
$$

## 카메라 내부 파라미터 (Camera Intrinsic Parameter)

카메라 내부 파라미터는 정규화 이미지 평면의 좌표를 실제 이미지 평면의 픽셀 좌표로 변환하는 역할을 한다.

카메라 내부 파라미터는 렌즈와 이미지 센서의 물리적 특징을 나타내는 값들이다. 일반적으로 카메라 제조 공정에서 결정된다.

카메라 내부 파라미터에는 초점 거리 $f$, 주점 $c$, 비대칭 계수 $s$가 존재하며, 이들을 합친 $K$ 행렬을 카메라 내부 파라미터 행렬이라고 부른다.

$$
K=\begin{bmatrix}
f_x&s&c_x\\0&f_y&c_y\\0&0&1
\end{bmatrix}
$$

2D 정규화 이미지 픽셀 좌표에 위 행렬을 곱함으로써, 2D 이미지 픽셀 좌표로 변환할 수 있다.

$$
\begin{bmatrix}u\\v\\1\end{bmatrix}=
\begin{bmatrix}
f_x&s&c_x\\0&f_y&c_y\\0&0&1
\end{bmatrix}\begin{bmatrix}x\\y\\1\end{bmatrix}
$$

### 초점 거리 (Focal Length)

초점 거리 $(f_x,f_y)$는 핀홀과 이미지 평면 사이의 거리를 픽셀 단위로 표현한 것이다.

![fig5](AI/3D/Camera_Calibration-5.png){: style="display:block; margin:0 auto; width:60%;"}
_[[출처]](https://darkpgmr.tistory.com/32)_

$$
f_x=\frac{F~(\text{mm})}{p_x~(\text{mm/pixel})}~~,~~
f_y=\frac{F~(\text{mm})}{p_y~(\text{mm/pixel})}
$$

- $F$: 렌즈와 센서 사이의 물리적인 거리 (mm 단위)
- $f$: 이미지 처리에서 사용하는 초점 거리 (pixel 단위)

이때 $p_x$와 $p_y$는 이미지 센서의 cell 하나의 가로/세로 물리적 크기를 의미한다.

현대 디지털카메라의 센서의 cell은 대부분 정사각형이므로 일반적으로 $f_x =f_y$이다.

정규화 이미지 평면은 핀홀에서 거리가 $1$인 가상의 평면이다. 하지만 실제 이미지가 맺히는 센서는 핀홀에서 $f$만큼 떨어져 있기 때문에, 삼각형의 닮음비에 의해 좌표 값에 $f$를 곱해줘야 한다.

$$
\begin{aligned}
u'=x\cdot f_x\\
v'=y\cdot f_y
\end{aligned}
$$

![fig6](AI/3D/Camera_Calibration-6.png){: style="display:block; margin:0 auto; width:100%;"}

### 주점 (Principal Point)

주점 $(c_x,c_y)$는 핀홀에서 이미지 센서에 내린 수선의 발이 맺히는 픽셀 좌표를 의미한다.

조립 공정상의 오차로 인해 실제 렌즈의 중심축과 센서의 중심이 정확히 일치하지 않을 수 있어 보정이 필요하지만, 일반적으로 이미지의 중심 $(\frac{W}{2},\frac{H}{2})$과 일치한다고 가정한다.

![fig7](AI/3D/Camera_Calibration-7.png){: style="display:block; margin:0 auto; width:60%;"}
_[[출처]](https://physics.stackexchange.com/questions/11594/how-to-find-the-principal-point-in-an-image)_

정규화 이미지 평면의 원점은 렌즈의 중심에 위치하지만, 이미지 픽셀 좌표계의 원점은 이미지의 좌상단이다. 따라서 이미지 픽셀 좌표로 옮기기 위해서는 주점의 좌표만큼 평행 이동해야 한다.

$$
\begin{aligned}
u=u'+c_x\\
v=v'+c_y
\end{aligned}
$$

### 비대칭 계수 (Skew Coefficient)

비대칭 계수 $s$는 이미지 센서의 셀 격자 (Grid)가 직각이 아닐 때 발생하는 왜곡을 나타내며, $y$축이 $x$축에 대해 기울어진 정도를 의미한다.

![fig8](AI/3D/Camera_Calibration-8.png){: style="display:block; margin:0 auto; width:60%;"}
_[[출처]](https://darkpgmr.tistory.com/32)_

$$
s=\tan(\alpha)
$$

현대 디지털 카메라의 픽셀 격자는 정확히 직각을 이루므로, 대부분 $s=0$으로 간주한다.
