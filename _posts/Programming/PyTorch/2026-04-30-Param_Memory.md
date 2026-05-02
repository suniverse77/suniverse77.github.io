---
title: "[GPU 분산 학습] 딥러닝 모델 파라미터 메모리 산출"
date: 2026-04-30 00:00:00 +/-TTTT
categories: [Programming, 파이토치]
tags: [GPU 분산 학습]
math: true
toc: true
author: sunho
---

딥러닝 모델의 학습 과정은 크게 loss를 계산하는 순전파 (Forward pass), 각 파라미터의 그라디언트를 계산하는 역전파 (Backward pass), 그리고 계산된 그라디언트를 이용해 실제로 파라미터를 업데이트하는 옵티마이저 스텝 (Optimizer Step)으로 이루어진다.

![fig1](Programming/PyTorch/Param_Memory-1.png){: style="display:block; margin:0 auto; width:100%;"}

이 과정에서 GPU 메모리 (VRAM)는 크게 4가지 영역으로 나뉘어 점유된다.

- **파라미터 메모리:** 모델의 파라미터를 저장하는 공간 (위 그림에서 $W^{(i)}$)
- **활성화 메모리:** 입력 데이터가 모델의 네트워크를 타고 흐를 때 나오는 중간 계산 결과값들을 임시로 저장하는 공간 (위 그림에서 $\mathbf{x},\boldsymbol{a},\mathbf{y}$)
- **그라디언트 메모리:** 개별 파라미터마다 계산된 그라디언트 값을 저장하는 공간 (위 그림에서 $\frac{\partial\mathcal{L}}{\partial W^{(i)}}$)
- **옵티마이저 상태 메모리:** 옵티마이저가 유지해야 하는 과거의 정보를 저장하는 공간 (위 그림에서 $\hat{m}$과 $\hat{v}$)

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

따라서 

$$
\text{Activation Memory}=
\text{Token Embeddings}+\text{Positional Embeddings}+\text{Transformer Layer}
\approx 56.45\text{ GB}
$$

> **중간 결과값들을 저장해야 하는 이유가 뭘까?**
> 
> 순전파가 끝난 후 이어지는 역전파 과정에서, 파라미터마다 그라디언트를 계산할 때 필요하기 때문이다.
> 
> 예를 들어, 아래와 같은 순전파 연산 흐름이 있다고 가정해보자.
> 
> $$z_1=xW^{(1)}\to a_1=f(z_1)\to z_2=a_1W^{(2)}$$
> 
> 역전파 시 가중치 $W^{(2)}$의 그라디언트는 chain rule에 의해 아래와 같이 계산되는데, 이때 $a_1$값을 저장하지 않았다면 역전파 과정에서 그라디언트를 구할 수 없게 된다.
> 
> $$\vphantom{\Bigg(}\frac{\partial\mathcal{L}}{\partial W^{(2)}}=\frac{\partial z_2}{\partial W^{(2)}}\cdot \frac{\partial\mathcal{L}}{\partial z_2}
=a_1^\top\cdot \frac{\partial\mathcal{L}}{\partial z_2}$$

### 3. 그라디언트 (Gradient) 메모리

마지막 단계에서 모델의 가중치를 업데이트하려면 모든 파라미터마다 그라디언트가 필요하다.
<br>
따라서 그라디언트 메모리 크기는 파라미터 메모리 크기와 동일하다.

$$
\text{Gradient Memory}=
\text{num params}\times\text{precision}=
1.5\text{B}\times4\text{ Bytes}=6\text{ Billion Bytes}\approx6\text{ GB}
$$

### 4. 옵티마이저 상태 (Optimizer State) 메모리

가중치를 업데이트하는 옵티마이저는 학습의 안정성과 속도를 높이기 위해, 현재 시점의 그라디언트뿐만 아니라 과거의 그라디어트 정보도 사용한다.

예를 들어 Adam 옵티마이저의 경우, 개별 파라미터마다 자신의 사본, 모멘텀 $\hat{m}$ (과거 그라디언트 평균)과 분산 $\hat{v}$ 정보를 추가로 저장한다.

결과적으로 옵티마이저 상태 메모리 크기는 파라미터 메모리 크기의 3배에 달하게 된다.

$$
\text{Optimizer State Memory}=
3\times(\text{num params}\times\text{precision})
\approx18 \text{ GB}
$$

### 최종 VRAM 사용량

$$6 \text{ GB (가중치)} + 6 \text{ GB (기울기)} + 18 \text{ GB (옵티마이저)} + 56.43 \text{ GB (활성화)} \approx 87 \text{ GB}$$
