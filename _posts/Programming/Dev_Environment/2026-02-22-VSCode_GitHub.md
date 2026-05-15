---
title: "[VS Code] SSH 환경에서 로컬과 GitHub 연결"
date: 2026-02-22 00:00:00 +/-TTTT
categories: [Programming, 개발 환경]
tags: [VS Code, Git]
math: true
toc: true
author: sunho
---

VS Code로 SSH 서버에 원격 연결해 코딩할 때, 로컬 PC에서 코드를 편집하더라도 실제 파일 저장과 연산은 SSH 서버에서 수행된다.

이 프로젝트를 GitHub로 관리할 경우, Git의 입장에서는 SSH 서버가 **로컬 저장소**, GitHub가 **원격 저장소**가 된다.

## GitHub 계정에 SSH Key 등록

로컬 (SSH 서버)과 원격 GitHub 저장소 사이에 연결 통로를 만든다.

1. **SSH Key 생성:** SSH 서버의 터미널에서 아래 명령어 실행 후 엔터 연타

    `ssh-keygen -t ed25519 -C "<Key 설명>"`

2. **Public Key 복사:** 아래 명령어로 출력된 `ssh-ed25519`로 시작하는 긴 문자열을 드래그해서 복사

    `cat ~/.ssh/id_ed25519.pub`

3. SSH Key 등록

    1. [GitHub](https://github.com/) 우측 상단의 프로필 클릭하고 **settings** 클릭

    2. **SSH 등록:** 왼쪽 메뉴의 **SSH and GPG Keys** 클릭하고 **New SSH key** 클릭하고 Public Key 등록

    ![fig1](Programming/Dev_Environment/VSCode_GitHub-1.png){: style="display:block; margin:0 auto; width:80%;"}

## 로컬 프로젝트와 GitHub repository 연결

1. 깃허브에서 새 repository 생성

2. 깃허브의 `<> Code` 버튼의 SSH 탭에서 `.git` 주소 (원격 저장소 주소) 복사

    ![fig2](Programming/Dev_Environment/VSCode_GitHub-2.png){: style="display:block; margin:0 auto; width:60%;"}

3. VS Code 터미널의 프로젝트 폴더에서 아래 명령어를 순차적으로 실행

    ```bash
    # 현재 폴더를 Git 저장소로 초기화 (실행하면 .git 디렉토리가 생성)
    git init

    # git commit 작성자 이름 설정
    git config --global user.name "<작성자 이름>"

    # git commit 작성자 이메일 설정 (주로 GitHub에 등록된 이메일을 사용)
    git config --global user.email "<GitHub 이메일 주소>"

    # 현재 로컬 Git 저장소와 GitHub 원격 저장소 연결
    git remote add <원격 저장소 이름> <원격 저장소 주소>
    ```

    원격 저장소 이름으로는 주로 `origin`을 사용한다.
    <br>
    또한 서로 다른 이름으로 여러 원격 저장소를 등록하여, 하나의 로컬 프로젝트에 여러 개의 원격 저장소를 연결할 수 있다.

4. **연결 확인**: `git remote -v` 명령어를 실행했을 때 등록한 주소가 보이면 연결 성공

### .git 폴더

### .git 폴더

`.git` 폴더는 Git이 해당 폴더를 Git 저장소로 인식할 수 있도록 하는 숨김 폴더이다.

폴더 내부에서 `git init` 명령어를 실행하거나 `git clone`으로 저장소를 복제하면 자동으로 생성되며, 커밋 히스토리, 브랜치 정보 등의 Git 관련 데이터가 저장된다.

간혹 `git add .` 명령어를 실행할 때 `warning: adding embedded git repository` 경고가 발생하는 경우가 있다.
<br>
이 경고는 현재 프로젝트의 하위 폴더가 이미 별도의 Git 저장소인 경우, 즉 그 안에 또 다른 `.git` 폴더가 존재하는 경우에 발생한다.

이 경고를 무시하고 그대로 `push`하면, GitHub에 해당 폴더가 업로드는 되지만 실제 내부 파일은 포함되지 않은 빈 껍데기 폴더로 올라가게 된다.
<br>
GitHub에서는 아래와 같이 화살표 아이콘이 표시된 폴더 형태로 나타난다.

![fig3](Programming/Dev_Environment/VSCode_GitHub-3.png){: style="display:block; margin:0 auto; width:60%;"}

만약 해당 폴더 안의 파일들도 내 GitHub 저장소에 포함하고 싶다면, 폴더 내부의 `.git`을 제거하고 Git이 다시 일반 폴더로 추적하도록 만들어야 한다.
<br>
아래 순서대로 실행하면 된다.

```bash
# 하위 폴더의 .git 디렉토리 삭제
rm -rf <에러 발생한 폴더명>/.git

# 기존 서브모듈 기록 제거
git rm --cached <에러 발생한 폴더명>

git add .
```
