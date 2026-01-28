---
title: "확산 모델 (Diffusion Model)"
date: 2025-10-05 00:00:00 +/-TTTT
categories: [AI, 생성 모델]
tags: [생성 모델]
math: true
toc: true
author: sunho
---

## 직관적 이해

Diffusion 모델은 간단하게, 깨끗한 상태의 이미지를 점진적으로 파괴하여 무작위 노이즈로 만드는 과정을 역으로 학습함으로써, 노이즈에서 깨끗한 이미지로 복원해 나가는 방법을 배우는 생성 모델이다.

![fig1](AI/Generative/Diffusion-1.png){: style="display:block; margin:0 auto; width:80%;"}
_[[출처]](https://www.researchgate.net/figure/The-forward-and-backward-processes-of-the-diffusion-model-The-credit-of-the-used-images_fig1_382128283)_

### Forward process (Diffusion process)

Forward process는 깨끗한 상태의 이미지의 형체를 조금씩 깎아내면서 동시에 표준 가우시안 노이즈를 추가해서, 최종적으로 아무런 정보가 남지 않은 표준 가우시안 분포로 변환하는 과정이다.

예를 들어, 2차원 데이터 $(x_1,x_2)$가 있을 때 '개' 데이터는 $(10,20)$, '고양이' 데이터는 $(5,25)$ 부근에 모여 있다고 가정하자.

그럼 $(10,20)$ 지점에서 '개'일 확률이 압도적으로 높고, 주변으로 갈수록 급격히 낮아지는 형태일 것이다.

![fig2](AI/Generative/Diffusion-2.png){: style="display:block; margin:0 auto; width:80%;"}
_[[출처: Julia Turc]](https://www.youtube.com/watch?v=R0uMcXsfo2o&list=PL7x3-Ea6TrJQQjG9FIxQM3U0UFWgXCV0Z&index=2)_

Forward process는 이런 뾰족한 형태의 언덕을 표준 가우시안 분포로 변형시키기 위해, 각 데이터에 매 step $t$마다 아래의 행동을 수행한다.

- **노이즈 추가:** 데이터들의 분산을 $1$로 맞춰, 언덕을 완만하게 퍼뜨림
- **신호 축소:** 데이터들의 평균을 $0$으로 맞추기 위해, 중심을 원점으로 이동시킴

즉, $t=0\sim T$에서 데이터 분포 지형이 매 step마다 바뀐다고 생각하면 된다.

![fig3](AI/Generative/Diffusion-3.png){: style="display:block; margin:0 auto; width:80%;"}
_[[출처: Julia Turc]](https://www.youtube.com/watch?v=R0uMcXsfo2o&list=PL7x3-Ea6TrJQQjG9FIxQM3U0UFWgXCV0Z&index=2)_

### Reverse process (Sampling)

Reverse process는 무질서 상태의 표준 가우시안 분포에서 시작해서, 원래의 깨끗한 이미지로 복원해가는 과정이다.

직관적으로 설명하자면, 공간상에 무작위로 흩뿌려진 점들이 '개, 고양이' 같은 특정 데이터 군집이 모여 있는 언덕을 향해 이동하는 과정이라 할 수 있다.

예를 들어, '개' 데이터를 생성한다고 가정해보자.

앞서 Forward process에서 데이터 분포 지형 (확률 지형)이 $t=0$에서 $t=T$로 갈수록 완만해진다고 했다.

Reverse process에서는 $t=T$일 때, 매우 넓게 퍼진 확률 지형을 따라 대략적인 방향을 잡고 이동한다. 이후 $t=50, 49 \dots$ 로 시간이 흐름에 따라 매 순간 변화하는 지형의 경사를 따라가며, 최종적으로는 '개' 데이터가 밀집된 $(10,20)$ 지점 부근에 안착하게 된다.

![fig3](AI/Generative/Diffusion-4.gif){: style="display:block; margin:0 auto; width:80%;"}
_[[출처: Julia Turc]](https://www.youtube.com/watch?v=R0uMcXsfo2o&list=PL7x3-Ea6TrJQQjG9FIxQM3U0UFWgXCV0Z&index=2)_

왜 $t=T$로 갈수록 완만해지게 설계했을까?

실제 데이터는 전체 픽셀 공간에서 매우 좁은 영역을 차지하므로, 입자가 데이터와 멀리 떨어진 임의의 지점에 놓이면 어느 방향으로 가야 데이터 언덕이 나오는지 알 수 없는 상황이 발생한다.

이를 해결하기 위해 $t=T$에서 지형 구조를 의도적으로 넓게 확장하여, 어느 위치에서든 높은 확률 지역을 찾아갈 수 있는 일반적인 방향 감각을 학습하도록 한다. 이렇게 대략적인 길을 따라가다가 $t=0$에 가까워질수록 급격히 뾰족해지는 언덕을 타고 데이터의 세밀한 특징을 찾아갈 수 있도록 한 것이다.

## 수식적 정의

### Forward process

### Reverse process

## 실제 코드 구현
