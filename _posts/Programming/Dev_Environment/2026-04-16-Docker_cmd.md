---
title: "[개발 환경] 도커 명령어"
date: 2026-04-16 06:00:00 +/-TTTT
categories: [Programming, 개발 환경]
tags: [개발 환경]
math: true
toc: true
author: sunho
---

## 도커 이미지 관련 명령어

| 명령어 | 설명 |
| :---: | :---: |
| `docker pull` | 이미 만들어둔 이미지 다운로드 |
| `docker build` | 도커파일을 이용해 이미지 빌드 |
| `docker images` | 현재 존재하는 도커 이미지들의 전체 목록과 용량 출력 |
| `docker rmi` | 사용하지 않는 도커 이미지 삭제 |

### `docker pull {다운받을 이미지 이름}`

`docker pull`은 다른 사람이 이미 만들어둔 이미지를 다운로드한다.

다른 사람이 만들어둔 이미지는 주로 [Docker Hub](https://hub.docker.com/)에서 다운받을 수 있다.

![fig1](Programming/Dev_Environment/Docker_cmd-1.png){: style="display:block; margin:0 auto; width:100%;"}

### `docker build -t {빌드할 이미지 이름} {Dockerfile 경로}`

`docker build`는 내가 작성한 도커파일을 바탕으로 새로운 이미지를 빌드한다.

### `docker images`

`docker images`는 현재 내 컴퓨터에 다운로드되어 있거나 직접 만든 도커 이미지들의 전체 목록과 용량을 보여준다.

![fig2](Programming/Dev_Environment/Docker_cmd-2.png){: style="display:block; margin:0 auto; width:100%;"}

### `docker rmi {제거할 이미지 ID 또는 이름}`

`docker rmi`는 더 이상 사용하지 않는 도커 이미지를 삭제한다.

만약 해당 이미지를 사용해서 만든 컨테이너가 하나라도 남아있다면, 먼저 `docker rm` 명령어로 해당 컨테이너를 삭제해야 이미지를 지울 수 있다.


## 컨테이너 관련 명령어

| 명령어 | 설명 |
| :---: | :---: |
| `docker run` | 이미지를 바탕으로 컨테이너 생성 및 실행 |
| `docker ps` | 현재 실행 중인 컨테이너들의 목록, 상태, 생성 시간 등 출력 |
| `docker stop` | 실행 중인 컨테이너 중지 |
| `docker rm` | 중지된 컨테이너를 내 컴퓨터에서 완전히 삭제 |

### `docker run {옵션} {사용할 이미지 이름}`

`docker run`은 컨테이너를 생성한 다음 실행하는 명령어이다.

컨테이너를 실행할 때 `-d` 옵션 없이 실행하면, 컨테이너는 터미널 화면에서 돌아간다. 다시 말해 컨테이너 안에서 출력되는 로그가 실시간으로 터미널에 출력되는데, 이 때문에 프로그램이 종료될 때까지 터미널은 입력 불가 상태가 된다.
<br>
만약 여기서 `Ctrl + C`를 눌러서 빠져나오면, 도커 컨테이너도 같이 죽어버리는 경우가 많다.

반대로 `-d` 옵션을 사용해서 실행하면, 컨테이너는 백그라운드에서 실행되고 터미널은 사용자가 명령어를 칠 수 있는 터미널 프롬프트 상태로 돌아온다.
<br>
컨테이너가 백그라운드에서 실행되기 때문에, 사용자는 터미널에서 다른 작업을 이어서 할 수 있다.

| 옵션 이름 | 설명 | 예시 |
| :---: | :---: | :---: |
| `-d` | 백그라운드에서 조용히 실행 | - |
| `-p` | 내 컴퓨터의 포트와 컨테이너의 포트 연결 | - |
| `--name {컨테이너 이름}` | 생성될 컨테이너에 이름을 붙임 | `--name my_container` |
| `--gpus all` | 내 컴퓨터에 있는 모든 GPU를 컨테이너가 사용할 수 있도록 할당 | `--gpus all` , `--gpus all` |
| `--memory={RAM 용량}` | 컨테이너가 사용할 수 있는 최대 RAM 용량 제한 | `--memory=80g ` , `--memory=80g ` |
| `--shm-size={}` | 컨테이너에 할당되는 공유 메모리의 크기를 설정 |

아래 예시에서 이미지 이름인 `vllm/vllm-openai:latest` 이후에 나오는 명령어들은 도커 옵션이 아니라, 해당 이미지 안의 VLLM 프로그램에게 전달되는 세부 지시사항이다.

```bash
docker run \
    -d \
    -p 1234:1234 \
    --name my_container \
    --gpus all \
    --memory=80g \
    vllm/vllm-openai:latest \
    --gpu-memory-utilization 0.9 
```

### `docker ps {옵션}`

`docker ps`는 현재 실행 중인 컨테이너들의 목록, 상태, 생성 시간 등 출력

![fig3](Programming/Dev_Environment/Docker_cmd-3.png){: style="display:block; margin:0 auto; width:100%;"}

### `docker stop {컨테이너 ID 또는 이름}`

### `docker rm {컨테이너 ID 또는 이름}`
