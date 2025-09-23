---
title: "[선형대수] 선형 사상"
date: 2025-07-14 00:00:00 +/-TTTT
categories: [인공지능 수학, 선형대수]
tags: [선형대수]
math: true
toc: true
author: sunho
img_path: /assets/images/math/
description: ✏️ 벡터의 기본 개념
---

## 선형 사상 (Linear Mappings)

아래의 조건을 만족시키는 사상 $\Phi : V → W$를 선형 사상이라고 부른다.

1. $\Phi(\mathbf{x}+\mathbf{y})=\Phi(\mathbf{x})+\Phi(\mathbf{y})$
2. $\Phi (\lambda \mathbf{x})=\lambda \Phi (\mathbf{x})$

사상은 함수라고도 하며, $V$를 정의역, $W$를 치역이라고 생각하면 된다.

![fig1](mlm/10-1.png){: style="display:block; margin:0 auto; width:90%;"}

### 단사 (Injective)

$$
\Phi (\mathbf{x})=\Phi (\mathbf{y})\implies\mathbf{x}=\mathbf{y}
$$

- 정의역과 공역의 치역이 일대일로 mapping
- 입력과 대응되지 않는 출력도 존재
- 입력값이 다르면 출력값도 다름
  
### 전사 (Surjective)

$$
\Phi (V)=W
$$

- 공역과 치역이 동일
- 모든 출력이 적어도 하나의 입력과 대응됨
  
### 전단사 (Bijective)

- injective하면서 surjective함
- 서로 완전히 일대일 대응됨
- inverse mapping $\Phi^{-1}=\Psi:W\to V$가 존재

## 이미지와 커널 (Image & Kernel)

![fig1](mlm/10-2.png){: style="display:block; margin:0 auto; width:60%;"}

### Image

선형 사상 $\Phi : V → W$ 에 대해, $V$가 mapping되는 $W$의 벡터들의 집합을 image라고 한다.

$$

$$

### Kernel



선형 사상 $\Phi : V → W$ 에 대해, $\Phi$에 의해 $\mathbf{0}_W$로 보내지는 $V$의 벡터들의 집합을 kernel이라고 한다.

### Transformation Matrix

행렬 $A\in \Bbb R^{m\times n}$에 대응하는 선형 사상 $\Phi:\Bbb R^n→\Bbb R^m$이 존재할 때, 아래의 4가지 성질이 성립한다.

- Image는 변환 행렬 $A$의 column space이다.
- $\text{ker}(\Phi)$는 Homogeneous Equation $A\mathbf{x}=\mathbf{0}$의 일반해이다. 즉, kernel은 null space라고도 한다.
- 변환 행렬 $A$의 rank는 image의 차원과 동일하다. → $\text{rank}(A)=\text{dim}(\text{Im}(\Phi))$
- 변환 행렬 $A$의 nullity는 kernel의 차원과 동일하다. → $\text{nullity}(A)=\text{dim}(\text{ker}(\Phi))$

## 차원 정리 (Rank-Nullity Theorem)

선형 사상 $\Phi : V → W$ 에 대해, 아래의 수식이 성립한다.

$$
\text{dim}(V)=\text{rank}(A)+\text{nullity}(A)
$$

선형 사상이 행렬 $A\in \Bbb R^{m\times n}$로 표현될 경우, 아래와 같이 표현할 수 있다.

$$
\Phi(\mathbf{x})=A\mathbf{x}\implies n=\text{rank}(A)+\text{nullity}(A)
$$

즉, 정의역 $\mathbb{R}^{n}$의 차원은 행렬 $A$의 column space 차원(rank)과 null space 차원(nullity)의 합과 같다.
