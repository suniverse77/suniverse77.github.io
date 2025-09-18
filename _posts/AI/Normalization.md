---
title: "[CS231n] Normalization"
date: 2025-09-04 00:00:00 +/-TTTT
categories: [딥러닝]
tags: [CS231n]
math: true
toc: true
author: sunho
description: 📖 Stanford CS231n | Spring 2025 | Lecture 1
---

## Min-Max Scaling

공식은 아래와 같으며, 데이터의 범위를 $[0,1]$ 또는 $[-1,1]$ 사이로 스케일링

$$
x'=\frac{x-x_{min}}{x_{max}-x_{min}}
$$

## Standardization

공식은 아래와 같으며, 데이터의 분포를 평균 0, 분산 1로 변환한다.

$$
x'=\frac{x-\mu}{\sigma}
$$

- $x$는 입력, $\mu$는 평균, $\sigma$는 표준편차를 의미한다.

## Covariate Shift