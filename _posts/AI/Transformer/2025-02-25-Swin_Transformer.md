---
title: "[트랜스포머] Swin Transformer (Shifted Window Transformer)"
date: 2025-02-25 00:00:00 +/-TTTT
categories: [AI, 트랜스포머]
tags: [트랜스포머]
math: true
toc: true
author: sunho
---

**📄 관련 논문:** [[Swin Transformer: Hierarchical Vision Transformer using Shifted Windows]](https://arxiv.org/abs/2103.14030)

## ViT의 한계점

### 고정된 토큰 스케일

기존 ViT는 입력 이미지를 동일한 크기의 패치들로 쪼갠 뒤, 이 패치 하나하나를 언어 모델의 토큰처럼 취급한다.
<br>
또한 이 $16\times16$ 픽셀을 대표하는 하나의 토큰은 모델의 입력층부터 출력층까지 크기가 변하지 않는데, 이는 비전 task에서 문제가 된다.

이미지 속 객체들은 크기가 매우 다양하기 때문에, 작은 객체와 큰 객체를 모두 효과적으로 인식하려면 모델이 다양한 scale의 특징을 포착할 수 있어야 한다.
<br>
하지만 처음부터 끝까지 고정된 크기의 토큰만 사용하면 다양한 크기의 객체에 대응하기 어렵게 된다.

![fig1](AI/Transformer/Swin_Transformer-1.png){: style="display:block; margin:0 auto; width:60%;"}

### Attention 연산량

기존 ViT는 모든 토큰끼리 Attention을 계산한다.

입력 이미지 크기가 커질수록 패치 개수 $N$이 증가하고, Self-Attention 계산량은 $O(N^2)$이 되어 연산량과 메모리 사용량이 급격히 증가한다.

ViT에서는 하나의 패치 크기가 $16\times16$이기 때문에, 입력 이미지 해상도에 따른 패치 개수는 다음과 같다.

- $224\times224$ 이미지 → 패치 개수 $196$개 → Attention 맵 크기: $196\times196$
- $1024\times1024$ 이미지 → 패치 개수 $\text{4,096}$개 → Attention 맵 크기: $\text{4,096}\times\text{4,096}$

## Swin Transformer

Swin Transformer의 모델 구조는 다음과 같다.

![fig2](AI/Transformer/Swin_Transformer-2.png){: style="display:block; margin:0 auto; width:80%;"}

Swin Transformer Block에서는 아래 그림의 Transformer Block이 연속적으로 수행된다.

![fig3](AI/Transformer/Swin_Transformer-3.png){: style="display:block; margin:0 auto; width:60%;"}

- **W-MSA:** Regular Window based Multi-head Self-Attention (feature들을 이동시키지 않음)
- **SW-MSA:** Shifted Window based Multi-head Self-Attention

또한 각 stage 이후에 Patch Merging을 통해 패치 하나가 바라보는 Receptive Field을 점진적으로 키워나간다.

### Shifted Window based Self-Attention

Swin Transformer에서는 Global Attention을 수행하지 않고, 이미지를 여러 개의 윈도우로 쪼갠 후 그 안에서만 Local Attention을 수행한다.

Shifted Window based Self-Attention의 파이프라인은 다음과 같다.

![fig4](AI/Transformer/Swin_Transformer-4.png){: style="display:block; margin:0 auto; width:100%;"}

패치 개수를 $N$, 1개의 윈도우 내의 패치 개수를 $M$이라고 할 때, Self-Attention 연산량은 $O(NM)$이다.

- 윈도우 1개의 Self-Attention 연산량: $M^2$
- 전체 윈도우 개수: $\frac{N}{M}$
- 전체 연산량: $\frac{N}{M}\times M^2=NM$

따라서 $M$이 고정이면, 사실상 선형 복잡도에 가까워진다.

#### Cyclic Shift

만약 Window Attention만 사용한다면, 서로 다른 윈도우에 있는 패치들은 정보를 교환할 수 없게 된다.

이를 해결하기 위해, 각 블록의 Feature Map을 왼쪽으로 $\frac{M}{2}$만큼, 위쪽으로 $\frac{M}{2}$만큼 순환 이동시킨다.

![fig5](AI/Transformer/Swin_Transformer-5.png){: style="display:block; margin:0 auto; width:100%;"}

#### Masked Attention

Cyclic Shift를 하면 Feature Map의 가장자리가 반대편으로 넘어가기 때문에, 원래 멀리 떨어져 있던 토큰들이 같은 윈도우에 들어갈 수 있다.

아래의 그림에서 ③번 윈도우의 $(A,B)$, $(C,D)$는 원래 서로 이웃이었지만, $(A,C)$, $(B,D)$는 서로 이웃이 아니었다.

![fig6](AI/Transformer/Swin_Transformer-6.png){: style="display:block; margin:0 auto; width:30%;"}

Swin Transformer에서는 Local Attention만 수행하기 때문에, 이웃이 아닌 영역끼리는 Attention을 하지 않도록 설계해야 한다.

이를 위해 Attention Mask를 적용하여, 원래 인접한 영역끼리는 Attention을 허용하고 Cyclic Shift 때문에 인위적으로 붙은 영역끼리는 Attention을 차단하도록 한다.

![fig7](AI/Transformer/Swin_Transformer-7.png){: style="display:block; margin:0 auto; width:50%;"}

### Patch Merging

Patch Merging은 다음 Stage로 넘어갈 때, 인접한 $2\times2$개의 패치를 하나로 병합하는 방법이다.

구체적으로는 $C$ 차원의 인접한 $2\times2$ 패치들을 concat하여 $4C$ 차원으로 만든 뒤, Linear layer를 거쳐 최종 출력 차원을 $2C$로 축소한다.

![fig8](AI/Transformer/Swin_Transformer-8.png){: style="display:block; margin:0 auto; width:60%;"}

- **Stage 1:** 처음에는 원본 이미지의 $4\times4$ 픽셀 영역이 1개의 패치가 된다. 이 패치들 $7\times7$개를 모아 하나의 윈도우를 구성하여 Attention을 수행한다.
- **Patch Merging:** 인접한 $2\times2$개의 패치를 하나로 병합한다.
- **Stage 2:** 이제 하나의 패치는 원본 이미지의 $8\times8$ 픽셀 면적을 대표하게 된다. 윈도우는 여전히 똑같이 $7\times7$개의 패치를 담고 있지만, 패치 하나하나가 더 거시적인 정보를 담고 있기 때문에, 결과적으로 윈도우 1개가 커버하는 실제 원본 이미지의 영역은 이전보다 $4$배 넓어지게 된다.
- **Patch Merging:** 인접한 $2\times2$개의 패치를 하나로 병합한다.
- **Stage 3:** 이제 하나의 패치는 원본 이미지의 $16\times16$ 픽셀 면적을 대표하게 된다.
- **Patch Merging:** 인접한 $2\times2$개의 패치를 하나로 병합한다.
- **Stage 4:** 이제 하나의 패치는 원본 이미지의 $32\times32$ 픽셀 면적을 대표하게 된다.

결과적으로 Patch Merging을 통해 만들어진 Hierarchical Feature Map은 Multi-scale feature들을 유연하게 포착할 수 있게 된다.
