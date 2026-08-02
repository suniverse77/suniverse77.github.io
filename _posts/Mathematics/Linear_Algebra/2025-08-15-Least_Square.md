---
title: "[선형대수] 최소 제곱법 (Least Square Method)"
date: 2025-08-15 00:00:00 +/-TTTT
categories: [Mathematics, 선형대수]
tags: [선형대수]
math: true
toc: true
author: sunho
---

## 최소 제곱법 (Least Square Method)

**최소 제곱법**은 연립 선형 방정식 $A\mathbf{x}=\mathbf{b}$의 해가 존재하지 않을 때, $\mathbf{b}$에 가장 가까운 근사식 $A\mathbf{x}=\hat{\mathbf{b}}$를 찾는 방법이다.

이때 가장 가깝다는 뜻은 오차 벡터 $\mathbf{b}−A\mathbf{x}$의 Norm이 최소가 된다는 의미이며, 따라서 최적의 해 $\hat{\mathbf{x}}$은 아래와 같이 정의된다.

$$
\hat{\mathbf{x}}=\underset{\mathbf{x}}{\arg\min}\lVert\mathbf{b}−A\mathbf{x}\rVert
\tag{1}
$$

예를 들어, 아래의 왼쪽 그림에서 모든 점을 완벽히 통과하는 직선은 찾을 수 없다.
<br>
따라서 오른쪽 그림처럼 여러 개의 직선을 그어 보면서, 각 점과의 오차가 가장 작아지는 직선을 찾는 과정으로 이해할 수 있다.

![fig1](/assets/images/Mathematics/Linear_Algebra/Least_Square-1.png){: style="display:block; margin:0 auto; width:80%;"}
_[[출처]](https://darkpgmr.tistory.com/56)_

이때 최소 제곱 해 (Least Squares Solution)는 다음과 같다.

$$
\hat{\mathbf{x}}=(A^\top A)^{-1}A^\top\mathbf{b}
\tag{2}
$$

<details>
<summary><font color='#0000FF'>식 (2) 유도</font></summary>
<div markdown="1">

> $\lVert\mathbf{b}−A\mathbf{x}\rVert$의 최소값을 찾는 것이 목표이기 때문에, 함수를 $\lVert\mathbf{b}−A\mathbf{x}\rVert_2^2$으로 바꿔도 동치이다.
>
> $$\hat{\mathbf{x}}=\underset{\mathbf{x}}{\arg\min}\lVert\mathbf{b}−A\mathbf{x}\rVert_2^2$$
>
> $\lVert\mathbf{b}−A\mathbf{x}\rVert_2^2$은 다음과 같이 전개된다.
>
> $$\lVert\mathbf{b}−A\mathbf{x}\rVert_2^2=\left(\mathbf{b}−A\mathbf{x}\right)^\top\left(\mathbf{b}−A\mathbf{x}\right)$$
>
> 좌변을 다음과 같이 전개할 수 있다.
>
> $$\begin{aligned}\left(\mathbf{b}−A\mathbf{x}\right)^\top\left(\mathbf{b}−A\mathbf{x}\right)&=\mathbf{x}^\top A^\top A\mathbf{x}-\mathbf{x}^\top A^\top\mathbf{b}-\mathbf{b}^\top A\mathbf{x}+\mathbf{b}^\top\mathbf{b}\\&=\mathbf{x}^\top A^\top A\mathbf{x}-2\mathbf{b}^\top A\mathbf{x}+\mathbf{b}^\top\mathbf{b}\end{aligned}$$
>
> 최소값을 구하기 위해, $\mathbf{x}$에 대해 편미분을 수행하여 $0$이 되는 지점을 찾는다.
>
> $$\frac{\partial}{\partial\mathbf{x}}\lVert\mathbf{b}−A\mathbf{x}\rVert_2^2=0$$
>
> $\mathbf{b}^\top\mathbf{b}$는 $\mathbf{x}$에 무관하기 때문에, 다음과 같이 정리할 수 있다.
>
> $$\begin{aligned}\frac{\partial}{\partial\mathbf{x}}\lVert\mathbf{b}−A\mathbf{x}\rVert_2^2&=\frac{\partial}{\partial\mathbf{x}}\left(\mathbf{x}^\top A^\top A\mathbf{x}-2\mathbf{b}^\top A\mathbf{x}\right)\\&=2\mathbf{x}^\top A^\top A-2\mathbf{b}^\top A\end{aligned}$$
>
> 즉, 다음의 식을 만족하는 $\mathbf{x}$를 찾으면 된다.
>
> $$2\mathbf{x}^\top A^\top A-2\mathbf{b}^\top A=0$$
>
> 이항하여 정리하면 다음의 식이 도출된다.
>
> $$\mathbf{x}^\top A^\top A=\mathbf{b}^\top A~\to~\mathbf{x}^\top=\left(A^\top A\right)^{-1}\mathbf{b}^\top A$$
>
> 양변에 Transpose를 취해, 최종적으로 최소 제곱 해를 구할 수 있다.
>
> $$\mathbf{x}=(A^\top A)^{-1}A^\top\mathbf{b}$$

</div>
</details>
<br>

최소 제곱 해를 의사 역행렬을 이용해 아래와 같이 표현할 수 있다.

$$
\hat{\mathbf{x}}=A^+\mathbf{b}
\tag{3}
$$
