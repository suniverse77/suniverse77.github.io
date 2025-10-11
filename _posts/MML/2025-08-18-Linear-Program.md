---
title: "[최적화] 주성분 분석 (PCA)"
date: 2025-08-18 00:00:00 +/-TTTT
categories: [인공지능 수학, 최적화]
tags: [최적화]
math: true
toc: true
author: sunho
---

## Linear Programming

목적함수와 제약조건이 모두 선형식으로 표현된 최적화 문제를 의미한다.

$$
\underset{\mathbf x\in\mathbb{R}^d}\min~\mathbf c^\top\mathbf x
\\\text{subject to}~~A\mathbf x\leq\mathbf b
$$

Primal problem을 위와 같이 나타낼 수 있으며, 각 차원은 $A\in\mathbb{R}^{m\times d}$ , $\mathbf b\in\mathbb{R}^m$ , $\mathbf c\in\mathbb{R}^d$ , $\mathbf x\in\mathbb{R}^d$이다.

Primal problem은 $d$개의 변수와 $m$개의 제약 조건을 가진다.

$$
\underset{\mathbf \lambda\in\mathbb{R}^m}\max~-\mathbf b^\top\boldsymbol\lambda
\\
\text{subject to}~~
\mathbf c+A^\top\boldsymbol\lambda=0
\\ ~~~~~~~
\boldsymbol\lambda\geq0
$$

Dual problem은 위와 같이 정의된다.

<details>
<summary><font color='blue'>공식 유도</font></summary>
<div markdown="1">

1. Define lagrangian function
    
    $\mathcal{L}(\mathbf x,\boldsymbol\lambda)=\mathbf c^\top\mathbf x+\boldsymbol\lambda^\top(A\mathbf x-\mathbf b)$
    
2. Define dual function
    
    $\mathcal{D}(\boldsymbol\lambda)=
    \underset{\mathbf x}\min~\mathcal{L}(\mathbf x,\boldsymbol\lambda)
    =-\mathbf b^\top\boldsymbol\lambda$
    
    $\nabla_\mathbf x\mathcal{L}(\mathbf x,\boldsymbol\lambda)=0
    \to\mathbf c^\top+\boldsymbol\lambda^\top A=0$

</div>
</details>

## Qudratic Programming

목적함수가 2차식이고 제약조건이 선형식으로 표현된 최적화 문제를 의미한다.

$$
\underset{\mathbf x\in\mathbb{R}^d}\min~\bigg(
\frac{1}{2}\mathbf x^\top Q\mathbf x+\mathbf c^\top\mathbf x\bigg)
\\
\text{subject to}~~A\mathbf x\leq\mathbf b
$$

Primal problem을 위와 같이 나타낼 수 있으며, 각 차원은 $A\in\mathbb{R}^{m\times d}$ , $\mathbf b\in\mathbb{R}^m$ , $\mathbf c\in\mathbb{R}^d$ , $\mathbf x\in\mathbb{R}^d$이다.

$Q\in\mathbb{R}^{d\times d}$는 symmetric, positive definite 행렬이다.

$$
\underset{\mathbf \lambda\in\mathbb{R}^m}\max~
\bigg(-\frac{1}{2}\mathbf b^\top\boldsymbol\lambda
\bigg)
\\
\text{subject to}~~
\boldsymbol\lambda\geq0
$$

Dual problem은 위와 같이 정의된다.

<details>
<summary><font color='blue'>공식 유도</font></summary>
<div markdown="1">

1. Define Lagrangian
    
    $\mathcal{L}(\mathbf x,\boldsymbol\lambda)=
    \frac{1}{2}\mathbf x^\top Q\mathbf x+\mathbf c^\top\mathbf x
    +\boldsymbol\lambda^\top(A\mathbf x-\mathbf b)$
    
2. Set the gradient of the Lagrangian to zero
    
    $\nabla_\mathbf x\mathcal{L}(\mathbf x,\boldsymbol\lambda)=0
    \to\mathbf x^\top Q+\mathbf c^\top+\boldsymbol\lambda^\top A=0$
    
3. Substitution
    
    $\mathcal{D}(\boldsymbol\lambda)=-\frac{1}{2}(\mathbf c^\top+A^\top\boldsymbol\lambda)^\top Q^{-1}(\mathbf c+A^\top\boldsymbol\lambda)-\boldsymbol\lambda^\top\mathbf b$
    
4. Solve Dual problem
    
    $\nabla_{\boldsymbol\lambda}\mathcal{D}(\boldsymbol\lambda)=0$

</div>
</details>
