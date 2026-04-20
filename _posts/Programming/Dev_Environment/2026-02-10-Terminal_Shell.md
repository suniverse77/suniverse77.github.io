---
title: "[개발 환경] 터미널과 쉘 (Shell)"
date: 2026-02-10 00:00:00 +/-TTTT
categories: [Programming, 개발 환경]
tags: [개발 환경]
math: true
toc: true
author: sunho
---

## 터미널과 쉘의 차이

터미널은 단순히 글자를 보여주는 창이고, 쉘은 실제 명령을 실행하는 엔진이라고 생각하면 된다.

- **터미널:** 사용자가 키보드로 명령어를 입력하고, 컴퓨터가 출력하는 결과를 모니터로 볼 수 있게 해주는 단순한 인터페이스이다.
- **쉘:** 터미널 창에 입력된 문법이 맞는지 검사하고, 실제 프로그램을 실행시키며, 그 결과를 다시 터미널에 돌려주는 프로그램이다.

## 주요 쉘의 특징

### Bash (Bourne Again Shell)

리눅스의 표준 쉘로, 대부분의 서버 환경에서 기본값으로 설정되어 있다.

모든 입출력을 단순한 문자열로 처리한다.

![fig1](Programming/Dev_Environment/Terminal_Shell-1.png){: style="display:block; margin:0 auto; width:80%;"}

### Zsh (Z Shell)

macOS의 기본 쉘로, Bash를 기반으로 자동 완성 등의 기능을 추가한 쉘이다.

### CMD (Command Prompt)

MS-DOS 시절부터 내려온 윈도우의 오래된 엔진으로, 현대적인 프로그래밍 기능을 수행하기에는 문법이 투박하고 기능이 제한적이다.

![fig2](Programming/Dev_Environment/Terminal_Shell-2.png){: style="display:block; margin:0 auto; width:80%;"}

### Windows Powershell

CMD의 한계를 극복하기 위해 마이크로소프트에서 만든 엔진이다.

Bash와 달리, 결과값이 단순 텍스트가 아니라 .NET 객체다.
<br>
예를 들어 프로세스 목록을 가져오면, 그저 글자가 아니라 메모리 사용량이나 CPU 점유율같은 데이터가 담긴 덩어리를 받는다.

리눅스 환경에 익숙한 사람들을 배려해서, `ls`나 `cd`와 같이 자주 사용하는 Bash 명령어를 PowerShell에서도 쓸 수 있게 미리 연결해두었다.

![fig3](Programming/Dev_Environment/Terminal_Shell-3.png){: style="display:block; margin:0 auto; width:80%;"}
