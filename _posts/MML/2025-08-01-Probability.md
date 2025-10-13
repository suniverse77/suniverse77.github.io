---
title: "[확률] 확률이란"
date: 2025-08-01 00:00:00 +/-TTTT
categories: [인공지능 수학, 확률]
tags: [확률]
math: true
toc: true
author: sunho
---

## Probability Space

### Sample space

확률 실험에서 나올 수 있는 모든 가능한 결과들의 집합을 의미한다.
    
> 주사위 던지기 → $\Omega=\lbrace1,2,3,4,5,6\rbrace$
    

### Event space

Event (사건)는 sample space의 부분집합으로, 실험 결과가 만족해야할 조건을 의미한다.
    
> 짝수가 나올 사건 → $A=\lbrace2,4,6\rbrace\subset\Omega$
    
Event space는 가능한 모든 사건들의 집합을 의미한다.
    
> $\Omega=\lbrace a,b\rbrace$ → $\mathcal{A}=\lbrace\emptyset,\lbrace a\rbrace,\\lbrace b\rbrace,\lbrace a,b\rbrace\rbrace$

## Basic Rules of Probability

### Sum Rule

$$
P(A)=\sum_{i=1}^n P(A,B_i)=P(A,B_1)+\cdots+P(A,B_n)
$$

어떤 사건 $A$ 다른 사건 $B_i$들을 통해 일어날 수 있을 때, $A$가 발생할 전체 확률은 가능한 모든 경우의 확률을 더해서 구한다.

### Product Rule

$$
P(A,B)=p(A\mid B)P(B)=P(B\mid A)P(A)
$$

Joint 확률 분포는 Marginal 분포와 Conditional 분포의 곱으로 나타낼 수 있다.

## Independence

두 사건이 독립이란 것은 한 사건의 발생이 다른 사건의 발생에 영향을 주지 않는다는 것을 의미한다.

$$
P(A,B)=P(A)P(B)
$$

두 사건 $A$와 $B$가 독립이라면, 위의 식이 성립한다.

### Conditional Independence

$$
P(A,B\mid C)=P(A\mid C)P(B\mid C)
$$

사건 $C$가 발생했을 때에도 두 사건 $A$와 $B$가 독립이라면, 이를 조건부 독립이라고 한다.

### Disjoint

$$
P(A,B)=\emptyset
$$

두 사건이 동시에 일어날 수 없다는 것을 의미하며, 독립과는 다른 개념이다.

두 사건이 mutually exclusive하다고도 부른다.
