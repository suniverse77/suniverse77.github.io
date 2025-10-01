---
title: "[선형대수] 행렬이 만드는 공간"
date: 2025-07-13 00:00:00 +/-TTTT
categories: [인공지능 수학, 선형대수]
tags: [선형대수]
math: true
toc: true
author: sunho
---

## 열공간 (Column space)

행렬 $A$의 선형 변환을 통해 나올 수 있는 가능한 모든 출력 벡터 $\mathbf{v}$의 집합을 $A$의 열공간이라고 한다.

행렬 $A$의 각 열은 변환 후 도달할 기저 벡터의 위치를 알려주고, 이 기저 벡터의 span이 가능한 모든 출력이기 때문이다.

여기서 [rank](https://suniverse77.github.io/posts/Basis/)에 대해 다시 집고 가자.

Rank의 의미는 변환 후 출력의 차원수 즉, 열공간의 차원수이다.

변환 후 출력이 직선 (1차원)이면 변환 행렬의 rank는 1, 평면 (2차원)이라면 rank는 2이다.

이때 rank가 행렬의 열 수와 같으면 full-rank라고 하며, 이는 변환을 거쳐도 공간이 찌그러지지 않고 원래의 차원을 그대로 유지한다는 뜻이다.

선형 변환은 변환 후에도 원점이 고정이어야하기 때문에 열공간은 항상 영벡터를 포함한다.

- Full-rank인 경우, 오직 영벡터만이 변환 후 영벡터가 된다.
- Full-rank가 아닌 경우, 일부 벡터들도 변환후 영벡터가 될 수 있다.

    예를 들어 2차원 공간이 직선으로 붕괴되면, 원래 다른 방향으로 뻗어 있던 직선 위의 벡터들이 변환 후 원점으로 모이게 된다.

    3차원 공간이 평면으로 붕괴되면, 모두 원점에 도달하는 벡터로 가득 찬 직선이 존재

    3차원 공간이 직선으로 붕괴하면 모두 원점에 도달하는 벡터로 가득 찬 평면이 존재

## 영공간 (Null space)

행렬 $A$의 선형 변환을 통해 원점으로 도달하는 벡터 $\mathbf{x}$의 집합을 의미하며, 다른 말로 커널 (kernel)이라고 부른다.

수학적으로는 아래와 같이 표현된다.

$$
N(A)=\lbrace\mathbf{x}\mid A\mathbf{x}=\mathbf{0}\rbrace
$$

즉, 동차 방정식의 해를 모두 모아놓은 집합을 의미한다.

$A\mathbf{x}=\mathbf{0}$은 항상 $\mathbf{x}=\mathbf{0}$을 포함하기 때문에 공간 상에서 원점을 지나는 직선 또는 평면으로 표현된다.

![fig1](mlm/13-1.png){: style="display:block; margin:0 auto; width:70%;"}
_[[출처]](https://www.3blue1brown.com/lessons/inverse-matrices)_

영공간의 차원을 **nullity**라고 한다.

$$
\text{nullity}(A)=\text{dim}\left(N(A)\right)
$$

### 영공간의 성질
    
1. 어떠한 영공간이든지 항상 $\mathbf{0}$를 포함하므로, 영공간은 벡터 공간이다.
2. 영공간은 방정식의 가능한 모든 해이다.
3. Nullity는 $A\mathbf{x}=\mathbf{0}$를 풀었을 때 나오는 자유 변수의 개수와 동일하다.

<details>
<summary><font color='#FF0000'>Example 1</font></summary>
<div markdown="1">



</div>
</details>
<br>
