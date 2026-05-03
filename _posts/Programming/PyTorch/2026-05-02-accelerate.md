---
title: "[Hugging Face] accelerate 라이브러리"
date: 2026-05-02 00:00:00 +/-TTTT
categories: [Programming, 파이토치]
tags: [Hugging Face, GPU 분산 학습]
math: true
toc: true
author: sunho
---

`accelerate`는 Hugging Face에서 개발한 파이썬 라이브러리 중 하나로, 복잡한 분산 학습 코드를 단 몇 줄로 줄여주는 역할을 한다.

코드 상단에서 `Accelerator` 객체를 하나 만들고 내 모델과 데이터 로더를 `prepare()`라는 함수에 통과시키기만 하면, 코드가 실행되는 환경 (Single-GPU, Multi-GPU 등)을 자동으로 감지하여 알맞게 세팅하고, 현재 프로세스가 할당받은 장치 (GPU 또는 CPU)를 스스로 파악하여 텐서들을 자동으로 메모리에 올려준다.
<br>
이 덕분에 하나의 파이썬 스크립트로 내 컴퓨터, 대형 서버 어디서든 코드 수정 없이 학습을 돌릴 수 있다.

### accelerate 적용

먼저 터미널에서 `pip install accelerate`를 실행해서, `accelerate` 라이브러리를 설치해야 한다.

```python
import torch
import torch.nn as nn
from torch.utils.data import DataLoader, Dataset
# accelerate 라이브러리에서 Accelerator 클래스 import
from accelerate import Accelerator

class Model(nn.Module):
    def __init__(self):
        super().__init__()
        self.fc = nn.Linear(10, 2)
    def forward(self, x):
        return self.fc(x)

# ---------------------------------------------------------
# Step 1: Accelerator 초기화
# ---------------------------------------------------------
# 이 한 줄이 dist.init_process_group 등을 모두 대신함
accelerator = Accelerator()

# model.to(device) 사용할 필요 X
model = Model()
optimizer = torch.optim.SGD(model.parameters(), lr=0.01)
criterion = nn.MSELoss()

dataset = MyDataset()
# shuffle=True로 두면 알아서 분산시켜 줌
train_loader = DataLoader(dataset, batch_size=32, shuffle=True)

# ---------------------------------------------------------
# Step 2: 내가 만든 객체들을 prepare 함수에 통과
# ---------------------------------------------------------
# 현재 환경 (DDP, FSDP 등)에 맞게 알아서 모델을 wrapping하고 로더 세팅
model, optimizer, train_loader = accelerator.prepare(
    model, optimizer, train_loader
)

num_epochs = 5

# ---------------------------------------------------------
# Step 3: 훈련 loop
# ---------------------------------------------------------
for epoch in range(num_epochs):
    model.train()
    
    for x, y in train_loader:
        # x, y = x.to(device), y.to(device) 사용할 필요 X
        
        optimizer.zero_grad()
        y_pred = model(x)
        loss = criterion(y_pred, y)
        
        # loss.backward() 대신 accelerator.backward() 사용
        accelerator.backward(loss)
        
        optimizer.step()
```

### accelerate 설정 및 실행

터미널에서 `accelerate config` 명령어를 실행하면 머신 대수, GPU 개수, 분산 학습 방식 등을 묻는 프롬프트가 나타난다. 이때 사용자가 선택한 답변들은 `~/.cache/huggingface/accelerate/default_config.yaml` 파일로 시스템에 저장된다.

설정을 마치고 `accelerate launch script.py`를 실행하면, 앞서 저장한 설정 파일을 읽어와 내부적으로 환경 변수를 자동 세팅한다.

이후 파이썬 코드 내에서 `Accelerator()` 객체가 생성될 때 이 환경 변수들을 읽어오며, `prepare()` 함수가 호출되면 해당 설정 정보를 바탕으로 모델과 학습 환경을 알맞게 구성해 준다.

#### accelerate config 질문

