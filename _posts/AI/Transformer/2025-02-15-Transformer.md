---
title: "[트랜스포머] 트랜스포머 (Transformer)"
date: 2025-02-15 00:00:00 +/-TTTT
categories: [AI, 트랜스포머]
tags: [트랜스포머]
math: true
toc: true
author: sunho
---

**📄 관련 논문:** [NeurIPS 2017] [Attention Is All you Need](https://arxiv.org/abs/1706.03762)

## Overview

트랜스포머의 아키텍처는 아래와 같으며, 크게 인코더와 디코더로 이루어져 있다.

![fig1](AI/Transformer/Transformer-1.png){: style="display:block; margin:0 auto; width:60%;"}

인코더는 입력 문장을 이해하고 의미 정보를 요약하며, 디코더는 인코더가 전달한 의미 정보를 이용해 적절한 출력 문장을 생성한다.

예를 들어, 아래의 문제를 수행하는 트랜스포머 모델의 동작 방식은 아래와 같다.

**질문에 답을 해주는 모델**

`'오늘 날씨 어때?'`라는 질문을 하면 해당 문장은 인코더의 입력으로 들어간다. 인코더는 질문의 의미를 파악하여 하나의 요약본인 문맥 벡터 (Context Vector)를 출력한다.

디코더는 인코더가 전달한 문맥 벡터를 바탕으로, 답변의 가장 적절한 첫 번째 단어 `'오늘'`을 출력한다.

이후 디코더는 지금까지 생성된 단어 `'오늘'`을 다시 입력으로 받아, 질문과 현재까지의 출력 `'오늘 날씨 어때?' + '오늘'`을 함께 고려하여 다음에 올 단어 `'서울의'`를 출력한다.

그다음 디코더는 `'오늘 날씨 어때? + '오늘 서울의'`를 함께 고려하여 다음 단어 `'날씨는'`을 출력한다.

이러한 과정을 반복하여 최종적으로 `'오늘 서울의 날씨는 화창합니다.'`라는 답변을 완성한다.

**번역 모델**

번역 모델도 위의 과정과 동일하다.

한글 → 영어 번역에서 `'나는 학생이다.'`라는 문장이 인코더의 입력으로 들어오면, 디코더는 `'I'`를 출력한다.

이후 디코더는 `'나는 학생이다.' + 'I'`를 함께 고려하여 다음에 올 단어 `'am'`을 출력한다.

이러한 과정을 반복하여 최종적으로 `'I am a student.'`라는 번역본을 완성한다.

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

토큰 임베딩만으로는 단어의 고유한 의미만 알 수 있을 뿐, 문장 내에서 단어 간의 문맥적 관계는 파악할 수 없다.
<br>
이 문제를 해결하기 위해 도입한 기술이 Attention 메커니즘이다.

![fig6](AI/Transformer/Transformer-6.png){: style="display:block; margin:0 auto; width:40%;"}

### Attention

Attention은 현재 문맥을 반영하여, 각 단어의 의미를 더 정교하게 다듬는 역할을 한다.

수학적으로는 $N$개의 토큰 임베딩으로 구성된 입력 행렬 $E$가, Attention을 거쳐 문맥이 반영된 새로운 행렬 $E'$로 변환되는 과정이다.

$$
E'=\text{Attention}(E),\quad\text{where }E=\begin{bmatrix}\mathbf{e}_1,&\mathbf{e}_2,&\cdots,&\mathbf{e}_N\end{bmatrix}
$$

예를 들어, 아래 그림에서 `creature`에 해당하는 임베딩 $\mathbf{e}_4$는 문맥상 주변 단어인 `fluffy`와 `blue`의 임베딩에 영향을 받아, `파랗고 복슬복슬한 생명체`라는 구체적인 정보를 담은 새로운 임베딩 $\mathbf{e}_4'$로 업데이트된다.

![fig7](AI/Transformer/Transformer-7.png){: style="display:block; margin:0 auto; width:80%;"}

그렇다면 Attention이 실제로 어떻게 수행되는지 알아보자.

트랜스포머의 Attention 연산은 다음과 같이 정의된다.

$$
\text{Attention}(Q,K,V)=\text{softmax}\left(\frac{QK^\top}{\sqrt d_k}\right)V
\tag{3}
$$

여기서 $Q$는 Query, $K$는 Key, $V$는 Value를 의미하며, 이들은 아래와 같이 토큰 임베딩에 학습 가능한 가중치 행렬을 곱해 만들어진다.

$$
Q=E\cdot W_Q\in\mathbb{R}^{N\times d_k}\quad,\quad
K=E\cdot W_K\in\mathbb{R}^{N\times d_k}\quad,\quad
V=E\cdot W_V\in\mathbb{R}^{N\times d_k}
\tag{4}
$$

#### Attention Map

직관적으로 비유하자면 Query는 질문, Key는 답변으로 볼 수 있다.

예를 들어 Query가 `나를 수식하는 형용사는 어디 있어?`라고 물어보면, Key는 `여기 있어요!` 또는 `저는 아니에요!`라고 답하며 서로의 연관성을 측정하는 셈이다.

이 과정은 $Q$와 $K$의 내적을 통해 계산되며, 내적값이 클수록 두 토큰이 서로 의미적으로 강하게 연관되어 있음을 의미한다.

![fig8](AI/Transformer/Transformer-8.png){: style="display:block; margin:0 auto; width:50%;"}

이때 내적값 $QK^\top$을 $\sqrt{d_k}$로 나누어주는 이유는, 벡터의 차원인 $d_k$ 가 커질수록 내적의 결과값이 극단적으로 커져 Softmax 함수의 기울기가 소실되는 현상을 방지하기 위함이다.

> **왜 내적값이 커질수록 Softmax 함수의 기울기가 소실될까?**
> 
> Softmax 함수의 출력 확률을 $p$라고 할 때, 이 함수의 미분값은 $p(1-p)$ 형태를 가진다.
>
> Softmax 함수의 특성상 입력값들 사이의 차이가 조금만 커져도 결괏값은 극단적으로 벌어지는데, 만약 $p$가 극단적으로 커져 $1$에 수렴하거나 극단적으로 작아져 $0$에 수렴하게 되면, 미분값은 $0$에 수렴하게 된다.
>
> 그런데 Softmax 계층에서 미분값이 $0$이 되어버리면 그 이전 층으로는 어떤 기울기도 전달되지 못하며, 결국 모델의 학습이 멈춰버리게 된다. (Vanishing Gradient 현상)
>
> **왜 $\sqrt{d_k}$로 나눌까?**
>
> 두 벡터의 내적은 다음과 같다.
> 
> $$\mathbf{q}\cdot\mathbf{k}=\sum_{i=1}^{d_k}q_ik_i$$
> 
> $\mathbf{q}$와 $\mathbf{k}$를 구성하는 각 원소들이 평균이 $0$이고 분산이 $1$인 독립적인 확률 변수라고 가정해 보자.
>
> 그렇게 되면 $q_i k_i$는 여전히 평균이 $0$, 분산이 $1$인 분포를 따르지만, 이 값들을 $d_k$개만큼 더한 결과는 평균이 $0$, 분산이 $d_k$가 된다.
> 
> 즉, 임베딩 차원인 $d_k$가 커질수록 두 벡터를 내적한 결과값이 $d_k$배만큼 넓어지는 것이다.<br>이는 곧 극단적으로 큰 양수나 작은 음수가 튀어나올 확률이 높아진다는 뜻이며, 이는 앞서 설명한 Softmax 의 기울기 소실로 직결된다.
> 
> 따라서 이렇게 커진 분산을 다시 정규화하기 위해, 내적의 결괏값을 그 분포의 표준편차인 $\sqrt{d_k}$ 로 나누어주는 것이다.

이후 조정된 내적값에 행 방향으로 Softmax 함수를 적용하여, 전체 합이 1이 되는 확률 분포 형태로 값들을 정규화한다.

$$
\text{softmax}\left(\frac{QK^\top}{\sqrt{d_k}}\right)=
\begin{bmatrix}
\text{softmax}(~\mathbf{q}_1\mathbf{k}_1^\top&\mathbf{q}_1\mathbf{k}_2^\top&\cdots&\mathbf{q}_1\mathbf{k}_N^\top~)\\
\text{softmax}(~\mathbf{q}_2\mathbf{k}_1^\top&\mathbf{q}_2\mathbf{k}_2^\top&\cdots&\mathbf{q}_2\mathbf{k}_N^\top~)\\
\vdots&\vdots&\ddots&\vdots\\
\text{softmax}(~\mathbf{q}_N\mathbf{k}_1^\top&\mathbf{q}_N\mathbf{k}_2^\top&\cdots&\mathbf{q}_N\mathbf{k}_N^\top~)
\end{bmatrix}\in\mathbb{R}^{N\times N}
\tag{5}
$$

![fig9](AI/Transformer/Transformer-9.png){: style="display:block; margin:0 auto; width:60%;"}

이렇게 Softmax 함수를 통과하여 각 단어가 다른 단어에 얼마나 집중해야 하는지를 0과 1 사이의 비율로 나타낸 결과물을 Attention map이라고 한다.

$$
\text{Attention Map}=\text{softmax}\left(\frac{QK^\top}{\sqrt{d_k}}\right)=
\begin{bmatrix}
w_{1,1}&w_{1,2}&\cdots&w_{1,N}\\
w_{2,1}&w_{2,2}&\cdots&w_{1,N}\\
\vdots&\vdots&\ddots&\vdots\\
w_{N,1}&w_{N,2}&\cdots&w_{1,N}
\end{bmatrix}\in\mathbb{R}^{N\times N}
\tag{6}
$$

#### Value

<span style="background-color:#fff5b1">Attention Map이 문맥 내에서 각 단어 간의 관계를 나타낸다면, 여기에 Value를 곱하는 과정은 그 관계를 바탕으로 실제 토큰 임베딩을 어떻게 변화시킬지 구체적인 문맥 정보를 추출하는 단계이다.</span>

$$
\text{softmax}\left(QK^\top\right)V=
\begin{bmatrix}
w_{1,1}\mathbf{v}_1+w_{1,2}\mathbf{v}_2+\cdots+w_{1,N}\mathbf{v}_N\\
\vdots\\
w_{4,1}\mathbf{v}_1+w_{4,2}\mathbf{v}_2+\cdots+w_{4,N}\mathbf{v}_N\\
\vdots\\
w_{N,1}\mathbf{v}_1+w_{N,2}\mathbf{v}_2+\cdots+w_{N,N}\mathbf{v}_N
\end{bmatrix}
=\begin{bmatrix}\Delta\mathbf{e}_1\\\vdots\\\Delta\mathbf{e}_4\\\vdots\\\Delta\mathbf{e}_N
\end{bmatrix}\in\mathbb{R}^{N\times D}
\tag{7}
$$

이 행렬 곱 연산을 통해 도출된 $\Delta\mathbf{e}_i$는 원본 임베딩이 <span style="background-color:#fff5b1">문맥을 반영하기 위해 이동해야 할 방향</span>과 크기, 즉 <span style="background-color:#fff5b1">해당 방향으로 가하는 힘</span>으로 해석할 수 있다.

최종적으로 Attention 연산 이후 Skip Connection을 통해, 원래의 토큰 임베딩인 $\mathbf{e}_i$에 $\Delta\mathbf{e}_i$를 더해준다.
<br>
이 과정을 거치며 각 토큰은 비로소 주변 문맥의 의미를 반영한 새로운 임베딩으로 업데이트되는 것이다.

$$
\mathbf{e}_i'=\mathbf{e}_i+\Delta\mathbf{e}_i
\tag{8}
$$

### Self-Attention & Cross-Attention

$Q,K,V$를 어디에서 추출하느냐에 따라 크게 Self-Attention과 Cross-Attention으로 분류할 수 있다.

![fig10](AI/Transformer/Transformer-10.png){: style="display:block; margin:0 auto; width:60%;"}

#### Self-Attention

Self-Attention은 $Q,K,V$를 모두 동일한 입력 시퀀스에서 생성하는 방식이다.

이는 단일 문장 내에 존재하는 각 단어들이 서로 어떤 연관성을 가지는지 스스로 계산하여, 문맥적 의미를 파악하도록 하는 구조이다.

예를 들어, `The cat sat on the mat.`이라는 문장이 주어졌을 때, `cat` 이라는 단어가 `mat` 또는 `sat`과 얼마나 강한 관계를 맺고 있는지 가중치를 통해 학습함으로써 문장 전체의 논리적, 의미적 연결성을 깊이 있게 이해한다.

#### Cross-Attention

Cross-Attention은 $Q$를 하나의 입력에서, $K,V$를 또 다른 독립적인 입력에서 생성하여 서로 교차시키는 방식이다.

이는 서로 다른 두 개의 domain 간의 의미적 대응 관계를 매핑하고 학습하도록 하는 구조이다.

예를 들어 한국어를 영어로 번역하는 경우, $Q$는 디코더가 현재까지 생성한 영어 단어 정보에서 추출되고, $K$ 와 $V$ 는 인코더의 원본 한국어 문장에서 추출된다.
<br>
결과적으로 디코더는 다음 영어 단어를 정확하게 예측하기 위해 한국어 원문의 어느 부분에 Attention해야 하는지를 학습하게 된다.

### Multi-Head Attention (MHA)

식 (4)의 Single-Head Attention만으로는 문장 속 다양한 의미적 관계를 충분히 포착하기 어렵다.
<br>
예를 들어 `The bank of the river` 라는 문장에서 `bank`가 `river`와 물리적으로 강하게 연관되어 있다는 사실은 파악할 수 있지만, 문장의 시제나 주어와 동사 간의 구조적 관계 등 다른 중요한 언어적 특징은 놓치기 쉽다.

이러한 한계를 극복하기 위해, $Q,K,V$를 한 번에 연산하지 않고, 여러 개의 독립적인 Head로 나누어 병렬로 처리하는 Multi-Head Attention 구조를 도입했다.

임베딩 차원이 $d_k$일 때, 이를 $h$개의 Head로 균등하게 쪼개면 각 Head는 $d_h=\frac{d_k}{h}$ 차원의 공간을 할당받게 된다.
<br>
이때 각각의 Head는 서로 다른 가중치 행렬 $W_i^Q,W_i^K,W_i^V$를 가지며, 이를 통해 원본 임베딩에서 자신만의 고유한 $Q,K,V$를 독립적으로 만든다.

$$
Q_i=E\cdot W_i^Q\in\mathbb{R}^{N\times d_h}\quad,\quad
K_i=E\cdot W_i^K\in\mathbb{R}^{N\times d_h}\quad,\quad
V_i=E\cdot W_i^V\in\mathbb{R}^{N\times d_h}
\tag{9}
$$

이는 하나의 문장을 분석할 때, 1번 Head는 주어와 동사의 관계에만 집중하고, 2번 Head는 형용사와 명사의 관계에 집중하는 것과 같은 원리다.
<br>
각 Head마다 초기화되는 가중치 값이 다르기 때문에, 학습이 진행될수록 모델은 서로 다른 관점에서 문맥을 포착할 수 있게 된다.

![fig11](AI/Transformer/Transformer-11.png){: style="display:block; margin:0 auto; width:60%;"}

마지막으로 MHA 출력에 가중치 행렬 $W^O$를 곱해 선형 변환을 수행한다.
<br>
이 과정은 $h$개의 Head가 각각 수집해 온 다양한 관점의 정보들을 자연스럽게 융합하는 역할을 한다.

$$
\text{MHA}(Q,K,V)=\text{Concat}(\text{head}_1,\cdots,\text{head}_h)W^O
,\quad\text{where }\text{head}_i=\text{Attention}(Q_i,K_i,V_i)
\tag{10}
$$

### Masked Self-Attention

다음 단어를 순차적으로 예측하는 Autoregressive 모델의 디코더는 앞서 생성된 단어들만 문맥으로 참조하여 다음 단어를 생성해야 한다.
<br>
실제 추론 과정에서는 아직 생성되지 않은 미래의 토큰을 볼 수 없으므로, 학습 과정에서도 이와 동일한 환경을 구성하기 위해 미래 토큰을 미리 가려두는 작업이 필수적이다.

하지만 인코더에서 사용되는 기존의 Self-Attention 구조를 디코더에 그대로 적용하면, 행렬 연산을 통해 한 번에 모든 단어의 연관성을 병렬로 계산하게 된다.
<br>
이 경우, 뒤쪽에 위치한 미래의 단어가 Attention을 통해 현재 단어의 문맥에 영향을 주는 상황이 발생한다.
<br>
이는 모델이 다음에 예측해야 할 정답을 미리 컨닝하는 셈이 되어 정상적인 학습을 불가능하게 만든다.

이러한 문제를 해결하기 위해, 입력 시퀀스의 미래 토큰 정보에 접근하지 못하도록 수학적인 제한을 두는 구조를 Masked Self-Attention이라고 부른다.

구체적으로 이 과정은 원래의 Attention Map에 마스크 행렬 $M$을 더하는 방식으로 수행된다.

$$
\text{Masked Attention}(Q,K,V)=\text{softmax}\left(\frac{QK^\top}{\sqrt d_k}+M\right)V
\tag{11}
$$

이때 더해지는 마스크 행렬을 Causal Mask라고 하며, 다음과 같이 정의된다.

$$
M_{ij}=\begin{cases}0&,~j\leq i\\-\infty&,~j>i\end{cases}
\tag{12}
$$

즉, 현재 위치 $i$보다 미래에 해당하는 $j$위치의 연산 값들을 모두 $-\infty$ 로 설정한다.
<br>
이후 Softmax 함수가 적용되면 $e^{-\infty}$는 완전히 $0$이 되기 때문에, 미래 토큰과의 연결 고리를 수학적으로 완벽하게 차단할 수 있다.

## Output 단계

최종 예측은 마지막 토큰의 벡터만 사용하여 수행한다.

모델의 마지막 layer에서 각 토큰의 벡터는 단순히 해당 단어의 의미만 담는 것이 아니라, 문장 전체의 문맥 정보를 응축하여 담고 있다.

특히 마지막 토큰의 벡터는 '다음에 어떤 단어가 와야 할까'라는 질문에 대한 정보를 압축하고 있으며, 한 마디로 전체 문맥을 반영한 상태에서 다음 단어를 예측하기 위한 최종 표현이라 할 수 있다.

이 벡터는 출력 가중치 행렬 $W_O\in\mathbb{R}^{V\times d}$를 통해
Vocabulary에 존재하는 단어 개수인 $V$에 해당하는 차원으로 확장된다.

이후 소프트맥스 함수를 적용해 각 단어에 대한 확률 분포로 변환한다.

$$
\text{softmax}\left(W_O\mathbf{z}\right)\in\mathbb{R}^{V}
$$

이 확률 분포에서 가장 높은 확률을 가진 단어가 최종 예측 결과로 선택된다.

![fig4](AI/Transformer/Transformer4-4.png){: style="display:block; margin:0 auto; width:70%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=9-Jl0dxWQs8&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=8)_

### Temperature

온도 (Temperature)는 소프트맥스로 변환된 확률 분포의 완만함을 결정하는 하이퍼파라미터이다.

아래 수식에서 $T$가 temperature에 해당한다.

$$
\text{softmax}=\frac{\exp\left(\frac{x_i}{T}\right)}{\sum_j\exp\left(\frac{x_j}{T}\right)}
$$

$T$가 작을수록 $\frac{x_i}{T}$ 값의 차이가 커지므로, 가장 큰 logit이 압도적으로 커지게 된다. 즉, 확률 분포가 날카로워진다.

$T$가 클수록 $\frac{x_i}{T}$ 값의 차이가 완화되므로, 확률 분포가 완만해진다. 이 경우, 모델은 더 다양한 단어를 샘플링할 가능성이 높아져 창의적인 결과가 나오게 된다.

![fig5](AI/Transformer/Transformer4-5.png){: style="display:block; margin:0 auto; width:90%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=9-Jl0dxWQs8&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=8)_

## 파라미터 개수

FFN은 트랜스포머 전체 파라미터의 약 $2/3$를 차지한다.

![fig6](AI/Transformer/Transformer4-6.png){: style="display:block; margin:0 auto; width:70%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=9-Jl0dxWQs8&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=8)_
