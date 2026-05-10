---
title: "[GPU 분산 학습] DP / DDP / FSDP 개념"
date: 2026-04-30 06:00:00 +/-TTTT
categories: [Programming, 파이토치]
tags: [GPU 분산 학습]
math: true
toc: true
author: sunho
---

PyTorch에는 GPU 병렬 처리를 위한 두 가지 방식 (DP, DDP)이 있다.

## DP (Data Parallel)

DP는 **단일 프로세스 (Single-process)**, **멀티 스레드 (Multi-thread)** 방식으로 동작한다.

즉, 하나의 파이썬 프로세스 내에서 여러 개의 스레드를 생성하여 작업을 분산한다.
<br>
스레드는 물리적으로 동일한 컴퓨터의 메모리를 공유해야만 작동하므로, 반드시 한 대의 컴퓨터 (single node) 환경에서만 사용할 수 있다.

동작 방식은 아래와 같다.

1. Master GPU가 하나의 배치를 가져온 뒤, GPU 개수에 맞게 배치 데이터를 쪼개서 각 GPU에게 나누어 준다.
2. Master GPU가 모델의 최신 가중치를 다른 GPU들에게 복사해 준다.
3. 각 GPU는 자신이 할당받은 배치로 순전파 연산을 수행해서 예측값을 얻는다.
    <br>그리고 각 GPU의 예측값을 다시 Master GPU로 전부 모은다.
4. Master GPU가 모아진 예측값을 바탕으로 Loss를 계산한다.
    <br>이후 Loss를 다시 각 GPU로 나누어 준다.
5. 각 GPU는 전달받은 Loss를 바탕으로 역전파를 수행하여, 각자의 그래디언트를 계산한다.
6. 각 GPU에서 계산된 그래디언트를 **Reduce** 통신을 통해 Master GPU로 모아서 최종 합산하고, Master GPU는 자신이 들고 있는 원본 모델의 가중치를 업데이트한다.

![fig1](Programming/PyTorch/DP_DDP_FSDP-1.png){: style="display:block; margin:0 auto; width:100%;"}

구현이 단순하다는 장점이 있지만, 매 스텝마다 각 GPU의 순전파 결과값과 그래디언트를 Master GPU 한 곳으로 모아서 Loss 계산 및 가중치 업데이트를 진행한다는 구조적 한계가 있다. 
<br>
이로 인해 GPU 간 통신 병목 현상이 발생하며, Master GPU에만 연산과 메모리 부하가 집중되는 GPU 불균형 현상이 발생한다.

### DP의 VRAM 사용량

DP에서 업데이트는 GPU 0에서만 일어나기 때문에, 옵티마이저 상태 (O)는 GPU 0에만 존재한다.

예를 들어 GPU 1장에서 28GB를 사용하는 경우, 그 내역이 다음과 같다고 해보자.

- 파라미터 메모리: 7GB
- 그래디언트 메모리: 7GB
- 옵티마이저 상태 메모리: 7GB
- activation 메모리: 7GB

이 모델을 GPU 4장에 DP로 학습하면 메모리 사용량은 다음과 같이 변한다.

- **GPU 0:** 28GB
- **GPU 1,2,3:** 21GB (옵티마이저 상태 메모리 x)

![fig2](Programming/PyTorch/DP_DDP_FSDP-2.png){: style="display:block; margin:0 auto; width:80%;"}

## DDP (Distributed Data Parallel)

DDP는 **멀티 프로세스 (Multi-process)** 방식으로 동작한다.

즉, Master GPU 없이 각 GPU가 독립적인 프로세스를 생성하여 작업을 분산한다.
<br>
프로세스는 물리적인 메모리 공유 없이 네트워크를 통해 통신하므로, 한 대의 컴퓨터뿐만 아니라 여러 대의 컴퓨터 (multi-node) 환경에서도 사용할 수 있다.

동작 방식은 아래와 같다.

