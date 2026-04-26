---
title: "[VS Code] Git Graph"
date: 2026-02-23 06:00:00 +/-TTTT
categories: [Programming, 개발 환경]
tags: [VS Code]
math: true
toc: true
author: sunho
---

VS Code의 확장 프로그램인 **Git Graph**를 사용하면, Git의 작업 내역 (History, Branch, Merge)을 한눈에 볼 수 있다.
<br>
또한 마우스 클릭만으로 `commit`, `push`와 같은 Git 명령어를 실행할 수 있다.

### 그래프 보는 법

Git Graph는 2가지 방법으로 확인할 수 있다.

![fig1](Programming/Dev_Environment/VSCode_Git-1.png){: style="display:block; margin:0 auto; width:80%;"}

`View Git Graph` 버튼을 누르면 아래의 화면이 뜬다.

![fig2](Programming/Dev_Environment/VSCode_Git-2.png){: style="display:block; margin:0 auto; width:80%;"}

그래프에서 동그라미 하나는 하나의 commit을 의미한다.

빨간색 박스처럼 선이 옆으로 갈라져 나가는 것은 새로운 Branch 생성을 의미하고, 파란색 박스처럼 두 선이 하나로 합쳐지는 것은 Merge를 의미한다.

제일 왼쪽의 일직선은 현재 위치하고 있는 브랜치 (로컬 HEAD)이다.

### 마우스 클릭으로 Git 기능 사용

각 commit을 클릭하면 누가 어떤 파일을 수정했는지를 볼 수 있고, 파일을 클릭하면 코드의 어떤 부분이 수정되었는지도 확인할 수 있다.

![fig3](Programming/Dev_Environment/VSCode_Git-3.png){: style="display:block; margin:0 auto; width:80%;"}

Branch (선)나 commit (점)을 마우스 우클릭하면 아래와 같이 여러 메뉴 뜬다.

![fig4](Programming/Dev_Environment/VSCode_Git-4.png){: style="display:block; margin:0 auto; width:80%;"}

- **Create Branch:** 내가 원하는 과거의 특정 시점을 기준으로 브랜치 생성
- **Checkout Branch:** 해당 브랜치로 이동 (`git switch` 기능)
- **Merge into current branch:** 다른 브랜치를 지금 내 브랜치로 가져와서 합치기 (`git merge` 기능)

또한 commit 메시지를 작성하고 버튼 클릭으로 바로 commit이 가능하다.

![fig5](Programming/Dev_Environment/VSCode_Git-5.png){: style="display:block; margin:0 auto; width:50%;"}

Fetch, Pull, Push 또한 버튼 클릭으로 간단하게 할 수 있다.

![fig6](Programming/Dev_Environment/VSCode_Git-6.png){: style="display:block; margin:0 auto; width:50%;"}
