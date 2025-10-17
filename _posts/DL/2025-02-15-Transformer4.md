---
title: "[트랜스포머] Feed-Forward Network"
date: 2025-02-15 18:00:00 +/-TTTT
categories: [AI, 딥러닝]
tags: [트랜스포머]
math: true
toc: true
author: sunho
---

해당 포스트는 3Blue1Brown님의 [「*How might LLMs store facts*」](https://www.youtube.com/watch?v=9-Jl0dxWQs8&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=8) 영상을 참고하였습니다.

![fig0](dl/transformer/4-0.png){: style="display:block; margin:0 auto; width:40%;"}
_출처: Attention Is All you Need_

## Feed-Forward Network (FFN)

Feed-Forward Network는 크게 Up-projection, Activation, Down-projection으로 이루어져 있다.

![fig1](dl/transformer/4-1.png){: style="display:block; margin:0 auto; width:70%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=9-Jl0dxWQs8&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=8)_

이 구조는 Attention layer를 통과한 각 입력 벡터 $\mathbf{e}_i$에 대해 독립적으로 적용된다.

여기서 독립적으로 동작한다는 것은 각 단어 벡터가 서로 정보를 주고받지 않는다는 의미이지, 벡터마다 다른 가중치 행렬을 사용한다는 뜻이 아니다.
즉, 모든 임베딩 벡터는 동일한 가중치 행렬 $W_{\uparrow},W_{\downarrow}$를 공유하며, 각 벡터는 별도로 FFN을 통과한다.

![fig2](dl/transformer/4-2.png){: style="display:block; margin:0 auto; width:70%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=9-Jl0dxWQs8&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=8)_

### Up-projection

특정 인코딩 벡터에 대한 up-projection 연산은 아래와 같이 정의된다.

$$
\mathbf{x}_i=W_{\uparrow}\mathbf{e}_i'+\mathbf{b}_{\uparrow}=
\begin{bmatrix}-\mathbf{w}_1-\\-\mathbf{w}_2-\\\vdots\\-\mathbf{w}_{d_u}-\end{bmatrix}
\begin{bmatrix}|\\\mathbf{e}_i\\|\end{bmatrix}+\mathbf{b}_{\uparrow}
=\begin{bmatrix}\mathbf{w}_1^\top\mathbf{e}_i+b_1\\\mathbf{w}_2^\top\mathbf{e}_i+b_2\\\vdots\\\mathbf{w}_{d_u}^\top\mathbf{e}_i+b_{d_u}\end{bmatrix}\in\mathbb{R}^{d_u}
$$

여기서 가중치 행렬 $W_{\uparrow}$의 크기는 $d_u\times d$이며, 일반적으로 $d_u>d$이다. 하드웨어 효율을 고려하여 보통 $d_u$는 $d$의 상수배로 설정한다.

이때 $W_{\uparrow}$의 각 행 벡터 $\mathbf{w}_j$는 입력 벡터의 서로 다른 특징을 조사하는 일종의 질문으로 해석할 수 있다. 즉, 입력 임베딩에 대해 $d_u$개의 서로 다른 질문을 던지는 것으로 볼 수 있다.

예를 들어, 어떤 벡터 $\mathbf{e}$가 'Michael'과 'Jordan'의 정보를 모두 담고 있다고 하자. 만약 첫 번째 행 $\mathbf{w}_1$이 '이 단어는 사람 이름인가?'라는 질문을 나타낸다면, 내적값 $\mathbf{w}_1^\top\mathbf{e}$는 클 것이다. 반면, 두 번째 행 $\mathbf{w}_2$이 '이 단어는 도시 이름인가?'라는 질문을 나타낸다면, 내적값 $\mathbf{w}_2^\top\mathbf{e}$은 작을 것이다.

### 활성 함수 (Activation Function)

언어는 본질적으로 비선형 과정이기 때문에, 비선형성을 부여하기 위해 활성 함수를 적용한다.

$$
\mathbf{y}_i=\begin{bmatrix}f(x_1)\\f(x_2)\\\vdots\\f(x_{d_u})\end{bmatrix}\in\mathbb{R}^{d_u}
$$

여기서 각 $x_j$는 뉴런의 입력값으로 볼 수 있으며, 활성 함수 $f(\cdot)$로는 ReLU, GELU 등의 함수를 사용한다.

### Down-projection

up-projection과 활성 함수를 거친 벡터 $\mathbf{y}_i$를 다시 원래 차원 $d$로 되돌리는 과정을 down-projection이라고 하며, 이 연산은 아래와 같이 정의된다.

$$
\mathbf{z}_i=W_{\downarrow}\mathbf{y}_i'+\mathbf{b}_{\downarrow}=
\begin{bmatrix}|&|&&|\\\mathbf{w}_1&\mathbf{w}_2&\cdots&\mathbf{w}_{d_u}\\|&|&&|\end{bmatrix}
\begin{bmatrix}y_1\\y_2\\\vdots\\y_{d_u}\\\end{bmatrix}+\mathbf{b}_{\downarrow}
=y_1\mathbf{w}_1+y_2\mathbf{w}_2+\cdots+y_{d_u}\mathbf{w}_{d_u}+\mathbf{b}_{\downarrow}\in\mathbb{R}^{d}
$$

여기서 가중치 행렬 $W_{\downarrow}$의 크기는 $d_u\times d$이다.

이 연산은 열 벡터의 선형 결합으로 해석할 수 있다.

각 열 벡터 $\mathbf{w}_j$는 $j$번째 뉴런과 대응되며, 그 활성값 $y_j$가 클수록 해당 방향의 벡터가 최종 출력 $\mathbf{z}_k$에 더 큰 영향을 미친다.

이를 up-projection과 함께 생각해보자.

예를 들어, 입력 벡터 $\mathbf{e}$가 'Michael Jordan’의 정보를 담고 있다고 하자. $W_{\uparrow}$의 첫 번째 행이 '농구 선수인가요?'라는 질문을 반영하고 있다면, 그에 대한 내적값 $y_1$ 값은 크게 나타날 것이다.

이때 모델이 $W_{\downarrow}$의 첫 번째 열 벡터를 농구 개념과 관련된 방향으로 학습했다면, $y_1$ 값이 크기 때문에 해당 방향이 출력 벡터 $\mathbf{z}$에 많이 반영될 것이다.

결과적으로 얻어진 벡터 $\mathbf{z}$는 원래 임베딩 $\mathbf{e}$에 더해지면서, 해당 단어의 표현을 '농구'라는 의미 방향으로 이동시키게 된다.

![fig3](dl/transformer/4-3.png){: style="display:block; margin:0 auto; width:90%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=9-Jl0dxWQs8&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=8)_

## 예측 (Prediction)

최종 예측은 마지막 토큰의 벡터만 사용하여 수행한다.

트랜스포머 모델의 목표는 주어진 문맥 다음에 올 **'바로 그 다음 단어'**를 예측하는 것입니다.

문맥의 집약체: 모델의 마지막 레이어에 있는 각 토큰의 벡터는 그 자체의 의미뿐만 아니라, 어텐션 메커니즘을 통해 문장 전체의 문맥 정보를 흡수한 결과물입니다.

최종 정보: 특히 마지막 토큰의 벡터는 문장 전체("Michael Jordan plays the sport of")를 모두 고려한 후, "이제 다음에 뭐가 와야 할까?"에 대한 모든 정보를 압축하여 담고 있는 최종 결과물입니다.

마지막 layer의 벡터를 사전 크기의 벡터로 확장한다.

이후 소프트맥스 함수를 적용해 각 단어에 대한 확률 분포로 변환한다. 이후 이 확률 분포에서 가장 높은 확률을 가진 단어(예: "basketball")가 최종 예측 결과로 선택됩니다.

$$
\text{softmax}\left(W_O\mathbf{z}\right)\in\mathbb{R}^{V}
$$

![fig4](dl/transformer/4-4.png){: style="display:block; margin:0 auto; width:70%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=9-Jl0dxWQs8&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=8)_

### Temperature

MLP는 트랜스포머 전체 파라미터의 약 $2/3$를 차지한다.

![fig5](dl/transformer/4-5.png){: style="display:block; margin:0 auto; width:70%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=9-Jl0dxWQs8&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=8)_

MLP는 트랜스포머 전체 파라미터의 약 $2/3$를 차지한다.

![fig6](dl/transformer/4-6.png){: style="display:block; margin:0 auto; width:70%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=9-Jl0dxWQs8&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=8)_

## 파라미터 개수

MLP는 트랜스포머 전체 파라미터의 약 $2/3$를 차지한다.

![fig7](dl/transformer/4-7.png){: style="display:block; margin:0 auto; width:70%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=9-Jl0dxWQs8&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=8)_
