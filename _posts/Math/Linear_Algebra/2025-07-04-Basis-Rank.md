---
title: "[선형대수] 기저, 랭크와 차원"
date: 2025-07-04 00:00:00 +/-TTTT
categories: [Mathmatics, 선형대수]
tags: [선형대수]
math: true
toc: true
author: sunho
---

## 기저 (Basis)

벡터 공간의 기저란, 공간 전체를 span할 수 있는 선형 독립인 벡터들의 집합을 말한다.

즉, 벡터 공간 $V$를 span하는 가장 작은 집합 $B$를 $V$의 기저라고 부르며, 이는 특정 공간에서 좌표축 역할을 하는 벡터들의 집합이다.

기저는 아래와 같이 표현 가능하다.

- $B$는 $V$의 minimal generating set이다. 

   벡터를 하나라도 제거하면 더 이상 $V$ 전체를 생성할 수 없다는 뜻이다.

- $B$는 $V$의 maximally linearly independent set이다.

   벡터를 하나라도 추가하면 선형 독립성이 깨진다는 뜻이다.

기저는 가우스 소거법을 이용해 구할 수 있다.

<details>
<summary><font color='#FF0000'>Example 1</font></summary>
<div markdown="1">

$$
A=\begin{bmatrix}1&2&3\\2&5&5\end{bmatrix}
$$

---

가우스 소거법을 이용해 RREF로 변환한다.

$$
A=\begin{bmatrix}1&0&5\\0&1&-1\end{bmatrix}
$$

위에서 첫 번째와 두 번째 열이 pivot 열이다.

**열공간의 basis**

<span style="background-color:#fff5b1">피벗 열의 위치에 해당하는 원본 행렬에서의 열벡터가 $A$의 열공간의 기저다.</span>

$$
\mathbf{b_1}=\begin{bmatrix}1\\2\end{bmatrix}
~,~\mathbf{b_2}=\begin{bmatrix}2\\5\end{bmatrix}
$$

가우스 소거법을 해도 열벡터 사이의 관계 (누가 종속이고 독립인지)는 유지된다. 하지만, 가우스 소거법을 통해 변형된 열벡터는 원본 행렬의 열벡터와 같은 공간을 span하지 않는다.

따라서, 기저는 원본 행렬에서 선택해야 한다.

하지만 <span style="background-color:#FFE6E6">열공간의 기저가 반드시 피벗 열의 위치에 해당하는 것은 아니다.</span> 예를 들어 위에서 첫 번째와 두 번째 열을 기저로 설정했지만, 첫 번째와 세 번째 열을 기저로 설정할 수도 있다.

**행공간의 basis**

RREF 행렬에서 $\mathbf{0}$이 아닌 행벡터가 $A$의 행공간의 기저다.

