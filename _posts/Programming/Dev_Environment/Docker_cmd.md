---
title: "[개발 환경] 도커 명령어"
date: 2026-04-16 06:00:00 +/-TTTT
categories: [Programming, 개발 환경]
tags: [개발 환경]
math: true
toc: true
author: sunho
---

1. 이미지(Image) 관련 명령어 (밀키트 준비하기)
docker pull [이미지 이름]

설명: 도커 허브(Docker Hub) 같은 저장소에서 다른 사람이 이미 만들어둔 이미지를 내 컴퓨터로 다운로드합니다.

예시: docker pull ubuntu:latest (최신 버전의 우분투 운영체제 이미지를 다운로드)

docker build -t [이미지 이름] [Dockerfile 경로]

설명: 내가 작성한 Dockerfile의 레시피를 바탕으로 새로운 이미지를 생성(빌드)합니다. -t 옵션을 사용해 이미지에 알아보기 쉬운 이름(태그)을 붙입니다.

예시: docker build -t my-python-app . (현재 폴더에 있는 Dockerfile을 사용해 'my-python-app'이라는 이미지를 생성)

docker images

설명: 현재 내 컴퓨터에 다운로드되어 있거나 직접 만든 도커 이미지들의 전체 목록과 용량을 보여줍니다.

2. 컨테이너(Container) 관련 명령어 (실제로 구동하고 관리하기)
docker run [옵션] [이미지 이름]

설명: 이미지를 바탕으로 컨테이너를 생성하고 실행합니다. 도커에서 가장 중요하고 강력한 명령어입니다.

자주 쓰는 옵션: * -d: 백그라운드에서 조용히 실행합니다.

-p 외부포트:내부포트: 내 컴퓨터의 포트와 컨테이너의 포트를 연결합니다.

--name: 생성될 컨테이너에 원하는 이름을 붙여줍니다.

예시: docker run -d -p 8080:80 --name my-web-server nginx (nginx 이미지를 백그라운드에서 실행하고, 내 컴퓨터의 8080 포트로 접속하면 컨테이너의 80 포트로 연결하며, 이름은 'my-web-server'로 지정)

docker ps

설명: 현재 실행 중인 컨테이너들의 목록, 상태, 생성 시간 등을 보여줍니다.

팁: docker ps -a 옵션을 붙이면 현재 멈춰있는 컨테이너까지 포함한 모든 목록을 볼 수 있습니다.

docker stop [컨테이너 ID 또는 이름]

설명: 실행 중인 컨테이너를 안전하게 중지합니다. (컴퓨터 전원을 끄는 것과 비슷합니다.)

예시: docker stop my-web-server

docker rm [컨테이너 ID 또는 이름]

설명: 중지된 컨테이너를 내 컴퓨터에서 완전히 삭제합니다.

예시: docker rm my-web-server

3. 정리 명령어 (청소하기)
docker rmi [이미지 ID 또는 이름]

설명: 더 이상 사용하지 않는 도커 이미지를 삭제합니다. 단, 해당 이미지를 사용해서 만든 컨테이너가 하나라도 남아있다면 먼저 컨테이너를 삭제(docker rm)해야 이미지를 지울 수 있습니다.
