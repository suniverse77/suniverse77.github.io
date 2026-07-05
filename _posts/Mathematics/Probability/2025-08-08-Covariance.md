---
title: "[확률] 공분산과 상관 계수"
date: 2025-08-08 00:00:00 +/-TTTT
categories: [Mathmatics, 확률]
tags: [확률]
math: true
toc: true
author: sunho
---

## 공분산 (Covariance)

공분산은 <span style="background-color:#fff5b1">두 확률 변수 간의 상관관계를 나타내는 값</span>이다.

$$
\text{Cov}(X,Y)=\mathbb E_{X,Y}[(x-\mu_X)(y-\mu_Y)]=\mathbb E_{X,Y}[xy]-\mathbb E[x]\mathbb E[y]
\tag{1}
$$

- $\text{Cov}(X,Y)=0$ → $X$와 $Y$의 증가/감소 방향이 서로 관계가 없다. → 두 변수가 uncorrelated하다고 한다.
- $\text{Cov}(X,Y)>0$ → $X$와 $Y$가 서로 같은 방향으로 증가 또는 감소한다.
- $\text{Cov}(X,Y)<0$ → $X$와 $Y$가 서로 다른 방향으로 증가 또는 감소한다.

$X$와 $Y$가 독립이면 공분산이 0이며 역은 성립하지 않는다.

### 공분산 행렬 (Covariance Matrix)

공분산 행렬은 <span style="background-color:#fff5b1">다변량 확률 변수 내의 여러 확률 변수 간의 상관관계를 행렬 형태로 나타낸 값</span>이다.
<br>
즉, 다변량 확률변수의 분산을 공분산 행렬이라고 부른다.

공분산 행렬은 항상 대칭 행렬이고, positive semi-definite 성질을 갖는다.

예를 들어 다변량 확률 변수 $\mathbf{X}=[X_1,X_2,\dots,X_D]$가 존재할 때, 공분산 행렬 $\Sigma_{\mathbf{X}}$는 다음과 같다.

$$
\Sigma_{\mathbf X}=
\begin{bmatrix}
\sigma_1^2&\sigma_{1,2}&\cdots&\sigma_{1,D}\\
\sigma_{2,1}&\sigma_2^2&\cdots&\sigma_{2,D}\\
\vdots&\vdots&\ddots&\vdots\\
\sigma_{D,1}&\sigma_{D,2}&\cdots&\sigma_D^2
\end{bmatrix}\in\mathbb{R}^{D\times D}
,\quad\text{where }\sigma_{i,j}=\text{Cov}(X_i,X_j)
$$

공분산 행렬의 대각 성분은 각 확률 변수 $X_i$의 분산을 의미한다.

이때 공분산 행렬은 $\mathbf{X}$의 분산이므로, $\mathbb{V}[\mathbf X]$으로도 표기할 수 있다.

## 상관 계수 (Correlation)

상관 계수는 두 확률 변수 간의 관계의 강도를 나타내는 값이다.

$$
\rho(X,Y)=\frac{\text{Cov}(X,Y)}{\sigma_X\sigma_Y}
\tag{2}
$$

값의 범위가 $[-1,1]$ 사이에만 존재하므로 단위에 영향을 받지 않는다.

- 값이 0에 가까울수록 $X$와 $Y$ 사이의 상관 관계가 없다.
- $\pm1$에 가까울수록 $X$와 $Y$ 사이의 상관 관계가 강하다. → 두 변수가 very related하다고 한다.
