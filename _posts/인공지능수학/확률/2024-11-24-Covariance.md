---
layout: single
title: "[확률] Covariance"
last_modified_at: 2024-11-24
categories: ["인공지능 수학"]
tags: ["확률"]
excerpt: "공분산"
use_math: true
toc: true
toc_sticky: true
---

## Covariance

$$
\text{Cov}(X,Y)=\mathbb E_{X,Y}[(x-\mu_X)(y-\mu_Y)]=\mathbb E_{X,Y}[xy]-\mathbb E[x]\mathbb E[y]
$$

두 확률 변수 간의 상관 정도를 나타내는 값이다.
- $\text{Cov}(X,Y)=0$ → $X$와 $Y$의 증가/감소 방향이 서로 관계가 없다. → 두 변수가 uncorrelated하다고 한다.
- $\text{Cov}(X,Y)>0$ → $X$와 $Y$가 서로 같은 방향으로 증가 또는 감소한다.
- $\text{Cov}(X,Y)<0$ → $X$와 $Y$가 서로 다른 방향으로 증가 또는 감소한다.

$X$와 $Y$가 독립이면 공분산이 0이며 역은 성립하지 않는다.

<details>
<summary><font color='blue'>유도</font></summary>
<div markdown="1">



</div>
</details>


## Correlation

$$
\rho(X,Y)=\frac{\text{Cov}(X,Y)}{\sigma_X\sigma_Y}
$$

두 확률 변수 간의 관계의 강도를 나타내는 값이다.

값의 범위가 $[-1,1]$ 사이에만 존재하므로 단위에 영향을 받지 않는다.

- 값이 0에 가까울수록 $X$와 $Y$ 사이의 상관 관계가 없다.
- $\pm1$에 가까울수록 $X$와 $Y$ 사이의 상관 관계가 강하다. → 두 변수가 very related하다고 한다.
