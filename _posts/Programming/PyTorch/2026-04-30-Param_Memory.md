---
title: "[GPU 분산 학습] 딥러닝 모델 파라미터 메모리 산출"
date: 2026-04-30 00:00:00 +/-TTTT
categories: [Programming, 파이토치]
tags: [GPU 분산 학습]
math: true
toc: true
author: sunho
---

딥러닝 모델의 학습 과정은 크게 loss를 계산하는 순전파 (Forward pass), 각 파라미터의 그래디언트를 계산하는 역전파 (Backward pass), 그리고 계산된 그래디언트를 이용해 실제로 파라미터를 업데이트하는 옵티마이저 스텝 (Optimizer Step)으로 이루어진다.

![fig1](Programming/PyTorch/Param_Memory-1.png){: style="display:block; margin:0 auto; width:100%;"}

이 과정에서 GPU 메모리 (VRAM)는 크게 4가지 영역으로 나뉘어 점유된다.

- **파라미터 메모리:** 모델의 파라미터를 저장하는 공간 (위 그림에서 $W^{(i)}$)
- **활성화 메모리:** 입력 데이터가 모델의 네트워크를 타고 흐를 때 나오는 중간 계산 결과값들을 임시로 저장하는 공간 (위 그림에서 $\mathbf{x},\boldsymbol{a},\mathbf{y}$)
- **그래디언트 메모리:** 개별 파라미터마다 계산된 그래디언트 값을 저장하는 공간 (위 그림에서 $\frac{\partial\mathcal{L}}{\partial W^{(i)}}$)
- **옵티마이저 상태 메모리:** 옵티마이저가 유지해야 하는 과거의 정보를 저장하는 공간 (위 그림에서 $\hat{m}$과 $\hat{v}$)

이 중 <span style="background-color:#fff5b1">활성화 메모리는 입력 데이터의 크기 (배치 크기, 데이터 크기 등)에 비례하며, 나머지 파라미터, 그래디언트, 옵티마이저 상태 메모리는 모델의 크기에 의해 결정된다.</span>

