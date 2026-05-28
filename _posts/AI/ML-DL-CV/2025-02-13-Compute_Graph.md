---
title: "[딥러닝] 계산 그래프 (Computational Graphs)"
date: 2025-02-13 00:00:00 +/-TTTT
categories: [AI, 머신러닝 / 딥러닝 / 컴퓨터 비전]
tags: [딥러닝, 모델 학습]
math: true
toc: true
author: sunho
---

신경망의 복잡한 연산은 덧셈, 곱셈 등 일련의 단순한 기본 연산으로 분해할 수 있다.
<br>
계산 그래프는 이러한 개별 연산들을 노드로 삼아 전체 연산 과정을 구조화한 것이다.

예를 들어, $z=w\cdot x+b$ 연산을 다음과 같은 계산 그래프로 표현할 수 있다.

![fig1](AI/ML-DL/Compute_Graph-1.png){: style="display:block; margin:0 auto; width:20%;"}

## 연쇄 법칙 (Chain Rule)

역전파 과정에서 연쇄 법칙은 다음 식을 따른다.

$$
\text{Downstream Gradient}=\text{Upstream Gradient}\times\text{Local Gradient}
\tag{1}
$$

![fig2](AI/ML-DL/Compute_Graph-2.png){: style="display:block; margin:0 auto; width:60%;"}

위 그림에서 연산자 노드 $f(\cdot)$를 기준으로 downstrem gradient, local gradient, upstream gradient는 다음과 같다.

- **Upstream Gradient:** 출력 방향 $y$에서 전해져 온 미분값

    $$\frac{\partial\mathcal{L}}{\partial y}$$

    Loss가 현재 노드의 출력값 변화에 얼마나 민감한지를 나타낸다.

- **Local Gradient:** 현재 노드 자체의 미분값

    $$\frac{\partial y}{\partial x}$$

    현재 노드의 출력값이 입력값 변화에 얼마나 민감한지를 나타낸다.

- **Downstream Gradient:** 입력 방향 $x$로 보낼 최종 미분값

    $$
    \frac{\partial\mathcal{L}}{\partial x}=
    \frac{\partial\mathcal{L}}{\partial y}\cdot
    \frac{\partial y}{\partial x}
    $$

    Loss가 현재 노드의 입력값 변화에 얼마나 민감한지를 나타낸다.
    <br>
    Downstream Gradient는 앞선 layer의 Upstream Gradient가 된다.

## 연산자 노드의 그래디언트 전파 특성

연산자 노드의 종류에 따라, 역전파 때 upstream gradient를 downstream으로 전달하는 고유의 방식이 존재한다.

- **덧셈 게이트 (Add gate) - 그래디언트 분배기**

    Upstream gradient을 연결된 모든 하류 노드에 동일하게 복사하여 downstream gradient를 만든다.
- **곱셈 게이트 (Mul gate) - 그래디언트 스왑** 

    Upstream gradient에 서로 바꾼 입력값을 곱하여 downstream gradient를 만든다.
- **복사 게이트 (Copy gate) - 그래디언트 합산기**

    여러 갈래에서 흘러들어오는 upstream gradient들을 모두 더해서 하나의 downstream gradient로 만든다.
- **최대값 게이트 (Max gate) - 그래디언트 라우터**

    Upstream gradient를 최댓값을 출력했던 경로로만 그대로 전달하고, 나머지 경로에는 0을 전달하여 흐름을 차단한다.

아래 그림에서 초록색 숫자는 입출력값, 빨간색 숫자는 그래디언트값을 나타낸다.

![fig3](AI/ML-DL/Compute_Graph-3.png){: style="display:block; margin:0 auto; width:60%;"}
_출처: Stanford CS231n, Lecture 4 (Neural Networks and Backpropagation)_

## 신경망에서의 chain rule

실제 딥러닝에서는 하나의 연산자 노드에 입력 $x$와 가중치 $w$가 입력으로 들어와 $y=f(x,w)$를 출력한다.

이때, 역전파 과정에서 Chain Rule에 의해 2가지의 downstream gradient가 생긴다.

$$\frac{\partial\mathcal{L}}{\partial x}~~,~\frac{\partial\mathcal{L}}{\partial w}$$

$\frac{\partial\mathcal{L}}{\partial x}$는 앞선 layer로 그라디언트를 전달할 때 사용되며, $\frac{\partial\mathcal{L}}{\partial w}$는 해당 노드의 파라미터를 업데이트하는 데 사용된다.

### 1. 입출력이 모두 스칼라인 경우 (Scalar to Scalar)

1개의 노드에서 입력을 받아 1개의 값을 출력하는 단일 뉴런의 경우를 생각해보자.

$$
y=wx\in\mathbb{R}, \quad \text{where } x, w \in \mathbb{R}
$$

![fig4](AI/ML-DL/Compute_Graph-4.png){: style="display:block; margin:0 auto; width:30%;"}

Chain Rule에 따라, 각 downstream gradient는 다음과 같이 계산된다.

- 입력에 대한 미분

    $$
    \frac{\partial\mathcal{L}}{\partial x}=\frac{\partial\mathcal{L}}{\partial y}\cdot\frac{\partial y}{\partial x}
    =\frac{\partial\mathcal{L}}{\partial y}\cdot w
    $$
