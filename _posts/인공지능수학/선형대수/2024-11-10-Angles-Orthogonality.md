---
layout: single
title: "[선형대수] Angles & Orthogonality"
last_modified_at: 2024-11-10
categories: ["인공지능 수학"]
tags: ["선형대수"]
excerpt: "벡터와 행렬의 직교성"
use_math: true
toc: true
toc_sticky: true
---

## Angle

$$
\theta=\cos^{-1}\big(\frac{\langle\mathbf{x},\mathbf{y}\rangle}{\lVert\mathbf{x}\rVert\cdot\lVert\mathbf{y}\rVert}\big)
$$

Inner product space에서 두 벡터의 각도는 위와 같이 정의된다.

## Orthogonality

두 벡터 $\mathbf{x}$, $\mathbf{y}$의 내적이 0이라면, 두 벡터는 **orthogonal**하다고 한다.

직교하고 있는 두 벡터의 크기가 1이라면, **orthonormal**하다고 한다.

Square matrix $A$의 column vector들이 orthonormal하면, $A$를 **orthogonal matrix**라고 한다.

- $A$, $B$가 orthogonal matrix라면, $AB$도 orthogonal matrix다.
- $A$가 orthogonal matrix라면, $\text{det}(A)=\pm1$이다.

## Orthonormal Basis

Basis $B=\lbrace\mathbf{b}_1,\dots,\mathbf{b}_n\rbrace$를 orthonormal basis로 변환하는 방법에는 크게 2가지가 있다.

**1. $[BB^\top\vert B]$에 대해 Gauss Elimination 수행**

<details>
<summary><font color='red'>Example</font></summary>
<div markdown="1">

<center><img src='{{"/assets/images/인공지능수학/2-3. Figure1.png" | relative_url}}' width="30%"></center>

---

<center><img src='{{"/assets/images/인공지능수학/2-3. Figure2.png" | relative_url}}' width="100%"></center>

가우스 소거법을 적용해서 아래와 같은 orthonormal basis를 얻을 수 있다.

<center><img src='{{"/assets/images/인공지능수학/2-3. Figure3.png" | relative_url}}' width="40%"></center>

</div>
</details>
<br>
**2. Gram-Schmidt method 적용**

<center><img src='{{"/assets/images/인공지능수학/2-3. Figure4.png" | relative_url}}' width="100%"></center>

  <details>
  <summary><font color='red'>Example</font></summary>
  <div markdown="1">
  
  <center><img src='{{"/assets/images/인공지능수학/2-3. Figure5.png" | relative_url}}' width="30%"></center>
  
  ---
  1. $\mathbf{b}_2$를 $\mathbf{b}_1$ 방향과 $\mathbf{b}_1$에 수직한 벡터의 합으로 분리
     <center><img src='{{"/assets/images/인공지능수학/2-3. Figure6.png" | relative_url}}' width="25%"></center>
  3. $\mathbf{b}_1$에 수직한 벡터를 구함
     <center><img src='{{"/assets/images/인공지능수학/2-3. Figure7.png" | relative_url}}' width="80%"></center>
  5. 크기를 1로 조절해 orthonormal basis로 변환
     <center><img src='{{"/assets/images/인공지능수학/2-3. Figure8.png" | relative_url}}' width="25%"></center>
  
  </div>
  </details>
