---
title: "[평가지표] 분류 모델 성능 평가"
date: 2025-03-01 00:00:00 +/-TTTT
categories: [AI, 딥러닝]
tags: [3D Vision]
math: true
toc: true
author: sunho
---

## Classification 평가 지표

분류 평가 지표는 모델의 예측이 실제 정답과 얼마나 일치하는지 측정하며, 혼동 행렬 (Confusion Matrix)을 기반으로 한다.

![fig1](dl/metric/1-1.png){: style="display:block; margin:0 auto; width:40%;"}
_[[출처]](https://www.blog.trainindata.com/confusion-matrix-precision-and-recall/)_

**Positive/Negative**는 모델이 예측한 값을, **True/False**는 그 예측이 맞았는지 틀렸는지를 의미한다.

- **TP (True Positive)** : 실제 **Positive**인 것을 **Positive**라고 올바르게 예측한 경우
- **TN (True Negative)** : 실제 **Negative**인 것을 **Negative**라고 올바르게 예측한 경우
- **FP (False Positive)** : 실제 **Negative**인 것을 **Positive**라고 잘못 예측한 경우
- **FN (False Negative)** : 실제 **Positive**인 것을 **Negative**라고 잘못 예측한 경우

<details>
<summary><font color='#FF0000'>Example 1</font></summary>
<div markdown="1">



</div>
</details>
<br>

![fig2](dl/metric/1-2.png){: style="display:block; margin:0 auto; width:80%;"}
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

![fig3](dl/metric/1-3.png){: style="display:block; margin:0 auto; width:50%;"}
_[[출처]](https://www.blog.trainindata.com/auc-roc-analysis/)_

#### TPR과 FPR의 관계

해당 부분은 '공돌이의 수학정리노트'님의 [*'ROC curve'*](https://angeloyeo.github.io/2020/08/05/ROC.html) 포스트를 참고하였습니다.

![fig4](dl/metric/1-4.png){: style="display:block; margin:0 auto; width:50%;"}
_[[출처]](https://www.blog.trainindata.com/auc-roc-analysis/)_

예를 들어, 의사 A는 모든 환자들을 다 암환자라고 판단한다고 하자.

그러면 실제로 암에 걸린 환자들은 모두 암 환자로 판정되고, 암에 걸리지 않은 환자들도 모두 암 환자로 판정된다.

즉, True Positive Rate와 False Positive Rate가 모두 높아지게 된다.

이는 아래와 같이 threshold가 낮다는 뜻이다.

![fig5](dl/metric/1-5.gif){: style="display:block; margin:0 auto; width:60%;"}
_[[출처]](https://www.blog.trainindata.com/auc-roc-analysis/)_

한편, 의사 B는 모든 환자들을 암환자가 아니라고 판단한다고 하자.

그러면 암에 걸리지 않은 환자들 뿐만 아니라, 실제로 암에 걸린 환자들도 모두 정상인으로 판정되게 된다.

즉, True Positive Rate와 False Positive Rate 모두 낮아지게 된다.

이는 아래와 같이 threshold가 높다는 뜻이다.

![fig6](dl/metric/1-6.gif){: style="display:block; margin:0 auto; width:60%;"}
_[[출처]](https://www.blog.trainindata.com/auc-roc-analysis/)_

#### 곡선 위의 점의 의미

곡선 위의 한 점은 특정 임계값 (Threshold)에서의 FPR과 TPR의 관계를 나타낸다.

즉, AUROC는 임계값을 0%부터 100%까지 쭉 변경해 가면서 얻어지는 (FPR, TPR) 좌표들을 모두 이어 그린 선인 것을 알 수 있다.

![fig7](dl/metric/1-7.gif){: style="display:block; margin:0 auto; width:80%;"}
_[[출처]](https://angeloyeo.github.io/2020/08/05/ROC.html)_

#### 곡선의 휘어짐 정도의 의미

곡선의 휘어짐은 모델이 **Positive**와 **Negative** 클래스를 얼마나 잘 구별하는지를 나타낸다.

모델이 두 클래스를 더 잘 구별할수록, ROC 커브는 좌상단에 더 가까워지게 된다.

![fig8](dl/metric/1-8.gif){: style="display:block; margin:0 auto; width:80%;"}
_[[출처]](https://angeloyeo.github.io/2020/08/05/ROC.html)_
