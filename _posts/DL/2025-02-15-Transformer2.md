---
title: "[트랜스포머] 트랜스포머의 구조 2 - 임베딩 (Embedding)"
date: 2025-02-15 06:00:00 +/-TTTT
categories: [AI, 딥러닝]
tags: [트랜스포머]
math: true
toc: true
author: sunho
---

해당 포스트는 3Blue1Brown님의 ['*Transformers, the tech behind LLMs*'](https://www.youtube.com/watch?v=wjZofJX0v4M&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=6) 영상을 참고하였습니다.

![fig0](dl/transformer/2-0.png){: style="display:block; margin:0 auto; width:40%;"}
_출처: [Attention Is All you Need](https://arxiv.org/abs/1706.03762)_

## 토큰화 (Tokenization)

임베딩 전, 입력 문장을 여러 개의 토큰 (token)으로 분리한다. 토큰은 문장을 구성하는 최소 의미 단위로, 여러 단위로 분리할 수 있다.

**단어 단위로 분리**

$$
\text{I love playing football.}\to\left[~\text{“I”},\text{“love”},\text{“playing”},\text{“football”},\text{“.”}~\right]
$$

**문자 단위로 분리**

$$
\text{I love playing football.}\to\left[~\text{“I”},\text{“~”},\text{“l”},\text{“o”},\text{“v”},\cdots,\text{“l”},\text{“l”}\text{“.”}~\right]
$$

**서브워드 (subword) 단위로 분리**

$$
\text{I love playing football.}\to\left[~\text{“I”},\text{“love”},\text{“play”},\text{“##ing”},\text{“foot”},\text{“##ball”},\text{“.”}~\right]
$$

컴퓨터는 텍스트를 직접 이해할 수 없고, 숫자 형태로만 계산할 수 있다. 따라서 모델을 학습하기 전에, 학습 과정에서 사용할 단어들의 목록인 사전 (vocabulary)을 미리 정의해야 한다.

만약 입력 문장에 사전에 없는 단어가 등장하면, 해당 단어는 UNK (unknown) 토큰으로 대체된다.

## 단어 임베딩 (Word Embedding)

위와 같이 문장을 단어 단위로 분리한 뒤 각 단어를 숫자 벡터로 변환하는 과정을 임베딩이라고 하며, 이렇게 변환된 벡터를 단어 임베딩 (Word Embedding)이라고 부른다.

단어 임베딩은 각 단어를 고차원의 벡터로 표현하며, 이때 단어 임베딩의 차원을 임베딩 차원이라고 한다.

즉, 단어 임베딩은 그 단어의 의미 정보만을 가지고 있는 고차원의 벡터이며, 위치 인코딩을 통해 단어의 위치 정보도 포함하고 있다. <span style="background-color:#fff5b1">단어 임베딩 자체만으로는 문맥적인 정보는 포함하지 않는다.</span>

![fig1](dl/transformer/2-1.png){: style="display:block; margin:0 auto; width:70%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=wjZofJX0v4M&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=6)_

사전 내의 각 단어의 벡터로 변환된 사전을 임베딩 행렬 (Embedding Matrix) $W_E$ 라고 하며, 각 임베딩 벡터는 랜덤값에서 시작하여 학습을 통해 조정된다.

![fig2](dl/transformer/2-2.png){: style="display:block; margin:0 auto; width:90%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=wjZofJX0v4M&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=6)_

아래 그림은 고차원 공간의 단어 임베딩을 3차원 공간에서 시각화한 것이다.

![fig3](dl/transformer/2-3.png){: style="display:block; margin:0 auto; width:50%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=wjZofJX0v4M&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=6)_

단어 임베딩은 아무렇게나 학습되는 것이 아니라, 각 단어의 의미를 반영하도록 학습된다.

예를 들어 아래 그림에서 '남자' 임베딩과 '여자' 임베딩의 차이 (노란색 벡터)는 '왕' 임베딩과 '여왕' 임베딩의 차이와 유사한 방향을 가진다.

이는 곧, 우리가 '여왕' 임베딩에 대한 정보가 없더라도, '왕' 임베딩에 노란색 벡터를 더함으로써 '여왕' 임베딩을 근사적으로 얻을 수 있다는 말이 된다.

$$
E(\text{queen})\approx E(\text{king})+\left(E(\text{woman})-E(\text{man})\right)
$$

즉, 이 공간에서 노란색 벡터의 방향은 '성별'에 대한 의미적 정보를 담고 있다고 볼 수 있다.

![fig4](dl/transformer/2-4.png){: style="display:block; margin:0 auto; width:50%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=wjZofJX0v4M&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=6)_

또 한가지 예로, 아래 그림에서 노란색 벡터의 방향은 '복수형'에 대한 의미적 정보를 담고 있다.

![fig5](dl/transformer/2-5.png){: style="display:block; margin:0 auto; width:50%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=wjZofJX0v4M&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=6)_

실제로 확인해보면, $\overrightarrow{\text{plur}}$ 벡터와 복수형 단어 임베딩의 내적값이 단수형 단어 임베딩의 내적값보다 더 큰 것을 확인할 수 있을 것이다.

$$
\overrightarrow{\text{plur}}\cdot E(\text{dog})=-1.13~~,~~
\overrightarrow{\text{plur}}\cdot E(\text{dogs})=3.40
$$

## 위치 인코딩 (Positional Encoding)

Attention과 이런 블록들은 단순 점곱으로 이루어져있으며 위치에 대한 정보를 간과할 수 있다.

각 토큰의 실제 위치를 고려하지 않는다. 

1. 각각의 고유한 위치는 고유한 값을 가져야됨
2. 위치값을 제어하는 기본 법칙이 있어야됨
3. 토큰간 거리를 추정하는 능력
4. 학습때 사용한 문장보다 더 긴 시퀀스를 발견하더라도 일반화할 수 있어야 함

먼저 정의에 대해서 살펴보고 왜 이렇게 하는지 알아보자.

위치 인코딩 (Sinusoidal Positional Encoding)은 아래와 같이 정의된다.

$$
PE(pos,2i)=\sin\left(\frac{pos}{10000^{2i/d}}\right)
$$

$$
PE(pos,2i+1)=\cos\left(\frac{pos}{10000^{2i/d}}\right)
$$

여기서 $d$는 고정된 임베딩 차원, $pos$는 토큰의 인덱스 $i$는 임베딩 차원의 인덱스를 의미한다.

차원 인덱스가 낮을수록 (앞쪽 차원일수록) 낮은 주파수의 함수를, 인덱스가 높을수록 (뒤쪽 차원일수록) 높은 주파수의 함수를 가진다.

![fig6](dl/transformer/2-6.png){: style="display:block; margin:0 auto; width:70%;"}
_[[출처: BrainDrain]](https://www.youtube.com/watch?v=T3OT8kqoqjc)_

아래 그림에서 position을 $x$축, depth를 $y$축으로 보면, depth가 깊어질수록 주기가 길어지는 것을 확인할 수 있다.

![fig7](dl/transformer/2-7.png){: style="display:block; margin:0 auto; width:70%;"}

예를 들어 임베딩 차원이 $d=8$이라면, 첫 번째 단어 $(pos=0)$와 두 번째 단어 $(pos=1)$의 아래와 같다.

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

최종적으로 더해서 임베딩 벡터를 만든다.

$$
\mathbf{e}_i'=\mathbf{e}_i+\mathbf{p}_i
$$

concat하면 비용이 늘어나므로 단순히 더함

모델이 학습중 위치 정보를 추출하는 방법에 대한 직관을 개발할 것임

### 직관적 이해



![fig8](dl/transformer/2-8.gif){: style="display:block; margin:0 auto; width:70%;"}
_[[출처: Serrano.Academy]](https://www.youtube.com/watch?v=IHu3QehUmrQ)_

![fig9](dl/transformer/2-9.png){: style="display:block; margin:0 auto; width:90%;"}
_[[출처: Serrano.Academy]](https://www.youtube.com/watch?v=IHu3QehUmrQ)_
