---
title: "[선형대수] 그람-슈미트 과정 (Gram-Schmidt process)"
date: 2025-07-04 06:00:00 +/-TTTT
categories: [Mathematics, 선형대수]
tags: [선형대수]
math: true
toc: true
author: sunho
---

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

![fig1](Math/Linear_Algebra/Basis_Rank-1.png){: style="display:block; margin:0 auto; width:70%;"}
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