---
title: "[논문리뷰] An Image is Worth One Word: Personalizing Text-to-Image Generation using Textual Inversion"
date: 2025-01-11 00:00:00 +/-TTTT
categories: [AI, 논문리뷰]
tags: [Multimodal, Diffusion, Image Generation]
math: true
toc: true
author: sunho
description: 📝 ICLR 2023
---

[[Paper]](https://arxiv.org/abs/2208.01618)
[[GitHub]](https://github.com/rinongal/textual_inversion)

<details>
<summary><font color='#FF8C00'>📝 Summary</font></summary>
<div markdown="1">
<br>
사전학습된 생성 모델과 텍스트 인코더를 건드리지 않고, 해당 모델의 텍스트 임베딩 공간 내에서 새로운 개념을 찾는 것이 목표이다.
- 표현하길 원하는 단어를 pseudo-word $S_*$로 표기한 후 텍스트 인코더에 입력
- 해당 단어에 대응되는 임베딩 벡터 $v_*$에 대해서만 최적화

</div>
</details>
<br>

![fig0](paper/text_inv-0.png){: style="display:block; margin:0 auto; width:100%;"}

## Introduction

**기존 연구들의 한계점**

- T2I 모델은 사용자가 원하는 대상을 텍스트로 얼마나 잘 설명하느냐에 의해 그 활용이 제한된다.
- 대규모 모델에 새로운 개념을 도입하는 일은 어렵다.
    - 매번 새로운 개념마다 모델을 다시 학습시키는 것은 비용이 많이 든다.
    - 소수의 예시로 파인튜닝을 하면 기존 지식을 망각하는 catastrophic forgetting 문제가 발생한다.

**제안하는 방법**

- 사용자가 제공한 개념을 통해 새로운 이미지를 만드는 personalized text-to-image generation이라는 새로운 task를 제안한다.
- 사전학습된 T2I 모델의 텍스트 임베딩 공간 안에서 새로운 단어(pseudo-word)를 찾는 방법을 제안한다. 즉, 새로운 개념을 나타낼 수 있는 새로운 임베딩 벡터를 찾는 것이 목표이다.
- 생성 모델 자체는 건드리지 않기 때문에 기존 모델의 텍스트 이해력과 일반화 능력을 보존할 수 있다.

## Methods

![fig1](paper/text_inv-1.png){: style="display:block; margin:0 auto; width:100%;"}

### 1. Latent Diffusion Models

본 연구에서는 LDM을 사용하였다.

$$
L_{LDM} := \mathbb{E}_{z \sim \mathcal{E}(x),\, y,\, \epsilon \sim \mathcal{N}(0,1),\, t} \left[ \left\| \epsilon - \epsilon_\theta(z_t, t, c_\theta(y)) \right\|_2^2 \right]

$$

텍스트 인코더 $c_\theta$로는 BERT를 사용하였고, $y$는 텍스트 임베딩을 의미한다.

학습 중에 $c_\theta$와 $\epsilon_\theta$는 함께 최적화된다.

### 2. Text Embeddings

입력 문자열의 각 단어나 sub-word(단어의 일부)는 토큰으로 변환되며, 이 토큰들은 미리 정의된 dictionary 내의 인덱스이다.

각 토큰은 고유한 임베딩 벡터와 연결되어 있으며, 이 벡터는 인덱스를 기반으로 조회하여 가져올 수 있다.

학습하고자 하는 새로운 개념을 나타내기 위해 대체 문자열(placeholder string) $S_*$를 지정하고, 이에 대응되는 임베딩 벡터 $v_*$를 출력하도록 하여 개념을 어휘에 주입한다.

### 3. Textual Inversion

새로운 임베딩 $v_*$를 찾기 위해 3~5장의 소량의 이미지를 사용한다.

$$
v_* =\underset{v}{ \arg\min}~\mathbb{E}_{z \sim \mathcal{E}(x),\, y,\, \epsilon \sim \mathcal{N}(0,1),\, t} \left[ \left\| \epsilon - \epsilon_\theta(z_t, t, c_\theta(y)) \right\|_2^2 \right]
$$

생성 모델과 텍스트 인코더의 가중치는 고정하고, 위의 LDM loss를 최소화하도록 $v_*$만 최적화한다.

즉, 주어진 입력 이미지를 재구성하도록 $S_*$에 대응되는 최적의 텍스트 임베딩 $v_*$를 찾는 것이 목표이다.

일반적인 T2I 모델은 텍스트를 입력으로 주면 그와 대응되는 이미지를 만들지만, textual inversion에서는 이미지를 주고, 그 이미지를 가장 잘 설명할 수 있는 텍스트 임베딩을 역으로 찾아내기 때문에 inversion이라고 부른다.

## Experiments

### Qualitative Comparisons and Applications

**Image variations**

![fig2](paper/text_inv-2.png){: style="display:block; margin:0 auto; width:100%;"}

<br>
제안한 방법을 2개의 baseline과 비교하였다.
- LDM: 사람이 작성한 짧은 caption과 긴 caption을 조건으로 입력
- DALLE-2: 이미지와 사람이 작성한 긴 caption을 조건으로 입력

**Style transfer**

![fig3](paper/text_inv-3.png){: style="display:block; margin:0 auto; width:100%;"}

<br>
Textual-embedding space는 스타일과 같은 추상적인 개념도 표현할 수 있다.

이때, 스타일이 공유된 몇 장의 이미지와 "A painting in the style of $S_*$" 형식의 프롬프트를 통해 학습을 진행한다.

### Quantitative Analysis

![fig4](paper/text_inv-4.png){: style="display:block; margin:0 auto; width:100%;"}
<br>

왼쪽은 CLIP-based 평가, 오른쪽은 user study이다.