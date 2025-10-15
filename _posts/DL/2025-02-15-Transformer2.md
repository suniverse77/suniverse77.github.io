---
title: "[트랜스포머] 임베딩 (Embedding)"
date: 2025-02-15 06:00:00 +/-TTTT
categories: [AI, 딥러닝]
tags: [CS231n]
math: true
toc: true
author: sunho
---

## 임베딩 (Embedding)

먼저 입력 문장을 여러 개의 토큰 (token)으로 분리한다. 토큰은 문장을 구성하는 최소 의미 단위로, 여러 단위로 분리할 수 있다.

**단어 단위로 분리**

$$
\text{I love playing football.}\to\left[~\text{"I"},\text{love},\text{playing},\text{football},\text{.}~\right]
$$

**문자 단위로 분리**

$$
\text{I love playing football.}\to\left[~\text{``I"},\text{``~"},\text{l},\text{o},\text{v},\cdots,\text{.}~\right]
$$

**서브워드 (subword) 단위로 분리**

$$
\text{I love playing football.}\to\left[~\text{``I"},\text{love},\text{play},\text{\#\#ing},\text{foot},\text{\#\#ball},\text{.}~\right]
$$

이후 각 단어를 벡터로 변환하며, 이 과정을 임베딩이라고 한다.

![fig1](dl/transformer/2-1.png){: style="display:block; margin:0 auto; width:70%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=wjZofJX0v4M&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=6)_

컴퓨터는 텍스트를 직접 이해할 수 없고, 숫자 형태의 벡터만 계산할 수 있습니다.
따라서 텍스트를 숫자로 바꾸기 위해, 먼저 모델이 학습 때 사용할 **단어 목록(사전, vocabulary)**을 미리 만들어 둡니다.

모델이 한 번도 본 적 없는 단어가 입력되면,
그 단어는 사전에 없기 때문에 UNK (unknown) 토큰으로 대체됩니다.

![fig2](dl/transformer/2-2.png){: style="display:block; margin:0 auto; width:70%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=wjZofJX0v4M&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=6)_

![fig3](dl/transformer/2-3.png){: style="display:block; margin:0 auto; width:70%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=wjZofJX0v4M&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=6)_
