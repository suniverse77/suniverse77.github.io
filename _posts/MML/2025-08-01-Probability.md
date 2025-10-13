---
title: "[확률] 확률이란"
date: 2025-08-01 00:00:00 +/-TTTT
categories: [인공지능 수학, 확률]
tags: [확률]
math: true
toc: true
author: sunho
---

## 확률 공간 (Probability Space)

### 표본 공간 (Sample space)

확률 실험에서 나올 수 있는 모든 가능한 결과들의 집합을 의미한다.
    
예를 들어, 주사위 던지기의 표본 공간은 나올 수 있는 모든 눈이 된다.

$$\Omega=\lbrace1,2,3,4,5,6\rbrace$$

### 사건 (Event)

사건은 표본 공간의 부분집합으로, 실험 결과가 만족해야할 조건을 의미한다.

예를 들어, 주사위 던지기에서 짝수가 나올 사건 $A$는 아래와 같이 표현된다.
    
$$A=\lbrace2,4,6\rbrace\subset\Omega$$

![fig1](mlm/p1-1.png){: style="display:block; margin:0 auto; width:60%;"}
_[[출처]](https://m.blog.naver.com/mykepzzang/221855523956)_

### 확률 함수

확률 함수 $P(\cdot)$는 해당 사건에 대해 그 확률을 할당하는 함수이다.

예를 들어, 주사위 던지기에서 짝수가 나올 사건을 $A$라고 할 때, $A$에 대한 확률은 아래와 같이 표현된다.

$$
P(A)=\frac{1}{2}
$$

## 확률의 기본 규칙

### 합의 법칙 (Sum Rule)

어떤 사건 $A$가 다른 사건 $B_i$들을 통해 일어날 수 있을 때, $A$가 발생할 전체 확률은 가능한 모든 경우의 확률을 더해서 구한다.

$$
P(A)=\sum_{i=1}^n P(A,B_i)=P(A,B_1)+\cdots+P(A,B_n)
$$

### 곱의 법칙 (Product Rule)

결합 확률 분포는 주변 분포와 조건부 분포의 곱으로 나타낼 수 있다.

$$
P(A,B)=p(A\mid B)P(B)=P(B\mid A)P(A)
$$
