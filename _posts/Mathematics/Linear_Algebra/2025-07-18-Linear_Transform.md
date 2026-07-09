---
title: "[선형대수] 선형 변환 (Linear Transformation)"
date: 2025-07-18 00:00:00 +/-TTTT
categories: [Mathematics, 선형대수]
tags: [선형대수]
math: true
toc: true
author: sunho
---

변환은 어떤 벡터를 입력받아 다른 벡터를 출력하는 함수를 의미한다.
<br>
변환이라는 단어를 사용한 이유는 입력 벡터가 특정 규칙에 따라 움직이는 기하학적 이동을 연상하기 쉽기 때문이다.

**선형 변환**은 <span style="background-color:#fff5b1">선형성을 만족하는 특별한 변환</span>을 의미하며, 다음과 같이 표현된다.

$$
T(a\mathbf{u}+b\mathbf{v})=a\cdot T(\mathbf{u})+b\cdot T(\mathbf{v})
\tag{1}
$$

위 식의 의미는 다음과 같다.

1. 두 벡터를 먼저 더한 후 변환한 결과는, 각각을 변환한 후 더한 결과와 같다.

    $$
    T(\mathbf{u}+\mathbf{v})=T(\mathbf{u})+T(\mathbf{v})
    $$
2. 벡터에 스칼라를 곱한 후 변환한 결과는, 변환을 먼저 한 후 스칼라를 곱한 결과와 같다.

    $$
    T(a\mathbf{u})=a\cdot T(\mathbf{u})
    $$

선형 변환에서는 다음의 기하학적 특징을 가진다.

1. 변환 전의 모든 직선은 변환 후에도 휘어지지 않고 직선으로 유지된다.
2. 원점은 변환 후에도 원점에 위치한다.

## 선형 변환 관점에서의 행렬

행렬은 크게 두 가지 관점에서 볼 수 있다.

1. **열벡터 또는 행벡터들의 집합**

    예를 들어 머신러닝에서 자주 사용하는 $N \times D$ 데이터 행렬이 이에 해당한다.
2. **선형 변환을 수행하는 함수**

    어떤 벡터를 입력으로 받아, 크기와 방향을 바꾸어 새로운 벡터를 출력하는 함수로 볼 수 있다.

두 번째 관점에서 행렬은 벡터라는 화살표를 입력받아, 이를 늘리거나 줄이고 회전시켜 다른 화살표로 변환하는 역할을 한다.

