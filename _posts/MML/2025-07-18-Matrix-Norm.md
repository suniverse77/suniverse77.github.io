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

가장 직관적인 의미는 **"이 행렬이 벡터를 최대 몇 배까지 늘릴(stretch) 수 있는가?"**

### Norm의 조건

행렬 norm도 벡터 norm과 같이 만족해야 할 조건이 필요하다.

1. Absolutely homogeneous

   $\lVert\lambda A\rVert=\lambda\lVert A\rVert$

2. Triangle inequality

   $\lVert A+B\rVert\leq\lVert A\rVert+\lVert B\rVert$

3. Positive definite

   $\lVert A\rVert\geq0$

   $\lVert A\rVert=0\iff A=\mathbf{0}_{m,n}$

## Spectral Norm

Matrix norm에는 여러 종류가 있으며, 그 중 spectral norm은 아래와 같이 정의된다.

$$
\displaystyle\lVert A\rVert_2:=\underset{\mathbf{x}}{\max}\frac{\lVert A\mathbf x\rVert_2}{\lVert \mathbf x\rVert_2}=\underset{\mathbf{x}}{\max}\lVert A\mathbf x\rVert_2
$$

즉, spectral norm은 변환 전후의 크기 변화의 최대값으로 정의되며, 이는 $A$의 가장 큰 특이값과 동일하다.

<details>
<summary><font color='#0000FF'>증명</font></summary>
<div markdown="1">

계산의 편의성을 위해 $\lVert A\mathbf x\rVert_2$의 제곱에 대해 계산하고, $\rVert\mathbf{x}\lVert_2=1$이라고 가정한다.

1. Norm의 제곱

    $$
    \lVert A\mathbf x\rVert_2^2=(A\mathbf x)^\top A\mathbf x=\mathbf x^\top A^\top A\mathbf x
    $$

2. $A$에 SVD 적용

    $$
    A^\top A=(U\Sigma V^\top)^\top(U\Sigma V^\top)=V\Sigma^\top U^\top U\Sigma V^\top=V\Sigma^\top\Sigma V^\top
    $$

3. $\lVert A\mathbf x\rVert_2$에 대입

    $$
    \lVert A\mathbf x\rVert_2^2=\mathbf x^\top V(\Sigma^\top\Sigma)V^\top\mathbf x
    $$

4. $\mathbf{y}=V^\top\mathbf{x}$로 치환

    $$
    \lVert A\mathbf x\rVert_2^2=\mathbf{y}^\top(\Sigma^\top\Sigma)\mathbf{y}
    $$

    $V$는 직교 행렬이기 때문에 $\mathbf{x}$의 크기를 바꾸지 않는다.

    따라서 $\rVert\mathbf{y}\lVert_2^2=\rVert V^\top\mathbf{x}\lVert_2^2=\rVert\mathbf{x}\lVert_2^2=1$이다.
    
5. 최대값 찾기

    $$
    \lVert A\mathbf x\rVert_2^2=\mathbf{y}^\top(\Sigma^\top\Sigma)\mathbf{y}=
    \sigma_1^2\mathbf y_1^2+\sigma_2^2\mathbf y_2^2+\cdots+\sigma_r^2\mathbf y_r^2
    $$

    $\rVert\mathbf{y}\lVert_2^2=y_1^2+y_2^2+\cdots=1$의 조건이 있으며, 특이값은 크기순으로 정렬되어있기 때문에 위의 식이 제일 커지려면 $\sigma_1$에 가중치를 몰아주면 된다.

    즉, $\lVert A\mathbf x\rVert_2^2$는 $y_1=1$일 때 최대값 $\sigma_1^2$을 가진다.

6. 결론

    양쪽에 제곱근을 취하면 아래와 같은 결과를 얻을 수 있다.

    $$
    \underset{\lVert\mathbf{x}\rVert_2^2=1}{\max}\lVert A\mathbf x\rVert_2=\sigma_1
    $$

</div>
</details>
<br>
