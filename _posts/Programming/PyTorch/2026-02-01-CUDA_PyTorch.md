---
title: "[PyTorch] GPU, CUDA, PyTorch 버전 관계"
date: 2026-02-01 00:00:00 +/-TTTT
categories: [Programming, 파이토치 (PyTorch)]
tags: [PyTorch]
math: true
toc: true
author: sunho
---

PyTorch에서 GPU를 사용하려면 단순히 NVIDIA GPU가 있다고 끝나는 것이 아니다.
<br>
GPU를 사용하려면 NVIDIA Driver, PyTorch의 CUDA Runtime, PyTorch 버전, Python 버전, GPU 아키텍처가 서로 호환되어야 한다.

- **NVIDIA Driver가 PyTorch의 CUDA Runtime을 지원**해야 한다.
- 현재 **Python 버전에 맞는 PyTorch wheel이 설치**되어야 한다.
- **PyTorch 버전이 현재 GPU의 Compute Capability를 지원**해야 한다.

일반적으로 이미 GPU와 NVIDIA Driver가 이미 설치된 서버 환경이라면, PyTorch를 설치할 때는 다음 순서로 호환성을 확인하면 된다.

1. `nvidia-smi`로 현재 NVIDIA Driver가 지원하는 CUDA 버전을 확인한다.
2. NVIDIA Driver가 설치하려는 PyTorch의 CUDA Runtime 버전을 지원하는지 확인한다.
3. 설치하려는 PyTorch 버전이 현재 환경의 Python 버전을 지원하는지 확인한다. (지원을 안한다면 Python 버전을 변경하거나 PyTorch 버전을 변경)
4. PyTorch 설치 후 GPU 관련 오류가 발생한다면, 현재 GPU의 Compute Capability를 해당 PyTorch 버전이 지원하는지도 확인한다.

## NVIDIA Driver

그래픽카드가 물리적인 하드웨어라면, NVIDIA Driver는 운영체제가 GPU를 사용할 수 있게 해주는 소프트웨어이다.
<br>
즉, <span style="background-color:#fff5b1">NVIDIA Driver는 운영체제가 GPU와 통신할 수 있게 해주는 프로그램</span>이다.

따라서 컴퓨터에 NVIDIA GPU가 장착되어 있어도, NVIDIA Driver가 제대로 설치되어 있지 않으면 PyTorch에서 GPU를 사용할 수 없다.

NVIDIA Driver가 정상적으로 설치되어 있는지는 보통 `nvidia-smi` 명령어로 확인한다.

`nvidia-smi`를 실행하면 다음과 같은 정보가 보일 수 있다.

```bash
CUDA Version: 12.4
```

여기서 보이는 CUDA Version은 현재 NVIDIA Driver가 CUDA 12.4까지 지원할 수 있다고 이해하면 된다.

예를 들어 <span style="background-color:#fff5b1">PyTorch가 CUDA 12.1 Runtime으로 만들어진 버전이라면, NVIDIA Driver는 CUDA 12.1을 실행할 수 있을 만큼 충분히 최신이어야 한다.</span>

## PyTorch의 CUDA Runtime

CUDA Runtime이란, 쉽게 말해 PyTorch가 GPU 연산을 실행할 때 내부적으로 사용하는 CUDA 실행 환경을 의미한다.
<br>
PyTorch는 만들어질 때 특정 CUDA Runtime과 함께 빌드되므로, 사용자가 CUDA Runtime을 직접 따로 준비하지 않아도 된다.

