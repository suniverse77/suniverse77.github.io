---
title: "[경량화] 지식 증류 기법 (Knowledge Distillation)"
date: 2025-10-20 00:00:00 +/-TTTT
categories: [AI, 딥러닝]
tags: [경량화]
math: true
toc: true
author: sunho
---

## 지식 증류 (Knowledge Distillation)

지식 증류는 크고 복잡한 Teacher Model이 정답을 찾아가는 과정과 방법을 작은 Student Model에게 전달하는 기법이다.

여기서 3가지 용어가 나온다.

- **Hard Label**: 실제 정답 라벨 ex) $[0,0,1]$
- **Soft Label**: Teacher 모델이 예측한 확률 분포 ex) $[0.95,0.04,0.01]$
- **Dark Knowledge**: Sotf Label 속에 숨어 있는 핵심 지식으로, 클래스 간의 미묘한 관계를 의미

예를 들어, Student 모델이 Hard Label만 보고 학습하면 '이 사진은 고양이다'라는 1차원적인 정보만 얻는다. 하지만 Soft Label에 대해 학습하면, 정답이 고양이인 것뿐만 아니라, '고양이가 개와 4%정도, 호랑이와는 1%정도 닮았다'라는 클래스 간의 정보 또한 배울 수 있다.

## 지식 전달 방식에 따른 분류

![fig1](dl/lightweight/2-1.png){: style="display:block; margin:0 auto; width:70%;"}
_[[출처]](https://www.researchgate.net/figure/a-The-generic-response-based-knowledge-distillation-b-The-generic-feature-based_fig3_369207253)_

### 응답 기반의 지식 증류 (Response-based KD)

상단 그림의 a에 해당하며, Teacher 모델의 최종 예측 확률 분포인 Soft Label을 전달한다.

즉, Student 모델은 Soft Label을 똑같이 모방하도록 학습한다.

### 특징 기반의 지식 증류 (Feature-based KD)

상단 그림의 b에 해당하며, Teacher 모델의 Hidden Layer Feature를 전달한다.

Student 모델이 결과뿐만 아니라 중간 과정까지 배우도록 하는 방식이다.

이는 Teacher 모델이 최종 정답만 알려주는 것이 아니라, '정답을 찾으려면 먼저 이런 특징을 찾고, 그다음 저런 특징을 찾아야 해'라는 자신의 풀이 방법을 Student 모델에게 알려주는 것과 같다. 

주로 Teacher 모델과 Student 모델의 크기 차이가 매우 클 때 효과적이다.

### 관계 기반의 지식 증류 (Relation-based KD)

상단 그림의 c에 해당하며, 데이터 간의 관계를 전달한다.

이는 Teacher 모델이 여러 데이터를 보고 'A와 B는 비슷하다' 또는 'A와 C는 매우 다르다'라고 판단하는 데이터 간의 관계나 개념 간의 관계 자체를 Student 모델에게 가르치는 것과 같다.

## 학습 방식에 따른 분류

### 오프라인 증류 (Offline Distillation)



### 온라인 증류 (Online Distillation)

