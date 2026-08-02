---
title: "[선형대수] 사영 (Projection)"
date: 2025-07-07 00:00:00 +/-TTTT
categories: [Mathematics, 선형대수]
tags: [선형대수]
math: true
toc: true
author: sunho
---

## 벡터 위로의 사영 (Projection onto a Vector)

기저가 $\mathbf{b}$인 직선 벡터 공간 $\mathcal{U}$가 있을 때, 벡터 $\mathbf{x}$의 $\mathcal{U}$ 위로의 정사영 $\text{proj}_\mathcal{U}(\mathbf{x})$는 다음과 같이 정의된다.

$$
\text{proj}_\mathcal{U}(\mathbf{x})
=\frac{\mathbf{b}\cdot\mathbf{x}}{\mathbf{b}\cdot\mathbf{b}}\mathbf{b}
=\frac{\mathbf{b}^\top\mathbf{x}}{\lVert\mathbf{b}\rVert^2_2}\mathbf{b}
\tag{1}
$$

내적은 $\mathbf{b}^\top\mathbf{x}=\lVert\mathbf{b}\rVert\cdot\lVert\mathbf{x}\rVert\cos\theta$으로 정의되기 때문에 내적값에는 $\lVert\mathbf{b}\rVert_2$이 포함되어 있다.
<br>
또한 $\mathbf{x}$의 정사영의 크기는 $\lVert\mathbf{x}\rVert\cos\theta$이지만, 뒤에 곱해져 있는 $\mathbf{b}$는 단위 벡터가 아니기 때문에 여기에도 $\lVert\mathbf{b}\rVert_2$이 포함되어 있다. 

따라서, 정사영을 구할 때 L2 Norm의 제곱인 $\lVert\mathbf{b}\rVert_2^2$를 나눠야 한다.

![fig1](/assets/images/Mathematics/Linear_Algebra/Projection-1.png){: style="display:block; margin:0 auto; width:70%;"}
_출처: Deisenroth, Faisal, & Ong, <i>Mathematics for Machine Learning</i>_

<details>
<summary><font color='blue'>식 (1) 유도</font></summary>
<div markdown="1">

> **1. $\text{proj}_\mathcal{U}(\mathbf{x})$는 $\mathcal{U}$ 내의 벡터이기 때문에 $\mathbf{b}$의 상수배이다.**
> 
> $$\text{proj}_\mathcal{U}(\mathbf{x})=\lambda\mathbf{b}$$
>
> **2. $\mathbf{x}-\lambda\mathbf{b}$는 $\mathbf{b}$와 직교한다.**
>
> $$\langle\mathbf{x}-\lambda\mathbf{b},\mathbf{b}\rangle=0\to \mathbf{x}^\top\mathbf{b}=\lambda\mathbf{b}^\top\mathbf{b}$$
>
> **3. 수식을 정리한다.**
> 
> $$\lambda=\frac{\mathbf{b}^\top\mathbf{x}}{\mathbf{b}^\top\mathbf{b}}~\to~\text{proj}_\mathcal{U}(\mathbf{x})=\frac{\mathbf{b}^\top\mathbf{x}}{\lVert\mathbf{b}\rVert}\mathbf{b}$$

</div>
</details>

## 부분공간 위로의 사영 (Projection onto Subspaces)

기저 집합이 $B$인 벡터 부분공간 $\mathcal{U}$가 있을 때, 벡터 $\mathbf{x}$의 $\mathcal{U}$ 위로의 정사영 $\text{proj}_\mathcal{U}(\mathbf{x})$는 다음과 같이 정의된다.

