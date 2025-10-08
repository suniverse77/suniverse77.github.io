---
title: "[선형대수] 선형 변환"
date: 2025-07-10 00:00:00 +/-TTTT
categories: [인공지능 수학, 선형대수]
tags: [선형대수]
math: true
toc: true
author: sunho
---

해당 포스트는 3Blue1Brown님의 영상을 바탕으로 정리하였습니다.

[Youtube - 3Blue1Brown](https://www.youtube.com/watch?v=35ESC-g49fY&list=PL7x3-Ea6TrJR095LxHtu7MgS0vpli1XZv&index=4)

## 선형 변환 (Linear Transformation)

변환 (Transformation)은 어떤 벡터를 입력받아 다른 벡터를 출력하는 함수를 의미한다.

![fig1](mlm/10-1.png){: style="display:block; margin:0 auto; width:70%;"}
_[[그림 출처]](https://angeloyeo.github.io/2019/07/17/eigen_vector.html)_

변환이라는 단어를 사용한 이유는 입력 벡터가 특정 규칙에 따라 움직이는 기하학적 이동을 연상하기 쉽기 때문이다.

선형 변환은 선형성을 만족하는 특별한 변환을 의미하며, 아래의 특징을 가지고 있다.

**대수적 정의**

$$
T(a\mathbf{u}+b\mathbf{v})=a\cdot T(\mathbf{u})+b\cdot T(\mathbf{v})
$$

1. 두 벡터를 먼저 더한 후 변환한 결과는, 각각을 변환한 후 더한 결과와 같다.

    $$
    T(\mathbf{u}+\mathbf{v})=T(\mathbf{u})+T(\mathbf{v})
    $$
2. 벡터에 스칼라를 곱한 후 변환한 결과는, 변환을 먼저 한 후 스칼라를 곱한 결과와 같다.

    $$
    T(a\mathbf{u})=a\cdot T(\mathbf{u})
    $$

**기하학적 특징**

1. 변환 전의 모든 직선은 변환 후에도 휘어지지 않고 직선으로 유지된다.
2. 원점은 변환 후에도 원점에 위치한다.

<span style="background-color:#fff5b1">행렬은 일종의 공간 변환으로 해석할 수 있다.</span>

### 2차원 선형 변환

2차원 공간에서 선형 변환은 $2\times2$ 행렬로 표현된다.

행렬의 각 열 벡터는 원래 기저 벡터 $\hat{\mathbf{i}}=(1,0)$와 $\hat{\mathbf{j}}=(0,1)$의 도달 좌표로 볼 수 있다.

![fig2](mlm/10-2.png){: style="display:block; margin:0 auto; width:60%;"}
_[[그림 출처]](https://www.3blue1brown.com/lessons/linear-transformations#title)_

위 그림에서 $\hat{\mathbf{i}}$와 $\hat{\mathbf{j}}$가 각각 $(1,-2)$ , $(3,0)$에 도달했으므로, 변환 행렬 $A$는 아래와 같이 표현할 수 있다.

$$
A=\begin{bmatrix}1&3\\-2&0\end{bmatrix}
$$

임의의 벡터 $\mathbf{v}$가 변환 후 도달하는 벡터 $\mathbf{v}'$은 $\mathbf{i}'$ ( $\hat{\mathbf{i}}$의 도달 벡터)과 $\mathbf{j}'$ ( $\hat{\mathbf{j}}$의 도달 벡터)의 선형 결합으로 표현할 수 있다. 이는 기저 벡터의 도달 위치만 안다면 $\mathbf{v}$의 도달 위치를 유추할 수 있다는 의미이다.

예를 들어 벡터 $\mathbf{v}$가 아래와 같이 주어졌있을 때, 두 기저 벡터의 선형 결합으로 표현할 수 있다.

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

마찬가지로 여러 개의 벡터를 동시에 변환하고 싶다면, 그 벡터들을 모아 행렬로 만들면 된다. 이것이 행렬곱을 정의하는 방식이다.

$$
\begin{bmatrix}a&b\\c&d\end{bmatrix}\begin{bmatrix}\color{red}e&\color{blue}f\\\color{red}g&\color{blue}h\end{bmatrix}
=\begin{bmatrix}a&b\\c&d\end{bmatrix}\begin{bmatrix}e\\g\end{bmatrix}+\begin{bmatrix}a&b\\c&d\end{bmatrix}\begin{bmatrix}f\\h\end{bmatrix}
=\begin{bmatrix}\color{red}{ae+bg}&\color{blue}{af+bh}\\\color{red}{ce+dg}&\color{blue}{cf+dh}\end{bmatrix}
$$

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

### 비정사각행렬 (Non-square Matrix)

비정사각행렬은 공간의 차원을 변환하는 역할을 한다.

$m\times n$ 행렬은 $n$차원 공간의 벡터를 $m$차원 공간으로 변환한다.
즉, 행렬에서 열이 입력 공간의 차원, 행이 변환 후 출력 공간의 차원을 의미한다.

예를 들어 $3\times2$ 행렬은 2차원 공간의 벡터를 3차원 공간으로 옮긴다. 하지만 옮겨진 벡터는 3차원 공간을 채우는 것이 아니라, 3차원 공간에서 원점을 가로지르는 2차원 평면 위에 놓이게 된다.

$$
\begin{bmatrix}2&1\\1&3\\3&2\end{bmatrix}
\begin{bmatrix}1&2\\3&4\end{bmatrix}
=\begin{bmatrix}5&8\\10&14\\9&14\end{bmatrix}
$$

위의 예시에서 2차원 벡터 $[1~3]^\top$ , $[2~4]^\top$는 변환 후 각각 3차원 벡터 $[5~10~9]^\top$ , $[8~14~14]^\top$가 된다.

비정사각행렬에서 full-rank는 원래의 차원을 그대로 유지하면서 더 높은 차원으로 변환된 것을 의미한다.