1. 초기 학습 시작 시점에 한 번만 가중치를 동기화한다. (매 스텝마다 가중치 복사 X)
2. 각 GPU가 `DistributedSampler`를 통해 전체 데이터셋에서 자신에게 할당된 배치 데이터를 개별적으로 직접 읽어온다.

    (샘플이 1000장이고 GPU가 4개인 경우: GPU 0은 0~249번째, GPU 1은 250~499번째, GPU 2는 500~749번째, GPU 3은 750~999번째 샘플을 사용)
3. 각 GPU는 자신이 할당된 배치 내에서, 순전파 연산을 수행해서 개별적으로 Loss를 계산한다.
4. 각 GPU는 스스로 계산한 Loss를 바탕으로 역전파를 수행하여, 각자의 그래디언트를 계산한다.
6. 각 GPU는 각자 계산한 그래디언트를 **All-Reduce** 통신을 통해 서로 교환하고 합산되어, 모든 GPU가 완벽히 동일한 그래디언트를 동시에 나눠 갖게 된다.
    <br>
    이후 각 GPU는 이 동일한 그래디언트를 이용해 각자의 가중치를 독립적으로 업데이트하므로, 다음 스텝에서도 모든 모델의 상태가 똑같이 유지된다.

![fig3](Programming/PyTorch/DP_DDP_FSDP-3.png){: style="display:block; margin:0 auto; width:100%;"}

Master GPU로 데이터와 연산이 집중되지 않고, 각 GPU가 독립적으로 연산을 수행하기 때문에, 통신 병목과 GPU 불균형 현상이 해결되어 분산 학습 속도가 매우 빠르다는 장점이 있다.
<br>
하지만 모든 GPU가 모델의 파라미터, 옵티마이저 상태 등의 복사본을 각각 중복해서 메모리에 유지해야 하기 때문에 VRAM 소모가 여전히 심하며, 이 때문에 모델의 크기가 단일 GPU의 메모리 용량을 초과하는 경우에는 학습이 불가능하다.

### DDP의 VRAM 사용량

DDP의 목적은 메모리 절약이 아니라, 한 번에 처리하는 배치 크기를 늘려 학습 속도를 향상시키는 것이다.

예를 들어 `batch_size=1`로 GPU 1장으로 학습하면, 1epoch을 도는 데 N번의 step이 필요하다.
<br>
이때 DDP를 사용해 `batch_size=1`로 GPU 4장으로 학습하면, 1epoch을 도는 데 N/4번의 step만 필요하게 된다.

하지만 각 GPU가 독립적인 프로세스로 동작하기 때문에, 모델 파라미터 (P), 그래디언트 (G), 옵티마이저 상태 (O), activation (A)를 모두 독립적으로 가지고 있다.

예를 들어 GPU 1장에서 28GB를 사용하는 경우, 그 내역이 다음과 같다고 해보자.

- 파라미터 메모리: 7GB
- 그래디언트 메모리: 7GB
- 옵티마이저 상태 메모리: 7GB
- activation 메모리: 7GB

이 모델을 GPU 4장에 DDP로 학습해도, 각 GPU의 메모리 사용량은 동일하게 28GB이다.

![fig4](Programming/PyTorch/DP_DDP_FSDP-4.png){: style="display:block; margin:0 auto; width:80%;"}

> **Multi-processing이란?**
> 
> Multi-processing을 이해하기 전, 먼저 프로세스와 스레드에 대해 간단히 이해해야 한다.
> 
> **프로그램 (program)**이란 컴퓨터에서 실행 할 수 있는 파일을 의미한다.
    <br>
    **프로세스 (Process)**는 이 프로그램을 실행시킨 것, 즉 프로그램이 실행되고 있는 상태를 의미한다.
    (예: 파이썬 스크립트 실행, 크롬 브라우저 켜기 등)
    <br>
    각 프로세스는 독립된 메모리 공간 (작업 공간)을 할당받는다.
