---
title: "[개발 환경] VSCode - SSH 환경에서 로컬과 GitHub 연결"
date: 2026-02-21 06:00:00 +/-TTTT
categories: [Programming, 개발 환경]
tags: [개발 환경]
math: true
toc: true
author: sunho
---

VS Code로 SSH 서버에 원격 연결해 코딩할 때, 로컬 PC에서 코드를 편집하더라도 실제 파일 저장과 연산은 SSH 서버에서 수행된다.

이 프로젝트를 GitHub로 관리할 경우, Git의 입장에서는 SSH 서버가 **로컬 저장소**, GitHub가 **원격 저장소**가 된다.

## GitHub 계정에 SSH Key 등록

로컬 (SSH 서버)과 원격 (GitHub) 사이에 연결 통로를 만든다.

1. **SSH Key 생성:** 아래 명령어 입력 후 엔터 연타

    `ssh-keygen -t ed25519 -C {"GitHub 이메일 주소"}`

2. **Public Key 복사:** 아래 명령어로 출력된 `ssh-ed25519`로 시작하는 긴 문자열을 드래그해서 복사

    `cat ~/.ssh/id_ed25519.pub`

3. SSH Key 등록

    1. 우측 상단의 프로필 클릭하고 **settings** 클릭

    2. **SSH 등록:** 왼쪽 메뉴의 **SSH and GPG Keys** 클릭하고 **New SSH key** 클릭하고 Public Key 등록

    ![fig1](Programming/Dev_Environment/GitHub_SSH-1.png){: style="display:block; margin:0 auto; width:80%;"}

## 로컬 프로젝트와 GitHub repository 연결

1. 깃허브에서 새 repository 생성

2. 깃허브의 `<> Code` 버튼의 SSH 탭에서 `.git` 주소 복사

    ![fig2](Programming/Dev_Environment/GitHub_SSH-2.png){: style="display:block; margin:0 auto; width:60%;"}

3. VS Code 터미널의 프로젝트 폴더에서 아래 명령어 입력

    `git init`

    `git config --global user.name {"본인 이름(자유)}"`

    `git config --global user.email {"GitHub 이메일 주소"}`

    `git remote add origin {복사한 .git 주소}`

4. **연결 확인**: 아래 명령어를 입력했을 때 등록한 주소가 보이면 연결 성공

    `git remote -v`

## 백업 (push)

### 처음 push하는 경우

1. 저장할 파일을 목록에 담기

    `git add .`

    > **`warning: adding embedded git repository` 경고가 발생한 경우**
    >
    > 이 경고문이 발생한 이유는 하위 폴더 내부에 이미 다른 `.git` 폴더가 존재하기 때문이다. 주로 `git clone`을 통해 다른 프로젝트를 통째로 가져왔을 때 발생한다.
    >
    > 만약 무시하고 push한다면, 깃허브에 해당 폴더가 올라가긴 하지만, 안이 텅 빈 껍데기 폴더로 올라가게 된다. (깃허브에서는 화살표가 그려져 있는 폴더로 아이콘이 생성됨)
    >
    > 만약 해당 폴더 안의 파일들도 내 깃허브 저장소에 포함하고 싶다면, 아래 명령어로 내부 `.git`을 지우고 다시 추적해야 한다.
    > 
    > `rm -rf {에러 발생한 폴더명}/.git`
    >
    > `git rm --cached {에러 발생한 폴더명}`
    >
    > `git add .`
    >
    > 필요없다면, 바로 `git commit` 명령어로 넘어가면 된다.

2. 버전 기록 (`" "`에는 작업 내용 요약하는 아무 말 작성)

    `git commit -m "Initial backup from SSH server"`

3. 브랜치 이름을 master에서 main으로 변경

    `git branch -M main`

4. 깃허브 서버로 내 파일 복사 (전송)

    `git push -u origin main`

    > **`! [rejected] main -> main (fetch first)` 에러가 발생한 경우**
    >
    > 이 에러가 발생한 이유는 처음 repository를 생성할 때, 'Add a README file' 체크박스를 선택했기 때문이다. (로컬과 원격의 히스토리가 달라 충돌이 발생한 것임)
    >
    > 내 로컬에서 작성한 내용이 맞다면, 아래의 명령어로 강제 push를 하면 된다. (원래 GitHub에 있는 README 무시하고 덮어버림)
    >
    > `git push -u origin +main`

### 이후 일상적인 push

`git add .`

`git commit -m "Backup from SSH server"`

`git push`
