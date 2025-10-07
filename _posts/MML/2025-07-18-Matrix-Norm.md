---
title: "[선형대수] 행렬의 노름 (Norm)"
date: 2025-07-18 00:00:00 +/-TTTT
categories: [인공지능 수학, 선형대수]
tags: [선형대수]
math: true
toc: true
author: sunho
---

## 행렬의 노름 (Matrix Norm)

벡터의 norm 개념을 행렬에 확장한 것이다.

### Norm의 조건

행렬 norm도 벡터 norm과 같이 만족해야 할 조건이 필요하다.

1. Absolutely homogeneous

   $\lVert\lambda A\rVert=\lambda\lVert A\rVert$

2. Triangle inequality

   $\lVert A+B\rVert\leq\lVert A\rVert+\lVert B\rVert$

3. Positive definite

   $\lVert A\rVert\geq0$

   $\lVert A\rVert=0\iff A=0_{m,n}$

## 행렬 Norm의 종류

행렬의 Norm에는 여러 가지 종류가 있다. $A\in\mathbb{R}^{m\times n}$ 행렬에 대해 각 norm은 아래와 같이 정의된다.

### Frobenius Norm

행렬의 모든 원소를 제곱해서 더한 후, 그 값의 제곱근을 계산한 것이 Frobenius Norm이다.

$$
\lVert A\rVert_F=\sqrt{\sum_{i=1}^n\sum_{j=1}^m\lvert a_{i,j}\rvert^2}
$$

벡터의 Euclidean Norm을 구하는 것과 비슷하다.

<details>
<summary><font color='#FF0000'>Example 1</font></summary>
<div markdown="1">

$$
A=\begin{bmatrix}2&2\\3&4\end{bmatrix}
$$

---

$$
\lVert A\rVert_F=1+4+9+16=30
$$

---

</div>
</details>
<br>

### L1 Norm

각 열에 있는 원소들의 절댓값을 모두 더한 후, 그 합들 중 최댓값이 L1 Norm이다.

$$
\lVert A\rVert_1=\max_{j}\sum_{i=1}^m\lvert a_{i,j}\rvert
$$

<details>
<summary><font color='#FF0000'>Example 2</font></summary>
<div markdown="1">

$$
A=\begin{bmatrix}1&2\\3&4\end{bmatrix}
$$

---

$$
\lVert A\rVert_1=\max(1+3,2+4)=6
$$

---

</div>
</details>
<br>

### L-infinity Norm

각 행에 있는 원소들의 절댓값을 모두 더한 후, 그 합들 중 최댓값이 L2 Norm이다.

$$
\lVert A\rVert_\infin=\max_{i}\sum_{j=1}^n\lvert a_{i,j}\rvert
$$

<details>
<summary><font color='#FF0000'>Example 3</font></summary>
<div markdown="1">

$$
A=\begin{bmatrix}1&2\\3&4\end{bmatrix}
$$

---

$$
\lVert A\rVert_1=\max(1+2,3+4)=7
$$

---

</div>
</details>
<br>

### Spectral Norm (L2 Norm)

L2 Norm과 동일한 값을 가지며, 아래와 같이 정의된다.

$$
\lVert A\rVert_2:=\underset{\mathbf{x}}{\max}\frac{\lVert A\mathbf x\rVert_2}{\lVert \mathbf x\rVert_2}=\underset{\lVert\mathbf{x}\rVert=1}{\max}\lVert A\mathbf x\rVert_2
$$

이는 변환 전후의 크기 변화의 최대값이며, 기하학적으로 해당 행렬이 벡터를 최대로 늘릴 수 있는 배율을 의미한다.

이는 $A$의 가장 큰 특이값과 동일하다.

$$
\lVert A\rVert_2=\sigma_{\max}
$$

<details>
<summary><font color='#0000FF'>증명</font></summary>
<div markdown="1">

계산의 편의성을 위해 $\lVert A\mathbf x\rVert_2$의 제곱에 대해 계산하고, $\lVert A\mathbf x\rVert_2^2$에 대해 식을 전개한다.

$$
\lVert A\mathbf x\rVert_2^2=(A\mathbf x)^\top A\mathbf x=\mathbf x^\top A^\top A\mathbf x
$$

$A$에 SVD 적용하여 식을 전개한다.

$$
A^\top A=(U\Sigma V^\top)^\top(U\Sigma V^\top)=V\Sigma^\top U^\top U\Sigma V^\top=V\Sigma^\top\Sigma V^\top
$$

$$
\lVert A\mathbf x\rVert_2^2=\mathbf x^\top V(\Sigma^\top\Sigma)V^\top\mathbf x
$$

$\mathbf{y}=V^\top\mathbf{x}$로 치환하면 아래와 같이 전개할 수 있다.

$$
\lVert A\mathbf x\rVert_2^2=\mathbf{y}^\top(\Sigma^\top\Sigma)\mathbf{y}=
\sigma_1^2\mathbf y_1^2+\sigma_2^2\mathbf y_2^2+\cdots+\sigma_r^2\mathbf y_r^2
$$

$V$는 직교 행렬이기 때문에 $\mathbf{x}$의 크기를 바꾸지 않으며, $\rVert\mathbf{x}\lVert_2^2=1$을 가정했으므로 아래의 식이 성립한다.

$$
\rVert\mathbf{y}\lVert_2^2=\rVert V^\top\mathbf{x}\lVert_2^2=\rVert\mathbf{x}\lVert_2^2=1
~\to~
\rVert\mathbf{y}\lVert_2^2=y_1^2+y_2^2+\cdots=1
$$

특이값은 크기가 큰 순서부터 정렬되어 있으며, 위의 조건이 아래에서 $\lVert A\mathbf x\rVert_2^2$가 최대값이 되기 위해서는 $\sigma_1$에 가중치를 몰아줘아 한다.

즉, $\lVert A\mathbf x\rVert_2^2$는 $y_1=1$일 때 최대값 $\sigma_1^2$을 가진다.

이 때문에 아래와 같은 결론을 얻을 수 있다.

$$
\lVert A\rVert_2=\sigma_1=\sigma_{\max}
$$

---

</div>
</details>

<details>
<summary><font color='#FF0000'>Example 4</font></summary>
<div markdown="1">

$$
A=\begin{bmatrix}1&5&0\\5&1&0\end{bmatrix}
$$

---

$$
\sigma_1=6,\sigma_2=4
$$

$$
\lVert A\rVert_2=\sigma_{\max}=6
$$

---

</div>
</details>