$$
\vphantom{\Big(}
\text{proj}_\mathcal{U}(\mathbf{x})=B(B^\top B)^{-1}B^\top\mathbf{x}
\tag{2}
$$

![fig2](/assets/images/Mathematics/Linear_Algebra/Projection-2.png){: style="display:block; margin:0 auto; width:50%;"}
_출처: Deisenroth, Faisal, & Ong, <i>Mathematics for Machine Learning</i>_

<details>
<summary><font color='blue'>식 (2) 유도</font></summary>
<div markdown="1">

> **1. $\text{proj}_\mathcal{U}(\mathbf{x})$는 $\mathcal{U}$ 내의 벡터이기 때문에 기저들의 선형 결합으로 표현될 수 있다.**
>
> $$\text{proj}_\mathcal{U}(\mathbf{x})(\mathbf{x})=\lambda_1\mathbf{b}_1+\cdots+\lambda_m\mathbf{b}_m=B\boldsymbol\lambda$$
>
> **2. $\mathbf{x}-\pi_\mathcal{U}(\mathbf{x})$는 $U$의 basis들과 직교한다.**
>
> $$\langle\mathbf{x}-\pi_\mathcal{U}(\mathbf{x}),\mathbf{b}_1\rangle=0\\\vdots\\\langle\mathbf{x}-\pi_\mathcal{U}(\mathbf{x}),\mathbf{b}_m\rangle=0$$
>
> **3. 위의 수식을 행렬로 표현한다.**
>
> $$\langle\mathbf{x}-B\boldsymbol\lambda,B\rangle=0
\to\mathbf{x}^\top B=(B\boldsymbol\lambda)^\top B$$
>
> **4. 수식을 정리한다.**
>
> $$\vphantom{\Big(}\boldsymbol\lambda=(B^\top B)^{-1}B^\top\mathbf{x}~\to~\text{proj}_\mathcal{U}(\mathbf{x})(\mathbf{x})=B(B^\top B)^{-1}B^\top\mathbf{x}$$

</div>
</details>
<br>

$\mathbf{x}$의 정사영은 $\mathcal{U}$의 기저들의 선형 결합으로 표현될 수 있다. 따라서 선형 결합 계수 $\lambda$만 안다면 $\text{proj}_\mathcal{U}(\mathbf{x})$를 바로 구할 수 있다.

$$
\text{proj}_\mathcal{U}(\mathbf{x})=B\boldsymbol\lambda
\tag{3}
$$

<details>
<summary><font color='#FF0000'><strong>Example:</strong> 부분공간으로 정사영된 벡터 구하기</font></summary>
<div markdown="1">

> 어떤 부분공간 $\mathcal{U}$의 기저 집합이 다음과 같을 때,
>
> $$B=\begin{bmatrix}0&1&-3\\-1&-3&4\\2&1&1\\0&-1&2\\2&2&1\end{bmatrix}$$
>
> 벡터 $\mathbf{x}=\begin{bmatrix}-1\\\\-9\\\\-1\\\\4\\\\1\end{bmatrix}$를 $V$으로 정사영 시킨 결과는 다음과 같이 구할 수 있다.
>
> 먼저 $\mathbf{x}-B\boldsymbol\lambda$와 $B$는 서로 수직이기 때문에, 아래의 식이 성립한다.
>
> $$\langle\mathbf{x}-B\boldsymbol\lambda,B\rangle=0~\to~B^\top(\mathbf{x}-B\boldsymbol\lambda)=0~\to~B^\top\mathbf{x}=B^\top B\boldsymbol\lambda$$
>
> 즉, 아래의 방정식을 풀어 $\boldsymbol\lambda
$를 구하면 $\text{proj}_\mathcal{U}(\mathbf{x})$를 구할 수 있다.
>
> $$[B^\top B\mid B^\top\mathbf{x}]=\begin{bmatrix}\begin{array}{ccc|c}9&9&0&9\\9&16&-14&23\\0&-14&31&-25\end{array}\end{bmatrix}~\to~\boldsymbol\lambda=\begin{bmatrix}-3\\4\\1\end{bmatrix}$$
>
> 결과적으로, 부분공간 $\mathcal{U}$ 위로의 정사영된 벡터는 다음과 같다.
>
> $$\text{proj}_\mathcal{U}(\mathbf{x})=B\boldsymbol\lambda=\begin{bmatrix}1\\-5\\-1\\-2\\3\end{bmatrix}$$

</div>
</details>
<br>
