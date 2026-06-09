---
title: "[트랜스포머] 비전 트랜스포머 (ViT, Vision Transformer)"
date: 2025-02-25 00:00:00 +/-TTTT
categories: [AI, 트랜스포머]
tags: [트랜스포머]
math: true
toc: true
author: sunho
---

**📄 관련 논문:** [[Swin Transformer: Hierarchical Vision Transformer using Shifted Windows]](https://arxiv.org/abs/2103.14030)

Swin Transformer는 Shifted Window Transformer의 약자이다.


## ViT의 한계점

기존 Transformer는 모든 토큰끼리 Attention을 계산한다.

입력 이미지 크기가 커질수록 패치 개수 $N$이 증가하고, Self-Attention 계산량은 $O(N^2)$이 되어 연산량과 메모리 사용량이 급격히 증가한다.

ViT에서는 하나의 패치 크기가 $16\times16$이기 때문에, 입력 이미지 해상도에 따른 패치 개수는 다음과 같다.

- $224\times224$ 이미지 → 패치 개수 $196$개
- $1024\times1024$ 이미지 → 패치 개수 $\text{4,096}$개

## Swin Transformer

Swin Transformer의 전체 파이프라인은 다음과 같다.

![fig1](AI/Transformer/Swin_Transformer-1.png){: style="display:block; margin:0 auto; width:100%;"}

### Shifted Window based Self-Attention

Swin Transformer에서 제안한 방법으로, 전체 이미지에서 Attention을 수행하지 않고 작은 윈도우 안에서만 Attention을 수행하는 방식이다.

따라서 계산량은:

O(NM)

N = 전체 토큰 수
M = Window 크기 (고정)

M이 고정이면 사실상 선형 복잡도에 가까워집니다.

![fig2](AI/Transformer/Swin_Transformer-2.png){: style="display:block; margin:0 auto; width:100%;"}

![fig3](AI/Transformer/Swin_Transformer-3.png){: style="display:block; margin:0 auto; width:100%;"}

