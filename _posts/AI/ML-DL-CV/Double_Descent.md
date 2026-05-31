---
title: "[딥러닝] Double Descent"
date: 2025-02-25 00:00:00 +/-TTTT
categories: [AI, 머신러닝 / 딥러닝 / 컴퓨터 비전]
tags: [딥러닝]
math: true
toc: true
author: sunho
---

기존 이론에서는 모델의 크기와 복잡도가 커질수록 학습 데이터의 노이즈까지 학습하여 과적합(Overfitting)이 발생하고, 이로 인해 테스트 오차가 다시 증가한다는 U자형의 Bias-Variance Tradeoff 곡선을 정설로 여겼다.

![fig1](AI/ML-DL/Double_Descent-1.png){: style="display:block; margin:0 auto; width:70%;"}
_[[출처]](https://www.researchgate.net/figure/Bias-variance-trade-off-of-classical-Machine-Learning-ML-grey-line-and-Deep-Learning_fig2_359890656)_

하지만 모델의 크기를 더욱 키우면, 오히려 테스트 오차가 다시 줄어드는 Double Descent 현상이 발생하는 것을 관찰했다.

![fig2](AI/ML-DL/Double_Descent-2.png){: style="display:block; margin:0 auto; width:70%;"}
_[[출처]](https://www.researchgate.net/figure/Bias-variance-trade-off-of-classical-Machine-Learning-ML-grey-line-and-Deep-Learning_fig2_359890656)_

왜 이러한 현상이 발생할까?

예를 들어, 노란색의 학습 데이터와 초록색의 테스트 데이터가 4개 존재한다고 해보자.

![fig3](AI/ML-DL/Double_Descent-3.png){: style="display:block; margin:0 auto; width:70%;"}

![fig4](AI/ML-DL/Double_Descent-4.png){: style="display:block; margin:0 auto; width:70%;"}
