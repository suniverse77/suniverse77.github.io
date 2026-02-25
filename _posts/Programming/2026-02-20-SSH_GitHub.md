---
title: "[GitHub] GitHub SSH 연결"
date: 2025-12-17 00:00:00 +/-TTTT
categories: [Programming, etc]
tags: [GitHub]
math: true
toc: true
author: sunho
---

## 원격 저장소 & 로컬 저장소

SSH 원격 연결을 하면 VS Code UI를 사용하는 내 PC에서 작성한 파일이 SSH 서버에 저장된다.

`Git Push/Pull`을 통해 로컬 저장소의 파일들이 원격 저장소인 GitHub에 저장된다.

- **원격 저장소:** GitHub
- **로컬 저장소:** 내 컴퓨터 or SSH 서버

## GitHub 계정에 SSH Key 등록

**1. SSH Key 생성**

1. **Key 생성:** 아래 명령어 입력 후 엔터 연타

    `ssh-keygen -t ed25519 -C "GitHub 이메일 주소"`

2. **Public Key 복사:** 명령어로 출력된 `ssh-ed25519`로 시작하는 긴 문자열을 드래그해서 복사

    `cat ~/.ssh/id_ed25519.pub`

**2. SSH Key 등록**

1. 우측 상단의 프로필 클릭하고 **settings** 클릭

2. **SSH 등록:** 왼쪽 메뉴의 **SSH and GPG Keys** 클릭하고 **New SSH key** 클릭

## GitHub repository와 프로젝트 폴더 연결

1. 깃허브에서 새 repository 생성

2. 깃허브의 **<> Code** 버튼의 SSH 탭에서 `.git` 주소 복사

3. VS Code 터미널의 프로젝트 폴더에서 아래 명령어 입력

    `git init`

    `git config --global user.name "본인 이름(자유)"`

    `git config --global user.email "GitHub 이메일 주소"`

    `git remote add origin {복사한 .git 주소}`

4. **연결 확인**: 아래 명령어를 입력했을 때 등록한 주소가 보이면 연결 성공

    `git remote -v`

## 백업 (push)

### 처음 push하는 경우

1. 저장할 파일을 목록에 담기

    `git add .`

2. 버전 기록 (`" "`에는 작업 내용 요약하는 아무 말 작성)

    `git commit -m "Initial backup from SSH server"`

3. 브랜치 이름을 master에서 main으로 변경

    `git branch -M main`

4. 깃허브 서버로 내 파일 복사 (전송)

    `git push -u origin main`

### 이후 일상적인 push

`git add .`

`git commit -m "Backup from SSH server"`

`git push`
