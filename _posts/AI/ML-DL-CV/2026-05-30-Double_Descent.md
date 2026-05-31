---
title: "[딥러닝] Double Descent"
date: 2026-05-30 00:00:00 +/-TTTT
categories: [AI, 머신러닝 / 딥러닝 / 컴퓨터 비전]
tags: [딥러닝]
math: true
toc: true
author: sunho
---

기존 이론에서는 모델의 크기와 복잡도가 커질수록 학습 데이터의 노이즈까지 학습하여 과적합(Overfitting)이 발생하고, 이로 인해 테스트 오차가 다시 증가한다는 U자형의 Bias-Variance Tradeoff 곡선을 정설로 여겼다.

![fig1](AI/ML-DL/Double_Descent-1.png){: style="display:block; margin:0 auto; width:40%;"}
_[[출처]](https://www.researchgate.net/figure/Bias-variance-trade-off-of-classical-Machine-Learning-ML-grey-line-and-Deep-Learning_fig2_359890656)_

하지만 모델의 크기를 더욱 키우면, 오히려 테스트 오차가 다시 줄어드는 Double Descent 현상이 발생하는 것을 관찰했다.

![fig2](AI/ML-DL/Double_Descent-2.png){: style="display:block; margin:0 auto; width:70%;"}
_[[출처]](https://www.researchgate.net/figure/Bias-variance-trade-off-of-classical-Machine-Learning-ML-grey-line-and-Deep-Learning_fig2_359890656)_

왜 이러한 현상이 발생할까?

예를 들어, 노란색의 학습 데이터와 초록색의 테스트 데이터가 각각 4개 존재한다고 해보자.

- **1차 다항식으로 fitting하는 경우 (Underfitting)**

    모델의 표현력이 지나치게 부족하여 데이터의 실제 패턴을 포착하지 못한다.
    <br>
    그 결과 학습 오차와 테스트 오차가 모두 크게 나타난다.
- **2차 다항식으로 fitting하는 경우**

    데이터가 가진 경향성을 가장 잘 포착하는 경우다.
    <br>
    학습 오차가 적절히 낮아지면서도, 보지 못한 새로운 데이터에 대한 예측력도 높아져 테스트 오차가 최소가 되는 가장 이상적인 지점이다.
- **4차 다항식으로 fitting하는 경우 (Overfitting)**

    학습 데이터 개수와 모델의 변수(파라미터) 개수가 일치하는 지점이다.
    <br>
    학습 데이터의 모든 점을 정확히 지나가게 되어 학습 오차는 0이 되지만, 데이터에 포함된 작은 노이즈까지 맞추다 보니 테스트 오차가 극대화된다.
    <br>
    이 지점을 **보간 임계점(Interpolation Threshold)**이라고 부른다.

![fig3](AI/ML-DL/Double_Descent-3.png){: style="display:block; margin:0 auto; width:80%;"}

따라서 학습 오차와 테스트 오차의 곡선은 아래와 같이 나타나게 된다.

![fig4](AI/ML-DL/Double_Descent-4.png){: style="display:block; margin:0 auto; width:40%;"}

만약 보간 임계점을 넘어 모델의 파라미터를 데이터 개수보다 훨씬 더 많이 늘리면 어떻게 될까?
<br>
이 경우, 학습 데이터를 오차 없이 완벽하게 맞출 수 있는 곡선이 무한히 많이 생겨나게 된다.

![fig5](AI/ML-DL/Double_Descent-5.png){: style="display:block; margin:0 auto; width:80%;"}

결론적으로 모델을 계속 키울수록 모델이 선택할 수 있는 후보군이 넓어지기 때문에, 노이즈에 덜 민감한 훨씬 부드러운 해를 찾아내기가 쉬워진다.
<br>
그 덕분에 테스트 오차가 다시 줄어드는 Double Descent가 나타나게 되는 것이다.