- 현재 어느 컴퓨팅 환경에서 실행하는지 묻는 질문

    일반적으로 직접 GPU 서버에서 돌린다면 `This machine`을 선택하면 된다.

    ```bash
    In which compute environment are you running?
    Please select a choice using the arrow or number keys, and selecting with enter`
    ➔  This machine
        AWS (Amazon SageMaker)
    ```

- 분산 학습 방식을 선택하는 질문

    ```bash
    Please select a choice using the arrow or number keys, and selecting with enter                                                              
    ➔  No distributed training     # GPU 1개로만 학습할 때
        multi-CPU                   # CPU 여러 개를 사용할 때 (GPU 없이)
        multi-XPU                   # Intel GPU (XPU) 여러 개를 사용할 때
        multi-GPU                   # GPU 여러 개를 사용할 때 (가장 일반적인 선택)
        multi-NPU                   # Huawei NPU 여러 개를 사용할 때
        TPU                         # Google TPU를 사용할 때
    ```

<details>
<summary><font color='#0000FF'>No distributed training 선택한 경우</font></summary>
<div markdown="1">

- GPU가 있어도 CPU로만 학습할 것인지 묻는 질문

    거의 항상 `NO`를 선택하면 된다.

    ```bash
    Do you want to run your training on CPU only (even if a GPU / Apple Silicon / Ascend NPU device is available)? [yes/NO]
    ```

- `torch dynamo`로 학습 스크립트를 최적화할 것인지 묻는 질문

    처음 세팅하거나 안정성을 원한다면 `NO`를 권장한다. (`yes`는 속도 향상을 기대할 수 있지만 호환성 문제가 생길 수도 있음)

    ```bash
    Do you wish to optimize your script with torch dynamo?[yes/NO]:
    ```

- DeepSpeed를 사용할 것인지 묻는 질문

    메모리 부족 문제가 없다면 `NO`를 권장한다. (모델이 매우 커서 단일 GPU에 올라가지 않을 때 사용)

    ```bash
    Do you want to use DeepSpeed? [yes/NO]:
    ```

- 학습에 사용할 GPU를 ID로 지정하는 질문

    - `all` (기본값, 엔터만 누르면 됨): 서버에 있는 모든 GPU를 사용
    - `0` : GPU 0번 하나만 사용
    - `0,1,2,3` : GPU 0~3번 사용

    ```bash
    What GPU(s) (by id) should be used for training on this machine as a comma-seperated list? [all]:
    ```

- 혼합 정밀도(mixed precision) 학습 방식을 선택하는 질문

    ```bash
    Do you wish to use FP16 or BF16 (mixed precision)?                                                       
    Please select a choice using the arrow or number keys, and selecting with enter
    ➔  no
        fp16
        bf16
        fp8
    ```

---

</div>
</details>
<br>

<details>
<summary><font color='#0000FF'>multi-GPU 선택한 경우</font></summary>
<div markdown="1">

일반적으로 `multi-GPU`를 선택하고, `DeepSpeed`, `Megatron-LM`, `FSDP`를 모두 `NO`로 설정하면 자동으로 DDP로 동작한다.

- 몇 개의 머신을 사용할지 묻는 질문

    일반적으로 서버 한 대에서 GPU 여러 장을 쓰는 경우라면 그냥 엔터를 눌러 1을 선택하면 된다.

    ```bash
    How many different machines will you use (use more than 1 for multi-node training)? [1]:
    ```

- 분산 학습 중 오류를 실시간으로 체크할지 묻는 질문

    `NO`는 오류 체크를 하지 않아 속도가 빠르며, 안정적인 환경에서 권장한다.
    <br>
    `yes`는 매 분산 연산마다 오류를 체크해서 속도가 느려지지만, 디버깅할 때 유용하다.

    ```bash
    Should distributed operations be checked while running for errors? This can avoid timeout issues but will be slower. [yes/NO]:
    ```

- `torch dynamo`로 학습 스크립트를 최적화할 것인지 묻는 질문

    처음 세팅하거나 안정성을 원한다면 `NO`를 권장한다. (`yes`는 속도 향상을 기대할 수 있지만 호환성 문제가 생길 수도 있음)

    ```bash
    Do you wish to optimize your script with torch dynamo?[yes/NO]:
    ```

- DeepSpeed를 사용할 것인지 묻는 질문

    메모리 부족 문제가 없다면 `NO`를 권장한다. (모델이 매우 커서 단일 GPU에 올라가지 않을 때 사용)

    ```bash
    Do you want to use DeepSpeed? [yes/NO]:
    ```

- FSDP를 사용할 것인지 묻는 질문

    ```bash
    Do you want to use FullyShardedDataParallel? [yes/NO]:
    ```

- Megatron-LM을 사용할지 묻는 질문

    ```bash
    Do you want to use Megatron-LM ? [yes/NO]:
    ```

- 분산 학습에 사용할 GPU 수를 입력하는 질문

    ```bash
    How many GPU(s) should be used for distributed training? [1]:
    ```

- 학습에 사용할 GPU를 ID로 지정하는 질문

    - `all` (기본값, 엔터만 누르면 됨): 서버에 있는 모든 GPU를 사용
    - `0` : GPU 0번 하나만 사용
    - `0,1,2,3` : GPU 0~3번 사용

    ```bash
    What GPU(s) (by id) should be used for training on this machine as a comma-seperated list? [all]:
    ```

- 혼합 정밀도(mixed precision) 학습 방식을 선택하는 질문

    ```bash
    Do you wish to use FP16 or BF16 (mixed precision)?                                                       
    Please select a choice using the arrow or number keys, and selecting with enter
    ➔  no
        fp16
        bf16
        fp8
    ```

---

</div>
</details>
<br>
