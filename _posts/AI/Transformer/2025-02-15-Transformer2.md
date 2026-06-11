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

## Input 단계

컴퓨터는 인간의 언어인 텍스트를 직접 이해할 수 없고 오직 숫자 형태의 데이터만 연산할 수 있다.
<br>
따라서 자연어 문장을 모델에 입력하기 전, 텍스트를 컴퓨터가 처리할 수 있는 숫자로 변환하는 과정이 필요하다.

![fig0](AI/Transformer/Transformer-1.png){: style="display:block; margin:0 auto; width:40%;"}

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

![fig0](AI/Transformer/Transformer-2.png){: style="display:block; margin:0 auto; width:80%;"}

### 토큰 임베딩 (Token Embedding)

앞서 토큰화 과정으로 얻은 정수 ID는 단지 단어 사전에 등록된 인덱스 번호일 뿐이므로, 그 자체만으로는 모델 내부에서 유의미한 연산을 수행할 수 없다.
<br>
따라서 정수 ID를 연속적인 실수 벡터로 변환하는 과정이 필요한데, 이 역할을 수행하는 행렬을 임베딩 행렬이라고 부른다.

$$\vphantom{\Big(}
W_E\in\mathbb{R}^{N_{\text{word}}\times D}
\tag{1}
$$

여기서 $N_{\text{word}}$는 Vocabulary에 존재하는 전체 토큰 개수, $D$는 하나의 토큰을 표현할 차원의 크기를 의미한다.

예를 들어 토큰화를 통해 `love` 라는 단어가 정수 ID `1`로 변환되었다면, 모델은 임베딩 행렬의 1번째 행에 저장되어 있는 벡터를 그대로 가져온다.
<br>
이렇게 추출된 벡터가 바로 `love`의 임베딩 벡터가 된다.

![fig3](AI/Transformer/Transformer-3.png){: style="display:block; margin:0 auto; width:80%;"}

초기 생성 시 임베딩 행렬의 가중치는 무작위 실수 값으로 채워져 있지만, 학습을 통해 점차 단어의 고유한 의미를 반영하도록 최적화된다.

아래 그림은 $D=3$인 경우의 토큰 임베딩 공간을 시각화한 예시이다.

![fig4](AI/Transformer/Transformer-4.png){: style="display:block; margin:0 auto; width:60%;"}

토큰 임베딩이 학습이 성공적으로 완료되었다면, 단어 간의 의미적 관계가 벡터 연산으로 성립하게 된다.

위의 그림처럼 `여왕` 임베딩과 `왕` 임베딩의 차이인 $E(\text{queen})-E(\text{king})$는 `여자` 임베딩과 `남자` 임베딩의 차이인 $E(\text{woman})-E(\text{man})$와 유사한 방향과 크기를 가질 것이다.
<br>
이를 통해 두 벡터의 차이를 나타내는 주황색 벡터는 `여성성` 이라는 특정한 성별의 의미를 담고 있음을 알 수 있다.
<br>
이는 곧 우리가 `여왕` 임베딩에 대한 정보가 없더라도, `왕` 임베딩에 주황색 벡터를 더함으로써 `여왕` 임베딩을 근사적으로 얻을 수 있다는 말이 된다.

### 위치 인코딩 (Positional Encoding)

트랜스포머의 Attention과 Feed-Forward 블록은 모두 순서 개념이 없는 dot product 연산으로 구성되어 있다.
따라서 모델은 입력 토큰의 위치 정보를 스스로 인식할 수 없으며, 단어의 순서를 고려하지 않고 처리하게 되는 문제가 발생한다.

이를 해결하기 위해, 각 토큰의 위치를 벡터 형태로 인코딩하여 입력 임베딩에 더해주는 방식을 사용한다.
이 벡터를 위치 인코딩 (Positional Encoding)이라고 한다.

위치 인코딩이 갖춰야 할 조건은 아래와 같다.

- 모든 위치는 각각 고유한 값을 가져야 한다.
- 위치 간의 관계를 표현하는 일정한 규칙이 존재해야 한다.
- 두 위치 간의 거리를 추정할 수 있어야 한다.
- 학습 시 본 적 없는 더 긴 문장에 대해서도 일반화가 가능해야 한다.

이러한 요구를 만족하기 위해, 트랜스포머에서는 $\sin$ 함수와 $\cos$ 함수를 이용한
Sinusoidal Positional Encoding을 사용한다.

먼저 정의에 대해서 살펴보고 왜 이렇게 하는지 알아보자. Sinusoidal Positional Encoding은 아래와 같이 정의된다.

$$
PE(pos,2i)=\sin\left(\frac{pos}{10000^{2i/d}}\right)
$$

$$
PE(pos,2i+1)=\cos\left(\frac{pos}{10000^{2i/d}}\right)
$$

여기서 $d$는 고정된 임베딩 차원, $pos$는 토큰의 위치 인덱스 $i$는 임베딩 차원의 인덱스를 의미한다.

차원 인덱스가 낮을수록 (앞쪽 차원일수록) 낮은 주파수를, 인덱스가 높을수록 (뒤쪽 차원일수록) 높은 주파수를 사용한다.

![fig6](AI/Transformer/Transformer2-6.png){: style="display:block; margin:0 auto; width:60%;"}
_[[출처: BrainDrain]](https://www.youtube.com/watch?v=T3OT8kqoqjc)_

아래 그림에서 position을 $x$축, depth를 $y$축으로 볼 수 있으며, depth가 깊어질수록 주기가 길어지는 것을 확인할 수 있다.

![fig7](AI/Transformer/Transformer2-7.png){: style="display:block; margin:0 auto; width:70%;"}

예를 들어 임베딩 차원이 $d=8$이라면, 첫 번째 단어 $(pos=0)$와 두 번째 단어 $(pos=1)$의 위치 인코딩은 아래와 같다.

$$
\mathbf{p}_0=
\begin{bmatrix}
\sin\left(\frac{0}{10000^{0/8}}\right)\\
\cos\left(\frac{0}{10000^{0/8}}\right)\\
\sin\left(\frac{0}{10000^{2/8}}\right)\\
\cos\left(\frac{0}{10000^{2/8}}\right)\\
\vdots
\end{bmatrix}=
\begin{bmatrix}
\sin\left(0\right)\\
\cos\left(0\right)\\
\sin\left(0\right)\\
\cos\left(0\right)\\
\vdots
\end{bmatrix}\in\mathbb{R}^d
~~,~~
\mathbf{p}_1=
\begin{bmatrix}
\sin\left(\frac{1}{10000^{0/8}}\right)\\
\cos\left(\frac{1}{10000^{0/8}}\right)\\
\sin\left(\frac{1}{10000^{2/8}}\right)\\
\cos\left(\frac{1}{10000^{2/8}}\right)\\
\vdots
\end{bmatrix}=
\begin{bmatrix}
\sin\left(1\right)\\
\cos\left(1\right)\\
\sin\left(\frac{1}{10}\right)\\
\cos\left(\frac{1}{10}\right)\\
\vdots
\end{bmatrix}\in\mathbb{R}^d
$$

최종 입력 벡터는 원래의 단어 임베딩 $\mathbf{e}_i$에 위치 인코딩 $\mathbf{p}_i$를 더하여 만든다.

$$
\mathbf{e}_i'=\mathbf{e}_i+\mathbf{p}_i
$$

Concat을 사용할 경우 차원이 불필요하게 증가하기 때문에 덧셈으로 처리한다.

덧셈을 통해 각 차원의 위치 신호가 단어 임베딩의 의미 공간에 자연스럽게 섞이게 되며, 모델은 학습 과정에서 이 패턴을 이용해 위치 관계를 유추하는 직관을 형성한다.

### 직관적 이해

각 단어 임베딩의 차원이 $d=2$라고 가정하자.

이때 임베딩 벡터의 두 차원을 각각 $x$축과 $y$축의 좌표로 볼 수 있다.

$$
\mathbf{p}_t=
\begin{bmatrix}\sin\left(\frac{t}{10000^i}\right)\\\cos\left(\frac{t}{10000^i}\right)\end{bmatrix}=\begin{bmatrix}y\\x\end{bmatrix}
$$

위치 $t$가 증가함에 따라 벡터의 방향이 점진적으로 회전한다. 즉, 각 위치 벡터는 서로 다른 위상을 갖게 되며, 결과적으로 모든 단어가 2차원 평면에서 고유한 방향을 가지게 된다.

![fig8](AI/Transformer/Transformer2-8.gif){: style="display:block; margin:0 auto; width:70%;"}
_[[출처: Serrano.Academy]](https://www.youtube.com/watch?v=IHu3QehUmrQ)_

이제 $d=6$으로 확장하면, 각 벡터는 6차원 공간에서 각각 고유한 방향을 가리킬 것이다.

![fig9](AI/Transformer/Transformer2-9.png){: style="display:block; margin:0 auto; width:90%;"}
_[[출처: Serrano.Academy]](https://www.youtube.com/watch?v=IHu3QehUmrQ)_
