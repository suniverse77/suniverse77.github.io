---
title: "[CNN] 가중치 초기화와 데이터 증강"
date: 2025-02-06 00:00:00 +/-TTTT
categories: [AI Basics, 컴퓨터 비전]
tags: [컴퓨터 비전, CNN]
math: true
toc: true
author: sunho
---

## 데이터 증강 (Data Augmentation)

데이터 세트의 크기를 증가시키는 것으로, 오버피팅을 방지할 수 있다.

![fig1](AI_Basics/CV/Data_Augmentation-1.png){: style="display:block; margin:0 auto; width:100%;"}
_출처: Stanford CS231n, Lecture 6 (CNN Architectures)_

데이터를 증강하는 방법에는 여러 가지가 있다.

### Horizontal Flips

이미지를 수평으로 뒤집는 방법이다.

![fig2](AI_Basics/CV/Data_Augmentation-2.png){: style="display:block; margin:0 auto; width:60%;"}
_출처: Stanford CS231n, Lecture 6 (CNN Architectures)_

### Random crops and scales

원본 이미지의 크기를 다양하게 조절한 뒤, 그중 일부를 무작위로 잘라내는 방법이다. 과정은 아래와 같다.

1. $[256,480]$ 사이에서 랜덤하게 $L$ 값을 선택한다.
2. 이미지의 가로, 세로 중 짧은 부분을 $L$로 설정하고, 긴 부분을 비율에 맞게 조정한다. 

    예를 들어 $L=300$일 때, $240\times360$ 크기의 이미지는 $300\times450$으로 scaling된다.
3. 랜덤한 위치를 선택해 특정 크기로 (예를 들어 $224\times 224$) 잘라낸다.

이 방법을 통해서 모델은 고양이의 얼굴만 크게 확대된 이미지, 몸통 일부만 보이는 이미지 등 다양한 상황을 학습할 수 있다.

![fig3](AI_Basics/CV/Data_Augmentation-3.png){: style="display:block; margin:0 auto; width:40%;"}
_출처: Stanford CS231n, Lecture 6 (CNN Architectures)_

### Color Jitter

이미지의 대비와 밝기 등 색상과 관련된 속성값을 랜덤하게 조절하는 방법이다.

![fig4](AI_Basics/CV/Data_Augmentation-4.png){: style="display:block; margin:0 auto; width:60%;"}
_출처: Stanford CS231n, Lecture 6 (CNN Architectures)_

### Cutout

이미지의 특정 영역을 랜덤으로 선택하여 검은색 또는 회색 사각형으로 가려버리는 방법이다.

![fig5](AI_Basics/CV/Data_Augmentation-5.png){: style="display:block; margin:0 auto; width:60%;"}
_출처: Stanford CS231n, Lecture 6 (CNN Architectures)_
