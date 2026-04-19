---
title: "[개발 환경] 도커 명령어"
date: 2026-04-16 06:00:00 +/-TTTT
categories: [Programming, 개발 환경]
tags: [개발 환경]
math: true
toc: true
author: sunho
---

![fig1](Programming/Dev_Environment/Docker_cmd-1.png){: style="display:block; margin:0 auto; width:80%;"}
_[[출처]](https://tech.ktcloud.com/)_

## 도커 이미지 관련 명령어

| 명령어 | 설명 |
| :---: | :---: |
| `docker pull` | 이미 만들어둔 이미지 다운로드 |
| `docker build` | 도커파일을 이용해 이미지 빌드 |
| `docker images` | 현재 존재하는 도커 이미지들의 전체 목록과 용량 출력 |
| `docker rmi` | 사용하지 않는 도커 이미지 삭제 |

### **`docker pull {다운받을 이미지 이름}`**

`docker pull`은 다른 사람이 이미 만들어둔 이미지를 다운로드하는 명령어다.

다른 사람이 만들어둔 이미지는 주로 [Docker Hub](https://hub.docker.com/)에서 다운받을 수 있다.

![fig2](Programming/Dev_Environment/Docker_cmd-2.png){: style="display:block; margin:0 auto; width:100%;"}

### **`docker build -t {빌드할 이미지 이름} {Dockerfile 경로}`**

`docker build`는 내가 작성한 도커파일을 바탕으로 새로운 이미지를 빌드하는 명령어다.

### **`docker images`**

`docker images`는 현재 내 컴퓨터에 다운로드되어 있거나 직접 만든 도커 이미지들의 전체 목록과 용량을 보여주는 명령어다.

![fig3](Programming/Dev_Environment/Docker_cmd-3.png){: style="display:block; margin:0 auto; width:100%;"}

### **`docker rmi {제거할 이미지 ID 또는 이름}`**

`docker rmi`는 더 이상 사용하지 않는 도커 이미지를 삭제하는 명령어다.

만약 해당 이미지를 사용해서 만든 컨테이너가 하나라도 남아있다면, 먼저 `docker rm` 명령어로 해당 컨테이너를 삭제해야 이미지를 지울 수 있다.

## 컨테이너 관련 명령어

| 명령어 | 설명 |
| :---: | :---: |
| `docker run` | 이미지를 바탕으로 컨테이너 생성 및 실행 |
| `docker ps` | 현재 실행 중인 컨테이너들의 목록, 상태, 생성 시간 등 출력 |
| `docker stop` | 실행 중인 컨테이너 중지 |
| `docker rm` | 중지된 컨테이너를 내 컴퓨터에서 완전히 삭제 |
| `docker exec` | 현재 실행 중인 컨테이너 내부에서 특정 명령어를 추가로 실행 |

### **`docker run {옵션} {사용할 이미지 이름}`**

`docker run`은 컨테이너를 생성한 다음 실행하는 명령어다.

아래는 `docker run` 명령어와 함께 사용할 수 있는 몇 가지 옵션이다.

| 옵션 이름 | 설명 | 예시 |
| :---: | :---: | :---: |
| `-d` | 백그라운드에서 실행 | `-d` |
| `-p` | 호스트와 컨테이너의 포트 연결 | `-p 8000:8000` |
| `-v` | 호스트와 컨테이너 내부의 폴더를 동기화 (마운트) | `-v ~/.cache/models:/root/.cache/models` |
| `-e` | 컨테이너에 설정값 전달 | `-e toekn="$my_token"` |
| `--name` | 생성될 컨테이너에 이름을 붙임 | `--name my_container` |
| `--gpus` | 컨테이너가 사용할 GPU 할당 | `--gpus '"device=0"'` , `--gpus all` |
| `--memory` | 컨테이너가 사용할 수 있는 최대 RAM 용량 제한 | `--memory=100m` , `--memory=80g` |
| `--shm-size` | 공유 메모리 용량 설정 | `--shm-size=8g` |

#### **`-d`**

컨테이너를 실행할 때 `-d` 옵션 없이 실행하면, 컨테이너는 터미널 화면에서 돌아간다. 다시 말해 컨테이너 안에서 출력되는 로그가 실시간으로 터미널에 출력되는데, 이 때문에 프로그램이 종료될 때까지 터미널은 입력 불가 상태가 된다.
<br>
만약 여기서 `Ctrl + C`를 눌러서 빠져나오면, 도커 컨테이너도 같이 죽어버리는 경우가 많다.

반대로 `-d` 옵션을 사용해서 실행하면, 컨테이너는 백그라운드에서 실행되고 터미널은 사용자가 명령어를 칠 수 있는 터미널 프롬프트 상태로 돌아온다.
<br>
컨테이너가 백그라운드에서 실행되기 때문에 사용자는 터미널에서 다른 작업을 이어서 할 수 있으며, 터미널을 종료해도 컨테이너는 계속 유지된다.

#### **`-v {내 컴퓨터 경로}:{컨테이너 내부 경로}`**

컨테이너는 삭제하면 내부 데이터가 날아간다. 이때 `-v` 옵션을 사용하면, 컨테이너를 지우더라도 동기화된 내 컴퓨터의 경로에는 데이터가 남아있게 된다.

예를 들어 AI 모델은 매우 무겁기 때문에 컨테이너를 새로 만들 때마다 가중치 파일을 다시 다운로드하는 건 시간 낭비다. 이때 `-v`를 통해 내 컴퓨터에 이미 받아둔 모델 폴더를 공유하면, 다운받지 않고 즉시 실행할 수 있다.

#### **`-e {환경 변수}`**

도커 컨테이너가 생성될 때, 내부에서 사용할 환경변수를 주입하는 옵션이다.

예를 들어 컨테이너 안에서 실행되는 프로그램이 허깅페이스 인증 토큰이 뭔지 물어볼 때, 도커가 환경변수에 설정된 값을 사용하라고 알려주게 된다.

> 환경변수는 프로세스가 실행될 때 참조하는 `key=value` 형태의 참조값을 의미한다.
>
> 환경변수를 사용하는 이유는 주로 보안때문이다.
> <br> 중요한 정보를 소스 코드에 직접 적으면 유출 위험이 있는데, 환경변수를 사용하면 코드 밖에 저장해 두고 프로그램이 실행될 때마다 값을 읽어올 수 있다.

### **`docker ps {옵션}`**

`docker ps`는 현재 실행 중인 컨테이너들의 목록, 상태, 생성 시간 등 출력하는 명령어다.

![fig4](Programming/Dev_Environment/Docker_cmd-4.png){: style="display:block; margin:0 auto; width:100%;"}

아래는 `docker run` 명령어와 함께 사용할 수 있는 몇 가지 옵션이다.

| 옵션 이름 | 설명 |
| :---: | :---: |
| `-a` | 중지된 컨테이너까지 포함해서 모든 컨테이너 목록 출력 |
| `-q` | 컨테이너 ID만 출력 |
| `-s` | 컨테이너가 차지하고 있는 실제 용량을 함께 출력 |
| `--no-trunc` | 정보를 생략하지 않고 전체 길이를 다 출력 |

아래 사진을 보면 `-a` 옵션을 사용해서 중지된 컨테이너 (STATUS가 Exited)까지 출력되는 것을 확인할 수 있다.

![fig5](Programming/Dev_Environment/Docker_cmd-5.png){: style="display:block; margin:0 auto; width:100%;"}

### **`docker stop {컨테이너 ID 또는 이름}`**

`docker stop`은 실행 중인 컨테이너 중지하는 명령어다.

### **`docker rm {컨테이너 ID 또는 이름}`**

`docker rm`은 중지된 컨테이너를 내 컴퓨터에서 완전히 삭제하는 명령어다.

컨테이너가 중지되어야지 삭제할 수 있기 때문에, 먼저 `docker stop`을 이용해 삭제하려는 컨테이너를 중지해야 한다.

### **`docker exec {옵션} {컨테이너 ID 또는 이름} {명령어}`**

`docker exec`는 현재 실행 중인 컨테이너 내부에서 특정 명령어를 추가로 실행할 때 사용하는 명령어다.

주로 터미널에서 컨테이너 내부에 접속하기 위해 `docker exec -it {컨테이너 ID 또는 이름} /bin/bash` 형태로 사용하며, 실시간 로그 파일을 확인하거나 설정값을 임시로 수정하는 등 이미지 빌드 없이 긴급한 디버깅 작업이 필요할 때 해당 명령어를 사용한다.

![fig6](Programming/Dev_Environment/Docker_cmd-6.png){: style="display:block; margin:0 auto; width:100%;"}
