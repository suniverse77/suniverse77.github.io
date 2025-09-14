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

## 선형 결합 (Linear Combination)

선형 결합이란 

벡터를 상수배하고 더하는 두 가지 기본 연산으로 이루어져 있는 1차식 형태이기 때문에 **선형**이고, 여러 개의 벡터를 함께 사용하여 새로운 벡터를 만들어내기 때문에 **결합**이라고 표현한다.

$$
\mathbf{v}=c_1\mathbf{v}_1+\cdots+c_n\mathbf{v}_n
$$

예를 들어, 2차원 평면에서 

$$
\begin{bmatrix}2\\4\end{bmatrix}=
2\cdot\begin{bmatrix}1\\0\end{bmatrix}+4\cdot\begin{bmatrix}0\\1\end{bmatrix}
=2\mathbf{i}+4\mathbf{j}
$$

## 선형 생성 (Span)

벡터 집합 $\mathcal{V}$에 있는 벡터들의 가능한 모든 선형 결합으로 만들어지는 집합을 $\text{span}(\mathcal{V})$라고 한다.

2차원 공간에서 $\mathbf{v}$와 $\mathbf{w}$의 span은 두 벡터의 모든 선형 결합의 집합 $a\mathbf{v}+b\mathbf{w}$이며, 두 벡터가 일렬로 있지 않다면 span의 결과는 2차원 공간의 벡터 전체가 된다.

<details>
<summary><font color='red'>Example</font></summary>
<div markdown="1">
<br>

$$
\text{span}(\begin{bmatrix}1\\0\end{bmatrix},\begin{bmatrix}0\\1\end{bmatrix})=\mathbb{R}^2
$$

$$
\text{span}(\begin{bmatrix}2\\1\end{bmatrix},\begin{bmatrix}1\\3\end{bmatrix})=\begin{bmatrix}2a+b\\a+3b\end{bmatrix}=\mathbb{R}^2
$$

</div>
</details>
<br>

## 선형 독립 (Linear Independence)

벡터들의 집합 $\lbrace\mathbf{v}_1,\dots,\mathbf{v}_n\rbrace$이 주어졌을 때,

$$
\mathbf{0}=\lambda_1\mathbf{v}_1+\cdots+\lambda_n\mathbf{v}_n
$$

을 만족하는 스칼라 $\lambda_1,\cdots,\lambda_n$이 오직 $\lambda_1=\cdots=\lambda_2=0$일 때만 존재한다면 (trivial solution만 존재한다면), 이 벡터 집합을 선형 독립이라고 한다.

만약 0이 아닌 $\lambda$가 존재한다면 $\lambda_1\mathbf{v}_1=-\lambda_2\mathbf{v}_2-\lambda_n\mathbf{v}_3$처럼 한 벡터가 다른 벡터들의 조합으로 표현될 수 있으며, 이를 선형 종속이라고 한다.

즉, 선형 독립이란 집합 내의 어떤 벡터도 다른 벡터들의 조합으로 만들어지지 않는다는 것을 의미한다.

선형 독립이 중요한 이유는 해당 벡터들이 span할 수 있는 공간의 차원과 연관되어 있기 때문이다.

예를 들어, $\mathbf{v}_1=(1,1)$과 $\mathbf{v}_2=(2,2)$는 서로 비례 관계이므로 선형 종속이다. 따라서 두 벡터를 아무리 조합해도 결국 하나의 직선 (1차원 공간)밖에 만들 수 없다. 이 경우 하나의 벡터를 제거해도 span되는 공간은 변하지 않는다.

반면 $\mathbf{v}_1=(1,1)$과 $\mathbf{v}_2=(1,2)$는 선형 독립이므로, 이들의 조합으로 2차원 전체를 다 표현할 수 있다. 이 경우에는 벡터 중 하나라도 제거하면 span되는 공간의 차원이 줄어들게 된다.

### 선형 독립의 성질

1. 벡터 집합 내 하나라도 $\mathbf{0}$이 존재한다면, 해당 집합은 선형 종속이다. ($\mathbf{0}$은 스칼라배로 표현될 수 있기 때문이다.)
2. 행렬에서 non-pivot column은 항상 그 왼쪽에 존재하는 pivot column들의 선형 결합으로 표현된다.
   
   $$
   \begin{bmatrix}1&3&0\\0&0&2\end{bmatrix} → \begin{bmatrix}3\\0\end{bmatrix}=3\begin{bmatrix}1\\0\end{bmatrix}
   $$

### 선형 독립을 판단하는 방법

벡터 집합이 선형 독립인지 판단하는 방법에는 크게 2가지가 있다.

**1. 행렬의 pivot column 확인**

   열벡터로 이루어진 행렬을 REF로 변환했을 때 모든 열이 pivot column이면, 벡터 집합은 선형 독립이다.
    
   즉, pivot column들이 선형 독립이어야 한다.
    
**2. 동차 방정식 (Homogeneous Equation)의 해 확인**

   동차 방정식 $\sum\lambda_i\mathbf{v}_i=\mathbf{0}$의 해 $\boldsymbol\lambda$가 오직 trivial solution만 존재한다면, 벡터 집합은 선형 독립이다.
    
   즉, 변수 $\lambda_i$에 free variable이 존재하면 안된다.

<details>
<summary><font color='red'>Example</font></summary>
<div markdown="1">

아래의 벡터들이 선형 독립인지 판단

$$
\begin{bmatrix}1\\2\\-3\\4\end{bmatrix}
~,~
\begin{bmatrix}1\\1\\0\\2\end{bmatrix}
~,~
\begin{bmatrix}-1\\-2\\1\\1\end{bmatrix}
$$

---

**1. 벡터들을 행렬로 표현**

   $$
   \begin{bmatrix}1&1&-1\\2&1&-2\\-3&0&1\\4&2&1\end{bmatrix}
   $$

**2. 가우스 소거법을 이용해 REF로 변환**

   $$
   \begin{bmatrix}1&1&-1\\0&1&0\\0&0&1\\0&0&0\end{bmatrix}
   $$

**3-1. 행렬의 pivot column 확인**

모든 열이 pivot column이므로, 세 벡터는 선형 독립이다.

**3-2. 동차 방정식의 해 확인**

동차방정식의 해가 trivial solution이므로, 세 벡터는 선형 독립이다.
   
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
