---
title: "[최적화] 수학적 최적화 (Mathematical Optimization)"
date: 2025-08-20 00:00:00 +/-TTTT
categories: [인공지능 수학, 최적화]
tags: [최적화]
math: true
toc: true
author: sunho
---

## 선형 계획법 (LP - Linear Programming)

목적함수와 제약조건이 모두 선형식으로 표현된 최적화 문제를 의미한다.

$$
\begin{aligned}\vphantom{\Big(}
\min_{\mathbf x\in\mathbb{R}^d}~\mathbf c^\top\mathbf x~~~~~~~~\\
\text{subject to}~A\mathbf x\leq\mathbf b
\end{aligned}
$$

Primal 문제을 위와 같이 나타낼 수 있으며, 각 차원은 $A\in\mathbb{R}^{m\times d}$ , $\mathbf b\in\mathbb{R}^m$ , $\mathbf c\in\mathbb{R}^d$ , $\mathbf x\in\mathbb{R}^d$이다.

Primal 문제는 $d$개의 변수와 $m$개의 제약 조건을 가진다.

Dual 문제는 아래와 같이 정의된다.

$$
\begin{aligned}\vphantom{\Big(}
\max_{\mathbf \lambda\in\mathbb{R}^m}~-\mathbf b^\top\boldsymbol\lambda~~~~~~~~\\
\text{subject to}~\mathbf c+A^\top\boldsymbol\lambda=0\\
\boldsymbol\lambda\geq0~~~~~~~~~~~~
\end{aligned}
$$

<details>
<summary><font color='blue'>공식 유도</font></summary>
<div markdown="1">

**1. 라그랑주 함수 정의**
    
$$
\vphantom{\Big(}\mathcal{L}(\mathbf x,\boldsymbol\lambda)=\mathbf c^\top\mathbf x+\boldsymbol\lambda^\top(A\mathbf x-\mathbf b)
$$
    
**2. $\nabla\mathcal{L}=0$ 풀기**
    
$$
\mathcal{D}(\boldsymbol\lambda)=
\underset{\mathbf x}\min~\mathcal{L}(\mathbf x,\boldsymbol\lambda)
$$

$$
\nabla_\mathbf x\mathcal{L}(\mathbf x,\boldsymbol\lambda)=\mathbf c^\top+\boldsymbol\lambda^\top A=0~\to~\boldsymbol\lambda^\top A=-\mathbf{c}^\top
$$

**3. $\mathcal{L}(\mathbf x,\boldsymbol\lambda)$에 대입**

$$
\vphantom{\Big(}\mathcal{D}(\boldsymbol\lambda)=-\mathbf b^\top\boldsymbol\lambda
$$

</div>
</details>

## 2차 계획법 (Qudratic Programming)

목적함수가 2차식이고 제약조건이 선형식으로 표현된 최적화 문제를 의미한다.

$$
\begin{aligned}
\min_{\mathbf x\in\mathbb{R}^d}\bigg(\frac{1}{2}\mathbf x^\top Q\mathbf x+\mathbf c^\top\mathbf x\bigg)\\
\text{subject to}~A\mathbf x\leq\mathbf b~~~
\end{aligned}
$$

Primal 문제를 위와 같이 나타낼 수 있으며, 각 차원은 $A\in\mathbb{R}^{m\times d}$ , $\mathbf b\in\mathbb{R}^m$ , $\mathbf c\in\mathbb{R}^d$ , $\mathbf x\in\mathbb{R}^d$이다.

$Q\in\mathbb{R}^{d\times d}$는 양의 정부호 행렬이다.

$$
\begin{aligned}
\max_{\mathbf \lambda\in\mathbb{R}^m}\bigg(-\frac{1}{2}\mathbf b^\top\boldsymbol\lambda\bigg)\\
\text{subject to}~\boldsymbol\lambda\geq0~
\end{aligned}
$$

Dual 문제는 위와 같이 정의된다.

<details>
<summary><font color='blue'>공식 유도</font></summary>
<div markdown="1">

**1. 라그랑주 함수 정의**
    
$$
\mathcal{L}(\mathbf x,\boldsymbol\lambda)=
\frac{1}{2}\mathbf x^\top Q\mathbf x+\mathbf c^\top\mathbf x
+\boldsymbol\lambda^\top(A\mathbf x-\mathbf b)
$$
    
**2. $\nabla\mathcal{L}=0$ 풀기**
    
$$
\vphantom{\Big(}\nabla_\mathbf x\mathcal{L}(\mathbf x,\boldsymbol\lambda)=\mathbf x^\top Q+\mathbf c^\top+\boldsymbol\lambda^\top A=0~\to~\boldsymbol\lambda^\top A=-\mathbf x^\top Q+\mathbf c^\top

$$
    
**3. $\mathcal{L}(\mathbf x,\boldsymbol\lambda)$에 대입**
    
$$
\mathcal{D}(\boldsymbol\lambda)=-\frac{1}{2}(\mathbf c^\top+A^\top\boldsymbol\lambda)^\top Q^{-1}(\mathbf c+A^\top\boldsymbol\lambda)-\boldsymbol\lambda^\top\mathbf b
$$

</div>
</details>
