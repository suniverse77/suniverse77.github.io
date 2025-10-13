---
title: "[확률] 독립"
date: 2025-08-03 00:00:00 +/-TTTT
categories: [인공지능 수학, 확률]
tags: [확률]
math: true
toc: true
author: sunho
---

## 독립 (Independence)

두 사건이 독립이란 것은 한 사건의 발생이 다른 사건의 발생에 영향을 주지 않는다는 것을 의미한다.

$$
P(A,B)=P(A)P(B)
$$

두 사건 $A$와 $B$가 독립이라면, 위의 식이 성립한다.

### 조건부 독립 (Conditional Independence)

$$
P(A,B\mid C)=P(A\mid C)P(B\mid C)
$$

사건 $C$가 발생했을 때에도 두 사건 $A$와 $B$가 독립이라면, 이를 조건부 독립이라고 한다.

## 배반 (Disjoint)

두 사건이 동시에 일어날 수 없다는 것을 의미하며, 독립과는 다른 개념이다.

$$
P(A,B)=\emptyset
$$

두 사건이 mutually exclusive하다고도 부른다.