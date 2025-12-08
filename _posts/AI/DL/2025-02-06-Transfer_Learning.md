---
title: "[CNN] 전이 학습 (Transfer Learning)"
date: 2025-02-06 00:00:00 +/-TTTT
categories: [AI, 딥러닝]
tags: [CS231n]
math: true
toc: true
author: sunho
---

## 전이 학습 (Transfer Learning)

전이 학습은 이미 학습된 모델의 지식을 이용해 새로운 문제에 활용하는 기법을 의미한다.

처음부터 모든 걸 학습하지 않기 때문에 빠르고 효율적인 학습이 가능하다.

![fig1](dl/cnn/06-27.png){: style="display:block; margin:0 auto; width:90%;"}

먼저 ImageNet에 대해 학습된 모델을 가져온다.

**Feature Extractor로 사용 (2번 case)**

사전 학습된 모델의 앞부분 layer의 가중치를 고정시키고 뒷부분 layer만 새롭게 학습시키는 방식으로, 마지막 layer의 출력 크기만 클래스 개수에 맞게 조정하면 된다.

CNN의 경우 conv layer는 고정하고 마지막 분류기 layer만 새 데이터에 맞게 학습하면 된다.

주로 추가로 학습시킬 데이터셋이 적을 때 사용한다. 하지만 대부분의 layer를 고정하기 때문에 당연히 ImageNet과 유사한 데이터셋에 대해서 가장 좋은 성능이 나타날 수밖에 없다.

**Fine-tuning (3번 case)**

사전 학습된 모델의 가중치를 초기값으로 사용하며, 전체 또는 일부 layer를 다시 학습시키는 방식이다.

주로 추가로 학습시킬 데이터셋이 클 때 사용한다.

![fig2](dl/cnn/06-28.png){: style="display:block; margin:0 auto; width:90%;"}

4가지 상황에 따른 학습 전략이 있다.

- **추가로 학습시킬 데이터셋이 적고, 사전학습 때 사용한 데이터셋과 비슷한 경우**

    모든 layer에 대해 fine-tuning하면 오버피팅의 위험이 있으므로 마지막 layer만 학습시키는 것이 효율적이다.
- **추가로 학습시킬 데이터셋이 많고, 사전학습 때 사용한 데이터셋과 비슷한 경우**

    모든 layer에 대해 fine-tuning하는 것이 효율적이다.
- **추가로 학습시킬 데이터셋이 적고, 사전학습 때 사용한 데이터셋과 다른 경우**
    
    다른 모델을 선택하는 것이 낫다.
- **추가로 학습시킬 데이터셋이 많고, 사전학습 때 사용한 데이터셋과 다른 경우**

    모델을 처음부터 학습시킨 것이 좋을 수도 있고, fine-tuning한 것이 좋을 수도 있다. 즉, 어떠한 방법이 더 좋은지 보장할 수 없다.
