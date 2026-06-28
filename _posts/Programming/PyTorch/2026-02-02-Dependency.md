---
title: "[PyTorch] 의존성 충돌"
date: 2026-02-02 00:00:00 +/-TTTT
categories: [Programming, 파이토치 (PyTorch)]
tags: [PyTorch]
math: true
toc: true
author: sunho
---

의존성(Dependency) 충돌은 라이브러리들끼리 필요한 버전이 서로 맞지 않아서 생기는 문제다.
<br>
개발 환경을 맞추다 보면 자주 겪게 되고, 해결하기도 꽤 까다롭다.

충돌을 최대한 줄일 수 있는 가장 확실한 순서는 다음과 같다.

1. `torch`와 `CUDA` 버전 확정

2. `torch`에 묶이는 라이브러리 설치

    - `torchvision` / `torchaudio`
    - `flash-attn`
    - `xformers`

3. `transformers`, `numpy` 등의 상위 라이브러리 설치

### 의존성 충돌 발생 원인

하지만 위의 순서를 지켜도, 다음의 이유로 충돌이 발생할 수 있다.

- **3단계에서 설치한 상위 라이브러리가 `torch`를 끌어내리는 경우 (가장 흔함)**

    마지막에 설치하는 `vllm` 등과 같은 라이브러리가 자기 의존성에 `torch==특정버전`을 박아두면, 1단계에서 맞춘 `torch`를 `pip`이 조용히 제거하고 다른 버전으로 바꿔버린다.
    <br>
    그러면 2단계에서 설치한 `torchvision`, `xformers` 등이 전부 어긋나게 된다.

- **transformers가 huggingface_hub / tokenizers를 끌어올리는 경우**

    3단계에서 `transformers`를 깔 때 같이 따라오는 `huggingface_hub`나 `tokenizers`가, `diffusers`와 같은 이미 설치된 다른 라이브러리가 요구하는 범위를 벗어나면 충돌하게 된다.
    <br>
    `torch`와 무관한 라인에서 터지는 충돌이다.

- **`flash-attn`, `xformers`의 wheel이 애초에 안 맞는 경우**

    2단계에서 `torch` 버전은 맞아도 CUDA 빌드 태그(`cu121` vs `cu124`)나 Python 버전 등이 어긋나면 import 시점에 에러가 발생하게 된다.
    <br>
    순서와 무관하게 정확한 wheel 조합의 문제다.

- **`numpy`와 같은 바닥 의존성이 막판에 바뀌는 경우**

    3단계에서 어떤 라이브러리가 예를 들어 `numpy`를 `2.x`로 올리면, 이미 깔린 `torch`나 다른 패키지가 런타임에 깨질 수 있다.
    <br>
    설치는 성공해도 실행할 때 터지는 유형이라 더 까다롭다.

### 안전 장치

`torch`를 보호하기. 상위 라이브러리가 `torch`를 못 건드리게 막는 방법이 있다.

```bash
# 이미 깐 torch를 건드리지 않도록 방지
pip install transformers vllm --no-deps

# 의존성을 무시하지 않되, 재설치 및 업그레이드만 막기
pip install transformers --upgrade-strategy only-if-needed
```

하지만 `--no-deps`는 의존성을 아예 안 깔아서 위험하니, 그 라이브러리가 뭘 요구하는지 아는 상태에서만 쓰는 게 좋다.

또는 `pip`는 한 명령 안에서 여러 패키지를 받으면 버전을 함께 고려해 풀기 때문에, 패키지를 따로따로 까는 것보다 `requirements` 파일에 다 적어 한 번에 까는 게 충돌을 줄이는 방법이다.

설치가 끝나면 `pip check` 명령어를 통해 충돌 여부를 검사해야 한다.
