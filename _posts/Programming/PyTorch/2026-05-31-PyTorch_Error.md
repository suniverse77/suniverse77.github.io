---
title: "[파이토치] 파이토치에서 자주 발생하는 런타임 에러"
date: 2026-05-31 00:00:00 +/-TTTT
categories: [Programming, 파이토치]
tags: [파이토치]
math: true
toc: true
author: sunho
---

## 에러 종류

컴퓨터가 코드를 읽고 실행하는 과정에 따라 에러를 크게 3가지로 나눌 수 있다.

1. **런타임 에러 (Runtime Error)**

    프로그램의 문법에는 문제가 없어서 <span style="background-color:#fff5b1">실행은 시작되었지만, 작동 도중에 예상치 못한 문제에 부딪혀 강제 종료되는 에러</span>이다.
    <br>
    주로 개발자가 미처 생각하지 못한 예외 상황이 발생했을 때 일어난다.

    대표적인 예시로 **메모리 부족 (OOM)**, **0으로 나누기 (ZeroDivisionError)**, **인덱스 초과 (IndexError)**, **파일 찾기 실패 (FileNotFoundError)** 등이 있다.

2. **구문 에러 (Syntax Error)**

    <span style="background-color:#fff5b1">프로그래밍 문법을 틀려서 프로그램이 아예 실행조차 되지 않는 에러</span>이다.

    대표적인 예시로 괄호나 따옴표를 열고 닫지 않기, 명령어 오타 등이 있다.

3. **논리 에러 (Logical Error)**

    에러 메시지도 뜨지 않고 프로그램도 끝까지 정상적으로 돌아가지만, 최종 결과값이 내가 의도한 것과 전혀 다르게 나오는 상황이다.
    <br>
    더해야 하는데 `-` 기호를 쓴 경우 등 개발자가 생각한 알고리즘이 틀렸을 때 발생한다.

    컴퓨터 입장에서는 에러가 아니기 때문에, 알려주지 않는다.

## PyTorch Runtime Error

파이토치에서 자주 발생하는 몇 가지 런타임 에러에 대해서 알아보자.

### CUDA Out of Memory 에러

작업 중인 프로세스가 GPU의 VRAM보다 더 많은 용량을 요구해서 프로그램이 강제 종료된 상황이다.

```bash
torch.OutOfMemoryError: CUDA out of memory. Tried to allocate 64.00 GiB. GPU 0 has a total capacity of 94.97 GiB of which 13.49 GiB is free. Including non-PyTorch memory, this process has 81.47 GiB memory in use
```

위 로그는 GPU에 이미 81GB가량의 데이터가 차 있어서 남은 공간이 약 13GB뿐인데, 64GB라는 데이터를 추가로 넣으려고 시도하다가 용량 초과로 에러가 발생했다는 뜻이다.

로그를 자세히 분석하면 아래와 같다.

- **`torch.OutOfMemoryError: CUDA out of memory.`**

    GPU 메모리가 꽉 차서 더 이상 데이터를 올릴 공간이 없다는 뜻이다.

- **`Tried to allocate 64.00 GiB.`**

    PyTorch가 현재 연산을 수행하기 위해 한 번에 64.00 GiB의 메모리를 추가로 할당하려고 시도했다는 뜻이다.

- **`GPU 0 has a total capacity of 94.97 GiB`**

    사용 중인 0번 GPU의 전체 VRAM 용량은 약 95GB라는 뜻이다.

- **`of which 13.49 GiB is free.`**

    전체 95GB 중에서 현재 사용 가능한 여유 공간은 13.49GB뿐이라는 뜻이다.

- **`Including non-PyTorch memory, this process has 81.47 GiB memory in use`**

    이미 다른 데이터나 캐시, 모델의 가중치 등으로 인해 81.47GB의 메모리가 사용 중이라는 뜻이다.
