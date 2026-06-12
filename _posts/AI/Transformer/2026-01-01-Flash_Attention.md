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

![fig1](AI/Transformer/Flash_Attention-1.png){: style="display:block; margin:0 auto; width:70%;"}

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

1. HBM에서 $Q$와 $K$ 행렬의 일부를 SRAM으로 가져온다. **(Read)**
2. 가져온 $Q$와 $K$ 조각으로, $S=QK^\top$ 연산을 수행한다.
3. 연산이 완료된 $S$ 조각을 HBM으로 내보낸다. **(Write)**
4. $N\times N$ 크기의 $S$ 행렬이 모두 완성될 때까지 1~3 과정을 반복한다.

    ![fig2](AI/Transformer/Flash_Attention-2.png){: style="display:block; margin:0 auto; width:60%;"}
5. HBM에서 $S$의 일부 행을 SRAM으로 가져온다. **(Read)**
6. 가져온 $S$ 조각으로, $P=\text{softmax}(S)$ 연산을 수행한다.
7. Softmax가 적용된 $P$ 조각을 HBM으로 내보낸다. **(Write)**
8. $P$ 행렬이 모두 완성될 때까지 5~7 과정을 반복한다.

    ![fig3](AI/Transformer/Flash_Attention-3.png){: style="display:block; margin:0 auto; width:50%;"}
9. 마지막으로 HBM에서 $V$와 $P$ 행렬의 일부를 SRAM으로 가져온다. **(Read)**
10. 가져온 $V$와 $P$ 조각으로, $O=PV$ 연산을 수행한다.
11. 연산이 완료된 $O$ 조각을 HBM으로 내보낸다. **(Write)**
12. $N\times D$ 크기의 $O$ 행렬이 모두 완성될 때까지 7~8 과정을 반복한다.

    ![fig4](AI/Transformer/Flash_Attention-4.png){: style="display:block; margin:0 auto; width:60%;"}

SRAM의 물리적인 용량이 작기 때문에, 하드웨어 연산기 수준에서는 데이터를 작은 조각으로 나누어 처리하는 Tiling 방식으로 동작한다.

하지만 Standard Attention 의 치명적인 문제는 중간 결과물인 $S$와 $P$의 크기에 있다.
<br>
일반적으로 시퀀스 길이 $N$이 Head 차원 $d_h$보다 압도적으로 크기 때문에, 중간에 생성되는 $S$와 $P$ 행렬은 $N \times N$이라는 막대한 공간을 차지하게 된다.

문제는 이렇게 거대한 행렬이 느린 HBM과 SRAM 사이를 반복해서 오간다는 점이다. (5~7번 과정)

비록 Tiling을 통해 한 번에 올리는 데이터의 크기를 줄였더라도 과정이 반복되기 때문에, 결국 전체 HBM 접근량 자체는 $O(N^2)$에 달하게 된다.

## Flash Attention

Flash Attention에서는 Tiling Softmax (Online Softmax)를 구현하여, 기존 Softmax 함수의 I/O 병목을 줄였다.

Flash Attention의 GPU 메모리 계층 간 데이터 이동 과정은 다음과 같다.

1. HBM에서 $Q,K,V,O$ 행렬의 일부와 Softmax 통계량을 SRAM으로 가져온다. **(Read)**

    (첫 번째 루프여서 $O$와 Softmax 통계량이 없다면, 초기화된 기본값을 가져온다.)
2. 가져온 $Q$와 $K$ 조각으로, $S=QK^\top$ 연산을 수행한다.
3. 가져온 Softmax 통계량을 이용해, SRAM에서 바로 $P$ 조각을 계산한다.
4. 계산된 $P$ 조각과 가져온 $V$ 조각으로, SRAM에서 바로 $O=PV$ 연산을 수행한다.
5. 2~3 과정에서 생성된 $S$와 $P$ 조각은 HBM에 내보내지 않고, 연산이 끝나는 즉시 바로 폐기한다.
6. 최종적으로 업데이트된 $O$ 조각과 통계량만 HBM으로 내보낸다. **(Write)**
7. $N\times D$ 크기의 $O$ 행렬이 모두 완성될 때까지 1~6 과정을 반복한다.



