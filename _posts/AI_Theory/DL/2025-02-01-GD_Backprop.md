---
title: "[NN] 경사 하강법과 역전파"
date: 2025-02-01 06:00:00 +/-TTTT
categories: [AI Theory, 딥러닝]
tags: [신경망]
math: true
toc: true
author: sunho
---

## 경사 하강법 (Gradient Descent)

앞서, 모델은 학습을 통해 가중치를 업데이트한다고 했다. 그럼 어떤 기준과 방법으로 파라미터들을 업데이트할까?

모델이 파라미터를 업데이트하는 기준은 손실 함수 $\mathcal{L}$의 값을 최소화하는 것이며, 이를 위해 그라디언트 정보를 이용한다.

기본적인 업데이트 수식은 아래와 같다.

$$
\theta_{t+1}=\theta_t-\eta\nabla\mathcal{L}_\theta(\theta_t)
$$

위의 수식에서 $\eta$는 학습률 (Learning Rate)로, 한 번에 얼마나 이동할지인 보폭을 의미한다.

그라디언트는 함수값이 증가하는 방향을 가리키는데, 우리는 손실을 줄여야 하므로 빼기 연산을 하여 업데이트한다.

아래 그림에서 볼 수 있듯이 손실 함수의 최소값을 찾기 위해 그라디언트를 이용해 경사를 따라 내려가듯 가중치를 업데이트하며, 이 알고리즘을 경사 하강법이라고 부른다.

