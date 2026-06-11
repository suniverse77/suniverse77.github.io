---
title: "[트랜스포머] 위치 인코딩 (Positional Encoding)"
date: 2025-02-18 00:00:00 +/-TTTT
categories: [AI, 트랜스포머]
tags: [트랜스포머]
math: true
toc: true
author: sunho
---

### 위치 인코딩 (Positional Encoding)

트랜스포머의 Attention과 Feed-Forward 블록은 모두 순서 개념이 없는 dot product 연산으로 구성되어 있다.
따라서 모델은 입력 토큰의 위치 정보를 스스로 인식할 수 없으며, 단어의 순서를 고려하지 않고 처리하게 되는 문제가 발생한다.

이를 해결하기 위해, 각 토큰의 위치를 벡터 형태로 인코딩하여 입력 임베딩에 더해주는 방식을 사용한다.
이 벡터를 위치 인코딩 (Positional Encoding)이라고 한다.

위치 인코딩이 갖춰야 할 조건은 아래와 같다.

- 모든 위치는 각각 고유한 값을 가져야 한다.
- 위치 간의 관계를 표현하는 일정한 규칙이 존재해야 한다.
- 두 위치 간의 거리를 추정할 수 있어야 한다.
- 학습 시 본 적 없는 더 긴 문장에 대해서도 일반화가 가능해야 한다.

이러한 요구를 만족하기 위해, 트랜스포머에서는 $\sin$ 함수와 $\cos$ 함수를 이용한
Sinusoidal Positional Encoding을 사용한다.

먼저 정의에 대해서 살펴보고 왜 이렇게 하는지 알아보자. Sinusoidal Positional Encoding은 아래와 같이 정의된다.

$$
PE(pos,2i)=\sin\left(\frac{pos}{10000^{2i/d}}\right)
$$

$$
PE(pos,2i+1)=\cos\left(\frac{pos}{10000^{2i/d}}\right)
$$

여기서 $d$는 고정된 임베딩 차원, $pos$는 토큰의 위치 인덱스 $i$는 임베딩 차원의 인덱스를 의미한다.

차원 인덱스가 낮을수록 (앞쪽 차원일수록) 낮은 주파수를, 인덱스가 높을수록 (뒤쪽 차원일수록) 높은 주파수를 사용한다.

![fig6](AI/Transformer/Transformer2-6.png){: style="display:block; margin:0 auto; width:60%;"}
_[[출처: BrainDrain]](https://www.youtube.com/watch?v=T3OT8kqoqjc)_

아래 그림에서 position을 $x$축, depth를 $y$축으로 볼 수 있으며, depth가 깊어질수록 주기가 길어지는 것을 확인할 수 있다.

![fig7](AI/Transformer/Transformer2-7.png){: style="display:block; margin:0 auto; width:70%;"}

예를 들어 임베딩 차원이 $d=8$이라면, 첫 번째 단어 $(pos=0)$와 두 번째 단어 $(pos=1)$의 위치 인코딩은 아래와 같다.

$$
\mathbf{p}_0=
\begin{bmatrix}
\sin\left(\frac{0}{10000^{0/8}}\right)\\
\cos\left(\frac{0}{10000^{0/8}}\right)\\
\sin\left(\frac{0}{10000^{2/8}}\right)\\
\cos\left(\frac{0}{10000^{2/8}}\right)\\
\vdots
\end{bmatrix}=
\begin{bmatrix}
\sin\left(0\right)\\
\cos\left(0\right)\\
\sin\left(0\right)\\
\cos\left(0\right)\\
\vdots
\end{bmatrix}\in\mathbb{R}^d
~~,~~
\mathbf{p}_1=
\begin{bmatrix}
\sin\left(\frac{1}{10000^{0/8}}\right)\\
\cos\left(\frac{1}{10000^{0/8}}\right)\\
\sin\left(\frac{1}{10000^{2/8}}\right)\\
\cos\left(\frac{1}{10000^{2/8}}\right)\\
\vdots
\end{bmatrix}=
\begin{bmatrix}
\sin\left(1\right)\\
\cos\left(1\right)\\
\sin\left(\frac{1}{10}\right)\\
\cos\left(\frac{1}{10}\right)\\
\vdots
\end{bmatrix}\in\mathbb{R}^d
$$

최종 입력 벡터는 원래의 단어 임베딩 $\mathbf{e}_i$에 위치 인코딩 $\mathbf{p}_i$를 더하여 만든다.

$$
\mathbf{e}_i'=\mathbf{e}_i+\mathbf{p}_i
$$

Concat을 사용할 경우 차원이 불필요하게 증가하기 때문에 덧셈으로 처리한다.

덧셈을 통해 각 차원의 위치 신호가 단어 임베딩의 의미 공간에 자연스럽게 섞이게 되며, 모델은 학습 과정에서 이 패턴을 이용해 위치 관계를 유추하는 직관을 형성한다.

### 직관적 이해

각 단어 임베딩의 차원이 $d=2$라고 가정하자.

이때 임베딩 벡터의 두 차원을 각각 $x$축과 $y$축의 좌표로 볼 수 있다.

$$
\mathbf{p}_t=
\begin{bmatrix}\sin\left(\frac{t}{10000^i}\right)\\\cos\left(\frac{t}{10000^i}\right)\end{bmatrix}=\begin{bmatrix}y\\x\end{bmatrix}
$$

위치 $t$가 증가함에 따라 벡터의 방향이 점진적으로 회전한다. 즉, 각 위치 벡터는 서로 다른 위상을 갖게 되며, 결과적으로 모든 단어가 2차원 평면에서 고유한 방향을 가지게 된다.

![fig8](AI/Transformer/Transformer2-8.gif){: style="display:block; margin:0 auto; width:70%;"}
_[[출처: Serrano.Academy]](https://www.youtube.com/watch?v=IHu3QehUmrQ)_

이제 $d=6$으로 확장하면, 각 벡터는 6차원 공간에서 각각 고유한 방향을 가리킬 것이다.

![fig9](AI/Transformer/Transformer2-9.png){: style="display:block; margin:0 auto; width:90%;"}
_[[출처: Serrano.Academy]](https://www.youtube.com/watch?v=IHu3QehUmrQ)_