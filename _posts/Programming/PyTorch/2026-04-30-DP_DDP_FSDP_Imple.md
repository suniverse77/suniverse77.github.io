---
title: "[PyTorch] GPU 분산 학습 2 - DP / DDP / FSDP 구현"
date: 2026-04-30 12:00:00 +/-TTTT
categories: [Programming, 파이토치 (PyTorch)]
tags: [PyTorch, GPU 분산 학습]
math: true
toc: true
author: sunho
---

아래의 코드를 기본적인 모델 학습 구조로 가정하겠다.

```python
import torch
import torch.nn as nn
from torch.utils.data import DataLoader

device = 'cuda' if torch.cuda.is_available() else 'cpu'

class Model(nn.Module):
    def __init__(self):
        super().__init__()
        self.fc = nn.Linear(10, 2)

    def forward(self, x):
        return self.fc(x)

model = Model().to(device)
optimizer = torch.optim.SGD(model.parameters(), lr=0.01)
criterion = nn.MSELoss()

dataset = MyDataset()
train_loader = DataLoader(dataset, batch_size=32, shuffle=True)

num_epochs = 5

for epoch in range(num_epochs):
    model.train()
    
    for x, y in train_loader:
        x, y = x.to(device), y.to(device)
        
        optimizer.zero_grad()
        y_pred = model(x)
        loss = criterion(y_pred, y)
        loss.backward()
        optimizer.step()
```

## DP (Data Parallel)

일반적인 파이썬 스크립트 실행하듯 `python script.py`로 실행하면 된다.

```python
import torch
import torch.nn as nn
from torch.utils.data import DataLoader
# DP 관련 모듈
from torch.nn.parallel import DataParallel as DP

device = 'cuda' if torch.cuda.is_available() else 'cpu'

class Model(nn.Module):
    def __init__(self):
        super().__init__()
        self.fc = nn.Linear(10, 2)

    def forward(self, x):
        return self.fc(x)

# ---------------------------------------------------------
# DP 구현: 모델 생성 및 DP Wrapping
# ---------------------------------------------------------
model = Model().to(device)

# 사용 가능한 GPU가 1개보다 많으면, DP 모듈로 모델을 감싸 분산 학습이 가능하도록 설정
if torch.cuda.device_count() > 1:
    print(f"Let's use {torch.cuda.device_count()} GPUs!")
    model = DP(model)

optimizer = torch.optim.SGD(model.parameters(), lr=0.01)
criterion = nn.MSELoss()

dataset = MyDataset()
train_loader = DataLoader(dataset, batch_size=32, shuffle=True)

num_epochs = 5

for epoch in range(num_epochs):
    model.train()
    
    for x, y in train_loader:
        x, y = x.to(device), y.to(device)
        
        optimizer.zero_grad()
        y_pred = model(x)
        loss = criterion(y_pred, y)
        loss.backward()
        optimizer.step()
```

## DDP (Distributed Data Parallel)

DDP는 터미널에서 `torchrun` 모듈을 사용하여 실행해야 한다.
<br>
예를 들어 2개의 GPU를 사용한다면 `torchrun --nproc_per_node=2 script.py`처럼 실행한다.

<details>
<summary><font color='#0000FF'>여러 컴퓨터에서 실행하는 방법</font></summary>
<div markdown="1">

여러 컴퓨터를 통해 분산 학습을 사용하려고 하는 경우, 각 컴퓨터의 터미널에서 `torchrun` 명령어를 따로따로 실행해야 한다.

컴퓨터가 2대 있고, 각각 GPU가 4개씩 있는 경우를 가정해 보자.

- 컴퓨터 1 (대장 노드 - Node 0) 터미널에서 실행

    ```Bash
    torchrun \
        --nnodes=2 \                   # 총 참여하는 노드 개수
        --node_rank=0 \                # 현재 컴퓨터의 노드 번호
        --nproc_per_node=4 \           # 현재 컴퓨터에 존재하는 GPU 개수
        --master_addr="192.168.0.1" \  # 대장 컴퓨터 IP 주소 (자기 자신)
        --master_port=12345 \          # 통신에 사용할 임의의 포트 번호
        script.py
    ```
- 컴퓨터 2 (작업자 노드 - Node 1) 터미널에서 실행

    ```Bash
    torchrun \
        --nnodes=2 \                   # 총 참여하는 노드 개수
        --node_rank=1 \                # 현재 컴퓨터의 노드 번호
        --nproc_per_node=4 \           # 현재 컴퓨터에 존재하는 GPU 개수
        --master_addr="192.168.0.1" \  # 대장 컴퓨터 IP 주소
        --master_port=12345 \          # 대장 컴퓨터가 열어둔 포트 번호
        script.py
    ```

---

</div>
</details>
<br>

> **명령어: `python` vs `torchrun`**
>
> `python`은 단 1개의 파이썬 프로세스만 실행한다.
>
> 반면, `torchrun`은 지정한 GPU 개수만큼 독립적인 파이썬 프로세스를 동시에 여러 개 실행한다.
    <br>
    예를 들어 `torchrun --nproc_per_node=4 script.py`라고 실행하면, 내부적으로 python script.py가 4개 동시에 실행되는 것과 같다.
