---
title: "[선형대수] 행렬식과 역행렬"
date: 2025-07-12 00:00:00 +/-TTTT
categories: [인공지능 수학, 선형대수]
tags: [선형대수]
math: true
toc: true
author: sunho
---

## 행렬식 (Determinant)

정사각 행렬에서만 정의되며, $2\times2$ 행렬에 대해 행렬식은 아래와 같이 정의된다.

$$
A=\begin{bmatrix}a&b\\c&d\end{bmatrix}~\to~
\text{det}(A)=\lvert A\rvert=ad-bc
$$

행렬식의 기하학적 의미는 아래와 같다.

![fig1](mlm/12-1.png){: style="display:block; margin:0 auto; width:70%;"}
_[[출처]](https://m.blog.naver.com/lagrange0115/222087882248)_

1. 행렬을 열 벡터의 집합으로 본다면, 두 열 벡터가 이루는 영역의 너비를 의미한다.
2. 행렬을 변환으로 본다면, 변환에 의해 늘어나는 영역의 너비 변화율을 의미한다.

<details>
<summary><font color='#FF0000'>Example 1</font></summary>
<div markdown="1">

$$
A=\begin{bmatrix}3&0\\0&2\end{bmatrix}
$$

---

$(1,0)$과 $(0,1)$이 이루는 정사각형 영역의 너비는 1이다.

변환 후 각 벡터는 $(3,0)$와 $(0,2)$가 되고, 이 벡터들이 이루는 평행사변형 영역의 너비는 6이다.

너비 변화율은 6이고, 이는 $\text{det}(A)$와 일치한다.

$$
\text{det}(A)=6-0=6
$$

---

</div>
</details>
<br>

행렬식이 0이라는 것은 변환에 의해 공간 전체가 직선 또는 한점으로 찌그러진다는 것을 의미한다. 이 경우 다시 정보를 복원할 수 없기 때문에 역행렬이 존재하지 않는다.

이해하기 쉽게 생각해보면, 행렬식이 0이라는 것은 어떤 숫자에 0을 곱하는 것과 같다.
예를 들어, 숫자 3에 0을 곱하면 0이 된다. 이렇게 0이 되어 버린 결과만 가지고는 원래 숫자가 3이었는지 아니면 다른 어떤 숫자였는지 다시 알아낼 수가 없다.

행렬식이 음수라는 것은 공간의 방향의 뒤집힌 것을 의미한다.

<details>
<summary><font color='#FF0000'>Example 2</font></summary>
<div markdown="1">

$$
A=\begin{bmatrix}2&4\\2&4\end{bmatrix}
~,~
\mathbf{x}_1=\begin{bmatrix}1\\1\end{bmatrix}
,\mathbf{x}_2=\begin{bmatrix}2\\4\end{bmatrix}
$$

---

행렬 $A$의 행렬식은 $0$이다.

$\mathbf{x}_1$과 $\mathbf{x}_2$는 선형 독립이므로, 두 벡터가 span하는 공간은 2차원 평면이다.

$$
\text{span}(\begin{bmatrix}1\\1\end{bmatrix},\begin{bmatrix}2\\4\end{bmatrix})=\mathbb{R}^2
$$

하지만 변환 후의 $\mathbf{x}_1$과 $\mathbf{x}_2$는 서로 같은 벡터로, 직선을 span하는 것을 확인할 수 있다.

$$
AX=\begin{bmatrix}2&4\\2&4\end{bmatrix}
\begin{bmatrix}1&2\\1&4\end{bmatrix}
=\begin{bmatrix}6&20\\6&20\end{bmatrix}
$$

$$
\text{span}(\begin{bmatrix}6\\6\end{bmatrix},\begin{bmatrix}20\\20\end{bmatrix})=\mathbb{R}^1
$$

즉, 행렬식이 $0$인 행렬에 의해 변환된 공간은 차원이 줄어드는 것을 확인할 수 있다.

---

</div>
</details>
<br>

$3\times3$ 행렬에 대해 행렬식은 아래와 같이 정의된다.

$$
A=\begin{bmatrix}a&b&c\\d&e&f\\g&h&i\end{bmatrix}~\to~
\text{det}(A)=
a\begin{vmatrix}e&f\\h&i\end{vmatrix}
-b\begin{vmatrix}d&f\\g&i\end{vmatrix}
+c\begin{vmatrix}d&e\\g&h\end{vmatrix}
$$

3차원에서는 평행육면체 (parallelepiped)의 부피 또는 변환 후 부피의 변화율을 의미한다.

![fig2](mlm/12-2.png){: style="display:block; margin:0 auto; width:70%;"}
_[[출처]](https://taesan5435.tistory.com/entry/%ED%96%89%EB%A0%AC%EC%8B%9DDeterminant-%EC%97%AC%EC%9D%B8%EC%9E%90cofactor-%EC%99%B8%EC%A0%81Cross-product)_

### 행렬식의 성질

1. $\text{det}(AB)=\text{det}(A)\text{det}(B)$
2. $\text{det}(A)=\text{det}(A^\top)$
3. $A$가 가역 행렬이라면, $\text{det}(A^{-1})=\frac{1}{\text{det}(A)}$이 성립한다.
4. $\text{det}(A)=\text{det}(S^{-1}AS)$
5. $T$가 삼각 행렬이라면, $T$의 행렬식은 대각 성분의 곱과 같다.

    $$\text{det}(T)=\prod_i t_{ii}$$
6. 하나의 열 (행)에 어떤 숫자를 곱해서 다른 열 (행)에 더해도 행렬식은 동일하다.
8. 하나의 열 (행)에 상수 $\lambda$를 곱하면 $\text{det}(\lambda A)=\lambda^n\text{det}(A)$
9. 두 열 (행)를 바꾸는 것은 행렬식의 부호를 바꾼다.

(5), (6), (7), (8)번의 성질을 이용해 행렬을 삼각 행렬로 변환하면 행렬식을 쉽게 구할 수 있다.

<details>
<summary><font color='red'>Example 3</font></summary>
<div markdown="1">
  
$$
A=\begin{bmatrix}1&2\\3&4\end{bmatrix}
$$

---

**1. Gauss Elimination 수행**

(6)번 성질에 의해 가우스 소거법을 사용해도 행렬식에는 변화가 없다.

$$
A=\begin{bmatrix}1&2\\0&-2\end{bmatrix}
$$

**2. 삼각행렬에서의 행렬식 계산**

정리한 행렬은 삼각 행렬 형태로, (5)번 성질을 사용해서 쉽게 행렬식을 계산할 수 있다.

$$\text{det}(A)=1\times(-2)=-2$$

---

</div>
</details>


## 역행렬 (Inverse Matrix)

역행렬 $A^{-1}$는 어떤 행렬 $A$에 곱했을 때 단위 행렬 $I$를 만들어주는 행렬을 의미한다.

즉, $AA^{-1}=A^{-1}A=I$가 성립하며, $3\times\frac{1}{3}=1$과 같은 개념이다.

행렬을 선형 변환 관점에서 보면, 역행렬은 원래 변환을 되돌리는 역할을 한다.

예를 들어, 어떤 행렬이 물체를 시계 방향으로 90도 회전시키는 역할을 한다면, 이 행렬의 역행렬은 물체를 반시계 방향으로 90도 회전시켜서 원래 위치로 되돌려놓는 역할을 한다.

![fig3](mlm/10-3.png){: style="display:block; margin:0 auto; width:70%;"}
_[[출처]](https://www.3blue1brown.com/lessons/inverse-matrices)_

역행렬은 정사각 행렬에 대해서만 정의되며, 정사각 행렬 중에서도 역행렬이 존재하는 행렬을 가역 행렬 (Invertible Matrix)이라고 한다.
$A\in\mathbb{R}^{n\times n}$에 대해서 아래 표현은 모두 동일한 의미를 가진다.

- $\text{det}(A)\neq0$
- $\text{rank}(A)=n$ ($A$가 full-rank)

    만약 $\text{rank}(A)<n$ 이면, 변환 후 출력 공간의 차원이 줄어들어 정보를 복원할 수 없게 된다.

- $A\mathbf{x}=\mathbf{b}$가 유일한 해를 가짐

    $A$가 가역 행렬이라면, $\mathbf{x}=A^{-1}\mathbf{b}$이므로 $\mathbf{x}$는 유일한 해를 가지게 된다.

- $A$의 고유값에 0이 없음

    $\text{det}(A)=\prod_{i=1}^n\lambda_i$이 성립하기 때문에 $\text{det}(A)\neq0$이기 위해서는 $\lambda_i\neq0$이어야 한다.

$2\times2$ 행렬에서 역행렬을 계산하는 공식은 아래와 같다.

$$
A=\begin{bmatrix}a&b\\c&d\end{bmatrix}
~\to~
A^{-1}=\frac{1}{\text{det}(A)}\begin{bmatrix}d&-b\\-c&a\end{bmatrix}
$$

$3\times3$ 이상의 행렬은 계산이 복잡해져 역행렬을 직접 구하기가 어렵다.

이때 첨가 행렬 $\left[A\mid I\right]$를 만들어 가우스 소거법을 이용해 좌변을 단위 행렬 $I$로 만들면, 우변에는 자동으로 $A^{-1}$가 만들어진다.

$$
\left[A\mid I\right]~\to~\left[AA^{-1}\mid IA^{-1}\right]
~\to~\left[I\mid A^{-1}\right]
$$

<details>
<summary><font color='#FF0000'>Example 4</font></summary>
<div markdown="1">

$$
A=\begin{bmatrix}1&0&1&0\\0&1&1&0\\1&1&0&1\\1&1&1&0\end{bmatrix}
$$

---

첨가 행렬 $[A\mid I]$를 만든다.

$$
[A\mid I]=
\begin{bmatrix}\begin{array}{cccc|cccc}
1&0&1&0&1&0&0&0\\0&1&1&0&0&1&0&0\\1&1&0&1&0&0&1&0\\1&1&1&0&0&0&0&1
\end{array}\end{bmatrix}
$$

가우스 소거법을 이용해 좌변을 $I$로 만든다.

$$
[A\mid I]~\to~
\begin{bmatrix}\begin{array}{cccc|cccc}
1&0&1&0&1&0&0&0\\0&1&1&0&0&1&0&0\\0&1&-1&1&-1&0&1&0\\0&1&0&0&-1&0&0&1
\end{array}\end{bmatrix}
~\to~
\begin{bmatrix}\begin{array}{cccc|cccc}
1&0&1&0&1&0&0&0\\0&1&1&0&0&1&0&0\\0&0&-2&1&-1&-1&1&0\\0&0&-1&0&-1&-1&0&1
\end{array}\end{bmatrix}
$$

$$
~\to~
\begin{bmatrix}\begin{array}{cccc|cccc}
1&0&1&0&1&0&0&0\\0&1&1&0&0&1&0&0\\0&0&-1&0&-1&-1&0&1\\0&0&-2&1&-1&-1&1&0
\end{array}\end{bmatrix}
~\to~
\begin{bmatrix}\begin{array}{cccc|cccc}
1&0&1&0&1&0&0&0\\0&1&1&0&0&1&0&0\\0&0&-1&0&-1&-1&0&1\\0&0&0&1&1&1&1&-2
\end{array}\end{bmatrix}
$$

$$
~\to~
\begin{bmatrix}\begin{array}{cccc|cccc}
1&0&1&0&1&0&0&0\\0&1&1&0&0&1&0&0\\0&0&1&0&1&1&0&-1\\0&0&0&1&1&1&1&-2
\end{array}\end{bmatrix}
~\to~
\begin{bmatrix}\begin{array}{cccc|cccc}
1&0&0&0&0&-1&0&1\\0&1&0&0&-1&0&0&1\\0&0&1&0&1&1&0&-1\\0&0&0&1&1&1&1&-2
\end{array}\end{bmatrix}
$$

좌변이 $I$가 되었으므로, 우변은 자연스럽게 $A^{-1}$가 된다.

$$
A^{-1}=\begin{bmatrix}0&-1&0&1\\-1&0&0&1\\1&1&0&-1\\1&1&1&-2\end{bmatrix}
$$

---

</div>
</details>
<br>

## 의사 역행렬 (Pseudo-inverse Matrix)

의사 역행렬 $A^{+}$는 역행렬의 개념을 일반화한 행렬을 의미한다.
즉, $A$가 정사각 행렬, 가역 행렬이 아닐 때에도 정의된다.

$A\in\mathbb{R}^{m\times n}$가 $m>n$이고 full-rank일 때, 의사 역행렬은 아래와 같이 정의된다.

$$
A^{+}=(A^\top A)^{-1}A^\top
$$

$A$가 가역 행렬이라면, $A^{-1}=A^{+}$이다.

의사 역행렬 $A^{+}$는 다음 4가지 조건 (Moore-Penrose 조건)을 만족하는 행렬이다.

1. $AA^{+}A = A$
2. $A^{+}AA^{+} = A^{+}$
3. $(AA^{+})^T = AA^{+}$
4. $(A^{+}A)^T = A^{+}A$

선형 변환 관점에서 보면, 의사역행렬은 $A$의 변환을 최대한 되돌리는 근사 행렬이다.

의사 역행렬은 [최소제곱법 (Method of Least Square)](https://suniverse77.github.io/posts/Least-Square/)의 해와 관련이 있다.
