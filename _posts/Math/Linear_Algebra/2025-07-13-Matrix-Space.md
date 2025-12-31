---
title: "[선형대수] 행렬의 네 가지 주요 부분공간 (Four Fundamental Subspaces)"
date: 2025-07-13 00:00:00 +/-TTTT
categories: [Mathmatics, 선형대수]
tags: [선형대수]
math: true
toc: true
author: sunho
---

선형대수학에는 네 가지 주요 부분공간이 있다.

- 열공간 (Column space)
- 행공간 (Row space)
- 영공간 (Null space)
- 좌측 영공간 (Left Null space)

![fig1](mlm/13-1.png){: style="display:block; margin:0 auto; width:80%;"}
_[[출처]](https://www.cs.utexas.edu/~flame/laff/alaff/chapter04-four-fundamental-spaces.html)_

위의 그림은 행렬 $A\in\mathbb{R}^{m\times n}$에 대한 네 가지 주요 부분공간을 시각화한 것으로, 아래 내용을 보고 난 뒤에는 이해할 수 있을 것이다.

## 열공간 (Column space)

열공간 $C(A)$는 행렬 $A\in\mathbb{R}^{m\times n}$의 열벡터들의 선형 결합으로 이루어지는 부분공간을 의미한다.

열벡터의 차원은 $\mathbb{R}^m$이기 때문에 열공간은 $\mathbb{R}^m$의 부분공간이다.

$$
A=\begin{bmatrix}1&2\\3&4\\5&6\end{bmatrix}
\to
C(A)=\text{span}(\begin{bmatrix}1\\3\\5\end{bmatrix},\begin{bmatrix}2\\4\\6\end{bmatrix})\subseteq\mathbb{R}^3
$$

열공간의 차원은 행렬 $A$의 rank와 같다.

$$
\text{dim}\left(C(A)\right)=\text{rank}(A)=r
$$

## 행공간 (Row space)

행공간 $C(A^\top)$는 행렬 $A\in\mathbb{R}^{m\times n}$의 행벡터들의 선형 결합으로 이루어지는 공간을 의미한다.

행벡터의 차원은 $\mathbb{R}^n$이기 때문에 행공간은 $\mathbb{R}^n$의 부분 공간이다.

$$
A=\begin{bmatrix}1&2\\3&4\\5&6\end{bmatrix}
\to
C(A^\top)=\text{span}(\begin{bmatrix}1&2\end{bmatrix},\begin{bmatrix}3&4\end{bmatrix},\begin{bmatrix}5&6\end{bmatrix})\subseteq\mathbb{R}^2
$$

행공간의 차원은 행렬 $A$의 rank와 같다.

$$
\text{dim}\left(C(A^\top)\right)=\text{rank}(A)=r
$$

## 영공간 (Null space)

영공간 $N(A)$는 $A\mathbf{x}=\mathbf{0}$의 모든 해 집합을 의미하며, 다른 말로 커널 (kernel)이라고 부른다.

해 집합은 행벡터의 차원과 같기 때문에 영공간은 공간은 $\mathbb{R}^n$의 부분 공간이다.

$$
N(A)=\lbrace\mathbf{x}\in\mathbb{R}^n\mid A\mathbf{x}=\mathbf{0}\rbrace
\subseteq\mathbb{R}^n
$$

영공간의 차원을 **nullity**라고 부르며, [차원 정리](https://suniverse77.github.io/posts/Linear-Mapping/#%EC%B0%A8%EC%9B%90-%EC%A0%95%EB%A6%AC-rank-nullity-theorem)에 따라 아래와 같다.

$$
\text{nullity}(A)=\text{dim}\left(N(A)\right)
=n-r
$$

기하학적으로 봤을 때, 영공간은 행렬 $A$의 선형 변환을 통해 원점으로 도달하는 벡터 $\mathbf{x}$의 집합이며, 항상 $\mathbf{x}=\mathbf{0}$을 포함하기 때문에 공간 상에서 원점을 지나는 직선 또는 평면으로 표현된다.

아래 그림의 왼쪽의 노란색 직선이 변환 후 오른쪽의 노란색 점 (원점)이 되었으므로, 노란색 직선은 영공간이다.

![fig2](mlm/13-2.png){: style="display:block; margin:0 auto; width:60%;"}
_[[출처]](https://www.3blue1brown.com/lessons/inverse-matrices)_

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

## 좌측 영공간 (Left Null space)

좌측 영공간 $N(A^\top)$는 $A^\top\mathbf{y}=\mathbf{0}$의 모든 해 집합을 의미한다.

해 집합은 열벡터의 차원과 같기 때문에 좌측 영공간은 공간은 $\mathbb{R}^m$의 부분 공간이다.

$$
N(A^\top)=\lbrace\mathbf{y}\in\mathbb{R}^m\mid A^\top\mathbf{y}=\mathbf{0}\rbrace\subseteq\mathbb{R}^m
$$

좌측 영공간의 차원은 아래와 같다.

$$
\text{dim}\left(N(A^\top)\right)=m-r
$$

행렬 $A$의 관점에서 봤을 때, $\mathbf{y}^\top A=\mathbf{0}^\top$는 벡터가 행렬의 왼쪽에 곱해지므로 좌측 영공간이라고 부른다.

## 부분공간 간의 관계

행공간과 영공간은 정의역인 $\mathbb{R}^n$에 속하고, 열공간과 좌측 열공간은 공역인 $\mathbb{R}^m$에 속한다.

또한, 4개의 부분공간은 서로 직교쌍을 이룬다.

**열공간과 좌측 영공간은 직교한다.**

$$
N(A)=C(A^\top)^\perp
$$

아래의 식을 통해 직교성을 간단하게 확인할 수 있다.

$$
\mathbf{y}^\top A=\mathbf{0}^\top~\to~
\begin{bmatrix}y_1&y_2\end{bmatrix}
\begin{bmatrix}|&|\\\mathbf{a}_1&\mathbf{a}_2\\|&|\end{bmatrix}
=\begin{bmatrix}0&0\end{bmatrix}~\to~
\mathbf{y}\cdot\mathbf{a}_i=0
$$

내적이 $0$이므로, 두 공간은 직교한다.

**행공간과 영공간은 직교한다.**

$$
N(A^\top)=C(A)^\perp
$$

아래의 식을 통해 직교성을 간단하게 확인할 수 있다.

$$
A\mathbf{x}=\mathbf{0}~\to~
\begin{bmatrix}-\mathbf{a}_1-\\-\mathbf{a}_2-\end{bmatrix}
\begin{bmatrix}x_1\\x_2\end{bmatrix}=
\begin{bmatrix}0\\0\end{bmatrix}~\to~
\mathbf{a}_i\cdot\mathbf{x}=0
$$

내적이 $0$이므로, 두 공간은 직교한다.
