---
title: "[딥러닝] 딥러닝 모델의 학습"
date: 2025-02-11 00:00:00 +/-TTTT
categories: [AI, 머신러닝 / 딥러닝]
tags: [딥러닝, 모델 학습]
math: true
toc: true
author: sunho
---

딥러닝 모델에서 데이터를 학습하는 과정은 크게 순전파(Forward pass), 역전파(Backward pass), 그리고 파라미터 업데이트(Parameter Update)로 이루어진다.

![fig1](AI/ML-DL/Model_Train-1.png){: style="display:block; margin:0 auto; width:60%;"}

- **순전파 (Forward pass):** 입력 데이터에서 출발해 계산 그래프를 따라 각 노드의 출력을 차례대로 계산하며, 최종적으로 모델의 예측값과 실제 정답을 비교하여 손실 함수 값 $\mathcal{L}$을 얻는다.
- **역전파 (Backward pass):** 출력에서 입력 방향으로 그래프를 거슬러 올라가면서 연쇄 법칙(Chain Rule)을 이용해, 각 파라미터에 대한 손실의 기울기 $\nabla_{\boldsymbol{\theta}}\mathcal{L}$를 계산한다.
- **파라미터 업데이트 (Parameter Update):** 계산된 그래디언트를 바탕으로 옵티마이저를 사용하여 손실을 줄이는 방향으로 파라미터 $\boldsymbol{\theta}$를 업데이트한다.

이러한 `순전파 → 역전파 → 파라미터 업데이트`의 1회 사이클을 묶어서 스텝(Step) 또는 이터레이션(Iteration)이라고 한다.

또한 모델이 준비된 전체 학습 데이터셋을 모두 한 번씩 다 학습에 사용했을 때를 1 Epoch이라고 한다.

![fig2](AI/ML-DL/Model_Train-2.png){: style="display:block; margin:0 auto; width:50%;"}

만약 학습 데이터셋에 데이터가 1000개 있고, 배치 크기를 25로 설정했다고 해보자.
<br>
이 경우 1번의 epoch을 완료하기 위해 총 40번의 step이 이루어진다.
