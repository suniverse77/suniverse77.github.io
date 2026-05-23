---
title: "[논리학] 논리학 기호"
date: 2026-03-10 00:00:00 +/-TTTT
categories: [Mathmatics, Study]
tags: [논리학]
math: true
toc: true
author: sunho
---

## 명제 논리 연산자 (Propositional Connectives)

단일 명제들의 진리값을 결합하거나 반전시켜, 새로운 복합 명제를 만드는 연산자이다.

| 기호 | 명칭 | 논리 연산 | 예시 | 의미 |
| :---: | :---: | :---: | :---: | --- |
| $\lnot$ <br> $\sim$ <br> $!$ | 부정 (Negation) | NOT | $\lnot P$ | $P$가 `거짓`일 때 `참` |
| $\land$ <br> $\cdot$ <br> $\&$ | 논리곱 (Conjunction) | AND | $P\land Q$ | $P$와 $Q$가 모두 `참`일 때 `참` |
| $\lor$ <br> $+$ <br> $\parallel$ | 논리합 (Disjunction) | OR | $P\lor Q$ | $P$ 또는 $Q$ 중 하나라도 `참`이면 `참` |
| $\oplus$ <br> $\veebar$ | 배타적 논리합 <br> (Exclusive Disjunction) | XOR | $P\oplus Q$ | $P$와 $Q$의 진리값이 서로 다를 때 `참` |
| $\to$ <br> $\Rightarrow$ | 함의 (Implication) | IF-THEN | $P\rightarrow Q$ | $P$이면 $Q$이다 |
| $\leftrightarrow$ <br> $\Leftrightarrow$ | 동치 (Equivalence) | IFF | $P\leftrightarrow Q$ | $P$와 $Q$의 진리값이 서로 같을 때 `참` |

### 진리표 (Truth Table)

진리표에서 $1$은 `True`에, $0$은 `False`에 대응한다.

#### NOT

| $P$ | &nbsp; | $\lnot P$ |
| :---: | :---: | :---: |
| $0$ | | $1$ |
| $1$ | | $0$ |

#### AND

| $P$ | $Q$ | &nbsp; | $P\land Q$ |
| :---: | :---: | :---: | :---: |
| $0$ | $0$ | | $0$ |
| $0$ |$1$ | | $0$ |
| $1$ | $0$ | | $0$ |
| $1$ | $1$ | | $1$ |

#### OR

|$P$|$Q$|$P\lor Q$|
|---|---|---|
|$0$|$0$|$0$
|$0$|$1$|$1$
|$1$|$0$|$1$
|$1$|$1$|$1$

#### XOR

|$P$|$Q$|$P\oplus Q$|
|---|---|---|
|$0$|$0$|$0$
|$0$|$1$|$1$
|$1$|$0$|$1$
|$1$|$1$|$0$

#### IF-THEN

|$P$|$Q$|$P\rightarrow Q$|
|---|---|---|
|$0$|$0$|$1$
|$0$|$1$|$1$
|$1$|$0$|$0$
|$1$|$1$|$1$

- $P$가 `거짓`일 때, $P\rightarrow Q$는 항상 `참`
- $P$가 `참`일 때, $P\rightarrow Q$는 $Q$의 진리값에 의해 결정

#### IFF

|$P$|$Q$|$P\rightarrow Q$|
|---|---|---|
|$0$|$0$|$1$
|$0$|$1$|$0$
|$1$|$0$|$0$
|$1$|$1$|$1$

## 양화사 (Quantifiers)

술어 논리에서 추가되는 기호들로, 단순한 참/거짓을 넘어 변수에 대한 조건을 명시할 때 사용한다.

'얼마나 많은 대상에 대해 그 진술이 성립하는가'를 나타내는 논리 기호이다.

| 기호 | 명칭 | 논리 연산 | 예시 | 의미 |
| :---: | :---: | :---: | :---: | --- |
| $\forall$ | 보편 양화사 <br> (Universal Quantifier) | FOR ALL |  $\forall x, P(x)$ | 모든 $x$는 $P$를 만족한다. |
| $\exists$ | 존재 양화사 <br> (Existential Quantifier) | EXISTS | $\exists x, P(x)$ | $P$를 만족하는 $x$가 적어도 하나는 있다. |
| $\exists!$ | 유일 존재 양화사 <br> (Unique Existential Quantifier) | EXISTS EXACTLY ONE | $\exists! x, P(x)$ | $P$를 만족하는 $x$는 오직 하나 있다. |

## 메타 논리 기호 (Metalogical Symbols)

논리식 내부의 연산을 뜻하는 것이 아니라, 논리식과 논리식 사이의 관계나 증명 가능성을 설명하기 위해 논리 시스템 밖에서 사용하는 기호이다.

| 기호 | 명칭 | 논리 연산 | 예시 | 의미 |
| :---: | :---: | :---: | :---: | --- |
| $\equiv$ | 논리적 동치 <br> (Logical Equivalence) | EQUIVALENT | $P \equiv Q$ | $P$와 $Q$가 모든 상황에서 항상 같은 진리값을 갖는다. |
| $\models$ | 논리적 귀결 <br> (Logical Consequence) | ENTAILS | $P \models Q$ | $P$가 참인 모든 경우에 $Q$도 반드시 참이다. |
| $\vdash$ | 도출 <br> (Provability) | PROVES | $P \vdash Q$ | 정해진 규칙을 통해 가정 $P$로부터 결론 $Q$를 공식적으로 증명할 수 있다. |
