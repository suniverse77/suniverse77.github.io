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

## 벡터 부분공간 (Vector Subspace)

벡터공간 $V$의 부분집합 $U$가 아래의 조건을 만족하면, $U$를 $V$의 부분공간이라고 한다.

1. $U$는 영벡터를 포함해야 한다.

	$$
	\mathbf{0}\in U
	$$
2. $U$는 덧셈에 대해 닫혀있어야 한다.

	$$
	\mathbf{u},\mathbf{v}\in U~\to~\mathbf{u+v}\in U
	$$
3. $U$는 스칼라배에 대해 닫혀있어야 한다.

	$$\vphantom{\Big(}
	\mathbf{u}\in U~\to~c\mathbf{u}\in U
	$$

1번 조건에 의해 좌표 공간에서의 부분공간은 원점을 포함해야 하기 때문에, 2차원 공간에서는 원점을 통과하는 직선, 3차원 공간에서는 원점을 통과하는 직선 또는 평면으로 나타난다.

<details>
<summary><font color='#FF0000'>Example 1</font></summary>
<div markdown="1">

![fig1](mlm/2-1.png){: style="display:block; margin:0 auto; width:80%;"}
_출처: Deisenroth, Faisal, & Ong, <i>Mathematics for Machine Learning</i>_

---

**1. 첫 번째 그림**

(2)번, (3)번 조건을 만족하지 못하므로, $\mathbb{R}^2$의 부분공간이 아니다.

예를 들어, 그림에서 축과 만나는 지점의 좌표를 $\pm1$이라고 가정하자.

집합 내에 존재하는 벡터 $\mathbf{u}=(1,0)$와 $\mathbf{v}=(1,1)$에 대해, $\mathbf{u}+\mathbf{v}=(2,1)$ , $2\mathbf{u}=(2,0)$이 되어 해당 집합을 벗어나게 된다.

**2. 두 번째 그림**

(1)번, (2)번, (3)번 조건을 만족하지 못하므로, $\mathbb{R}^2$의 부분공간이 아니다.

예를 들어, 그림의 직선의 방정식이 $y=x+1$이라고 가정하자.

집합 내에 존재하는 벡터 $\mathbf{u}=(0,1)$와 $\mathbf{v}=(-1,0)$에 대해, $\mathbf{u}+\mathbf{v}=(-1,1)$ , $2\mathbf{u}=(0,2)$가 되어 해당 집합을 벗어나게 된다.

**3. 세 번째 그림**

(2)번 조건을 만족하지 못하므로, $\mathbb{R}^2$의 부분공간이 아니다.

예를 들어, 그림의 두 직선의 방정식이 각각 $y=2x$ , $y=\frac{1}{2}x$라고 가정하자.

집합 내에 존재하는 벡터 $\mathbf{u}=(4,2)$와 $\mathbf{v}=(-2,-4)$에 대해, $\mathbf{u}+\mathbf{v}=(2,-2)$가 되어 해당 집합을 벗어나게 된다.

**4. 네 번째 그림**

모든 조건을 다 만족하므로, $\mathbb{R}^2$의 부분공간이다.

---

</div>
</details>

## 아핀 공간 (Affine Space)

벡터 공간을 평행 이동한 공간을 아핀 공간이라고 부른다.

원점에서 offset된 공간으로, $\mathbf0$을 포함하지 않아 벡터 공간은 아니다.

![fig2](mlm/2-2.png){: style="display:block; margin:0 auto; width:50%;"}
_[[출처]](https://en.wikipedia.org/wiki/Affine_space)_