![fig1](Mathematics/Linear_Algebra/Linear_Transform-1.png){: style="display:block; margin:0 auto; width:70%;"}
_[[그림 출처]](https://angeloyeo.github.io/2019/07/17/eigen_vector.html)_

행렬은 선형 변환을 수행하기 때문에 공간을 구부리지는 못한다.
<br>
대신 직선은 직선으로 유지한 채, 공간을 늘리고 줄이고 회전시키는 방식으로만 변형한다.

예를 들어, 원 위의 모든 벡터를 행렬 $A$에 통과시키면 일반적으로 타원이 된다.

![fig2](Mathematics/Linear_Algebra/Linear_Transform-2.png){: style="display:block; margin:0 auto; width:30%;"}

### 2차원 선형 변환 예시

2차원 벡터를 2차원 벡터로 변환하는 선형 변환은 $2\times2$ 행렬로 표현된다.

아래와 같은 선형 변환 $A$를 생각해 보자.

$$
A=\begin{bmatrix}1&3\\-2&0\end{bmatrix}\in\mathbb{R}^{2\times2}
$$

이제 유클리드 좌표계 위의 벡터 $\mathbf{x}=\mathbf{i}+\mathbf{j}$에 선형 변환 $A$를 적용해 보자.

#### 기저 벡터의 이동

선형 변환은 <span style="background-color:#fff5b1">기저 벡터의 이동</span>으로 이해할 수 있다.
<br>
즉, 벡터를 기저 벡터의 선형 결합으로 나타냈을 때 그 계수는 그대로 유지되지만, 기저 벡터 자체가 새로운 위치로 이동하기 때문에 벡터가 가리키는 실제 위치가 바뀌는 것이다.

$$
\mathbf{x}=1\mathbf{i}+1\mathbf{j}\quad\to\quad
A\mathbf{x}=1(A\mathbf{i})+1(A\mathbf{j})
$$

기저 벡터 $\mathbf{i}$, $\mathbf{j}$가 이동한 위치를 각각 $\mathbf{v}_1$, $\mathbf{v}_2$라고 하면, 이는 다음과 같이 구해진다.

$$
\mathbf{v}_1=A\mathbf{i}=\begin{bmatrix}1\\-2\end{bmatrix}
\quad,\quad
\mathbf{v}_2=A\mathbf{j}=\begin{bmatrix}3\\0\end{bmatrix}
$$

즉, <span style="background-color:#fff5b1">행렬의 각 열 벡터는 원래 기저 벡터가 변환 후 도달한 위치</span>이다.

따라서 $\mathbf{x}$의 변환 결과 $A\mathbf{x}$는 계수 $(1, 1)$을 유지한 채 기저 벡터만 갈아끼운 것으로 계산된다.

$$
A\mathbf{x}=1\mathbf{v}_1+1\mathbf{v}_2
=\begin{bmatrix}1\\-2\end{bmatrix}+\begin{bmatrix}3\\0\end{bmatrix}
=\begin{bmatrix}4\\-2\end{bmatrix}
$$

![fig3](Mathematics/Linear_Algebra/Linear_Transform-3.png){: style="display:block; margin:0 auto; width:70%;"}

#### 원래 벡터를 새로운 기저로 표현

반대로, 변환 전의 벡터 $\mathbf{x}=\mathbf{i}+\mathbf{j}$를 새로운 기저 $\mathbf{v}_1$, $\mathbf{v}_2$로 표현하면 어떻게 될까?
<br>
주의할 점은, 이는 위와 달리 벡터를 이동시키는 것이 아니라 <span style="background-color:#fff5b1">가만히 있는 벡터를 읽는 기준만 바꾸는 것</span>이므로 계수 $(1,1)$이 유지되지 않는다는 것이다.

찾고자 하는 것은 $\mathbf{x}=c_1\mathbf{v}_1+c_2\mathbf{v}_2$를 만족하는 계수 $(c_1, c_2)$이다.

$\mathbf{v}_1$, $\mathbf{v}_2$가 행렬 $A$의 열이므로 이 식은 $\mathbf{x}=A\begin{bmatrix}c_1\\\\c_2\end{bmatrix}$로 쓸 수 있고, 양변에 $A^{-1}$을 곱하면 <span style="background-color:#fff5b1">새로운 기저에서의 좌표는 역변환으로 구해짐</span>을 알 수 있다.

$$
\begin{bmatrix}c_1\\c_2\end{bmatrix}=A^{-1}\mathbf{x}=
\frac{1}{6}\begin{bmatrix}0&-3\\2&1\end{bmatrix}
\begin{bmatrix}1\\1\end{bmatrix}=
\begin{bmatrix}-0.5\\0.5\end{bmatrix}
$$

즉, 원래 벡터 $\mathbf{x}$는 새로운 기저로 다음과 같이 표현된다.

$$
\mathbf{x}=-0.5\mathbf{v}_1+0.5\mathbf{v}_2
$$

![fig4](Mathematics/Linear_Algebra/Linear_Transform-4.png){: style="display:block; margin:0 auto; width:70%;"}

정리하면, 같은 행렬 $A$를 두고 두 가지 방향의 해석이 존재한다.

1. **벡터를 실제로 이동시키는 변환의 관점:** 계수가 유지된 채 도착지가 $A\mathbf{x}$로 정해짐
2. **벡터는 그대로 둔 채 기준만 바꾸는 기저 변환의 관점:** 새로운 좌표가 $A^{-1}\mathbf{x}$로 정해짐

### 회전 행렬 (Rotation Matrix)

**회전 행렬**은 원점을 중심으로 벡터를 일정 각도 $\theta$만큼 회전시키는 변환을 수행한다.

2차원 공간에서 회전 행렬은 다음과 같이 정의된다.

$$
R(\theta)=\begin{bmatrix}
\cos\theta&-\sin\theta\\ \sin\theta&\cos\theta
\end{bmatrix}
\tag{2}
$$

예를 들어, 벡터를 반시계 방향으로 90º 회전시키는 행렬은 다음과 같다.

$$
A=\begin{bmatrix}
0&-1\\1&0
\end{bmatrix}
$$

![fig5](Mathematics/Linear_Algebra/Linear_Transform-5.png){: style="display:block; margin:0 auto; width:60%;"}
_[[그림 출처]](https://www.3blue1brown.com/lessons/linear-transformations#title)_

## Rank와 변환의 관계

행렬의 Rank는 <span style="background-color:#fff5b1">선형 변환 후 만들어질 수 있는 출력 공간의 차원</span>을 의미한다.

열벡터의 관점에서 말하면, Rank는 $A$의 열공간의 차원이다.

$$
\text{rank}(A)=\dim(C(A))
\tag{3}
$$

앞서 보았듯 행렬의 각 열은 기저 벡터가 이동한 위치이므로, Rank는 곧 이동한 기저 벡터들이 span할 수 있는 차원을 나타낸다.

### 정사각 행렬

2차원 벡터를 2차원 벡터로 변환하는 행렬 $A\in\mathbb{R}^{2\times 2}$를 생각해 보자.

- **$\text{rank}(A)=2$:** 두 열벡터가 선형 독립이다. 출력이 2차원 평면 전체를 채운다. **(차원 유지)**
- **$\text{rank}(A)=1$:** 두 열벡터가 한 직선 위에 겹친다. 평면 전체가 그 직선 위로 짓눌린다. **(차원 압축)**
- **$\text{rank}(A)=0$:** 모든 벡터가 원점으로 이동한다. **(붕괴)**

예를 들어 Rank가 1인 행렬 $A=\begin{bmatrix}1&0\\\\1&0\end{bmatrix}$는 모든 벡터를 직선 $y=x$ 위로 보낸다.

![fig6](Mathematics/Linear_Algebra/Linear_Transform-6.png){: style="display:block; margin:0 auto; width:70%;"}

위 케이스를 Null Space의 관점에서 다시 정리하면 다음과 같다.

- **$A$가 Full-Rank:** 오직 영벡터만이 변환 후 영벡터가 된다.
- **$A$가 Rank-Deficient:** 영벡터가 아닌 일부 벡터들이 변환후 영벡터가 된다.

즉, Rank가 작아질수록 선형 변환은 공간을 더 낮은 차원의 공간으로 압축하거나 붕괴시킨다.

### 직사각 행렬

직사각 행렬은 입력과 출력의 차원 자체가 다른 변환이다.

$m\times n$ 행렬은 $n$차원 공간의 벡터를 $m$차원 공간으로 변환한다.
<br>
즉, <span style="background-color:#fff5b1">열의 개수가 입력 공간의 차원, 행의 개수가 출력 공간의 차원</span>이다.
<br>
단, 출력이 $m$차원 공간을 실제로 얼마나 채우는지는 Rank가 결정한다.

직사각 행렬에서 FullRank는 원래의 차원을 그대로 유지하면서 더 높은 차원으로 변환된 것을 의미한다.

예를 들어 아래의 $3\times2$ 행렬은 2차원 벡터 $\begin{bmatrix}1\\\\3\end{bmatrix},\begin{bmatrix}2\\\\4\end{bmatrix}$를 3차원 벡터 $\begin{bmatrix}5\\\\10\\\\9\end{bmatrix},\begin{bmatrix}8\\\\14\\\\14\end{bmatrix}$로 변환한다.

$$
A=\begin{bmatrix}2&1\\1&3\\3&2\end{bmatrix}
$$

이때 옮겨진 벡터들이 3차원 공간 전체를 채우는 것은 아니다.
<br>
열공간의 차원은 rank인 $2$를 넘을 수 없으므로, 모든 출력은 3차원 공간 안에서 원점을 지나는 2차원 평면 위에 놓인다.
<br>
만약 행렬 $A$의 Rank가 $1$이었다면 출력은 직선 위에 놓였을 것이다.

비정사각행렬의 Full-Rank는 $\text{rank}(A)=\min(m,n)$을 의미하며, 행렬의 모양에 따라 의미가 달라진다.

- **$m>n$ :** 입력의 $n$차원이 그대로 유지된 채 더 높은 $m$차원 공간에 심어진다.
- **$m<n$ :** 출력이 $m$차원 공간 전체를 채우며, 입력의 $n-m$개 차원은 반드시 원점으로 붕괴한다.
