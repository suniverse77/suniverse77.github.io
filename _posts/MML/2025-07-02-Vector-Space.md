---
title: "[선형대수] 벡터 공간"
date: 2025-07-02 00:00:00 +/-TTTT
categories: [인공지능 수학, 선형대수]
tags: [선형대수]
math: true
toc: true
author: sunho
---

## 벡터 공간 (Vector Space)

공집합이 아닌 집합 $\mathcal{V}$와 스칼라들의 집합(Field) $F$가 있을 때,

집합 $\mathcal{V}$에 벡터 덧셈 ($+$)과 스칼라 곱셈 ($\cdot$)의 두 가지 연산이 정의되어 있고, 아래 10가지 공리를 만족하면 집합 $\mathcal{V}$를 벡터 공간이라고 하며, $\mathcal{V}$의 원소를 벡터라고 한다.

즉, 단순히 벡터들의 집합이 아니라, 이 집합 내의 원소들이 특정 규칙을 만족하는 공간을 의미한다

이때, 벡터 덧셈은 $\mathcal{V} \times \mathcal{V} \to \mathcal{V}$로, 스칼라 곱셈은 $F \times \mathcal{V} \to \mathcal{V}$로 가는 함수로, 연산을 수행해도 다시 집합 $\mathcal{V}$ 내의 원소가 나온다.

### 벡터 덧셈에 대한 공리 (벡터 공간은 아벨 군을 이룬다)

1. 닫힘 (Closure): 임의의 벡터 $\mathbf{u}, \mathbf{v} \in \mathcal{V}$에 대해, $\mathbf{u} + \mathbf{v}$는 $\mathcal{V}$에 속한다.

2. 교환 법칙 () 성립: 임의의 벡터 $\mathbf{u}, \mathbf{v} \in \mathcal{V}$에 대해, $\mathbf{u} + \mathbf{v} = \mathbf{v} + \mathbf{u}$가 성립한다.

3. 결합 법칙 (Associativity) 성립: 임의의 벡터 $\mathbf{u}, \mathbf{v}, \mathbf{w} \in \mathcal{V}$에 대해, $(\mathbf{u} + \mathbf{v}) + \mathbf{w} = \mathbf{u} + (\mathbf{v} + \mathbf{w})$가 성립한다.

4. 항등원 (Identity) 존재: V 내에 모든 벡터 $\mathbf{u} \in \mathcal{V}$에 대해 $\mathbf{u} + \mathbf{0} = \mathbf{u}$를 만족하는 유일한 영벡터 $\mathbf{0}$이 존재한다.

5. 역원 (Inverse) 존재: 임의의 벡터 $\mathbf{u} \in \mathcal{V}$에 대해, $\mathbf{u} + (-\mathbf{u}) = \mathbf{0}$를 만족하는 유일한 역벡터 $-\mathbf{u}$가 V 내에 존재한다.

### 스칼라 곱셈에 대한 공리

6. 닫힘 (Closure): 임의의 스칼라 $c\in F$와 벡터 $\mathbf{u} \in \mathcal{V}$에 대해, $c \cdot \mathbf{u}$는 $\mathcal{V}$에 속한다.

7. 스칼라 덧셈에 대한 분배 법칙: 임의의 스칼라 $c,d\in F$와 벡터 $\mathbf{u} \in \mathcal{V}$에 대해, $(c+d) \cdot \mathbf{u} = c \cdot \mathbf{u} + d \cdot \mathbf{u}$가 성립한다.

8. 벡터 덧셈에 대한 분배 법칙: 임의의 스칼라 $c\in F$와 벡터 $\mathbf{u}, \mathbf{v} \in \mathcal{V}$에 대해, $c \cdot (\mathbf{u} + \mathbf{v}) = c \cdot \mathbf{u} + c \cdot \mathbf{v}$가 성립한다.

9. 스칼라 곱셈에 대한 결합 법칙 (Associativity of scalar multiplication): 임의의 스칼라 c,d∈F와 벡터 $\mathbf{u} \in \mathcal{V}$에 대해, $(cd) \cdot \mathbf{u} = c \cdot (d \cdot \mathbf{u})$가 성립한다.

10. 항등원 (Identity) 존재: 스칼라 집합 F의 곱셈 항등원인 1에 대해, 임의의 벡터 $\mathbf{u} \in \mathcal{V}$에 대해 $1 \cdot \mathbf{u} = \mathbf{u}$가 성립한다.

## Vector Subspace

벡터공간 $V$의 부분집합 $U$가 아래의 조건을 만족하면, $U$를 $V$의 subspace라고 한다.

1. $V$에 존재하는 $\mathbf{0}$ (zero vector)를 포함해야 한다.
2. $U$는 덧셈과 스칼라배에 대해 닫혀있어야 한다.

좌표 공간에서의 subspace는 원점을 포함해야 한다.

- $\mathbb{R}^2$ 공간에서 vector subspace는 원점을 포함하는 직선
- $\mathbb{R}^3$ 공간에서 vector subspace는 원점을 포함하는 직선 또는 평면



- 첫 번째 그림은 스칼라배에 대해 닫혀있지 않으므로, $\mathbb{R}^2$의 subspace가 아니다.
- 두 번째 그림은 원점을 포함하지 않으므로, $\mathbb{R}^2$의 subspace가 아니다.
- 세 번째 그림은 $\mathbb{R}^2$의 subspace가 아니다.
- 네 번째 그림은 subspace의 조건을 다 만족하므로, $\mathbb{R}^2$의 subspace이다.



- 해당 직선에 있는 벡터들끼리 덧셈을 하거나 벡터에 스칼라배를 할 경우, 직선 밖으로 나가기 때문에 subspace가 아니다.



- 해당 직선에 있는 벡터들끼리 덧셈을 하거나 벡터에 스칼라배를 해도 직선 내에 존재하기 때문에 subspace이다.

## Span

벡터 집합 $S$에 있는 벡터들의 가능한 모든 linear combination으로 만들어지는 집합을 $\text{span}(S)$라고 한다.

- $$
	\text{span}(\begin{bmatrix}1\\0\end{bmatrix},\begin{bmatrix}0\\1\end{bmatrix})=\mathbb{R}^2
	$$ <font color='white'>.</font>
- $$
	\text{span}(\begin{bmatrix}2\\1\end{bmatrix},\begin{bmatrix}1\\3\end{bmatrix})=\begin{bmatrix}2a+b\\a+3b\end{bmatrix}
	$$ <font color='white'>.</font>

## Null Space

Homogeneous Equation의 solution을 모두 모아놓은 집합을 Null Space라고 부른다.

$$
N(A)=\lbrace\mathbf{x}\mid A\mathbf{x}=\mathbf{0}\rbrace
$$
    
- 어떠한 null space든지 항상 $\mathbf{0}$를 포함하므로, vector space이다.
- Null space의 차원을 **nullity**라고 하며, free variable의 개수와 동일하다.

