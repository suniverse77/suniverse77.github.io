---
title: "[PyTorch] CUDA Core와 Tensor Core"
date: 2026-05-29 00:00:00 +/-TTTT
categories: [Programming, 파이토치 (PyTorch)]
tags: [PyTorch]
math: true
toc: true
author: sunho
---

## 코어(Core)란?

코어(Core)는 컴퓨터에서 실제로 수학적 계산을 수행하고 명령을 처리하는 물리적인 일꾼을 의미한다.

- **CPU Core:** 복잡하고 다양한 종류의 명령을 순차적으로 빠르게 처리하는 데 특화된 소수 정예 일꾼
    - OS 구동, 일반적인 프로그램 실행 등 컴퓨터의 전반적인 제어와 복잡한 논리 연산을 지휘
    - 개별 코어 하나하나의 성능이 매우 뛰어나며, 보통 하나의 칩에 4개에서 24개 정도가 탑재됨
- **GPU Core:** 단순한 수학 연산을 동시에 병렬로 처리하는 데 특화된 수천 명의 분업화된 일꾼
    - 그래픽 렌더링이나 딥러닝에서의 단순 연산을 전담
    - 개별 코어가 처리할 수 있는 명령의 복잡도는 CPU보다 낮지만, 하나의 칩에 수천~수만 개 이상이 탑재됨

![fig1](Programming/PyTorch/CUDA_Tensor_Core-1.png){: style="display:block; margin:0 auto; width:50%;"}
_[[출처]](https://www.researchgate.net/figure/CPU-vs-GPU-architecture-each-blue-square-represents-one-core_fig1_323281068)_

## CUDA Core vs Tensor Core

CUDA Core와 Tensor Core는 모두 GPU 코어이다.

아래는 한 눈에 보는 비교 표이다.

| 구분 | 쿠다 코어 (CUDA Core) | 텐서 코어 (Tensor Core) |
| :---: | :---: | :---: |
| **주요 역할** | 수학 연산 및 그래픽 처리 | 딥러닝 모델의 대규모 행렬 연산 가속 |
| **연산 단위** | 스칼라 (1D), 데이터 1개씩 처리 | 행렬 (2D/3D), 블록 단위로 한 번에 처리 |
| **처리 속도** | 행렬 곱셈 시, 상대적으로 느림 | 행렬 곱셈 시, 압도적으로 빠름 |
| **주요 데이터 포맷** | `FP32`, `INT32` 등 | `FP16`, `BF16`, `TF32`, `INT8`, `FP8` 등 |

우주선 궤도 시뮬레이션, 기상 예측과 같은 정밀한 작업에서는 소수점 아래 미세한 숫자의 오차가 궤도 이탈과 같은 치명적인 결과로 이어질 수 있다.
<br>
이 때문에 CUDA Core는 `FP32`, `INT32` 등의 무거운 데이터 포멧을 사용해서 정밀한 연산을 지원하도록 설계되었다.

반면 딥러닝은 본질적으로 확률과 통계에 기반한다.
<br>
예를 들어 모델이 '이 사진이 강아지일 확률은 85.1234567%야.'라고 할 필요 없이, '85.1%야.'라고만 해도 강아지를 분류하는 데 아무런 지장이 없다.
<br>
따라서 Tensor Core는 `FP16`, `BF16` 등의 가벼운 데이터 포맷을 사용해서 불필요한 정밀도를 과감히 버리도록 설계되었다.

### 쿠다 코어 (CUDA Core)

GPU 내부의 CUDA Core는 본질적으로 CPU Core와 유사하게 수학적 계산과 명령 처리를 수행한다.
<br>
CUDA Core는 CPU Core에 비해 구조가 단순하고 Clock Rate가 낮은 대신, GPU 하나에 수천 개가 탑재되어 있어서 압도적인 병렬 처리를 할 수 있다.

이러한 CUDA Core는 그래픽 렌더링, 물리 시뮬레이션, 일반적인 수학 계산 등 범용적인 목적을 위해 만들어졌다.

1개의 CUDA Core는 1 GPU clock에 1개의 데이터끼리만 더하거나 곱할 수 있다.

즉 CUDA Core는 행렬을 곱할 때 원소들을 하나하나 순차적으로 계산해야 하므로, 대규모 행렬 연산이 존재하는 딥러닝 모델에서는 연산 효율이 크게 떨어진다.

### 텐서 코어 (Tensor Core)

Tensor Core는 오직 딥러닝과 고성능 컴퓨팅의 가속을 위해 설계된 특수 목적 하드웨어이다.

CUDA Core와 달리, 1개의 Tensor Core는 1 GPU clock에 행렬을 블록 단위로 처리한다.
<br>
현재는 연산 단위가 훨씬 커졌지만, Tensor Core가 처음 등장했던 초창기의 기본 연산 단위는 4x4 행렬이었다.

딥러닝의 핵심 연산은 matrix multiply-accumulate이다.

$$
D=A\times B+C
$$

![fig2](Programming/PyTorch/CUDA_Tensor_Core-2.png){: style="display:block; margin:0 auto; width:80%;"}
_[[출처]](https://dreamgonfly.github.io/blog/cuda-cores-vs-tensor-cores/)_

입력 행렬 $A,B,C$가 4x4 행렬일 때, 위 연산을 하려면 64번의 곱셈과 64번의 덧셈이 필요하다.
<br>
이 연산을 처리할 때 두 코어의 속도 차이는 다음과 같다.

- **CUDA Core:** 한 번에 하나의 데이터만 처리할 수 있기 때문에, 위 연산을 128 GPU clock이 소모된다. 덧셈과 곱셈을 1 clock에 처리하는 FMA(Fused Multiply-Add) 기술을 쓴다고 해도, 총 64 GPU clock이 소모된다.
- **Tensor Core:** 4x4 블록 전체를 단 한 번의 작동으로 계산해 버리기 때문에, 위 연산을 1 GPU clock 만에 끝낸다.