[GPT-2 XL](https://huggingface.co/openai-community/gpt2-xl) 모델을 예시로 계산을 해보겠다.
<br>
GPT-2 XL의 기본적인 스펙은 다음과 같고, **Batch size는 32**라고 가정해보겠다.

- **Parameters:** `1.5B`
- **Input Context Lenght:** `1,024`
- **Embedding Dimension:** `1,600`
- **Hidden Dimension:** `1,600`
- **Transformer Layers:** `48`
- **Attention Heads:** `25`

![fig2](Programming/PyTorch/Param_Memory-2.png){: style="display:block; margin:0 auto; width:100%;"}

### 1. 파라미터 (Parameters) 메모리

딥러닝 모델의 파라미터는 네트워크를 구성하는 weight와 bias로, 모델의 고정된 구성 요소이다.
<br>
즉, 파라미터 메모리는 모델 자체가 차지하는 기본적인 물리적 용량을 의미한다.

우리가 허깅페이스 등 웹에서 다운로드하는 모델 가중치 파일 ( `.safetensors`, `.pt` 등)의 크기나, 학습을 위해 `model.to('cuda')` 명령어로 GPU에 모델을 처음 로드할 때 점유되는 VRAM이 바로 이 파라미터 메모리에 해당한다.

이 파라미터 메모리는 모델의 파라미터 수와 데이터 정밀도에 의해 결정된다.

- `FP32` : 파라미터 1개를 32 Bits (4 Byte)로 표현
- `FP16` / `BF16` : 파라미터 1개를 16 Bits (2 Byte)로 표현
- `INT8`: 파라미터 1개를 8 Bits (1 Byte)로 표현
- `INT4`: 파라미터 1개를 4 Bits (0.5 Byte)로 표현

예를 들어 `FP32` 정밀도로 학습하거나 로드할 경우, 파라미터 메모리 크기는 다음과 같이 산출된다.

$$
\text{Parameter Memory}=
\text{num params}\times\text{precision}=
1.5\text{B}\times4\text{ Bytes}=6\text{ Billion Bytes}\approx6\text{ GB}
$$

### 2. 활성화 (Activations) 메모리

활성화는 입력 데이터가 모델의 각 layer를 통과하면서, 행렬 곱셈이나 비선형 함수 등의 연산을 거친 후 나오는 중간 계산 결과값들을 의미한다.

고정된 크기를 갖는 파라미터 메모리와 달리, 활성화 메모리는 입력 크기 (Batch size, Context length, Image size 등)에 정비례해서 커진다.

#### Token Embedding 메모리

입력된 단어 토큰들을 임베딩할 때 발생하는 메모리다.

$$
\text{batch size}\times\text{context length}\times\text{embedding dim}\times\text{precision}\approx 0.19\text{ GB}
$$

#### Positional Embedding 메모리

시퀀스 내 토큰의 위치 정보를 기억하는 메모리다.
<br>
위치 정보는 모든 배치 데이터가 동일하게 공유하므로, batch size를 곱하지 않는다.

$$
\text{context length}\times\text{embedding dim}\times\text{precision}
\approx 0.006\text{ GB}
$$

#### Transformer Layer 메모리

- Self-Attention

    Query, Key, Value, Output 4개의 텐서가 생성된다.

    $$
    4\times(\text{batch size}\times\text{context length}\times\text{embedding dim}\times\text{precision})
    \approx 0.78\text{ GB}
    $$
- Feed Forward

    현재 Hidden dim과 Embedding dim이 동일하기 때문에, 단순히 2를 곱해서 구할 수 있다.

    $$
    2\times(\text{batch size}\times\text{context length}\times\text{hidden dim}\times\text{precision})
    \approx 0.39\text{ GB}
    $$

총 48개의 layer가 존재하므로, 전체 활성화 메모리는 다음과 같이 산출된다.

$$
48\times(\text{Self-Attention}+\text{Feed Forward})
\approx 1.17\text{ GB}\times 48=56.25\text{ GB}
$$

따라서 모든 항목을 합산한 총 활성화 메모리는 다음과 같다.

$$
\text{Activation Memory}=
\text{Token Embed}+\text{Positional Embed}+\text{Transformer Layer}
\approx 56.45\text{ GB}
$$

> **중간 결과값들을 저장해야 하는 이유가 뭘까?**
> 
> 순전파가 끝난 후 이어지는 역전파 과정에서, 파라미터마다 그래디언트를 계산할 때 필요하기 때문이다.
> 
> 예를 들어, 아래와 같은 순전파 연산 흐름이 있다고 가정해보자.
> 
> $$z_1=xW^{(1)}\to a_1=f(z_1)\to z_2=a_1W^{(2)}$$
> 
> 역전파 시 가중치 $W^{(2)}$의 그래디언트는 chain rule에 의해 아래와 같이 계산되는데, 이때 $a_1$값을 저장하지 않았다면 역전파 과정에서 그래디언트를 구할 수 없게 된다.
> 
> $$\vphantom{\Bigg(}\frac{\partial\mathcal{L}}{\partial W^{(2)}}=\frac{\partial z_2}{\partial W^{(2)}}\cdot \frac{\partial\mathcal{L}}{\partial z_2}
=a_1^\top\cdot \frac{\partial\mathcal{L}}{\partial z_2}$$

### 3. 그래디언트 (Gradient) 메모리

마지막 단계에서 모델의 가중치를 업데이트하려면 모든 파라미터마다 그래디언트가 필요하다.
<br>
따라서 그래디언트 메모리 크기는 파라미터 메모리 크기와 동일하다.

$$
\text{Gradient Memory}=
\text{num params}\times\text{precision}=
1.5\text{B}\times4\text{ Bytes}=6\text{ Billion Bytes}\approx6\text{ GB}
$$

### 4. 옵티마이저 상태 (Optimizer State) 메모리

가중치를 업데이트하는 옵티마이저는 학습의 안정성과 속도를 높이기 위해, 현재 시점의 그래디언트뿐만 아니라 과거의 그라디어트 정보도 사용한다.

예를 들어 Adam 옵티마이저의 경우, 개별 파라미터마다 자신의 사본, 모멘텀 $\hat{m}$ (과거 그래디언트 평균)과 분산 $\hat{v}$ 정보를 추가로 저장한다.

결과적으로 옵티마이저 상태 메모리 크기는 파라미터 메모리 크기의 3배에 달하게 된다.

$$
\text{Optimizer State Memory}=
3\times(\text{num params}\times\text{precision})
\approx18 \text{ GB}
$$

## 최종 VRAM 사용량

결과적으로 GPT-2 XL 모델을 `batch size=32`로 학습하기 위해 필요한 총 VRAM 용량은 다음과 같다.

$$
\text{Total Memory}=
6 \text{ GB}+56.45 \text{ GB}+6 \text{ GB}+18 \text{ GB } \approx 87 \text{ GB}
$$

여기에 임시 변수들이 차지하는 자잘한 여유 공간까지 고려하면 실제로는 최소 $87\text{ GB}$ 이상의 메모리가 요구된다.
<br>
이는 최신 그래픽카드인 **NVIDIA RTX 5090 (32GB)**뿐만 아니라 데이터센터용 GPU인 **A100 (80GB)** 단일 장비로도 감당할 수 없는 수치이다.

### 메모리 Trade-off

만약 메모리 확보를 위해 극단적으로 `batch size=1`로 설정하게 된다면, 활성화 메모리가 $1.88 \text{ GB}$이 되어 총 메모리 요구량이 약 $31.88\text{ GB}$가 된다.
<br>
이론상 32GB VRAM 내에 아슬아슬하게 들어가는 수치지만, 실제 학습 환경에서는 여러 가지 문제가 발생할 수 있다.

- **CUDA OOM 위험:** 실제로는 운영체제와 CUDA가 기본적으로 점유하는 여유 메모리가 필요하기 때문에, 메모리 부족 (OOM)이 발생할 확률이 높다.
- **학습 효율 붕괴:** GPU의 병렬 연산을 전혀 활용하지 못해 학습 속도가 매우 느려진다.
- **학습 불안정:** 한 번에 1개의 데이터만 보고 그래디언트를 계산하기 때문에, 그래디언트가 매 스텝 불안정해져서 모델이 제대로 수렴하지 못하게 된다.
