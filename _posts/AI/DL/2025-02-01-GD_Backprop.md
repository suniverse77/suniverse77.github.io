---
title: "[NN] 경사 하강법과 역전파"
date: 2025-02-01 06:00:00 +/-TTTT
categories: [AI, 딥러닝]
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
w_{new}\leftarrow w_{old}-\alpha\nabla_w\mathcal{L}
$$

위의 수식에서 $\alpha$는 학습률 (Learning Rate)로, 한 번에 얼마나 이동할지인 보폭을 의미한다.

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

![fig2](dl/nn/2-2.png){: style="display:block; margin:0 auto; width:80%;"}
_출처: Stanford CS231n, Lecture 4 (Neural Networks and Backpropagation)_

- **순전파 (Forward pass)**에서는 입력에서 출발해 그래프를 따라가면서 각 노드의 출력을 차례대로 계산하며, 최종적으로 손실 함수 값 $L$을 얻는다.
- **역전파 (Backward pass)**에서는 출력에서 입력 방향으로 그래프를 거슬러 올라가면서 chain rule을 이용해 각 파라미터에 대한 손실의 기울기 $\nabla_WL$를 계산한다.

### 입력이 스칼라인 경우

스칼라 함수

![fig3](dl/nn/2-3.png){: style="display:block; margin:0 auto; width:80%;"}
_출처: Stanford CS231n, Lecture 4 (Neural Networks and Backpropagation)_

<details>
<summary><font color='#FF0000'>Example 1</font></summary>
<div markdown="1">



---

</div>
</details>

<details>
<summary><font color='#FF0000'>Example 2</font></summary>
<div markdown="1">



---

</div>
</details>
<br>



### 입력이 벡터인 경우

벡터 함수

### 입력이 행렬인 경우
