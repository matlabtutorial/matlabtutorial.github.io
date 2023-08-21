---
title: (번역) MATLAB with Python
published: true
permalink: MATLAB_with_Python_Book.html
summary: "Yann Debray의 MATLAB With Python Book을 번역했습니다."
tags: [번역, MATLAB, Python]
identifier: MATLAB_with_Python_Book
sidebar: false
toc: true
ogimage: https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/ogimage.jpg
---

본 게시글의 원문은 Yann Debray의 [`MATLAB with Python Book`](https://github.com/yanndebray/matlab-with-python-book) 입니다. 해당 책은 MIT 라이센스를 따르기 때문에 개인적으로 번역하여 재배포 합니다. 본 포스팅에는 추후 유료 수익을 위한 광고가 부착될 수도 있습니다.

    MIT License

    Copyright (c) 2023 Yann Debray

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.

본 게시물에서 활용된 소스 코드들은 모두 [Yann Debray의 GitHub Repo](https://github.com/yanndebray/matlab-with-python-book)에서 확인할 수 있습니다.

# 1. 소개

매일 만나는 엔지니어와 과학자들은 MATLAB과 Python을 MATLAB **<u>v.s.</u>** Python으로 생각합니다. 이 책의 목표는 그들에게 MATLAB **<u>with</u>** Python으로 생각할 수 있다는 것을 증명하는 것입니다.

Python은 최근 [TIOBE 지수](https://www.tiobe.com/tiobe-index/)에 따르면 가장 많이 사용되는 프로그래밍 언어가 되었습니다. 이는 본질적으로 범용적이며, 스크립팅, 웹 개발 및 인공 지능 (머신 러닝 및 딥 러닝)에 특히 사용됩니다.

MATLAB은 대부분 기술 계산용 프로그래밍 언어로 인식되며, 엔지니어와 과학자를 위한 개발 환경입니다. 그러나 MATLAB은 또한 Python을 포함한 여러 프로그래밍 언어와 유연한 양방향 통합 기능을 제공합니다.

MATLAB은 일반적인 Python 배포와 함께 작동합니다. 이 책에서는 Python 3.10 (다운로드:[Python.org](https://www.python.org/downloads/))과 MATLAB 2023a를 사용할 것입니다.

## 1.1. 과학적 계산의 역사 요약

### 1.1.1. 수치 해석의 기원

1970년대에 Cleve Moler는 [EISPACK](https://en.wikipedia.org/wiki/EISPACK) (고유값 계산용) 및 [LINPACK](https://en.wikipedia.org/wiki/LINPACK) (선형 대수용)이라는 Fortran 라이브러리의 개발에 적극적으로 참여했습니다. 그는 뉴멕시코 대학의 수학 교수로서 학생들이 Fortran 래퍼 코드를 작성하고 컴파일하고 디버깅하고 다시 컴파일하고 실행하는 번거로움 없이 이러한 라이브러리에 접근할 수 있게 하고 싶었습니다.

그래서 그는 Fortran에서 행렬 연산을 위한 대화형 인터프리터인 MATLAB을 만들었습니다 (MATrix LABoratory의 약자로, Matrix 영화와는 아무 상관이 없습니다. 그 영화는 30년 후에 나왔습니다). 이 첫 번째 버전은 EISPACK과 LINPACK의 일부 루틴을 기반으로 하였으며 80개의 함수만 포함되어 있었습니다.

이 시절의 MATLAB 매뉴얼 사진은 초기 소프트웨어의 범위를 보여줍니다.

<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image2.png" />

당시에 MATLAB은 아직 프로그래밍 언어가 아니었습니다. 파일 확장자 (m-스크립트)도 없었고, 툴박스도 없었습니다. 유일하게 사용 가능한 데이터 타입은 행렬이었습니다. 그래픽 기능은 화면에 그려지는 별표(asterisks)였습니다 (Astérix The Gaul과는 무관합니다).

<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image3.gif" />

함수를 추가하려면 Fortran 소스 코드를 수정하고 모든 것을 다시 컴파일해야 했습니다. 따라서 소스 코드는 공개되었으며, 그렇게 해야 했습니다 (오픈 소스 개념은 80년대에 리처드 스톨만과 자유 소프트웨어 운동과 함께 나타났습니다).

칼리포니아의 스탠포드 대학에서 Cleve Moler가 수치 해석 강의를 한 후, MIT에서 훈련받은 엔지니어가 그에게 다가왔습니다. "나는 Cleve에게 자신을 소개했어요." 이것이 Jack Little이 그들의 첫 만남에 대한 이야기를 전하는 방식입니다. Jack Little은 MATLAB이 PC에서 사용될 수 있는 가능성을 미리 예측하고 C로 재작성했습니다. 그는 Steve Jobs와 Bill Gates와 같이 개인용 컴퓨팅이 IBM의 메인프레임 서버 비즈니스를 이길 것이라는 것을 알고 있었습니다. 또한 소프트웨어 기능을 확장하기 위해 프로그램 파일을 작성하는 기능과, 잘 구조화되고 모듈식이며 확장 가능한 비즈니스 모델이 될 툴박스를 추가했습니다. 1984년, 그는 (The) MathWorks라는 회사를 설립하여 MATLAB을 상업화했습니다.

**MATLAB의 기원에 대해 더 읽어보세요:**

-   A history of MATLAB – 20202년 6월에 발표된 기사 -
    <https://dl.acm.org/doi/10.1145/3386331>

-   The Origins of MATLAB
    <https://www.mathworks.com/company/newsletters/articles/the-origins-of-matlab.html>

-   Cleve's Corner – ACM에서 발행한 MATLAB의 역사
    <https://blogs.mathworks.com/cleve/2020/06/13/history-of-matlab-published-by-the-acm/?doing_wp_cron=1642533843.1107759475708007812500>

### 1.1.2. 평행 우주에서

1980년대에, Guido van Rossum은 [Centrum Wiskunde & Informatica](https://en.wikipedia.org/wiki/Centrum_Wiskunde_%26_Informatica) (줄여서 **CWI**; 영어: "수학과 컴퓨터 과학 국립 연구소")에서 ABC라는 언어에 관련된 작업을 하고 있었습니다.

"ABC는 컴퓨터 프로그래머나 소프트웨어 개발자가 아닌 지능 있는 컴퓨터 사용자들을 위해 가르칠 수 있는 프로그래밍 언어로서 개발되었습니다. 1970년대 후반에 ABC의 주요 설계자들은 이와 같은 대상을 위해 전통적인 프로그래밍 언어를 가르쳤습니다. 그 학생들에는 물리학자부터 사회과학자, 언어학자에 이르기까지 다양한 과학자들이 포함되어 있었는데, 이들은 매우 큰 컴퓨터를 사용하는 데 도움이 필요했습니다. 그들은 자신들만의 지식을 가진 똑똑한 사람들이었지만, 프로그래밍 언어가 전통적으로 정의한 특정한 제한, 제약 및 임의의 규칙에 놀랐습니다. 이러한 사용자 피드백을 바탕으로 ABC의 설계자들은 다른 언어를 개발하려고 노력했습니다."

1986년에 Guido van Rossum은 CWI에서 다른 프로젝트인 Amoeba 프로젝트로 옮겼습니다. Amoeba는 분산 운영 체제였습니다. 1980년대 후반에, 그들은 스크립팅 언어가 필요하다는 것을 깨달았습니다. 이 프로젝트 내에서 주어진 자유로운 환경을 통해 Guido van Rossum은 자신의 "미니 프로젝트"를 시작했습니다.

1989년 12월, Van Rossum은 "크리스마스 주변에 시간을 보내기 위한 '취미' 프로그래밍 프로젝트가 필요했고, 최근에 생각하고 있었던 '새로운 스크립팅 언어: ABC의 계승 자손으로서 Unix/C 해커들에게 호소할 것 같은'" 인터프리터를 작성하기로 결정했습니다. 그는 "Python"이라는 이름을 선택한 이유를 "약간 불손한 기분(그리고 Monty Python's Flying Circus의 큰 팬이었기 때문)"으로 설명합니다.
[(“Programming Python” Guido van Rossum, 1996 서문)](https://www.python.org/doc/essays/foreword/)

그는 간단한 가상 머신, 간단한 파서 및 간단한 런타임을 작성했습니다. 그는 기본 구문을 만들었는데, 문장 그룹화에 들여쓰기를 사용했습니다. 그리고 몇 가지 데이터 타입을 개발했습니다: 딕셔너리, 리스트, 문자열 및 숫자. 이로써 Python이 탄생하게 되었습니다.

**Guido의 의견에 따르면, Python의 성공에 대한 가장 혁신적인 기여는 확장하기 쉽도록 만든 것이었습니다.**

**Python 언어의 주요 이정표:**
- 1991년: Guido Van Rossum에 의해 alt.sources에 Python 0.9.0이 게시됨
- 1994년: Python 1.0. 람다 함수의 맵, 필터, 리듀스와 같은 함수형 프로그래밍을 포함
- 2000년: Python 2.0. 리스트 컴프리헨션과 가비지 컬렉션을 도입
- 2008년: Python 3. 기본적인 디자인 결함을 수정하고 하위 호환성이 없음
- 2022년: Python 2의 지원 종료, 최종 버전 2.7.18이 출시됨

**Python에 대해 더 읽어보세요:**

- Python의 탄생 - Guido van Rossum과의 대화, Part I  
  <https://www.artima.com/articles/the-making-of-python>

- Microsoft Q&A with Guido van Rossum, Python 창시자  
  <https://www.youtube.com/watch?v=aYbNh3NS7jA>

- Python 창시자 Guido van Rossum에 의한 Python 이야기  
  <https://www.youtube.com/watch?v=J0Aq44Pze-w>

- Python 역사 타임라인 인포그래픽  
  <https://python.land/python-tutorial/python-history>

## 1.2. 저자 소개

제 이름은 Yann Debray이며, 저는 MATLAB Product Manager로서 MathWorks에서 일하고 있습니다. 아마도 저는 MATLAB을 판매하려고 하는 편견이 있다고 생각하실 것입니다. 그게 틀린 말은 아닙니다. 하지만 제 동기를 더 잘 이해하려면 제 배경을 조금 더 깊게 살펴보아야 합니다.

저는 2020년 6월에 MathWorks에 합류했습니다(코로나-19 팬데믹 중에). 그 전에는 [Scilab](https://scilab.org/)이라는 프로젝트에서 6년 동안 일했습니다. Scilab은 MATLAB의 오픈 소스 대안입니다. 이 경험은 제 오픈 소스와 과학적 컴퓨팅에 대한 열망을 나타냅니다.

저의 첫 번째 수치 계산 체험은 2013년 12월에 이루어졌습니다. 그때 [Claude Gomez](https://www.d-booker.fr/content/81-interview-with-claude-gomez-ceo-of-scilab-enterprises-about-scilab-and-its-development)와 처음 만났습니다. 그는 당시 Scilab Enterprises의 CEO였으며, Scilab을 연구 프로젝트에서 회사로 바꾼 주인공입니다. 비즈니스 모델은 리눅스 주변에서 서비스를 판매하는 Red Hat에서 영감을 얻었습니다.

저는 과학적 컴퓨팅에서 오픈 소스를 지속 가능한 모델로 만드는 도전을 아주 잘 알고 있습니다. 그래서 오픈 소스와 프로프라이어터리 소프트웨어 사이에서 균형을 믿습니다. 모든 소프트웨어가 무료일 수 없습니다. 시뮬레이션과 같은 분야에서 요구되는 전문지식 - 수십 년의 투자가 필요한 분야 - 우리는 여전히 지적 재산에 의해 주도되는 엔지니어링 소프트웨어 시장 전체를 관찰할 것입니다.

## 1.3. 오픈 소스 vs 상용

이 책에 대한 초기 질문 중 하나는 다음과 같았습니다:

*이것을 상용화할까요, 아니면 오픈 소스로 만들까요?*

나는 책을 쓰는 것이 무엇을 의미하는지에 대한 이상적인 시각을 가지고 있었습니다. 명성과 화려함. 하지만 실제로는 이것이 상당히 특수한 분야라서 많이 팔릴 것 같지 않다는 것을 알고 있습니다. 내가 예상한 타겟 독자는 MATLAB의 500만 사용자 중에 약 30%로, Python에도 관심이 있는 사람들입니다.

내 오픈 소스에 대한 이상주의를 넘어, 이 프로젝트를 끝까지 이끌기 위해 구체적인 동기가 필요하다고 느꼈습니다. 그래서 이 책의 인쇄본을 판매하는 초기 아이디어를 가졌습니다. 하지만 제 친애하는 동료이자 친구인 Mike Croucher가 "죽은 나무"라고 부르는 것에 대해 나에게 충고했습니다. 이는 인쇄된 내용이 MATLAB의 새 버전마다 빠르게 구식화될 것임을 암시한 것입니다(매년 두 번의 업데이트가 있습니다).

마지막으로, 콘텐츠를 오픈 소스화하더라도 유료 버전을 출시하는 것과 충돌하지 않는다고 결정했습니다. 사실, 내가 기술 서적을 구매할 때는 오픈 소스 라이선스를 적용한 것들을 자주 선택합니다.

## 1.4. 이 책은 누구를 위한 것인가요?

다음 시나리오에서 본인의 모습이 보인다면, 이 책은 여러분을 위한 것입니다:

여러분은 MATLAB을 사용하는 엔지니어 또는 연구원이며, Python에 대한 언급을 점점 더 듣고 있습니다. 특히 데이터 과학 및 인공 지능과 관련된 주제에서 이런 얘기가 나옵니다. 온라인에서 코드를 검색할 때 Python으로 작성된 흥미로운 스크립트나 패키지를 우연히 발견할 수도 있습니다. 또는 Python을 사용하는 동료와 함께 작업할 때, 그들의 작업을 통합하는 방법을 찾고 있을 수 있습니다:

<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image5.png" />

여러분은 (또는 데이터 과학자가 되고 싶으신 분이라면) 데이터 과학자이며, 과학 및 공학 데이터(무선 통신, 오디오, 비디오, 레이더/라이다, 자율 주행 등)에 작업 중입니다. 데이터 처리와 관련된 일상 작업 중 일부를 위해 Python을 사용할 가능성이 높지만, 인공 지능 워크플로의 엔지니어링 부분에서는 MATLAB을 고려해볼 수 있습니다(특히 이 인공 지능이 임베디드 시스템에 통합될 경우). 이 부분이 엔지니어 동료에 의해 다루어진다면, 그들이 여러분과 공유하는 모델 및 스크립트를 실행할 수 있는 능력만 갖추고 싶을 수도 있습니다:

<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image6.png" />

# 2. MATLAB 및 Python으로의 종합 프로젝트

MathWorks에 합류한 후 Heather를 만났습니다. 그녀는 MATLAB을 Python과 함께 사용하는 방법을 설명하는 매우 좋은 데모를 개발했습니다. 이 첫 번째 장에서는 그녀가 개발한 **Weather Forecasting 앱**을 보여드릴 것입니다. 그녀의 GitHub 저장소에서 코드를 찾아볼 수 있습니다: [https://github.com/hgorr/weather-matlab-python](https://github.com/hgorr/weather-matlab-python)

먼저 코드를 검색하려면 zip 파일을 다운로드하거나 리포지토리를 복제합니다:

```matlab
!git clone https://github.com/hgorr/weather-matlab-python
cd weather-matlab-python\
```

결과적으로 생성된 응용 프로그램은 다음과 같이 보일 것입니다:

<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image8.png" alt="Chart, line chart" />

우리는 다음과 같은 단계로 작업할 것입니다:


   1. Heather의 Python 코드를 호출하여 날씨 데이터를 가져옵니다.
   1. 공기 품질을 예측하는 MATLAB 모델을 통합합니다.
   1. MATLAB + Python으로 이루어진 결과 응용 프로그램을 배포합니다.


이 예제에서는 [openweathermap.org](https://openweathermap.org/)의 웹 서비스에서 데이터를 사용합니다.

이 실시간 데이터에 액세스하려면 먼저 [등록](https://home.openweathermap.org/users/sign_up)해야 합니다. 무료 계층을 제공하며 API 키를 생성할 수 있습니다: <https://home.openweathermap.org/api_keys>

<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image10.png" alt="website" />

이 키는 웹 서비스의 각 호출에 필요합니다. 예를 들어, [현재 날씨](https://openweathermap.org/current)를 요청하려면 다음 주소를 호출하면 됩니다:

`api.openweathermap.org/data/2.5/weather?q={도시 이름}\&appid=`[`{API 키}`](https://home.openweathermap.org/api_keys)

API 키를 [accessKey.txt](https://home.openweathermap.org/api_keys)라는 텍스트 파일에 저장하세요.

```matlab
% apikey = fileread("accessKey.txt");
```

대안으로 이 스크립트에서 보여주는 샘플 API 키를 사용할 수도 있습니다.

```matlab
appid ='b1b15e88fa797225412429c1c50c122a1';
```

# 2.1. 파이썬을 MATLAB에서 호출하기

Heather는 [weather.py](https://github.com/hgorr/weather-matlab-python/blob/main/weather.py)라는 모듈을 만들었습니다. 이 모듈은 웹 서비스에서 데이터를 읽고 반환된 JSON 데이터를 구문 분석합니다. 물론 MATLAB에서도 이 작업을 수행할 수 있지만, 데이터에 접근하는 예제로 이 모듈을 사용해보겠습니다.

## 2.1.1. 파이썬 설치 확인

먼저 [pyenv](https://www.mathworks.com/help/matlab/ref/pyenv.html) 명령을 사용하여 Python 환경에 연결합니다. MATLAB 및 Python 설정에 대한 자세한 내용은 다음 장을 참조하십시오. MATLAB은 기본 Python, 설치한 패키지 및 사용자 고유의 Python 코드에서 파이썬 함수를 호출하고 파이썬 개체를 생성할 수 있습니다.

```matlab
pyenv % MATLAB 버전 R2019b 이전에는 pyversion을 사용하세요.
```

```text:Output
ans = 
  PythonEnvironment with properties:

          Version: "3.10"
       Executable: "C:\Users\ydebray\AppData\Local\WPy64-31040\python-3.10.4.amd64\python.exe"
          Library: "C:\Users\ydebray\AppData\Local\WPy64-31040\python-3.10.4.amd64\python310.dll"
             Home: "C:\Users\ydebray\AppData\Local\WPy64-31040\python-3.10.4.amd64"
           Status: NotLoaded
    ExecutionMode: OutOfProcess

```

## 2.1.2. 파이썬 사용자 정의 함수 MATLAB에서 호출하기

이제 동료의 날씨 모듈을 어떻게 사용하는지 알아보겠습니다. 먼저 오늘 날짜의 데이터를 가져오겠습니다. 날씨 모듈의 [get_current_weather](https://github.com/hgorr/weather-matlab-python/blob/c8985b96b4c4a64b283573a5276d25f33f311bcc/weather.py#L16) 함수는 Json 형식으로 현재 날씨 상황을 가져옵니다. 그런 다음 [parse_current_json](https://github.com/hgorr/weather-matlab-python/blob/c8985b96b4c4a64b283573a5276d25f33f311bcc/weather.py#L42) 함수는 이 데이터를 파이썬 딕셔너리 형식으로 반환합니다.

```matlab
jsonData = py.weather.get_current_weather("London","UK",appid,api='samples')
```

```text:Output
jsonData = 
  Python dict with no properties.

    {'coord': {'lon': -0.13, 'lat': 51.51}, 'weather': [{'id': 300, 'main': 'Drizzle', 'description': 'light intensity drizzle', 'icon': '09d'}], 'base': 'stations', 'main': {'temp': 280.32, 'pressure': 1012, 'humidity': 81, 'temp_min': 279.15, 'temp_max': 281.15}, 'visibility': 10000, 'wind': {'speed': 4.1, 'deg': 80}, 'clouds': {'all': 90}, 'dt': 1485789600, 'sys': {'type': 1, 'id': 5091, 'message': 0.0103, 'country': 'GB', 'sunrise': 1485762037, 'sunset': 1485794875}, 'id': 2643743, 'name': 'London', 'cod': 200}

```

```matlab
weatherData = py.weather.parse_current_json(jsonData)
```

```text:Output
weatherData = 
  Python dict with no properties.

    {'temp': 280.32, 'pressure': 1012, 'humidity': 81, 'temp_min': 279.15, 'temp_max': 281.15, 'speed': 4.1, 'deg': 80, 'lon': -0.13, 'lat': 51.51, 'city': 'London', 'current_time': '2023-03-15 16:04:38.427888'}

```

## 2.1.3. 파이썬 데이터를 MATLAB 데이터로 변환하기

이제 [Python 딕셔너리](https://docs.python.org/3/tutorial/datastructures.html#dictionaries)를 [MATLAB 구조체](https://www.mathworks.com/help/matlab/ref/struct.html)로 변환해보겠습니다.

```matlab
data = struct(weatherData)
```

```text:Output
data = 
            temp: 280.3200
        pressure: [1x1 py.int]
        humidity: [1x1 py.int]
        temp_min: 279.1500
        temp_max: 281.1500
           speed: 4.1000
             deg: [1x1 py.int]
             lon: -0.1300
             lat: 51.5100
            city: [1x6 py.str]
    current_time: [1x26 py.str]

```

대부분의 데이터는 자동으로 변환됩니다. 몇 가지 필드만이 명확한 동등한 항목을 찾지 못했습니다.

   -  `pressure`와 `humidity`는 MATLAB에서 `py.int` 객체로 남습니다.
   -  `city`와 `current_time`은 MATLAB에서 `py.str` 객체로 남습니다.

우리는 [double](https://www.mathworks.com/help/matlab/ref/double.html), [string](https://www.mathworks.com/help/matlab/characters-and-strings.html) 및 [datetime](https://www.mathworks.com/help/matlab/date-and-time-operations.html)과 같은 표준 MATLAB 함수를 사용하여 명시적으로 변환할 수 있습니다.

```matlab
data.pressure = double(data.pressure);
data.humidity = double(data.humidity);
data.deg = double(data.deg);
data.city = string(data.city);
data.current_time = datetime(string(data.current_time))
```

```text:Output
data = 
            temp: 280.3200
        pressure: 1012
        humidity: 81
        temp_min: 279.1500
        temp_max: 281.1500
           speed: 4.1000
             deg: 80
             lon: -0.1300
             lat: 51.5100
            city: "London"
    current_time: 15-Mar-2023 16:04:38

```

## 2.1.4. 파이썬 리스트를 MATLAB 행렬로 변환하기

이제 [get_forecast](https://github.com/hgorr/weather-matlab-python/blob/c8985b96b4c4a64b283573a5276d25f33f311bcc/weather.py#L67) 함수를 호출해보겠습니다. 이 함수는 다음 몇 일 동안 예측된 날씨 조건 시리즈를 반환합니다. 구조체의 필드는 [Python 리스트](https://docs.python.org/3/tutorial/datastructures.html#more-on-lists)로 반환됩니다.

```matlab
jsonData = py.weather.get_forecast('Muenchen','DE',appid,api='samples');
forecastData = py.weather.parse_forecast_json(jsonData);  
forecast = struct(forecastData)
```

```text:Output
forecast = 
    current_time: [1x36 py.list]
            temp: [1x36 py.list]
             deg: [1x36 py.list]
           speed: [1x36 py.list]
        humidity: [1x36 py.list]
        pressure: [1x36 py.list]

```

숫자 데이터만 포함하는 리스트는 double 형식으로 변환될 수 있습니다 (MATLAB R2022a부터):

```matlab
forecast.temp = double(forecast.temp) - 273.15; % from Kelvin to Celsius
forecast.temp
```

```text:Output
ans = 1x36    
   13.5200   12.5100    3.9000   -0.3700    0.1910    2.4180    3.3280    3.5200    5.1030    3.3050    2.4890    2.3090    1.8850    1.8150    1.4120    2.4980    4.7770    5.2170    0.6470   -1.9110   -3.5970   -4.9520   -5.8550   -0.1940    4.2720    4.8340   -0.6910   -3.6770   -4.3570   -5.0440   -5.4950    0.6000    6.1520    6.1930    1.2930   -0.7260

```

텍스트를 포함하는 리스트는 문자열로 변환되며, datetime과 같은 특정 데이터 유형으로 더 처리될 수 있습니다.

```matlab
forecast.current_time = string(forecast.current_time);
forecast.current_time = datetime(forecast.current_time);
forecast.current_time
```

```text:Output
ans = 1x36 datetime    
16-Feb-2017 12:00:0016-Feb-2017 15:00:0016-Feb-2017 18:00:0016-Feb-2017 21:00:0017-Feb-2017 00:00:0017-Feb-2017 03:00:0017-Feb-2017 06:00:0017-Feb-2017 09:00:0017-Feb-2017 12:00:0017-Feb-2017 15:00:0017-Feb-2017 18:00:0017-Feb-2017 21:00:0018-Feb-2017 00:00:0018-Feb-2017 03:00:0018-Feb-2017 06:00:0018-Feb-2017 09:00:0018-Feb-2017 12:00:0018-Feb-2017 15:00:0018-Feb-2017 18:00:0018-Feb-2017 21:00:0019-Feb-2017 00:00:0019-Feb-2017 03:00:0019-Feb-2017 06:00:0019-Feb-2017 09:00:0019-Feb-2017 12:00:0019-Feb-2017 15:00:0019-Feb-2017 18:00:0019-Feb-2017 21:00:0020-Feb-2017 00:00:0020-Feb-2017 03:00:00

```

Section 4.7에서 파이썬과 MATLAB 간의 데이터 변환에 대해 더 자세하게 확인할 수 있습니다.

## 2.1.5. Python 데이터를 가져와 MATLAB에서 그래프로 탐색하기

```matlab
plot(forecast.current_time,forecast.temp)
xtickangle(45)
xlabel('Date')
ylabel('Temperature')
```


<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image11.png" alt="차트, 라인 차트" />

## 2.1.6. MATLAB에서 머신 러닝 모델 호출하기

이제 우리가 일부 역사적 데이터를 사용하여 날씨 조건 세트를 가져와 대기 질을 예측하는 머신 러닝 모델을 만들었다고 가정해 봅시다. 제 Python 동료는 Python 코드에서 내 모델을 사용하고 싶어합니다.


먼저 대기 질 예측이 어떻게 작동하는지 살펴보겠습니다. 세 가지 단계가 있습니다.


   - .mat 파일에서 모델 로드
   - openweathermap.org의 현재 날씨 데이터를 모델이 예상하는 형식으로 변환
   - 모델의 predict 메서드를 호출하여 그 날의 예상 대기 질을 가져옵니다.

```matlab
load airQualModel.mat model
testData = prepData(data);
airQuality = predict(model,testData)
```

```text:Output
airQuality = 
     Good
```
제 동료에게 이를 전달하기 위해 이러한 단계를 하나의 함수인 [predictAirQuality](https://github.com/hgorr/weather-matlab-python/blob/main/predictAirQual.m)로 묶어보겠습니다:

```matlab
function airQual = predictAirQual(data)
% PREDICTAIRQUAL: 머신 러닝 모델을 기반으로 대기 질을 예측합니다.
%
%#function CompactClassificationEnsemble

% 데이터 유형 변환  
currentData = prepData(data);

% 모델 로드
mdl = load("airQualModel.mat");
model = mdl.model;

% 대기 질 결정
airQual = predict(model,currentData);

% Python에서 사용하기 위한 데이터 유형 변환
airQual = char(airQual);

end
```

이 함수는 위에서 설명한 것과 같은 세 가지 단계를 수행합니다. 모델을 로드하고 데이터를 변환하며 모델의 예측 메서드를 호출합니다.  

하지만 한 가지 더 해야 할 일이 있습니다. 모델은 MATLAB 범주 값을 반환하는데, 이는 Python에서 직접적인 등가물이 없기 때문에 문자 배열로 변환합니다.

이제 우리는 대기 질 예측 모델을 사용하는 MATLAB 함수를 가졌으므로, Python에서 이를 어떻게 사용하는지 살펴보겠습니다.

## 2.2. Python에서 MATLAB 호출하기

이제 주피터 노트북을 사용하여 Python에서 MATLAB을 호출하는 방법을 보여드리겠습니다.

첫 번째 단계는 엔진 API를 사용하여 Python과 통신할 MATLAB을 백그라운드에서 실행하는 것입니다. (이미 설치했다고 가정하겠습니다 - 그렇지 않으면 [3.8 섹션](3_Set-up_MATLAB_and_Python.md)을 확인하세요).

```python
>>> import matlab.engine
>>> m = matlab.engine.start_matlab()
```

MATLAB이 실행되면 경로에 있는 모든 MATLAB 함수를 호출할 수 있습니다.

```python
>>> m.sqrt(42.0)
6.48074069840786
```

텍스트 파일에서 키에 액세스해야 합니다.

```python
>>> with open("accessKey.txt") as f:
...   apikey = f.read()
```

이제 MATLAB의 get_current_weather 및 parse_current_json 함수를 MATLAB에서와 마찬가지로 사용하여 현재 날씨 조건을 가져올 수 있습니다.

```python
>>> import weather
>>> json_data = weather.get_current_weather("Boston","US",apikey)
>>> data = weather.parse_current_json(json_data)
>>> data
{'temp': 62.64, 'feels_like': 61.9, 'temp_min': 58.57, 'temp_max': 65.08, 'pressure': 1018, 'humidity': 70, 'speed': 15.01, 'deg': 335, 'gust': 32.01, 'lon': -71.0598, 'lat': 42.3584, 'city': 'Boston', 'current_time': '2022-05-23 11:28:54.833306'}
```

그런 다음 MATLAB 함수 predictAirQuality를 호출하여 예측 결과를 얻을 수 있습니다.

```python
>>> aq = m.predictAirQuality(data)
>>> aq
Good
```

마지막 단계는 노트북 시작 시 엔진 API에 의해 시작된 MATLAB을 종료하는 것입니다.

```python
>>> m.exit()
```

그러나 Python 동료가 MATLAB에 액세스할 수 없을 수도 있습니다. 다음 두 섹션은 이러한 사용 사례를 대상으로 합니다.

## 2.3. MATLAB 함수 세트에서 Python 패키지 생성하기

이를 위해서는 [MATLAB Compiler SDK](https://www.mathworks.com/help/compiler_sdk/)라는 전용 툴박스를 사용해야 합니다. 앱 리본에서 라이브러리 컴파일러를 선택하거나 명령 창에 `libraryCompiler`를 입력할 수 있습니다:

<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image17.png" alt="Graphical user interface Library Compiler" />

원하는 MATLAB 함수를 선택하여 이를 Python 함수로 변환할 수 있습니다. 의존성은 자동으로 Python 패키지에 추가됩니다(이 경우, 대기질 모델, 도시 목록 및 전처리 함수).

이렇게 하면 필요한 파일을 패키징하고 Python 단계에 대한 지침을 포함한 *setup.py* 및 *readme.txt* 파일이 생성됩니다. 생성된 패키지의 설정에 대한 자세한 내용은 [6.1절](#set-up-of-the-generated-python-package)을 참조하십시오.

그런 다음 패키지를 가져오고 초기화한 다음 다음과 같이 함수를 호출할 수 있습니다:

```python
>>> import AirQual
>>> aq = AirQual.initialize()
>>> result = aq.predictAirQual()
```

작업을 마친 후 프로세스를 종료하여 마무리할 수 있습니다:

```python
>>> aq.terminate()
```

더 나아가 MATLAB 기능을 웹 서비스로 공유하여 동시에 여러 사용자가 액세스할 수 있는 기능을 구현할 수 있습니다. 이 경우 [MATLAB Production Server](https://www.mathworks.com/help/mps/index.html)를 사용하여 로드 밸런싱을 할 수 있으며 MATLAB 코드는 [RESTful API](https://www.mathworks.com/help/mps/restful-api-and-json.html) 또는 [Python 클라이언트](https://www.mathworks.com/help/mps/python/create-a-matlab-production-server-python-client.html)를 통해 액세스할 수 있습니다.

# 3. MATLAB 및 Python 설치

## 3.1. Python 설치

간단하게 [www.python.org/downloads](https://www.python.org/downloads/)에 접속하여 [MATLAB 버전과 호환되는 Python 버전](https://www.mathworks.com/support/requirements/python-compatibility.html)을 선택하십시오.

예를 들어, 최신 릴리스와 호환되는 버전은 다음과 같습니다:

| MATLAB 버전 | 호환되는 Python 2 버전 | 호환되는 Python 3 버전 |
|----------------|---------------------------------|---------------------------------|
| R2023a         | 2.7                             | 3.9, 3.10                       |
| R2022b         | 2.7                             | 3.8, 3.9, 3.10                  |
| R2022a         | 2.7                             | 3.8, 3.9                        |
| R2021b         | 2.7                             | 3.7, 3.8, 3.9                   |

### 3.1.1. Windows에서 Python 설치

Windows를 사용 중이라면, 다음 단계에 따라 Python을 설치할 수 있습니다:

1. Python 웹사이트에서 [Windows 설치 프로그램 (64비트)](https://www.python.org/ftp/python/3.10.10/python-3.10.10-amd64.exe)을 다운로드합니다.
2. 다운로드한 실행 파일 `python-3.10.10-amd64.exe`을 실행합니다.

설치 중에 "Add python.exe to PATH"이라는 체크박스가 표시됩니다. 시스템의 PATH 환경 변수에 Python을 추가하는 것이 좋습니다. 이렇게 하면 명령 프롬프트나 다른 개발 환경에서 Python을 더 쉽게 실행할 수 있습니다.

원하는 옵션을 선택한 후 "Install Now"를 클릭하여 설치 프로세스를 시작하십시오. 몇 분 안에 설치가 완료될 것입니다.

이로써 Windows 기기에 Python이 설치되며 명령 프롬프트나 다른 개발 환경에서 사용할 수 있게 됩니다.

다음 애플리케이션이 설치되어 시작 메뉴에서 접근 가능합니다:

<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image22.png" />

Python이 설치되어 PATH에 접근 가능한지 확인하려면 명령 프롬프트를 엽니다:

```
C:\Users\ydebray>where python
C:\Users\ydebray\AppData\Local\Programs\Python\Python310\python.exe
C:\Users\ydebray\AppData\Local\Microsoft\WindowsApps\python.exe
```

여러 버전의 Python이 설치된 경우, PATH에 나열된 순서대로 각각의 버전이 표시되며 실제로 설치되지 않은 마지막 버전도 표시됩니다:

```
C:\Users\ydebray\AppData\Local\Microsoft\WindowsApps\python.exe
```

이것은 Microsoft Store에서 패키지화된 버전으로의 링크입니다. 실행하면 스토어로 리디렉션됩니다.

<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image23.png" />

## 3.2. Anaconda나 다른 파이썬 배포판 설치

이전 버전을 설치했다면 기본적인 파이썬 언어만 있을 것입니다. 수치 패키지나 개발 환경은 설치되지 않았을 것입니다 (MATLAB는 모든 이러한 기능을 기본적으로 제공합니다). 미리 설치된 정제된 데이터 과학 패키지 세트를 얻으려면 Anaconda와 같은 배포판을 다운로드할 수 있습니다:

<u>2020년 9월부터는 [Anaconda의 이용 약관](https://www.anaconda.com/terms-of-service)을 준수해야 함에 유의하십시오: 무료로 개인적으로 오픈 소스 [Anaconda 배포판](https://www.anaconda.com/products/individual)을 사용하는 것은 조직원 수가 200명을 초과하지 않는 경우에만 가능합니다. 그렇지 않으면 [Anaconda Professional](https://www.anaconda.com/products/professional) 라이선스를 구매해야 합니다.</u>

다른 배포판으로 Anaconda 대안을 찾고 있다면 Windows에서는 [WinPython](https://winpython.github.io/)을 추천합니다. 리눅스에서 작동 중이라면 배포판이 필요하지 않을 것으로 생각되며 패키지를 직접 관리할 수 있습니다.

### 3.2.1. conda-forge에서 Miniconda 설치

[Conda-forge](https://conda-forge.org/)는 [conda 패키지 관리자의 설치 파일](https://github.com/conda-forge/miniforge)를 제공합니다. 기본적으로 커뮤니티 채널을 가리키며, 상업적인 활동에 대해서도 Anaconda 저장소의 이용 약관을 준수하기 위해 사용합니다.

Miniconda 설치 파일(55MB)을 다운로드하고 실행합니다:

<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image24.png" />

### 3.2.2. 최소한의 공간을 차지하는 Micromamba 설치

[micromamba](https://mamba.readthedocs.io/)는 conda 패키지 관리자의 4MB 순수 C++ 대체품입니다. pip나 conda와 달리 이는 파이썬으로 작성되지 않았기 때문에 별도의 파이썬 설치가 필요하지 않으며 파이썬을 가져올 수 있습니다:

리눅스에서:

```
curl micro.mamba.pm/install.sh | bash
```

```
(base) $ mamba install python
```

<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image24b.png" />

## 3.3. PATH 관리

여러 버전의 파이썬이 설치된 경우, 명령어 `python`은 PATH 내에서 상위에 있는 버전을 반환합니다. 기본적으로 사용되는 파이썬 버전을 확인하려면:

```
C:\Users\ydebray>python --version
Python 3.10.10
```

이를 변경하려면 [PATH](https://en.wikipedia.org/wiki/PATH_(variable))를 수정해야 합니다.

<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image25.png" />

PATH는 **환경 변수**에서 편집할 수 있으며, Windows 시작 메뉴의 검색 창에 "path"를 입력하여 찾을 수 있습니다. 사용자 변수 내의 Path를 선택합니다 (이는 시스템 변수 위에 작성되어 있을 것입니다):

<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image26.png" />
<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image27.png" />

파이썬 버전의 나열 순서를 PATH에서 수정할 수 있습니다. 또한 파이썬의 기본 패키지 관리자인 pip에 액세스하려면 Script 폴더도 PATH에 포함되어 있는지 확인하세요: `C:\Users\ydebray\AppData\Local\Programs\Python\Python310\Scripts`

<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image28.png" />

## 3.4. 추가 파이썬 패키지 설치

[Python Package Index](https://pypi.org/)에서 추가 패키지를 검색하려면 pip 명령을 사용하십시오:
```
C:\Users\ydebray>pip install pandas
```
이렇게 하면 유명한 [pandas](https://pandas.pydata.org) 패키지가 설치됩니다. 또한 자동으로 의존성을 검색합니다 (이 경우 numpy, python-dateutil, pytz).

패키지가 설치되었는지 확인하려면 pip show 명령을 사용할 수 있습니다. 이것은 해당 패키지에 대한 정보를 표시합니다:

```
C:\Users\ydebray>pip show pandas
Name: pandas
Version: 1.3.3
Summary: Powerful data structures for data analysis, time series, and
statistics
Home-page: https://pandas.pydata.org
Author: The Pandas Development Team
Author-email: pandas-dev@python.org
License: BSD-3-Clause
Location:
c:\users\ydebray\appdata\local\programs\python\python39\lib\site-packages
Requires: numpy, python-dateutil, pytz
Required-by: streamlit, altair
```

이전에 설치한 패키지를 새 버전으로 업그레이드하려면 다음과 같이 하면 됩니다:

```
C:\Users\ydebray>pip install --upgrade pandas
```

## 3.5. Python 가상 환경 설정하기

만약 서로 다른 프로젝트가 동일한 패키지의 다른 버전을 사용하거나 생산 환경을 깨끗한 공간에서 재현하고 싶다면 [Python 가상 환경](https://docs.python.org/3/tutorial/venv.html)을 사용하세요. 이것은 언어 수준에서의 가상화 방법입니다 (기계 수준에서의 가상 머신이나 운영 체제 수준의 Docker 컨테이너와 비슷한 역할을 합니다). 다음은 `env`라는 이름의 가상 환경을 만드는 기본 방법입니다:

```
C:\Users\ydebray>python -m venv env
```

그런 다음 아래와 같이 활성화해야 합니다.

- Windows에서:

```
C:\Users\ydebray>.\env\Scripts\activate
```

- Linux에서:
  
```
$ source env/bin/activate
```

이렇게 하면 원하는 라이브러리를 설치할 수 있습니다. 예를 들어 요구 사항 목록에서 설치하려면:

```
C:\Users\ydebray>pip install -r requirements.txt
```

## 3.6. Python 개발 환경 설정하기

Python과 과학 계산을 위한 관련 패키지를 설치한 후에도 MATLAB 통합 개발 환경 (IDE)와 같은 경험을 제공하지는 않습니다.

두 가지 핵심 오픈 소스 기술이 기술 계산 환경을 재정의하는 데 기여하고 있습니다:

-   Jupyter 노트북
-   Visual Studio Code

이들은 *언어*와 *개발 환경* 간의 상호 작용 방식을 재정의하고 있습니다. Jupyter로 먼저 대화형 컴퓨팅을 위한 개방형 표준을 만들고, VS Code Language Server Protocol을 통해 IDE에서 다중 언어에 대한 풍부한 상호 작용을 추가하고 있습니다.

### 3.6.1. Jupyter 노트북

<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image29.png" />

Jupyter 노트북은 시간이 지남에 따라 가장 많이 사용되고 사랑받는 데이터 과학 도구 중 하나가 되었습니다. 이들은 텍스트 (Markdown 형식), 코드 및 출력 (숫자 및 그래픽)을 결합합니다. 노트북은 데이터 과학자가 목표, 방법 및 결과를 전달하는 데 도움을 줍니다. 이는 교과서나 과학 논문의 실행 가능한 형태로 볼 수 있습니다.

Jupyter는 Julia, Python 및 R의 약자이지만, 또한 갈릴레오가 목성의 위성을 발견한 기록에 경의를 표하는 것입니다. 이러한 노트북은 아마도 과학의 초기 예시 중 하나로, 데이터와 서술 형식의 논문이었습니다. 갈릴레오가 1610년에 "천체신문"을 발표한 때 (그의 최초의 과학 논문 중 하나), 실제로 코드와 데이터를 포함하여 관측 결과를 발표했습니다. 그것은 밤의 날짜와 상태에 대한 기록이었습니다. 데이터와 메타데이터, 그리고 서술이 포함되어 있었습니다.

<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image30.png" />

Jupyter는 [2014년](https://speakerdeck.com/fperez/project-jupyter)에 IPython에서 분리된 프로젝트입니다. IPython은 Interactive Python의 약자로, 2001년에 Fernando Perez가 만들었습니다. 그는 Maple과 Mathematica가 모두 노트북 환경을 갖고 있던 것에서 영감을 받았습니다. 그는 Python 언어를 정말 좋아했지만 과학적 컴퓨팅을 위해 대화식 프롬프트의 제한을 느꼈습니다. 그래서 상태를 유지하고 이전 결과를 재사용할 수 있는 기능을 제공하며 Numeric 라이브러리와 Gnuplot을 로드하는 좋은 기능을 추가하기 위해 파이썬 시작 파일을 작성했습니다. ['ipython-0.0.1'](https://gist.github.com/fperez/1579699)이라는 이름의 코드가 탄생했는데, 이는 단지 259줄의 $PYTHONSTARTUP으로 로드할 수 있는 코드였습니다.

2006년경, IPython 프로젝트는 [Sage](https://www.sagemath.org/)라는 다른 오픈 소스 프로젝트에서 영감을 얻었습니다. Sage 노트북은 노트북 작업을 위해 파일 시스템을 사용하는 방식을 취했습니다. `ls`로 파일을 의미 있게 나열하거나 `cd`로 디렉토리를 변경하여 파일 시스템을 탐색할 수 없었습니다. Sage는 코드를 숨겨진 디렉토리에서 실행하며, 각 셀이 실제로 별도의 하위 디렉토리인 방식으로 동작했습니다.

2010년에 IPython의 아키텍처는 Python 코드를 실행하는 커널과 커뮤니케이션하는 노트북 프론트 엔드를 분리하고 이 둘 간의 통신을 [ZeroMQ 프로토콜](https://zeromq.org/)을 통해 이루어지도록 발전했습니다. 이러한 디자인으로 Qt 클라이언트, Visual Studio 확장 및 마지막으로 웹 프론트 엔드 개발이 가능해졌습니다.

<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image33.png" />
<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image31.png" />
<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image32.png" />

IPython은 Jupyter로 발전하면서 언어에 중립적인 특성을 갖추게 되었습니다. Jupyter는 Julia, R, Haskell, Ruby, 물론 Python (IPython 커널을 통해) 및 [MATLAB](https://github.com/Calysto/matlab_kernel) (커뮤니티에 의해 유지되는 커널로서 MATLAB Engine을 기반으로 구축됨)을 포함한 수십 개의 언어에서 실행 환경 (커널)을 지원합니다.

요약하면, Jupyter는 현대 과학 컴퓨팅 스택에 다음과 같은 3가지 주요 *구성 요소*를 제공합니다:

<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image34.png" /><img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image35.png" />
<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image36.png" />

Jupyter가 데이터 과학 분야에서 광범위하게 성공한 사례 중 일부는 다음과 같은 생태계에서의 추가 기능 개발로 나타납니다:

- Google Colab에서 노트북 실행
- GitHub에서 노트북 렌더링

**Jupyter에 대해 더 알아보기:**

- "The scientific paper is obsolete" - James Somers, The Atlantic - 2018년 4월 5일  
  <https://www.theatlantic.com/science/archive/2018/04/the-scientific-paper-is-obsolete/556676/>

- "The IPython notebook: a historical retrospective"  
  <http://blog.fperez.org/2012/01/ipython-notebook-historical.html>

- "A Brief History of Jupyter Notebooks"  
  <https://ep2020.europython.eu/media/conference/slides/7UBMYed-a-brief-history-of-jupyter-notebooks.pdf>

- "The First Notebook War" - Martin Skarzynski  
  <https://www.youtube.com/watch?v=QR7gR3njNWw>

### 3.6.2. Jupyter를 위한 MATLAB 통합

MathWorks는 2023년 1월에 공식 Jupyter 커널을 출시했습니다. 이 외에도 JupyterHub 서버 설치 내에서 MATLAB 전체 환경을 앱으로 통합하는 방법도 있습니다. 이 앱은 '새로 만들기' 메뉴에서 쉽게 찾을 수 있거나 JupyterLab을 사용하고 있다면 런처 아이콘으로 나타납니다:

<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image37.png" />
<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image37b.png" />

JupyterHub 서버에 이를 설치하는 방법은 다음 링크에서 확인할 수 있습니다:
- https://github.com/mathworks/jupyter-matlab-proxy 
- https://www.mathworks.com/products/reference-architectures/jupyter.html 
- https://blogs.mathworks.com/matlab/2023/01/30/official-mathworks-matlab-kernel-for-jupyter-released/ 

### 3.6.3. Visual Studio Code

저는 Jupyter/IPython Notebook ipynb 파일을 지원하는 Visual Studio Code를 사용하기 시작했습니다.

기타 통합 개발 환경과 마찬가지로, VS Code는 여러 언어 (Python, JavaScript 등)에서 스크립트를 작성하고 실행하는 기능을 지원합니다.

<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image38.png" />

[Eclipse](https://en.wikipedia.org/wiki/Eclipse_(software))의 구성 요소화 접근 방식과의 큰 차이점은 [Language Server Protocol](https://microsoft.github.io/language-server-protocol/overviews/lsp/overview/)라 불리는 웹 표준의 채택입니다:

이를 통해 개발 도구와 언어 서버 간에 더 풍부한 상호작용이 가능해집니다.
또한 모든 것이 웹 기술을 기반으로 하기 때문에 웹 버전을 [vscode.dev](https://vscode.dev/)에서 액세스할 수 있습니다. HTML/JS와 같은 웹 언어와는 달리 이는 브라우저에서 실행되는 인터프리터가 필요하거나 연결할 서버가 필요하므로 Python 실행을 지원하지 않습니다. [Pyodide](https://pyodide.org/en/stable/index.html)를 기반으로 한 몇 가지 해킹 방법이 존재합니다 (Python을 WebAssembly로 변환한 것).


## 3.7. MATLAB과 Python 연결하기

MATLAB 세션을 Python에 연결하는 방법으로 [pyenv](https://www.mathworks.com/help/matlab/ref/pyenv.html) 명령을 2019b 이후부터 사용할 수 있습니다. 그 이전에는 [pyversion](https://www.mathworks.com/help/matlab/ref/pyversion.html) 명령을 사용합니다 (2014b에 도입됨).

여러 버전의 Python이 설치되어 있는 경우, 다음과 같이 특정 버전을 사용하도록 지정할 수 있습니다:
```
>> pyenv('Version','3.8')
```
또는
```
>> pyenv('Version','C:\Users\ydebray\AppData\Local\Programs\Python\Python38\python.exe')
```
이것은 또한 Python 가상 환경에 연결하는 방법입니다:
```
>> pyenv('Version','env/Scripts/python.exe)
```
Python 가상 환경을 생성한 프로젝트 폴더에서, 단순히 'env'라는 이름의 가상 환경을 만들 때 Scripts 하위 폴더에 포함된 Python 실행 파일을 가리키면 됩니다.

**실행 모드:**

기본적으로 Python은 MATLAB과 동일한 프로세스에서 실행됩니다. 이는 두 시스템 간의 프로세스 간 데이터 교환에 대한 오버헤드가 없다는 장점을 가지고 있지만, Python에서 오류가 발생하고 충돌하면 MATLAB도 충돌하는 단점이 있습니다. 이는 MATLAB이 주어진 패키지와 다른 버전의 동일한 라이브러리를 사용할 때 발생할 수 있습니다. 이러한 이유로 [Out-of-Process 실행 모드](https://www.mathworks.com/help/matlab/matlab_external/out-of-process-execution-of-python-functionality.html)가 도입되었습니다:
```
>> pyenv("ExecutionMode","OutOfProcess")
```
**설정 팁:**
- 모든 코드가 경로에 포함되어 있는지 확인하세요 (MATLAB과 [Python 측](https://github.com/hgorr/matlab-with-python/blob/master/setUpPyPath.m) 모두)
- Python을 어떻게 설정했느냐에 따라 환경 설정을 확인하세요
- Out-of-Process 실행 모드에서 [Python 프로세스를 종료](https://www.mathworks.com/help/matlab/ref/pythonenvironment.terminate.html)할 수 있습니다.

## 3.8. MATLAB Engine API for Python 설치하기

[Python 패키지 인덱스(Python Package Index)](https://pypi.org/project/matlabengine/)에 [MATLAB Engine for Python](https://pypi.org/project/matlabengine/)이 추가되었기 때문에 2022년 4월 중순 이후로는 간단하게 pip 명령을 사용하여 설치할 수 있습니다:

```
C:\Users\ydebray>pip install matlabengine
```

그 이전의 경우와 MATLAB R2022a 이전의 릴리스의 경우, [수동으로 설치해야](https://www.mathworks.com/help/matlab/matlab_external/install-the-matlab-engine-for-python.html) 했습니다:

```
cd "matlabroot\extern\engines\python"
python setup.py install
```

Linux에서는 MATLAB의 기본 설치 위치를 확인하기 위해 MATLAB 명령 창에서 `matlabroot`를 호출해야 합니다. Linux의 기본 설치 위치는 다음과 같습니다:

`/usr/local/MATLAB/R2023a`

# 4. MATLAB에서 Python 호출하기

왜 MATLAB에서 Python을 호출하려고 할까요? 그에는 여러 가지 이유가 있을 수 있습니다.

첫째, 개인 사용자로서의 관점에서, Python에서 사용 가능한 기능을 활용하고 싶을 수 있습니다. 예를 들어, Scikit-Learn이나 XGBoost와 같은 분야별 특화 라이브러리를 활용하거나, TensorFlow나 PyTorch와 같은 딥 러닝 라이브러리, OpenAI Gym과 같은 강화 학습 라이브러리 등을 사용할 수 있습니다.

둘째, 동료가 개발한 Python 함수를 활용하고 싶을 때가 있습니다. 이를 통해 MATLAB 사용자로서 해당 기능을 활용할 수 있으며, 다시 코딩할 필요가 없습니다.

셋째, MATLAB 애플리케이션을 Python 기반 환경에서 배포하는 경우가 있습니다. 이러한 경우 데이터 액세스와 같은 일부 서비스가 Python으로 작성되어 있을 수 있습니다.

## 4.1. MATLAB에서 Python 문장 및 파일 실행하기

R2021b부터 [pyrun](https://www.mathworks.com/help/matlab/ref/pyrun.html)을 사용하여 MATLAB에서 직접 Python 문장을 실행할 수 있습니다. 이렇게 하면 스크립트로 래핑하지 않고도 간단한 Python 코드 조각을 실행할 수 있습니다.

```matlab
pyrun("l = [1,2,3]")
pyrun("print(l)")
```

```text:Output
[1, 2, 3]
```

위와 같이 pyrun 함수는 상태를 유지하며 이전 호출에서 정의된 변수를 유지합니다. Python 변수를 MATLAB 측에서 가져올 때는 두 번째 인수로 변수를 지정하면 됩니다.

```matlab
pyrun("l2 = [k^2 for k in l]","l2")
```

```text:Output
ans = 
  Python list with values:

    [3, 0, 1]

    Use string, double or cell function to convert to a MATLAB array.
```

여기서는 l 변수의 값을 사용하여 l2 변수를 생성하고 해당 값을 출력하였습니다.

로컬 스코프에서 정의된 변수 목록은 [dir](https://docs.python.org/3/library/functions.html#dir)() 함수를 사용하여 가져올 수 있습니다.

```matlab
D = pyrun("d = dir()","d")
```

```text:Output
D = 
  Python list with values:

    ['__builtins__', '__name__', 'l', 'l2']

    Use string, double or cell function to convert to a MATLAB array.
```

위 코드에서는 현재 스코프에 정의된 변수 목록을 가져와 D 변수에 저장하였습니다.

만약 Python 코드 조각을 스크립트에 붙여넣는 것이 더 편리하다면 [pyrunfile](https://www.mathworks.com/help/matlab/ref/pyrunfile.html) 함수를 사용할 수 있습니다.

## 4.2. MATLAB 라이브 태스크에서 Python 코드 실행하기

MATLAB R2022a부터는 사용자 정의 라이브 태스크를 개발할 수 있습니다. 그래서 2021년 중반에 Lucas Garcia와 함께 Python 라이브 태스크를 프로토타이핑하기 시작했습니다. 사실은 처음에는 그다지 훌륭하지 않은 버전을 만들었고, 그 후에 Lucas가 이를 훌륭한 형태로 개선했습니다 (이 작업에 대한 모든 칭찬은 Lucas에게 돌아가야 합니다). 이 Minimal Viable Product(MVP)을 기반으로, MATLAB 편집기 팀과 Python 인터페이스 팀과 협력하여 개발에 참여하게 되었습니다. 우리는 이 프로토타입을 GitHub에서 오픈소스로 공개하여 초기 피드백을 받고, 향후 버전에서 제품에 포함시키는 것이 가장 좋을 것으로 결정했습니다.

이 코드는 https://github.com/mathworks 에서 사용 가능합니다.

이를 테스트하려면 저장소를 클론하거나 다운로드하세요. 설정 스크립트를 실행하여 라이브 태스크를 작업 갤러리에 등록하세요. 새 라이브 스크립트를 생성한 후 라이브 편집기 탭에서 작업을 선택하세요. 라이브 스크립트에서 MY TASKS 아래에 다음과 같은 아이콘이 표시됩니다:

<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image41.png" />

이 아이콘을 클릭하면 라이브 스크립트에 커서가 있는 위치에 라이브 태스크가 추가됩니다. 또는 라이브 스크립트에서 "python"이나 "run"을 직접 입력한 후 작업을 선택할 수 있습니다:

<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image43.png" />

첫 번째 버전은 다음과 같았습니다(이것은 제 버전입니다):

<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image44.png" />

그리고 Lucas가 개선한 버전은 다음과 같습니다:

<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image45.png" />

## 4.3. MATLAB에서 Python 호출의 기본 구문

MATLAB에서 Python 함수를 호출하는 모든 구문은 기본적으로 동일한 구문을 가지고 있습니다:

<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image46.png" width="150px" />

제가 일반적으로 처음에 제시하는 기본 예제는 일반적으로 [math 모듈](https://docs.python.org/3/library/math.html)의 제곱근 함수를 호출하는 것입니다. MATLAB에서 Python에서 수학 함수를 호출하는 것은 그다지 의미가 없지만, 결과를 MATLAB에서 기대한 것과 직접 비교하는 것은 쉽습니다:

MATLAB 명령창에서:

`>> py.math.sqrt(42)`

MATLAB 라이브 스크립트에서:

```matlab
py.math.sqrt(42)
```

```text:Output
ans = 6.4807
```

우리는 MATLAB 내에서 Python 데이터 구조를 생성할 수 있습니다:

```matlab
py.list([1,2,3])
```

```text:Output
ans = 
  Python list with values:

    [1.0, 2.0, 3.0]

    Use string, double or cell function to convert to a MATLAB array.

```

```matlab
py.list({1,2,'a','b'})
```

```text:Output
ans = 
  Python list with values:

    [1.0, 2.0, 'a', 'b']

    Use string, double or cell function to convert to a MATLAB array.

```

```matlab
s = struct('a', 1, 'b', 2)
```

```text:Output
s = 
    a: 1
    b: 2

```

```matlab
d = py.dict(s)
```

```text:Output
d = 
  Python dict with no properties.

    {'a': 1.0, 'b': 2.0}

```

또한 MATLAB 측에서 이러한 데이터 구조에 대한 메서드를 실행할 수 있습니다:

```matlab
methods(d)
```

```text:Output
Methods for class py.dict:

char        copy        eq          get         items       le          ne          popitem     struct      values      
clear       dict        ge          gt          keys        lt          pop         setdefault  update      

Static methods:

fromkeys    

Methods of py.dict inherited from handle.
```

```matlab
d.get('a')
```

```text:Output
ans = 1
```

## 4.4. MATLAB에서 Python 사용자 정의 함수 호출하기

이 장에서는 동료인 Ian McKenna가 개발한 데모를 활용할 것입니다. 그는 MathWorks에서 금융 분야의 주요 응용 엔지니어로 근무하며, 기업 웹 예측 분석을 구축하고 다른 비즈니스 중요 응용 프로그램이 웹 서비스로 연결될 수 있도록 담당하고 있습니다. 이 예시는 2장에서의 날씨 예시와 동일한 구조를 따릅니다.

이 웹 서비스는 [암호화폐의 가격을 예측](https://www.mathworks.com/videos/integrating-python-with-matlab-1605793241650.html)하는 것을 목표로 합니다:

<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image80.png" />

다음과 같은 형식의 데이터(JSON)를 반환합니다.

```json
[{"Time":"2022-01-21T12:00:00Z","predictedPrice":2466.17},
...
{"Time":"2022-01-21T17:00:00Z","predictedPrice":2442.25}]
```

첫 번째 단계는 특정 암호화폐의 가격 변동을 간단히 보여주는 애플리케이션을 개발하는 것입니다:

<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image82.png" style="width:3.67361in;height:1.90972in" alt="A picture containing diagram Description automatically generated" />

이를 통해 지난 24시간 동안의 가격 변화를 모니터링하고 이에 기반해 암호화폐 자산을 사거나 판매하는 결정을 내릴 수 있습니다. 그런데 어느 날, 매니저가 다가와 다음과 같이 말합니다:

*"이봐, 좋은 아이디어가 있는데. 만약 우리가 과거 데이터가 아닌 예측 데이터에 접근할 수 있다면, 예측이 100% 정확하더라도 현재로서는 얻는 이익 이상의 추가 수익을 얻을 수 있을거야."*

<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image83.png" />

기관에는 MATLAB 전문 지식을 가진 몇 명의 퀀트(quants) 연구원이 있다고 가정해 봅시다. 그리고 그들은 비즈니스 사용자가 찾는 예측 모델을 구축하는 방법을 정확히 알고 있습니다.

하지만 그에 앞서, 우리의 첫 번째 과제는 Python 데이터 스크래핑 라이브러리를 호출하고 해당 데이터를 직접 MATLAB으로 가져오는 것입니다. 우선 손쉽게 해당하는 암호화폐 URL을 구문 분석하고 도메인 이름만 추출하는 작업을 해보겠습니다. 이를 위해 [`urllib`](https://docs.python.org/3/library/urllib.html) 패키지의 하위 모듈인 `parse`의 `urlparse` 함수를 사용하려고 합니다.

```matlab
startDate = '2022-01-21T12:00:00Z';
stopDate = '2022-01-21T17:00:00Z';
url = "https://api.pro.coinbase.com/products/ETH-USD/candles?start="+startDate+"&end="+stopDate+"&granularity=60"
```


```text:Output
url = "https://api.pro.coinbase.com/products/ETH-USD/candles?start=2022-01-21T12:00:00Z&end=2022-01-21T17:00:00Z&granularity=60"
```


```matlab
urlparts = py.urllib.parse.urlparse(url)
```


```text:Output
urlparts = 
  Python ParseResult with properties:

    fragment
    hostname
    netloc
    params
    password
    path
    port
    query
    scheme
    username

    ParseResult(scheme='https', netloc='api.pro.coinbase.com', path='/products/ETH-USD/candles', params='', query='start=2022-01-21T12:00:00Z&end=2022-01-21T17:00:00Z&granularity=60', fragment='')

```


```matlab
domain = urlparts.netloc
```


```text:Output
domain = 
  Python str with no properties.

    api.pro.coinbase.com

```

MATLAB과 Python 간의 중간 데이터 이동을 최소화하기 위해, 몇 가지 함수를 포함하는 [Python 사용자 정의 모듈](https://www.mathworks.com/help/matlab/matlab_external/call-user-defined-custom-module.html)인 `dataLib.py`를 작성합니다.

```matlab(Display)
jsonData = py.dataLib.getPriceData("ETH", startDate, stopDate)
data = py.dataLib.parseJson(jsonData, [0,4])
```

`dataLib.py`는 [Coinbase Pro](https://pro.coinbase.com/)에서 1분봉(1-minute bars)을 가져옵니다. API는 시작 날짜로 지정한 첫 번째 분을 가져오지 않으므로 시간 범위는 (시작, 끝]입니다. 데이터 반환에는 Numpy 배열부터 목록 및 딕셔너리 및 JSON까지 다양한 데이터 구조를 사용합니다.

이것이 MATLAB에서 이 함수를 호출하는 방법입니다.

참고: `dataLib.py`는 Python의 경로에 있어야 합니다.

```matlab
product = "ETH";
```

```text:Output
product = "ETH"
```

```matlab
startDate = '2022-01-21T12:00:00Z';
stopDate = '2022-01-21T17:00:00Z';
jsonData = py.dataLib.getPriceData(product, startDate, stopDate);
```

만약 Live Script에 상호작용성을 추가하고 싶다면, [Live Controls](https://www.mathworks.com/help/matlab/matlab_prog/add-interactive-controls-to-a-live-script.html)라는 이름의 요소를 추가할 수 있습니다. 이는 매개변수나 옵션을 제공하여 사용자가 Live Script 내에서 조절할 수 있도록 하여 상호작용성과 시나리오 분석을 향상시킵니다.


<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image86.png" />

리본에서 컨트롤을 삽입할 수 있습니다:

<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image87.png" />

이것이 Live Control을 매개변수화하는 방법입니다:

<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image88.png" />

여기에서 유용한 또 다른 유형의 Live Control은 `parseJson` 함수에서 반환할 정보를 선택하는 간단한 체크박스입니다:

여기에서 유용한 또 다른 유형의 Live Control은 `parseJson` 함수에서 반환할 정보를 선택하는 간단한 체크박스입니다:

<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image89.png" />

```matlab
Dates = true;
Low = false;
High = false;
Open = false;
Close = true;
Volume = false;

% Python 인덱싱(0부터 시작)에 맞게 1을 뺍니다
selectedColumns = find([Dates Low High Open Close Volume])-1;
```

```text:Output
selectedColumns = 1x2    
     0     4

```

Python 인덱싱이 0부터 시작하기 때문에 결과 배열에서 1을 빼는 것에 주의하세요.

```matlab
% this function returns back two outputs as a tuple
data = py.dataLib.parseJson(jsonData, selectedColumns);
```

우리 이야기의 이 부분에서 마지막으로 할 일은 Python 함수 출력을 MATLAB 데이터 유형으로 변환하는 것입니다 (이는 Python과 MATLAB 간 데이터 매핑에 대한 이 장의 마지막 부분에서 다룰 예정입니다).

```matlab
priceData = data{1};
```


```text:Output
priceData = 
  Python ndarray:

   1.0e+09 *

    1.6428    0.0000
    1.6428    0.0000
    ...
    1.6428    0.0000
    1.6428    0.0000

    Use details function to view the properties of the Python object.

    Use double function to convert to a MATLAB array.

```

Python 객체의 속성을 보려면 details 함수를 사용하세요.

MATLAB 배열로 변환하려면 double 함수를 사용하세요.

```matlab
columnNames = data{2}
```

```text:Output
columnNames = 
  Python list with no properties.

    ['Date', 'Close']

```

그런 다음 우리는 오른쪽의 Numpy 배열을 단순히 double 명령을 사용하여 캐스팅할 수 있습니다:

```matlab
priceData = double(priceData);
```

```text:Output
priceData = 300x2    
1.0e+09 *

    1.6428    0.0000
    1.6428    0.0000
    1.6428    0.0000
    1.6428    0.0000
    1.6428    0.0000
    1.6428    0.0000
    1.6428    0.0000
    1.6428    0.0000
    1.6428    0.0000
    1.6428    0.0000

```

마찬가지로 문자열(또는 R2022a 이전 버전에서는 cell)과 같은 목록을 캐스팅하기 위한 다양한 명령이 있습니다:

```matlab
columnNames = string(columnNames);
```

우리가 MATLAB에서 이러한 데이터를 가지고 있는 경우, MATLAB 테이블로 변환하게 되는데, 이는 기본적으로 Pandas 데이터 프레임과 유사합니다:

```matlab
data = array2table(priceData, 'VariableNames', columnNames);
```

테이블과 마찬가지로, 타임테이블은 간단한 유형의 작업이나 복잡한 유형의 작업을 수행하기 위해 몇 년 동안 MATLAB에 내장된 데이터 구조입니다. 만약 시간대를 다루고, 시간을 세계 표준 시간대에 따른 시간으로 변환하고 싶다면, [datetime](https://www.mathworks.com/help/matlab/ref/datetime.html#d123e298898) 명령을 사용하여 해당 변환을 수행할 수 있습니다.

```matlab
data.Date = datetime(data.Date, 'ConvertFrom', 'posixtime', 'TimeZone', 'America/New_York')
```

| |Date|Close|
|:--:|:--:|:--:|
|1|21-Jan-2022 12:00:00|2.8073e+03|
|2|21-Jan-2022 11:59:00|2.8108e+03|
|3|21-Jan-2022 11:58:00|2.8051e+03|
|4|21-Jan-2022 11:57:00|2.8071e+03|
|5|21-Jan-2022 11:56:00|2.8051e+03|
|6|21-Jan-2022 11:55:00|2.8028e+03|
|7|21-Jan-2022 11:54:00|2.7984e+03|
|8|21-Jan-2022 11:53:00|2.7983e+03|
|9|21-Jan-2022 11:52:00|2.8062e+03|
|10|21-Jan-2022 11:51:00|2.8054e+03|
|11|21-Jan-2022 11:50:00|2.8061e+03|
|12|21-Jan-2022 11:49:00|2.8012e+03|
|13|21-Jan-2022 11:48:00|2.8008e+03|
|14|21-Jan-2022 11:47:00|2.8030e+03|


```matlab
plot(data.Date, data.Close)
```

<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image90.png" />

[**사용자 정의 Python 모듈 다시 로드하기**](https://www.mathworks.com/help/matlab/matlab_external/call-user-defined-custom-module.html#buuz303)

만약 `dataLib` 모듈 내부의 함수들을 수정했다면 어떻게 해야 할까요? MATLAB에서 해당 함수들을 다시 호출하겠지만 어떤 차이도 보이지 않을 것입니다. 이는 모듈을 다시 로드해야 하기 때문입니다:

```matlab
mod = py.importlib.import_module('dataLib');
py.importlib.reload(mod);
```

때때로 모듈을 언로드해야 할 수도 있는데, 이를 위해 클래스를 지워야 합니다. 이렇게 하면 MATLAB 작업 공간에서 모든 변수, 스크립트, 클래스가 삭제됩니다.

```matlab
clear classes 
```

Python을 프로세스 외부에서 실행하고 있다면, 다른 접근 방법으로는 [프로세스를 종료](https://www.mathworks.com/help/matlab/matlab_external/reload-python-interpreter.html)하는 것입니다.

```matlab
terminate(pyenv) 
```

## 4.5. MATLAB에서 Python 커뮤니티 패키지 호출하기

지구과학 및 기후 과학과 같은 일부 과학 분야에서는 Python 커뮤니티가 점점 커지고 있습니다. 하지만 연구원과 엔지니어들의 프로그래밍 능력은 매우 다양하기 때문에, MATLAB에서 Python 커뮤니티 패키지에 대한 인터페이스를 만들면 500만 이상의 MATLAB 커뮤니티에 특정 도메인의 능력을 제공할 수 있습니다.

이에 대한 좋은 예시 중 하나는 MathWorker인 Rob Purser가 개발한 [Climate Data Store Toolbox](https://github.com/mathworks/climatedatastore)입니다. Rob과 저는 MathWorks Open Source 프로그램 핵심 팀의 일원입니다. 우리는 오픈 소스를 홍보하며, MathWorks 제품에서 오픈 소스 소프트웨어 사용을 지원하고 MathWorkers가 GitHub와 [MATLAB 파일 교환](https://www.mathworks.com/matlabcentral/fileexchange/)에 자신의 작업을 기여하는 데 도움을 주고 있습니다.

![](https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image75.png)

이 섹션에서는 Climate Data Store Toolbox를 사용하여 Python 패키지 위에 MATLAB 툴박스를 어떻게 구축하는지에 대해 설명합니다. 이 툴박스는 유럽 중기 기상 예보 센터 (ECMWF)가 만든 [CDS Python API](https://github.com/ecmwf/cdsapi)에 의존합니다. 이 툴박스는 자동으로 Python을 설정하고 CDSAPI 패키지를 다운로드하고 설치할 것입니다 (수동으로 `pip install cdsapi`를 사용하여 수동으로 설치할 수도 있습니다). 데이터를 검색하려면 [https://cds.climate.copernicus.eu/](https://cds.climate.copernicus.eu/)에서 계정을 만들어야 합니다.

처음 사용할 때, CSAPI 자격 증명을 요청할 것입니다.

![](https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image76.png)

데이터 세트에서 다운로드할 데이터를 선택하십시오 ([이 웹페이지](https://cds.climate.copernicus.eu/cdsapp#!/dataset/satellite-sea-ice-thickness?tab=form)에서 옵션 확인). 이것은 API 요청에서 생성되는 Python 구조의 "MATLAB화"된 버전입니다.

```matlab
datasetName ="satellite-sea-ice-thickness";
options.version = "1_0";
options.variable = "all";
options.satellite = "cryosat_2";
options.cdr_type = ["cdr","icdr"]; 
options.year = ["2011","2021"]; 
options.month = "03";
[downloadedFilePaths,citation] = climateDataStoreDownload('satellite-sea-ice-thickness',options);
```

```text:Output
2021-12-03 14:45:47,502 INFO Welcome to the CDS
2021-12-03 14:45:47,504 INFO Sending request to https://cds.climate.copernicus.eu/api/v2/resources/satellite-sea-ice-thickness
2021-12-03 14:45:47,610 INFO Request is completed
2021-12-03 14:45:47,611 INFO Downloading https://download-0012.copernicus-climate.eu/cache-compute-0012/cache/data0/dataset-satellite-sea-ice-thickness-2e9e98de-6daf-4e4e-b54c-6e2d3717bda2.zip to C:\Users\rpurser\AppData\Local\Temp\tp047bab7e_df6a_405a_b357_cda6a03d28f6.zip (4.4M)
2021-12-03 14:45:50,037 INFO Download rate 1.8M/s
```

Python으로 가져온 NetCDF 파일은 [ncread](https://www.mathworks.com/help/matlab/ref/ncread.html)를 사용하여 MATLAB에서 읽고 [timetable](https://www.mathworks.com/help/matlab/timetables.html) 형식으로 정보를 저장합니다. 이 작업은 [readSatelliteSeaIceThickness](https://github.com/mathworks/climatedatastore/blob/main/doc/readSatelliteSeaIceThickness.m) 함수를 통해 수행됩니다.

```matlab
ice2011 = readSatelliteSeaIceThickness("satellite-sea-ice-thickness\ice_thickness_nh_ease2-250_cdr-v1p0_201103.nc");
ice2021 = readSatelliteSeaIceThickness("satellite-sea-ice-thickness\ice_thickness_nh_ease2-250_icdr-v1p0_202103.nc");
head(ice2021)
```

| |time|lat|lon|thickness|
|:--:|:--:|:--:|:--:|:--:|
|1|01-Mar-2021|47.6290|144.0296|2.4566|
|2|01-Mar-2021|47.9655|144.0990|2.5800|
|3|01-Mar-2021|50.5072|148.0122|-0.0364|
|4|01-Mar-2021|50.8360|148.1187|1.0242|
|5|01-Mar-2021|50.3237|146.9969|0.0518|
|6|01-Mar-2021|51.1642|148.2269|0.2445|
|7|01-Mar-2021|50.9112|147.6573|0.8933|
|8|01-Mar-2021|50.6540|147.0948|0.1271|

```matlab
disp(citation)
```

```text:Output
Generated using Copernicus Climate Change Service information 2021
```

이 툴박스는 MATLAB의 아름다운 [지리 데이터 시각화](https://www.mathworks.com/help/matlab/ref/geodensityplot.html) 기능을 활용합니다.


```matlab
subplot(1,2,1)
geodensityplot(ice2011.lat,ice2011.lon,ice2011.thickness,"FaceColor","interp")
geolimits([23 85],[-181.4 16.4])
geobasemap("grayterrain")
title("Ice Thickness, March 2011")

subplot(1,2,2)
geodensityplot(ice2021.lat,ice2021.lon,ice2021.thickness,"FaceColor","interp")
geolimits([23 85],[-181.4 16.4])
geobasemap("grayterrain")
title("Ice Thickness, March 2021")
f = gcf;
f.Position(3) = f.Position(3)*2;
```

![](https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image77.png)

이처럼 잘 작성된 toolbox에서는 해당 toolbox와 직접 패키지화된 문서를 찾을 수 있습니다.

![](https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image78.png)

자신만의 toolbox를 생성하여 다른 사람과 공유할 수 있습니다. 이 파일들은 MATLAB 코드, 데이터, 앱, 예제 및 문서를 포함할 수 있습니다. 툴박스를 생성할 때 MATLAB은 당신이나 다른 사람이 툴박스를 설치할 수 있게 해주는 단일 설치 파일 (.mltbx)을 생성합니다.

[툴박스 생성 및 공유 방법](https://www.mathworks.com/help/matlab/matlab_prog/create-and-share-custom-matlab-toolboxes.html)에 대해 더 읽어보세요.

## 4.6. MATLAB에서 호출되는 Python 코드 디버그하기

언어 경계를 넘나드는 양언어 애플리케이션을 개발할 때 가장 처음으로 마주치게 되는 어려움 중 하나는 언어 경계를 넘어서 디버깅하는 것입니다. 다음 예제에서는 앱의 Python 부분을 디버그하기 위해 MATLAB 세션을 VSCode나 Visual Studio 프로세스에 연결하는 방법을 보여줄 것입니다. 다음 장에서는 그 반대인 MATLAB 부분을 아름다운 MATLAB 디버거를 사용해 디버그하는 방법을 살펴볼 것입니다.

### 4.6.1. Visual Studio Code를 사용한 디버깅

이 섹션은 [VSCode를 사용하여 MATLAB에서 호출된 Python 코드를 디버깅하는 방법](https://www.mathworks.com/matlabcentral/answers/1645680-how-can-i-debug-python-code-using-matlab-s-python-interface-and-visual-studio-code)을 8단계로 보여줍니다:

1) VS Code를 설치하고 프로젝트를 생성합니다.

[이 튜토리얼](https://code.visualstudio.com/docs/python/python-tutorial#_configure-and-run-the-debugger)에서 Visual Studio Code를 설치하는 방법, Python 프로젝트를 설정하는 방법, Python 인터프리터를 선택하는 방법 및 `launch.json` 파일을 생성하는 방법에 대한 지침을 확인하세요.

2) 터미널에서 다음과 같이 debugpy 모듈을 설치합니다.
```
$ python -m pip install debugpy
```
3) VS Code에서 다음 디버깅 코드를 Python 모듈의 맨 위에 추가합니다.
```python
import debugpy
debugpy.debug_this_thread()
```
4) `launch.json` 파일을 아래의 코드로 구성하여 MATLAB을 선택하고 연결하도록 설정합니다.
```json
{
    "version": "0.2.0",
    "configurations": [
         {  
            "name": "Attach to MATLAB",
            "type": "python",
            "request": "attach",
            "processId": "${command:pickProcess}"
         }
    ]
}
```
5) 코드에 중단점을 추가합니다.

6) MATLAB에서 Python 환경을 설정하고 ProcessID 번호를 가져옵니다. 이 예제에서 `ExecutionMode`는 `InProcess`로 설정되어 있습니다.
   
```matlab
>> pyenv 

ans = 
  PythonEnvironment with properties:

          Version: "3.8"
       Executable: "C:\Users\ydebray\AppData\Local\Programs\Python\Python38\python.exe"
          Library: "C:\Users\ydebray\AppData\Local\Programs\Python\Python38\python38.dll"
             Home: "C:\Users\ydebray\AppData\Local\Programs\Python\Python38"
           Status: Loaded
    ExecutionMode: InProcess
        ProcessID: "12772"
      ProcessName: "MATLAB"

```

만약 `Status: NotLoaded`가 표시된다면, Python 인터프리터를 로드하기 위해 아무 Python 명령을 실행한 다음 (예를 들어 `>> py.list`), `pyenv` 명령을 실행하여 MATLAB 프로세스의 `ProcessID`를 얻으십시오.

7) MATLAB 프로세스를 VS Code에 연결합니다.

VS Code에서 "Run and Debug" (Ctrl+Shift+D)를 선택한 후, 디버깅을 시작하는 화살표를 선택합니다 (F5). 이 예제에서 녹색 화살표에는 "Attach to MATLAB"라는 레이블이 표시됩니다. 이는 `launch.json` 파일에서 지정한 "name" 매개변수의 값과 일치합니다. 드롭다운 메뉴의 검색 창에 "matlab"을 입력하고, pyenv 명령의 출력과 일치하는 "MATLAB.exe" 프로세스를 선택하세요. 만약 OutOfProcess 실행 모드를 사용 중이라면, "MATLABPyHost.exe" 프로세스를 검색해야 할 것입니다.

**In-process 실행 모드:**

![](https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image47.png)

**Out-of-Process 실행 모드:**

![](https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image48.png)

8) MATLAB에서 Python 함수를 호출합니다. 실행이 중단되어야 할 중단점에서 멈출 것입니다.

![](https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image49.png)

다음 MATLAB 코드를 실행하여 Python 함수 search 내부로 들어가 보세요:
```matlab
>> N = py.list({'Jones','Johnson','James'})
>> py.mymod.search(N)
```

### 4.6.2. Visual Studio로 디버깅하기

만약 Visual Studio에 접근할 수 있고 더 익숙하다면, [Visual Studio](https://stackoverflow.com/questions/61708900/calling-python-from-matlab-how-to-debug-python-code)를 사용하여 이전과 동일한 작업을 수행할 수 있습니다. Visual Studio를 열고 기존 코드로부터 새 Python 프로젝트를 생성합니다. 그런 다음 디버그 메뉴에서 "Attach to Process"를 선택하세요:

![](https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image50.png)

# 4.7. Python과 MATLAB 간의 데이터 매핑


[*Python for MATLAB Development*](https://link.springer.com/book/10.1007/978-1-4842-7223-7)이라는 책에서 Albert Danial은 [mat2py](https://github.com/Apress/python-for-matlab-development/blob/main/code/matlab_py/mat2py.m)를 사용하여 MATLAB 변수를 해당하는 Python 기본 변수로 변환하는 똑똑한 함수와 [py2mat](https://github.com/Apress/python-for-matlab-development/blob/main/code/matlab_py/py2mat.m)을 사용하여 반대로 수행하는 함수를 공유합니다.

MATLAB 함수 내에서 반환된 Python 함수의 [데이터 변환](https://www.mathworks.com/help/matlab/matlab_external/passing-data-to-python.html)은 두 언어의 기본 데이터 유형의 차이를 이해해야 할 수도 있습니다:

   - 스칼라(정수, 부동 소수점 숫자 등), 텍스트 및 부울 값
   - 딕셔너리(dictionary) 및 리스트(list)
   - 배열(array) 및 데이터프레임(dataframe)

*타임테이블* 또는 *카테고리*와 같은 일부 특수한 MATLAB 데이터 유형은 추가 처리가 필요하며 수동으로 변환되어야 할 수 있습니다. 물론 이러한 데이터 유형을 여전히 함수에서 사용할 수는 있지만, 함수는 Python 인터프리터가 이해할 수 있는 유형을 반환해야 합니다.


## 4.7.1. 스칼라(Scalars)

아래 표는 일반적인 스칼라 데이터 유형의 매핑을 보여줍니다:

![](https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image92.png)

기본적으로 MATLAB에서 숫자는 double 형태이며, Python에서 소수점 없는 숫자는 정수 형태입니다.

```matlab
a = py.dataExchange.get_float()
```

```text:Output
a = 1
```

```matlab
class(a)
```

```text:Output
ans = 'double'
```

```matlab
b = py.dataExchange.get_complex()
```

```text:Output
b = 2.0000 + 0.0000i
```

```matlab
class(b)
```

```text:Output
ans = 'double'
```
MATLAB에는 요구되는 정밀도에 따라 여러 유형의 정수가 있습니다.

예를 들어, [uint8](https://www.mathworks.com/help/matlab/ref/uint8.html)은 0과 255 사이의 양수만 저장할 수 있으며, [int8](https://www.mathworks.com/help/matlab/ref/int8.html)은 [-2^7, 2^7-1] 범위를 다룹니다.

Python 정수를 변환하는 가장 일반적인 유형은 int64입니다. 이를 명시적으로 수행할 수 있습니다.

```matlab
c = py.dataExchange.get_integer()
```

```text:Output
c = 
  Python int with properties:

    denominator: [1x1 py.int]
           imag: [1x1 py.int]
      numerator: [1x1 py.int]
           real: [1x1 py.int]

    3

```

```matlab
class(c)
```

```text:Output
ans = 'py.int'
```

```matlab
int64(c)
```

```text:Output
ans = 3
```

Python 함수에서 문자열을 가져올 때 변환은 명확하지 않을 수 있습니다. 이를 [char](https://www.mathworks.com/help/matlab/ref/char.html) (문자 배열)이나 [string](https://www.mathworks.com/help/matlab/ref/string.html)으로 변환할 수 있습니다.

char의 경우 작은따옴표로, string의 경우 큰따옴표로 구분할 수 있습니다.

```matlab
abc = py.dataExchange.get_string()
```

```text:Output
abc = 
  Python str with no properties.

    abc

```

```matlab
char(abc)
```


```text:Output
ans = 'abc'
```


```matlab
class(char(abc))
```


```text:Output
ans = 'char'
```


```matlab
string(abc)
```


```text:Output
ans = "abc"
```


```matlab
class(string(abc))
```


```text:Output
ans = 'string'
```

마지막으로, 논리 정보를 포함하는 기본 데이터 유형은 Python에서 불리언(boolean)이라고 불립니다.

```matlab
py.dataExchange.get_boolean()
```

```text:Output
ans = 
   1

```

## 4.7.2. 딕셔너리(Dictionaries)과 리스트(Lists)

다음은 두 언어 간에 컨테이너가 어떻게 매핑되는지를 나타내는 내용입니다:

![](https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image93.png)

Python 딕셔너리와 리스트를 MATLAB 컨테이너로 변환하는 예를 제시하기 위해 2장의 예제를 다시 사용해 보겠습니다.

JSON 데이터는 Python의 딕셔너리와 매우 유사하며, 웹 서비스에서 데이터에 접근할 때 데이터 처리가 매우 쉬워집니다.

```matlab
url = webread("https://samples.openweathermap.org").products.current_weather.samples{1};
r = py.urllib.request.urlopen(url).read();
json_data = py.json.loads(r);
py.weather.parse_current_json(json_data)
```

```text:Output
ans = 
  Python dict with no properties.

    {'temp': 280.32, 'pressure': 1012, 'humidity': 81, 'temp_min': 279.15, 'temp_max': 281.15, 'speed': 4.1, 'deg': 80, 'lon': -0.13, 'lat': 51.51, 'city': 'London', 'current_time': '2022-05-22 22:15:18.161296'}

```

딕셔너리는 스칼라 뿐만 아니라 리스트와 같은 다른 데이터 유형도 포함할 수 있습니다.

```matlab
url2 = webread("https://samples.openweathermap.org").products.forecast_5days.samples{1};
r2 = py.urllib.request.urlopen(url2).read();
json_data2 = py.json.loads(r2);
forecast = struct(py.weather.parse_forecast_json(json_data2))
```

```text:Output
forecast = 
    current_time: [1x40 py.list]
            temp: [1x40 py.list]
             deg: [1x40 py.list]
           speed: [1x40 py.list]
        humidity: [1x40 py.list]
        pressure: [1x40 py.list]

```

```matlab
forecastTemp = forecast.temp;
forecastTime = forecast.current_time;
```

숫자 데이터만 포함하는 리스트는 MATLAB R2022a부터는 doubles로 변환할 수 있습니다:

```matlab
double(forecastTemp)
```

```text:Output
ans = 1x40    
  261.4500  261.4100  261.7600  261.4600  260.9810  262.3080  263.7600  264.1820  264.6700  265.4360  266.1040  266.9040  268.1020  270.2690  270.5850  269.6610  269.1550  268.0560  265.8030  263.3810  261.8500  263.4550  264.0150  259.6840  255.1880  255.5940  256.9600  258.1090  259.5330  263.4380  264.2280  261.1530  258.8180  257.2180  255.7820  254.8190  257.4880  259.8270  261.2560  260.2600
```

그리고 어떤 종류의 리스트든 문자열로 변환할 수 있습니다 (텍스트와 숫자 데이터의 혼합을 포함한 경우도).

```matlab
forecastTimeString = string(forecastTime);
datetime(forecastTimeString)
```

```text:Output
ans = 1x40 datetime    
30-Jan-2017 18:00:0030-Jan-2017 21:00:0031-Jan-2017 00:00:0031-Jan-2017 03:00:0031-Jan-2017 06:00:0031-Jan-2017 09:00:0031-Jan-2017 12:00:0031-Jan-2017 15:00:0031-Jan-2017 18:00:0031-Jan-2017 21:00:0001-Feb-2017 00:00:0001-Feb-2017 03:00:0001-Feb-2017 06:00:0001-Feb-2017 09:00:0001-Feb-2017 12:00:0001-Feb-2017 15:00:0001-Feb-2017 18:00:0001-Feb-2017 21:00:0002-Feb-2017 00:00:0002-Feb-2017 03:00:0002-Feb-2017 06:00:0002-Feb-2017 09:00:0002-Feb-2017 12:00:0002-Feb-2017 15:00:0002-Feb-2017 18:00:0002-Feb-2017 21:00:0003-Feb-2017 00:00:0003-Feb-2017 03:00:0003-Feb-2017 06:00:0003-Feb-2017 09:00:00
```

R2022a 이전에는 Python 리스트를 [MATLAB cell 배열](https://www.mathworks.com/help/matlab/cell-arrays.html)로 변환해야 했습니다.

그런 다음 [cellfun](https://www.mathworks.com/help/matlab/ref/cellfun.html) 함수로 셀을 double, 문자열로 변환할 수 있습니다.

R2021b까지는 이전 코드는 다음과 같을 것입니다:

```matlab
forecastTempCell = cell(forecastTemp)
```

| |1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|
|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
|1|261.4500|261.4100|261.7600|261.4600|260.9810|262.3080|263.7600|264.1820|264.6700|265.4360|266.1040|266.9040|268.1020|270.2690|270.5850|269.6610|269.1550|268.0560|265.8030|263.3810|261.8500|263.4550|264.0150|259.6840|255.1880|255.5940|256.9600|258.1090|259.5330|263.4380|


```matlab
cellfun(@double,forecastTempCell)
```

```text:Output
ans = 1x40    
  261.4500  261.4100  261.7600  261.4600  260.9810  262.3080  263.7600  264.1820  264.6700  265.4360  266.1040  266.9040  268.1020  270.2690  270.5850  269.6610  269.1550  268.0560  265.8030  263.3810  261.8500  263.4550  264.0150  259.6840  255.1880  255.5940  256.9600  258.1090  259.5330  263.4380  264.2280  261.1530  258.8180  257.2180  255.7820  254.8190  257.4880  259.8270  261.2560  260.2600
```

```matlab
forecastTimeCell = cell(forecastTime)
```

| |1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|
|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
|1|1x19 str|1x19 str|1x19 str|1x19 str|1x19 str|1x19 str|1x19 str|1x19 str|1x19 str|1x19 str|1x19 str|1x19 str|1x19 str|1x19 str|1x19 str|1x19 str|1x19 str|1x19 str|1x19 str|1x19 str|1x19 str|1x19 str|1x19 str|1x19 str|1x19 str|1x19 str|1x19 str|1x19 str|1x19 str|1x19 str|1x19 str|


```matlab
cellfun(@string,forecastTimeCell)
```

```text:Output
ans = 1x40 string    
"2017-01-30 18:0…  "2017-01-30 21:0…  "2017-01-31 00:0…  "2017-01-31 03:0…  "2017-01-31 06:0…  "2017-01-31 09:0…  "2017-01-31 12:0…  "2017-01-31 15:0…  "2017-01-31 18:0…  "2017-01-31 21:0…  "2017-02-01 00:0…  "2017-02-01 03:0…  "2017-02-01 06:0…  "2017-02-01 09:0…  "2017-02-01 12:0…  "2017-02-01 15:0…  "2017-02-01 18:0…  "2017-02-01 21:0…  "2017-02-02 00:0…  "2017-02-02 03:0…  "2017-02-02 06:0…  "2017-02-02 09:0…  "2017-02-02 12:0…  "2017-02-02 15:0…  "2017-02-02 18:0…  "2017-02-02 21:0…  "2017-02-03 00:0…  "2017-02-03 03:0…  "2017-02-03 06:0…  "2017-02-03 09:0…
```

## 4.7.3. 배열

weather 모듈의 parse_forecast_json 함수를 수정함으로써 리스트 대신 [Python 배열](https://docs.python.org/3/library/array.html)을 출력할 수 있습니다.

실제로 기본 Python에는 원시 배열 데이터 형식이 존재합니다.

```matlab
forecast2 = struct(py.weather.parse_forecast_json2(json_data2))
```

```text:출력
forecast2 = 
    current_time: [1x40 py.list]
            temp: [1x1 py.array.array]
             deg: [1x1 py.array.array]
           speed: [1x1 py.array.array]
        humidity: [1x1 py.array.array]
        pressure: [1x1 py.array.array]
```

MATLAB의 `double` 함수는 Python 배열을 MATLAB 배열로 변환합니다.

```matlab
double(forecast2.temp)
```

```text:출력
ans = 1x40    
  261.4500  261.4100  261.7600  261.4600  260.9810  262.3080  263.7600  264.1820  264.6700  265.4360  266.1040  266.9040  268.1020  270.2690  270.5850  269.6610  269.1550  268.0560  265.8030  263.3810  261.8500  263.4550  264.0150  259.6840  255.1880  255.5940  256.9600  258.1090  259.5330  263.4380  264.2280  261.1530  258.8180  257.2180  255.7820  254.8190  257.4880  259.8270  261.2560  260.2600
```

이 데이터 변환은 Numpy 배열에도 적용됩니다.

```matlab
npA = py.numpy.array([1,2,3;4,5,6;7,8,9])
```

```text:Output
npA = 
  Python ndarray:

     1     2     3
     4     5     6
     7     8     9

    Use details function to view the properties of the Python object.

    Use double function to convert to a MATLAB array.

```

```matlab
double(npA)
```


```text:Output
ans = 3x3    
     1     2     3
     4     5     6
     7     8     9

```

## 4.7.4. 데이터프레임

데이터 전송에 대한 일반적인 질문 중 하나는 MATLAB 테이블과 Pandas 데이터프레임 간의 데이터 교환 방법입니다. 이에 대한 권장 솔루션은 [Parquet 파일](https://www.mathworks.com/help/matlab/parquet-files.html)을 활용하는 것입니다. Parquet은 열 지향 저장 형식으로, 다양한 언어 간에 탭ular 데이터를 저장하고 전송하는 데 사용됩니다. 이는 Hadoop 빅 데이터 생태계의 프로젝트에서 데이터 처리 프레임워크, 데이터 모델 또는 프로그래밍 언어 선택에 관계없이 사용할 수 있습니다. ([Parquet에 대해 더 알아보기](https://parquet.apache.org/))

아래 예제는 Pandas 데이터프레임과 MATLAB 테이블 간의 상호 작용을 보여줍니다.

**pq_CreateDataFrame.py**

```python
import pandas as pd
import numpy as np
 
# 데이터프레임 생성
df = pd.DataFrame({'column1': [-1, np.nan, 2.5], 
'column2': ['foo', 'bar', 'tree'], 
'column3': [True, False, True]})
print(df)
 
# pyarrow 라이브러리를 통해 데이터프레임을 Parquet 파일로 저장
df.to_parquet('data.parquet', index=False)
```

이 코드는 Python 스크립트로 작성되어 있으며, 데이터프레임을 생성하고 Parquet 파일로 저장하는 과정을 나타냅니다.
  
Parquet 파일 읽기

```matlab
% info = parquetinfo('data.parquet')
data = parquetread('data.parquet')
```

| |column1|column2|column3|
|:--:|:--:|:--:|:--:|
|1|-1|"foo"|1|
|2|NaN|"bar"|0|
|3|2.5000|"tree"|1|

특정 열의 데이터 타입 확인

```matlab
class(data.column2)
```

```text:출력
ans = 'string'
```

테이블 내 데이터 변경

```matlab
data.column2 = ["orange"; "apple"; "banana"];
```

결과를 다시 Parquet로 쓰기

```matlab
parquetwrite('newdata.parquet', data)
```

마지막으로 수정된 데이터프레임을 Python에서 다시 읽기:


**pq_ReadTable.py**

```python
import pandas as pd
import os 

# change to current directory
thisDirectory = os.path.dirname(os.path.realpath(__file__))
os.chdir(thisDirectory)
# read parquet file via pyarrow library
df = pd.read_parquet('newdata.parquet')
print(df)
```

# 5. 파이썬 AI 라이브러리를 MATLAB에서 호출하기

이 장에서는 인공 지능을 위한 다양한 파이썬 라이브러리, 머신 러닝 및 딥 러닝 (Scikit-learn 및 TensorFlow와 같은) 및 이를 MATLAB에서 호출하는 방법을 살펴보겠습니다.

이러한 단계는 일반적인 [AI 워크플로우](https://www.mathworks.com/discovery/artificial-intelligence.html)에 통합될 수 있습니다:

![](https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image51.png)

## 5.1. MATLAB에서 Scikit-learn 호출하기

Iris 꽃 [데이터셋](https://en.wikipedia.org/wiki/Iris_flower_data_set)은 영국 통계학자이자 생물학자인 Ronald Fisher가 소개한 다변량 데이터셋입니다. 이 데이터셋은 3가지 다른 종류의 붓꽃(Setosa, Versicolour 및 Virginica) 꽃잎과 꽃받침 길이로 이루어진 150x4 numpy.ndarray로 구성되어 있습니다. 행은 샘플을 나타내고 열은 꽃받침 길이, 꽃받침 폭, 꽃잎 길이 및 꽃잎 폭을 나타냅니다.


또한 이 데이터셋은 MATLAB에도 있으며, 이는 통계 및 머신 러닝 도구 상자의 일부로 제공되는 [샘플 데이터셋](https://www.mathworks.com/help/stats/sample-data-sets.html) 목록에 포함되어 있습니다:


```matlab
load fisheriris.mat
gscatter(meas(:,1),meas(:,2),species)
```

![figure_0.png](https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image52.png)

또는 Scikit-learn 라이브러리에서 [데이터셋](https://scikit-learn.org/stable/auto_examples/datasets/plot_iris_dataset.html)을 가져올 수도 있습니다 (아직 MATLAB 내부에서).

```matlab
iris_dataset = py.sklearn.datasets.load_iris()
```


```text:Output
iris_dataset = 
  Python Bunch with no properties.

    {'data': array([[5.1, 3.5, 1.4, 0.2],
           [4.9, 3. , 1.4, 0.2],
           [4.7, 3.2, 1.3, 0.2],
           [4.6, 3.1, 1.5, 0.2],
           [5. , 3.6, 1.4, 0.2],
           [5.4, 3.9, 1.7, 0.4],
            ...
           [6.2, 3.4, 5.4, 2.3],
           [5.9, 3. , 5.1, 1.8]]), 
           'target': array([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
           0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
           0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
           1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
           1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
           2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
           2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2]), 'frame': None, 'target_names': array(['setosa', 'versicolor', 'virginica'], dtype='<U10'), 'DESCR': '...', 'feature_names': ['sepal length (cm)', 'sepal width (cm)', 'petal length (cm)', 'petal width (cm)'], 'filename': 'iris.csv', 'data_module': 'sklearn.datasets.data'}

```

Scikit-learn 데이터셋은 [Bunch 객체](https://scikit-learn.org/stable/modules/generated/sklearn.utils.Bunch.html)로 반환됩니다. MATLAB 내부에서 직접 Python 모듈 문서에 액세스할 수 있습니다:

 ![image_0.png](https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image53.png)

이 데이터셋은 MATLAB로 struct 형태로 전달할 수 있습니다.

```matlab
struct(iris_dataset)
```


```text:Output
ans = 
             data: [1x1 py.numpy.ndarray]
           target: [1x1 py.numpy.ndarray]
            frame: [1x1 py.NoneType]
     target_names: [1x1 py.numpy.ndarray]
            DESCR: [1x2782 py.str]
    feature_names: [1x4 py.list]
         filename: [1x8 py.str]
      data_module: [1x21 py.str]

```

```matlab
X_np = iris_dataset{'data'}
```


```text:Output
X_np = 
  Python ndarray:

    5.1000    3.5000    1.4000    0.2000
    4.9000    3.0000    1.4000    0.2000
    4.7000    3.2000    1.3000    0.2000
    4.6000    3.1000    1.5000    0.2000
    ...
    5.9000    3.0000    5.1000    1.8000

    Use details function to view the properties of the Python object.

    Use double function to convert to a MATLAB array.

```


```matlab
X_ml = double(X_np)
```


```text:Output
X_ml = 150x4    
    5.1000    3.5000    1.4000    0.2000
    4.9000    3.0000    1.4000    0.2000
    4.7000    3.2000    1.3000    0.2000
    4.6000    3.1000    1.5000    0.2000
    5.0000    3.6000    1.4000    0.2000
    5.4000    3.9000    1.7000    0.4000
    4.6000    3.4000    1.4000    0.3000
    5.0000    3.4000    1.5000    0.2000
    4.4000    2.9000    1.4000    0.2000
    4.9000    3.1000    1.5000    0.1000

```


```matlab
X = X_ml(:,1:2)
```


```text:Output
X = 150x2    
    5.1000    3.5000
    4.9000    3.0000
    4.7000    3.2000
    4.6000    3.1000
    5.0000    3.6000
    5.4000    3.9000
    4.6000    3.4000
    5.0000    3.4000
    4.4000    2.9000
    4.9000    3.1000

```


```matlab
y = iris_dataset{'target'}
```


```text:Output
y = 
  Python ndarray:

   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2

    Use details function to view the properties of the Python object.

    Use int64 function to convert to a MATLAB array.

```


```matlab
% y_ml = int64(y)
```
일단 Python의 ndarray를 MATLAB 데이터 형식으로 번역하지는 않겠습니다. 대신 Python의 멋진 기능을 사용하여 서수값의 목록을 범주형 종(species)의 목록으로 번역합니다. 이러한 기능은 [pyrun](https://www.mathworks.com/help/matlab/ref/pyrun.html) 몇 번의 호출로 MATLAB에서 활용할 수 있습니다.

```matlab
pyrun('dict = {0: "setosa",1: "versicolor", 2: "virginica"}')
s = pyrun('species = [dict[i] for i in y]','species',y = y) % y를 입력으로 전달하고 종(species)을 출력으로 얻습니다.
```

```text:Output
s = 
  Python list with values:

    ['setosa', 'setosa', 'setosa', 'setosa', 
    ...
    'versicolor', 'versicolor', 'versicolor', 
    ...
    'virginica', 'virginica', 'virginica']

    Use string, double or cell function to convert to a MATLAB array.

```

마지막으로, Python 리스트를 [MATLAB 범주형 변수](https://www.mathworks.com/help/matlab/categorical-arrays.html)로 가져올 수 있습니다:

```matlab
categoricalSpecies = categorical(cell(s));
```

이제 `categoricalSpecies`는 MATLAB에서 사용할 수 있는 범주형 변수가 됩니다.


```matlab
s = string(s);
species = categorical(s)
```

```text:Output
species = 1x150 categorical    
setosa       setosa       setosa       setosa       setosa       setosa       setosa       setosa       setosa       setosa       setosa       setosa       setosa       setosa       setosa       setosa       setosa       setosa       setosa       setosa       setosa       setosa       setosa       setosa       setosa       setosa       setosa       setosa       setosa       setosa       

```

Python에서 전처리를 수행하는 또 다른 접근 방식은 [`pyrunfile`](https://www.mathworks.com/help/matlab/ref/pyrunfile.html)을 사용하여 수행할 수 있습니다.


```matlab
[X,y,species] = pyrunfile('iris_data.py',{'Xl','y','species'})
```


```text:Output
X = 
  Python list with values:

    [[5.1, 3.5], [4.9, 3.0], 
    ... [5.9, 3.0]]

    Use string, double or cell function to convert to a MATLAB array.

y = 
  Python ndarray:

   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2

    Use details function to view the properties of the Python object.

    Use int64 function to convert to a MATLAB array.

species = 
  Python list with values:

    ['setosa', 'setosa', 'setosa', 'setosa', 
    ...
    'versicolor', 'versicolor', 'versicolor', 
    ...
    'virginica', 'virginica', 'virginica']

    Use string, double or cell function to convert to a MATLAB array.

```

다음은 Python 스크립트의 내용입니다:

<u>iris_data.py</u>

```python
from sklearn import datasets
iris = datasets.load_iris()

X = iris.data[:, :2]  # 처음 두 개의 특성만 사용합니다 (꽃받침)
Xl = X.tolist()
y = iris.target
dict = {0: "setosa", 1: "versicolor", 2: "virginica"}
species = [dict[i] for i in y]
```

이 경우, 우리는 Numpy 배열 대신 리스트의 리스트를 검색하고 있습니다. 이는 수동 데이터 마샬링이 필요합니다.

```matlab
Xc = cell(X)'
```

| |1|
|:--:|:--:|
|1|1x2 list|
|2|1x2 list|
|3|1x2 list|
|4|1x2 list|
|5|1x2 list|
...


```matlab
Xc1 = cell(Xc{1})
```

| |1|2|
|:--:|:--:|:--:|
|1|5.1000|3.5000|


```matlab
cell2mat(Xc1)
```


```text:Output
ans = 1x2    
    5.1000    3.5000

```

이전 단계는 도우미 함수 `dataprep`에 포함되어 있습니다 (라이브 스크립트의 끝에):

```matlab
function Xp = dataprep(X)
  Xc = cell(X)';
  Xcc = cellfun(@cell,Xc,'UniformOutput',false);
  Xcm = cellfun(@cell2mat,Xcc,'UniformOutput',false);
  Xp = cell2mat(Xcm);
end
```

```matlab
X_ml = dataprep(X);
y_ml = double(y);
s = string(species);
species = categorical(s);
```

데이터 전송을 포함하지 않는 다른 접근 방식은 Python에서 전처리를 수행하고 결과를 [Parquet 파일](https://www.mathworks.com/help/matlab/parquet-files.html)로 저장하는 것입니다.


```matlab
pyrunfile('iris_data_save.py')
```

그런 다음, Parquet 파일을 직접 테이블로 MATLAB에 로드할 수 있습니다.

```matlab
T = parquetread("iris.parquet")
```

| |lenght|width|species|
|:--:|:--:|:--:|:--:|
|1|5.1000|3.5000|"setosa"|
|2|4.9000|3|"setosa"|
|3|4.7000|3.2000|"setosa"|
|4|4.6000|3.1000|"setosa"|
|5|5|3.6000|"setosa"|
|6|5.4000|3.9000|"setosa"|
|7|4.6000|3.4000|"setosa"|
|8|5|3.4000|"setosa"|
|9|4.4000|2.9000|"setosa"|
|10|4.9000|3.1000|"setosa"|
|11|5.4000|3.7000|"setosa"|
|12|4.8000|3.4000|"setosa"|
|13|4.8000|3|"setosa"|
|14|4.3000|3|"setosa"|


Scikit-Learn의 Logistic Regression 모델 및 그의 fit 및 predict 메서드를 직접 호출할 수 있습니다.

```matlab
model = py.sklearn.linear_model.LogisticRegression();
model = model.fit(X,y); % 객체 참조를 통해 전달
y2 = model.predict(X);
y2_ml = double(y2);
confusionchart(y_ml,y2_ml)
```

이제 Scikit-Learn 모델을 래퍼 모듈을 통해 호출할 수 있습니다.


```matlab
model = py.iris_model.train(X,y);
y2 = py.iris_model.predict(model, X)
```


```text:Output
y2 = 
  Python ndarray:

   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   2   2   2   1   2   1   2   1   2   1   1   1   1   1   1   2   1   1   1   1   1   1   1   1   2   2   2   2   1   1   1   1   1   1   1   2   2   1   1   1   1   1   1   1   1   1   1   1   1   1   2   1   2   2   2   2   1   2   2   2   2   2   2   1   1   2   2   2   2   1   2   1   2   1   2   2   1   1   2   2   2   2   2   2   1   2   2   2   1   2   2   2   1   2   2   2   1   2   2   1

    Use details function to view the properties of the Python object.

    Use int64 function to convert to a MATLAB array.

```

학습 세트를 기반으로 한 모델의 정밀도:

```matlab
sum(y_ml == y2)/length(y_ml)
```

```text:Output
ans = 0.8200
```

또는 MATLAB에서 다양한 분류 모델을 훈련할 수도 있습니다. 다양한 머신러닝 방법에 대해 익숙하지 않다면 앱을 사용하여 다양한 유형의 모델 결과를 간단히 시도해볼 수 있습니다:

```matlab
classificationLearner(X_ml,species)
```

이를 통해 모델의 결과를 쉽게 시각화하고 평가할 수 있습니다.

## 5.2. MATLAB에서 TensorFlow 호출하기

TensorFlow를 사용하는 방법을 소개하겠습니다. [시작 가이드 튜토리얼](https://www.tensorflow.org/tutorials/keras/classification)을 통해 진행해보겠습니다:

![image_0.png](https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image56.png)

이 가이드에서는 10개의 카테고리에 속하는 70,000개의 흑백 이미지를 포함하는 [Fashion MNIST](https://github.com/zalandoresearch/fashion-mnist) 데이터셋을 사용합니다.

이 이미지들은 낮은 해상도(28 x 28 픽셀)에서 개별 의류 아이템을 나타냅니다.

이 예제는 Zalando에서 제작한 것으로 MIT 라이선스에 따릅니다.

먼저, **TensorFlow를 로드**하고 설치된 TensorFlow 버전을 확인해보겠습니다:


```matlab
tf = py.importlib.import_module('tensorflow');
pyrun('import tensorflow as tf; print(tf.__version__)')
```


```text:Output
2.8.0
```

그런 다음 **데이터셋을 가져오겠습니다**.

```matlab
fashion_mnist = tf.keras.datasets.fashion_mnist
```

```text:Output
fashion_mnist = 
  Python module with properties:

    load_data: [1x1 py.function]

    <module 'keras.api._v2.keras.datasets.fashion_mnist' from 'C:\\Users\\ydebray\\AppData\\Local\\WPy64-39100\\python-3.9.10.amd64\\lib\\site-packages\\keras\\api\\_v2\\keras\\datasets\\fashion_mnist\\__init__.py'>

```


```matlab
train_test_tuple = fashion_mnist.load_data();
```


그리고 **훈련 및 테스트용 이미지와 레이블을 따로 저장**하겠습니다.

[Python 튜플을 MATLAB에서 인덱싱](https://www.mathworks.com/help/matlab/matlab_external/pythontuplevariables.html)할 때 중괄호를 사용합니다: `pytuple{1}`

(MATLAB은 1부터 시작하는 인덱스를 사용하므로 Python과 달리 주의해야 합니다)



```matlab
% ND array containing gray scale images (values from 0 to 255)
train_images = train_test_tuple{1}{1}; 
test_images = train_test_tuple{2}{1};
% values from 0 to 9: can be converted as uint8
train_labels = train_test_tuple{1}{2};
test_labels = train_test_tuple{2}{2}; 
```

MATLAB에서 클래스 목록을 직접 정의합니다:

```matlab
class_names = ["T-shirt/top", "Trouser", "Pullover", "Dress", "Coat", "Sandal", "Shirt", "Sneaker", "Bag", "Ankle boot"];
```


```text:Output
class_names = 1x10 string    
"T-shirt/top""Trouser"    "Pullover"   "Dress"      "Coat"       "Sandal"     "Shirt"      "Sneaker"    "Bag"        "Ankle boot" 

```

만약 MATLAB에서 위의 목록에서 훈련 레이블의 인덱스를 사용하려면 [0:9] 범위를 [1:10] 범위로 변경해야 합니다.

```matlab
tl = uint8(train_labels)+1; % [0:9] 범위를 [1:10] 범위로 변경
l = length(tl)
```


```text:Output
l = 60000
```

다음은 훈련 세트에 60,000개의 이미지가 있으며 각 이미지가 28 x 28 픽셀로 표시됨을 나타냅니다.

```matlab
train_images_m = uint8(train_images);
size(train_images_m)
```

```text:Output
ans = 1x3    
       60000          28          28

```

단일 이미지의 크기를 변경하려면 `reshape` 함수를 사용합니다:

```matlab
size(train_images_m(1,:,:))
```


```text:Output
ans = 1x3    
     1    28    28

```


```matlab
size(reshape(train_images_m(1,:,:),[28,28]))
```


```text:Output
ans = 1x2    
    28    28

```


데이터셋을 **탐색하도록 라이브 스크립트에 라이브 컨트롤을 추가**할 수 있습니다.

![image_1](https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image57.png)

```matlab
i = 42;
img = reshape(train_images_m(i,:,:),[28,28]);
imshow(img)
title(class_names(tl(i)))
```

![figure_0](https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image58.png)

신경망을 훈련하기 전에 데이터를 **전처리**해야 합니다.

만약 훈련 데이터 세트의 첫 번째 이미지를 살펴보면, 픽셀 값이 0부터 255 사이의 범위에 있다는 것을 알 수 있습니다:

```matlab
train_images = train_images / 255;
test_images = test_images / 255;
```

마지막으로, tf_helper 파일 또는 모듈에서 지정한 함수로 **모델을 구축하고 훈련**할 수 있습니다:

```matlab
model = py.tf_helper.build_model();
```

모델의 아키텍처를 확인하려면 셀 배열에서 레이어를 검색할 수 있습니다:


```matlab
cell(model.layers)
```

| |1|2|3|
|:--:|:--:|:--:|:--:|
|1|1x1 Flatten|1x1 Dense|1x1 Dense|


```matlab
py.tf_helper.compile_model(model);
py.tf_helper.train_model(model,train_images,train_labels) 
```


```text:Output
Epoch 1/10

   1/1875 [..............................] - ETA: 12:59 - loss: 159.1949 - accuracy: 0.2500
  39/1875 [..............................] - ETA: 2s - loss: 52.8977 - accuracy: 0.5256    
  76/1875 [>.............................] - ETA: 2s - loss: 34.8739 - accuracy: 0.6049
 113/1875 [>.............................] - ETA: 2s - loss: 28.4213 - accuracy: 0.6350
 157/1875 [=>............................] - ETA: 2s - loss: 22.9735 - accuracy: 0.6616
 194/1875 [==>...........................] - ETA: 2s - loss: 20.3405 - accuracy: 0.6740
 229/1875 [==>...........................] - ETA: 2s - loss: 18.3792 - accuracy: 0.6861
 265/1875 [===>..........................] - ETA: 2s - loss: 16.7848 - accuracy: 0.6943

 ...
```

테스트 데이터 세트에서 모델의 성능을 평가하여 **모델을 평가**합니다.

```matlab
test_tuple = py.tf_helper.evaluate_model(model,test_images,test_labels)
```


```text:Output
313/313 - 0s - loss: 0.5592 - accuracy: 0.8086 - 412ms/epoch - 1ms/step
test_tuple = 
  Python tuple with values:

    (0.5592399835586548, 0.8086000084877014)

    Use string, double or cell function to convert to a MATLAB array.

```


```matlab
test_acc = test_tuple{2}
```


```text:Output
test_acc = 0.8086
```


테스트 데이터 세트의 첫 번째 이미지에 대해 **모델을 테스트**해보세요:


```matlab
test_images_m = uint8(test_images);
prob = py.tf_helper.test_model(model,py.numpy.array(test_images_m(1,:,:)))
```


```text:Output
prob = 
  Python ndarray:

    0.0000    0.0000    0.0000    0.0000    0.0000    0.0002    0.0000    0.0033    0.0000    0.9965

    Use details function to view the properties of the Python object.

    Use single function to convert to a MATLAB array.

```


```matlab
[argvalue, argmax] = max(double(prob))
```


```text:Output
argvalue = 0.9965
argmax = 10
```


```matlab
imshow(reshape(test_images_m(1,:,:),[28,28])*255)
title(class_names(argmax))
```


![](https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image59.png)


## 5.3. MATLAB에서 TensorFlow 모델 가져오기

[TensorFlow 및 ONNX 모델 가져오기/내보내기 기능](https://blogs.mathworks.com/deep-learning/2022/03/18/importing-models-from-tensorflow-pytorch-and-onnx/)을 설명하기 위해 자율 주행 사용 사례 주변의 작업 흐름을 살펴보겠습니다.

![](https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image60.png)

데이터는 Udacity의 간단한 [오픈 소스 주행 시뮬레이터](https://github.com/udacity/self-driving-car-sim)에서 생성됩니다.

그리고 모델은 NVIDIA의 [자율 주행을 위한 엔드-투-엔드 학습](https://arxiv.org/pdf/1604.07316.pdf)에 대한 실제 실험에서 가져왔습니다.

![](https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image61.png)
![](https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image62.png)

신경망의 입력은 카메라에서 온 이미지이고 출력은 조향 각도를 예측하는 것입니다(-1부터 1까지).

이 문제를 왼쪽에서 오른쪽으로 5개의 클래스로 단순화하겠습니다.

*(선택 사항)* CPU에서 훈련에 4개의 워커를 사용하기 위해 병렬 풀을 설정합니다.

```matlab
p = gcp('nocreate'); % 풀이 없으면 새로 생성하지 않음.
if isempty(p)
   parpool()
else
    poolsize = p.NumWorkers
end
```

UDACITY 시뮬레이터에서 생성된 이미지 위치와 조향 각도의 참값이 포함된 CSV 파일을 가져옵니다.

```matlab
filename = "driving_log.csv";
drivinglog = import_driving_log(filename);
drivinglog = drivinglog(2:end, :);
```

| |VarName1|center|left|right|steering|throttle|reverse|speed|
|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
|1|0|"center_2021_04_25_1...|"left_2021_04_25_11_...|"right_2021_04_25_11...|0|0|0|0|
|2|1|"center_2021_04_25_1...|"left_2021_04_25_11_...|"right_2021_04_25_11...|0|0|0|0|
|3|2|"center_2021_04_25_1...|"left_2021_04_25_11_...|"right_2021_04_25_11...|0|0|0|0|
|4|3|"center_2021_04_25_1...|"left_2021_04_25_11_...|"right_2021_04_25_11...|0|0|0|0|
|5|4|"center_2021_04_25_1...|"left_2021_04_25_11_...|"right_2021_04_25_11...|0|0|0|0|

**데이터 준비**

조향 각도의 범위를 분석하여 최적의 클래스 값을 찾습니다.

```matlab
figure;
histogram(drivinglog.steering);
title("Original steering angle distribution");
```

![](https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image63.png)

`discretize`를 사용하여 조향 각도를 이산적인 구간으로 그룹화합니다.

```matlab
steeringLimits = [-1 -0.5 -0.05 0 0.05 0.5 1];
steeringClasses = discretize(drivinglog.steering, steeringLimits, 'categorical');
classNames = categories(steeringClasses);
```

0도에 가까운 각도를 나타내는 두 개의 구간을 병합합니다.


``` matlab
steeringClasses = mergecats(steeringClasses,["[-0.05, 0)","[0, 0.05)"], "0.0");
histogramClasses = histogram(steeringClasses);
title("Angle distribution discretized (5 categories)");
```


![](https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image64.png)

**이미지 데이터 스토어 생성 및 데이터 균형 조정 (언더샘플링)**

이전 히스토그램에서 데이터셋이 매우 불균형함을 보여줍니다. `countEachLabel`을 사용하여 각 클래스의 인스턴스 수를 확인합니다.

```matlab
imds = imageDatastore("sim_data/"+drivinglog.center,"Labels", steeringClasses);
countEachLabel(imds)
```

| |Label|Count|
|:--:|:--:|:--:|
|1|[-1, -0.5)|288|
|2|[-0.5, -0.05)|611|
|3|0|6093|
|4|[0.05, 0.5)|679|
|5|[0.5,1]|264|

균형이 맞지 않은 클래스에서 유지할 샘플 수와 이러한 샘플을 무작위로 선택합니다.

```matlab
maxSamples = 800;
countLabel = countEachLabel(imds);
[~, unbalancedLabelIdx] = max(countLabel.Count);
unbalanced = imds.Labels == countLabel.Label(unbalancedLabelIdx);
idx = find(unbalanced);
randomIdx = randperm(numel(idx));
downsampled = idx(randomIdx(1:maxSamples));
retained = [find(~unbalanced) ; downsampled];
imds = subset(imds, retained');
histogram(imds.Labels)
```

![](https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image65.png)

**데이터셋을 학습, 검증 및 테스트로 분리**

데이터 중 90%를 학습에, 나머지를 테스트 및 검증에 사용하기 위해 추출합니다.

``` matlab
[imdsTrain, imdsValid,imdsTest] = splitEachLabel(imds, 0.9, 0.05, 0.05);
```

**이미지 전처리**

이미지를 크기 조정하고 YCbCr 색 공간으로 변환하여 전처리합니다.

```matlab
trainData = transform(imdsTrain, @imagePreprocess, "IncludeInfo", true);
testData = transform(imdsTest, @imagePreprocess, "IncludeInfo", true);
valData = transform(imdsValid, @imagePreprocess, "IncludeInfo", true);
imds_origI = imdsTrain.read;
imds_newI = trainData.read{1};
subplot(211), imshow(imds_origI), title("imds의 원본 이미지")
subplot(212), imshow(imds_newI), title("imds의 전처리된 이미지")
```

![](https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image66.png)

**모델 수정:**

Keras 모델에서 네트워크를 로드하고 [Deep Network Designer](https://www.mathworks.com/help/deeplearning/gs/get-started-with-deep-network-designer.html)를 사용하여 표시합니다.

모델을 [SavedModel 형식](http://www.tensorflow.org/tutorials/keras/save_and_load#save_the_entire_model)으로 저장하고 가져오는 것이 권장되며 (경고 메시지가 표시될 수 있음), HDF5 형식보다 더 우수한 결과를 얻을 수 있습니다.

``` matlab
layers = importKerasLayers("tf_model.h5")
```

```text:Output
layers = 
  20x1 Layer array with layers:

     1   'conv2d_5_input'            Image Input         66x200x3 images
     2   'conv2d_5'                  2-D Convolution     24 5x5 convolutions with stride [2  2] and padding [0  0  0  0]
     3   'conv2d_5_elu'              ELU                 ELU with Alpha 1
     4   'conv2d_6'                  2-D Convolution     36 5x5 convolutions with stride [2  2] and padding [0  0  0  0]
     5   'conv2d_6_elu'              ELU                 ELU with Alpha 1
     6   'conv2d_7'                  2-D Convolution     48 5x5 convolutions with stride [2  2] and padding [0  0  0  0]
     7   'conv2d_7_elu'              ELU                 ELU with Alpha 1
     8   'conv2d_8'                  2-D Convolution     64 3x3 convolutions with stride [1  1] and padding [0  0  0  0]
     9   'conv2d_8_elu'              ELU                 ELU with Alpha 1
    10   'conv2d_9'                  2-D Convolution     64 3x3 convolutions with stride [1  1] and padding [0  0  0  0]
    11   'conv2d_9_elu'              ELU                 ELU with Alpha 1
    12   'flatten'                   Keras Flatten       Flatten activations into 1-D assuming C-style (row-major) order
    13   'dense'                     Fully Connected     100 fully connected layer
    14   'dense_elu'                 ELU                 ELU with Alpha 1
    15   'dense_1'                   Fully Connected     50 fully connected layer
    16   'dense_1_elu'               ELU                 ELU with Alpha 1
    17   'dense_2'                   Fully Connected     10 fully connected layer
    18   'dense_2_elu'               ELU                 ELU with Alpha 1
    19   'dense_3'                   Fully Connected     1 fully connected layer
    20   'RegressionLayer_dense_3'   Regression Output   mean-squared-error
```


``` matlab
deepNetworkDesigner(layers)
```

회귀에 사용된 마지막 레이어를 제거하고 5개 클래스로 분류하는 레이어를 추가합니다 (그런 다음 넷을 **layers_1**로 내보냄).

![](https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image67.png)

*(프로그래밍 대체 방법)* 회귀에 사용된 레이어를 제거하고 5개 클래스로 분류하는 레이어를 추가합니다.

``` matlab
netGraph = layerGraph(layers);
clf; plot(netGraph)
```

![](https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image68.png)

``` matlab
classificationLayers = [fullyConnectedLayer(5,"Name","dense_3"), ...
                        softmaxLayer("Name","softmax"), ...
                        classificationLayer("Name","classoutput")];
netGraph = removeLayers(netGraph, {'dense_3', 'RegressionLayer_dense_3'});
netGraph = addLayers(netGraph,classificationLayers);
layers_1 = netGraph.Layers
```


```text:Output
layers_1 = 
  21x1 Layer array with layers:

     1   'conv2d_5_input'   Image Input             66x200x3 images
     2   'conv2d_5'         2-D Convolution         24 5x5 convolutions with stride [2  2] and padding [0  0  0  0]
     3   'conv2d_5_elu'     ELU                     ELU with Alpha 1
     4   'conv2d_6'         2-D Convolution         36 5x5 convolutions with stride [2  2] and padding [0  0  0  0]
     5   'conv2d_6_elu'     ELU                     ELU with Alpha 1
     6   'conv2d_7'         2-D Convolution         48 5x5 convolutions with stride [2  2] and padding [0  0  0  0]
     7   'conv2d_7_elu'     ELU                     ELU with Alpha 1
     8   'conv2d_8'         2-D Convolution         64 3x3 convolutions with stride [1  1] and padding [0  0  0  0]
     9   'conv2d_8_elu'     ELU                     ELU with Alpha 1
    10   'conv2d_9'         2-D Convolution         64 3x3 convolutions with stride [1  1] and padding [0  0  0  0]
    11   'conv2d_9_elu'     ELU                     ELU with Alpha 1
    12   'flatten'          Keras Flatten           Flatten activations into 1-D assuming C-style (row-major) order
    13   'dense'            Fully Connected         100 fully connected layer
    14   'dense_elu'        ELU                     ELU with Alpha 1
    15   'dense_1'          Fully Connected         50 fully connected layer
    16   'dense_1_elu'      ELU                     ELU with Alpha 1
    17   'dense_2'          Fully Connected         10 fully connected layer
    18   'dense_2_elu'      ELU                     ELU with Alpha 1
    19   'dense_3'          Fully Connected         5 fully connected layer
    20   'softmax'          Softmax                 softmax
    21   'classoutput'      Classification Output   crossentropyex
```

**모델 훈련:** (여기서는 CPU를 사용하지만, GPU에서 속도를 높이는 것을 권장합니다)

``` matlab
initialLearnRate = 0.001;
maxEpochs = 30;
miniBatchSize = 100;
options = trainingOptions("adam", ...
    "MaxEpochs",maxEpochs, ...
    "InitialLearnRate",initialLearnRate, ...
    "Plots","training-progress",  ...
    "ValidationData",valData, ...
    "ValidationFrequency",10, ...
    "LearnRateSchedule","piecewise", ...
    "LearnRateDropPeriod",10, ...
    "LearnRateDropFactor",0.5, ...
    "ExecutionEnvironment","parallel",...
    "Shuffle","every-epoch");
net = trainNetwork(trainData, layers_1, options);
```

![](https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image69.png)

**모델 저장:** 새로 훈련된 네트워크를 MAT 형식으로 저장합니다.

```matlab
model_name = "net-class-30-1e-4-drop10-0_5"; % classification-epochs-learning_rate-drop_period-drop_factor
save(model_name + ".mat", "net")
```

ONNXNetwork 형식으로 내보냅니다.

```matlab
exportONNXNetwork(net, model_name + ".onnx")
```

**모델 테스트:**

테스트 데이터셋을 사용하여 조향 각도의 예측 값과 실제 값의 그래프를 그립니다.


``` matlab
model_name = "net-class-30-1e-4-drop10-0_5"; % classification-epochs-learning_rate-drop_period-drop_factor
load(model_name+".mat","net")
predSteering = classify(net, testData);
figure
startTest = 80;
endTest = 100;
plot(predSteering(startTest:endTest), 'r*', "MarkerSize",10)
hold on
plot(imdsTest.Labels(startTest:endTest), 'b*')
legend("Predictions", "Actual")
hold off
```

![](https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image70.png)

**혼동 행렬 표시:**

혼동 행렬을 표시합니다.

```matlab
confMat = confusionmat(imdsTest.Labels, predSteering);
confusionchart(confMat)
```

**테스트 이미지와 예측된 라벨 표시:**

테스트 이미지와 예측된 라벨, 그리고 실제 라벨을 표시합니다.

```matlab
numberImages = length(imdsTest.Labels);
i = 42;
img = readimage(imdsTest, i);
imshow(img), title(char(imdsTest.Labels(i)) + "/" + char(predSteering(i)));
```
![](https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-08-21-MATLAB_with_Python/image72.png)
 
**Helper Functions**


``` matlab
function drivinglog = import_driving_log(filename, dataLines)
%IMPORTFILE Import data from a text file
%  DRIVINGLOG = IMPORTFILE(FILENAME) reads data from text file FILENAME
%  for the default selection.  Returns the data as a table.
%
%  DRIVINGLOG = IMPORTFILE(FILE, DATALINES) reads data for the specified
%  row interval(s) of text file FILENAME. Specify DATALINES as a
%  positive scalar integer or a N-by-2 array of positive scalar integers
%  for dis-contiguous row intervals.
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 28-May-2021 21:31:34
%% Input handling
% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [1, Inf];
end
%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 8);
% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";
% Specify column names and types
opts.VariableNames = ["VarName1", "center", "left", "right", "steering", "throttle", "reverse", "speed"];
opts.VariableTypes = ["double", "string", "string", "string", "double", "double", "double", "double"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Specify variable properties
opts = setvaropts(opts, ["center", "left", "right"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["center", "left", "right"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, ["VarName1", "steering", "throttle", "reverse", "speed"], "ThousandsSeparator", ",");
% Import the data
drivinglog = readtable(filename, opts);
end
```


 

``` matlab
function [dataOut, info] = imagePreprocess(dataIn, info)
imgOut = dataIn(60:135, :, :);
imgOut = rgb2ycbcr(imgOut);
imgOut = imresize(imgOut, [66 200]);
dataOut = {imgOut, info.Label};
end
```