---
title: "최소 제곱법 (Least Square Method)"
date: 2025-08-15
categories: [Mathematics, Linear Algebra, Matrix Calculus]
math: true
toc: true
published: true
---

## 최소 제곱법 (Least Square Method)

**최소 제곱법**은 연립 선형 방정식 $A\vx=\vb$의 해가 존재하지 않을 때, $\vb$에 가장 가까운 근사식 $A\vx=\hat{\vb}$를 찾는 방법이다.

이때 가장 가깝다는 뜻은 오차 벡터 $\vb−A\vx$의 Norm이 최소가 된다는 의미이며, 따라서 최적의 해 $\hat{\vx}$은 아래와 같이 정의된다.

$$
\hat{\vx}=\underset{\vx}{\arg\min}\lVert\vb−A\vx\rVert
\tag{1}
$$

예를 들어, 아래의 왼쪽 그림에서 모든 점을 완벽히 통과하는 직선은 찾을 수 없다.
<br>
따라서 오른쪽 그림처럼 여러 개의 직선을 그어 보면서, 각 점과의 오차가 가장 작아지는 직선을 찾는 과정으로 이해할 수 있다.

![fig1](Least_Square-1.png)
_[[출처]](https://darkpgmr.tistory.com/56)_

이때 최소 제곱 해 (Least Squares Solution)는 다음과 같다.

$$
\hat{\vx}=(A^\top A)^{-1}A^\top\vb
\tag{2}
$$

::: 식 (2) 유도
$\lVert\vb−A\vx\rVert$의 최소값을 찾는 것이 목표이기 때문에, 함수를 $\lVert\vb−A\vx\rVert_2^2$으로 바꿔도 동치이다.

$$\hat{\vx}=\underset{\vx}{\arg\min}\lVert\vb−A\vx\rVert_2^2$$

$\lVert\vb−A\vx\rVert_2^2$은 다음과 같이 전개된다.

$$\lVert\vb−A\vx\rVert_2^2=\left(\vb−A\vx\right)^\top\left(\vb−A\vx\right)$$

좌변을 다음과 같이 전개할 수 있다.

$$\begin{aligned}\left(\vb−A\vx\right)^\top\left(\vb−A\vx\right)&=\vx^\top A^\top A\vx-\vx^\top A^\top\vb-\vb^\top A\vx+\vb^\top\vb\\&=\vx^\top A^\top A\vx-2\vb^\top A\vx+\vb^\top\vb\end{aligned}$$

최소값을 구하기 위해, $\vx$에 대해 편미분을 수행하여 $0$이 되는 지점을 찾는다.

$$\frac{\partial}{\partial\vx}\lVert\vb−A\vx\rVert_2^2=0$$

$\vb^\top\vb$는 $\vx$에 무관하기 때문에, 다음과 같이 정리할 수 있다.

$$\begin{aligned}\frac{\partial}{\partial\vx}\lVert\vb−A\vx\rVert_2^2&=\frac{\partial}{\partial\vx}\left(\vx^\top A^\top A\vx-2\vb^\top A\vx\right)\\&=2\vx^\top A^\top A-2\vb^\top A\end{aligned}$$

즉, 다음의 식을 만족하는 $\vx$를 찾으면 된다.

$$2\vx^\top A^\top A-2\vb^\top A=0$$

이항하여 정리하면 다음의 식이 도출된다.

$$\vx^\top A^\top A=\vb^\top A~\to~\vx^\top=\left(A^\top A\right)^{-1}\vb^\top A$$

양변에 Transpose를 취해, 최종적으로 최소 제곱 해를 구할 수 있다.

$$\vx=(A^\top A)^{-1}A^\top\vb$$
:::
<br>

최소 제곱 해를 의사 역행렬을 이용해 아래와 같이 표현할 수 있다.

$$
\hat{\vx}=A^+\vb
\tag{3}
$$
