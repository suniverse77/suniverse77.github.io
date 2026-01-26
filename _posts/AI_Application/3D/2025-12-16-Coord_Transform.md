---
title: "[3D 비전] 2D ↔ 3D 좌표계 변환"
date: 2025-12-16 06:00:00 +/-TTTT
categories: [AI, 3D 비전]
tags: [3D 비전]
math: true
toc: true
author: sunho
---

카메라 행렬을 통해 3D 월드 좌표와 2D 이미지 픽셀 좌표 간의 변환이 가능하다.

![fig7](3d/3-7.png){: style="display:block; margin:0 auto; width:60%;"}
_[[출처]](https://searching-fundamental.tistory.com/77#google_vignette)_

각 좌표의 notation은 아래와 같이 표기하겠다.

- $\mathbf{P}_w=(X_w,Y_w,Z_w)$ : 3D 월드 좌표
- $\mathbf{P}_c=(X_c,Y_c,Z_c)$ : 3D 카메라 좌표
- $\mathbf{p}_n=(x,y)$ : 2D 정규화 이미지 픽셀 좌표
- $\mathbf{p}=(u,v)$ : 2D 이미지 픽셀 좌표
- $\tilde{\cdot}~$ : 각 좌표의 동차 좌표

## Forward Projection: 3D $\to$ 2D

3D 월드 좌표에 카메라 외부 행렬 $[R\mid\mathbf{t}]$와 카메라 내부 행렬 $K$를 순차적으로 곱하면 2D 픽셀 좌표로 변환이 가능하다.

이때, $R$과 $\mathbf{t}$는 월드 좌표의 점을 카메라 좌표의 점으로 변환하는 역할을 한다. (카메라 좌표에서 봤을 때 월드 좌표의 점)

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

각 과정은 아래와 같다.

1. 카메라 외부 파라미터 행렬을 곱해 3D 월드 좌표에서의 점을 3D 카메라 좌표에서의 점으로 변환한다.

    $$
    \mathbf{P}_c=[R\mid t]\mathbf{\tilde{P}}_w
    $$
2. 3D 카메라 좌표에서의 점 $\mathbf{P}_c$를 카메라 원점에서 $\mathbf{P}_c$까지의 깊이 $Z_c$로 나누어, 정규화 이미지 평면 상의 2D 픽셀 좌표로 투영한다.

    $$
    \mathbf{\tilde{p}}_n=\frac{\mathbf{P}_c}{Z_c}    ~\rightarrow~
    \begin{bmatrix}x\\y\\1\end{bmatrix}=
    \frac{1}{Z_c}\begin{bmatrix}X_c\\Y_c\\Z_c\end{bmatrix}
    $$
3. 카메라 내부 파라미터 행렬을 곱해 이미지 평면 상의 2D 픽셀 좌표로 변환한다.

    $$
    \mathbf{\tilde{p}}=K\mathbf{\tilde{p}}_n~\rightarrow~
    \begin{bmatrix}u\\v\\1\end{bmatrix}=
    K\begin{bmatrix}x\\y\\1\end{bmatrix}
    $$

## Backward Projection: 2D $\to$ 3D

반대로, 이미지 평면 상의 2D 픽셀 좌표 $(u,v)$가 실제 3D 세계의 어떤 지점에 존재했는지도 계산할 수 있다.

하지만 주의할 점이 있다.

3차원 공간의 점이 2D 평면으로 투영될 때 깊이 정보가 소실되며, 깊이가 다르더라도 같은 직선 (Ray) 상에만 존재하면 동일한 픽셀로 투영된다.

즉, 해당 점에 대한 깊이 정보가 없다면, 2D 점을 하나의 특정한 3D 점으로 역변환할 수 없다.

![fig8](3d/3-8.png){: style="display:block; margin:0 auto; width:60%;"}
_[[출처]](https://www.mdpi.com/1424-8220/22/19/7540)_

따라서 카메라 원점에서 뻗어 나가는 직선 (Ray)의 방정식을 구하는 방식으로 접근해야 한다.

> Ray란 카메라 원점에서 시작해서, 이미지 평면의 픽셀을 통과해 3D 공간으로 뻗어 나가는 직선을 의미한다.
>
> 아래 그림에서 노란색 직선이 Ray이다.
> 
> ![fig9](3d/3-9.png){: style="display:block; margin:0 auto; width:40%;"}

깊이를 알 수 없는 상태에서의 변환 과정은 아래와 같다.

이때, $R$과 $\mathbf{t}$는 정방향 변환에서와 동일하게 월드 좌표의 점을 카메라 좌표의 점으로 변환하는 역할을 한다.

1. 이미지 평면의 픽셀 좌표를 정규화 이미지 평면의 픽셀 좌표로 변환한다. 결과적으로, $\mathbf{\tilde{p}}_n$은 Ray의 방향 벡터가 된다.

    $$
    \mathbf{\tilde{p}}_n=K^{-1}\mathbf{\tilde{p}}~\rightarrow~
    \begin{bmatrix}x\\y\\1\end{bmatrix}=
    K^{-1}\begin{bmatrix}u\\v\\1\end{bmatrix}
    $$

    정규화 평면 상의 점 $(x, y, 1)$은 카메라 원점 $(0, 0, 0)$에서 시작된 광선이 $Z_c=1$인 지점을 통과할 때의 좌표를 의미한다.
2. 3D 카메라 좌표에서의 점 $\mathbf{P}_c$는 깊이 $w$를 알 수 없는 상태에서 다음과 같이 표현된다.

    $$
    \mathbf{P}_c=d\cdot\mathbf{\tilde{p}}_n~\rightarrow~
    \begin{bmatrix}X_c\\Y_c\\Z_c\end{bmatrix}=
    w\begin{bmatrix}x\\y\\1\end{bmatrix}
    $$
3. 3D 카메라 좌표 $\mathbf{P}_c$를 3D 월드 좌표 $\mathbf{P}_w$로 변환한다. 

    정방향 변환에서의 식 $\mathbf{\tilde{P}}_c=[R\mid\mathbf{t}]{\tilde{P}}_w=R\mathbf{\tilde{P}}_w+\mathbf{t}$를 이용한다.

    $$
    \mathbf{\tilde{P}}_w=R^{-1}(\mathbf{P}_c-\mathbf{t})=R^\top(\mathbf{P}_c-\mathbf{t})
    $$

위의 식을 정리하면 아래와 같다.

$$
\mathbf{\tilde{P}}_w=R^\top\mathbf{P}_c-R^\top\mathbf{t}
=w\cdot\underbrace{(R^\top K^{-1}\mathbf{\tilde{p}})}_{\text{Ray Direction}}+\underbrace{(-R^\top\mathbf{t})}_{\text{Ray Origin}}
$$

이 식은 3D 공간에서 직선을 정의하는 $\mathbf{P}=w\mathbf{d}+\mathbf{o}$ 형태와 같으며, 카메라 원점에서 3D 공간의 점까지의 Ray 방정식을 의미한다.

- **Ray Origin:** 월드 좌표계 상에서의 카메라 원점의 위치 (Ray의 시작점)
- **Ray Direction:** 이미지 픽셀이 월드 공간에서 가리키는 방향 벡터
