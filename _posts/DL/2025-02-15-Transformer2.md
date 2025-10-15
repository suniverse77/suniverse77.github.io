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
\text{I love playing football.}\to\left[~\text{``I"},\text{love},\text{playing},\text{football},\text{.}~\right]
$$

**문자 단위로 분리**

$$
\text{I love playing football.}\to\left[~\text{``I"},\text{``~"},\text{l},\text{o},\text{v},\cdots,\text{.}~\right]
$$

**서브워드 (subword) 단위로 분리**

$$
\text{I love playing football.}\to\left[~\text{``I"},\text{love},\text{play},\text{ing},\text{foot},\text{ball},\text{.}~\right]
$$

이후 각 단어를 벡터로 변환한다

![fig2](dl/transformer/2-1.png){: style="display:block; margin:0 auto; width:70%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=wjZofJX0v4M&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=6)_