### 기존 Softmax의 한계점

입력 데이터 $x_i$에 대해, Softmax 연산은 다음과 같다.

$$
\text{Softmax}(x_i) = \frac{e^{x_i - m}}{l}
,\quad\text{where }x_i\in\mathbf{x}
\tag{1}
$$

여기서 $m$은 전체 원소의 최댓값 $\max(\mathbf{x})$이고, $l$은 지수 함수의 전체 합 $\sum_j e^{x_j - m}$을 의미한다.

Stadard Attention에서 무거운 $S$ 행렬을 HBM에서 계속 읽고 쓰는 이유는, Softmax 연산의 특성상 $m$과 $l$을 구하기 위해 행 단위의 전체 데이터를 한 번에 알아야 하기 때문이다.

### Online Softmax

Online Softmax는 각 행마다 Softmax 통계량 $m$과 $l$을 별도로 저장하며, 새로운 블록이 들어올 때마다 이 통계량을 업데이트한다.

#### 최대값 업데이트

이전 블록까지 구한 임시 최댓값을 $m_{\text{old}}$로, 현재 새로 가져온 블록 데이터의 최대값을 $m_{\text{now}}$라고 하자.

과거의 최댓값과 현재 블록의 최대값을 비교하여, 전체 최댓값을 업데이트한다.

$$
m_{\text{new}}=\max(m_{\text{old}},m_{\text{now}})
\tag{2}
$$

#### 지수합 업데이트

이전 블록까지 구한 임시 지수합을 $l_{\text{old}}$라고 하자.

앞서 전체 최댓값이 $m_{\text{new}}$로 업데이트되었기 때문에, 과거에 구해둔 분모의 지수합 $l_{old}$도 새로운 기준에 맞춰 업데이트한다.

$$
l_{\text{new}} = l_{\text{old}} \cdot e^{m_{\text{old}} - m_{\text{new}}} + \sum e^{x_{\text{new}} - m_{\text{new}}}
\tag{3}
$$

> **식 (3)이 성립하는 이유**
> 
> 이전 지수합 $l_{\text{old}}$는 $\sum e^{x_{\text{old}} - m_{\text{old}}}$ 로 계산된 상태이다.
> 
> 여기에 보정값인 $e^{m_{\text{old}} - m_{\text{new}}}$를 곱하면, 다음과 같이 식을 전개할 수 있다.
>
> $$\left( \sum e^{x_{\text{old}} - m_{\text{old}}} \right) \cdot e^{m_{\text{old}} - m_{\text{new}}} = \sum e^{(x_{\text{old}} - m_{\text{old}}) + (m_{\text{old}} - m_{\text{new}})} = \sum e^{x_{\text{old}} - m_{\text{new}}}$$
>
> 즉, 과거 데이터를 다시 메모리에서 불러오지 않더라도, 처음부터 전체 최댓값 $m_{\text{new}}$를 알고 계산했던 것과 수학적으로 완벽히 동일한 결괏값이 도출된다.

#### 최종 출력 행렬 $O$ 업데이트

기존의 출력 행렬 $O_{\text{old}}$ 역시 과거의 지수합 $l_{\text{old}}$와 과거의 최댓값 $m_{\text{old}}$ 를 기준으로 만들어진 임시 결과물이다.

따라서 새로운 블록을 가져올 때마다, 스케일링을 통해 이전 출력과 현재 출력 $O_{\text{now}}$ 를 병합하여 업데이트한다.

$$
O_{\text{new}} =
\frac{O_{\text{old}} \cdot l_{\text{old}} \cdot e^{m_{\text{old}} - m_{\text{new}}} + O_{\text{now}} \cdot l_{\text{now}} \cdot e^{m_{\text{now}} - m_{\text{new}}}}{l_{\text{new}}}
\tag{4}
$$
