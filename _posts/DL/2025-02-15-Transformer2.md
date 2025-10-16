---
title: "[트랜스포머] 임베딩 (Embedding)"
date: 2025-02-15 06:00:00 +/-TTTT
categories: [AI, 딥러닝]
tags: [CS231n]
math: true
toc: true
author: sunho
---

## 토큰화 (Tokenization)

임베딩 전, 입력 문장을 여러 개의 토큰 (token)으로 분리한다. 토큰은 문장을 구성하는 최소 의미 단위로, 여러 단위로 분리할 수 있다.

**단어 단위로 분리**

$$
\text{I love playing football.}\to\left[~\text{“I”},\"\text{“love”},\text{“playing”},\text{“football”},\text{“.”}~\right]
$$

**문자 단위로 분리**

$$
\text{I love playing football.}\to\left[~\text{“I”},\text{“~”},`\text{“l”}','\text{“o”}',\text{“v”},\cdots,\text{“.”}~\right]
$$

**서브워드 (subword) 단위로 분리**

$$
\text{I love playing football.}\to\left[~\text{“I"},\text{“love},\text{“play},\text{“##ing},\text{“foot},\#\#\text{“ball},\text{“.}~\right]
$$

컴퓨터는 텍스트를 직접 이해할 수 없고, 숫자 형태로만 계산할 수 있다. 따라서 모델을 학습하기 전에, 학습 과정에서 사용할 단어들의 목록인 사전 (vocabulary)을 미리 정의해야 한다.

만약 입력 문장에 사전에 없는 단어가 등장하면, 해당 단어는 UNK (unknown) 토큰으로 대체된다.

## 임베딩 (Embedding)

위와 같이 문장을 단어 단위로 분리한 뒤, 각 단어를 숫자 벡터로 변환하는 과정을 임베딩이라고 한다. 이렇게 변환된 벡터를 단어 임베딩 (Word Embedding)이라고 부른다.

![fig1](dl/transformer/2-1.png){: style="display:block; margin:0 auto; width:70%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=wjZofJX0v4M&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=6)_

사전 내의 각 단어의 벡터로 변환된 사전을 임베딩 행렬 (Embedding Matrix) $W_E$라고 하며, 각 임베딩 벡터는 랜덤값에서 시작하여 학습을 통해 조정된다.

![fig2](dl/transformer/2-2.png){: style="display:block; margin:0 auto; width:90%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=wjZofJX0v4M&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=6)_

단어 임베딩은 

![fig3](dl/transformer/2-3.png){: style="display:block; margin:0 auto; width:50%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=wjZofJX0v4M&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=6)_
