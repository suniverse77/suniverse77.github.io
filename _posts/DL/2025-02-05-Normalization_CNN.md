---
title: "[CNN] CNN에서의 데이터 정규화"
date: 2025-02-05 12:00:00 +/-TTTT
categories: [AI, 딥러닝]
tags: [CS231n]
math: true
toc: true
author: sunho
---

## CNN에서의 Normalization

![fig1](cs231n/06-1.png){: style="display:block; margin:0 auto; width:100%;"}

보통 normalization을 설명할 때 위의 그림을 자주 사용한다. 

하지만 아래의 그림이 이해하기에는 더 쉬운 것 같다.

설명하기 전, 채널 크기를 $C$, 세로와 가로의 크기를 $H$와 $W$라고 할 때, 앞으로 입력의 크기를 $C\times H\times W$로 표현한다. 이러한 샘플이 $N$개 존재한다면 $N\times C\times H\times W$ 크기로 표현한다.

### Batch Normalization

![fig2](cs231n/06-2.png){: style="display:block; margin:0 auto; width:80%;"}
_[[그림 출처]](https://blog.csdn.net/weixin_38346042/article/details/131882490)_

Batch Norm은 하나의 배치 내에서 각 채널 별로 정규화를 수행한다.

$N\times C\times H\times W$ 크기의 텐서에 대해 batch norm을 수행하면 결과의 크기는 $1\times C\times H\times W$가 된다.

### Layer Normalization

![fig3](cs231n/06-3.png){: style="display:block; margin:0 auto; width:80%;"}
_[[그림 출처]](https://blog.csdn.net/weixin_38346042/article/details/131882490)_

Layer Norm은 하나의 샘플에 대해서 정규화를 수행한다.

$N\times C\times H\times W$ 크기의 텐서에 대해 layer norm을 수행하면 결과의 크기는 $N\times 1\times 1\times 1$가 된다.

### Instance Normalization

![fig4](cs231n/06-4.png){: style="display:block; margin:0 auto; width:80%;"}
_[[그림 출처]](https://blog.csdn.net/weixin_38346042/article/details/131882490)_

Istance Norm은 각 샘플마다 채널 별로 정규화를 수행한다.

$N\times C\times H\times W$ 크기의 텐서에 대해 instance norm을 수행하면 결과의 크기는 $N\times 1\times 1\times C$가 된다.

### Group Normalization

![fig5](cs231n/06-5.png){: style="display:block; margin:0 auto; width:80%;"}
_[[그림 출처]](https://blog.csdn.net/weixin_38346042/article/details/131882490)_

Group Norm은 각 샘플마다 채널을 $G$개의 그룹으로 묶어 정규화를 수행한다.

$G=C$이면 그룹의 개수가 총 $C$개라는 뜻이므로 instance norm과 동일한 기능을 수행하며, $G=1$이면 하나의 샘플을 통채로 정규화한다는 뜻이므로 layer norm과 동일한 기능을 수행한다.

그룹의 개수가 $G$일 때, $N\times C\times H\times W$ 크기의 텐서에 대해 group norm을 수행하면 결과의 크기는 $N\times 1\times 1\times G$가 된다.
