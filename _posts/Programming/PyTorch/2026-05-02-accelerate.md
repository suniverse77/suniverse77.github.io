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

## 학습 코드에 accelerate 적용

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

## accelerate 설정 및 실행

`accelerate`는 아래 명령어로 실행할 수 있다.

```bash
accelerate launch train.py
```

이때 분산 학습에 필요한 설정 파일이 함께 전달되어야 하는데, 이 설정 파일을 만드는 방법은 크게 2가지가 있다.

### 1. accelerate config 명령어 사용

터미널에서 `accelerate config` 명령어를 실행하면 머신 대수, GPU 개수, 분산 학습 방식 등을 묻는 프롬프트가 차례로 나타난다.
<br>
질문에 모두 답하고 나면, 응답한 내용이 `~/.cache/huggingface/accelerate/default_config.yaml` 경로에 자동으로 저장된다.
<br>
이후 별도의 인자 없이 `accelerate launch train.py`만 실행해도, 앞서 저장된 기본 설정 파일을 자동으로 읽어와 분산 학습 환경 변수를 세팅해준다.

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

### 2. config.yaml 파일을 직접 작성

원하는 위치에 `yaml` 파일을 직접 만든 뒤, 실행할 때 `--config_file` 인자로 경로를 명시적으로 넘겨주는 방법이다.

```bash
accelerate launch --config_file ./config.yaml train.py
```

`accelerate` 설정 파일에서 사용 가능한 주요 키는 다음과 같다.

| Key |	Value / Type | 설명 |
| :---: | :---: | :---: |
| `compute_environment` | `LOCAL_MACHINE` / `AMAZON_SAGEMAKER` | 실행 환경 |
| `distributed_type` | `NO` / `MULTI_GPU` / `MULTI_CPU` / `FSDP` / <br> `DEEPSPEED` / `MEGATRON_LM` / `XLA` / `TPU` |  분산 학습 방식 |
| `mixed_precision` | `no` / `fp16` / `bf16` / `fp8` | 혼합정밀도 |
| `num_machines` | `int` | 머신 대수 |
| `num_processes` | `int` | 전체 프로세스 수 (보통 GPU 총 개수) |
| `gpu_ids` | `str` | 사용할 GPU 지정 (예: `all` 또는 `0,1,3` 등) |
| `machine_rank` | `int` | 멀티노드일 때 현재 머신의 rank (0부터) |
| `main_process_ip` | `str`	| 멀티노드 마스터 노드 IP |
| `main_process_port` | `int` | 마스터 노드 포트 |

- `mixed_precision`를 `NO`로 설정하면, 혼합 정밀도를 사용하지 않고 전부 `fp32`로 사용해서 학습한다.
- 이때 `distributed_type`에서 선택한 값에 따라, 해당 방식에 맞는 설정 블록 (`fsdp_config`, `deepspeed_config` 등)을 추가적으로 작성해줘야 한다.
    
    ```yaml
    compute_environment: LOCAL_MACHINE
    distributed_type: FSDP
    fsdp_config:
        # fsdp 설정 값...
    ```

#### FSDP 설정 (`fsdp_config`)

| Key |	Value / Type | 설명 |
| :---: | :---: | :---: |
| `fsdp_sharding_strategy` | `FULL_SHARD` / `SHARD_GRAD_OP` / `NO_SHARD` / <br> `HYBRID_SHARD` / `HYBRID_SHARD_ZERO2` | 샤딩 전략 |
| `fsdp_auto_wrap_policy` | `TRANSFORMER_BASED_WRAP` / `SIZE_BASED_WRAP` / `NO_WRAP` | 자동 wrap 정책 |
| `fsdp_transformer_layer_cls_to_wrap` | `str` (공백 없이 콤마 구분) | wrap할 레이어 클래스명 (예: `BasicTransformerBlock,ResnetBlock2D`) |
| `fsdp_backward_prefetch` | `BACKWARD_PRE` / `BACKWARD_POST` / `NO_PREFETCH` | 역전파 prefetch 시점 |
| `fsdp_forward_prefetch` | `bool` | 순전파 prefetch 여부 |
| `fsdp_state_dict_type` | `FULL_STATE_DICT` / `SHARDED_STATE_DICT` / `LOCAL_STATE_DICT` | 체크포인트 저장 방식 |
| `fsdp_offload_params` | `bool` | CPU offload 여부 |
| `fsdp_cpu_ram_efficient_loading` | `bool` | rank 0에서만 모델 로드 후 분산 여부 |
| `fsdp_sync_module_states` | `bool` | 모듈 상태 동기화 여부 |
| `fsdp_use_orig_params` | `bool` | 원본 파라미터 유지 (LoRA, freeze 등에 필수) |
| `fsdp_activation_checkpointing` | `bool` | 활성화 체크포인팅 여부 |