![fig1](dl/nn/2-1.png){: style="display:block; margin:0 auto; width:50%;"}
_[[출처]](https://blog.ex-em.com/1750)_

### Gradient 계산 방법

컴퓨터가 그라디언트를 계산하는 방법에는 크게 두 가지가 있다.

#### Numerical gradient

미분의 수학적 정의를 이용해 그라디언트의 근사치를 계산하는 방법이다.

$$
\frac{df(x)}{dx}=\lim_{h\to0}\frac{f(x+h)-f(x)}{h}
$$

$h$가 완전한 0이 아니므로 근사치이며, 가중치 하나하나에 대해 두 가지 함수 $f(x+h)$, $f(x)$를 호출해야 하므로 매우 느리다.

하지만 수식이 직관적이기 때문에 코드로 구현하기는 쉽다.

#### Analytic gradient

미적분학을 이용해 그라디언트를 계산하는 공식을 유도하여 구현하는 방법이다.

$$
f(x)=2x^3 ~\to~f'(x)=6x^2
$$

수학 공식을 직접 사용하기 때문에 오차가 없고, 한 번의 계산으로 모든 가중치에 대한 그라디언트를 얻을 수 있기 때문에 매우 빠르다.

하지만 복잡한 모델의 그라디언트 공식을 유도하고 코드로 구현하는 것이 어렵다.

## 역전파 (Backpropagation)

실제 신경망에는 파라미터가 매우 많다.

앞선 방법으로 그라디언트를 계산하려면 매번 새로운 손실 함수에 대해 $\nabla_wL$을 계산해야하기 때문에 매우 비효율적이다.

그렇다면 컴퓨터는 복잡한 신경망에서 어떻게 효율적으로 그라디언트를 계산할 수 있을까?

계산 그래프와 연쇄 법칙 (Chain Rule)을 이용해 구한다.

### 계산 그래프 (Computational Graphs)

신경망의 연산은 덧셈, 곱셈 등의 일련의 기본 연산으로 구성되기 때문에 이를 아래와 같은 계산 그래프로 표현할 수 있다.

![fig2](dl/nn/2-2.png){: style="display:block; margin:0 auto; width:60%;"}
_출처: Stanford CS231n, Lecture 4 (Neural Networks and Backpropagation)_

- **순전파 (Forward pass)**에서는 입력에서 출발해 그래프를 따라가면서 각 노드의 출력을 차례대로 계산하며, 최종적으로 손실 함수 값 $L$을 얻는다.
- **역전파 (Backward pass)**에서는 출력에서 입력 방향으로 그래프를 거슬러 올라가면서 chain rule을 이용해 각 파라미터에 대한 손실의 기울기 $\nabla_WL$를 계산한다.

### 1. 입출력이 모두 스칼라인 경우 (Scalar to Scalar)

1개의 노드에서 입력을 받아 1개의 값을 출력하는 단일 뉴런의 경우를 생각해보자.

![fig3](dl/nn/2-3.png){: style="display:block; margin:0 auto; width:30%;"}

입력 데이터 $x$와 가중치 $w$는 스칼라이고, 이 둘의 내적을 통해 계산된 출력 $y$ 역시 스칼라이다.

$$
x,w\in\mathbb{R}~~,~~y=wx\in\mathbb{R}
$$

![fig4](dl/nn/2-4.png){: style="display:block; margin:0 auto; width:60%;"}
_출처: Stanford CS231n, Lecture 4 (Neural Networks and Backpropagation)_

**Upstream Gradient**

노드의 출력 $y$가 최종 손실 함수 $L$에 얼마나 영향을 미치는지에 대한 값이다.

$$
\frac{\partial L}{\partial y}\in\mathbb{R}
$$

역전파의 흐름상, 손실 함수 쪽에서 계산되어 현재 노드로 흘러들어오는 기울기이기 때문에 Upstream Gradient라고 부른다.

**Local Gradient**

현재 노드에서 입력 $x$가 변할 때 출력 $y$가 얼마나 변하는지를 나타낸다.

$$
\frac{\partial y}{\partial x}\in\mathbb{R}~~,~~
\frac{\partial y}{\partial w}\in\mathbb{R}
$$

다른 노드와 상관없이, 오직 현재 노드의 연산 과정만 고려하여 내부적으로 계산하기 때문에 Local Gradient라고 부른다.

**Downstream Gradient**

노드의 입력 $x,w$가 최종 손실 함수에 얼마나 영향을 미치는지에 대한 값으로, Chain Rule에 의해 'Upstream Gradient $\times$ Local Gradient'로 계산된다.

$$
\frac{\partial L}{\partial x}=\frac{\partial L}{\partial y}\cdot\frac{\partial y}{\partial x}\in\mathbb{R}~~,~~
\frac{\partial L}{\partial w}=\frac{\partial L}{\partial y}\cdot\frac{\partial y}{\partial w}\in\mathbb{R}
$$

이 값을 입력 쪽으로 흘려보내기 때문에 Downstream Gradient라고 부른다.

#### 역전파 과정

$$
\frac{\partial L}{\partial w}=\frac{\partial L}{\partial y}\cdot x
$$

<details>
<summary><font color='#FF0000'>Example 1</font></summary>
<div markdown="1">

![fig5](dl/nn/2-5.png){: style="display:block; margin:0 auto; width:60%;"}
_출처: Stanford CS231n, Lecture 4 (Neural Networks and Backpropagation)_

---

</div>
</details>

#### ㄴ

![fig6](dl/nn/2-6.png){: style="display:block; margin:0 auto; width:60%;"}
_출처: Stanford CS231n, Lecture 4 (Neural Networks and Backpropagation)_



### 2. 벡터 입력과 스칼라 출력 (Vector to Scalar)

$n$개의 노드에서 입력을 받아 1개의 값을 출력하는 단일 뉴런의 경우를 생각해보자.

![fig7](dl/nn/2-7.png){: style="display:block; margin:0 auto; width:30%;"}

입력 데이터 $\mathbf{x}$와 가중치 $\mathbf{w}$는 벡터이고, 이 둘의 내적을 통해 계산된 출력 $y$는 스칼라이다.

$$
\mathbf{x},\mathbf{w}\in\mathbb{R}^n~~,~~y=\mathbf{w}^\top\mathbf{x}
$$

**Upstream Gradient**

노드의 출력 $y$가 최종 손실 함수 $L$에 얼마나 영향을 미치는지에 대한 값이다. 출력 $y$가 스칼라이므로, 이 값 또한 스칼라이다.

$$
\frac{\partial L}{\partial y}\in\mathbb{R}
$$

**Local Gradient**

현재 노드에서 입력 $\mathbf{x}$가 변할 때 출력 $y$가 얼마나 변하는지를 나타낸다.

$$
\frac{\partial y}{\partial \mathbf{x}}\in\mathbb{R}^{n}
~~,~~\frac{\partial y}{\partial \mathbf{w}}\in\mathbb{R}^{n}
$$

Local Gradient의 각 요소는 입력 벡터의 각 요소가 출력 $y$에 얼마나 영향을 미치는지를 나타낸다.

**Downstream Gradient**

노드의 입력 $\mathbf{x},\mathbf{w}$가 최종 손실 함수에 얼마나 영향을 미치는지에 대한 값으로, Chain Rule에 의해 'Upstream Gradient $\times$ Local Gradient'로 계산된다.

$$
\frac{\partial L}{\partial \mathbf{x}}=\frac{\partial y}{\partial \mathbf{x}}\cdot\frac{\partial L}{\partial y}\in\mathbb{R}^{n}~~,~~
\frac{\partial L}{\partial \mathbf{w}}=\frac{\partial y}{\partial \mathbf{w}}\cdot\frac{\partial L}{\partial y}\in\mathbb{R}^{n}
$$

Downstream Gradient의 각 요소는 $\mathbf{x}$의 각 요소가 손실 함수에 얼마나 영향을 미치는지를 나타낸다.

$\frac{\partial L}{\partial \mathbf{x}}$는 이전 layer로 계속해서 기울기를 전달하는 데 사용되며, $\frac{\partial L}{\partial \mathbf{w}}$는 해당 layer의 파라미터를 업데이트하는 데 사용된다.

### 3. 입출력이 모두 벡터인 경우 (Vector to Vector)

$n$개의 노드가 $m$개의 노드로 연결되는 경우를 생각해보자.

![fig8](dl/nn/2-8.png){: style="display:block; margin:0 auto; width:30%;"}

입력 데이터 $\mathbf{x}$는 벡터, 가중치 $W$는 행렬이고, 이 둘의 내적을 통해 계산된 출력 $\mathbf{y}$는 벡터이다.

$$
\mathbf{x}\in\mathbb{R}^n,W\in\mathbb{R}^{m\times n}~~,~~\mathbf{y}=W\mathbf{x}\in\mathbb{R}^m
$$

**Upstream Gradient**

노드의 출력 $\mathbf{y}$가 최종 손실 함수 $L$에 얼마나 영향을 미치는지에 대한 값이다.

$$
\frac{\partial L}{\partial \mathbf{y}}\in\mathbb{R}^{m}
$$

**Local Gradient**

현재 노드에서 입력 $\mathbf{x}$가 변할 때 출력 $\mathbf{y}$가 얼마나 변하는지를 나타낸다.

$$
\frac{\partial \mathbf{y}}{\partial \mathbf{x}}\in\mathbb{R}^{m\times n}
~~,~~\frac{\partial \mathbf{y}}{\partial W}\in\mathbb{R}^{D_y\times D_z}
$$

Local Gradient는 입력 $X$의 모든 각각의 원소가 출력 $Z$의 모든 각각의 원소에 미치는 영향을 나타내므로, 4차원 텐서가 된다.

이때, Local Gradient 행렬을 Jacobian Matrix라고 부른다.

**Downstream Gradient**

노드의 입력 $\mathbf{x},\mathbf{w}$가 최종 손실 함수에 얼마나 영향을 미치는지를 나타낸다.

$$
\frac{\partial L}{\partial \mathbf{x}}\in\mathbb{R}^n~~,~~
\frac{\partial L}{\partial W}\in\mathbb{R}^{m\times n}
$$

즉, 역전파를 할 때 기울기 행렬의 크기는 원래 변수의 크기와 동일하다.

### 4. 입출력이 행렬인 경우: 배치 처리 (Matrix to Matrix)

$B$개의 배치가 있고, 각 배치에서 $n$개의 노드가 $m$개의 노드로 연결되는 경우를 생각해보자.

![fig9](dl/nn/2-9.png){: style="display:block; margin:0 auto; width:30%;"}

입력 데이터 $X$는 행렬, 가중치 $W$는 4차원 텐서이고, 이 둘의 내적을 통해 계산된 출력 $Z$는 행렬이다.

$$
X\in\mathbb{R}^{n\times B},W\in\mathbb{R}^{(m\times B)\times(n\times B)}~~,~~Y=WX\in\mathbb{R}^{m\times B}
$$

**Upstream Gradient**

노드의 출력 $\mathbf{y}$가 최종 손실 함수 $L$에 얼마나 영향을 미치는지에 대한 값이다.

$$
\frac{\partial L}{\partial Y}\in\mathbb{R}^{m}
$$

**Local Gradient**

현재 노드에서 입력 $X$가 변할 때 출력 $Y$가 얼마나 변하는지를 나타낸다.

$$
\frac{\partial Y}{\partial X}\in\mathbb{R}^{m\times n}
~~,~~\frac{\partial Y}{\partial W}\in\mathbb{R}^{D_y\times D_z}
$$


**Downstream Gradient**

노드의 입력 $X,W$가 최종 손실 함수에 얼마나 영향을 미치는지를 나타낸다.

$$
\frac{\partial L}{\partial X}\in\mathbb{R}^n~~,~~
\frac{\partial L}{\partial W}\in\mathbb{R}^{m\times n}
$$

즉, 역전파를 할 때 기울기 행렬의 크기는 원래 변수의 크기와 동일하다.

#### ReLU 함수에서의 역전파

ReLU는 Element-wise 연산이기 때문에 $x_1$은 $z_1$에만 영향을 주고 $z_2, z_3$ 등에는 영향을 주지 않는다.

따라서 Local Gradient는 대각선 성분만 값을 가지고 나머지는 모두 0인 대각 행렬이다.

![fig7](dl/nn/2-7.png){: style="display:block; margin:0 auto; width:70%;"}
_출처: Stanford CS231n, Lecture 4 (Neural Networks and Backpropagation)_

결과적으로 역전파 때, 원래 입력이 양수였던 요소의 기울기만 그대로 전파되고, 음수였던 곳은 0이 된다.

$$
\left(\frac{\partial L}{\partial \mathbf{x}}\right)_i=
\begin{cases}
\left(\frac{\partial L}{\partial \mathbf{z}}\right)_i&x_i>0\\
0&\text{otherwise}
\end{cases}
$$
