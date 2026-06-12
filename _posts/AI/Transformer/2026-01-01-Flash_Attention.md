---
title: "[트랜스포머] Flash Attention"
date: 2026-01-01 0:00:00 +/-TTTT
categories: [AI, 트랜스포머]
tags: [트랜스포머, Attention]
math: true
toc: true
author: sunho
---

**📄 관련 논문:** [NeurIPS 2022] [FlashAttention: Fast and Memory-Efficient Exact Attention with IO-Awareness](https://arxiv.org/abs/2205.14135)

**📄 관련 논문:** [ICLR 2024] [FlashAttention-2: Faster Attention with Better Parallelism and Work Partitioning](https://arxiv.org/abs/2307.08691)

## 하드웨어 개념

- **하드디스크:** 프로그램 실행 전이나 전원이 꺼졌을 때 파일 형태로 데이터가 보존되는 비휘발성 저장 장치이다.
- **CPU RAM:** 변수를 초기화하거나 파일을 로드할 때 데이터가 임시로 저장되는 공간이다. 전원이 꺼지면 데이터가 사라지는 휘발성 메모리이며, CPU가 직접 접근하여 데이터를 처리한다. 하드 디스크에 있는 데이터를 PyTorch의 `torch.load()`와 같은 코드를 통해 CPU RAM으로 복사할 수 있다.
- **GPU RAM:** CPU 메모리에 있는 데이터를 대규모 병렬 연산을 위해 복사해 두는 공간이다. CPU RAM에 있는 데이터를 PyTorch의 `.to('cuda')`와 같은 코드를 통해 GPU RAM으로 복사할 수 있다.

### GPU 메모리 계층

Flash Attention의 동작 원리를 이해하기 위해, GPU 메모리의 종류를 크게 HBM과 SRAM으로 나눠서 살펴보겠다.

![fig1](AI/Transformer/Flash_Attention-1.png){: style="display:block; margin:0 auto; width:80%;"}

#### HBM (High Bandwidth Memory)

HBM은 여러 개의 DRAM (Dynamic RAM) 칩을 수직으로 쌓아 올린 형태이다.

우리가 일반적으로 VRAM이라고 부르는 공간으로, 딥러닝 모델의 가중치와 대규모 입력 데이터가 상주하는 GPU의 메인 메모리 역할을 한다.

저장 용량이 비교적 크고 한 번에 전송할 수 있는 대역폭이 넓지만, 연산을 수행하는 GPU Core 물리적으로 멀리 떨어져 있어 데이터를 읽고 쓰는 Latency가 길다는 단점이 있다.
<br>
이로 인해 GPU Core가 HBM에서 데이터가 오기를 기다리며 쉬게 되는 Memory Bottleneck 현상이 발생하게 된다.

#### SRAM (Static Random Access Memory)

SRAM은 연산을 수행하는 GPU Core 바로 옆에 위치한 고속 Cache 메모리이다.

HBM에 비해 데이터를 읽고 쓰는 속도가 압도적으로 빠르지만, 칩 내부에 물리적으로 할당되어 있어 용량이 매우 제한적이다. (보통 수백 KB 수준)
<br>
따라서 모든 데이터를 SRAM에 올려둘 수는 없으며, 당장 연산에 필요한 핵심 데이터만 아주 짧은 시간 동안 머물게 된다.

## Standard Attention

Standard Attention의 GPU 메모리 계층 간 데이터 이동 과정은 다음과 같다.

1. HBM에서 $Q,K,V$ 행렬의 일부를 SRAM으로 가져와 $S=QK^\top$ 연산을 수행한다. (Read)
2. 수행된 $S$ 조각을 HBM으로 이동한다. (Write)
3. 1~2 과정을 $S$가 완성될 때까지 반복한다.
4. HBM에서 $S$의 일부 row를 SRAM으로 가져와 Softmax 연산을 수행한다. (Read)
5. $P$ 조각을 HBM으로 이동한다. (Write)
6. 4~5 과정을 $P$가 완성될 때까지 반복한다.
7. HBM에서 $V$와 $P$ 행렬의 일부를 SRAM으로 가져와 $O=PV$ 연산을 수행한다. (Read)
8. 수행된 $O$ 조각을 HBM으로 이동한다. (Write)
3. 1~2 과정을 $O$가 완성될 때까지 반복한다.

연산을 조각별로 Tiling하는 이유는 SRAM의 크기가 작기 때문이다.

일반적으로 시퀀스 길이 $N$이 Head 차원 $d_h$보다 훨씬 크며, 이 때문에 $S$ 행렬의 크기도 매우 크다.

그런데 4~5 과정을 보면, 이렇게 거대한 $S$ 행렬이 전송 속도가 느린 HBM과 SRAM 사이를 왔다갔다 하는 것을 볼 수 있다.

비록 Tiling을 수행하지만, 결국 $O(N^2)$이다.

![fig2](AI/Transformer/Flash_Attention-2.png){: style="display:block; margin:0 auto; width:80%;"}

![fig3](AI/Transformer/Flash_Attention-3.png){: style="display:block; margin:0 auto; width:80%;"}

![fig4](AI/Transformer/Flash_Attention-4.png){: style="display:block; margin:0 auto; width:80%;"}

## Flash Attention

Flash Attention에서는 Tiling Softmax (Online Softmax)를 구현하여 
