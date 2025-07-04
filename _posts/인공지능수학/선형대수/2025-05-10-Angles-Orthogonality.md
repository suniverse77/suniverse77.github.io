---
layout: single
title: "[선형대수] Angles & Orthogonality"
last_modified_at: 2025-05-10
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

### 1. $[BB^\top\vert B]$에 대해 Gauss Elimination 수행

> ex) ![Figure 1](/assets/images/인공지능수학/2-3. Figure1.png){: style="display:block; margin:0 auto; width: 30%; height: 30%;"}
>
> ---
> ![Figure 2](/assets/images/인공지능수학/2-3. Figure2.png){: style="display:block; margin:0 auto; width: 100%; height: 100%;"}
>
> 가우스 소거법을 적용해서 아래와 같은 orthonormal basis를 얻을 수 있다.
> 
> ![Figure 3](/assets/images/인공지능수학/2-3. Figure3.png){: style="display:block; margin:0 auto; width: 40%; height: 40%;"}

### 2. Gram-Schmidt method 적용

![Figure 4](/assets/images/인공지능수학/2-3. Figure4.png){: style="display:block; margin:0 auto; width: 90%; height: 90%;"}

> ex) ![Figure 5](/assets/images/인공지능수학/2-3. Figure5.png){: style="display:block; margin:0 auto; width: 30%; height: 30%;"}
>
> ---
> 1. $\mathbf{b}_2$를 $\mathbf{b}_1$ 방향과 $\mathbf{b}_1$에 수직한 벡터의 합으로 분리
>    ![Figure 6](/assets/images/인공지능수학/2-3. Figure6.png){: style="display:block; margin:0 auto; width: 30%; height: 30%;"}
> 3. $\mathbf{b}_1$에 수직한 벡터를 구함
>    ![Figure 7](/assets/images/인공지능수학/2-3. Figure7.png){: style="display:block; margin:0 auto; width: 90%; height: 90%;"}
> 5. 크기를 1로 조절해 orthonormal basis로 변환
>    ![Figure 8](/assets/images/인공지능수학/2-3. Figure8.png){: style="display:block; margin:0 auto; width: 30%; height: 30%;"}
