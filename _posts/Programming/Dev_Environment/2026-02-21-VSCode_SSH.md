---
title: "[VS Code] SSH 연결"
date: 2026-02-21 00:00:00 +/-TTTT
categories: [Programming, 개발 환경]
tags: [개발 환경]
math: true
toc: true
author: sunho
---

매번 터미널을 통해 원격 접속해서 검은색 창에서만 코딩하기에는 불편함이 많다. 
<br>
이때 VS Code의 **Remote - SSH** 확장 프로그램을 사용하면, 원격 서버에 있는 파일들을 마치 내 컴퓨터에 있는 파일처럼 편하게 열고, 수정하고, 실행할 수 있다.

### 1. 'Remote - SSH' 확장 프로그램 설치

먼저 로컬 컴퓨터의 VS Code에 원격 접속을 도와주는 확장 프로그램인 **Remote - SSH**를 설치해야 한다.
<br>
설치 방법은 다음과 같다.

1. VS Code의 좌측 메뉴 아이콘에서 **확장 (Extensions)** 탭을 클릭한다.
2. 검색창에 **Remote - SSH**를 검색한 뒤, **설치 (Install)** 버튼을 누른다.

설치하면 **Remote Explorer**라는 아이콘이 새로 생기게 된다.

![fig1](Programming/Dev_Environment/VSCode_SSH-1.png){: style="display:block; margin:0 auto; width:60%;"}

### 2. 접속할 서버 정보 확인 및 SSH Config 파일 설정

보통 SSH 연결을 할 때, 터미널에서 아래의 명령어를 이용해 접속할 것이다.

`ssh -p 12345 root@100.200.300.400`

위의 예시에서 각 정보의 의미는 다음과 같다.

| 위의 예시 | 설명 |
| :---: | :---: |
| `root` |  접속할 **사용자명 (User)** |
| `100.200.300.400` | 서버의 실제 **IP 주소 (HostName)** |
| `12345` | **포트 번호 (Port)** (별도 포트가 없다면 기본값은 22) |

매번 위의 명령어를 치는 것은 번거롭기 때문에, VS Code의 설정 파일에 미리 등록해 두는 것이 좋다.

1. VS Code 화면에서 F1 키 또는 `Ctrl+Shift+P`를 눌러 명령 팔레트를 연다.
2. 검색창에 **SSH**를 입력하고, **Remote-SSH: Open SSH Configuration File... (SSH 구성 파일 열기...)**를 선택한다.
3. 나타나는 경로 중 내 사용자 계정 폴더의 config 파일을 선택한다. 

    `C:\Users\이름\.ssh\config` 또는 `~/.ssh/config`
4. 열린 파일에 아래 양식에 맞춰 서버 정보를 입력하고 저장한다.

![fig2](Programming/Dev_Environment/VSCode_SSH-2.png){: style="display:block; margin:0 auto; width:60%;"}

위에서 `Host` 항목 옆의 `MyServer`는 해당 서버를 부를 별명 (Alias)이다.
<br>
이렇게 별명을 설정해 두면, 앞으로 터미널에서 복잡한 IP나 포트 번호를 외울 필요 없이 아래처럼 간편하게 접속할 수 있다.

`ssh MyServer`

### 3. 원격 서버 접속

이제 설정한 정보로 원격 서버에 접속해 볼 차례이다.

1. VS Code 좌측 하단 구석에 있는 **><** 모양을 클릭하거나, 좌측 메뉴의 **원격 탐색기 (Remote Explorer)** 아이콘을 클릭한다.

    ![fig3](Programming/Dev_Environment/VSCode_SSH-3.png){: style="display:block; margin:0 auto; width:80%;"}
2. 상단의 메뉴에서 **Connect to Host... (호스트에 연결...)**를 선택한다.

    ![fig4](Programming/Dev_Environment/VSCode_SSH-4.png){: style="display:block; margin:0 auto; width:80%;"}
3. 접속하고자 하는 서버를 클릭한다.

    ![fig5](Programming/Dev_Environment/VSCode_SSH-5.png){: style="display:block; margin:0 auto; width:80%;"}
4. 새로운 VS Code 창이 열리고, 상단에 뜨는 목록에서 접속할 서버의 운영체제를 선택한다. (보통 **Linux** 선택)

    ![fig6](Programming/Dev_Environment/VSCode_SSH-6.png){: style="display:block; margin:0 auto; width:80%;"}
5. 비밀번호를 묻는 프롬프트가 뜨면, 서버 비밀번호를 입력하고 엔터를 누른다. (입력 시 화면에 아무것도 안 보이는 것이 정상)

좌측 하단에 **SSH: MyServer**라고 뜨면 접속에 성공한 것이다.

![fig7](Programming/Dev_Environment/VSCode_SSH-7.png){: style="display:block; margin:0 auto; width:60%;"}

### 4. 작업 폴더 열기
서버에는 접속했지만, 아직 특정 폴더를 연 상태는 아니다.

좌측에서 **폴더 열기 (Open Folder)**를 클릭하거나 상단의 **파일(File) > 폴더 열기(Open Folder)**를 클릭하면, 화면 중앙 상단에 경로 입력창이 나타난다.

이제 원격 서버에서 작업할 디렉토리 경로를 입력하고 **확인 (OK)**을 누르면, 원격 서버의 파일들이 VS Code 좌측 탐색기 (Explorer)에 나타나게 된다.

![fig8](Programming/Dev_Environment/VSCode_SSH-8.png){: style="display:block; margin:0 auto; width:100%;"}

![fig9](Programming/Dev_Environment/VSCode_SSH-9.png){: style="display:block; margin:0 auto; width:100%;"}
