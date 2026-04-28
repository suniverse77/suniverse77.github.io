---
title: "[HPO] Grid Search / Random Search"
date: 2026-04-21 00:00:00 +/-TTTT
categories: [AI, Methodologies]
tags: [HPO]
math: true
toc: true
author: sunho
---

HPO (HyperParameter Optimization)는 머신러닝 모델의 최적 성능을 끌어내기 위해 하이퍼파라미터를 튜닝하는 알고리즘을 말한다

수많은 하이퍼파라미터 조합을 사람이 일일이 테스트하는 것은 엄청난 시간과 비용이 소모되는 비효율적인 작업이다.
<br>
따라서 보다 효율적으로 탐색하기 위해 다양한 HPO 알고리즘을 활용한다.

## Grid Search

사용자가 탐색할 값들을 미리 정해두고, 가능한 모든 조합을 하나하나 전부 테스트하는 방법이다.

예를 들어 Learning Rate와 Batch Size를 최적화해야하는 상황을 가정해 보자.
<br>
사용자가 Learning Rate 후보로 `[0.1, 0.01, 0.001]`을, Batch Size 후보로 `[16, 32, 64]`를 입력하면, 컴퓨터가 알아서 모든 경우의 수를 곱해서 총 9번의 실험을 진행한다.

![fig1](AI/Methodologies/Grid_Random-1.png){: style="display:block; margin:0 auto; width:40%;"}

파라미터 종류가 늘어날수록 테스트해야 할 조합이 기하급수적으로 늘어나게 되고, 진짜 최적값이 사용자가 정한 간격 사이에 있다면 최적값을 찾지 못한다는 단점이 존재한다.

## Random Search

사용자가 정해준 범위 내에서 무작위로 값을 뽑아 조합을 만들어 테스트하는 방법이다.

Grid Search와 달리, 사용자는 하이퍼파라미터를 찾을 연속적인 구간과 테스트할 횟수를 지정해야 한다.

![fig2](AI/Methodologies/Grid_Random-2.png){: style="display:block; margin:0 auto; width:40%;"}

Random Search가 Grid Search보다 효율적인 상황이 있다.

만약 Learning Rate가 Batch Size보다 더 중요한 하이퍼파라미터라고 가정해 보자.
<br>
Grid Search는 9번의 테스트 동안 Learning Rate를 단 3개의 값으로만 테스트하지만, Random Search는 9번의 테스트동안 Learning Rate를 서로 다른 9개의 값으로 테스트할 수 있다.

즉 똑같은 비용을 투자했을 때, Random Search가 중요한 파라미터를 더 다양하고 촘촘하게 탐색할 수 있다.
<br>
최적화해야 할 하이퍼파라미터가 많아질수록 이 장점이 극대화되어, 적은 시도 횟수로도 좋은 성능의 최적값을 찾아낼 확률이 높아진다.

하지만 Random Search 역시 철저히 무작위성에 의존하기 때문에, 최적값을 찾았다는 보장을 하기 어렵고 여전히 비효율적인 탐색이 발생할 수 있다는 단점이 존재한다.
