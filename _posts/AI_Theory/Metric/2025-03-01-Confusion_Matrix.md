---
title: "[평가 지표] 혼동행렬 (Confusion Matrix)"
date: 2025-03-01 00:00:00 +/-TTTT
categories: [AI Theory, 평가 지표]
tags: [평가 지표]
math: true
toc: true
author: sunho
---

## 혼동행렬 (Confusion Matrix)

모델의 예측 결과를 실제 정답과 비교하여

![fig1](dl/metric/1-1.png){: style="display:block; margin:0 auto; width:40%;"}
_[[출처]](https://www.blog.trainindata.com/confusion-matrix-precision-and-recall/)_

**Positive/Negative**는 <span style="background-color:#fff5b1">모델이 예측한 값</span>을, **True/False**는 <span style="background-color:#fff5b1">그 예측이 맞았는지 틀렸는지</span>를 의미한다.

- **TP (True Positive)** : 실제 **Positive**인 것을 **Positive**라고 올바르게 예측한 경우
- **TN (True Negative)** : 실제 **Negative**인 것을 **Negative**라고 올바르게 예측한 경우
- **FP (False Positive)** : 실제 **Negative**인 것을 **Positive**라고 잘못 예측한 경우
- **FN (False Negative)** : 실제 **Positive**인 것을 **Negative**라고 잘못 예측한 경우

TP와 FN은 실제 Positive인 경우, TN과 FP는 실제 Negative인 경우이다.

### Classification에서의 계산 방법

Classification에서는 이미지 단위로 계산한다.

**이진 분류**

하나의 클래스를 기준으로 설정하고 계산한다.

아래는 클래스 A를 **Positive**라고 가정할 경우이다. (B는 **Negative**임)

- 실제 클래스가 A인데, 모델이 A로 예측한 경우 → **TP**
- 실제 클래스가 A인데, 모델이 B로 예측한 경우 → **FN**
- 실제 클래스가 B인데, 모델이 B로 예측한 경우 → **TN**
- 실제 클래스가 B인데, 모델이 A로 예측한 경우 → **FP**

**다중 분류**

다중 분류에서는 기준 클래스를 돌아가면서 계산한다.

- 실제 클래스가 A인데, 모델이 A로 예측한 경우 → **TP**
- 실제 클래스가 A인데, 모델이 다른 클래스로 예측한 경우 → **FN**
- 실제 클래스가 A가 아닌데, 모델이 다른 클래스로 예측한 경우 → **TN**
- 실제 클래스가 A가 아닌데, 모델이 A로 예측한 경우 → **FP**

![fig2](dl/metric/1-2.png){: style="display:block; margin:0 auto; width:60%;"}
_[[출처]](https://devopedia.org/confusion-matrix)_

<details>
<summary><font color='#FF0000'>Example 1</font></summary>
<div markdown="1">

![fig3](dl/metric/1-3.png){: style="display:block; margin:0 auto; width:50%;"}
_[[출처]](https://ai.plainenglish.io/understanding-the-power-of-the-confusion-matrix-f23c214a65d2)_

클래스 A 기준 아래와 같이 계산할 수 있다.

- **TP** = 50
- **FN** = 10 + 0 = 10
- **TN** = 80 + 70 + 15 + 10 = 175
- **FP** = 5 + 2 = 7

클래스 B 기준 아래와 같이 계산할 수 있다.

- **TP** = 80
- **FN** = 5 + 15 = 20
- **TN** = 50 + 70 + 0 + 2 = 122
- **FP** = 10 + 10 = 20

---

</div>
</details>

### Semantic Segmentation에서의 계산 방법

Semantic Segmentation에서는 픽셀 단위로 계산한다.

계산 방법은 Classification과 동일하다.

### Object Detection에서의 계산 방법

Object Detection에서는 Bounding Box 단위로 계산한다.

아래의 경우가 모두 충족해야 예측에 성공했다고 한다.

1. 실제 클래스와 예측한 클래스가 맞은 경우
2. 정답 박스와 예측 박스의 IoU 값이 임계값을 넘은 경우

아래는 클래스 A를 **Positive**라고 가정할 경우이다. (B와 배경은 **Negative**임)

**TP**

- 해당 위치에 실제 객체 A가 존재하는데, ①, ②번 모두 만족한 경우

**FN** → 놓친 경우

- 해당 위치에 실제 객체 A가 존재하는데, 모델이 B로 예측한 경우
- 해당 위치에 실제 객체 A가 존재하는데, 객체가 없다고 예측한 경우
- 해당 위치에 실제 객체 A가 존재하고 ①번을 만족했지만, ②번을 만족하지 못한 경우

**FP** → 오검출한 경우

- 해당 위치가 배경인데, 모델이 A로 예측한 경우
- 해당 위치에 실제 객체 B가 존재하는데, 모델이 A로 예측한 경우
- 해당 위치에 실제 객체 A가 존재하고 ①번을 만족했지만, ②번을 만족하지 못한 경우
- 중복 검출한 경우

객체 탐지에서는 배경 영역은 매우 많기 때문에 **TN**은 계산하지 않는다.

## 혼동행렬 기반 성능 지표

![fig4](dl/metric/1-4.png){: style="display:block; margin:0 auto; width:80%;"}
_[[출처]](https://velog.io/@jjw9599/ConfusionMatrix-ClassificationEvaluation)_

### 정확도 (Accuracy)

Accuracy는 전체 데이터 중에서 모델이 올바르게 예측한 비율을 의미한다.

$$
\text{Accuracy}=\frac{\vphantom{\big(}\text{TP}+\text{TN}}{\text{TP}+\text{TN}+\text{FP}+\text{FN}}
$$

데이터가 불균형할 때 성능을 제대로 평가하기 어렵다는 단점이 있다.

예를 들어 99%가 정상, 1%가 불량인 경우, 모델이 전부 정상으로 예측해도 99%의 정확도가 나오게 된다.

### 정밀도 (Precision)

Precision은 모델이 **Positive**라고 예측한 것들 중에서, 실제로 **Positive**인 것 (정답을 맞춤)의 비율을 의미한다.

$$
\text{Precision}=\frac{\vphantom{\big(}\text{TP}}{\text{TP}+\text{FP}}
$$

이해하기 쉽게, `'너가 Positive라고 예측한 거, 진짜 확실해?'`라고 질문을 던지는 것과 같다.

즉, 모델의 <span style="background-color:#FFE6E6">신중함</span> (함부로 정답이라고 말하지 않음)을 평가하는 지표이며, **FP**를 싫어한다.

예를 들어, 정상 메일 (**Negative**)을 스팸 (**Positive**)으로 분류하면 안되는 스팸 메일 분류기에서 사용할 수 있다.

### 재현율 (Recall, Sensitivity)

Recall은 실제 **Positive**인 것들 중에서, 모델이 **Positive**라고 올바르게 찾아낸 비율을 의미한다.

$$
\text{Recall}=\frac{\vphantom{\big(}\text{TP}}{\text{TP}+\text{FN}}
$$

이해하기 쉽게, `'Positive인거, 다 찾은거 맞아?'`라고 질문을 던지는 것과 같다.

즉, 모델의 <span style="background-color:#FFE6E6">집요함</span> (의심가면 일단 다 잡음)을 평가하는 지표이며, **FN**를 싫어한다.

예를 들어, 실제 암 환자 (**Positive**)를 정상 (**Negative**)으로 진단하면 안되는 암 진단 모델에서 사용할 수 있다.

### F1 Score

F1 Score는 Precision과 Recall의 조화 평균이다.

$$
\text{F1 Score}=2\times\frac{\vphantom{\big(}\text{Precision}\times\text{Recall}}{\text{Precision}+\text{Recall}}
$$

데이터가 불균형할 때 Accuracy 대신 사용하며, Precision과 Recall 모두 중요할 때 사용한다.