<details>
<summary><font color='#0000FF'>fsdp_sharding_strategy</font></summary>
<div markdown="1">

FSDP는 모델의 파라미터 (P), 그래디언트 (G), 옵티마이저 상태 (O)를 여러 GPU에 쪼개서 나눠 저장하는데,  `fsdp_sharding_strategy`는 이걸 어느 정도까지 쪼갤지 결정하는 옵션이다.

| Value | P | G | O | 메모리 절약 | 통신 비용 |
| :---: | :---: | :---: | :---: | :---: | :---: |
| `NO_SHARD` | X | X | X | 없음 (DDP와 동일) | 적음 |
| `SHARD_GRAD_OP` | X | O | O | 중간 | 중간 |
| `FULL_SHARD` | O | O | O | 큼 | 큼 |

---

</div>
</details>

<details>
<summary><font color='#0000FF'>fsdp_auto_wrap_policy</font></summary>
<div markdown="1">

FSDP는 모델의 파라미터 (P), 그래디언트 (G), 옵티마이저 상태 (O)를 여러 GPU에 쪼개서 나눠 저장하는데,  `fsdp_auto_wrap_policy`는 이걸 어느 정도까지 쪼갤지 결정하는 옵션이다.

모델을 통째로 한 덩어리로 쪼개면 비효율적이에요. 트랜스포머처럼 반복되는 블록 단위로 쪼개야 통신과 계산을 겹쳐서(overlap) 효율적으로 처리할 수 있어요.

| Value | 동작 방식 |
| :---: | :---: |
| `TRANSFORMER_BASED_WRAP` | 지정한 트랜스포머 레이어 클래스 단위로 자동 wrap |
| `SIZE_BASED_WRAP` | 파라미터 수가 일정 기준 이상인 모듈을 자동 wrap |
| `NO_WRAP` | 자동 wrap 안 함. 사용자가 수동 처리 |

`SIZE_BASED_WRAP`를 사용할 경우, 추가적으로 `fsdp_min_num_params` key 값을 통해 warp할 모듈의 최소 파라미터 수를 지정해야 한다.

```yaml
fsdp_min_num_params: 100000000  # 1억 개 이상인 모듈만 wrap
```

---

</div>
</details>

<details>
<summary><font color='#0000FF'>fsdp_backward_prefetch</font></summary>
<div markdown="1">

FSDP는 모델의 파라미터 (P), 그래디언트 (G), 옵티마이저 상태 (O)를 여러 GPU에 쪼개서 나눠 저장하는데,  `fsdp_auto_wrap_policy`는 이걸 어느 정도까지 쪼갤지 결정하는 옵션이다.

모델을 통째로 한 덩어리로 쪼개면 비효율적이에요. 트랜스포머처럼 반복되는 블록 단위로 쪼개야 통신과 계산을 겹쳐서(overlap) 효율적으로 처리할 수 있어요.

| Value | 동작 방식 |
| :---: | :---: |
| `TRANSFORMER_BASED_WRAP` | 지정한 트랜스포머 레이어 클래스 단위로 자동 wrap |
| `SIZE_BASED_WRAP` | 파라미터 수가 일정 기준 이상인 모듈을 자동 wrap |
| `NO_WRAP` | 자동 wrap 안 함. 사용자가 수동 처리 |

`SIZE_BASED_WRAP`를 사용할 경우, 추가적으로 `fsdp_min_num_params` key 값을 통해 warp할 모듈의 최소 파라미터 수를 지정해야 한다.

```yaml
fsdp_min_num_params: 100000000  # 1억 개 이상인 모듈만 wrap
```

---

</div>
</details>

