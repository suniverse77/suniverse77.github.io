---
title: "[트랜스포머] Attention"
date: 2025-02-15 12:00:00 +/-TTTT
categories: [AI, 딥러닝]
tags: [트랜스포머]
math: true
toc: true
author: sunho
---

해당 포스트는 3Blue1Brown님의 [「*Attention in transformers, step-by-step*」](https://www.youtube.com/watch?v=eMlx5fFNoYc&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=7) 영상을 참고하였습니다.

## Attention

이전 포스트에서 언급했듯이, 단어 임베딩만으로는 단어의 문맥적 의미를 파악할 수 없다. 이 문제를 해결하기 위해 도입한 것이 어텐션 메커니즘이다.

Attention은 각 단어의 의미를 더 정교하게 만드는 것뿐만 아니라, 하나의 임베딩이 다른 임베딩으로부터 필요한 정보를 선택적으로 받아들일 수 있도록 도와준다. 즉, 문맥에 따라 단어의 표현을 업데이트하는 역할을 한다.

예를 들어, 'Tower'라는 단어는 일반적으로 큰 건물을 의미한다. 하지만 그 앞에 'Eiffel'이라는 단어가 붙게 되면 'Eiffel Tower'라는 표현 자체가 '에펠탑'이라는 특정 대상을 나타내는 방향으로 업데이트된다.

반대로 앞에 'Miniature'라는 단어가 붙게 되면, 해당 임베딩은 큰 건물의 의미와는 거리가 멀어지고 '작은 모형'의 의미 쪽으로 조정된다.

![fig1](dl/transformer/3-1.png){: style="display:block; margin:0 auto; width:100%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=eMlx5fFNoYc&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=7)_

형용사에 의해서 명사의 의미가 좀 더 구체적으로 변한다고 생각하면 더 이해하기 쉬울 것이다.

아래 그림에서 명사 'creature'의 임베딩 $E_4$가 형용사 'fluffy'와 'blue'의 임베딩 $E_2,E_3$에 의해서 푸르고 복슬복슬한 생명체를 나타내는 새로운 임베딩 $E_4'$로 변환된다.

![fig2](dl/transformer/3-2.png){: style="display:block; margin:0 auto; width:65%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=eMlx5fFNoYc&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=7)_

단어 임베딩을 행벡터로 볼 경우, Attention 연산은 아래와 같이 정의된다. (행벡터를 가정하고 포스터를 작성했지만, 첨부한 사진은 열벡터 기준의 그림임)

$$
\text{softmax}(\frac{QK^\top}{\sqrt d_k})V
$$

여기서 $Q$는 쿼리 (Query), $K$는 키 (Key), $V$는 밸류 (Value)를 의미한다. $\sqrt{d_k}$는 스케일링 계수로, 내적값이 지나치게 커지는 것을 방지한다.

그럼 각각이 뭔지에 대해서 알아보자.

### 쿼리와 키 (Query, Key)

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

![fig4](dl/transformer/3-4.png){: style="display:block; margin:0 auto; width:90%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=eMlx5fFNoYc&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=7)_

Query와 Key의 내적을 통해 생성된 행렬을 어텐션 맵 (Attention map)이라고 한다. Attention map은 문장 내에서 각 단어 쌍 간의 유사도 정보를 담고 있다.

$$
QK^\top=
\begin{bmatrix}
\mathbf{q}_1\mathbf{k}_1^\top&\mathbf{q}_1\mathbf{k}_2^\top&\cdots&\mathbf{q}_1\mathbf{k}_n^\top\\
\mathbf{q}_2\mathbf{k}_1^\top&\mathbf{q}_2\mathbf{k}_2^\top&\cdots&\mathbf{q}_2\mathbf{k}_n^\top\\
\vdots&\vdots&\ddots&\vdots\\
\mathbf{q}_n\mathbf{k}_1^\top&\mathbf{q}_n\mathbf{k}_2^\top&\cdots&\mathbf{q}_n\mathbf{k}_n^\top
\end{bmatrix}\in\mathbb{R}^{n\times n}
$$

Attention map의 크기는 입력 토큰의 개수 $n$의 제곱에 비례하므로,
입력 길이가 길어질수록 연산량과 메모리 사용량이 빠르게 증가한다.

내적값을 통해 얻은 값은 실수 전체 범위를 가지기 때문에 음수나 매우 큰 양수 등이 섞여 있을 수 있다. 따라서 출력값을 정규화시키기 위해, 소프트맥스 함수를 이용하여 값들을 확률 분포 형태로 변환한다.

이때 행 방향 (`axis=`)으로 소프트맥스 함수를 적용한다.

$$
\text{softmax}\left(QK^\top\right)=
\begin{bmatrix}
\text{softmax}(~\mathbf{q}_1\mathbf{k}_1^\top&\mathbf{q}_1\mathbf{k}_2^\top&\cdots&\mathbf{q}_1\mathbf{k}_n^\top~)\\
\text{softmax}(~\mathbf{q}_2\mathbf{k}_1^\top&\mathbf{q}_2\mathbf{k}_2^\top&\cdots&\mathbf{q}_2\mathbf{k}_n^\top~)\\
\vdots&\vdots&\ddots&\vdots\\
\text{softmax}(~\mathbf{q}_n\mathbf{k}_1^\top&\mathbf{q}_n\mathbf{k}_2^\top&\cdots&\mathbf{q}_n\mathbf{k}_n^\top~)
\end{bmatrix}\in\mathbb{R}^{n\times n}
$$

Attention map의 각 행은 각 Query가 Key들과 얼마나 유사도를 가지는지를 의미한다.

![fig5](dl/transformer/3-5.png){: style="display:block; margin:0 auto; width:50%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=eMlx5fFNoYc&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=7)_

### 밸류 (Value)

Value 역시 마찬가지로 각각 단어 임베딩에 Value 행렬 $W_V\in\mathbb{R}^{d\times d}$을 곱해 만든다.

$$
V=E\cdot W_V=\begin{bmatrix}&-\mathbf{v}_1-&\\&\vdots&\\&-\mathbf{v}_n-&\end{bmatrix}\in\mathbb{R}^{n\times d}
$$

Value 행렬도 학습 가능한 파라미터로 이루어져 있다.

직관적으로 보면, Value는 해당 단어를 실제 만약 다른 임베딩이 현재 임베딩과 관련이 있다면 어떤 값을 더해줬을때 그 의미가 변하는지를 알려준다.

![fig6](dl/transformer/3-6.png){: style="display:block; margin:0 auto; width:100%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=eMlx5fFNoYc&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=7)_

![fig7](dl/transformer/3-7.png){: style="display:block; margin:0 auto; width:60%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=eMlx5fFNoYc&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=7)_

$$
\left(QK^\top\right)V=
\begin{bmatrix}
(\mathbf{q}_1\mathbf{k}_1^\top)\mathbf{v}_1+(\mathbf{q}_1\mathbf{k}_2^\top)\mathbf{v}_2+\cdots+(\mathbf{q}_1\mathbf{k}_n^\top)\mathbf{v}_n\\
(\mathbf{q}_2\mathbf{k}_1^\top)\mathbf{v}_1+(\mathbf{q}_2\mathbf{k}_2^\top)\mathbf{v}_2+\cdots+(\mathbf{q}_2\mathbf{k}_n^\top)\mathbf{v}_n\\
\vdots\\
(\mathbf{q}_n\mathbf{k}_1^\top)\mathbf{v}_1+(\mathbf{q}_n\mathbf{k}_2^\top)\mathbf{v}_2+\cdots+(\mathbf{q}_n\mathbf{k}_n^\top)\mathbf{v}_n
\end{bmatrix}
=\begin{bmatrix}\Delta\mathbf{e}_1\\\Delta\mathbf{e}_2\\\vdots\\\Delta\mathbf{e}_n\end{bmatrix}\in\mathbb{R}^{n\times d}
$$

여기서 $K=K_1+K_2+\cdots+K_n$

$$
E'=E+\Delta E=\begin{bmatrix}\mathbf{e}_1+\Delta\mathbf{e}_1\\\mathbf{e}_2+\Delta\mathbf{e}_2\\\vdots\\\mathbf{e}_n+\Delta\mathbf{e}_n\end{bmatrix}\in\mathbb{R}^{n\times d}
$$

![fig8](dl/transformer/3-8.png){: style="display:block; margin:0 auto; width:60%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=eMlx5fFNoYc&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=7)_

## Self-Attention과 Cross-Attention



## Multi-Head Attention



## Masked Self-Attention


