---
layout: single
title: "[선형대수] Gradients"
last_modified_at: 2024-11-18
categories: ["인공지능 수학"]
tags: ["선형대수"]
excerpt: "Gradient & Jacobian"
use_math: true
toc: true
toc_sticky: true
---

## Differentiation

$$
\Delta y=f(x+\Delta x)-f(x)=\alpha\Delta x
$$

입력을 흔들었을 때($\Delta x$) 출력이 흔들리는 정도($\Delta y$)의 관계를 나타낸다.

### Derivate

$$
f'(x)=\frac{df}{dx}
$$

미분 또는 도함수라고 부르며, 스칼라 → 스칼라 함수 $f:\mathbb{R}\mapsto\mathbb{R}$의 변화율을 나타낸다.

### Gradient

$$
\nabla_\mathbf x f(\mathbf x)=
\frac{df}{d\mathbf x}=
\begin{bmatrix}
\frac{\partial f(\mathbf x)}{\partial x_1}&\cdots&\frac{\partial f(\mathbf x)}{\partial x_n}
\end{bmatrix}
\in\mathbb{R}^n
$$

벡터 → 스칼라 함수 $f:\mathbb{R}^n\mapsto\mathbb{R}$에 대해, 각 입력 변수에 대한 편미분을 열 벡터 형태로 모은 것을 의미한다.

$$f(\mathbf x)=f(x_1,\dots,x_n)$$

### Jacobian

$$
J=\nabla_\mathbf x \mathbf f(\mathbf x)=
\frac{d\mathbf f}{d\mathbf x}=
\begin{bmatrix}
\frac{\partial \mathbf f(\mathbf x)}{\partial x_1}&\cdots&\frac{\partial \mathbf f(\mathbf x)}{\partial x_n}
\end{bmatrix}=
\begin{bmatrix}
\frac{\partial f_1(\mathbf x)}{\partial x_1}&\cdots&\frac{\partial f_1(\mathbf x)}{\partial x_n}\\
\vdots&&\vdots\\
\frac{\partial f_m(\mathbf x)}{\partial x_1}&\cdots&\frac{\partial f_m(\mathbf x)}{\partial x_n}
\end{bmatrix}
\in\mathbb{R}^{m\times n}
$$

벡터 → 벡터 함수 $\mathbf f:\mathbb{R}^n\to\mathbb{R}^m$에 대해, 각 출력 성분 $f_i$를 각 입력 변수 $x_j$에 대해 편미분한 값들을 행렬 형태로 모은 것을 의미한다.

$$\mathbf f(\mathbf x)=
\begin{bmatrix}
f_1(\mathbf x)\\\vdots\\f_n(\mathbf x)
\end{bmatrix}$$

## Graident 계산법

### 벡터 미분

$$
f(\mathbf x+\Delta\mathbf x)-f(\mathbf x)=\Box\Delta\mathbf x
$$

위의 공식에서 $\Box$에 들어갈 값이 $f(\mathbf x)$의 gradient이다.

<details>
<summary><font color='red'>Example</font></summary>
<div markdown="1">

1. $\displaystyle\frac{\partial A\mathbf x}{\partial\mathbf x}=A
    ~\rightarrow~A(\mathbf{x}+\Delta\mathbf{x})-A\mathbf{x}=A\Delta\mathbf{x}$
2. $\displaystyle\frac{\partial \mathbf x^\top A\mathbf x}{\partial\mathbf x}=\mathbf x^\top(A+A^\top)
    ~\rightarrow~(\mathbf x+\Delta\mathbf{x})^\top A(\mathbf x+\Delta\mathbf{x})-\mathbf x^\top A\mathbf x=\mathbf x^\top(A+A^\top)\Delta\mathbf{x}$
3. $\displaystyle\frac{\partial\left<\mathbf x\cdot\mathbf x\right>}{\partial\mathbf x}=2\mathbf x^\top
    ~\rightarrow~(\mathbf{x}+\Delta\mathbf{x})^\top(\mathbf{x}+\Delta\mathbf{x})-\mathbf{x}^\top\mathbf{x}=2\mathbf x^\top\Delta\mathbf{x}$

</div>
</details>

### 행렬 미분

$$
f(X+\Delta X)-f(X)=\text{tr}(\Box\Delta X)
$$

위의 공식에서 $\Box$에 들어갈 값이 $f(X)$의 gradient이다.

<details>
<summary><font color='red'>Example1</font></summary>
<div markdown="1">

$$
\frac{\partial \mathbf{a}^\top X\mathbf{b}}{\partial X}=\mathbf b\mathbf a^\top
$$

---

$\text{tr}(\mathbf{a}^\top (X+\Delta X)\mathbf{b}-\mathbf{a}^\top X\mathbf{b})=\text{tr}(\mathbf{a}^\top \Delta X\mathbf{b})=\text{tr}(\mathbf{b}\mathbf{a}^\top \Delta X)$

</div>
</details>

<details>
<summary><font color='red'>Example2</font></summary>
<div markdown="1">

$$
\frac{\partial \log X^{-1}}{\partial X}=X^{-1}
$$

---

1. $Y=X^{-1}$라고 가정한 후, $\Delta Y$ 구하기

    $\displaystyle
    (X+\Delta X)(Y+\Delta Y)=I\rightarrow XY+X\Delta Y+\Delta XY=I\rightarrow\Delta Y=-X^{-1}\Delta XX^{-1}
    $
2. $X^{-1}=Y$ 치환 해 $Y$에 대한 식으로 표현 후, 전개

    $\displaystyle
    \text{tr}\big(\log(X+\Delta X)^{-1}-\log X^{-1}\big)
    =\text{tr}\big(\log(Y+\Delta Y)-\log Y\big)
    $

    $\displaystyle
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=\text{tr}\big(\log(I+Y^{-1}\Delta Y)\big)
    $

    $\displaystyle
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    =\text{tr}\big(\log(I+Y^{-1}\Delta Y)\big)\approx\text{tr}(Y^{-1}\Delta Y)
    $    
3. 다시 $X$에 대한 식으로 표현

    $\displaystyle
    \text{tr}(Y^{-1}\Delta Y)=\text{tr}(-XX^{-1}\Delta XX^{-1})=\text{tr}(-X^{-1}\Delta X)
    $

</div>
</details>

<details>
<summary><font color='red'>Example3</font></summary>
<div markdown="1">

$$
\frac{\partial\ln \lvert aX\rvert}{\partial X}=X^{-1}
$$

---

1. $\log$ 성질을 사용해 식 전개

    $\displaystyle
    \text{tr}\big(\ln\text{det}(aX+a\Delta X)-\ln\text{det}(aX)\big)
    =\text{tr}\big(\ln\frac{\text{det}(aX)\text{det}(I+X^{-1}\Delta X)}{\text{det}(aX)}\big)
    $

    $
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    =\text{tr}\big(\ln\text{det}(I+X^{-1}\Delta X)\big)
    $
2. $\text{det}(I+\Delta)=1+\text{tr}(\Delta)$ 사용 해 전개

    $\displaystyle
    \text{tr}\big(\ln\text{det}(I+X^{-1}\Delta X)\big)=\text{tr}\big(\ln(1+\text{tr}(X^{-1}\Delta X))\big)
    $

3. 1차 근사 $\log(1+x)\approx x$ 사용 해 전개

    $\displaystyle
    \text{tr}\big(\ln(1+\text{tr}(X^{-1}\Delta X))\big)\approx\text{tr}(X^{-1}\Delta X)
    $

</div>
</details>
