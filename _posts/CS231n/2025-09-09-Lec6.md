---
title: "[CS231n] CNN Architectures"
date: 2025-09-09 00:00:00 +/-TTTT
categories: [AI, CS231n]
tags: [CS231n]
math: true
toc: true
author: sunho
description: 📖 Stanford CS231n | Spring 2025 | Lecture 6
---

# How to build CNNs?

## Layers in CNNs

### Normalization Layer

Normalization은 데이터의 크기와 분포를 일정한 범위로 조정하는 task를 의미한다.

자세한 내용은 [Normalization](https://suniverse77.github.io/posts/Lec6/) 포스트에 설명하였다.

![fig1](cs231n/06-1.png){: style="display:block; margin:0 auto; width:100%;"}

보통 normalization을 설명할 때 위의 그림을 자주 사용한다. 

하지만 아래의 그림이 이해하기에는 더 쉬운 것 같다.

설명하기 전, 채널 크기를 $C$, 세로와 가로의 크기를 $H$와 $W$라고 할 때, 앞으로 입력의 크기를 $C\times H\times W$로 표현한다. 이러한 샘플이 $N$개 존재한다면 $N\times C\times H\times W$ 크기로 표현한다.

**Batch Normalization**

![fig2](cs231n/06-2.png){: style="display:block; margin:0 auto; width:80%;"}
_[[그림 출처]](https://blog.csdn.net/weixin_38346042/article/details/131882490)_

Batch Norm은 하나의 배치 내에서 각 채널 별로 정규화를 수행한다.

$N\times C\times H\times W$ 크기의 텐서에 대해 batch norm을 수행하면 결과의 크기는 $1\times C\times H\times W$가 된다.

**Layer Normalization**

![fig3](cs231n/06-3.png){: style="display:block; margin:0 auto; width:80%;"}
_[[그림 출처]](https://blog.csdn.net/weixin_38346042/article/details/131882490)_

Layer Norm은 하나의 샘플에 대해서 정규화를 수행한다.

$N\times C\times H\times W$ 크기의 텐서에 대해 layer norm을 수행하면 결과의 크기는 $N\times 1\times 1\times 1$가 된다.

**Instance Normalization**

![fig4](cs231n/06-4.png){: style="display:block; margin:0 auto; width:80%;"}
_[[그림 출처]](https://blog.csdn.net/weixin_38346042/article/details/131882490)_

Istance Norm은 각 샘플마다 채널 별로 정규화를 수행한다.

$N\times C\times H\times W$ 크기의 텐서에 대해 instance norm을 수행하면 결과의 크기는 $N\times 1\times 1\times C$가 된다.

**Group Normalization**

![fig5](cs231n/06-5.png){: style="display:block; margin:0 auto; width:80%;"}
_[[그림 출처]](https://blog.csdn.net/weixin_38346042/article/details/131882490)_

Group Norm은 각 샘플마다 채널을 $G$개의 그룹으로 묶어 정규화를 수행한다.

$G=C$이면 그룹의 개수가 총 $C$개라는 뜻이므로 instance norm과 동일한 기능을 수행하며, $G=1$이면 하나의 샘플을 통채로 정규화한다는 뜻이므로 layer norm과 동일한 기능을 수행한다.

그룹의 개수가 $G$일 때, $N\times C\times H\times W$ 크기의 텐서에 대해 group norm을 수행하면 결과의 크기는 $N\times 1\times 1\times G$가 된다.

---

위는 ConvNet에서의 동작 방식이었고, MLP에서의 Batch norm과 Layer norm의 동작은 아래와 같다. 기본적으로 매커니즘은 동일하다.

![fig6](cs231n/06-6.png){: style="display:block; margin:0 auto; width:80%;"}
_[[그림 출처]](https://yonghyuc.wordpress.com/2020/03/04/batch-norm-vs-layer-norm/)_

- **Batch Normalization**: 배치 내에서 각 feature 별로 정규화를 수행
- **Layer Normalization**: 하나의 샘플에 대해 정규화 수행

### Dropout

Dropout은 학습 중에 확률적으로 뉴런을 꺼서 모델이 특정 뉴런에 오버피팅되는 것을 막는다.

Dropout에서 사용되는 하이퍼파라미터 $p$는 뉴런이 제거될 확률이다. 즉, 뉴런이 살아남을 확률은 $1-p$이다.

매번 다른 뉴런이 꺼지기 때문에 일종의 앙상블 학습 효과를 낸다.

![fig7](cs231n/06-7.png){: style="display:block; margin:0 auto; width:90%;"}

테스트 때도 dropout을 적용하면 같은 이미지를 넣어도 매번 출력이 달라지기 때문에 예측의 일관성이 없어진다. 따라서 dropout은 학습에서만 사용하고 테스트에서는 사용하지 않는다.

하지만 학습에서만 사용할 경우 학습과 테스트 때 활성된 뉴런의 개수가 달라지기 때문에 각 뉴런의 출력값의 스케일이 달라지는 현상이 발생한다.

- 뉴런이 모두 살아 있는 경우, 출력값이 4가 된다.

    $$
    \mathbf{x}^\top\mathbf{w}=
    \begin{bmatrix}1\\1\\1\\1\end{bmatrix}
    \begin{bmatrix}1&1&1&1\end{bmatrix}=4
    $$

- 뉴런이 절반만 살아 있는 경우, 출력값이 2가 된다.

    $$
    \mathbf{x}^\top\mathbf{w}=
    \begin{bmatrix}1\\1\\1\\1\end{bmatrix}
    \begin{bmatrix}1&0&1&0\end{bmatrix}=2
    $$

이러한 현상을 방지하기 위해 학습 때 출력값에 $\frac{1}{1-p}$를 곱해서 학습과 테스트 때의 출력 분포가 동일하도록 맞춘다.

## Activation Functions

활성화 함수는 모델에 비선형성을 도입하며, 여러 종류의 함수가 존재한다.

### Sigmoid

$$
\sigma(x)=\frac{1}{1+e^{-x}}
$$

Sigmoid 함수는 위와 같이 정의되며, 출력값의 범위를 0과 1사이로 매핑하기 때문에 확률로 해석할 때 주로 사용한다.

하지만 입력이 매우 큰 양수거나 음수일 경우 기울기가 0에 가까워진다는 문제점이 존재한다.

![fig8](cs231n/06-3.png){: style="display:block; margin:0 auto; width:80%;"}

### ReLU (Rectified Linear Unit)

$$
f(x)=\max(0,x)
$$

ReLU 함수는 위와 같이 정의되며, 음수 입력은 0으로, 양수 입력은 그대로 출력한다.

양수 영역에서는 기울기가 1이므로 saturation 문제가 없으며, sigmoid나 tanh보다 학습이 훨씬 빠르다.

하지만 여전히 음수 입력에 대해 기울기가 0이라는 문제점이 존재한다.

![fig9](cs231n/06-9.png){: style="display:block; margin:0 auto; width:80%;"}

### GeLU (Gaussian Error Linear Unit)

$$
f(x)=x\cdot\Phi(x)
$$

GeLU 함수는 위와 같이 정의된다.

ReLU에서 0에서 갑자기 꺾이는 불연속적인 변화를 부드럽게 만들었으며, 음수 구간에서도 0이 아닌 기울기를 가지기 때문에 학습 안정성이 개선되었다.

최근 트랜스포머 계열 모델에서 많이 사용되는 함수이다.

![fig10](cs231n/06-10.png){: style="display:block; margin:0 auto; width:80%;"}

### Others

그 외에도 다양한 활성화 함수가 존재한다.

![fig11](cs231n/06-11.png){: style="display:block; margin:0 auto; width:100%;"}

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

## Weight Initialization

가중치를 초기화하는 여러 가지 시도가 있었다.

### Small random numbers

가중치를 랜덤한 작은 값들로 초기화하는 방법이 있다.

```python
# 4096개 뉴런을 가진 레이어 7개 (입력 + 은닉6)
dims = [4096] * 7

hs = []

# 가우시안 분포를 따르는 초기 입력 데이터 생성 (16개 샘플, 4096개 특징)
x = np.random.rand(16, dims[0])

for Din, Dout in zip(dims[:-1], dims[1:]):
    # 가우시안 분포를 따르는 4096x4096 크기의 가중치 행렬 생성
    W = np.random.randn(Din, Dout)

    # 표준편차를 0.01로 만듦
    W = 0.01 * W
    
    # 순전파: 행렬 곱 + ReLU 활성화 함수
    x = np.maximum(0, x.dot(W))
    hs.append(x)
```

첫 번째 layer에서 출력 activation의 분산은 대략 $1^2\times 0.01^2\times4096\approx0.4$가 된다. 그럼 두 번째 layer의 입력의 분산이 1보다 작은 $0.4$가 되므로 layer를 지날수록 activation의 분산은 0으로 수렴하게 된다.

입력과 가중치의 평균이 0이므로, 출력의 평균도 0이 된다. 하지만 ReLU 함수는 음수 영역을 제거하기 때문에 출력의 평균은 양수의 어떤 값이 된다. 하지만 출력의 분산이 작다는 것은 결국 0 근처에 모여있다는 뜻이기 때문에 평균 또한 0으로 수렴하게 된다. 

![fig19](cs231n/06-19.png){: style="display:block; margin:0 auto; width:100%;"}

시각화를 한 결과, 가중치의 평균과 표준편차가 점점 작아져 0에 수렴하는 것을 볼 수 있다.

### Large random numbers

가중치를 랜덤한 큰 값들로 초기화하는 방법이 있다.

```python
dims = [4096] * 7
hs = []
x = np.random.rand(16, dims[0])

for Din, Dout in zip(dims[:-1], dims[1:]):
    W = np.random.randn(Din, Dout)

    # 표준편차를 0.05로 만듦
    W = 0.05 * W
    
    x = np.maximum(0, x.dot(W))
    hs.append(x)
```

첫 번째 layer에서 출력 activation의 분산은 대략 $1^2\times 0.05^2\times4096\approx10.24$가 된다. 그럼 두 번째 layer의 입력의 분산이 1보다 큰 $10.24$가 되므로 layer를 지날수록 activation의 분산은 발산하게 된다.

위에서 말했듯이 ReLU 함수는 음수 영역을 제거하기 때문에 출력의 평균은 양수의 어떤 값이 되며, 분산이 크기 때문에 평균이 점점 큰 양수쪽으로 움직이게 된다.

![fig20](cs231n/06-20.png){: style="display:block; margin:0 auto; width:100%;"}

시각화를 한 결과, 가중치의 평균과 표준편차가 점점 커져 발산하는 것을 볼 수 있다.

### Kaiming He Initialization

ReLU 함수를 사용할 때 신호가 layer를 지나면서 사라지거나 폭발하지 않도록, 가중치를 평균이 $0$, 표준편차가 $\sqrt{\frac{2}{n_{in}}}$인 가우시안 분포를 따르도록 초기화하는 것을 제안하였다.

$$
W\sim \mathcal{N}(0,\sqrt{\frac{2}{n_{in}}})
$$

- $n_{in}$은 입력 노드의 개수이다.

```python
dims = [4096] * 7
hs = []
x = np.random.rand(16, dims[0])

for Din, Dout in zip(dims[:-1], dims[1:]):
    # 
    W = np.random.randn(Din, Dout) * np.sqrt(2/Din)
    x = np.maximum(0, x.dot(W))
    hs.append(x)
```

![fig21](cs231n/06-21.png){: style="display:block; margin:0 auto; width:100%;"}

시각화를 한 결과, layer를 거쳐도 가중치의 평균과 표준편차가 유지되는 것을 볼 수 있다.

# How to train CNNs?

## Data Preprocessing for Image

이미지에 대한 전처리는 매우 간단하다.

각 RGB 채널의 평균과 표준편차를 계산해 normalizaiton을 수행하면 된다.

특정 데이터셋에서 미리 계산된 값을 이용할 수도 있다. 가장 일반적인 것은 ImageNet의 평균과 표준편차를 이용하는 것이다.

## Data Augmentation

데이터 세트의 크기를 증가시키는 것으로, 오버피팅을 방지할 수 있다.

![fig22](cs231n/06-22.png){: style="display:block; margin:0 auto; width:100%;"}

데이터를 증강하는 방법에는 여러 가지가 있다.

### Horizontal Flips

이미지를 수평으로 뒤집는 방법이다.

![fig23](cs231n/06-23.png){: style="display:block; margin:0 auto; width:60%;"}

### Random crops and scales

원본 이미지의 크기를 다양하게 조절한 뒤, 그중 일부를 무작위로 잘라내는 방법이다. 과정은 아래와 같다.

1. $[256,480]$ 사이에서 랜덤하게 $L$ 값을 선택한다.
2. 이미지의 가로, 세로 중 짧은 부분을 $L$로 설정하고, 긴 부분을 비율에 맞게 조정한다. 

    예를 들어 $L=300$일 때, $240\times360$ 크기의 이미지는 $300\times450$으로 scaling된다.
3. 랜덤한 위치를 선택해 특정 크기로 (예를 들어 $224\times 224$) 잘라낸다.

이 방법을 통해서 모델은 고양이의 얼굴만 크게 확대된 이미지, 몸통 일부만 보이는 이미지 등 다양한 상황을 학습할 수 있다.

![fig24](cs231n/06-24.png){: style="display:block; margin:0 auto; width:40%;"}

### Color Jitter

이미지의 대비와 밝기 등 색상과 관련된 속성값을 랜덤하게 조절하는 방법이다.

![fig25](cs231n/06-25.png){: style="display:block; margin:0 auto; width:60%;"}

### Cutout

이미지의 특정 영역을 랜덤으로 선택하여 검은색 또는 회색 사각형으로 가려버리는 방법이다.

![fig26](cs231n/06-26.png){: style="display:block; margin:0 auto; width:60%;"}

## Transfer Learning

전이 학습 (Transfer Learning)은 이미 학습된 모델의 지식을 이용해 새로운 문제에 활용하는 기법을 의미한다.

처음부터 모든 걸 학습하지 않기 때문에 빠르고 효율적인 학습이 가능하다.

![fig27](cs231n/06-27.png){: style="display:block; margin:0 auto; width:90%;"}

먼저 ImageNet에 대해 학습된 모델을 가져온다.

**Feature Extractor로 사용 (2번 case)**

사전 학습된 모델의 앞부분 layer의 가중치를 고정시키고 뒷부분 layer만 새롭게 학습시키는 방식으로, 마지막 layer의 출력 크기만 클래스 개수에 맞게 조정하면 된다.

CNN의 경우 conv layer는 고정하고 마지막 분류기 layer만 새 데이터에 맞게 학습하면 된다.

주로 추가로 학습시킬 데이터셋이 적을 때 사용한다. 하지만 대부분의 layer를 고정하기 때문에 당연히 ImageNet과 유사한 데이터셋에 대해서 가장 좋은 성능이 나타날 수밖에 없다.

**Fine-tuning (3번 case)**

사전 학습된 모델의 가중치를 초기값으로 사용하며, 전체 또는 일부 layer를 다시 학습시키는 방식이다.

주로 추가로 학습시킬 데이터셋이 클 때 사용한다.

![fig28](cs231n/06-28.png){: style="display:block; margin:0 auto; width:90%;"}

4가지 상황에 따른 학습 전략이 있다.

- **추가로 학습시킬 데이터셋이 적고, 사전학습 때 사용한 데이터셋과 비슷한 경우**

    모든 layer에 대해 fine-tuning하면 오버피팅의 위험이 있으므로 마지막 layer만 학습시키는 것이 효율적이다.
- **추가로 학습시킬 데이터셋이 많고, 사전학습 때 사용한 데이터셋과 비슷한 경우**

    모든 layer에 대해 fine-tuning하는 것이 효율적이다.
- **추가로 학습시킬 데이터셋이 적고, 사전학습 때 사용한 데이터셋과 다른 경우**
    
    다른 모델을 선택하는 것이 낫다.
- **추가로 학습시킬 데이터셋이 많고, 사전학습 때 사용한 데이터셋과 다른 경우**

    모델을 처음부터 학습시킨 것이 좋을 수도 있고, fine-tuning한 것이 좋을 수도 있다. 즉, 어떠한 방법이 더 좋은지 보장할 수 없다.

## Hyperparameter Selection

적절한 하이퍼파라미터를 선택하는 과정은 아래와 같다.

**1. 초기 loss값을 확인한다. (Check initial loss)**

예를 들어, 클래스가 10개인 분류 문제에서 Softmax를 쓴다면 초기 손실 값은 이론적으로 $-\ln(1/10)\approx2.3$ 근처에서 시작해야 한다. 만약 초기 loss값이 너무 높거나 낮다면, 문제가 있을 가능성이 높다.

**2. 작은 샘플에 과적합시키기 (Overfit a small sample)**

전체 데이터 중 아주 일부만 가지고 모델을 학습시켜 손실을 0에 가깝게, 정확도를 100%까지 도달되는지 확인한다. 이를 통해 모델이 최소한의 학습 능력을 갖추었는지 확인할 수 있다.

**3. loss가 감소하는 학습률 찾기 (Find LR that makes loss go down)**

아주 작은 학습률에서 시작하여, 점차 키워가면서 loss 값이 안정적으로 감소하기 시작하는 학습률의 범위를 찾는다.

**4. 넓은 범위에서 짧게 학습 (Coarse grid, train for ~1-5 epochs)**

앞서 찾은 학습률을 포함하여, Regularization 파라미터 등 다른 하이퍼파라미터들의 범위를 넓게 설정하고 여러 조합을 만든다. 이후 해당 조합들을 가지고 1~5epoch 정도로 짧게만 학습시켜 후보 범위를 찾는다.

좋지 않은 하이퍼파라미터 조합은 보통 초반 에폭에서부터 성능이 좋지 않기 때문에 오래 학습시키지 않아도 빠르게 걸러낼 수 있다.

**5. 좁은 범위에서 길게 학습 (Refine grid, train longer)**

4단계에서 성능이 좋았던 상위 몇 개의 조합을 선택하고, 해당 범위 내에서 조합을 다시 만들어 더 길게 학습시킨다.

이때 짧은 학습에서는 보이지 않았던 미세한 성능 차이를 확인한다.

**6. 손실 및 정확도 곡선 확인 (Look at loss and accuracy curves)**

학습 과정 동안 손실과 정확도 곡선을 기록 및 시각화하여 분석한다.

- train acc와 valid acc의 차이가 존재하지만 정확도가 꾸준히 증가하고 있다.

    ![fig29](cs231n/06-29.png){: style="display:block; margin:0 auto; width:50%;"}

    이 경우 모델을 더 오래 학습시켜 경과를 본다.

- train acc는 증가하지만 valid acc는 감소하기 때문에 오버피팅이 발생한 것으로 볼 수 있다.

    ![fig30](cs231n/06-30.png){: style="display:block; margin:0 auto; width:60%;"}

    이 경우 regularization을 적용하거나 데이터를 더 모아야 한다.

- train acc와 valid acc의 차이가 거의 없이 꾸준히 증가하고 있다.

    ![fig31](cs231n/06-31.png){: style="display:block; margin:0 auto; width:60%;"}

    만약 학습을 오래해도 더이상 정확도의 증가가 없다면 더 큰 모델로 바꿔본다.

**7. 5번 단계로 돌아가 반복 (GOTO step 5)**

다른 하이퍼파라미터 조합에 대해 다시 반복한다.

### Grid search vs Random search

일반적으로 random search가 grid search보다 더 효율적인 경우가 많다.

![fig32](cs231n/06-32.png){: style="display:block; margin:0 auto; width:60%;"}

- **Grid search**: 사용자가 지정한 하이퍼파라미터 값들의 모든 가능한 조합을 하나도 빠짐없이 탐색하는 방법이다.
- **Random search**: 사용자가 지정한 하이퍼파라미터의 범위 내에서 지정된 횟수만큼 랜덤으로 조합을 선택하여 탐색하는 방법이다.

    랜덤으로 탐색하기 때문에 최적의 값을 반드시 찾는다는 보장은 없지만, 실제로 grid search보다 더 좋은 결과를 더 빨리 찾는 경우가 많다.
