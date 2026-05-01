---
title: "[GPU 분산 학습] 딥러닝 모델 파라미터 메모리 산출"
date: 2026-04-30 00:00:00 +/-TTTT
categories: [Programming, 파이토치]
tags: [GPU 분산 학습]
math: true
toc: true
author: sunho
---

딥러닝 모델을 학습할 때, GPU 메모리 (VRAM)는 크게 4가지 영역으로 나뉘어 사용된다.

[GPT 2 - XL](https://huggingface.co/openai-community/gpt2-xl) 모델을 예시로 들겠다.

- 파라미터 수: 1.5B (15억)
- 

### 1. 파라미터 (Parameters) 메모리

딥러닝 모델의 파라미터는 네트워크를 구성하는 weight와 bias로, 모델의 고정된 구성 요소이다.
<br>
즉, **파라미터 메모리**는 모델 자체가 차지하는 기본적인 물리적 용량을 의미한다.

우리가 허깅페이스 등 웹에서 다운로드하는 모델 가중치 파일 ( `.safetensors`, `.pt` 등)의 크기나, 학습을 위해 `model.to('cuda')` 명령어로 GPU에 모델을 처음 로드할 때 점유되는 VRAM이 바로 이 파라미터 메모리에 해당한다.

이 파라미터 메모리는 모델의 파라미터 수와 데이터 정밀도에 의해 결정된다.

- `FP32` : 파라미터 1개를 32 Bits (4 Byte)로 표현
- `FP16` / `BF16` : 파라미터 1개를 16 Bits (2 Byte)로 표현
- `INT8`: 파라미터 1개를 8 Bits (1 Byte)로 표현
- `INT4`: 파라미터 1개를 4 Bits (0.5 Byte)로 표현

예를 들어 `FP32` 정밀도로 학습하거나 로드할 경우, 파라미터 메모리는 다음과 같이 산출된다.

$$
\text{Parameter Memory}=
\text{파라미터 수} \times \text{정밀도 크기} = 1.5 \text{B} \times 4 \text{ Bytes} = 6 \text{ Billion Bytes} \approx 6 \text{ GB}
$$

### 2. 그라디언트 (Gradient) 메모리

모델 학습은 크게 세 단계의 사이클로 이루어진다.

$$
\begin{gathered}
\text{Forward Pass (Loss 계산)}\\
\downarrow\\
\text{Backward Pass (Gradient 계산)}\\
\downarrow\\
\text{Optimizer Step (가중치 업데이트)}
\end{gathered}
$$

**그라디언트 메모리**는 역전파 과정에서 계산된 기울기 값들이 임시로 저장되는 공간을 의미한다.
<br>
마지막 단계에서 모델의 가중치를 업데이트하려면

파라미터마다 가중치가 존재하기 때문에 그라디언트 메모리는 파라미터 메모리와 동일하다.

$$
\text{Gradient Memory}=\text{Parameter Memory}\approx 6 \text{ GB}
$$

### 3. 옵티마이저 상태 (Optimizer State) 메모리

4. 옵티마이저 상태 (Optimizer State - Adam)Adam 옵티마이저는 학습의 안정성을 위해 각 파라미터의 과거 기울기 평균(Momentum)과 분산(Variance) 정보를 추가로 기억해야 합니다.사진에서는 옵티마이저가 차지하는 공간을 모델 가중치의 3배로 잡았습니다. (일반적으로 FP32 상태의 모멘텀, 분산, 그리고 Master Weight 사본 등을 포함한 크기입니다).$6 \text{ GB} \times 3 = 18 \text{ GB}$

### 4. 활성화 (Activations) 메모리

모델 학습 중 가장 많은 메모리를 잡아먹는 주범입니다. 순전파(Forward) 때 계산된 각 레이어의 결과값들을, 역전파 때 기울기를 계산하기 위해 임시로 저장해 두는 공간입니다.이는 배치 사이즈(32)와 컨텍스트 길이(1024)에 정비례하여 커집니다.사진의 계산을 보면, 임베딩(Token/Positional) 처리와 총 48개의 레이어(Self Attention + Feed Forward)를 통과하며 생성되는 활성화 텐서들의 크기를 모두 합쳐 약 $56.43 \text{ GB}$로 계산되었습니다.✅ 총 필요 VRAM 메모리 (Total GPU Memory)$$6 \text{ GB (가중치)} + 6 \text{ GB (기울기)} + 18 \text{ GB (옵티마이저)} + 56.43 \text{ GB (활성화)} \approx 87 \text{ GB}$$
