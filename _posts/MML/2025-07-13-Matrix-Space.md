---
title: "[선형대수] 행렬이 만드는 공간"
date: 2025-07-13 00:00:00 +/-TTTT
categories: [인공지능 수학]
tags: [선형대수]
math: true
toc: true
author: sunho
img_path: /assets/images/math/
description: 📕 열공간 (column space)과 영공간 (null space)
---

## 열공간 (Column space)

크기와 방향을 모두 가진 양을 벡터라고 부르며, 크기만 가진 양을 스칼라라고 부른다.

- 위치벡터: 공간에서 점의 위치를 나타내는 벡터로, 원점을 시점으로 한다.
- 방향벡터: 직선이나 움직임의 방향을 나타내는 벡터로, 크기는 신경 쓰지 않는다.

## 영공간 (Null space)

Homogeneous Equation의 solution을 모두 모아놓은 집합을 Null Space라고 부른다.

$$
N(A)=\lbrace\mathbf{x}\mid A\mathbf{x}=\mathbf{0}\rbrace
$$
    
- 어떠한 null space든지 항상 $\mathbf{0}$를 포함하므로, vector space이다.
- Null space의 차원을 **nullity**라고 하며, free variable의 개수와 동일하다.


