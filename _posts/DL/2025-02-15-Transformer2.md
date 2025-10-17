---
title: "[트랜스포머] 트랜스포머의 구조2 - 임베딩 (Embedding)"
date: 2025-02-15 06:00:00 +/-TTTT
categories: [AI, 딥러닝]
tags: [트랜스포머]
math: true
toc: true
author: sunho
---

해당 포스트는 3Blue1Brown님의 [「*Transformers, the tech behind LLMs*」](https://www.youtube.com/watch?v=wjZofJX0v4M&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=6) 영상을 참고하였습니다.

![fig0](dl/transformer/2-0.png){: style="display:block; margin:0 auto; width:70%;"}
_출처: Attention Is All you Need_

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
E(queen)
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

