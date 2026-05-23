---
title: "[정규화] Regularization"
date: 2025-02-15 00:00:00 +/-TTTT
categories: [AI, 머신러닝 / 딥러닝]
tags: [딥러닝, 정규화]
math: true
toc: true
author: sunho
---

Regularization은 <span style="background-color:#fff5b1">모델이 학습 데이터에 너무 오버피팅되는 것을 방지</span>하는 기법이다.

## L1 / L2 Regularization

손실 함수에 정규화 term $R(W)$를 추가하는 방법이다.
<br>
이 추가되는 정규화 term의 형태에 따라 L1, L2로 분류된다.

$$
L(W)=\underbrace{\frac{1}{N}\sum_{i=1}^NL_i(f(x_i,W),y_i)}_{\text{Data loss}}+\underbrace{\lambda R(W)}_{\text{Regularization}}
$$

**Data loss**

모델이 학습 데이터에 대해 올바른 예측을 하도록 유도한다.

**Regularization**

정규화 term은 파라미터의 크기에 대한 패널티로 구성된다. 이로 인해 모델은 학습 과정에서 Data loss를 최소화하는 동시에, 가중치의 크기 또한 작게 유지하도록 유도된다.

가중치의 크기가 크다는 것은 모델의 출력이 특정 입력 특징의 작은 변화에도 매우 민감하게 반응한다는 의미이다.

따라서 가중치의 크기가 커지는 것을 방지한다는 것은 모델이 복잡해지는 것을 방지해 단순하고 안정적인 모델을 만든다는 뜻이다.

<details>
<summary><font color='#FF0000'>Example 1</font></summary>
<div markdown="1">

아래의 가중치 행렬에서 첫 번째 행은 '눈', 두 번째 행은 '코', 세 번째 행은 '입'의 특징을 감지한다고 해보자.

$$
W\mathbf{x}=
\begin{bmatrix}5&5&5&5\\1&1&1&1\\1&1&1&1\end{bmatrix}
\begin{bmatrix}2\\1\\3\\1\end{bmatrix}
=\begin{bmatrix}35\\7\\7\end{bmatrix}
$$

위 가중치 행렬에서 '눈'에 대한 가중치 크기가 매우 크다. 이는 모델이 '눈'을 감지하는 특징에 매우 민감하게 반응하며, '눈'의 정보를 다른 정보보다 훨씬 더 중요하게 증폭해서 받아들인다는 의미이다.

만약 입력 $\mathbf{x}$의 값이 $[2, 1, 3, 1]$이 아니라 노이즈가 낀 $[2, 1, 3, 1.1]$로 약간만 변해도, '코'와 '입'의 출력은 $0.1$만큼 변하지만, '눈'의 출력은 $0.5$만큼 변한다. 즉, '눈' 특징이 입력의 사소한 변화나 노이즈에도 크게 휘둘린다.

또한 모델이 학습 데이터의 '눈' 특징에 섞인 노이즈까지 증폭해서 학습하게 되면, 오버피팅으로 이어지게 된다.

---

</div>
</details>

### L1 Regularization (LASSO)

L1 정규화 공식은 아래와 같으며, 가중치에 L1 Norm을 적용한다.

$$
R(W)=\sum_k\sum_l\lvert W_{k,l}\rvert
$$

위 수식에서 $k$는 행 인덱스, $l$은 열 인덱스를 의미한다. 즉, 가중치 행렬 $W$ 내의 모든 개별 가중치 값의 절대값을 모두 더한다는 의미이다.

가중치가 2개일 때, L1의 패널티 영역은 마름모 형태로 나타난다.

$$
\lvert W_1\rvert+\lvert W_2\rvert\leq C
$$

![fig1](AI/ML-DL/Regularization-1.png){: style="display:block; margin:0 auto; width:50%;"}

여기서 타원 형태의 등고선은 데이터 손실 함수를 시각화한 것으로, 각 등고선은 동일한 손실 값을 갖는 지점들을 연결한 선이다.

타원의 중심이 손실 값이 가장 낮은 지점 (최적해)이며, 바깥쪽으로 퍼질수록 손실 값이 높아진다.

### L2 Regularization (Ridge)

L2 정규화 공식은 아래와 같으며, 가중치에 L2 Norm을 적용한다.

$$
R(W)=\sum_k\sum_lW^2_{k,l}
$$

위 수식에서 $k$는 행 인덱스, $l$은 열 인덱스를 의미한다. 즉, 가중치 행렬 $W$ 내의 모든 개별 가중치 값의 제곱값을 모두 더한다는 의미이다.

가중치가 2개일 때, L1의 패널티 영역은 원 형태로 나타난다.

$$
W_1^2+W_2^2\leq C
$$

![fig2](AI/ML-DL/Regularization-2.png){: style="display:block; margin:0 auto; width:50%;"}

### L1 정규화 vs L2 정규화

