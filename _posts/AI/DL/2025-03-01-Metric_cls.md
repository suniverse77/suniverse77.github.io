---
title: "[평가지표] 혼동행렬 (Confusion Matrix)"
date: 2025-03-01 00:00:00 +/-TTTT
categories: [AI, 딥러닝]
tags: [3D Vision]
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

![fig2](dl/metric/1-2.png){: style="display:block; margin:0 auto; width:80%;"}
_[[출처]](https://devopedia.org/confusion-matrix)_

<details>
<summary><font color='#FF0000'>Example 1</font></summary>
<div markdown="1">

![fig3](dl/metric/1-3.png){: style="display:block; margin:0 auto; width:80%;"}
_[[출처]](https://ai.plainenglish.io/understanding-the-power-of-the-confusion-matrix-f23c214a65d2)_



---

</div>
</details>
<br>

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

**FN**

- 해당 위치에 실제 객체 A가 존재하는데, 모델이 B로 예측한 경우
- 해당 위치에 실제 객체 A가 존재하는데, 객체가 없다고 예측한 경우

**TN**

- 해당 위치에 실제 객체 B가 존재하는데, 모델이 B로 예측한 경우
- 해당 위치가 배경인데, 객체가 없다고 예측한 경우

**FP**

- 해당 위치에 실제 객체 B가 존재하는데, 모델이 A로 예측한 경우
- 해당 위치가 배경인데, 모델이 A로 예측한 경우
- 해당 위치에 실제 객체 A가 존재하는데, ②번을 만족하지 못한 경우

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

Precision은 모델이 **Positive**라고 <span style="background-color:#FFE6E6">예측</span>한 것들 중에서, 실제로 **Positive**인 것 (정답을 맞춤)의 비율을 의미한다.

$$
\text{Precision}=\frac{\vphantom{\big(}\text{TP}}{\text{TP}+\text{FP}}
$$

이 지표는 모델이 **Positive** 예측을 얼마나 잘 수행했는지를 나타내며, <span style="background-color:#fff5b1">실제 **Negative**인 데이터를 잘못 잡으면 안될 때</span> 중요하다. 즉, $\text{FP}$가 치명적인 경우에 중요하다.
    
스팸 메일 분류기를 예로 들 수 있다.

메일 분류기는 정상 메일 (**Negative**)을 스팸 (**Positive**)으로 분류하면 안된다. 만약, 정상 메일을 스팸으로 분류한다면 $\text{FP}$가 증가하게 된다.

### 재현율 (Recall, Sensitivity)

Recall은 <span style="background-color:#FFE6E6">실제</span> **Positive**인 것들 중에서, 모델이 **Positive**라고 올바르게 찾아낸 비율을 의미한다.

$$
\text{Recall}=\frac{\vphantom{\big(}\text{TP}}{\text{TP}+\text{FN}}
$$

이 지표는 모델이 실제 **Positive** 데이터를 얼마나 빠짐없이 잘 찾아내는가를 나타내며, <span style="background-color:#fff5b1">실제 **Positive**인 데이터를 놓치면 안 될 때</span> 중요하다. 즉, 잘못 예측한 $\text{FN}$이 치명적인 경우에 중요하다.

암 진단 모델을 예로 들 수 있다.

암 진단 모델은 실제 암 환자 (**Positive**)를 정상 (**Negative**)으로 진단하면 안된다. 만약, 암 환자를 정상으로 진단한다면 $\text{FN}$이 증가하게 된다.

간략하게, <span style="background-color:#FFE6E6">Precision은 얼마나 정확하게 예측하는지</span>, <span style="background-color:#C0FFFF">Recall은 얼마나 빠짐없이 찾아내는지</span>를 측정하는 지표이다.

### F1 Score

F1 Score는 Precision과 Recall의 조화 평균이다.

$$
\text{F1 Score}=2\times\frac{\vphantom{\big(}\text{Precision}\times\text{Recall}}{\text{Precision}+\text{Recall}}
$$

데이터가 불균형할 때 Accuracy 대신 사용하며, Precision과 Recall 모두 중요할 때 사용한다.

### AUROC (Area Under ROC Curve)

ROC (Receiver Operating Characteristic) 곡선은 모델의 임계값 변화에 따라 **FPR (False Positive Rate)**이 변할 때 **TPR (True Positive Rate, Recall)**이 어떻게 변하는지를 그린 곡선이다.

- **FPR**: 가짜를 진짜라고 잘못 판단할 비율로, 값이 $0$에 가까울수록 좋다.
- **TPR**: 진짜를 진짜라고 정확히 맞힐 비율로, 값이 $1$에 가까울수록 좋다.

이때, AUROC는 이 ROC 곡선 아래의 면적을 의미하며, 값이 $1$에 가까울수록 모델의 성능이 좋다고 본다.

![fig5](dl/metric/1-5.png){: style="display:block; margin:0 auto; width:50%;"}
_[[출처]](https://www.blog.trainindata.com/auc-roc-analysis/)_

#### TPR과 FPR의 관계

해당 부분은 '공돌이의 수학정리노트'님의 [*'ROC curve'*](https://angeloyeo.github.io/2020/08/05/ROC.html) 포스트를 참고하였습니다.

![fig6](dl/metric/1-6.png){: style="display:block; margin:0 auto; width:50%;"}
_[[출처]](https://www.blog.trainindata.com/auc-roc-analysis/)_

예를 들어, 의사 A는 모든 환자들을 다 암환자라고 판단한다고 하자.

그러면 실제로 암에 걸린 환자들은 모두 암 환자로 판정되고, 암에 걸리지 않은 환자들도 모두 암 환자로 판정된다.

즉, True Positive Rate와 False Positive Rate가 모두 높아지게 된다.

이는 아래와 같이 threshold가 낮다는 뜻이다.

![fig7](dl/metric/1-7.gif){: style="display:block; margin:0 auto; width:60%;"}
_[[출처]](https://www.blog.trainindata.com/auc-roc-analysis/)_

한편, 의사 B는 모든 환자들을 암환자가 아니라고 판단한다고 하자.

그러면 암에 걸리지 않은 환자들 뿐만 아니라, 실제로 암에 걸린 환자들도 모두 정상인으로 판정되게 된다.

즉, True Positive Rate와 False Positive Rate 모두 낮아지게 된다.

이는 아래와 같이 threshold가 높다는 뜻이다.

![fig8](dl/metric/1-8.gif){: style="display:block; margin:0 auto; width:60%;"}
_[[출처]](https://www.blog.trainindata.com/auc-roc-analysis/)_

#### 곡선 위의 점의 의미

곡선 위의 한 점은 특정 임계값 (Threshold)에서의 FPR과 TPR의 관계를 나타낸다.

즉, AUROC는 임계값을 0%부터 100%까지 쭉 변경해 가면서 얻어지는 (FPR, TPR) 좌표들을 모두 이어 그린 선인 것을 알 수 있다.

![fig9](dl/metric/1-9.gif){: style="display:block; margin:0 auto; width:80%;"}
_[[출처]](https://angeloyeo.github.io/2020/08/05/ROC.html)_

#### 곡선의 휘어짐 정도의 의미

곡선의 휘어짐은 모델이 **Positive**와 **Negative** 클래스를 얼마나 잘 구별하는지를 나타낸다.

모델이 두 클래스를 더 잘 구별할수록, ROC 커브는 좌상단에 더 가까워지게 된다.

![fig10](dl/metric/1-10.gif){: style="display:block; margin:0 auto; width:80%;"}
_[[출처]](https://angeloyeo.github.io/2020/08/05/ROC.html)_
