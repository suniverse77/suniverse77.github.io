---
title: "[확률] 공분산과 상관 계수"
date: 2025-08-07 00:00:00 +/-TTTT
categories: [Mathmatics, 확률]
tags: [확률]
math: true
toc: true
author: sunho
---

## 공분산 (Covariance)

공분산은 두 확률 변수 간의 상관 정도를 나타내는 값이다.

$$
\text{Cov}(X,Y)=\mathbb E_{X,Y}[(x-\mu_X)(y-\mu_Y)]=\mathbb E_{X,Y}[xy]-\mathbb E[x]\mathbb E[y]
$$

- $\text{Cov}(X,Y)=0$ → $X$와 $Y$의 증가/감소 방향이 서로 관계가 없다. → 두 변수가 uncorrelated하다고 한다.
- $\text{Cov}(X,Y)>0$ → $X$와 $Y$가 서로 같은 방향으로 증가 또는 감소한다.
- $\text{Cov}(X,Y)<0$ → $X$와 $Y$가 서로 다른 방향으로 증가 또는 감소한다.

$X$와 $Y$가 독립이면 공분산이 0이며 역은 성립하지 않는다.

### 공분산 행렬 (Covariance Matrix)

공분산은 각 확률 변수 간의 함께 변하는 정도를 나타내는 값이다.

다변량 확률변수의 분산을 공분산 행렬이라고 부르며, 항상 대칭 행렬이고 양의 반정정부호 (positive semi-definite)이다.

$$
\mathbb{V}[\mathbf X]=\text{Cov}(\mathbf X)=
\mathbb{E}\left[(\mathbf{X}-\mathbb{E}[\mathbf{X}])(\mathbf{X}-\mathbb{E}[\mathbf{X}])^\top\right]=\Sigma_\mathbf X=
\begin{bmatrix}
\sigma_1^2&\sigma_{12}&\cdots&\sigma_{1D}\\
\sigma_{21}&\sigma_2^2&\cdots&\sigma_{2D}\\
\vdots&\vdots&\ddots&\vdots\\
\sigma_{D1}&\sigma_{D2}&\cdots&\sigma_D^2
\end{bmatrix}\in\mathbb{R}^{D\times D}
$$

각 원소는 서로 다른 확률 변수 간의 공분산을 나타내며, 대각 성분은 각 확률변수의 분산을 나타낸다.

$$
\sigma_{i,j}=\text{Cov}(X_i,X_j)=\mathbb{E}\left[(X_i-\mathbb{E}[X_i])(X_j-\mathbb{E}[X_j])\right]
$$

## 상관 계수 (Correlation)

상관 계수는 두 확률 변수 간의 관계의 강도를 나타내는 값이다.

$$
\rho(X,Y)=\frac{\text{Cov}(X,Y)}{\sigma_X\sigma_Y}
$$

값의 범위가 $[-1,1]$ 사이에만 존재하므로 단위에 영향을 받지 않는다.

- 값이 0에 가까울수록 $X$와 $Y$ 사이의 상관 관계가 없다.
- $\pm1$에 가까울수록 $X$와 $Y$ 사이의 상관 관계가 강하다. → 두 변수가 very related하다고 한다.
