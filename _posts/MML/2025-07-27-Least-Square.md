---
title: "[선형대수] 최소 제곱법 (Least Square Method)"
date: 2025-07-27 00:00:00 +/-TTTT
categories: [인공지능 수학, 선형대수]
tags: [선형대수]
math: true
toc: true
author: sunho
---

## 최소 제곱법 (Least Square Method)

연립 선형 방정식 $A\mathbf{x}=\mathbf{b}$의 해가 존재하지 않을 때, $\mathbf{b}$에 가장 가까운 근사식 $A\mathbf{x}=\hat{\mathbf{b}}$를 찾는 방법이다.

이때 가장 가깝다는 뜻은 오차 벡터 $\mathbf{b}−A\mathbf{x}$의 norm이 최소가 된다는 의미이며, 따라서 최적의 해 $\hat{\mathbf{x}}$은 아래와 같이 정의된다.

$$
\hat{\mathbf{x}}=\underset{\mathbf{x}}{\argmin}\lVert\mathbf{b}−A\mathbf{x}\rVert
$$

예를 들어, 아래의 왼쪽 그림에서 모든 점을 완벽히 통과하는 직선은 찾을 수 없다. 따라서 오른쪽 그림처럼 여러 개의 직선을 그어 보면서, 각 점과의 오차가 가장 작아지는 직선을 찾는 과정으로 이해할 수 있다.

![fig1](mlm/27-1.png){: style="display:block; margin:0 auto; width:80%;"}
_[[출처]](https://darkpgmr.tistory.com/56)_

이때 최소 제곱 해 (least squares solution)는 다음과 같다.

$$
\hat{\mathbf{x}}=(A^\top A)^{-1}A^\top\mathbf{b}
$$

<details>
<summary><font color='#0000FF'>공식 유도</font></summary>
<div markdown="1">

최소값을 찾는 거기 때문에 동치 

$$
\lVert\mathbf{b}−A\mathbf{x}\rVert\to\lVert\mathbf{b}−A\mathbf{x}\rVert_2^2
=\left(\mathbf{b}−A\mathbf{x}\right)^\top\left(\mathbf{b}−A\mathbf{x}\right)
$$

좌변을 아래와 같이 전개할 수 있다.

$$
\mathbf{x}^\top A^\top A\mathbf{x}-\mathbf{x}^\top A^\top\mathbf{b}-\mathbf{b}^\top A\mathbf{x}+\mathbf{b}^\top\mathbf{b}
=\mathbf{x}^\top A^\top A\mathbf{x}-2\mathbf{b}^\top A\mathbf{x}+\mathbf{b}^\top\mathbf{b}
$$

최소값을 구하기 위해 $\mathbf{x}$에 대해 편미분을 수행하여 0이 되는 지점을 찾는다.

$$
\frac{\partial}{\partial\mathbf{x}}\lVert\mathbf{b}−A\mathbf{x}\rVert_2^2=0
$$

$\mathbf{b}^\top\mathbf{b}$는 $\mathbf{x}$에 무관하기 때문에 아래와 같이 정리할 수 있다.

$$
\frac{\partial}{\partial\mathbf{x}}\lVert\mathbf{b}−A\mathbf{x}\rVert_2^2
=\frac{\partial}{\partial\mathbf{x}}
\left(
\mathbf{x}^\top A^\top A\mathbf{x}-2\mathbf{b}^\top A\mathbf{x}
\right)
=2\mathbf{x}^\top A^\top A-2\mathbf{b}^\top A=0
$$

$$
\mathbf{x}^\top A^\top A=\mathbf{b}^\top A
~\to~\mathbf{x}^\top=\left(A^\top A\right)^{-1}\mathbf{b}^\top A
$$

최종적으로 최소제곱 해는 아래와 같이 얻을 수 있다.

$$
\mathbf{x}=(A^\top A)^{-1}A^\top\mathbf{b}
$$

---

</div>
</details>
<br>

의사 역행렬이기 때문에 아래와 같이 표현할 수 있다.

$$
\hat{\mathbf{x}}=A^+\mathbf{b}
$$
