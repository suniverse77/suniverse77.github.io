---
title: "[GPU 분산 학습] DP / DDP"
date: 2026-04-30 06:00:00 +/-TTTT
categories: [Programming, 파이토치]
tags: [GPU 분산 학습]
math: true
toc: true
author: sunho
---

PyTorch에는 GPU 병렬 처리를 위한 두 가지 방식 (DP, DDP)이 있다.

## DP (Data Parallel)

DP는 단일 프로세스 (Single-process), 멀티 스레드 (Multi-thread) 방식으로 동작한다.

동작 방식은 아래와 같다.

1. Master GPU가 하나의 배치를 가져온 뒤, GPU 개수에 맞게 배치 데이터를 쪼개서 각 GPU에게 나누어 준다.
2. Master GPU가 모델의 최신 가중치를 다른 GPU들에게 복사해 준다.
3. 각 GPU는 자신이 할당받은 배치로 순전파(Forward) 연산을 수행해서 예측값을 얻는다.<br>그리고 각 GPU의 예측값을 다시 Master GPU로 전부 모은다.
4. Master GPU가 모아진 예측값을 바탕으로 Loss를 계산한다.<br>이후 Loss를 다시 각 GPU로 나누어 준다.
5. 각 GPU는 전달받은 Loss를 바탕으로 역전파를 수행하여, 각자의 그래디언트를 계산한다.
6. 각 GPU에서 계산된 그래디언트를 Master GPU로 모아서 최종 합산하고, Master GPU는 자신이 들고 있는 원본 모델의 가중치를 업데이트한다.

![fig1](Programming/PyTorch/DP_DDP_FSDP-1.png){: style="display:block; margin:0 auto; width:100%;"}

구현이 단순하다는 장점이 있지만, 매 스텝마다 각 GPU의 순전파 결과값과 그래디언트를 Master GPU 한 곳으로 모아서 Loss 계산 및 가중치 업데이트를 진행한다는 구조적 한계가 있다. 
<br>
이로 인해 GPU 간 통신 병목 현상이 발생하며, Master GPU에만 연산과 메모리 부하가 집중되는 GPU 불균형 현상이 발생한다.

![fig2](Programming/PyTorch/DP_DDP_FSDP-2.png){: style="display:block; margin:0 auto; width:40%;"}

## DDP (Distributed Data Parallel)

DDP는 멀티 프로세스 (Multi-process) 방식으로 동작한다.
<br>
즉 Master GPU 없이, 모든 GPU가 독립적인 프로세스로 동작한다.

동작 방식은 아래와 같다.

1. 각 GPU가 DistributedSampler를 통해 전체 데이터셋에서 자신에게 할당된 배치 데이터를 개별적으로 직접 읽어온다.
2. 전체 배치 데이터를 쪼개서 각 GPU에 나누어 준다.
3. 각 GPU는 할당받은 데이터로 순전파와 역전파 연산을 독립적으로 수행하여 자신만의 그래디언트를 계산한다.
4. Master GPU로 데이터를 모으지 않고, 각 GPU가 계산한 그래디언트만 서로 교환하여 더한다.
5. 이후 각 GPU는 서로 동일하게 업데이트된 모델 가중치를 가지게 된다.

![fig1](Programming/PyTorch/DP_DDP_FSDP-1.png){: style="display:block; margin:0 auto; width:80%;"}

DP와 달리, Master GPU로 데이터를 모으는 과정이 없어 모든 GPU가 메모리를 균등하게 사용한다.

## FSDP (Fully Sharded Data Parallel)

기본적으로 DP와 DDP 모두 각 GPU마다 모델의 가중치를 무조건 하나씩 올려두어야 한다.
<br>
따라서 모델 자체는 GPU 1대에 충분히 올라가지만 Batch Size가 커서 OOM (Out of Memory)이 발생하는 경우에는 해결이 가능하지만, 모델 자체가 커서 OOM이 발생하는 경우에는 해결하지 못한다.


### Multi-processing

Multi-processing을 이해하기 전, 먼저 프로세스와 스레드에 대해 간단히 이해해야 한다.

**프로세스 (Process)**

먼저 프로그램 (program)이란 컴퓨터에서 실행 할 수 있는 파일을 의미한다.

프로세스는 이 프로그램을 실행시킨 것, 즉 프로그램이 실행되고 있는 상태를 의미한다.
(예: 파이썬 스크립트 실행, 크롬 브라우저 켜기 등)

각 프로세스는 독립된 메모리 공간 (작업 공간)을 할당받는다.

**스레드 (Thread)**

스레드는 하나의 프로세스 내에서 작업의 흐름을 의미한다. (쉽게 말해 작업을 수행하는 일꾼)

하나의 프로세스 안에 있는 스레드들은 해당 프로세스의 메모리 공간을 서로 공유하며 일한다.

만약 하나의 프로세스에 스레드가 하나만 존재한다면, 크롬 브라우저를 실행했을 때 파일을 다운로드하면서 동시에 다른 탭에서 웹서핑을 하는 것이 불가능했을 것이다.

즉, 스레드 수가 많을 수록 (Multi-Thread) 동시에 할 수 있는 작업의 수가 증가하게 된다.

![fig1](Programming/PyTorch/DDP-1.png){: style="display:block; margin:0 auto; width:80%;"}
_[[출처]](https://www.go-cloudsec.com/2024/07/14/350/)_

**Multi-processing**

Multi-processing은 이름 그대로 스레드의 개수를 늘리는 게 아니라, 아예 프로세스를 여러 개 동시에 가동하는 방식이다.

일반적으로는 Multi-Thread가 효율적이지만, 파이썬에는 치명적인 약점이 있다. 파이썬은 프로세스 내에 스레드가 아무리 많아도, 한 번에 오직 하나의 스레드만 파이썬 코드를 실행할 수 있다는 규칙을 가지고 있다.

이를 파이썬 GIL (Global Interpreter Lock)이라고 한다.

따라서 하나의 프로세스 내에서 여러 스레드가 GPU를 나눠서 컨트롤하려는 DP는 GIL에 가로막혀 온전한 병렬 처리를 하지 못해 속도가 느려진다.

반면, GPU마다 하나의 프로세스를 할당시키는 DDP는 GIL의 간섭을 받지 않으므로 연산 속도가 훨씬 빠르다.
