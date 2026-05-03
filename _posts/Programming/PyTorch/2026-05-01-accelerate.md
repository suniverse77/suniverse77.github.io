---
title: "[Hugging Face] accelerate"
date: 2026-05-01 00:00:00 +/-TTTT
categories: [Programming, 파이토치]
tags: [Hugging Face, GPU 분산 학습]
math: true
toc: true
author: sunho
---

`accelerate`는 Hugging Face에서 개발한 파이썬 라이브러리 중 하나로, 복잡한 분산 학습 코드를 단 몇 줄로 줄여주는 역할을 한다.

앞서 우리가 DDP나 FSDP 코드를 짤 때 dist.init_process_group, DistributedSampler, os.environ 환경 변수 설정 등 신경 써야 할 기본 설정(보일러플레이트 코드)이 아주 많았죠? accelerate는 이러한 복잡한 설정들을 내부적으로 알아서 처리해 줍니다.

작동 방식: 코드 상단에서 Accelerator 객체를 하나 만들고, 내 모델과 데이터 로더를 prepare()라는 함수에 통과시키기만 하면 끝입니다. 그러면 코드가 실행되는 환경(Single GPU, 다중 GPU DDP, FSDP, 심지어 TPU까지)을 자동으로 감지하여 알맞게 세팅해 줍니다.

개발 단계:

Accelerator 객체 생성

일반 PyTorch 코드 작성 (모델, 로더, 옵티마이저)

accelerator.prepare()로 감싸기

훈련 루프 내에서 디바이스 이동(to(device)) 제거 및 backward() 변경

장점: 하나의 파이썬 스크립트로 노트북(CPU), 내 컴퓨터(1 GPU), 대형 서버(Multi-GPU DDP/FSDP) 어디서든 코드 수정 없이 학습을 돌릴 수 있습니다.

먼저 터미널에서 `accelerate` 모듈을 설치해야 한다.

```bash
pip install accelerate
```

```python
import torch
import torch.nn as nn
from torch.utils.data import DataLoader, Dataset
# 💡 Step 1: accelerate 라이브러리에서 Accelerator 불러오기
from accelerate import Accelerator

# (가정) 간단한 더미 데이터셋 클래스
class MyDataset(Dataset):
    def __init__(self):
        self.data = torch.randn(100, 10)
        self.targets = torch.randn(100, 2)
    def __len__(self): return 100
    def __getitem__(self, idx): return self.data[idx], self.targets[idx]

class Model(nn.Module):
    def __init__(self):
        super().__init__()
        self.fc = nn.Linear(10, 2)
    def forward(self, x):
        return self.fc(x)

# ---------------------------------------------------------
# Step 2: Accelerator 초기화
# ---------------------------------------------------------
# 이 한 줄이 앞서 배운 dist.init_process_group 등을 모두 대신합니다.
accelerator = Accelerator()

# 💡 참고: 이제 .to(device)를 할 필요가 없습니다!
model = Model()
optimizer = torch.optim.SGD(model.parameters(), lr=0.01)
criterion = nn.MSELoss()

dataset = MyDataset()
# 💡 참고: DistributedSampler도 필요 없습니다! shuffle=True로 두면 알아서 분산시켜 줍니다.
train_loader = DataLoader(dataset, batch_size=32, shuffle=True)

# ---------------------------------------------------------
# Step 3: Prepare (핵심 마법)
# ---------------------------------------------------------
# 내가 만든 객체들을 accelerator.prepare에 통과시키면, 
# 현재 환경(DDP, FSDP 등)에 맞게 알아서 모델을 래핑하고 로더를 세팅합니다.
model, optimizer, train_loader = accelerator.prepare(
    model, optimizer, train_loader
)

num_epochs = 5

# ---------------------------------------------------------
# Step 4: 훈련 루프
# ---------------------------------------------------------
for epoch in range(num_epochs):
    model.train()
    
    for x, y in train_loader:
        # 💡 참고: x, y = x.to(device) 코드를 지워도 됩니다! prepare된 로더가 알아서 해줍니다.
        
        optimizer.zero_grad()
        y_pred = model(x)
        loss = criterion(y_pred, y)
        
        # 💡 Step 5: loss.backward() 대신 accelerator.backward() 사용
        accelerator.backward(loss)
        
        optimizer.step()
        
print("학습이 성공적으로 완료되었습니다!")
```

코드를 train.py로 저장한 후 터미널에 아래 명령어를 치면, 어떤 환경으로 훈련할지 묻는 친절한 마법사가 나타나서 셋업을 도와주고 실행까지 해줍니다!
accelerate config (최초 1회 설정)
accelerate launch train.py (학습 실행)
