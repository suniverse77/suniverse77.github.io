---
title: "[PyTorch] GPU, CUDA, PyTorch 버전 관계"
date: 2026-02-01 00:00:00 +/-TTTT
categories: [Programming, 파이토치 (PyTorch)]
tags: [PyTorch]
math: true
toc: true
author: sunho
---

PyTorch에서 GPU를 사용하려면 단순히 NVIDIA GPU가 있다고 끝나는 것이 아니라, 아래의 조건이 만족되어야 한다.

- NVIDIA Driver가 PyTorch의 CUDA Runtime을 지원해야 한다.
- 현재 Python 버전에 맞는 PyTorch wheel이 설치되어 있어야 한다.
- PyTorch가 설치된 GPU의 Compute Capability를 지원해야 한다.

즉, NVIDIA Driver, CUDA Runtime, PyTorch 버전, Python 버전, GPU 아키텍처가 서로 호환되어야 한다.

일반적으로 이미 GPU와 NVIDIA Driver가 이미 설치된 서버 환경이라면, PyTorch를 설치할 때는 다음 순서로 호환성을 확인하면 된다.

1. 현재 NVIDIA Driver가 설치하려는 PyTorch의 CUDA Runtime 버전을 지원하는지 확인한다.
2. 설치하려는 PyTorch wheel이 현재 Python 버전을 지원하는지 확인한다.
2. PyTorch 설치 후 GPU 관련 오류가 발생한다면, 현재 GPU의 Compute Capability를 해당 PyTorch 버전이 지원하는지도 확인한다.

## NVIDIA Driver와 PyTorch의 CUDA Runtime

### NVIDIA Driver

그래픽카드가 물리적인 하드웨어라면, NVIDIA Driver는 운영체제가 GPU를 사용할 수 있게 해주는 소프트웨어이다.
<br>
즉, NVIDIA Driver는 운영체제가 GPU와 통신할 수 있게 해주는 프로그램이다.

따라서 컴퓨터에 NVIDIA GPU가 장착되어 있어도, NVIDIA Driver가 제대로 설치되어 있지 않으면 PyTorch에서 GPU를 사용할 수 없다.

NVIDIA Driver가 정상적으로 설치되어 있는지는 보통 `nvidia-smi` 명령어로 확인한다.

`nvidia-smi`를 실행하면 다음과 같은 정보가 보일 수 있다.

```bash
CUDA Version: 12.4
```

여기서 보이는 CUDA Version은 현재 NVIDIA Driver가 CUDA 12.4까지 지원할 수 있다고 이해하면 된다.

예를 들어 PyTorch가 CUDA 12.1 Runtime으로 만들어진 버전이라면, NVIDIA Driver는 CUDA 12.1을 실행할 수 있을 만큼 충분히 최신이어야 한다.

### PyTorch의 CUDA Runtime

PyTorch는 설치할 때 특정 CUDA Runtime과 함께 빌드된 wheel을 설치한다.

CUDA Runtime은 쉽게 말해, <span style="background-color:#fff5b1">PyTorch가 GPU 연산을 실행할 때 내부적으로 사용하는 CUDA 실행 환경</span>이다.

예를 들어 다음과 같은 설치 명령어가 있다고 하자.

```bash
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu126
```

여기서 `cu126`은 해당 PyTorch가 CUDA 12.6 Runtime과 함께 빌드되었다는 의미이다.

터미널에서 아래 명령어를 실행해, 설치된 PyTorch가 어떤 CUDA Runtime을 사용하는지 확인할 수 있다.

```bash
python -c "import torch; print(torch.__version__); print(torch.version.cuda)"
```

예를 들어 출력이 다음과 같다면, PyTorch 버전은 2.5.1이고, CUDA Runtime은 12.1을 사용한다는 뜻이다.

```bash
2.5.1+cu121
12.1
```

## Python 버전

PyTorch는 Python 패키지이기 때문에, 현재 사용 중인 Python 버전과도 호환되어야 한다.

PyTorch를 설치할 때 실제로는 Python 버전에 맞게 미리 빌드된 설치 파일을 내려받아 설치한다.
<br>
이때 사용하는 설치 파일을 wheel이라고 부른다.

예를 들어 Python 3.8 환경에서는 Python 3.10용으로 만들어진 PyTorch wheel을 설치할 수 없다.
<br>
반대로 최신 PyTorch 버전이 더 이상 오래된 Python 버전을 지원하지 않는 경우도 있다.

따라서 PyTorch를 설치하기 전에, 터미널에서 `python --version` 명령어를 사용해서 현재 Python 버전을 확인하는 것이 좋다.

## GPU Compute Capability

NVIDIA GPU는 세대마다 서로 다른 아키텍처를 가진다.

예를 들어 RTX 30 시리즈는 Ampere 아키텍처를 사용하고, 이 중 일부 GPU는 `sm_86`이라는 값을 가진다.
<br>
여기서 `sm_86`은 Compute Capability 8.6을 의미한다.

Compute Capability는 쉽게 말해, 해당 GPU가 어떤 연산 기능을 지원하는지 나타내는 번호이다.
<br>
즉, GPU의 세대와 기능을 구분하기 위한 값이라고 보면 된다.

PyTorch가 특정 GPU를 사용하려면, PyTorch가 해당 GPU의 Compute Capability를 지원해야 한다.
예를 들어 어떤 GPU가 `sm_86`을 사용하는데, PyTorch가 `sm_86`을 지원하지 않는다면 GPU를 제대로 사용할 수 없다.

- **최신 GPU + 오래된 PyTorch:** 최신 GPU를 사용하는데 PyTorch 버전이 너무 오래되면, PyTorch가 해당 GPU를 모를 수 있다.
- **오래된 GPU + 최신 PyTorch:** 최신 PyTorch에서는 아주 오래된 GPU에 대한 지원이 빠져 있을 수 있다.

따라서 GPU 관련 오류가 발생했을 때는 CUDA 버전만 확인하면 안 되며, 현재 설치된 PyTorch가 내 GPU의 Compute Capability를 지원하는지도 함께 확인해야 한다.
