---
title: "[논리학] 논리 프로그래밍 (Logic Programming, LP)"
date: 2026-03-16 00:00:00 +/-TTTT
categories: [Mathmatics, Study]
tags: [논리학]
math: true
toc: true
author: sunho
---

## 논리 프로그래밍이란?

논리 프로그래밍은 1차 논리(FOL)를 실제 컴퓨터 프로그램으로 구현한 것이다.

| 용어 | 의미 | 표현 |
| :---: | :---: | :---: |
| Term | 객체를 나타내는 가장 기본적인 단위 <br> (상수, 변수, 함수로 변환된 상수) | $t:=c\mid x\mid f(t_1,\dots t_n)$ |
| Atom | `참` 또는 `거짓`을 가지는 기본 명제 | $\alpha:=p(t_1,\dots t_n)$ |
| Ground Atom | 변수가 없는 Atom <br> (모든 항이 상수인 경우) | $\text{ground}(p):=p(c_1,f(c_2),\dots)$ |
| Literal | Atom 또는 그 부정 | $L:=\alpha\mid\lnot\alpha$ |
| Clause | 여러 Literal이 논리합(OR)으로 연결된 식 | $L_1\lor L_2\lor\cdots\lor L _n$ |
| Rule | 단 하나의 긍정 Literal만 존재하는 특별한 Clause | $r:\alpha_1\lor\lnot\alpha_2\lor\cdots\lor\lnot\alpha_n$ |
| Immediate Consequence Operator | 규칙으로부터 새로운 Fact를 추론하는 연산자 | $T_P$ |

- Atom은 더 이상 논리적으로 분해되지 않는 가장 기본적인 논리 단위이다.
- 논리 프로그래밍에서는 <span style="background-color:#fff5b1">긍정 형태의 Ground Atom을 **Fact**라고 부른다.</span>

    즉 Fact는 아무런 전제 조건 없이 그 자체로 항상 참인 명제를 의미하므로, 조건부가 비어있는 규칙 $\alpha\leftarrow$ 형태로 해석할 수 있다.

### Rule

하나의 긍정 Literal ($\alpha_h$)과 여러 부정 Literal ($\lnot\alpha_1, \dots, \lnot\alpha_n$)들로 이루어진 규칙은 아래와 같은 논리합 식을 갖는다.

$$
\alpha_h\lor\lnot\alpha_1\lor\lnot\alpha_2\lor\cdots\lor\lnot\alpha_n
\tag{1}
$$

드모르간의 법칙과 조건문의 논리적 동치 $A \lor \lnot B \equiv B \rightarrow A$를 적용하면, 위의 식은 아래와 같이 표현할 수 있다.

$$
\alpha_h\leftarrow\alpha_1,\alpha_2,\cdots,\alpha_n
\tag{2}
$$

여기서 우항의 쉼표는 논리곱(AND)을 의미한다.
<br>
즉, $\alpha_1, \alpha_2, \cdots, \alpha_n$이 모두 참이면 $\alpha_h$가 참이 된다는 뜻이다.
<br>
우리가 흔히 규칙이라고 부르는 것처럼, 전제 조건인 $\lbrace\alpha_1, \alpha_2, \cdots, \alpha_n\rbrace$이 모두 만족될 때 결과인 $\alpha_h$가 도출된다고 생각하면 된다.
	
이때 결론에 해당하는 $\alpha_h$을 Head, 조건들에 해당하는 $\lbrace\alpha_2,\cdots,\alpha_n\rbrace$를 Body라고 부른다.

- $Head(r)=\alpha_r$
- $Body(r)=\lbrace\alpha_1, \alpha_2, \cdots, \alpha_n\rbrace$

예를 들어, `x가 사람이고 100살이면 죽는다`라는 규칙을 아래와 같이 표현할 수 있다.

$$
\text{죽는다}(x)\leftarrow\text{사람}(x),\text{100살}(x)
$$

### 논리 프로그램과 사실 집합

논리 프로그램(Logic Program)은 논리 프로그래밍에서 다루는 것으로, 규칙들의 집합으로 정의된다.

논리 프로그램 $P$는 개발자가 사전에 정의하여 컴퓨터에 입력해 둔 Knowledge Base이다.

$$
P:=\lbrace r_1,r_2,\dots,r_n\rbrace
\tag{3}
$$

