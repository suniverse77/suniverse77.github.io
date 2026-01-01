---
title: "[트랜스포머] 트랜스포머의 구조 3 - Attention"
date: 2025-02-15 12:00:00 +/-TTTT
categories: [AI, 트랜스포머]
tags: [트랜스포머]
math: true
toc: true
author: sunho
---

해당 포스트는 3Blue1Brown님의 [*'Attention in transformers, step-by-step'*](https://www.youtube.com/watch?v=eMlx5fFNoYc&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=7) 영상을 참고하였습니다.

![fig0](dl/transformer/3-0.png){: style="display:block; margin:0 auto; width:40%;"}
_출처: [Attention Is All you Need](https://arxiv.org/abs/1706.03762)_

## Attention

이전 포스트에서 언급했듯이, 단어 임베딩만으로는 단어의 문맥적 의미를 파악할 수 없다. 이 문제를 해결하기 위해 도입한 것이 어텐션 메커니즘이다.

Attention은 각 단어의 의미를 더 정교하게 만드는 것뿐만 아니라, 하나의 임베딩이 다른 임베딩으로부터 필요한 정보를 선택적으로 받아들일 수 있도록 도와준다. 즉, 문맥에 따라 단어의 표현을 업데이트하는 역할을 한다.

예를 들어, 'Tower'라는 단어는 일반적으로 큰 건물을 의미한다. 하지만 그 앞에 'Eiffel'이라는 단어가 붙게 되면 'Eiffel Tower'라는 표현 자체가 '에펠탑'이라는 특정 대상을 나타내는 방향으로 업데이트된다.

반대로 앞에 'Miniature'라는 단어가 붙게 되면, 해당 임베딩은 큰 건물의 의미와는 거리가 멀어지고 '작은 모형'의 의미 쪽으로 조정된다.

![fig1](dl/transformer/3-1.png){: style="display:block; margin:0 auto; width:100%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=eMlx5fFNoYc&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=7)_

형용사에 의해서 명사의 의미가 좀 더 구체적으로 변한다고 생각하면 더 이해하기 쉬울 것이다.

아래 그림에서 명사 'creature'의 임베딩 $E_4$가 형용사 'fluffy'와 'blue'의 임베딩 $E_2,E_3$에 의해서 '파랗고 복슬복슬한 생명체'를 나타내는 새로운 임베딩 $E_4'$로 변환된다.

![fig2](dl/transformer/3-2.png){: style="display:block; margin:0 auto; width:65%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=eMlx5fFNoYc&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=7)_

단어 임베딩을 행벡터로 볼 경우, Attention 연산은 아래와 같이 정의된다.

$$
\text{Attention}(Q,K,V)=\text{softmax}\left(\frac{QK^\top}{\sqrt d_k}\right)V
$$

여기서 $Q$는 쿼리 (Query), $K$는 키 (Key), $V$는 밸류 (Value)를 의미한다. $\sqrt{d_k}$는 스케일링 계수로, 내적값이 지나치게 커지는 것을 방지한다.

그럼 각각이 뭔지에 대해서 알아보자.

### Query & Key

먼저, Query와 Key는 각각 단어 임베딩 $E$에 Query 행렬 $W_Q\in\mathbb{R}^{d_k\times q}$, Key 행렬 $W_K\in\mathbb{R}^{d_k\times k}$을 곱해 생성된다.

$$
Q=E\cdot W_Q=\begin{bmatrix}&-\mathbf{q}_1-&\\&\vdots&\\&-\mathbf{q}_n-&\end{bmatrix}\in\mathbb{R}^{n\times d_k}
~~,~~
K=E\cdot W_K=\begin{bmatrix}&-\mathbf{k}_1-&\\&\vdots&\\&-\mathbf{k}_n-&\end{bmatrix}\in\mathbb{R}^{n\times d_k}
$$

여기서 $n$은 입력 토큰 개수, $d$는 임베딩 차원, $d_k$는 Query와 Key의 차원을 의미한다. 일반적으로 $d_k<e$로 설정한다.

Query와 Key 행렬은 모두 학습 가능한 파라미터로 이루어져 있으며, 임베딩 공간에 존재하는 단어 벡터를 쿼리 공간 (query space)과 키 공간 (key space)으로 매핑하는 역할을 한다.

![fig3](dl/transformer/3-3.png){: style="display:block; margin:0 auto; width:80%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=eMlx5fFNoYc&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=7)_

직관적으로 보면, Query는 질문을 하는 도구, Key는 질문에 답을 제공하는 단서로 볼 수 있다.

예를 들어, Query가 '나를 수식하는 형용사는 어디 있어?'라고 물어보면 Key는 '여기 있어요!' 또는 '저는 아니에요!'라고 답하는 셈이다.

이러한 과정은 내적 (dot product)을 통해 계산되며, 내적값이 클수록 두 단어가 서로 의미적으로 강하게 관련되어 있음을 의미한다.

아래 그림에서 원의 크기는 내적값의 크기를 나타낸다. 'fluffy'와 'blue' 같은 형용사는 'creature'라는 명사와 의미적으로 연관되어 있어 큰 양수값을 갖는다. 이는 곧, 이 두 형용사가 'creature'에 더 집중하고 있다는 것을 의미한다. 반면, 'the'와 같은 관사는 'creature'와의 연관성이 낮아 내적값이 작거나 음수로 나타난다.

아래 그림은 단어 임베딩을 열벡터로 가정했기 때문에, $Q$와 $K$의 위치가 반대로 표현되어 있다.

![fig4](dl/transformer/3-4.png){: style="display:block; margin:0 auto; width:80%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=eMlx5fFNoYc&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=7)_

Query와 Key의 내적을 통해 생성된 행렬을 어텐션 맵 (Attention map)이라고 한다. Attention map은 문장 내에서 각 단어 쌍 간의 유사도 정보를 담고 있다.

$$
QK^\top=
\begin{bmatrix}\vphantom{\Big(}
\mathbf{q}_1\mathbf{k}_1^\top&\mathbf{q}_1\mathbf{k}_2^\top&\cdots&\mathbf{q}_1\mathbf{k}_n^\top\\
\mathbf{q}_2\mathbf{k}_1^\top&\mathbf{q}_2\mathbf{k}_2^\top&\cdots&\mathbf{q}_2\mathbf{k}_n^\top\\
\vdots&\vdots&\ddots&\vdots\\
\mathbf{q}_n\mathbf{k}_1^\top&\mathbf{q}_n\mathbf{k}_2^\top&\cdots&\mathbf{q}_n\mathbf{k}_n^\top
\end{bmatrix}\in\mathbb{R}^{n\times n}
$$

Attention map의 크기는 입력 토큰의 개수 $n$의 제곱에 비례하므로,
입력 길이가 길어질수록 연산량과 메모리 사용량이 빠르게 증가한다.

내적값을 통해 얻은 값은 실수 전체 범위를 가지기 때문에 음수나 매우 큰 양수 등이 섞여 있을 수 있다. 따라서 출력값을 정규화시키기 위해, 소프트맥스 함수를 이용하여 값들을 확률 분포 형태로 변환한다.

이때 행 방향 (`axis=1`)으로 소프트맥스 함수를 적용한다.

$$
\text{softmax}\left(QK^\top\right)=
\begin{bmatrix}
\text{softmax}(~\mathbf{q}_1\mathbf{k}_1^\top&\mathbf{q}_1\mathbf{k}_2^\top&\cdots&\mathbf{q}_1\mathbf{k}_n^\top~)\\
\text{softmax}(~\mathbf{q}_2\mathbf{k}_1^\top&\mathbf{q}_2\mathbf{k}_2^\top&\cdots&\mathbf{q}_2\mathbf{k}_n^\top~)\\
\vdots&\vdots&\ddots&\vdots\\
\text{softmax}(~\mathbf{q}_n\mathbf{k}_1^\top&\mathbf{q}_n\mathbf{k}_2^\top&\cdots&\mathbf{q}_n\mathbf{k}_n^\top~)
\end{bmatrix}\in\mathbb{R}^{n\times n}
$$

Attention map의 각 행은 해당 Query가 모든 Key들과 얼마나 유사한지를 나타낸다.

아래 그림은 단어 임베딩을 열벡터로 가정했기 때문에, 소프트맥스 함수를 열 방향 (`axis=0`)으로 적용하는 것으로 표현되어 있다.

![fig5](dl/transformer/3-5.png){: style="display:block; margin:0 auto; width:100%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=eMlx5fFNoYc&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=7)_

### Value

Value 역시 마찬가지로 각각 단어 임베딩에 Value 행렬 $W_V\in\mathbb{R}^{d\times d}$을 곱해 만든다.

$$
V=E\cdot W_V=\begin{bmatrix}&-\mathbf{v}_1-&\\&\vdots&\\&-\mathbf{v}_n-&\end{bmatrix}\in\mathbb{R}^{n\times d}
$$

Value 행렬도 학습 가능한 파라미터로 이루어져 있다.

직관적으로 보면, Value는 문장 내 다른 단어로부터 어떤 정보를 받아올지를 결정하는 벡터로 볼 수 있다.

예를 들어, 'creature'에 해당하는 쿼리 벡터 $\mathbf{q}_4$는 형용사 'fluffy'와 'blue'와 의미적으로 연관성이 높기 때문에, 내적값 $\mathbf{q}_4\mathbf{k}_2^\top$와 $\mathbf{q}_4\mathbf{k}_3^\top$은 상대적으로 클 것이다.

따라서 attention 결과 벡터 $\Delta\mathbf{e}_4$는 'fluffy'와 'blue'의 value 벡터 $\mathbf{v}_2$와 $\mathbf{v}_3$의 방향으로 더 큰 비중을 두어 결합된다. 이는 곧, 'creature'가 'fluffy'와 'blue' 단어의 정보를 받아와서 '파랗고 복슬복슬한 생명체'와 같은 문맥을 고려한 의미로 변환되는 것으로 볼 수 있다.

$$
\left(QK^\top\right)V=
\begin{bmatrix}
(\mathbf{q}_1\mathbf{k}_1^\top)\mathbf{v}_1+(\mathbf{q}_1\mathbf{k}_2^\top)\mathbf{v}_2+\cdots+(\mathbf{q}_1\mathbf{k}_n^\top)\mathbf{v}_n\\
\vdots\\
(\mathbf{q}_4\mathbf{k}_1^\top)\mathbf{v}_1+(\mathbf{q}_4\mathbf{k}_2^\top)\mathbf{v}_2+\cdots+(\mathbf{q}_4\mathbf{k}_n^\top)\mathbf{v}_n\\
\vdots\\
(\mathbf{q}_n\mathbf{k}_1^\top)\mathbf{v}_1+(\mathbf{q}_n\mathbf{k}_2^\top)\mathbf{v}_2+\cdots+(\mathbf{q}_n\mathbf{k}_n^\top)\mathbf{v}_n
\end{bmatrix}
=\begin{bmatrix}\Delta\mathbf{e}_1\\\vdots\\\Delta\mathbf{e}_4\\\vdots\\\Delta\mathbf{e}_n\end{bmatrix}\in\mathbb{R}^{n\times d}
$$

### Skip connection

포스터 상단의 트랜스포머 구조를 보면, `Add & Norm`이라는 블록이 존재한다.

이는 [skip connection]과 [layer normalization]을 의미하며, 연산은 아래와 같다.

$$
E'=E+\Delta E=\begin{bmatrix}\mathbf{e}_1+\Delta\mathbf{e}_1\\\mathbf{e}_2+\Delta\mathbf{e}_2\\\vdots\\\mathbf{e}_n+\Delta\mathbf{e}_n\end{bmatrix}\in\mathbb{R}^{n\times d}
$$

이는 원래 단어 임베딩 $\mathbf{e}$에 attention을 통해 얻은 변화량 $\Delta\mathbf{e}$를 더함으로써, 각 단어의 임베딩을 문맥적 의미를 반영한 새로운 임베딩으로 업데이트하는 것이다.

![fig6](dl/transformer/3-6.png){: style="display:block; margin:0 auto; width:90%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=eMlx5fFNoYc&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=7)_

## Self-Attention과 Cross-Attention

위에서 설명한 Attention 메커니즘은 Self-Attention이다. 이외에도 Cross-Attention이 있으며, 이 둘의 가장 큰 차이는 Query, Key, Value를 어디에서 가져오느냐이다.

포스터 상단의 트랜스포머 구조에서 빨간색과 노란색 박스에서는 Self-Attention을, 초록색 박스에서는 Cross-Attention을 사용한다.

### Self-Attention

Self-Attention은 $Q,K,V$를 모두 같은 입력에서 생성한다.

이는 한 문장 내의 각 단어가 서로의 연관성을 고려하여 문맥적 의미를 파악하도록 하는 구조이다.

예를 들어, `'The cat sat on the mat.'`에서 'cat'이 'mat' 또는 'sat'과 어떤 관계가 있는지를 학습함으로써 문장 내 의미적 연결성을 이해한다.

![fig7](dl/transformer/3-7.png){: style="display:block; margin:0 auto; width:50%;"}
_[[출처: 3Blue1Brown]](https://zzziito.tistory.com/56)_

### Cross-Attention

Cross-Attention은 $Q$는 하나의 입력, $K,V$는 다른 입력에서 생성한다.

이는 서로 다른 두 입력 간의 의미적 관계를 학습하도록 하는 구조이다.

예를 들어 한국어 → 영어 번역을 수행하는 트랜스포머의 디코더에서, $Q$는 현재 생성 중인 영어 단어에서 오고, $K$와 $V$는 인코더가 처리한 한국어 문장 정보에서 온다. 이를 통해 원문과 번역문 간의 대응 관계를 학습한다.

![fig8](dl/transformer/3-8.png){: style="display:block; margin:0 auto; width:50%;"}
_[[출처: 3Blue1Brown]](https://zzziito.tistory.com/56)_

## Masked Self-Attention

Masked Self-Attention은 기존 Self-Attention 구조에서 입력 시퀀스의 미래 토큰을 보지 못하도록 제한한 구조다. 이를 통해 모델이 다음 단어를 예측할 때 현재 시점 이전의 단어만 참고하도록 만든다.

하나의 문장에서 여러 개의 학습 데이터를 생성할 수 있다. 예를 들어 'the fluffy blue creature roamed the verdant forest.'라는 문장이 있을 때, 모델이 'the' 다음에 올 단어를 예측하거나, 'the fluffy blue' 다음에 올 단어를 예측하도록 여러 단계의 학습 데이터를 만들 수 있다.

![fig9](dl/transformer/3-9.png){: style="display:block; margin:0 auto; width:55%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=eMlx5fFNoYc&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=7)_

하지만 이렇게 하려면 뒤쪽의 단어가 앞부분에 영향을 주지 않게 해야 한다. 만약 뒤쪽의 단어가 attention을 통해 앞 단어에 영향을 준다면, 모델이 정답을 미리 컨닝하는 문제가 발생하기 때문이다.

따라서 Attention map에서 뒤쪽에 있는 토큰이 앞쪽에 있는 토큰에 영향을 주는 부분을 $0$으로 설정한다.

![fig10](dl/transformer/3-10.png){: style="display:block; margin:0 auto; width:60%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=eMlx5fFNoYc&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=7)_

하지만 단순히 $0$으로 설정하면, 소프트맥스 함수를 적용했을 때 정규화 과정에 포함되어 완전히 무시되지 않는다. 따라서 소프트맥스 함수를 적용하기 전에 값을 $-\infty$로 설정하여, 소프트맥스 함수 적용 이후에 $0$이 되도록 한다.

이러한 과정은 원래 Attention map에 마스크 행렬 $M$을 더하는 것으로 수행된다.

$$
\text{MaskedAttention}(Q,K,V)=\text{softmax}\left(\frac{QK^\top}{\sqrt d_k}+M\right)V
~~,~~
M_{ij}=\begin{cases}0&,~j\leq i\\-\infty&,~j>i\end{cases}
$$

![fig11](dl/transformer/3-11.png){: style="display:block; margin:0 auto; width:70%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=eMlx5fFNoYc&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=7)_

## Multi-Head Attention

Multi-Head Attention은 한 번의 Attention 연산 (Single-Head Attention)만으로는 문장 속 다양한 의미적 관계를 충분히 포착하기 어렵다는 한계를 해결하기 위해 고안된 구조이다.

이 방식은 Attention 연산을 여러 개의 Head로 나누어 병렬적으로 수행함으로써, 모델이 문맥에 따라 단어의 의미가 어떻게 달라지는지를 여러 가지 관점에서 학습할 수 있도록 한다.

예를 들어, 어떤 Head는 문장 내 문법적 관계를 학습하고, 다른 Head는 의미적 유사성이나 위치 관계를 학습할 수 있다.

Head의 개수를 $H$로 설정하면, Head 하나의 차원은 $d_h=\frac{d}{H}$이다. 이때 $H$개의 Attention 연산을 병렬로 수행하며, 각 Head는 서로 다른 가중치 행렬 $W_Q^{(h)}, W_K^{(h)}, W_V^{(h)}$를 사용하여 서로 다른 표현 공간에서 정보를 추출한다.

$$
\Delta E^{(h)}=\text{Attention}(QW_Q^{(h)},KW_K^{(h)},VW_v^{(h)})\in\mathbb{R}^{n\times d_h}
$$

이후, 모든 Head에서 얻은 결과를 연결하여 원래의 임베딩에 더한다.

$$
E'=E+\text{Concat}\left(\Delta E^{(1)},\Delta E^{(2)},\Delta E^{(3)},\cdots\right)
\in\mathbb{R}^{n\times(H\cdot d_h)}
$$

![fig12](dl/transformer/3-12.png){: style="display:block; margin:0 auto; width:70%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=eMlx5fFNoYc&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=7)_
