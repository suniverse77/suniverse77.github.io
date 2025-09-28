---
title: "[선형대수] 선형 사상과 차원 정리"
date: 2025-07-14 00:00:00 +/-TTTT
categories: [인공지능 수학, 선형대수]
tags: [선형대수]
math: true
toc: true
author: sunho
img_path: /assets/images/math/
---

## 선형 사상 (Linear Mappings)

아래의 조건을 만족시키는 사상 $\Phi : V\to W$를 선형 사상이라고 부른다.

1. $\Phi(\mathbf{x}+\mathbf{y})=\Phi(\mathbf{x})+\Phi(\mathbf{y})$
2. $\Phi (\lambda \mathbf{x})=\lambda \Phi (\mathbf{x})$

사상은 함수라고도 하며, $V$를 정의역, $W$를 치역이라고 생각하면 된다.

![fig1](mlm/10-1.png){: style="display:block; margin:0 auto; width:90%;"}

### 단사 함수 (Injective Function)

일대일 함수라고도 불리며, 정의역의 서로 다른 두 원소가 공역의 서로 다른 두 원소에 대응하는 함수를 의미한다.

$$
\Phi (\mathbf{x})=\Phi (\mathbf{y})\implies\mathbf{x}=\mathbf{y}
$$

즉, 출력이 같으면 입력값도 같아야하며, 이는 입력값이 다르면 출력값도 다르다는 것을 의미한다.

입력에 대응되지 않는 출력도 존재한다.
  
### 전사 함수 (Surjective Function)

공역의 모든 원소가 적어도 하나의 정의역 원소와 대응하는 함수를 의미한다.

$$
\Phi (V)=W
$$

즉, 공역과 치역이 동일하다.

하나의 출력에 여러 입력이 대응될 수 있다.
  
### 전단사 함수 (Bijective Function)

일대일 대응이라고도 불리며, 단사 함수이면서 동시에 전사 함수인 경우를 의미한다.

모든 입력이 서로 다른 출력에 정확히 하나씩 대응되며, 공역에 남는 원소가 없다. 이 때문에 역함수 (inverse mapping)가 존재한다.

$$
\Phi^{-1}=\Psi:W\to V
$$

선형 변환 관점에서 역행렬이 존재하는 경우가 전단사 변환이다.

## 상과 핵 (Image & Kernel)

![fig1](mlm/10-2.png){: style="display:block; margin:0 auto; width:50%;"}

### Image

선형 사상 $\Phi : V → W$ 에 의해 $V$의 모든 벡터가 매핑되는 $W$의 벡터들의 집합을 의미한다.

$$
\text{Im}(\Phi)=\Phi(V)=
\lbrace w\in W\mid\exists v\in V:\Phi(v)=w
\rbrace
$$

즉, image는 <span style="background-color:#fff5b1">선형 변환의 출력 공간</span>을 의미한다.

### Kernel

선형 사상 $\Phi : V → W$ 에 대해, $\Phi$에 의해 $\mathbf{0}_W$로 보내지는 $V$의 벡터들의 집합을 kernel이라고 한다.

$$
\text{ker}(\Phi)=\Phi^{-1}(\mathbf{0}_W)=
\lbrace
\mathbf{v}\in V\mid\Phi(\mathbf{v})=\mathbf{0}_W
\rbrace
$$

즉, 핵은 선형 변환의 (Null Space)[https://suniverse77.github.io/posts/Matrix-Space/#%EC%98%81%EA%B3%B5%EA%B0%84-null-space]이다. 다시 말해 동차 방정식 $A\mathbf{x}=\mathbf{0}$의 일반해로도 볼 수 있다.

---

$m\times n$ 크기의 행렬 $A\in \Bbb R^{m\times n}$는 $A:\Bbb R^n→\Bbb R^m$ 형태의 선형 사상 $\Phi$를 정의한다.

즉, 선형 사상 $\Phi:\Bbb R^n→\Bbb R^m$를 고정된 기저에 대해 표현하면 행렬 $A$가 된다.

이때 아래의 2가지 성질이 성립한다.

- <span style="background-color:#fff5b1">행렬 $A$의 rank는 image의 차원과 동일하다.</span>

    $$
    \text{rank}(A)=\text{dim}(\text{Im}(\Phi))
    $$

    이는 image가 $A$의 column space이기 때문이다.

- <span style="background-color:#fff5b1">행렬 $A$의 nullity는 kernel의 차원과 동일하다.</span>

    $$
    \text{nullity}(A)=\text{dim}(\text{ker}(\Phi))
    $$

    이는 kernel이 $A$의 null space이기 때문이다.

## 차원 정리 (Rank-Nullity Theorem)

선형 사상 $\Phi : V → W$를 정의하는 행렬 $A\in \Bbb R^{m\times n}$가 있을 때, 아래의 수식이 성립한다.

$$
\text{dim}(V)=\text{rank}(A)+\text{nullity}(A)
$$

$$
n=\text{rank}(A)+\text{nullity}(A)
$$

여기서 $n$은 입력 공간의 차원으로, 변환 후의 차원 (rank)과 원점으로 사라진 차원 (nullity)을 더하면 원래의 전체 차원 $n$이 된다는 것을 보여준다.

![fig3](mlm/10-3.png){: style="display:block; margin:0 auto; width:70%;"}
_[[출처]](https://ko.wikipedia.org/wiki/%ED%8C%8C%EC%9D%BC:Rank-nullity.svg)_
