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

$$
A=\begin{bmatrix}1&2\\3&4\end{bmatrix}
\to
\text{col}(A)=\text{span}(\begin{bmatrix}1\\3\end{bmatrix},\begin{bmatrix}2\\4\end{bmatrix})
$$

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

## 행공간 (Row space)

일반적으로 열벡터를 기준으로 보기 때문에 열공간 중심으로 다루지만, 행공간도 존재한다.

$$
A=\begin{bmatrix}1&2\\3&4\end{bmatrix}
\to
\text{row}(A)=\text{span}\left(\begin{bmatrix}1&2\end{bmatrix},\begin{bmatrix}3&4\end{bmatrix}\right)
$$

## 영공간 (Null space)

행렬 $A$의 선형 변환을 통해 원점으로 도달하는 벡터 $\mathbf{x}$의 집합을 의미하며, 다른 말로 커널 (kernel)이라고 부른다.

수학적으로는 아래와 같이 표현된다.

$$
N(A)=\lbrace\mathbf{x}\mid A\mathbf{x}=\mathbf{0}\rbrace
$$

즉, 동차 방정식의 해를 모두 모아놓은 집합을 의미한다.

$A\mathbf{x}=\mathbf{0}$은 항상 $\mathbf{x}=\mathbf{0}$을 포함하기 때문에 공간 상에서 원점을 지나는 직선 또는 평면으로 표현된다.

아래 그림의 왼쪽의 노란색 직선이 변환 후 오른쪽의 노란색 점 (원점)이 되었으므로, 노란색 직선은 영공간이다.

![fig1](mlm/13-1.png){: style="display:block; margin:0 auto; width:60%;"}
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

$$
A=\begin{bmatrix}1&-2&3\\2&-4&6\\3&-6&9\end{bmatrix}
$$

---

위 행렬에 대한 동차 방정식을 REF로 변환하면 아래와 같다. 

$$
\begin{bmatrix}\begin{array}{ccc|c}1&-2&3&0\\0&0&0&0\\0&0&0&0\end{array}\end{bmatrix}
$$

피벗 변수는 $x_1$이고, 자유 변수는 $x_2$와 $x_3$이다.

자유변수들을 $x_2=s,x_3=t$와 같은 파라미터로 설정하면, 동차해를 아래와 같이 파라미터에 대한 식으로 표현할 수 있다.

$$
\mathbf{x}_h=\begin{bmatrix}2s-3t\\s\\t\end{bmatrix}
=s\begin{bmatrix}2\\1\\0\end{bmatrix}+t\begin{bmatrix}-3\\0\\1\end{bmatrix}
$$

이때 $s$에 의해 생성되는 공간은 $x=2y$ 직선이고, $t$에 의해 생성되는 공간은 $x=-3z$ 직선이다.

즉, 두 벡터의 선형 결합으로 $\mathbb{R}^3$ 공간에서의 2차원 평면을 span할 수 있으며, 결국 자유 변수의 개수가 영공간의 차원과 동일하다는 것을 알 수 있다.

---

</div>
</details>
<br>

### 행공간과 영공간의 관계

아래의 수식을 통해 행공간과 영공간은 공간 상에서 서로 직교한다는 것을 알 수 있다.

$$
A\mathbf{x}=\mathbf{0}~\to~
\begin{bmatrix}-\mathbf{a}_1-\\-\mathbf{a}_2-\end{bmatrix}
\begin{bmatrix}x_1\\x_2\end{bmatrix}=
\begin{bmatrix}0\\0\end{bmatrix}
$$

![fig2](mlm/13-2.png){: style="display:block; margin:0 auto; width:60%;"}
_[[출처]](https://angeloyeo.github.io/2020/11/17/four_fundamental_subspaces.html)_
