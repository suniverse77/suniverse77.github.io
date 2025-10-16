---
title: "[트랜스포머] Self-Attention"
date: 2025-02-15 12:00:00 +/-TTTT
categories: [AI, 딥러닝]
tags: [트랜스포머]
math: true
toc: true
author: sunho
---

해당 포스트는 3Blue1Brown님의 [「*Attention in transformers, step-by-step*」](https://www.youtube.com/watch?v=eMlx5fFNoYc&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=7) 영상을 참고하였습니다.

## Attention

임베딩만으로는 각 단어의 문맥적 의미를 파악하지 못한다.

![fig1](dl/transformer/3-1.png){: style="display:block; margin:0 auto; width:100%;"}
_[[출처: 3Blue1Brown]](https://www.youtube.com/watch?v=eMlx5fFNoYc&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=7)_