>
>` torchrun`은 실행되는 각 파이썬 프로세스에 `LOCAL_RANK` (현재 컴퓨터 내 GPU 번호), `WORLD_SIZE` (전체 GPU 개수) 등의 환경 변수를 자동으로 주입해 주기 때문에, `os.environ["LOCAL_RANK"]`를 통해 번호를 쉽게 가져올 수 있다.

```python
import torch
import torch.nn as nn
from torch.utils.data import DataLoader
# DDP 관련 모듈
import torch.distributed as dist
from torch.utils.data.distributed import DistributedSampler
from torch.nn.parallel import DistributedDataParallel as DDP

# ---------------------------------------------------------
# Step 1: 분산 학습 환경 초기화
# ---------------------------------------------------------
# 프로세스 간 통신 채널 설정
dist.init_process_group(backend='nccl')

# torchrun이 설정한 환경 변수에서 현재 프로세스의 로컬 GPU 번호 획득
local_rank = int(os.environ["LOCAL_RANK"])
torch.cuda.set_device(local_rank)
device = torch.device(f'cuda:{local_rank}')

class Model(nn.Module):
    def __init__(self):
        super().__init__()
        self.fc = nn.Linear(10, 2)

    def forward(self, x):
        return self.fc(x)

# ---------------------------------------------------------
# Step 2: 모델 생성 및 DDP Wrapping
# ---------------------------------------------------------
model = Model().to(device)

# DDP 모듈로 모델을 감싸 분산 학습이 가능하도록 설정
model = DDP(model, device_ids=[local_rank])

# ---------------------------------------------------------
# Step 3: 데이터 로더 및 분산 샘플러 설정
# ---------------------------------------------------------
dataset = MyDataset()

# 전체 데이터셋이 각 GPU에 겹치지 않게 분배되도록 Sampler 설정
sampler = DistributedSampler(dataset)

# sampler를 사용할 때는 shuffle=False로 설정 (sampler가 알아서 섞어줌)
train_loader = DataLoader(dataset, batch_size=32, sampler=sampler)

num_epochs = 5

# ---------------------------------------------------------
# Step 4: 분산 학습 훈련 loop
# ---------------------------------------------------------
for epoch in range(num_epochs):
    # 매 epoch마다 Sampler에 현재 epoch을 전달해야 데이터 셔플링이 정상 작동함
    sampler.set_epoch(epoch)
    model.train()
    
    for x, y in train_loader:
        x, y = x.to(device), y.to(device)
        
        optimizer.zero_grad()
        y_pred = model(x)
        loss = criterion(y_pred, y)
        loss.backward()
        optimizer.step()

# ---------------------------------------------------------
# Step 5: 리소스 정리
# ---------------------------------------------------------
# 모든 학습이 완료된 후 프로세스 간 통신 그룹을 종료하여 메모리 및 자원 해제
dist.destroy_process_group()
```

## FSDP (Fully Sharded Data Parallel)

DDP와 동일하게 터미널에서 `torchrun` 모듈을 사용하여 실행하면 된다.

```python
import os
import torch
import torch.nn as nn
from torch.utils.data import DataLoader
# FSDP 관련 모듈
import torch.distributed as dist
from torch.utils.data.distributed import DistributedSampler
from torch.distributed.fsdp import FullyShardedDataParallel as FSDP

# ---------------------------------------------------------
# Step 1: 분산 학습 환경 초기화 (DDP와 동일)
# ---------------------------------------------------------
dist.init_process_group(backend='nccl')
local_rank = int(os.environ["LOCAL_RANK"])
torch.cuda.set_device(local_rank)
device = torch.device(f'cuda:{local_rank}')

class Model(nn.Module):
    def __init__(self):
        super().__init__()
        self.fc = nn.Linear(10, 2)

    def forward(self, x):
        return self.fc(x)

# ---------------------------------------------------------
# Step 2: 모델 생성 및 FSDP Wrapping
# ---------------------------------------------------------
# 모델을 CPU 상태에서 FSDP로 감싸면, FSDP가 알아서 적절한 GPU로 파라미터를 sharding 수행
model = Model()
model = FSDP(model)

optimizer = torch.optim.SGD(model.parameters(), lr=0.01)
criterion = nn.MSELoss()

# ---------------------------------------------------------
# Step 3: 데이터 로더 및 분산 샘플러 설정 (DDP와 동일)
# ---------------------------------------------------------
dataset = MyDataset()

sampler = DistributedSampler(dataset)
train_loader = DataLoader(dataset, batch_size=32, sampler=sampler)

num_epochs = 5

# ---------------------------------------------------------
# Step 4: 분산 학습 훈련 loop (DDP와 동일)
# ---------------------------------------------------------
for epoch in range(num_epochs):
    sampler.set_epoch(epoch)
    model.train()
    
    for x, y in train_loader:
        # 데이터는 각 로컬 GPU로 직접 보냄
        x, y = x.to(device), y.to(device)
        
        optimizer.zero_grad()
        y_pred = model(x)
        loss = criterion(y_pred, y)
        loss.backward()
        optimizer.step()

# ---------------------------------------------------------
# Step 5: 리소스 정리 (DDP와 동일)
# ---------------------------------------------------------
dist.destroy_process_group()
```

### FSDP 추가 설정