정규화 term이 있다면, 아래 그림처럼 패널티 영역 안에서 손실 값이 가장 낮은 지점 (검은색 점)을 찾아야 한다.

![fig3](AI/ML-DL/Regularization-3.png){: style="display:block; margin:0 auto; width:70%;"}
_[[출처]](https://www.linkedin.com/pulse/intuitive-visual-explanation-differences-between-l1-l2-xiaoli-chen/)_

만약 패널티 영역을 더 줄이면 어떻게 될까?

패널티 영역을 줄인다는 것은 모델에 더 큰 제약을 가한다는 뜻이다. ($\lambda$ 값을 키운다는 의미와 동일)

L1 정규화의 경우, 패널티 영역을 줄일수록 축 위에서 최적해를 찾을 확률이 높아진다. 이는 최적화 과정에서 중요도가 낮은 특징의 가중치를 정확히 $0$으로 만드는 특징 선택 (feature selection) 효과로 이어진다.

L2 정규화의 경우, 패널티 영역을 줄여도 원의 둥근 형태 때문에 축 위에서 최적해를 만날 확률이 낮다. 즉, 특정 가중치를 $0$으로 제거하기보다는, 전체적인 가중치 값을 $0$에 가깝게 작게 유지하도록 유도하는 가중치 감쇠 (weight decay) 효과로 이어진다.

![fig4](AI/ML-DL/Regularization-4.png){: style="display:block; margin:0 auto; width:70%;"}
_[[출처]](https://www.linkedin.com/pulse/intuitive-visual-explanation-differences-between-l1-l2-xiaoli-chen/)_

#### 접점 (Tangent Point)

L1의 페널티 영역은 마름모 형태이기 때문에 면과 꼭짓점으로 구성된다.
면은 기울기가 상수로 고정되어 있고, 꼭짓점은 미분이 정의되지 않는다.

만약 손실 함수가 필요로 하는 접점의 기울기가 $-0.5$인데, L1 마름모의 면이 기울기 $-1$만 제공할 수 있다면, 둘은 면에서는 절대 만날 수 없다.
따라서, 남은 선택지인 꼭짓점에서 만나게 된다.

L2의 패널티 영역은 원 형태이기 때문에, 표면의 모든 지점에서 기울기가 항상 정의되고 연속적으로 변한다.

손실 함수가 최적의 해를 찾기 위해 어떤 기울기를 가진 접점을 필요로 하든, L2의 원은 표면 위 어딘가에서 그에 정확히 일치하는 기울기를 가진 지점을 항상 찾아낼 수 있다. 따라서 이 지점은 축 위에 존재할 확률은 매우 낮다.

## Dropout

Dropout은 오버피팅을 방지하기 위해 MLP에서 학습 중에 확률적으로 뉴런을 꺼서 모델이 특정 뉴런에 오버피팅되는 것을 막는 기법이다.

Dropout에서 사용되는 하이퍼파라미터 $p$는 뉴런이 제거될 확률이다. 즉, 뉴런이 살아남을 확률은 $1-p$이다.

매번 다른 뉴런이 꺼지기 때문에 일종의 앙상블 학습 효과를 낸다.

![fig5](AI/ML-DL/Regularization-5.png){: style="display:block; margin:0 auto; width:80%;"}
_출처: Stanford CS231n, Lecture 6 (CNN Architectures)_

### 추론 단계에서의 Dropout

추론 때에도 dropout을 적용하면 같은 이미지를 넣어도 매번 출력이 달라지기 때문에 예측의 일관성이 없어진다. 따라서 dropout은 학습에서만 사용하고 추론 단계에서는 사용하지 않는다.

하지만 학습에서만 사용할 경우 학습과 테스트 때 활성된 뉴런의 개수가 달라지기 때문에 각 뉴런의 출력값의 스케일이 달라지는 현상이 발생한다.

이러한 현상을 방지하기 위해 학습 때 출력값에 $\frac{1}{1-p}$를 곱해서 학습과 추론 때의 출력 분포가 동일하도록 맞춘다.

<details>
<summary><font color='#FF0000'>Example 2</font></summary>
<div markdown="1">

$p=0.5$의 Dropout 적용했을 때, 신경망의 출력값은 $2$가 된다.

$$
\mathbf{x}^\top\mathbf{w}=
\begin{bmatrix}1\\1\\1\\1\end{bmatrix}
\begin{bmatrix}1&0&1&0\end{bmatrix}=2
$$

추론 때는 Dropout을 적용하지 않기 때문에, 신경망의 출력값은 $4$가 된다.

$$
\mathbf{x}^\top\mathbf{w}=
\begin{bmatrix}1\\1\\1\\1\end{bmatrix}
\begin{bmatrix}1&1&1&1\end{bmatrix}=4
$$

학습과 추론 때의 출력 스케일이 다르기 때문에, 학습 때 출력값에 $\frac{1}{1-0.5}=2$를 곱해서 스케일을 맞춘다.

---

</div>
</details>
