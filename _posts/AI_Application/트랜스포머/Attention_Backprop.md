---
title: "[트랜스포머] Attention 역전파"
date: 2026-01-01 0:00:00 +/-TTTT
categories: [AI, 트랜스포머]
tags: [트랜스포머]
math: true
toc: true
author: sunho
---

Attention layer에서의 forward 과정은 아래와 같다.

$$
S=QK^\top~\rightarrow~A=\frac{S}{\sqrt{d_k}}~\rightarrow~
P=\text{softmax}(A)~\rightarrow~O=PV
$$


