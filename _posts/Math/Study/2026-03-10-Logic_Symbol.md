---
title: "[논리학] 논리식 기호"
date: 2026-03-10 00:00:00 +/-TTTT
categories: [Mathmatics, Study]
tags: [논리학]
math: true
toc: true
author: sunho
---

|기호|명칭|의미|
|---|---|---|
|$\lnot$ <br> $\sim$ <br> $!$|부정 (NOT)|$\lnot P$ : $P$가 `거짓`일 때 `참`|
|$\land$ <br> $\cdot$ <br> $\&$|논리곱 (AND, Conjunction)|$P\land Q$ : $P$와 $Q$가 모두 `참`일 때 `참`|
|$\lor$ <br> $+$ <br> $\parallel$|논리합 (OR, Disjunction)|$P\lor Q$ : $P$ 또는 $Q$ 중 하나라도 `참`이면 `참`|
|$\oplus$ <br> $\veebar$|배타적 논리합 (XOR)|$P\oplus Q$ : $P$와 $Q$의 진리값이 서로 다를 때 `참`|
|$\to$ <br> $\Rightarrow$|조건 (Implication)|$P\rightarrow Q$ : $P$이면 $Q$이다|
|$\leftrightarrow$ <br> $\Leftrightarrow$|동치 (Equivalence)|$P\leftrightarrow Q$ : $P$와 $Q$의 진리값이 서로 같을 때 `참`

## 진리표 (Truth Table)

진리표에서 $1$은 `True`에, $0$은 `False`에 대응한다.

### NOT

|$P$|$\lnot P$|
|---|---|
|$0$|$1$|
|$1$|$0$|

### AND

|$P$|$Q$|$P\land Q$|
|---|---|---|
|$0$|$0$|$0$
|$0$|$1$|$0$
|$1$|$0$|$0$
|$1$|$1$|$1$

### OR

|$P$|$Q$|$P\lor Q$|
|---|---|---|
|$0$|$0$|$0$
|$0$|$1$|$1$
|$1$|$0$|$1$
|$1$|$1$|$1$

### XOR

|$P$|$Q$|$P\oplus Q$|
|---|---|---|
|$0$|$0$|$0$
|$0$|$1$|$1$
|$1$|$0$|$1$
|$1$|$1$|$0$

### Implication

|$P$|$Q$|$P\rightarrow Q$|
|---|---|---|
|$0$|$0$|$1$
|$0$|$1$|$1$
|$1$|$0$|$0$
|$1$|$1$|$1$

- $P$가 `거짓`일 때, $P\rightarrow Q$는 항상 `참`
- $P$가 `참`일 때, $P\rightarrow Q$는 $Q$의 진리값에 의해 결정

### Equivalance

|$P$|$Q$|$P\rightarrow Q$|
|---|---|---|
|$0$|$0$|$1$
|$0$|$1$|$0$
|$1$|$0$|$0$
|$1$|$1$|$1$