[PyTorch 공식 홈페이지](https://pytorch.org/get-started/previous-versions/)에 접속하면 아래와 같은 설치 명령어들을 확인할 수 있다.

```bash
# CUDA 12.6
pip install torch==2.11.0 torchvision==0.26.0 torchaudio==2.11.0 --index-url https://download.pytorch.org/whl/cu126
# CUDA 12.8
pip install torch==2.11.0 torchvision==0.26.0 torchaudio==2.11.0 --index-url https://download.pytorch.org/whl/cu128
# CUDA 13.0
pip install torch==2.11.0 torchvision==0.26.0 torchaudio==2.11.0 --index-url https://download.pytorch.org/whl/cu130
```

여기서 `--index-url` 끝의 `cu126`은 해당 PyTorch가 CUDA 12.6 Runtime과 함께 빌드되었다는 의미이다.
<br>
같은 PyTorch 버전이라도, 여러 개의 CUDA Runtime이 존재하는 것을 확인할 수 있다.

PyTorch가 이미 설치되어 있는 경우, 터미널에서 아래 명령어를 실행해 설치된 PyTorch가 어떤 CUDA Runtime을 사용하는지 확인할 수 있다.

```bash
python -c "import torch; print(torch.__version__); print(torch.version.cuda)"
```

예를 들어 출력이 다음과 같다면, PyTorch 버전은 2.5.1이고, CUDA Runtime은 12.1을 사용한다는 뜻이다.

```bash
2.5.1+cu121
12.1
```

### PyTorch wheel

Wheel은 Python 패키지를 설치하기 쉽게 미리 만들어 놓은 설치 파일로, `.whl` 확장자를 사용한다.

예를 들어 아래 명령어로 PyTorch를 설치한다고 하자.

```bash
pip install torch==2.11.0 torchvision==0.26.0 torchaudio==2.11.0 --index-url https://download.pytorch.org/whl/cu126
```

여기서 `--index-url`은 `pip`에게 패키지를 어디에서 찾을지 알려주는 옵션이다.
<br>
즉, 위 명령어는 PyTorch의 `cu126` 저장소에서 `torch`, `torchvision`, `torchaudio` 패키지를 찾아 설치하라는 의미이다.

여기서 `cu126`은 CUDA 12.6 Runtime을 포함한 PyTorch wheel을 사용하겠다는 뜻이다.

실제로 `https://download.pytorch.org/whl/cu126` 저장소에 접속해 `torch` 목록으로 들어가면, 아래와 같은 wheel 파일들을 확인할 수 있다.
<br>
여기서 `cp310`은 Python 3.10 버전, `win_amd64`는 운영체제를 의미한다.

```
torch-2.8.0+cu126-cp39-cp39-manylinux_2_28_x86_64.whl
torch-2.8.0+cu126-cp39-cp39-win_amd64.whl
torch-2.9.0+cu126-cp310-cp310-manylinux_2_28_aarch64.whl
torch-2.9.0+cu126-cp310-cp310-manylinux_2_28_x86_64.whl
torch-2.9.0+cu126-cp310-cp310-win_amd64.whl
```

이름을 하나씩 나누어 보면 다음과 같다.

| 구분 | 의미 |
| :---: | :---: |
| `torch` | 패키지 이름 |
| `2.11.0+cu126` | PyTorch 2.11.0 버전 & CUDA 12.6 Runtime을 포함한 빌드 |
| `cp310` | CPython 3.10용 |
| `manylinux_2_28_x86_64` | Linux x86_64 환경용 |

`pip`가 현재 활성화된 Python 환경의 버전과 운영체제, CPU 아키텍처를 확인한 뒤, 그에 맞는 wheel을 자동으로 선택해 설치하기 때문에, 우리는 `pip install` 명령어에서 복잡하게 `.whl` 파일을 직접 지정하지 않아도 된다.

하지만 만약 현재 환경이 Python이 3.13이고 설치하려는 PyTorch 버전이 Python 3.13용 wheel을 제공하지 않는다면, `pip`은 보통 설치하지 못하고 오류를 발생시킨다.

## Python 버전

PyTorch는 Python 패키지이기 때문에, 현재 사용 중인 Python 버전과도 호환되어야 한다.

PyTorch를 설치할 때 실제로는 Python 버전에 맞게 미리 빌드된 설치 파일을 내려받아 설치한다.
<br>
이때 사용하는 설치 파일을 wheel이라고 부른다.

예를 들어 Python 3.8 환경에서는 Python 3.10용으로 만들어진 PyTorch wheel을 설치할 수 없다.
<br>
반대로 최신 PyTorch 버전이 더 이상 오래된 Python 버전을 지원하지 않는 경우도 있다.

따라서 PyTorch를 설치하기 전에, 터미널에서 `python --version` 명령어를 사용해서 현재 Python 버전을 확인하는 것이 좋다.

## PyTorch 버전

[PyTorch 공식 홈페이지](https://pytorch.org/get-started/previous-versions/)를 보면, 같은 CUDA Runtime을 사용하더라도 PyTorch 버전이 다른 경우를 확인할 수 있다.

CUDA Rutime이 NVIDIA Driver와의 호환성에 영향을 준다면, PyTorch 버전은 무슨 영향을 줄까?

먼저 기능적인 측면에서 PyTorch 버전에 따라 사용할 수 있는 함수가 달라질 수 있다.
<br>
새로운 버전에서 함수나 기능이 추가되기도 하고 제거될 수도 있다.

또한 같은 모델을 실행하더라도 PyTorch 버전에 따라 내부 연산 최적화가 달라질 수 있다.
<br>
따라서 최신 버전에서 더 빠르게 동작하거나, 특정 연산의 성능이 개선되는 경우도 있다.

하지만 GPU 실행과 직접적으로 관련해서 중요한 부분은 <span style="background-color:#fff5b1">해당 PyTorch 버전이 현재 GPU 아키텍처를 지원하는지</span>이다.

예를 들어 다음과 같은 문제가 발생할 수 있다.

- **최신 GPU + 오래된 PyTorch:** 최신 GPU를 사용하는데 PyTorch 버전이 너무 오래되면, PyTorch가 해당 GPU를 모를 수 있다.
- **오래된 GPU + 최신 PyTorch:** 최신 PyTorch에서는 아주 오래된 GPU에 대한 지원이 빠져 있을 수 있다.

따라서 PyTorch에서 GPU 관련 오류가 발생했을 때는 CUDA Runtime과 NVIDIA Driver의 호환성뿐만 아니라, 현재 PyTorch 버전이 내 GPU를 지원하는지도 함께 확인해야 한다.

### GPU Compute Capability

NVIDIA GPU는 세대마다 서로 다른 아키텍처를 가진다.

예를 들어 RTX 30 시리즈는 Ampere 아키텍처를 사용하고, 이 중 일부 GPU는 `sm_86`이라는 값을 가진다.
<br>
여기서 `sm_86`은 Compute Capability 8.6을 의미한다.

Compute Capability는 쉽게 말해, 해당 GPU가 어떤 연산 기능을 지원하는지 나타내는 번호이다.
<br>
즉, GPU의 세대와 기능을 구분하기 위한 값이라고 보면 된다.

PyTorch가 특정 GPU를 사용하려면, PyTorch가 해당 GPU의 Compute Capability를 지원해야 한다.

예를 들어 어떤 GPU가 `sm_86`을 사용하는데, PyTorch가 `sm_86`을 지원하지 않는다면 GPU를 제대로 사용할 수 없다.