6. fsdp_forward_prefetch — 순전파에도 prefetch 적용
순전파에서도 같은 방식으로 다음 레이어 파라미터를 미리 가져올지 여부예요. true로 하면 속도는 빨라지지만 메모리 사용량이 늘어요. 보통은 역전파 prefetch만 켜고 이건 false로 두는 경우가 많아요.
7. fsdp_state_dict_type — 체크포인트를 어떻게 저장할까
학습 중 저장할 때, 분산되어 있는 파라미터를 어떻게 합쳐서 저장할지의 문제예요.
값동작장단점FULL_STATE_DICT모든 GPU의 파라미터를 rank 0에 모아서 하나의 파일로 저장호환성 ⭕, 큰 모델은 OOM 위험SHARDED_STATE_DICT각 GPU가 자기 몫만 따로 저장 (여러 파일)OOM 없음, 빠름. 로드 시 같은 GPU 수 필요LOCAL_STATE_DICT거의 사용 안 함 (deprecated 추세)-
실무 팁: 70B 같은 대형 모델은 FULL_STATE_DICT로 저장 시 rank 0의 CPU/GPU 메모리가 터져요. 이런 경우 학습 중에는 SHARDED_STATE_DICT로 저장하다가, 마지막에만 FULL_STATE_DICT로 변환해 배포하는 게 일반적이에요.
8. fsdp_offload_params — CPU로 파라미터 내보내기
true로 하면 사용하지 않는 파라미터를 GPU 메모리에서 CPU RAM으로 옮겨놨다가, 필요할 때 다시 GPU로 가져와요.

장점: GPU 메모리 사용량 대폭 감소. 작은 GPU에서도 큰 모델 학습 가능
단점: CPU↔GPU 통신 때문에 속도 매우 느려짐 (2~5배까지)

GPU 메모리가 정말 부족할 때만 쓰는 최후의 수단이에요. ZeRO-Offload와 비슷한 개념입니다.
9. fsdp_cpu_ram_efficient_loading — 모델 로드 시 메모리 절약
대형 모델을 처음 로드할 때, 모든 GPU가 각자 모델 전체를 메모리에 올리면 GPU 8개면 8배의 메모리를 잠깐 사용해요(이후엔 분산되지만, 로딩 순간에 OOM 발생).
true로 설정하면:

rank 0(첫 번째 프로세스)에서만 모델을 메모리에 로드
다른 rank들은 비어있는 메타 텐서로 시작
이후 분산 처리 단계에서 각자 자기 몫만 받음

70B 같은 대형 모델 학습 시 거의 필수예요. 단, fsdp_sync_module_states: true와 함께 써야 동작합니다.
10. fsdp_sync_module_states — 모듈 상태 동기화
true로 하면 rank 0의 모델 가중치를 다른 rank들에 broadcast해서 모두 같은 초기 상태에서 시작하도록 보장해요. 위의 fsdp_cpu_ram_efficient_loading이나 from_pretrained로 모델 로드할 때 짝꿍처럼 같이 쓰입니다.
11. fsdp_use_orig_params — 원본 파라미터 객체 유지
FSDP는 내부적으로 파라미터들을 하나의 큰 평평한 텐서(flat parameter) 로 합쳐서 관리해요. 이게 효율적이긴 한데, 옵티마이저 입장에서는 원래 파라미터 이름이나 그룹 정보가 사라져버려요.
true로 하면 원본 nn.Parameter 객체를 그대로 노출해줘서:

파라미터 그룹별 다른 학습률 가능 (예: backbone은 lr=1e-5, head는 lr=1e-3)
일부 파라미터 freeze 가능 (requires_grad=False)
LoRA처럼 일부만 학습하는 경우 필수
torch.compile과의 호환성도 더 좋음

요즘은 거의 항상 true로 두는 게 표준이에요.
12. fsdp_activation_checkpointing — 활성화 메모리 절약
순전파의 중간 결과(activation) 들은 역전파 때 그래디언트 계산에 필요해서 저장해둬야 해요. 이게 메모리를 꽤 많이 잡아먹어요.
true로 하면:

순전파 시 중간 activation을 저장하지 않고
역전파 시 필요할 때 다시 계산해서 사용

→ 메모리는 크게 절약(30~50%), 대신 계산 시간 약 30% 증가
긴 시퀀스나 대형 모델에서 OOM 날 때 거의 필수적인 옵션이에요. Gradient Checkpointing이라고도 부릅니다.

