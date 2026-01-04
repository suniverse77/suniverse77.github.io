---
title: "[트랜스포머] Attention 역전파"
date: 2025-12-20 0:00:00 +/-TTTT
categories: [AI, 트랜스포머]
tags: [트랜스포머]
math: true
toc: true
author: sunho
---

## Forward

Attention layer에서 입력 $X\in\mathbb{R}^{n\times d}$에 대해, query, key, value는 아래와 같이 생성된다.

$$
Q=XW^Q~,~K=XW^K~,~V=XW^V
$$

또한, Attention layer의 forward 과정은 아래와 같다.

$$
S=QK^\top~\rightarrow~A=\frac{S}{\sqrt{d_k}}~\rightarrow~
P=\text{softmax}(A)~\rightarrow~O=PV
$$

이를 계산 그래프로 나타내면 아래 그림과 같다.

![fig1](AI/Transformer/Attention_Backprop-1.png){: style="display:block; margin:0 auto; width:60%;"}

## Backward

### Value 파라미터 업데이트

1. Value 행렬 $V$에 대한 그라디언트 계산

    $$
    \frac{\partial\mathcal{L}}{\partial V}=\frac{\partial\mathcal{L}}{\partial O}\cdot\frac{\partial O}{\partial V}=P^\top\cdot\frac{\partial\mathcal{L}}{\partial O}
    $$
2. Value 가중치 $W^V$에 대한 그라디언트 계산

    $$
    \frac{\partial\mathcal{L}}{\partial W^V}=\frac{\partial\mathcal{L}}{\partial V}\cdot\frac{\partial V}{\partial W^V}=X^\top\cdot\frac{\partial\mathcal{L}}{\partial O}
    $$
3. Value 파라미터 업데이트

    $$
    W^V\leftarrow W^V-\eta\frac{\partial\mathcal{L}}{\partial W^V}
    $$

### Query, Key 파라미터 업데이트

1. 행렬 $P$에 대한 그라디언트 계산

    $$
    \frac{\partial\mathcal{L}}{\partial P}=\frac{\partial\mathcal{L}}{\partial O}\cdot\frac{\partial O}{\partial P}=\frac{\partial\mathcal{L}}{\partial O}\cdot V^\top
    $$
2. Value 가중치에 대한 그라디언트 계산

    $$
    \frac{\partial\mathcal{L}}{\partial A}=\frac{\partial\mathcal{L}}{\partial P}\cdot\frac{\partial P}{\partial A}=X^\top\cdot\frac{\partial\mathcal{L}}{\partial O}
    $$
3. Score 행렬 $S$에 대한 그라디언트 계산

    $$
    \frac{\partial\mathcal{L}}{\partial S}=\frac{\partial\mathcal{L}}{\partial A}\cdot\frac{\partial A}{\partial S}=\frac{\partial\mathcal{L}}{\partial A}\cdot\frac{1}{\sqrt{d_k}}
    $$
4. Query 행렬 $Q$와 Key 행렬 $K$에 대한 그라디언트 계산

    $$
    \frac{\partial\mathcal{L}}{\partial Q}=\frac{\partial\mathcal{L}}{\partial S}\cdot\frac{\partial S}{\partial Q}=\frac{\partial\mathcal{L}}{\partial S}\cdot K
    $$

    $$
    \frac{\partial\mathcal{L}}{\partial K}=\frac{\partial\mathcal{L}}{\partial S}\cdot\frac{\partial S}{\partial K}=\left(\frac{\partial\mathcal{L}}{\partial S}\right)^\top\cdot Q
    $$
5. Query 가중치 $W^Q$와 Key 가중치 $W^K$에 대한 그라디언트 계산

    $$
    \frac{\partial\mathcal{L}}{\partial W^Q}=\frac{\partial\mathcal{L}}{\partial Q}\cdot\frac{\partial Q}{\partial W^Q}=X^\top\cdot\frac{\partial\mathcal{L}}{\partial Q}
    $$

    $$
    \frac{\partial\mathcal{L}}{\partial W^K}=\frac{\partial\mathcal{L}}{\partial K}\cdot\frac{\partial K}{\partial W^K}=X^\top\cdot\frac{\partial\mathcal{L}}{\partial K}
    $$
6. Query, Key 파라미터 업데이트

    $$
    W^Q\leftarrow W^Q-\eta\frac{\partial\mathcal{L}}{\partial W^Q}
    $$

    $$
    W^K\leftarrow W^K-\eta\frac{\partial\mathcal{L}}{\partial W^K}
    $$