$$\vphantom{\Big(}
\mathbf{b_1}=\begin{bmatrix}1&0&5\end{bmatrix}
~,~\mathbf{b_2}=\begin{bmatrix}0&1&-1\end{bmatrix}
$$

가우스 소거법은 행들의 선형 결합을 통해 이뤄진다. 따라서 원본 행렬에서의 행벡터가 가우스 소거법을 통해 변형될지라도, RREF에서의 행벡터와 원본 행렬에서의 행벡터는 결국 같은 공간을 span한다.

$$
\text{span}(\begin{bmatrix}1\\2\\3\end{bmatrix}^\top,\begin{bmatrix}2\\5\\5\end{bmatrix}^\top)
=\text{span}(\begin{bmatrix}1\\0\\5\end{bmatrix}^\top,\begin{bmatrix}0\\1\\-1\end{bmatrix}^\top)
$$

따라서, 기저를 원본 행렬 또는 RREF 행렬에서 선택해도 무관하다.

---

</div>
</details>

### 직교 기저 (Orthogonal Basis)

기저를 이루는 벡터들이 서로 직교(orthogonal)하는 경우, 직교 기저라고 부른다.

$$
\mathbf{b}_i\cdot\mathbf{b}_j=0~,~(i\not=j)
$$

직교 기저가 중요한 이유는 2가지가 있다.

1. 서로 직교한다는 것은 <span style="background-color:#fff5b1">선형 독립을 자동으로 보장</span>해준다.

2. 어떤 벡터를 기저들의 선형 결합으로 나타낼 때, 계수를 쉽게 구할 수 있다.

$$
\mathbf{v}=\sum_{i=1}^N c_i\mathbf{b}_i
~~,~~
c_i=\frac{\mathbf{v}\cdot\mathbf{b}_i}{\lVert\mathbf{b}_i\rVert}
$$

<details>
<summary><font color='#0000FF'>공식 유도</font></summary>
<div markdown="1">

$$
\mathbf{v}=\sum_{i=1}^N c_i\mathbf{b}_i
$$

1. 양변에 $\mathbf{b}_k$를 내적함

$$
\mathbf{v}\cdot\mathbf{b}_k=\left(\sum_{i=1}^N c_i\mathbf{b}_i\right)\cdot\mathbf{b}_k=\sum_{i=1}^N c_i(\mathbf{b}_i\cdot\mathbf{b}_k)
$$

2. $\mathbf{b}_i\cdot\mathbf{b}_j=0~,~(i\not=j)$이기 때문에 우변에는 $i=k$인 항만 남음

$$
\mathbf{v}\cdot\mathbf{b}_k=c_k(\mathbf{b}_k\cdot\mathbf{b}_k)
$$

3. $c_1$만 남기고 이항

$$
c_k=\frac{\mathbf{v}\cdot\mathbf{b}_k}{\lVert\mathbf{b}_k\rVert}
$$

---

</div>
</details>

<details>
<summary><font color='#FF0000'>Example 2</font></summary>
<div markdown="1">

$$
B=\begin{bmatrix}1&-1\\1&1\end{bmatrix}
~~,~~
\mathbf{v}=\begin{bmatrix}3\\5\end{bmatrix}
$$

---

$B$의 basis들은 서로 직교한다. 벡터 $\mathbf{v}$를 이 basis들의 선형 결합으로 표현할 수 있다.

$$
\mathbf{v}=\begin{bmatrix}3\\5\end{bmatrix}
=c_1\begin{bmatrix}1\\1\end{bmatrix}+c_2\begin{bmatrix}-1\\1\end{bmatrix}
$$

**1. $c_1$ 구하기**

$$
c_1=\frac{\mathbf{v}^\top\mathbf{b}_1}{\mathbf{b}_1^\top\mathbf{b}_1}
=\frac{8}{2}=4
$$

**2. $c_2$ 구하기**

$$
c_2=\frac{\mathbf{v}^\top\mathbf{b}_2}{\mathbf{b}_2^\top\mathbf{b}_2}
=\frac{2}{2}=1
$$

따라서 아래와 같이, basis들의 선형 결합으로 표현할 수 있다.

$$
\mathbf{v}=4\mathbf{b}_1+\mathbf{b}_2
$$

---

</div>
</details>

### 정규 직교 기저 (Orthonormal Basis)

Basis를 이루는 벡터들이 <span style="background-color:#fff5b1">서로 직교하고 각각의 크기가 1</span>일 경우, 정규 직교 기저라고 부른다.

$$
\mathbf{b}_i\cdot\mathbf{b}_j=
\begin{cases}
1&(i=j)\\
0&(i\not=j)
\end{cases}
$$

#### 정규 직교 기저가 중요한 이유

정규 직교 기저는 여러 계산에서 유용하게 사용될 수 있다.

어떤 벡터를 기저들의 선형 결합으로 표현할 때, 정규 직교 기저라면 더 단순한 계산으로 선형 결합 계수를 구할 수 있다.

$$
\mathbf{v}=\sum_{i=1}^N c_i\mathbf{b}_i
~~,~~
c_i=\mathbf{v}\cdot\mathbf{b}_i
$$

<details>
<summary><font color='#FF0000'>Example 3</font></summary>
<div markdown="1">

$$
B=\begin{bmatrix}\frac{1}{\sqrt{2}}&-\frac{1}{\sqrt{2}}\\\frac{1}{\sqrt{2}}&\frac{1}{\sqrt{2}}\end{bmatrix}
~~,~~
\mathbf{v}=\begin{bmatrix}3\\5\end{bmatrix}
$$

---

$$
\mathbf{v}=\begin{bmatrix}3\\5\end{bmatrix}
=c_1\begin{bmatrix}1\\1\end{bmatrix}+c_2\begin{bmatrix}-1\\1\end{bmatrix}
$$

**1. $c_1$ 구하기**

$$
c_1=\mathbf{v}^\top\mathbf{b}_1=4
$$

**2. $c_2$ 구하기**

$$
c_2=\mathbf{v}^\top\mathbf{b}_2=1
$$

따라서 아래와 같이, basis들의 선형 결합으로 표현할 수 있다.

$$
\mathbf{v}=4\mathbf{b}_1+\mathbf{b}_2
$$

---

</div>
</details>
<br>

또한 벡터를 어떤 벡터 공간으로 [정사영](https://suniverse77.github.io/posts/Projection/#%EB%B6%80%EB%B6%84%EA%B3%B5%EA%B0%84-%EC%9C%84%EB%A1%9C%EC%9D%98-%EC%82%AC%EC%98%81-projection-onto-general-subspace)할 때, $B^\top B=I$이므로 복잡한 역행렬 계산을 피할 수 있다.

$$
\text{proj}_U(\mathbf{v})=BB^\top\mathbf{v}
$$

<details>
<summary><font color='#FF0000'>Example 4</font></summary>
<div markdown="1">

$$
B=\begin{bmatrix}\frac{1}{\sqrt{2}}&-\frac{1}{\sqrt{2}}\\\frac{1}{\sqrt{2}}&\frac{1}{\sqrt{2}}\\0&0\end{bmatrix}
~~,~~
\mathbf{v}=\begin{bmatrix}3\\5\\7\end{bmatrix}
$$

---

벡터 $\mathbf{v}$를 기저 집합이 $B$인 벡터 공간으로 정사영한 결과는 아래와 같이 구할 수 있다.

$$
\text{proj}_U(\mathbf{v})=
\begin{bmatrix}\frac{1}{\sqrt{2}}&-\frac{1}{\sqrt{2}}\\\frac{1}{\sqrt{2}}&\frac{1}{\sqrt{2}}\\0&0\end{bmatrix}
\begin{bmatrix}\frac{1}{\sqrt{2}}&\frac{1}{\sqrt{2}}&0\\-\frac{1}{\sqrt{2}}&\frac{1}{\sqrt{2}}&0\end{bmatrix}
\begin{bmatrix}3\\5\\7\end{bmatrix}
=\begin{bmatrix}3\\5\\0\end{bmatrix}
$$

---

</div>
</details>

### 그람-슈미트 과정 (Gram-Schmidt process)

그람 슈미트 과정을 통해 기저 $B=\lbrace\mathbf{a}_1,\dots,\mathbf{a}_N\rbrace$를 정규 직교 기저 $B'=\lbrace\mathbf{b}_1,\dots,\mathbf{b}_N\rbrace$로 변환할 수 있다.

3차원 공간에서 그람 슈미트 과정은 아래와 같다.

**1. 첫 번째 정규 직교 기저 구하기**

먼저 기저 벡터에서 하나의 기준 벡터 $\mathbf{w}_1$를 설정한 후, 해당 벡터를 정규화한다. ($\mathbf{a}_1$를 기준 벡터 설정)

$$
\mathbf{w}_1=\mathbf{a}_1
~\to~
\mathbf{b}_1=\frac{\mathbf{w}_1}{\lVert\mathbf{w}_1\rVert}
$$

**2. 두 번째 정규 직교 기저 구하기**

두 번째 기저 벡터 $\mathbf{a}_2$에서 $\mathbf{w}_1$ 방향의 성분 $\mathbf{w}_1^{\shortparallel}$을 제거하여, $\mathbf{w}_1$에 수직인 벡터 $\mathbf{w}_2$를 찾는다.

$$
\mathbf{a}_2=\mathbf{w}_1^{\shortparallel}+\mathbf{w}_2
$$

$\mathbf{a}_1^{\shortparallel}$은 $\mathbf{a}_2$를 $\mathbf{a}_1$으로 정사영시킨 벡터이므로, 아래와 같이 $\mathbf{w}_2$를 구할 수 있다.

$$
\mathbf{w}_2=\mathbf{w}_2-\text{proj}_{\mathbf{w}_1}(\mathbf{a}_2)
=\mathbf{w}_2-\frac{\mathbf{w}_1\cdot\mathbf{a}_2}{\mathbf{w}_1\cdot\mathbf{w}_1}\mathbf{w}_1
$$

이후 정규화하여 두 번째 기저 $\mathbf{b}_2$를 구한다.

$$
\mathbf{b}_2=\frac{\mathbf{w}_2}{\lVert\mathbf{w}_2\rVert}
$$

**3. 세 번째 정규 직교 기저 구하기**

세 번째 기저 벡터 $\mathbf{a}_3$에서 $\mathbf{w}_1$과 $\mathbf{w}_2$ 방향의 성분을 제거하여, $\mathbf{w}_1$과 $\mathbf{w}_2$가 span하는 공간에 수직인 벡터 $\mathbf{w}_3$를 찾는다.

$$
\mathbf{w}_3=\mathbf{w}_3-\text{proj}_{\mathbf{w}_1}(\mathbf{a}_3)-\text{proj}_{\mathbf{w}_2}(\mathbf{a}_3)
=\mathbf{w}_3
-\frac{\mathbf{w}_1\cdot\mathbf{a}_3}{\mathbf{w}_1\cdot\mathbf{w}_1}\mathbf{w}_1
-\frac{\mathbf{w}_2\cdot\mathbf{a}_3}{\mathbf{w}_2\cdot\mathbf{w}_2}\mathbf{w}_2
$$

이후 정규화하여 세 번째 기저 $\mathbf{b}_3$를 구한다.

$$
\mathbf{b}_3=\frac{\mathbf{w}_3}{\lVert\mathbf{w}_3\rVert}
$$

아래의 왼쪽 그림에서 $\mathbf{a}$들은 서로 직교하지 않았지만, 오른쪽 그림에서 $\mathbf{b}$들은 서로 직교한다. 

![fig1](mlm/4-1.png){: style="display:block; margin:0 auto; width:70%;"}
_[[출처]](https://interactivetextbooks.tudelft.nl/linear-algebra/Chapter7/GramSchmidt.html)_

<details>
<summary><font color='#FF0000'>Example 5</font></summary>
<div markdown="1">

$$
\mathbf{a}_1=\begin{bmatrix}1\\1\\0\end{bmatrix}~,~
\mathbf{a}_2=\begin{bmatrix}1\\3\\2\end{bmatrix}~,~
\mathbf{a}_3=\begin{bmatrix}2\\0\\1\end{bmatrix}
$$

---

**1. 첫 번째 정규 직교 기저 구하기**

$$
\mathbf{w}_1=\mathbf{a}_1=\begin{bmatrix}1\\1\\0\end{bmatrix}
$$

$$
\mathbf{b}_1=\frac{\mathbf{w}_1}{\lVert\mathbf{w}_1\rVert}=
\frac{1}{\sqrt2}\begin{bmatrix}1\\1\\0\end{bmatrix}
$$

**2. 두 번째 정규 직교 기저 구하기**

$$
\mathbf{w}_2=\mathbf{a}_2-\frac{\mathbf{w}_1\cdot\mathbf{a}_2}{\mathbf{w}_1\cdot\mathbf{w}_1}\mathbf{w}_1
=\begin{bmatrix}-1\\1\\2\end{bmatrix}
$$

$$
\mathbf{b}_2=\frac{\mathbf{w}_2}{\lVert\mathbf{w}_2\rVert}=
\frac{1}{\sqrt6}\begin{bmatrix}-1\\1\\2\end{bmatrix}
$$

**3. 세 번째 정규 직교 기저 구하기**

$$
\mathbf{w}_3=\mathbf{a}_3-\frac{\mathbf{w}_1\cdot\mathbf{a}_3}{\mathbf{w}_1\cdot\mathbf{w}_1}\mathbf{w}_1-\frac{\mathbf{w}_2\cdot\mathbf{a}_3}{\mathbf{w}_2\cdot\mathbf{w}_2}\mathbf{w}_2
=\begin{bmatrix}1\\-1\\1\end{bmatrix}
$$

$$
\mathbf{b}_3=\frac{\mathbf{w}_2}{\lVert\mathbf{w}_2\rVert}=
\frac{1}{\sqrt3}\begin{bmatrix}1\\-1\\1\end{bmatrix}
$$

최종적으로 얻은 정규 직교 기저는 아래와 같다.

$$
\mathbf{a}_1=\frac{1}{\sqrt2}\begin{bmatrix}1\\1\\0\end{bmatrix}~,~
\mathbf{a}_2=\frac{1}{\sqrt6}\begin{bmatrix}-1\\1\\2\end{bmatrix}~,~
\mathbf{a}_3=\frac{1}{\sqrt3}\begin{bmatrix}1\\-1\\1\end{bmatrix}
$$

---

</div>
</details>

## 차원 (Dimension)

벡터 공간 $V$의 기저의 개수를 $V$의 차원이라고 부른다.

<span style="background-color:#fff5b1">벡터의 차원과 벡터 공간의 차원은 다르다.</span>

- 벡터의 차원은 벡터를 구성하는 원소의 개수를 의미한다.

   $$
   \mathbf{v}=\begin{bmatrix}2\\4\\6\end{bmatrix}~\to~\text{dim}(\mathbf{v})=3
   $$

- 벡터 공간의 차원은 공간을 생성하는 선형 독립 벡터의 개수를 의미한다.

   $$
   V=\text{span}(\begin{bmatrix}1\\3\\5\end{bmatrix},\begin{bmatrix}2\\4\\6\end{bmatrix})~\to~\text{dim}(V)=2
   $$

부분공간의 차원은 항상 원래 공간의 차원보다 작거나 같다.

$$
U\subseteq V \implies \text{dim}(U)\leq \text{dim}(V)
$$

## 계수 (Rank)

Rank는 행렬에서 선형 독립인 행 또는 열의 최대 개수를 의미한다.

열 벡터로 이루어진 행렬 $A$에서는 선형 독립인 열의 개수를 의미하므로, 열 벡터들이 span하는 공간의 최대 차원을 나타낸다.

가우스 소거법을 적용 후 변환된 REF 형태의 행렬에서 0이 아닌 행 또는 열의 개수가 rank이다.

<details>
<summary><font color='#FF0000'>Example 6</font></summary>
<div markdown="1">
  
$$
A=\begin{bmatrix}1&2&3\\2&3&4\\3&6&9\end{bmatrix}
$$

---

**1. 가우스 소거법 적용**

$$
A=\begin{bmatrix}1&2&3\\0&1&2\\0&0&0\end{bmatrix}
$$

**2. 0이 아닌 행 또는 열의 개수 세기**

0이 아닌 행이 2개이므로, $\text{rank}(A)=2$ 이다.

즉, 3개의 열벡터들이 span하는 공간 $V$의 차원은 2차원 평면이다.

---

</div>
</details>

### Rank의 성질

1. $\text{rank}(A)=\text{rank}(A^T)$
2. $\text{rank}(AB)\leq\min\left(\text{rank}(A),\text{rank}(B)\right)$
3. $A\in\mathbb{R}^{m\times n}$에 대해 $\text{rank}(A)=\min(m,n)$의 경우 $A$를 <span style="background-color:#fff5b1">full rank</span>라고 하며, $\text{rank}(A)<\min(m,n)$의 경우 $A$를 <span style="background-color:#fff5b1">rank-deficient</span>라고 한다.
4. 정방 행렬 $A\in\mathbb{R}^{n\times n}$에 대해 $\text{rank}(A)=n$일 경우, $A$는 역행렬이 존재한다.

   변환 후 차원이 줄어들지 않기 때문에 역변환이 가능하다.
5. $\text{rank}(A)=\text{rank}(A\mid \mathbf{b})$인 경우에만, $A\mathbf{x}=\mathbf{b}$의 해를 구할 수 있다.

<details>
<summary><font color='#FF0000'>Example 7</font></summary>
<div markdown="1">

$$
\begin{cases}x_1+x_2=2\\x_1+x_2=4\end{cases}
$$

---

위의 연립 방정식에 대한 첨가 행렬은 아래와 같이 구성할 수 있다.

$$
[A\mid \mathbf{b}]=\begin{bmatrix}\begin{array}{cc|c}1&1&2\\1&1&4\end{array}\end{bmatrix}
$$

$\text{rank}(A)=1$이지만 $\text{rank}(A\mid \mathbf{b})=2$인 경우로, $\text{rank}(A)<\text{rank}(A\mid \mathbf{b})$이다. 

실제 가우스 소거법을 적용해보면 해가 존재하지 않는 것을 확인할 수 있다.

$$
[A\mid \mathbf{b}]=\begin{bmatrix}\begin{array}{cc|c}1&1&2\\0&0&2\end{array}\end{bmatrix}
$$

---

</div>
</details>
<br>
