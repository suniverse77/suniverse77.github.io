---
title: "[LLM] Message Role"
date: 2026-04-27 00:00:00 +/-TTTT
categories: [Programming, Code]
tags: [LLM]
math: true
toc: true
author: sunho
---

우리가 LLM API를 호출할 때는 주로 아래와 같은 형식으로 데이터를 전달한다.
<br>
이는 원래 OpenAI의 Chat Completions API에서 사용하는 표준 포맷이지만, 현재는 거의 모든 LLM 생태계에서 사실상 표준으로 자리 잡은 구조다.

```python
{
    model: "", 
    messages=[
        {"role": "", "content": "..."}
    ]
}
```

- `model` : 사용할 LLM 모델의 이름 (예: `"gpt-4o"`, `"qwen/qwen3.5-27b"`)
- `message` : 모델과 주고받은 대화의 전체 context를 순서대로 담는 리스트
    
    - `role` : 메시지를 작성한 주체 (`system`, `user`, `assistant`, `tool`로 구분)
    - `content` : 해당 주체가 말한 실제 텍스트나 전달할 데이터

## system

`system`은 LLM의 페르소나, 어투, 그리고 대화 전반의 규칙을 정의하는 역할을 한다.

```python
{
    "role": "system", 
    "content": "당신은 파이토치와 딥러닝 전문가입니다. 초보자도 이해하기 쉽게 비유를 들어 설명하고, 항상 친절한 어투를 유지하세요."
}
```

## user

`user`는 사용자가 입력한 프롬프트를 전달하는 역할을 한다.

```python
{
    "role": "user", 
    "content": "파이토치에서 Tensor와 Numpy Array의 가장 큰 차이점이 뭐야?"
}
```

## assistant

`assistant`는 LLM이 생성한 응답을 기록하는 역할을 한다.
<br>
이 역할은 크게 두 가지 목적으로 쓰인다.

### 이전 대화 맥락 유지 (Multi-turn Conversation)

LLM API는 상태를 저장하지 않는 특성 때문에, 다음 질문을 던지면 이전 대화 내용을 전혀 기억하지 못한다.

따라서 사용자와 LLM이 꼬리를 무는 대화를 이어가려면, 과거에 LLM이 생성했던 답변과 사용자의 질문 리스트에 누적해서 매번 통째로 다시 보내줘야 한다.

```python
messages = [
    {"role": "user", "content": "파이토치 창시자가 누구야?"},
    # 아래의 assistant 역할이 없으면, 다음 질문의 '그 사람'이 누군지 모델은 알 수 없다.
    {"role": "assistant", "content": "파이토치(PyTorch)는 주로 Meta(구 Facebook)의 AI 연구팀인 FAIR에 속한 얀 르쿤(Yann LeCun), 수미스 친탈라(Soumith Chintala) 등에 의해 개발되었습니다."},
    {"role": "user", "content": "그 사람들이 만든 다른 프레임워크도 있어?"} 
]
```

이렇게 이전에 모델이 뱉어낸 결과물을 `assistant` 역할로 다시 입력해 주어야, LLM은 `"아, 내가 아까 얀 르쿤과 수미스 친탈라 이야기를 했지. 그럼 '그 사람들'은 이 두 명을 뜻하는구나"` 하고 문맥을 이해하게 된다.

### 모범 답안 예시 주입 (Few-shot Prompting)

LLM에게 system 역할로 "항상 JSON 형식으로 단답형으로 말해"라고 백 번 지시하는 것보다, 실제로 그렇게 대답했던 가짜 대화 기록을 보여주는 것이 LLM의 행동을 교정하는 데 훨씬 효과적이다.
<br>
이를 프롬프트 엔지니어링에서는 **Few-shot Prompting**이라고 부른다.

즉, 답변의 형식이나 퀄리티를 개발자가 원하는 대로 강제하기 위해, 진짜 사용자가 질문하기 전에 개발자가 임의로 `user`와 완벽한 정답을 말하는 `assistant` 쌍을 미리 만들어서 주입해 두는 것이다.

