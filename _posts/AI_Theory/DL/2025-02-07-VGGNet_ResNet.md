---
title: "[CNN] VGGNet & ResNet"
date: 2025-02-07 00:00:00 +/-TTTT
categories: [AI, 딥러닝]
tags: [CS231n]
math: true
toc: true
author: sunho
---

## CNN Architectures

아래 그림은 연도별 ImageNet Large Scale Visual Recognition Challenge (ILSVRC) 대회의 우승 모델의 에러율과 layer 깊이를 나타낸다.

ResNet을 기점으로 신경망의 layer가 매우 깊어진 것을 볼 수 있다.

![fig12](cs231n/06-12.png){: style="display:block; margin:0 auto; width:80%;"}

### VGGNet

VGGNet의 아키텍처는 아래와 같다.

<span style="background-color:#fff5b1">3x3 conv (stride=1)만 사용</span>한 것이 가장 큰 특징이며, conv 연산 때는 공간적 크기를 보존하고 크기를 줄일 때는 pooling 연산을 수행하였다.

![fig13](cs231n/06-13.png){: style="display:block; margin:0 auto; width:80%;"}

아래 그림에서 3x3 conv를 3번 사용하면 A3의 한 칸이 보는 영역이 Input의 7x7 영역인 것을 확인할 수 있다. 이는 7x7 conv를 1번 사용하는 것과 동일한 receptive field를 가지는 효과를 낸다.

![fig14](cs231n/06-14.png){: style="display:block; margin:0 auto; width:100%;"}

하지만 왜 3x3 conv를 3번 사용했을까? 정답은 동일한 receptive field를 가지지만 필요한 파라미터 수는 더 적기 때문이다.

입력과 출력의 채널 크기가 $C$라면 필터가 $C$개 있어야 하므로, 7x7 conv 1-layer는 $1\times[C\times (7\times7\times C)]=49C^2$개의 파라미터가 필요하다. 반면 3x3 conv 3-layer는 $3\times[C\times (3\times3\times C)]=9C^2$개의 파라미터만 필요하므로 더 적다. 

또한 layer가 더 깊어지므로 비선형성이 더 증가한다는 이점이 있다.

### ResNet

깊은 신경망은 얕은 신경망보다 표현력이 더 뛰어나야 하지만, 실제로 층이 깊어질수록 오히려 학습이 어려워지고 성능이 낮아지는 현상이 발생하였다.
ResNet은 깊은 모델일수록 최적화하기 어렵다는 문제를 해결하기 위해 고안된 구조다.

![fig15](cs231n/06-15.png){: style="display:block; margin:0 auto; width:100%;"}

항등함수 (Identity Function)를 넣으면 모델을 최소한 얕은 모델만큼 좋아야한다. 

![fig16](cs231n/06-16.png){: style="display:block; margin:0 auto; width:100%;"}

이를 이용해 항등 함수를 쉽게 학습할 수 있도록 skip connection을 추가하였다.

![fig17](cs231n/06-17.png){: style="display:block; margin:0 auto; width:80%;"}

신경망은 여러 층을 통과하여 입력 $x$를 원하는 출력 $H(x)$로 매핑하는 것을 학습한다. ResNet에서는 $H(x)$를 직접 학습하는 대신 skip connection을 도입하여 잔차 $F(x)=H(x)-x$만 학습하도록 하였다.

![fig18](cs231n/06-18.png){: style="display:block; margin:0 auto; width:80%;"}

잔차를 학습하는 것이 더 쉬운 이유는 2가지 관점으로 볼 수 있다.

**1. 최적화 관점**

만약 여러 층을 거쳐도 입력과 출력이 거의 같아야 하는 상황 (더 깊은 층이 필요 없는 상황)이라면, $H(x)$는 항등 함수에 가까워야 한다. 하지만 여러 층을 통과하며 이 항등 함수를 학습하는 것은 어렵다.

반면 ResNet은 $F(x)=H(x)−x$를 학습하므로 위와 동일한 상황에서 신경망은 단순히 $F(x)=0$을 학습하면 되며, 이는 최적화 관점에서 매우 쉬운 목표이다.

예를 들어, 출력이 입력과 똑같아야되는 상황에서 skip connection이 없다면 $x\to+2\to-2\to H(x)=x$ 이런 복잡한 매핑을 학습해야할 수도 있다. 이 경우 모든 층의 가중치가 정교하게 맞아야 하며, 복잡한 과정으로 항등 함수를 흉내내야하기 때문에 매우 어렵다.

하지만 skip connection이 있다면 이미 이 경로가 항등 함수를 제공하기 때문에 $x\to+0\to+0\to H(x)=F(x)+x$ 이렇게 간단히 $F(x)=0$만 학습해도 입력과 동일한 출력이 보장된다.

**2. 기울기 관점**

역전파로 전달되는 기울기는 연속적인 미분 값의 곱으로 표현되는데, 각 층에서 미분 값이 1보다 작다면 네트워크가 깊어질수록 점점 0에 가까워져 앞쪽 레이어까지 기울기가 잘 전달되지 않는 <span style="background-color:#fff5b1">기울기 소실 (Vanishing Gradient)</span> 현상이 발생한다.

ResNet에서는 skip connection에 의해 기울기가 아래와 같이 흐른다.

$$
y=F(x)+x~\to~\frac{\partial L}{\partial x}=\frac{\partial L}{\partial y}\left(\frac{\partial F(x)}{\partial x}+I\right)
$$

덧셈 구조 덕분에 $F(x)$의 기울기가 0에 가까워져도 $I$를 통해 기울기가 그대로 전달되기 때문에 기울기가 소실되지 않는다.