>
> **스레드 (Thread)**는 하나의 프로세스 내에서 작업의 흐름을 의미한다. (쉽게 말해 작업을 수행하는 일꾼)
    <br>
    하나의 프로세스 안에 있는 스레드들은 해당 프로세스의 메모리 공간을 서로 공유하며 일한다.
    <br>
    만약 하나의 프로세스에 스레드가 하나만 존재한다면, 크롬 브라우저를 실행했을 때 파일을 다운로드하면서 동시에 다른 탭에서 웹서핑을 하는 것이 불가능했을 것이다.
    <br>즉, 스레드 수가 많을 수록 (Multi-Thread) 동시에 할 수 있는 작업의 수가 증가하게 된다.
>
> ![fig5](Programming/PyTorch/DP_DDP_FSDP-5.png){: style="display:block; margin:0 auto; width:80%;"}
_[[출처]](https://www.go-cloudsec.com/2024/07/14/350/)_
> 
> **Multi-processing**은 이름 그대로 스레드의 개수를 늘리는 게 아니라, 아예 프로세스를 여러 개 동시에 가동하는 방식이다.
    <br>
    일반적으로는 Multi-Thread가 효율적이지만, 파이썬에는 치명적인 약점이 있다. 파이썬은 프로세스 내에 스레드가 아무리 많아도, 한 번에 오직 하나의 스레드만 파이썬 코드를 실행할 수 있다는 규칙을 가지고 있다.
    <br>
    이를 **파이썬 GIL (Global Interpreter Lock)**이라고 한다.
> 
> 따라서 하나의 프로세스 내에서 여러 스레드가 GPU를 나눠서 컨트롤하려는 DP는 GIL에 가로막혀 온전한 병렬 처리를 하지 못해 속도가 느려진다.
    <br>
    반면, GPU마다 하나의 프로세스를 할당시키는 DDP는 GIL의 간섭을 받지 않으므로 연산 속도가 훨씬 빠르다.

## FSDP (Fully Sharded Data Parallel)

기본적으로 DP와 DDP 모두 각 GPU마다 모델의 가중치를 무조건 하나씩 올려두어야 한다.
<br>
따라서 모델 자체는 GPU 1대에 충분히 올라가지만 Batch Size가 커서 OOM (Out of Memory)이 발생하는 경우에는 해결이 가능하지만, 모델 자체가 커서 OOM이 발생하는 경우에는 해결하지 못한다.

반면 FSDP는 모델의 상태를 모든 GPU에 조각내어 분산 저장하기 때문에, 모델 자체가 큰 경우에도 학습이 가능하다.

동작 방식은 아래와 같다.

1. 초기화 단계에서 전체 모델의 <span style="color:red">파라미터, 옵티마이저 상태, 그래디언트</span>를 GPU 개수만큼 조각 내어, 각 GPU는 자신에게 할당된 파츠만 메모리에 유지한다. 
    <br>
    이렇게 모델의 파라미터, 그래디언트, 옵티마이저 상태를 GPU 개수만큼 조각 내어 분산 저장하는 것을 **sharding**이라고 한다.
2. 데이터 배치는 DDP와 마찬가지로, `DistributedSampler`를 통해 각자 개별적으로 가져온다.
3. 순전파 연산 과정에서 특정 layer의 계산 차례가 오면, **All-gather** 통신을 통해 다른 GPU들로부터 파라미터 조각들을 임시로 모아 온전한 형태의 layer 가중치를 조립한다.
4. 조립된 파라미터를 이용해 각 GPU는 자신이 가져온 데이터로 병렬 연산을 수행하여, 해당 layer에서의 독립적인 결과값을 계산한다.
5. 현재 layer의 연산을 수행하는 동시에, 다음 layer의 파라미터 조각들을 백그라운드에서 미리 모으기 시작한다. (이를 **prefetch**라고 함)
6. 현재 layer의 계산이 완료되어 결과값을 다음 layer로 넘겨주는 즉시, 임시로 빌려왔던 다른 GPU의 파라미터 복사본을 메모리에서 즉시 해제하여 버린다.
7. 마지막 layer에 도달할 때까지 위 3~6의 과정을 반복한다.
8. 역전파 시에도 동일하게 파라미터를 Gather & Free 하며 그래디언트를 계산한다.
    <br>
    계산된 각 GPU의 그래디언트들은 **Reduce-Scatter** 통신을 통해 교환 및 합산되며, 최종적으로 합산된 그래디언트를 다시 쪼개어 각 GPU는 자신이 담당하는 파츠의 그래디언트만 챙기고 각자의 가중치를 독립적으로 업데이트한다.

![fig6](Programming/PyTorch/DP_DDP_FSDP-6.png){: style="display:block; margin:0 auto; width:60%;"}

예를 들어 GPU 3개일 때, FSDP에서 한 번의 forward 과정은 아래 그림과 같다.

![fig7](Programming/PyTorch/DP_DDP_FSDP-7.png){: style="display:block; margin:0 auto; width:100%;"}

만약 layer 끝까지 파라미터를 모으기만 하고 해제하지 않는다면, 마지막 layer 도달했을 때는 결국 전체 모델을 VRAM에 다 올려놓은 것과 같아진다.
<br>
따라서 FSDP처럼 다 쓴 layer를 즉시 버리는 방식을 사용하면, VRAM 사용량이 항상 일정하게 낮게 유지된다.

하지만 매 layer마다 모으고 해제하면 그만큼 통신이 자주 발생해 학습 속도가 느려질 수 있다.
<br>
따라서 모으고 해제하는 단위를 적절히 묶어서 정해야 하는데, 이렇게 묶는 것을 **wrap**이라고 한다.

하지만 매 layer마다 끊임없이 파라미터를 모으고 버리는 통신 과정에서 심각한 병목이 발생하므로, 통신 횟수를 줄이기 위해 여러 layer를 묶어서 처리하거나 GPU 간 통신 병목을 견딜 수 있는 초고속 네트워크 환경이 필수적으로 요구된다.

### FSDP의 VRAM 사용량

FSDP는 기본적으로 모델 파라미터 (P), 그래디언트 (G), 옵티마이저 상태 (O)를 sharding한다.
<br>
이들은 모든 GPU가 동일하게 공유해야 하는 자원이기 때문에, 평소에는 쪼개서 보관하다가 필요할 때 All-Gather로 모아서 쓰는 방식이 가능하다.

반면 activation (A)은 sharding하지 않는다.
<br>
각 GPU는 자신에게 할당된 배치로 순전파를 수행하므로, GPU마다 서로 다른 activation을 갖게 된다.
<br>
즉, 각자의 역전파에서만 쓰이는 고유한 데이터이기 때문에 굳이 분산시킬 필요가 없다.

이렇게 FSDP에는 sharding되는 자원과 sharding하지 않는 자원이 함께 존재한다.
<br>
즉, GPU 1장에서 학습 시 48GB가 필요하다고 해서, GPU 4장으로 학습할 때 각 GPU가 정확히 1/4인 12GB를 쓰는 것은 아니다.

예를 들어 GPU 1장에서 48GB를 사용하는 경우, 그 내역이 다음과 같다고 해보자.

- 파라미터 메모리: 12GB (sharding 가능)
- 그래디언트 메모리: 12GB (sharding 가능)
- 옵티마이저 상태 메모리: 12GB (sharding 가능)
- activation 메모리: 12GB (sharding 불가)

이 모델을 GPU 4장에 FSDP로 학습하면 메모리 사용량은 다음과 같이 변한다.

- sharding 대상: 36GB → 9GB (각 GPU)
- sharding 비대상: 12GB (각 GPU에 그대로 존재)

즉, 각 GPU마다 약 21GB의 메모리를 사용하게 된다.
<br>
게다가 All-Gather 시점에는 일시적으로 wrap 단위만큼의 파라미터가 추가로 모이기 때문에, 실제 peak memory는 이보다 더 높을 수 있다.

따라서 GPU 수를 늘릴수록 sharding 대상의 비중은 줄어들지만 activation이 차지하는 비중은 그대로 유지되므로, 일정 규모 이상부터는 `fsdp_activation_checkpointing` 같은 옵션을 함께 사용해 activation 메모리까지 줄여야 효율적인 학습이 가능하다.

![fig8](Programming/PyTorch/DP_DDP_FSDP-8.png){: style="display:block; margin:0 auto; width:80%;"}
