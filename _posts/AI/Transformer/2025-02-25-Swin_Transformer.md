---
title: "[트랜스포머] Swin Transformer"
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

- $224\times224$ 이미지 → 패치 개수 $196$개 → Attention 맵 크기: $196\times196$
- $1024\times1024$ 이미지 → 패치 개수 $\text{4,096}$개 → Attention 맵 크기: $\text{4,096}\times\text{4,096}$

또한 ViT의 Global Attention은 

![fig1](AI/Transformer/Swin_Transformer-1.png){: style="display:block; margin:0 auto; width:60%;"}

## Swin Transformer

Swin Transformer의 모델 구조는 다음과 같다.

![fig2](AI/Transformer/Swin_Transformer-2.png){: style="display:block; margin:0 auto; width:100%;"}

### Shifted Window based Self-Attention

Swin Transformer에서는 전체 이미지에서 Attention을 수행하지 않고 작은 윈도우 안에서만 Attention을 수행한다.

Shifted Window based Self-Attention의 파이프라인은 다음과 같다.

![fig3](AI/Transformer/Swin_Transformer-3.png){: style="display:block; margin:0 auto; width:100%;"}

패치 개수를 $N$, 1개의 윈도우 내의 패치 개수를 $M$이라고 할 때, Self-Attention 연산량은 $O(NM)$이다.

- 윈도우 1개의 Self-Attention 연산량: $M^2$
- 전체 윈도우 개수: $\frac{N}{M}$
- 전체 연산량: $\frac{N}{M}\times M^2=NM$

따라서 $M$이 고정이면, 사실상 선형 복잡도에 가까워진다.

#### Cyclic Shift

만약 Window Attention만 사용한다면, 서로 다른 윈도우에 있는 패치들은 정보를 교환할 수 없게 된다.

이를 해결하기 위해, 각 블록의 Feature Map을 왼쪽으로 $\frac{M}{2}$만큼, 위쪽으로 $\frac{M}{2}$만큼 순환 이동시킨다.

![fig4](AI/Transformer/Swin_Transformer-4.png){: style="display:block; margin:0 auto; width:100%;"}

#### Masked Attention

Cyclic Shift를 하면 Feature Map의 가장자리가 반대편으로 넘어가기 때문에, 원래 멀리 떨어져 있던 토큰들이 같은 윈도우에 들어갈 수 있다.

아래의 그림에서 3번 윈도우의 $(A,B)$, $(C,D)$는 원래 서로 이웃이었지만, $(A,C)$, $(B,D)$는 서로 이웃이 아니었다.

![fig5](AI/Transformer/Swin_Transformer-5.png){: style="display:block; margin:0 auto; width:60%;"}

따라서 $(A,C)$, $(B,D)$는 이웃이 아니므로 Attention을 하면 안 됩니다.

그래서 Attention Mask를 적용하여

원래 인접한 영역끼리는 Attention 허용
Cyclic Shift 때문에 인위적으로 붙은 영역끼리는 Attention 차단

합니다.