- 가중치에 대한 미분

    $$
    \frac{\partial\mathcal{L}}{\partial w}=\frac{\partial\mathcal{L}}{\partial y}\cdot\frac{\partial y}{\partial w}
    =\frac{\partial\mathcal{L}}{\partial y}\cdot x
    $$

### 2. 벡터 입력과 스칼라 출력 (Vector to Scalar)

$n$개의 노드에서 입력을 받아 1개의 값을 출력하는 단일 뉴런의 경우를 생각해보자.
<br>
주로 신경망의 마지막 layer의 구조가 이 경우이다.

$$
y=\mathbf{w}^\top\mathbf{x}\in\mathbb{R}
, \quad \text{where }\mathbf{x},\mathbf{w}\in\mathbb{R}^n
$$

![fig5](AI/ML-DL/Compute_Graph-5.png){: style="display:block; margin:0 auto; width:30%;"}

Chain Rule에 따라, 각 downstream gradient는 다음과 같이 계산된다.

- 입력에 대한 미분

    $$
    \frac{\partial\mathcal{L}}{\partial\mathbf{x}}=\frac{\partial\mathcal{L}}{\partial y}\cdot\frac{\partial y}{\partial \mathbf{x}}
    =\frac{\partial\mathcal{L}}{\partial y}\cdot\mathbf{w}\in\mathbb{R}^{n}
    $$
- 가중치에 대한 미분

    $$
    \frac{\partial\mathcal{L}}{\partial\mathbf{w}}=\frac{\partial\mathcal{L}}{\partial y}\cdot\frac{\partial y}{\partial \mathbf{w}}
    =\frac{\partial\mathcal{L}}{\partial y}\cdot\mathbf{x}\in\mathbb{R}^{n}
    $$

### 3. 입출력이 모두 벡터인 경우 (Vector to Vector)

$n$개의 노드가 $m$개의 노드로 연결되는 경우를 생각해보자.
<br>
주로 신경망의 hidden layer의 구조가 이 경우이다.

$$
\mathbf{y}=W\mathbf{x}\in\mathbb{R}^m
, \quad \text{where } \mathbf{x}\in\mathbb{R}^n~,W\in\mathbb{R}^{m\times n}
$$

![fig6](AI/ML-DL/Compute_Graph-6.png){: style="display:block; margin:0 auto; width:30%;"}

Chain Rule에 따라, 각 downstream gradient는 다음과 같이 계산된다.

- 입력에 대한 미분

    $$
    \frac{\partial\mathcal{L}}{\partial\mathbf{x}}=\frac{\partial\mathcal{L}}{\partial\mathbf{y}}\cdot\frac{\partial\mathbf{y}}{\partial \mathbf{x}}
    =W^\top\cdot\frac{\partial\mathcal{L}}{\partial\mathbf{y}}\in\mathbb{R}^{n}
    $$
- 가중치에 대한 미분

    $$
    \frac{\partial\mathcal{L}}{\partial W}=\frac{\partial\mathcal{L}}{\partial\mathbf{y}}\cdot\frac{\partial\mathbf{y}}{\partial W}
    =\frac{\partial\mathcal{L}}{\partial\mathbf{y}}\cdot\mathbf{x}^\top\in\mathbb{R}^{m\times n}
    $$

### 4. 입출력이 행렬인 경우: 배치 처리 (Matrix to Matrix)

배치 크기가 $B$이고, 각 배치에서 $n$개의 노드가 $m$개의 노드로 연결되는 경우를 생각해보자.
<br>
신경망에서 가장 일반적인 경우이다.

$$
Y=\mathbf{W}X\in\mathbb{R}^{m\times B}
, \quad \text{where } X\in\mathbb{R}^{n\times B}~,\mathbf{W}\in\mathbb{R}^{(m\times B)\times(n\times B)}
$$

![fig7](AI/ML-DL/Compute_Graph-7.png){: style="display:block; margin:0 auto; width:30%;"}

Chain Rule에 따라, 각 downstream gradient는 다음과 같이 계산된다.

- 입력에 대한 미분

    $$
    \frac{\partial\mathcal{L}}{\partial X}=\frac{\partial\mathcal{L}}{\partial Y}\cdot\frac{\partial Y}{\partial X}\in\mathbb{R}^{n\times B}
    $$
- 가중치에 대한 미분

    $$
    \frac{\partial\mathcal{L}}{\partial\mathbf{W}}=\frac{\partial\mathcal{L}}{\partial Y}\cdot\frac{\partial Y}{\partial \mathbf{W}}\in\mathbb{R}^{(m\times B)\times(n\times B)}
    $$

#### ReLU 함수에서의 역전파

ReLU는 Element-wise 연산이기 때문에 $x_1$은 $z_1$에만 영향을 주고 $z_2, z_3$ 등에는 영향을 주지 않는다.

따라서 Local Gradient는 대각선 성분만 값을 가지고 나머지는 모두 0인 대각 행렬이다.

결과적으로 역전파 때, 원래 입력이 양수였던 요소의 기울기만 그대로 전파되고, 음수였던 곳은 0이 된다.

$$
\left(\frac{\partial L}{\partial \mathbf{x}}\right)_i=
\begin{cases}
\left(\frac{\partial L}{\partial \mathbf{z}}\right)_i&x_i>0\\
0&\text{otherwise}
\end{cases}
$$
