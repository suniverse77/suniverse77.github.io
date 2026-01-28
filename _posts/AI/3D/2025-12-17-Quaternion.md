---
title: "[3D 비전] 사원수 회전 (Quaternion Rotation)"
date: 2025-12-17 00:00:00 +/-TTTT
categories: [AI, 3D 비전]
tags: [3D 비전]
math: true
toc: true
author: sunho
---

## 사원수 (Quaternion)

사원수는 복소수를 확장한 개념으로, 1개의 실수부와 3개의 허수부로 표현한 4차원 수체계를 의미한다.

$$\vphantom{\Big(}
q=w+xi+yj+zk
$$

위의 식은 $q=(w,x,y,z)$로도 표현되며, $w,x,y,z$는 실수, $i,j,k$는 서로 직교하는 허수 단위를 나타낸다.

허수들은 아래의 규칙을 만족한다.

$$\vphantom{\Big(}i^2=j^2=k^2=ijk=-1$$

$$\vphantom{\Big(}ij=k~,~jk=i~,~ki=j$$

$$\vphantom{\Big(}ji=-k~,~kj=-i~,~ik=-j$$

위의 관계식에서 알 수 있듯이, 곱셈의 교환 법칙은 성립하지 않는다.

단위 사원수 $\hat{q}$는 크기가 1인 사원수를 의미하며, $\lVert q\rVert=\sqrt{w^2+x^2+y^2+z^2}=1$를 만족한다.

## 사원수를 이용한 3차원 회전

3차원 공간에서의 회전을 다룰 때에는, 사원수를 스칼라 $s$와 벡터 $\mathbf{v}$의 조합으로 표현한다.

$$
q=(s,\mathbf{v})=(w,(x,y,z))
$$

3차원 공간에서 어떤 벡터 $\mathbf{p}$를 단위 회전축 $\mathbf{u}=(u_x,u_y,u_z)$를 기준으로 반시계방향으로 $\theta$만큼 회전하는 회전 사원수 $q$는 아래와 같이 정의된다.

$$
q=(w,x,y,z)=\cos\left(\frac{\theta}{2}\right)+\sin\left(\frac{\theta}{2}\right)u_xi+\sin\left(\frac{\theta}{2}\right)u_yj+\sin\left(\frac{\theta}{2}\right)u_zk
$$

$$
q=\cos\left(\frac{\theta}{2}\right)+\sin\left(\frac{\theta}{2}\right)(u_xi+u_yj+u_zk)
$$

이 회전 사원수는 3차원 벡터를 회전시키는 연산자의 역할을 한다.

회전시키고자 하는 3차원 좌표 $\mathbf{p}=(x, y, z)$를 사원수 형태로 변환한다. 이때 실수부 $w$는 $0$으로 설정하며, 이를 순수 사원수 (pure quarternion)라고 부른다.

$$
\mathbf{p}_{quat}=(0,x,y,z)=0+xi+yj+zk=(0,\mathbf{p})
$$

회전된 결과 사원수 $\mathbf{p}'$는 아래와 같이 계산된다.

$$
\mathbf{p}'_{quat}=q\mathbf{p}_{quat}q^{-1}=(0,\mathbf{p}')
$$

계산 결과 나온 $\mathbf{p}'_{quat}$의 벡터 부분 (허수부) $\mathbf{p}'$이 회전된 새로운 좌표가 된다.

### 3차원 회전 행렬과의 관계

단위 사원수 $\hat{q}=(w,x,y,z)$가 주어졌을 때, 이에 대응하는 $3 \times 3$ 회전 행렬 $R$은 아래와 같다.

$$
R=\begin{bmatrix} 
\vphantom{\Big(}1 - 2(y^2 + z^2) & 2(xy - wz) & 2(xz + wy) \\
\vphantom{\Big(}2(xy + wz) & 1 - 2(x^2 + z^2) & 2(yz - wx) \\
\vphantom{\Big(}2(xz - wy) & 2(yz + wx) & 1 - 2(x^2 + y^2) 
\end{bmatrix}
$$

위 행렬은 사원수 연산 $\mathbf{p}' = q\mathbf{p}q^{-1}$을 수행한 결과와 동일한 회전 효과를 낸다.

$$
\mathbf{p}' = R\mathbf{p}
$$

### 장점
