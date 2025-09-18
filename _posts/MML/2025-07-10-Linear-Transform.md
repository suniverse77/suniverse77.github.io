---
title: "[선형대수] 선형 변환"
date: 2025-07-10 00:00:00 +/-TTTT
categories: [인공지능 수학]
tags: [선형대수]
math: true
toc: true
author: sunho
img_path: /assets/images/math/
description: ✏️ 선형 변환으로서의 행렬
---

해당 포스트는 3Blue1Brown님의 영상을 바탕으로 정리하였습니다.

[Youtube - 3Blue1Brown](https://www.youtube.com/watch?v=35ESC-g49fY&list=PL7x3-Ea6TrJR095LxHtu7MgS0vpli1XZv&index=4)

## 선형 변환 (Linear Transformation)

선형대수학에서의 변환은 어떤 벡터를 입력받아 다른 벡터를 출력하는 규칙을 의미한다.

일종의 함수이지만, 변환에는 입력 벡터가 새로운 위치로 이동하거나 변형되는 기하학적 움직임을 연상시키는 데 도움이 됩니다.

기하학적으로 선형 변환은 아래의 2가지 조건을 만족하는 변형을 의미한다.

1. 변환 전의 모든 직선은 변환 후에도 직선으로 유지된다.
2. 원점은 항상 변환 후에도 같은 원점에 위치한다.

수학적으로 변환 이 선형 변환이 되려면 아래의 2가지 조건을 만족해야 한다.

1. 
2. 

<span style="background-color:#fff5b1">행렬은 일종의 공간 변환으로 해석할 수 있다.</span>

### 2차원 선형 변환

$$
A=\begin{bmatrix}a&b\\c&d\end{bmatrix}
$$

2차원 공간에서 선형 변환은 $2\times2$ 행렬로 표현된다.

행렬의 각 열 벡터는 원래 기저 벡터 $\hat{\mathbf{i}}=(1,0)$와 $\hat{\mathbf{j}}=(0,1)$의 도달 좌표로 볼 수 있다.

임의의 벡터 $\mathbf{v}$가 변환 후 도달하는 벡터는 $\hat{\mathbf{i}}$의 도달 벡터와 $\hat{\mathbf{j}}$ 도달 벡터의 선형 결합으로 표현할 수 있다. 즉, 기저 벡터의 도달 위치만 안다면 $\mathbf{v}$의 도달 위치를 유추할 수 있다는 의미이다.

예를 들어, 행렬 $A$와 벡터 $\mathbf{v}$가 아래와 같이 주어졌다고 해보자.

$$
A=\begin{bmatrix}1&3\\-2&0\end{bmatrix}
~,~
\mathbf{v}=\begin{bmatrix}-1\\2\end{bmatrix}
$$

벡터 $\mathbf{v}$는 아래처럼 두 기저 벡터의 선형 결합으로 표현할 수 있다.

$$
\mathbf{v}=\begin{bmatrix}-1\\2\end{bmatrix}
=-\hat{\mathbf{i}}+2\hat{\mathbf{j}}
$$

각 기저 벡터에 대해 변환 $A$를 적용하고, 변환된 기저를 각각 $\mathbf{i}'$, $\mathbf{j}'$라고 하자.

$$
A\hat{\mathbf{i}}=\begin{bmatrix}1&3\\-2&0\end{bmatrix}\begin{bmatrix}1\\0\end{bmatrix}=\begin{bmatrix}1\\-2\end{bmatrix}
~,~
A\hat{\mathbf{j}}=\begin{bmatrix}1&3\\-2&0\end{bmatrix}\begin{bmatrix}0\\1\end{bmatrix}=\begin{bmatrix}3\\0\end{bmatrix}
$$

이는 행렬 $A$의 각 열 벡터가 원래 기저 벡터의 도달 좌표라는 것을 의미한다.

이번에는 $\mathbf{v}$에 대해 변환 $A$를 적용하고, 변환된 벡터를 $\mathbf{v}'$라고 하자.

$$
A\mathbf{v}=\begin{bmatrix}1&3\\-2&0\end{bmatrix}\begin{bmatrix}-1\\2\end{bmatrix}=\begin{bmatrix}5\\2\end{bmatrix}=\mathbf{v}'
$$

이는 정확히 변환 후 기저 벡터의 선형 결합과 일치한다.

$$
\mathbf{v}'=\begin{bmatrix}5\\2\end{bmatrix}=-\mathbf{i}'+2\mathbf{j}'
$$

즉, 임의의 벡터가 변환 후 어디에 도달하는지 알고싶다면 벡터의 좌표를 취한 다음, 각 기저 벡터에 대응하는 행렬 열에 곱한 뒤 모두 더해주면 된다.

$$
A\mathbf{v}=\begin{bmatrix}1&3\\-2&0\end{bmatrix}\begin{bmatrix}-1\\2\end{bmatrix}
=-\begin{bmatrix}1\\-2\end{bmatrix}+2\begin{bmatrix}3\\0\end{bmatrix}
$$

---

왜 위의 과정을 거쳤을까?

사실 우리가 단순히 암기했던 행렬과 벡터의 곱셈 공식이 바로 이런 원리에 기반하기 때문이다.

$$
\begin{bmatrix}a&b\\c&d\end{bmatrix}\begin{bmatrix}x\\y\end{bmatrix}
=x\begin{bmatrix}a\\c\end{bmatrix}+y\begin{bmatrix}b\\d\end{bmatrix}
=\begin{bmatrix}ax+by\\cx+dy\end{bmatrix}
$$

즉, 벡터의 각 좌표를 계수로 삼아 행렬의 열벡터를 선형 결합한 것이 곱셈의 본질이다.

$$
\begin{bmatrix}a&b\\c&d\end{bmatrix}\begin{bmatrix}e&f\\g&h\end{bmatrix}
=\begin{bmatrix}a&b\\c&d\end{bmatrix}\begin{bmatrix}e\\g\end{bmatrix}+\begin{bmatrix}a&b\\c&d\end{bmatrix}\begin{bmatrix}f\\h\end{bmatrix}
=\begin{bmatrix}ae+bg&af+bh\\ce+dg&cf+dh\end{bmatrix}
$$

마찬가지로 여러 개의 벡터를 동시에 변환하고 싶다면, 그 벡터들을 모아 행렬로 만들면 된다. 이것이 행렬곱을 정의하는 방식이다.

특별한 변환을 수행하는 행렬이 있다.

**1. 전단 (Shear)**

전단 변환은 도형의 모양을 기울이는 효과를 낸다.



**2. 회전 (Rotation)**

회전 변환은 원점을 중심으로 벡터를 일정 각도 $\theta$만큼 회전시킨다.

$$
R(\theta)=\begin{bmatrix}
\cos\theta&-\sin\theta\\ \sin\theta&\cos\theta
\end{bmatrix}
$$

예를 들어, $\hat{\mathbf{i}}=(1,0)$와 $\hat{\mathbf{j}}=(0,1)$가 변환 후 각각 $(0,1)$, $(-1,0)$에 도달했다면 이 변환을 수행하는 행렬은 아래와 같다.

$$
A=\begin{bmatrix}
0&-1\\1&0
\end{bmatrix}
$$

이 변환은 반시계 방향으로 90º 회전시키는 역할을 수행한다.

### 3차원 선형 변환

3차원 공간에서의 선형 변환은 변환이 $3\times3$ 행렬로 표현된다는 것 외에는 2차원 선형 변환과 큰 차이가 없다.
