---
title: "[파이토치] 텐서 차원 조작"
date: 2026-02-10 00:00:00 +/-TTTT
categories: [Programming, 파이토치]
tags: [파이토치]
math: true
toc: true
author: sunho
---

## 인덱싱과 슬라이싱

차원이 여러 개인 텐서를 인덱싱할 때 `a[0, 0]` 방법으로 할 수도 있고, `a[0][0]` 방법으로 할 수도 있다.

`a[0][0]` 방법의 인덱싱은 먼저 `a[0]`을 실행하여 `[0]`번째 요소에 해당하는 임시 텐서를 메모리에 생성한 다음, 그 임시 객체에서 다시 `[0]`번째 요소를 가져온다. 즉, 불필요한 임시 메모리가 할당되고 연산이 2번 일어나기 때문에 속도가 미세하게 더 느리다.

반면 `a[0, 0]` 방법의 인덱싱은 한 번의 연산으로 행렬의 `[0, 0]` 위치 좌표를 계산하여 메모리에 직접 접근하기 때문에 더 효율적이다.

```python
a = torch.tensor([
    [0, 1, 2, 3],
    [4, 5, 6, 7]
])

print(a[0])
print(a[0][0])
print(a[0, 0])

--------------------------------------------------------------
>>> tensor([0, 1, 2, 3])
    tensor([0])
    tensor([0])
```

슬라이싱 또한 마찬가지이다.

```python
a = torch.tensor([
    [0, 1, 2, 3],
    [4, 5, 6, 7]
])

print(a[0][1:3])
print(a[0, 1:3])

--------------------------------------------------------------
>>> tensor([1, 2])
    tensor([1, 2])
```

### 조건 인덱싱

텐서에서 특정 조건을 만족하는 요소들의 값을 원하는 값으로 지정할 때 사용한다.

크게 Boolean Indexing 방법과 `torch.where` 함수를 사용하는 방법이 있다.

#### Boolean Indexing

원본 텐서 자체의 값을 직접 변경하는 In-place 연산을 해야할 때 좋다.

```python
a = torch.tensor([1, -2, 3, -4, 5])

# 조건: a에서 0이하인 요소들 → 결과: 0으로 만들기
a[a <= 0] = 0
print(a)

--------------------------------------------------------------
>>> tensor([1, 0, 3, 0, 5])
```

#### torch.where

원본 텐서를 보존하면서 새로운 텐서를 생성하고 싶거나, 조건에 따라 두 개의 다른 텐서를 조합할 때 유용하다.

함수의 인자는 `(조건, 참일 때 값, 거짓일 때 값)`으로 구성되어 있다.

```python
a = torch.tensor([1, -2, 3, -4, 5])

# 조건: a에서 0보다 큰 요소들 → 결과: 참이면 a, 거짓이면 0으로 만들기
b = torch.where(a > 0, a, 0)
print(b)

--------------------------------------------------------------
>>> tensor([1, 0, 3, 0, 5])
```

## 병합

텐서를 병합하는데 에는 `cat`과 `stack` 함수가 있으며, 두 함수는 결과 텐서의 차원이 늘어나는가로 구분할 수 있다.

이때, `dim` 인자는 텐서의 어느 축을 기준으로 연산을 수행할 것인가를 결정한다.

예를 들어, 2차원 배열에서 `dim=0`은 위아래의 세로 방향을 의미하고 (행 방향), `dim=1`은 가로 방향을 의미한다. (열 방향)

![fig1](Programming/PyTorch/Tensor_dim-1.png){: style="display:block; margin:0 auto; width:90%;"}

### cat

텐서들을 기존에 존재하는 차원을 기준으로 이어 붙인다.

차원의 수는 변하지 않으며, 붙이려는 차원을 제외한 나머지 차원의 shape은 완전히 동일해야 한다.

![fig2](Programming/PyTorch/Tensor_dim-2.png){: style="display:block; margin:0 auto; width:90%;"}

```python
x = torch.randn([2, 3])
y = torch.randn([2, 3])
z = torch.randn([4, 3])

a = torch.cat([x, y], dim=0)
b = torch.cat([x, z], dim=0)
c = torch.cat([x, y], dim=1)

print(a.shape)
print(b.shape)
print(c.shape)
--------------------------------------------------------------
>>> torch.Size([4, 3])
    torch.Size([6, 3])
    torch.Size([2, 6])
```

### stack

텐서들을 묶어서 새로운 차원을 만들어 포갠다.

텐서의 차원의 수가 1개 늘어나며, 합치려는 모든 텐서의 shape이 동일해야 한다.

![fig3](Programming/PyTorch/Tensor_dim-3.png){: style="display:block; margin:0 auto; width:90%;"}

```python
x = torch.randn([4, 3])
y = torch.randn([4, 3])

a = torch.stack([x, y], dim=0)
b = torch.stack([x, y], dim=1)

print(a.shape)
print(b.shape)

--------------------------------------------------------------
>>> torch.Size([2, 4, 3])
    torch.Size([4, 2, 3])
```

텐서 요소로 이루어진 리스트를 배치 텐서로 변환할 때, `stack` 함수를 이용할 수 있다.

```python
x = [
    torch.tensor([1, 2, 3]),
    torch.tensor([4, 5, 6]),
    torch.tensor([7, 8, 9])
]

a = torch.stack(x, dim=0)

print(a)
print(a.shape)
--------------------------------------------------------------
>>> tensor([[1, 2, 3],
            [4, 5, 6],
            [7, 8, 9]])
    torch.Size([3, 3])
```
