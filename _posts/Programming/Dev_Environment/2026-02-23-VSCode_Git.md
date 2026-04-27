---
title: "[VS Code] VS Code에서 쉽게 Git 관리"
date: 2026-02-23 06:00:00 +/-TTTT
categories: [Programming, 개발 환경]
tags: [VS Code, Git]
math: true
toc: true
author: sunho
---

VS Code에서는 터미널에 명령어를 직접 치지 않아도, 자체 내장된 **Source Control** 탭과 **Git Graph** 확장 프로그램을 통해 시각적으로 쉽게 Git을 관리할 수 있다.

## Source Control

VS Code 내장 기능으로, 좌측 **Source Control** 탭 (초록색 박스)을 통해 이용할 수 있다.

크게 `REPOSITORIES`, `CHANGES`, `GRAPH` 탭 (빨간색 박스)으로 구분되어 있다.

![fig1](Programming/Dev_Environment/VSCode_Git-1.png){: style="display:block; margin:0 auto; width:100%;"}

- **`REPOSITORIES`**

    `REPOSITORIES`는 현재 VS Code에서 열려 있는 Git 레포지토리 목록을 보여주는 영역이다.
    <br>
    여러 프로젝트를 동시에 열어 작업할 때, 어떤 프로젝트의 변경 사항을 관리할지 선택할 수 있다.

    우측의 점 3개 아이콘 (분홍색 박스)을 클릭하면, 세부 메뉴 (분홍색 화살표)가 나타난다.

    ![fig2](Programming/Dev_Environment/VSCode_Git-2.png){: style="display:block; margin:0 auto; width:60%;"}

    - `Pull, Push` 버튼 (노란색 박스)을 누르면 세부 메뉴가 한번 더 나타난다.

        메뉴에서 `Pull` 또는 `Push`를 클릭해 현재 로컬 브랜치의 Upstream 브랜치와 연결하거나, `Pull from...` 또는 `Push to...`를 클릭해 원하는 브랜치와 연결할 수 있다.

        `Pull from...` / `Push to...`를 클릭하면 아래와 같이 VS Code 상단에 원격 저장소 브랜치 목록이 뜬다.

        ![fig3](Programming/Dev_Environment/VSCode_Git-3.png){: style="display:block; margin:0 auto; width:100%;"}

    - `Branch` 버튼 (노란색 박스)을 누르면 세부 메뉴가 한번 더 나타난다.

        메뉴에서 `Create Branch`를 클릭해 현재 브랜치를 기준으로 새 브랜치를 생성하거나, `Create Branch From...`을 클릭해 원하는 브랜치를 기준으로 새 브랜치를 생성할 수 있다.

        메뉴에서 `Rename Branch...`을 이용해 브랜치명을 변경하거나, `Delete Branch...`와 `Delete Remote Branch...`를 이용해 로컬 또는 원격 저장소의 브랜치를 삭제할 수도 있다.

- **`CHANGES`**

    `CHANGES`는 수정되었지만 아직 커밋되지 않은 파일들의 목록을 보여주는 영역이다.
    <br>
    터미널의 명령어들을 마우스 클릭만으로 간단하게 실행할 수 있다.

    `+` 아이콘 (초록색 원)을 누르면 수정된 모든 파일을 한 번에 추가하는 `git add .`수정된 모든 파일을 한 번에 추가한다.
    <br>
   이후 commit 메시지를 적고 commit 버튼 (주황색 박스)을 누르면 `git commit -m "<commit 메시지>"`를 실행한 것과 완벽하게 동일하게 커밋이 완료된다.

    `CHANGES`에서도 점 3개 아이콘 (분홍색 박스)을 통해 `REPOSITORIES`와 동일한 기능을 수행할 수 있다.

- **`GRAPH`**

    `GRAPH`는 복잡한 커밋 내역과 브랜치 흐름을 한눈에 파악할 수 있게 시각화해준 영역이다.
    <br>
    그래프 상의 선은 branch, 동그라미 하나는 각각의 commit을 의미한다.
    <br>
    그래프는 현재 내가 위치한 브랜치를 기준으로 보여주는데, 즉 제일 왼쪽의 일직선 branch가 항상 로컬 HEAD 브랜치이다.

    각 commit을 클릭하면 아래처럼 해당 commit 때 수정된 파일 목록을 보여주고, 파일을 클릭하면 파일 내에서 어느 부분이 수정되었는지도 보여준다.

    ![fig4](Programming/Dev_Environment/VSCode_Git-4.png){: style="display:block; margin:0 auto; width:80%;"}


## Git Graph (확장 프로그램)

**Git Graph** 확장 프로그램을 설치하면, 아래와 같이 `CHANGES` 탭에 `View Git Graph` 아이콘이 생긴다.

![fig5](Programming/Dev_Environment/VSCode_Git-5.png){: style="display:block; margin:0 auto; width:50%;"}

해당 아이콘을 클릭하면 창에 크게 아래와 같은 화면이 펼쳐진다.

![fig6](Programming/Dev_Environment/VSCode_Git-6.png){: style="display:block; margin:0 auto; width:80%;"}

Source Control의 `GRAPH`탭과 동일하게, 동그라미 하나는 하나의 commit을 의미한다.
<br>
또한 빨간색 박스처럼 선이 옆으로 갈라져 나가는 것은 새로운 Branch 생성을 의미하고, 파란색 박스처럼 두 선이 하나로 합쳐지는 것은 Merge를 의미한다.
