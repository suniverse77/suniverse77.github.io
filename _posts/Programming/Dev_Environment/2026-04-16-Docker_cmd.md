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
| `docker pull {다운받을 이미지 이름}` | 이미 만들어둔 이미지 다운로드 |
| `docker build -t {빌드할 이미지 이름} {Dockerfile 경로}` | 도커파일을 이용해 이미지 빌드 |
| `docker images` | 현재 존재하는 도커 이미지들의<br>전체 목록과 용량 출력 |
| `docker rmi {제거할 이미지 ID 또는 이름}` | 사용하지 않는 도커 이미지 삭제 |

- `docker pull {다운받을 이미지 이름}`

    [Docker Hub](https://hub.docker.com/)에 접속해서 다른 사람이 이미 만들어둔 이미지를 다운로드할 수 있다.

![fig1](Programming/Dev_Environment/Docker_cmd-1.png){: style="display:block; margin:0 auto; width:100%;"}

- `docker build -t {빌드할 이미지 이름} {Dockerfile 경로}`

    내가 작성한 도커파일을 바탕으로 새로운 이미지를 빌드할 수도 있다.

- `docker images`

    현재 내 컴퓨터에 다운로드되어 있거나 직접 만든 도커 이미지들의 전체 목록과 용량을 보여준다.



- `docker rmi {제거할 이미지 ID 또는 이름}`

    더 이상 사용하지 않는 도커 이미지를 삭제한다. 만약 해당 이미지를 사용해서 만든 컨테이너가 하나라도 남아있다면, 먼저 `docker rm` 명령어로 해당 컨테이너를 삭제해야 이미지를 지울 수 있다.


## 컨테이너 관련 명령어

| 명령어 | 설명 |
| :---: | :---: |
| `docker run {옵션} {사용할 이미지 이름}` | 이미지를 바탕으로 컨테이너 생성 및 실행 |
| `docker ps` | 현재 실행 중인 컨테이너들의 목록, 상태, 생성 시간 등 출력 |
| `docker stop {컨테이너 ID 또는 이름}` | 실행 중인 컨테이너 중지 |
| `docker rm {컨테이너 ID 또는 이름}` | 중지된 컨테이너를 내 컴퓨터에서 완전히 삭제 |

- `docker run {옵션} {사용할 이미지 이름}`

    컨테이너 실행 옵션에는 여러 가지가 있다. 그 중 일부는 아래와 같다.

    | 옵션 이름 | 설명 |
    | :---: | :---: |
    | `-d` | 백그라운드에서 조용히 실행 (터미널을 종료해도 컨테이너는 계속 실행) |
    | `-p` | 내 컴퓨터의 포트와 컨테이너의 포트 연결 |
    | `--name` | 생성될 컨테이너에 붙일 이름 |
    | `--gpus all` | 내 컴퓨터에 있는 모든 GPU를 컨테이너가 사용할 수 있도록 할당 |
    | `--memory` | 컨테이너가 사용할 수 있는 최대 RAM 용량 제한 |

    아래 예시에서 이미지 이름인 `vllm/vllm-openai:latest` 이후에 나오는 명령어들은 도커 옵션이 아니라, 해당 이미지 안의 VLLM 프로그램에게 전달되는 세부 지시사항이다.

    ```bash
    docker run -d \
        -p 1234:1234 \
        --name my_container \
        --gpus all \
        --memory=80g \
        vllm/vllm-openai:latest \
        --gpu-memory-utilization 0.9 
    ```

- `docker ps`


