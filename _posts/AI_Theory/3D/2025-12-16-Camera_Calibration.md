---
title: "[3D Vision] 카메라 캘리브레이션"
date: 2025-12-16 06:00:00 +/-TTTT
categories: [AI, 3D 비전]
tags: [3D Vision]
math: true
toc: true
author: sunho
---

## 핀홀 카메라 모델

핀홀 카메라는 렌즈 없이 아주 작은 구멍 (핀홀)을 통해 빛을 받아들여 이미지를 맺는 가장 단순한 형태의 카메라이다. 이러한 원리 때문에 이미지 센서 (필름)에는 상하좌우가 뒤집힌 상이 맺힌다.

![fig1](3d/3-1.png){: style="display:block; margin:0 auto; width:100%;"}
_[[출처]](https://ko.wikipedia.org/wiki/%ED%95%80%ED%99%80_%EC%B9%B4%EB%A9%94%EB%9D%BC_%EB%AA%A8%EB%8D%B8)_

실제 카메라에서는 렌즈를 통과한 빛이 렌즈 뒤쪽에 있는 이미지 센서에 맺히고, 이 센서의 표면이 물리적인 이미지 평면 역할을 한다.

![fig2](3d/3-2.png){: style="display:block; margin:0 auto; width:80%;"}
_[[출처]](https://mvje.tistory.com/81#google_vignette)_

위의 그림처럼 실제 카메라의 이미지 이미지 평면은 렌즈 뒤 쪽에 존재하지만, 컴퓨터 비전에서는 수학적 편의를 위해 아래 그림처럼 렌즈 앞쪽에 있는 가상의 이미지 평면을 사용한다.

![fig3](3d/3-3.png){: style="display:block; margin:0 auto; width:80%;"}
_[[출처]](https://cho001.tistory.com/245)_

주요 구성 요소는 아래와 같다.

- **광학 중심 (Optical Center, Pinhole)**: 렌즈의 중심점으로, 카메라 좌표계의 원점에 해당
- **이미지 평면 (Image Plane)**: 상이 맺히는 가상의 평면
- **정규화 이미지 평면(Normalized Image Plane)**: 핀홀로부터 거리가 $1$인 가상의 평면
- **초점 거리 (Focal Length, $f$)**: 핀홀과 이미지 평면 사이의 거리

## 카메라 행렬

### 좌표계

각 좌표의 notation은 아래와 같이 표기하겠다.

- $\mathbf{P}_w=(X_w,Y_w,Z_w)$ : 3D 월드 좌표
- $\mathbf{P}_c=(X_c,Y_c,Z_c)$ : 3D 카메라 좌표
- $\mathbf{p}_n=(x,y)$ : 2D 정규화 이미지 픽셀 좌표
- $\mathbf{p}=(u,v)$ : 2D 이미지 픽셀 좌표
- $\tilde{\cdot}~$ : 각 좌표의 동차 좌표

**월드 좌표계**는 현실 세계의 한 점을 기준으로 정한 절대적인 좌표계를 의미한다.

$$
\mathbf{P}_w=\begin{bmatrix}X_w\\Y_w\\Z_w\end{bmatrix}
$$

**카메라 좌표계**는 카메라의 렌즈 중심을 원점으로 하고, 카메라가 바라보는 방향을 $z$축으로 하는 좌표계를 의미한다.

$$
\mathbf{P}_c=\begin{bmatrix}X_c\\Y_c\\Z_c\end{bmatrix}
$$

### 카메라 외부 파라미터 (Camera Extrinsic Parameter)

카메라 외부 파라미터에는 회전 행렬 $R$과 이동 벡터 $\mathbf{t}$가 존재한다.

$R$은 카메라가 어디를 바라보고 있고, $\mathbf{t}$는 카메라가 월드 좌표계에서 어디에 위치해 있는지를 나타낸다.

회전과 이동을 합쳐 행렬 $[R\mid\mathbf{t}]$로 표현할 수 있으며, 이를 카메라 외부 파라미터 행렬이라고 부른다.

$$
[R\mid\mathbf{t}]=\begin{bmatrix}
r_{11}&r_{12}&r_{13}&t_1\\
r_{21}&r_{22}&r_{23}&t_2\\
r_{31}&r_{32}&r_{33}&t_3
\end{bmatrix}
$$

3D 월드 좌표에 위 행렬을 곱함으로써, 3D 카메라 좌표로 변환할 수 있다.

$$
\begin{bmatrix}X_c\\Y_c\\Z_c\end{bmatrix}=
\begin{bmatrix}
r_{11}&r_{12}&r_{13}&t_1\\
r_{21}&r_{22}&r_{23}&t_2\\
r_{31}&r_{32}&r_{33}&t_3
\end{bmatrix}
\begin{bmatrix}X_w\\Y_w\\Z_w\\1\end{bmatrix}
~\rightarrow~\mathbf{P}_c=[R\mid\mathbf{t}]\mathbf{\tilde{P}}_w
$$

위 연산은 아래 연산과 동일하다.

$$
\begin{bmatrix}X_c\\Y_c\\Z_c\end{bmatrix}=
\begin{bmatrix}
r_{11}&r_{12}&r_{13}\\
r_{21}&r_{22}&r_{23}\\
r_{31}&r_{32}&r_{33}
\end{bmatrix}
\begin{bmatrix}X_w\\Y_w\\Z_w\end{bmatrix}
+\begin{bmatrix}t_1\\t_2\\t_3\end{bmatrix}
~\rightarrow~
\begin{cases}
X_c=r_{11}X_w+r_{12}Y_w+r_{13}Z_w+t_1\\
Y_c=r_{21}X_w+r_{22}Y_w+r_{23}Z_w+t_2\\
Z_c=r_{31}X_w+r_{32}Y_w+r_{33}Z_w+t_3
\end{cases}
$$

![fig4](3d/3-4.png){: style="display:block; margin:0 auto; width:50%;"}
_[[출처]](https://mvje.tistory.com/81#google_vignette)_

#### 회전 행렬 (Rotation)

회전 행렬 $R$은 월드 좌표계 축에 대한 카메라 좌표계 축의 회전을 의미한다.

$$
R=\begin{bmatrix}
r_{11}&r_{12}&r_{13}\\
r_{21}&r_{22}&r_{23}\\
r_{31}&r_{32}&r_{33}
\end{bmatrix}
$$

회전 행렬은 직교 행렬이므로, 아래의 식이 성립한다.

$$
R^{-1}=R^\top
$$

#### 이동 벡터 (Translation)

이동 벡터 $t$는 월드 좌표계 원점을 카메라 좌표계로 옮기는 이동을 의미한다.

$$
\mathbf{t}=\begin{bmatrix}t_1\\t_2\\t_3\end{bmatrix}
$$

이는 카메라가 월드 좌표계 상에서 $(t_1, t_2, t_3)$ 위치에 있다는 의미이다.

### 카메라 내부 파라미터 (Camera Intrinsic Parameter)

카메라 내부 파라미터는 렌즈와 이미지 센서의 물리적 특징을 나타내는 값들이다. 일반적으로 카메라 제조 공정에서 결정된다.

카메라 내부 파라미터에는 초점 거리 $f$, 주점 $c$, 비대칭 계수 $s$가 존재한다.

이들을 합쳐 행렬 $K$로 표현할 수 있으며, 이를 카메라 내부 파라미터 행렬이라고 부른다.

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
~\rightarrow~\mathbf{\tilde{p}}=K\mathbf{\tilde{p}}_n
$$

위 연산은 아래 연산과 동일하다. ($s=0$이라고 가정)

$$
\begin{bmatrix}u\\v\end{bmatrix}=
\begin{bmatrix}f_x&0\\0&f_y\end{bmatrix}
\begin{bmatrix}x\\y\end{bmatrix}+
\begin{bmatrix}c_x\\c_y\end{bmatrix}
~\rightarrow~
\begin{cases}
u=x\cdot f_x+c_x\\
v=y\cdot f_y+c_y
\end{cases}
$$

#### 초점 거리 (Focal Length)

초점 거리 $(f_x,f_y)$는 핀홀과 이미지 평면 사이의 거리를 픽셀 단위로 표현한 것이다.

![fig5](3d/3-5.png){: style="display:block; margin:0 auto; width:60%;"}
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

#### 주점 (Principal Point)

주점 $(c_x,c_y)$는 핀홀에서 이미지 센서에 내린 수선의 발이 맺히는 픽셀 좌표를 의미한다.

일반적으로 이미지의 중심 $(\frac{W}{2},\frac{H}{2})$과 일치한다고 가정한다.

하지만 조립 공정상의 오차로 인해 실제 렌즈의 중심축과 센서의 중심이 정확히 일치하지 않을 수 있어 보정이 필요하다.

정규화 이미지 평면의 원점은 렌즈의 중심에 위치하지만, 컴퓨터 비전에서 다루는 이미지 픽셀 좌표계의 원점은 이미지의 좌상단이다. 따라서 주점의 좌표만큼 평행 이동해야 한다.

#### 비대칭 계수 (Skew Coefficient)

비대칭 계수 $s$는 이미지 센서의 셀 격자 (Grid)가 직각이 아닐 때 발생하는 왜곡을 나타내며, $y$축이 $x$축에 대해 기울어진 정도를 의미한다.

![fig6](3d/3-6.png){: style="display:block; margin:0 auto; width:60%;"}
_[[출처]](https://darkpgmr.tistory.com/32)_

$$
s=\tan(\alpha)
$$

현대 디지털 카메라의 픽셀 격자는 정확히 직각을 이루므로, 대부분 $s=0$으로 간주한다.

## 좌표계 변환

카메라 행렬을 통해 3D 월드 좌표와 2D 이미지 픽셀 좌표 간의 변환이 가능하다.

![fig7](3d/3-7.png){: style="display:block; margin:0 auto; width:60%;"}
_[[출처]](https://searching-fundamental.tistory.com/77#google_vignette)_

### 3D 월드 좌표 $\to$ 2D 이미지 픽셀 좌표

먼저, 전체 파이프라인은 아래와 같다.

$$
\mathbf{\tilde{p}}=K[R\mid\mathbf{t}]\mathbf{\tilde{P}}_w
~\rightarrow~
\begin{bmatrix}x\\y\\1\end{bmatrix}=
\begin{bmatrix}
f_x&s&c_x\\0&f_y&c_y\\0&0&1
\end{bmatrix}
\begin{bmatrix}
r_{11}&r_{12}&r_{13}&t_1\\
r_{21}&r_{22}&r_{23}&t_2\\
r_{31}&r_{32}&r_{33}&t_3
\end{bmatrix}
\begin{bmatrix}X_w\\Y_w\\Z_w\\1\end{bmatrix}
$$

1. 카메라 외부 파라미터 행렬을 곱해 3D 월드 좌표를 3D 카메라 좌표로 변환한다.

    $$
    \mathbf{P}_c=[R\mid t]\mathbf{\tilde{P}}_w
    $$
2. 카메라 좌표를 깊이 $Z_c$로 나누어, 정규화 이미지 평면 상의 2D 픽셀 좌표로 투영한다.

    $$
    \mathbf{\tilde{p}}_n=\frac{\mathbf{P}_c}{Z_c}
    ~\rightarrow~
    \begin{bmatrix}u\\v\\1\end{bmatrix}=
    \frac{1}{Z_c}\begin{bmatrix}X_c\\Y_c\\Z_c\end{bmatrix}
    $$
3. 카메라 내부 파라미터 행렬을 곱해 이미지 평면 상의 2D 픽셀 좌표로 변환한다.

    $$
    \mathbf{\tilde{p}}=K\mathbf{\tilde{p}}_n
    $$
4. 동차 좌표 성분을 제거하여, 최종적으로 이미지 평면 상의 2D 픽셀 좌표를 얻는다.

    $$
    \mathbf{p}=\begin{bmatrix}u\\v\end{bmatrix}
    $$

### 2D 픽셀 좌표 $\to$ 3D 월드 좌표

반대로, 2D 픽셀 좌표를 3D 월드 좌표로 변환할 수도 있지만 주의할 점이 있다.

3차원 공간의 점을 2D 평면으로 투영할 때, 깊이가 다르더라도 같은 직선 (Ray) 상에 존재하면 동일한 픽셀로 투영된다.

즉, 2D 이미지로 변환되는 과정에서 깊이 정보가 소실되기 때문에, 역변환 때는 특정 3D 점 하나를 구할 수 없다.

![fig8](3d/3-8.png){: style="display:block; margin:0 auto; width:60%;"}
_[[출처]](https://www.mdpi.com/1424-8220/22/19/7540)_

따라서 카메라 원점에서 뻗어 나가는 직선 (Ray)의 방정식을 구하는 방식으로 접근해야 한다.

> Ray란 카메라 원점에서 시작해서, 이미지 평면의 픽셀을 통과해 3D 공간으로 뻗어 나가는 직선을 의미한다.
>
> 아래 그림에서 노란색 직선이 Ray이다.
> 
> ![fig9](3d/3-9.png){: style="display:block; margin:0 auto; width:40%;"}

먼저, 전체 파이프라인은 아래와 같다.

$$
\mathbf{\tilde{P}}_w=-R^\top\mathbf{t}+D\cdot\left(R^\top K^{-1}\mathbf{\tilde{p}}\right)
$$

1. $K^{-1}$를 곱해 이미지 평면의 픽셀을 정규화 이미지 평면으로 투영한다. 결과적으로, $\mathbf{\tilde{p}}_n$은 Ray의 방향 벡터가 된다.

    $$
    \mathbf{\tilde{p}}_n=K^{-1}\mathbf{\tilde{p}}
    $$

    $\mathbf{\tilde{p}}$은 좌표의 원점이 좌상단이기 때문에, 그 자체로 방향 벡터가 될 수 없다.
2. 3D 카메라 좌표로 돌려야하지만 깊이를 모르기 때문에, 스칼라 값 $D$를 깊이 변수로 둔 직선의 방정식으로 표현한다.

    $$
    \mathbf{P}_c=D\cdot\mathbf{\tilde{p}}_n
    $$
3. 카메라 좌표를 월드 좌표로 돌리기 위해, $\mathbf{\tilde{P}}_c=R\mathbf{\tilde{P}}_w+\mathbf{t}$를 이용한다.

    $$
    \mathbf{\tilde{P}}_w=R^{-1}(\mathbf{P}_c-\mathbf{t})=R^\top(\mathbf{P}_c-\mathbf{t})
    $$

위의 식을 정리하면 아래와 같다.

$$
\mathbf{\tilde{P}}_w=-R^\top\mathbf{t}+D\cdot\left(R^\top K^{-1}\mathbf{\tilde{p}}\right)
$$

여기서 각 항의 의미는 다음과 같다.

- **Ray Origin ($-R^\top\mathbf{t}$):** 월드 좌표계 상에서의 카메라 원점의 위치를 의미한다.
- **Ray Direction ($R^\top K^{-1}\mathbf{\tilde{p}}$):** 카메라 내부의 픽셀 $\mathbf{\tilde{p}}$가 가리키는 방향을 월드 좌표계 기준으로 회전시킨 방향 벡터를 의미한다.
