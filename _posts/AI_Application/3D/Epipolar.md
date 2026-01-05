---
title: "[3D 비전] Epipolar Geometry"
date: 2025-12-20 00:00:00 +/-TTTT
categories: [AI, 3D 비전]
tags: [3D 비전]
math: true
toc: true
author: sunho
---

## Epipolar Geometry

Epipolar Geometry는 3차원 공간을 서로 다른 두 지점에서 촬영했을 때, 두 이미지 사이의 기하학적 관계를 다루는 이론이다.

### 구성 요소

아래 그림은 3차원 공간상의 한 점 $P$가 카메라 $A$의 이미지 센서에는 $p$에 투영되고, 카메라 $B$의 이미지 센서에는 $p'$에 투영된 경우이다.

![fig1](AI/3D/Epipolar-1.png){: style="display:block; margin:0 auto; width:80%;"}
_[[출처]](https://darkpgmr.tistory.com/83)_

- **Baseline:** 두 카메라 중심 $C$와 $C'$를 잇는 직선
- **Epipole ($e, e'$):** 베이스라인과 각 이미지 평면이 만나는 점 (또는 상대 카메라의 중심이 내 이미지에 투영된 점으로 볼 수 있음)
- **Epipolar Plane:** 3차원 공간의 점 $P$와 두 카메라 중심 $C, C'$가 이루는 평면 (초록색 점선으로 이루어진 평면)
- **Epipolar Line ($l, l'$):** 에피폴라 평면과 이미지 평면이 만나서 생기는 직선

### Essential Matrix

### Fundamental Matrix

### 에피폴라 제약 조건 (Epipolar Constraint)

