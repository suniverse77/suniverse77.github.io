---
title: "[트랜스포머] 트랜스포머의 구조 2 - 임베딩 (Embedding)"
date: 2025-02-15 06:00:00 +/-TTTT
categories: [AI, 트랜스포머]
tags: [트랜스포머]
math: true
toc: true
author: sunho
---

**📄 관련 논문:** [NeurIPS 2017] [Attention Is All you Need](https://arxiv.org/abs/1706.03762)

## Overview

![fig1](AI/Transformer/Transformer-1.png){: style="display:block; margin:0 auto; width:40%;"}

## Input 단계

컴퓨터는 인간의 언어인 텍스트를 직접 이해할 수 없고 오직 숫자 형태의 데이터만 연산할 수 있다.
<br>
따라서 자연어 문장을 모델에 입력하기 전, 텍스트를 컴퓨터가 처리할 수 있는 숫자로 변환하는 과정이 필요하다.

![fig2](AI/Transformer/Transformer-2.png){: style="display:block; margin:0 auto; width:40%;"}

### 토큰화 (Tokenization)

토큰화는 연속된 문자열을 특정한 기준에 따라 모델이 처리할 수 있는 최소 의미 단위로 분리하는 작업을 의미한다.

이때, 분리된 각각의 조각을 토큰(Token)이라고 부른다.
<br>
토큰을 분리하는 기준에 따라 크게 세 가지 방식으로 나눌 수 있다.

- **단어 단위 토큰화:** 띄어쓰기나 구두점을 기준으로 문장을 분리하는 방식이다.

    ```
    I love playing football. -> I / love / playing / football / .
    ```

- **문자 단위 토큰화:** 텍스트를 개별 알파벳이나 문자 단위로 모두 쪼개는 방식이다.

    ```
    I love playing football. -> I /  / l / o / v / ... / b / a / l / l / .
    ```

- **서브워드(Subword) 단위 토큰화:** 자주 등장하는 단어는 하나의 토큰으로 유지하고, 희귀 단어나 복합어는 더 작은 의미 단위인 Subword로 쪼개는 방식이다. 현대 트랜스포머 기반 모델에서 표준으로 채택하는 방식이다.

    ```
    I love playing football. -> I / love / play / ##ing / foot / ##ball / .
    ```

이렇게 생성된 토큰들은 이후 Vocabulary의 목록을 참조하여 각각 고유한 정수 ID로 매핑된다. (Vocabulary는 미리 정의해놓은 단어 모음집임)

만약 입력된 토큰이 Vocabulary에 존재하지 않는다면, 해당 단어는 `UNK` (Unknown) 토큰으로 대체된다.

![fig3](AI/Transformer/Transformer-3.png){: style="display:block; margin:0 auto; width:80%;"}

### 토큰 임베딩 (Token Embedding)

앞서 토큰화 과정으로 얻은 정수 ID는 단지 단어 사전에 등록된 인덱스 번호일 뿐이므로, 그 자체만으로는 모델 내부에서 유의미한 연산을 수행할 수 없다.
<br>
따라서 정수 ID를 연속적인 실수 벡터로 변환하는 과정이 필요한데, 이 역할을 수행하는 행렬을 임베딩 행렬이라고 부른다.

$$\vphantom{\Big(}
W_E\in\mathbb{R}^{N_{\text{word}}\times D}
\tag{1}
$$

여기서 $N_{\text{word}}$는 Vocabulary에 존재하는 전체 토큰 개수, $D$는 하나의 토큰을 표현할 차원의 크기를 의미한다.

수학적으로 특정 토큰의 임베딩 벡터 $\mathbf{e}_i$를 구하는 과정은 다음과 같이 해당 토큰의 One-hot Vector $\mathbf{x}_i$와 임베딩 행렬 $W_E$의 곱으로 표현할 수 있다.

$$
\mathbf{e}_i=\mathbf{x}_i\cdot W_E
,\quad\text{where }\mathbf{x}_i\in\mathbb{R}^{1\times N_{\text{word}}}
\tag{2}
$$

하지만 대부분의 요소가 0이고 단 하나만 1인 One-hot Vector를 거대한 행렬에 직접 곱하는 것은 메모리와 연산량 측면에서 매우 비효율적이다.
<br>
따라서 실제 구현에서는 행렬 곱셈 연산을 수행하는 대신, 정수 ID를 인덱스로 삼아 임베딩 행렬의 특정 행을 그대로 읽어오는 Look-up 방식을 사용한다.

예를 들어 토큰화를 통해 `love` 라는 단어가 정수 ID `1`로 변환되었다면, 모델은 임베딩 행렬의 1번째 행에 저장되어 있는 벡터를 그대로 가져온다.
<br>
이렇게 추출된 벡터가 바로 `love`의 임베딩 벡터가 된다.

![fig3](AI/Transformer/Transformer-4.png){: style="display:block; margin:0 auto; width:80%;"}

초기 생성 시 임베딩 행렬의 가중치는 무작위 실수 값으로 채워져 있지만, 학습을 통해 점차 단어의 고유한 의미를 반영하도록 최적화된다.

아래 그림은 $D=3$인 경우의 토큰 임베딩 공간을 시각화한 예시이다.

![fig5](AI/Transformer/Transformer-5.png){: style="display:block; margin:0 auto; width:60%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=wjZofJX0v4M&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=6)_

토큰 임베딩이 학습이 성공적으로 완료되었다면, 단어 간의 의미적 관계가 벡터 연산으로 성립하게 된다.

위의 그림처럼 `여왕` 임베딩과 `왕` 임베딩의 차이인 $E(\text{queen})-E(\text{king})$는 `여자` 임베딩과 `남자` 임베딩의 차이인 $E(\text{woman})-E(\text{man})$와 유사한 방향과 크기를 가질 것이다.
<br>
이를 통해 두 벡터의 차이를 나타내는 주황색 벡터는 `여성성` 이라는 특정한 성별의 의미를 담고 있음을 알 수 있다.
<br>
이는 곧 우리가 `여왕` 임베딩에 대한 정보가 없더라도, `왕` 임베딩에 주황색 벡터를 더함으로써 `여왕` 임베딩을 근사적으로 얻을 수 있다는 말이 된다.

## Transformer Block

토큰 임베딩만으로는 단어의 고유한 의미만 알 수 있지, 단어 간의 문맥적 관계는 파악할 수 없다.
<br>
이 문제를 해결하기 위해 도입한 것이 Attention 메커니즘이다.

![fig6](AI/Transformer/Transformer-6.png){: style="display:block; margin:0 auto; width:40%;"}

### Attention

Attention은 각 단어의 의미를 더 정교하게 만드는 것뿐만 아니라, 하나의 임베딩이 다른 임베딩으로부터 필요한 정보를 선택적으로 받아들일 수 있도록 도와준다. 즉, 문맥에 따라 단어의 표현을 업데이트하는 역할을 한다.

$$
\text{Attention}(Q,K,V)=\text{softmax}\left(\frac{QK^\top}{\sqrt d_k}\right)V
\tag{3}
$$

여기서 $Q$는 Query, $K$는 Key, $V$는 Value를 의미한다.

### Multi-Head Attention



### Self-Attention & Cross-Attention



### Masked Self-Attention



## Output 단계
