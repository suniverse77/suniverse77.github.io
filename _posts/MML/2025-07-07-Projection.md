---
title: "[선형대수] 정사영 (Orthogonal Projection)"
date: 2025-07-07 00:00:00 +/-TTTT
categories: [인공지능 수학, 선형대수]
tags: [선형대수]
math: true
toc: true
author: sunho
---

## 사영 (Projection)

### 벡터 위로의 사영 (Projection onto a vector)

$$
\text{proj}_U(\mathbf{x})=\frac{\mathbf{b}^\top\mathbf{x}}{\lVert\mathbf{b}\rVert}\mathbf{b}
$$

Basis가 $\mathbf{b}$인 직선 벡터 공간 $U$가 있을 때, 벡터 $\mathbf{x}$의 $U$ 위로의 정사영 $\text{proj}_U(\mathbf{x})$는 위와 같이 정의된다.

내적은 $\mathbf{b}^\top\mathbf{x}=\lVert\mathbf{b}\rVert\cdot\lVert\mathbf{x}\rVert\cos\theta$으로 정의되기 때문에 내적값에는 $\mathbf{b}$의 크기가 포함되어 있다.

$\mathbf{x}$의 그림자 길이는 $\lVert\mathbf{x}\rVert\cos\theta$이기 때문에, 정사영을 구할 때 $\mathbf{b}$의 크기를 나눠야 한다.

![fig1](mlm/7-1.png){: style="display:block; margin:0 auto; width:70%;"}
_출처: Deisenroth, Faisal, & Ong, <i>Mathematics for Machine Learning</i>_

<details>
<summary><font color='blue'>공식 유도</font></summary>
<div markdown="1">

**1. $\text{proj}_U(\mathbf{x})$는 $U$ 내의 벡터이기 때문에 $\mathbf{b}$의 상수배이다.**

$$
\text{proj}_U(\mathbf{x})=\lambda\mathbf{b}
$$

**2. $\mathbf{x}-\lambda\mathbf{b}$는 $\mathbf{b}$와 직교한다.**

$$\langle\mathbf{x}-\lambda\mathbf{b},\mathbf{b}\rangle=0\to \mathbf{x}^\top\mathbf{b}=\lambda\mathbf{b}^\top\mathbf{b}
$$

**3. 수식을 정리한다.**
   
$$
\lambda=\frac{\mathbf{b}^\top\mathbf{x}}{\mathbf{b}^\top\mathbf{b}}~\to~\text{proj}_U(\mathbf{x})=\frac{\mathbf{b}^\top\mathbf{x}}{\lVert\mathbf{b}\rVert}\mathbf{b}
$$

---

</div>
</details>

### 부분공간 위로의 사영 (Projection onto general subspace)

$$
\text{proj}_U(\mathbf{x})=B(B^\top B)^{-1}B^\top\mathbf{x}
$$

Basis 집합이 $B$인 벡터 부분공간 $U$가 있을 때, 벡터 $\mathbf{x}$의 $U$ 위로의 정사영 $\text{proj}_U(\mathbf{x})$는 위와 같이 정의된다.

![fig2](mlm/7-2.png){: style="display:block; margin:0 auto; width:70%;"}
_출처: Deisenroth, Faisal, & Ong, <i>Mathematics for Machine Learning</i>_

<details>
<summary><font color='blue'>공식 유도</font></summary>
<div markdown="1">

**1. $\text{proj}_U(\mathbf{x})$는 $U$ 내의 벡터이기 때문에 basis들의 선형 결합으로 표현될 수 있다.**

$$
\text{proj}_U(\mathbf{x})(\mathbf{x})=\lambda_1\mathbf{b}_1+\cdots+\lambda_m\mathbf{b}_m=B\boldsymbol\lambda
$$

**2. $\mathbf{x}-\pi_U(\mathbf{x})$는 $U$의 basis들과 직교한다.**

$$
\langle\mathbf{x}-\pi_U(\mathbf{x}),\mathbf{b}_1\rangle=0
\\
\vdots
\\
\langle\mathbf{x}-\pi_U(\mathbf{x}),\mathbf{b}_m\rangle=0
$$

**3. 위의 수식을 행렬로 표현한다.**

$$
\langle\mathbf{x}-B\boldsymbol\lambda,B\rangle=0
\to
\mathbf{x}^\top B=(B\boldsymbol\lambda)^\top B
$$
   
**4. 수식을 정리한다.**

$$
\boldsymbol\lambda=(B^\top B)^{-1}B^\top\mathbf{x}~\to~\text{proj}_U(\mathbf{x})(\mathbf{x})=B(B^\top B)^{-1}B^\top\mathbf{x}
$$

---

</div>
</details>
