---
title: "[확률] 독립"
date: 2025-08-02 00:00:00 +/-TTTT
categories: [Mathmatics, 확률]
tags: [확률]
math: true
toc: true
author: sunho
---

## 독립 (Independence)

두 사건이 독립이란 것은 한 사건의 발생이 다른 사건의 발생에 영향을 주지 않는다는 것을 의미한다.

두 사건 $A$와 $B$가 독립인 경우, 아래와 같이 표현한다.

$$
P(A,B)=P(A)P(B)
$$

두 사건이 독립이라는 것과 동시에 일어날 수 없다는 다른 의미이다.

예를 들어, 동전과 주사위를 던질 때 동전의 앞뒷면 결과는 주사위가 6이 나올 확률에 아무런 영향을 주지 않는다. 하지만, ‘동전이 앞면이고 주사위가 6이 나오는’ 사건은 존재한다. 이런 경우를 독립이라고 한다.

### 조건부 독립 (Conditional Independence)

사건 $C$가 발생했을 때에도 두 사건 $A$와 $B$가 독립이라면, 이를 조건부 독립이라고 한다.

$$
P(A,B\mid C)=P(A\mid C)P(B\mid C)
$$

$A$ 와 $B$가 독립이라고 해서, $C$가 발생했을 때에도 $A$와 $B$가 독립인 것은 아니다.

$$
A\perp\!\!\!\perp B\nrightarrow A\perp\!\!\!\perp B\mid C
$$

<details>
<summary><font color='#0000FF'>증명</font></summary>
<div markdown="1">

동전을 2번 던졌을 때, 첫 번째 동전이 앞면이 나온 사건을 $H_1$, 두 번째 동전이 앞면이 나온 사건을 $H_2$, 첫 번째와 두 번째 던진 동전의 결과가 다른 사건을 $D$라고 하자.

주변 확률과 결합 확률을 아래와 같이 구할 수 있다.

$$
P(H_1)=\frac{1}{2}~,~P(H_2)=\frac{1}{2}~,~P(H_1,H_2)=\frac{1}{4}
$$

아래의 식이 성립하기 때문에, $H_1$과 $H_2$는 독립이다.

$$
P(H_1)P(H_2)=P(H_1,H_2)
$$

$D$가 발생했을 때의 주변 확률과 결합 확률을 아래와 같이 구할 수 있다.

$$
P(H_1\mid D)=\frac{1}{2}~,~P(H_2\mid D)=\frac{1}{2}~,~P(H_1,H_2\mid D)=0
$$

아래의 식이 성립하지 않기 때문에, $D$가 발생했을 때 $H_1$과 $H_2$는 독립이 아니다.

$$
P(H_1\mid D)P(H_2\mid D)\neq P(H_1,H_2\mid D)
$$

---

</div>
</details>
<br>

$C$가 발생했을 때 $A$와 $B$가 독립이라고 해서, $A$ 와 $B$가 독립인 것은 아니다.

$$
A\perp\!\!\!\perp B\mid C\nrightarrow A\perp\!\!\!\perp B
$$

<details>
<summary><font color='#0000FF'>증명</font></summary>
<div markdown="1">



</div>
</details>
<br>

## 배반 (Disjoint)

두 사건이 동시에 일어날 수 없다는 것을 의미하며, 두 사건이 상호 배타적 (mutually exclusive)이라고도 부른다.

두 사건 $A$와 $B$가 배반인 경우, 아래와 같이 표현한다.

$$
P(A,B)=\emptyset
$$
