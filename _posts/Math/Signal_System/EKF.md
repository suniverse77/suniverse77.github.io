---
title: "[칼만 필터] Extended Kalman Filter(EKF)"
date: 2026-04-10 00:00:00 +/-TTTT
categories: [Mathmatics, 신호 및 시스템]
tags: [칼만 필터]
math: true
toc: true
author: sunho
---

칼만 필터는 모션 모델과 관측 모델이 선형이라는 가정 하에 상태를 추정한다. 하지만 현실세계의 대부분의 현상들은 비선형으로 모델링되므로 앞서 정의한 칼만 필터를 그대로 적용하면 정상적으로 동작하지 않는다. 비선형의 모션 모델과 관측 모델에서도 칼만 필터를 사용하기 위해 확장칼만필터(extended kalman filter, EKF)가 제안되었다. EKF는 테일러 1차 근사(talyor 1st approximation)을 사용하여 비선형 모델을 선형 모델로 근사한 후 칼만 필터를 적용하는 방법을 사용한다. EKF에서 모션 모델과 관측 모델은 다음과 같다.