사실 집합 $I$는 Immediate Consequence Operator이 증명 과정을 거쳐, 해당 명제는 `참`이라고 판단하여 모아둔 결과물을 의미한다.

$$
I=\lbrace \alpha_1,\alpha_2,\dots,\alpha_n\rbrace
\tag{4}
$$
	
### Immediate Consequence Operator

Immediate Consequence Operator는 논리 프로그램에서 현재 알고 있는 사실들을 바탕으로, 규칙을 단 한 번 적용하여 새롭게 알아낼 수 있는 사실들의 집합을 만들어내는 함수이다.
<br>
쉽게 말해, 지식을 점진적으로 확장해 나가는 추론 기계라고 볼 수 있다.

어떤 논리 프로그램 $P$가 주어졌고 현재 참이라고 가정하는 Fact들의 집합을 $I$라고 할 때, $T_P(I)$는 다음과 같이 정의된다.

$$
T_P(I) = \{ \alpha_h \mid \alpha_h \leftarrow \alpha_1, \dots, \alpha_n \in \text{ground}(P) \text{ 이고 } \{\alpha_1, \dots, \alpha_n\} \subseteq I \}
\tag{4}
$$

위 식을 쉽게 설명하면, 규칙의 조건들이 모두 현재 알고 있는 Fact라면, 그 규칙의 결론 $\alpha_h$를 새로운 Fact로 인정하고 결과 집합에 넣는다는 의미이다.

$T_P$의 동작 과정은 아래와 같다.

1. $T_P$는 논리 프로그램 $P$에 정의되어 있는 모든 규칙 $\lbrace r_1,r_2,\dots,r_k\rbrace$를 순회한다.
2. 각 규칙의 조건들 $\lbrace \alpha_1,\alpha_2,\dots,\alpha_n\rbrace$이 현재의 사실 집합 $I$ 내에 포함되어 있는지 확인한다.

    이때 하나라도 $I$에 없다면, 다음 규칙으로 넘어간다.
3. 2번의 검사를 통과했다면, 해당 규칙의 결론 $\alpha_h$를 $I$에 담는다.

#### 예시

예를 들어, 현재 우리에게 다음과 같은 논리 프로그램 $P$가 있다고 가정해 보자.

```python
P = {
    r1: 사람(철수) <-                # 조건 없는 Rule (Fact)
    r2: 밥을 먹는다(x) <- 사람(x)     # 일반적인 Rule
}
```

아무것도 모르는 백지상태에서 $T_P$ 연산자를 반복해서 적용하면 지식이 다음과 같이 확장된다.

1. **초기 상태 $I_0$**

    초기에는 아무것도 모르는 백지상태이므로 사실 집합이 공집합이다.

    $$
    I_0=\emptyset
    $$

    ```python
    I = {
        # 공집합
    }
    ```
2. **첫 번째 추론 $I_1 = T_P(I_0)$**

    첫 번째 규칙 `r_1`의 조건은 현재의 사실 집합에 포함된다. → $\emptyset \subseteq I_0$
    <br>
    따라서 해당 규칙의 결론 `사람(철수)`를 $I$에 담는다.

    두 번째 규칙 `r_2`의 조건은 현재의 사실 집합에 포함되지 않으므로 건너뛴다.

    $$
    I_1=\text{사람(철수)}
    $$

    ```python
    I = {
        사람(철수)
    }
    ```
3. **두 번째 추론 $I_2 = T_P(I_1)$**

    두 번째 규칙의 조건은 현재의 사실 집합에 포함된다. → $\text{사람(x)} \subseteq \text{사람(철수)}$
    <br>
    따라서 해당 규칙의 결론 `밥을먹는다(철수)`를 $I$에 담는다.

    $$
    I_2=\lbrace\text{사람(철수), 밥을먹는다(철수)}\rbrace
    $$

    ```python
    I = {
        사람(철수), 
        밥을먹는다(철수)
    }
    ```
4. **세 번째 추론 $I_3 = T_P(I_2)$**

    현재 지식을 바탕으로 Rule을 다시 적용해 보지만, 더 이상 새롭게 도출되는 사실이 없기 때문에 종료된다.

    $$
    I=\lbrace\text{사람(철수), 밥을먹는다(철수)}\rbrace
    $$
