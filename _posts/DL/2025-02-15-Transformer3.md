---
title: "[트랜스포머] Self-Attention"
date: 2025-02-15 12:00:00 +/-TTTT
categories: [AI, 딥러닝]
tags: [트랜스포머]
math: true
toc: true
author: sunho
---

해당 포스트는 3Blue1Brown님의 [「*Attention in transformers, step-by-step*」](https://www.youtube.com/watch?v=eMlx5fFNoYc&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=7) 영상을 참고하였습니다.

## Attention

앞선 포스트에서 언급했듯이, 단어 임베딩만으로는 각 단어의 문맥적 의미를 파악하지 못한다.

attention block은 단어의 의미를 더 명확하게 하는 것뿐만 아니라 한 임베딩에 담긴 정보를 다른 임베딩으로 옮길 수 있게 도와준다.

예를 들어, Tower라는 단어는 큰 건물이라는 일반적인 의미를 담고 있을 것이다. 하지만 그 앞에 Eiffel이라는 단어가 붙게 되면 Eiffel Tower라는 단어자체가 에펠탑과 관련된 방향으로 업데이트된다. 만약 앞에 Miniature라는 단어가 붙게 되면 이 벡터는 더이상 큰 의미와는 완전히 거리가 멀어지게 된다.

![fig1](dl/transformer/3-1.png){: style="display:block; margin:0 auto; width:100%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=eMlx5fFNoYc&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=7)_

이해하기 쉽게, 형용사에 의해서 명사의 정보가 업데이트된다고 생각하면 된다.

![fig2](dl/transformer/3-2.png){: style="display:block; margin:0 auto; width:65%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=eMlx5fFNoYc&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=7)_

Attention 연산은 아래와 같이 정의된다.

$$
\text{softmax}(\frac{QK^\top}{\sqrt d_k}V)
$$

여기서 $Q$는 쿼리 (Query), $K$는 키 (Key), $V$는 밸류 (Value), $\sqrt{d_k}$는 의미한다.

그럼 각각이 뭔지에 대해서 알아보자.

### 쿼리와 키 (Query, Key)

먼저, Query와 Key는 각각 단어 임베딩에 Query 행렬 $W_Q\in\mathbb{R}^{e\times q}$, Key 행렬 $W_K\in\mathbb{R}^{e\times k}$을 곱해 만든다.

$Q$와 $K$의 차원을 각각 $q$, $k$라고 했을 때, 일반적으로 임베딩 차원 $e$보다 훨씬 작게 설정한다.

$$
Q=W_QE=\begin{bmatrix}|&&|\\Q_1&\cdots&Q_n\\|&&|\end{bmatrix}\in\mathbb{R}^q
~~,~~
K=W_KE=\begin{bmatrix}|&&|\\K_1&\cdots&K_n\\|&&|\end{bmatrix}\in\mathbb{R}^k
$$

Query와 Key 행렬은 학습 가능한 파라미터로 이루어져 있으며, 임베딩 공간에 있는 단어 토큰을 쿼리 공간으로 매핑시켜주는 역할을 한다.

![fig3](dl/transformer/3-3.png){: style="display:block; margin:0 auto; width:80%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=eMlx5fFNoYc&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=7)_

Query는 질문을 하는 , Key는 질문에 대해 답을 찾는 도구로 볼 수 있다.

예를 들어, Query가 '나를 수식하는 형용사 어딨어?'하고 물어보면 Key는 '여기 있어요.'

이를 내적으로 표현한다.

아래 그림에서 원의 크기는 내적값의 크기를 나타낸다. 보면 'fluffy'와 'blue'라는 형용사가 'creature'라는 명사와 관련이 있기 때문에 내적값이 큰 것을 확인할 수 있다. 이는 두 형용사가 'creature'에 집중하고 있다는 것을 나타낸다. 반대로 'the'라는 관사는 'creature'와 관련이 별로 없기 때문에 큰 음수값으로 나타나는 것을 확인할 수 있다.

![fig4](dl/transformer/3-4.png){: style="display:block; margin:0 auto; width:90%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=eMlx5fFNoYc&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=7)_

![fig5](dl/transformer/3-5.png){: style="display:block; margin:0 auto; width:80%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=eMlx5fFNoYc&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=7)_

![fig6](dl/transformer/3-6.png){: style="display:block; margin:0 auto; width:80%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=eMlx5fFNoYc&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=7)_

### 밸류 (Value)

Value 역시 마찬가지로 각각 단어 임베딩에 Value 행렬 $W_V\in\mathbb{R}^{e\times v}$을 곱해 만든다.

## Self-Attention과 Cross-Attention



## Multi-Head Attention



## Masked Self-Attention