```python
messages = [
    {"role": "system", "content": "당신은 영단어 번역기입니다."},
    
    # 개발자가 미리 주입한 가짜 모범 답안 (Few-shot)
    {"role": "user", "content": "사과"},
    {"role": "assistant", "content": "{\"word\": \"Apple\"}"},
    {"role": "user", "content": "바나나"},
    {"role": "assistant", "content": "{\"word\": \"Banana\"}"},
    
    # 실제 사용자의 진짜 질문
    {"role": "user", "content": "포도"}
]
```

이렇게 LLM에게 이전 대화 기록을 넘겨주면, LLM은 `"나는 과거에 무조건 JSON 형태로 영단어만 출력했었구나. 그럼 이번 '포도'라는 질문에도 똑같은 패턴으로 {"word": "Grape"}라고 답변해야지."`라고 스스로 규칙을 깨닫고 답변을 생성하게 된다.

## tool

`tool`은 LLM이 웹 검색, 데이터베이스 조회 등 외부 프로그램을 실행한 후, <span style="background-color:#fff5b1">그 결과값을 다시 LLM에게 전달해 주는 역할</span>을 한다.
<br>
단순히 모델이 텍스트를 생성하는 것을 넘어, 실제 외부 환경과 데이터를 주고받으며 동작할 수 있게 연결해 주는 다리 역할을 한다.

<span style="color:red">`tool` 역할의 메시지는 단독으로 쓰이지 않고, 반드시 LLM (`assistant`)이 먼저 `"어떤 도구를 사용하겠다"`고 요청한 이후에 사용된다.</span>

`tool` 메시지 객체는 필수적으로 다음 세 가지 키를 가져야 한다.

- role: "tool"로 고정합니다. 이 메시지가 외부 도구의 실행 결과임을 명시합니다.
- tool_call_id: 매우 중요한 식별자입니다. 직전에 assistant가 도구를 호출할 때 발급했던 고유 ID 값(예: call_abc123xyz)을 그대로 넣어주어야 합니다. 모델이 동시에 여러 개의 도구를 호출했을 때, 이 결과값이 어떤 호출에 대한 답변인지 매칭해 주는 역할을 합니다.
- content: 외부 프로그램이나 함수를 실행하고 얻은 실제 결과값을 문자열(String) 형태로 담습니다. 주로 JSON 형식의 문자열이 많이 사용됩니다

```python
{
    "role": "tool", 
    "tool_call_id": "call_abc123xyz", # 어떤 도구 호출에 대한 결과인지 식별하는 ID
    "content": "{\"location\": \"Seoul\", \"temperature\": \"24°C\", \"weather\": \"Sunny\"}"
}
```

ool 메시지가 실제 대화 흐름에서 어떻게 위치하는지 보여주는 것이 좋습니다. tool 메시지는 보통 아래와 같은 4단계 사이클 속에서 등장합니다.

```python
messages = [
    # 1. 사용자의 질문
    {"role": "user", "content": "지금 서울 날씨 어때?"},
    
    # 2. 모델의 도구 호출 (LLM: "get_weather 함수를 실행해야겠다! ID는 call_123이야.")
    {
        "role": "assistant", 
        "content": None, 
        "tool_calls": [
            {
                "id": "call_123", 
                "type": "function", 
                "function": {"name": "get_weather", "arguments": "{\"location\": \"Seoul\"}"}
            }
        ]
    },
    
    # 3. 외부 도구 실행 결과 전달 (개발자/시스템: "call_123의 실행 결과는 이거야!")
    {
        "role": "tool", 
        "tool_call_id": "call_123", # 위의 ID와 반드시 일치해야 함
        "content": "{\"temperature\": 24, \"condition\": \"Sunny\"}"
    },
    
    # 4. 최종 답변 (LLM: 전달받은 결과를 바탕으로 자연스러운 문장 생성)
    {"role": "assistant", "content": "현재 서울의 날씨는 맑고 기온은 24도입니다."}
]
```

