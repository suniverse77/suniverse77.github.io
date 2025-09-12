---
title: "[선형대수] 선형 독립"
date: 2025-07-03 00:00:00 +/-TTTT
categories: [인공지능 수학]
tags: [선형대수]
math: true
toc: true
author: sunho
img_path: /assets/images/math/
description: 👨‍👧‍👧 벡터의 기본 개념
---

## 정의

벡터 집합 내의 벡터들 $\lbrace\mathbf{x_1},\dots,\mathbf{x_n}\rbrace$이 서로들의 선형 결합으로 표현될 수 없을 때, 그 벡터들은 선형 종속이라고 표현한다.

$$
\mathbf{0}=\lambda_1\mathbf{x_1}+\cdots+\lambda_n\mathbf{x_n}=\sum_{i=1}^n\lambda_i\mathbf{x}_i
$$

- 위의 수식이 오직 trivial solution만 가지는 경우 $(\boldsymbol\lambda=\mathbf{0})$ → $\mathbf{x}_i$ are linearly independent
- 위의 수식이 non tirivial solution을 가지는 경우 → $\mathbf{x}_i$ are not linearly independent

### Properties of Linear Independence

1. 벡터 $\mathbf{x_1},\cdots,\mathbf{x_k}$ 중 적어도 하나가 $\mathbf{0}$이라면, linearly dependent하다.
2. 행렬에서 non-pivot column은 왼쪽에 존재하는 column들의 선형 결합으로 표현될 수 있다.
   
   $$
   \begin{bmatrix}1&3&0\\0&0&2\end{bmatrix} → \begin{bmatrix}3\\0\end{bmatrix}=3\begin{bmatrix}1\\0\end{bmatrix}
   $$

## Linear Independence 판단하는 방법

벡터들이 선형 독립인지 판단하는 방법에는 크게 2가지가 있다.

**1. 행렬을 REF로 변환했을 때, 모든 column이 pivot column이어야 한다.**
    
즉, pivot column끼리 linearly independent해야 한다.
    
**2. Homogeneous Equation $\sum\lambda_i\mathbf{x_i}=\mathbf{0}$이 있을 때, 해 $\boldsymbol\lambda$가 오직 trivial solution만 존재해야 한다.**
    
즉, 변수 $\lambda_i$에 free variable이 존재하면 안된다.

<details>
<summary><font color='red'>Example</font></summary>
<div markdown="1">

---

1. 벡터들을 행렬로 표현

   $$
   \begin{bmatrix}1&1&-1\\2&1&-2\\-3&0&1\\4&2&1\end{bmatrix}
   $$
2. Gauss Elimination 수행

   $$
   \begin{bmatrix}1&1&-1\\0&1&0\\0&0&1\\0&0&0\end{bmatrix}
   $$

3. Linearly Independent 판단

   - 모든 column이 pivot column이므로, 세 벡터는 linearly independent하다.
   - Homogeneous Equation의 해가 trivial solution이므로, 세 벡터는 linearly independent하다.
   
     $$
     \lambda_1\begin{bmatrix}1\\0\\0\\0\end{bmatrix}+\lambda_2\begin{bmatrix}1\\1\\0\\0\end{bmatrix}
     +\lambda_3\begin{bmatrix}-1\\0\\1\\0\end{bmatrix}=\begin{bmatrix}0\\0\\0\\0\end{bmatrix}
     $$
     
     위 방정식을 만족시키는 해는 trivial solution밖에 없다.

     $$
     \boldsymbol{\lambda}=\begin{bmatrix}0\\0\\0\end{bmatrix}
     $$

</div>
</details>


