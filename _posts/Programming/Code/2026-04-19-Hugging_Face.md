---
title: "[개발 환경] 허깅 페이스 (Hugging Face)"
date: 2026-04-19 00:00:00 +/-TTTT
categories: [Programming, 개발 환경]
tags: [개발 환경]
math: true
toc: true
author: sunho
---

[Hugging Face](https://huggingface.co/)는 전 세계 사람들이 모델과 데이터셋을 올리고 내려받는 일종의 Hub다.
<br>
내가 만든 모델을 공유할 수도 있고, 다른 사람이 학습해둔 모델을 가져다 바로 쓸 수도 있다.

Hugging Face는 이 Hub뿐 아니라 모델을 다루는 데 필요한 여러 라이브러리도 함께 만들어 제공한다.
<br>
[공식 문서](https://huggingface.co/docs)에 접속하면 그 목록을 한눈에 확인할 수 있다.

그중 자주 사용되는 라이브러리는 다음과 같다.

- `transformers`: 모델을 정의하고, 추론 및 학습을 가능하게 함
- `datasets`: 데이터셋 로딩 및 전처리
- `tokenizers`: LLM 토크나이저
- `huggingface_hub`: Hub에서 모델과 데이터를 다운로드 및 업로드
- `accelerate`: 분산 학습
- `diffusers`: 이미지 생성 모델
- `peft`: LoRA 등의 PEFT 기법
- `safetensors`: 모델 가중치 저장 포맷

## `transformers` 라이브러리

```python
from transformers import pipeline

# task만 정하면 적당한 기본 모델을 알아서 받아옵니다
classifier = pipeline("sentiment-analysis")

result = classifier("I love using Hugging Face!")
print(result)
# [{'label': 'POSITIVE', 'score': 0.9998}]
```