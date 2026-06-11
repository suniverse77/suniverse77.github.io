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

- 하드디스크: 프로그램 실행 전 or 껐을 때 파일 형태로 데이터가 저장되는 곳 (전기가 나가도 사라지지 않는 비휘발성)
- CPU RAM: 변수를 초기화하거나 파일을 load했을 때 임시로 저장되는 곳, 휘발성이고 CPU가 바로 가져다 사용할 수 있음
- GPU RAM: .to(cuda)를 이용해 CPU RAM에 있던 데이터를 복사

### GPU 메모리 계층

GPU 메모리 종류는 크게 HBM과 SRAM으로 나눌 수 있다.

#### HBM (High Bandwidth Memory)

HBM은 여러 개의 DRAM (Dynamic RAM) 칩을 수직으로 쌓아 올린 형태이다.

우리가 흔히 말하는 VRAM (Video RAM)이라고 부르는 공간으로, 모델의 가중치와 대규모 입력 데이터가 상주하는 메인 메모리이다.

저장 용량이 매우 크고 한 번에 전송할 수 있는 대역폭이 넓지만, 연산을 수행하는 GPU Core 물리적으로 멀리 떨어져 있다.
<br>
데이터를 읽고 쓰는 Latency가 길기 때문에, 연산 장치가 HBM에서 데이터를 기다리느라 놀게 되는 병목 현상의 주범이

#### SRAM (Static Random Access Memory)

연산을 수행하는 GPU Core 옆에 붙어 있는 Cache 메모리이다.

HBM에 비해 데이터를 읽고 쓰는 속도가 압도적으로 빠르지만, 칩 내부에 물리적으로 할당되어 있어 용량이 매우 작다.
<br>
따라서 모든 데이터를 올려둘 수 없고, 당장 연산에 필요한 핵심 데이터만 아주 짧은 시간 동안 머물다 간다.

## Standard Attention


## Flash Attention
