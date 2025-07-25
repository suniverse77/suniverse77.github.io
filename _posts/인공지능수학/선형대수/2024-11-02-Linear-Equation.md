---
layout: single
title: "[선형대수] Linear Equation"
last_modified_at: 2024-11-02
categories: ["인공지능 수학"]
tags: ["선형대수"]
excerpt: "선형 연립 방정식의 행렬 표현과 가우스 소거법"
use_math: true
toc: true
toc_sticky: true
---

## System of Linear Equations

여러 개의 연립 방정식을 하나의 행렬로 나타낸 것을 Augmented Matrix라고 부른다.

<center><img src='{{"/assets/images/인공지능수학/1-2. Figure1.png" | relative_url}}' width="50%"></center>

### 1. Unique solution

- Augmented Matrix의 rank가 미지수의 개수와 같을 때 발생한다.

### 2. No solution

- Overdeterminant System(제약 조건이 더 많은 상황)에서 발생한다.
- 제약 조건이 서로 모순일 때 발생한다.

### 3. Infinitely many solutions

- Underdeterminant System(미지수가 더 많은 상황)에서 발생한다.
- 연립방정식이 free varaible을 포함할 때 발생한다.

## Gauss Elimination

연립방정식을 Reduced REF로 변형하는 알고리즘

<details>
<summary><font color='red'>Example</font></summary>
<div markdown="1">

$$
\begin{bmatrix}\begin{array}{ccc|c}1&1&1&6\\2&3&1&14\\1&-1&2&2\end{array}\end{bmatrix}
$$

---

1. $\rho_2=\rho_2-2\rho_1$ , $\rho_3=\rho_3-\rho_1$

   $$
   \begin{bmatrix}\begin{array}{ccc|c}1&1&1&6\\0&1&-1&2\\0&-2&1&-4\end{array}\end{bmatrix}
   $$
2. $\rho_3=\rho_3+2\rho_1$

   $$
   \begin{bmatrix}\begin{array}{ccc|c}1&1&1&6\\0&1&-1&2\\0&0&-1&0\end{array}\end{bmatrix}
   $$  

</div>
</details>

### Reduced REF (Row Echelon Form)

모든 pivot이 1이고, 해당 열에서 pivot이 0이 아닌 유일한 요소인 형태

<center><img src='{{"/assets/images/인공지능수학/1-2. Figure2.png" | relative_url}}' width="30%"></center>

- REF에서 각 행의 leading entry에 해당하는 성분을 pivot이라고 부른다.
- REF에서 pivot에 대응되는 변수들을 pivot 또는 basic variable이라고 하고, 그 외의 변수들을 free variable이라고 부른다.

## Solve Linear Equation

연립방정식의 General solution은 Particular solution과 Homogeneous solution의 합으로 표현될 수 있다.

- Homogeneous solution은 Particular Solution에 더해도 변하지 않는다.
- $Ax=A(x_p+x_h)=Ax_p+Ax_h=b+0=b$
    
$Ax=0$에서 행렬 $A$가 invertible하다면, 해는 zero vector (trivial solution)밖에 없다.
- $Ax=0$ → $A^{-1}Ax=A^{-1}0$ → $x=0$
    
Linear System에서 $\mathbf{0}$인 해를 trivial solution, $\mathbf{0}$이 아닌 해를 non-trivial solution이라고 부른다.

<details>
<summary><font color='red'>Example</font></summary>
<div markdown="1">
  
<center><img src='{{"/assets/images/인공지능수학/1-2. Figure3.png" | relative_url}}' width="40%"></center>

---

**Solve Non-Homogeneous Equation**

1. Non-Homogeneous Equation을 Augmented Matrix로 변환

   $$
   \begin{bmatrix}\begin{array}{cccc|c}1&0&8&-4&42\\0&1&2&12&8\end{array}\end{bmatrix}
   $$
2. 가우스 소거법을 사용해 REF로 변환
3. Free variable들을 원하는 값으로 설정

   $$
   x_3=0,~x_4=0
   $$
4. Pivot variable들을 구함

   $$
   x_2+2x_3+12x_4=8~\to~x_2=8
   $$
   
   $$
   x_1+8x_3-4x_4=42~\to~x_1=42
   $$
6. Particular solution을 구함

   <center><img src='{{"/assets/images/인공지능수학/1-2. Figure4.png" | relative_url}}' width="15%"></center>

**Solve Homogeneous Equation**

1. Homogeneous Equation을 Augmented Matrix로 변환

   $$
   \begin{bmatrix}\begin{array}{cccc|c}1&0&8&-4&0\\0&1&2&12&0\end{array}\end{bmatrix}
   $$
2. 가우스 소거법을 사용해 REF로 변환
3. non-pivot column에 관련된 variable들을 free variable들로 표현
   
   $$
   x_2=-2x_3-12x_4
   $$

   $$
   x_1=-8x_3+4x_4
   $$
5. Homogeneous solution

     <center><img src='{{"/assets/images/인공지능수학/1-2. Figure5.png" | relative_url}}' width="35%"></center>

**Find General solution**

<center><img src='{{"/assets/images/인공지능수학/1-2. Figure6.png" | relative_url}}' width="50%"></center>

</div>
</details>
