---
title: (번역) 입력 인수의 기본값 설정과 검증 방법 - Argument를 사용하는 경우
published: true
permalink: function_arguments.html
summary: "함수 입력 인수에 대한 새로운 검증 방법인 Argument 소개"
tags: [번역, 입력 체크, 디폴트 인자]
identifier: function_arguments
sidebar: false
toc: true
---

본 포스트의 원문은 아래의 URL에서 확인하실 수 있습니다. 본 포스트는 원작자에게 동의를 구한 뒤 한국어로 번역하였습니다.

- [【MATLAB】入力引数のデフォルト値設定と検証方法: Arguments を使う場合](https://qiita.com/eigs/items/5d4f93464eb6506bead6)

# 시작하면서

MATLAB에서 디폴트 입력 인수를 설정하기 위해선 `nargin`을 사용할 수 있지만 꽤나 어려운 편입니다[^1].

[^1]: nargin을 사용한 방법에 관해선 <a href = "https://qiita.com/kenichi-hamaguchi">@kenichi-hamaguchi</a> 님의 포스팅인 <a href= "https://qiita.com/kenichi-hamaguchi/items/d4e451e67ebf380a48c6">【MATLAB】디폴트 인수의 설정 방법</a>에서 구체적인 방법과 예시를 소개하고 있으니 부디 참고 바랍니다.

**그러나 그것도 R2019a까지!**

R2019b부터 사용할 수 있는 Arguments(자세한 사항은 [여기](https://kr.mathworks.com/help/matlab/matlab_prog/argument-validation-functions.html?s_eid=PSM_29435))를 사용하면 상당히 편리하기 때문에 소개하고자 합니다.

# 뭐가 좋은거야?

1. 입력 인수의 디폴트 값 설정이 편해집니다.
2. 입력 인수의 검증도 꽤 편해집니다.
3. 함수 사용 시 옵션 선택이 좀 멋져집니다.

각각을 아래에서 소개합니다.

# 사용 환경

* MATLAB R2019b 이상

MathWorks의 브로그에서도 몇 가지 사용예시가 소개되어 있기 때문에 구경해주세요.

* [마음에 드는 R2019b 신기능 - 입력 인수 검증](https://blogs.mathworks.com/japan-community/2019/11/05/favorite-r2019b-feature/?s_eid=PSM_29435&from=kr)
* [입력인수 검증 ~ 숨겨진 편리한 기능](https://blogs.mathworks.com/japan-community/2019/11/27/function-arguments-part2/?s_eid=PSM_29435&from=kr)

# 사용법: 기본 구문

기본 구문은 (그림은 [공식 페이지](https://kr.mathworks.com/help/matlab/matlab_prog/function-argument-validation-1.html#mw_7d29b198-98bc-4268-93a2-d74504d2b023?s_eid=PSM_29435)에서 가져왔습니다.)

<img src = "https://kr.mathworks.com/help/matlab/matlab_prog/fav_syntax.png">

와 같으며, 네 가지의 요소가 있습니다. 입력인수명 (`inputArg`)와 그 뒤에,

* 상정된 변수의 배열 크기 (Size)
* double 형인지 어떤지 같은 클래스 이름 (Class)
* 그리고 검증에 사용하는 함수 (Functions)

그리고 마지막으로 `defaultValue` 기본값을 설정합니다. 전부 쓸 필요는 없고 필요한 것만 쓰면 OK입니다.

# 1. 입력인수의 디폴트 값 설정이 편합니다.

우선은 디폴트 값 설정부터 볼까요. 위에서 본 `defaultValue`를 쓰겠습니다.

```matlab
function c = myFunction(a,b)

arguments
    a = 1
    b = 2
end

c = a+b;
end
```

이런식으로 두고 입력없이 실행하거나 입력 1개만으로 실행하면 아래의 결과가 나오게 됩니다.

```
>> myFunction

ans =

     3
```
```
>> myFunction(10)

ans =

    12
```

생략한 인수는 디폴트값이 사용되고 있는 것을 알 수 있습니다.

# 2. 입력 인수의 검증도 편해집니다.

예를 들어 `a`는 스칼라 값이어야 한다면,

```matlab
function c = myFunction(a,b)

arguments
    a (1,1) = 1
    b = 2
end

c = a+b;
end
```

위 처럼 설정한다면, 스칼라값 이외 값이 입력된다면 에러가 반환됩니다. 테스트로 `1x2`의 벡터를 입력해보겠습니다.

```
>> myFunction([1,2])
Error using myFunction
 myFunction([1,2])
            ↑
Invalid argument at position 1. Value must be a scalar.
```

제대로 에러의 원인을 반환해주고 있습니다.

## 인수 검증 함수

몇 가지 입력값의 검증용 함수([인수 검증 함수 전체 보기](https://kr.mathworks.com/help/matlab/matlab_prog/argument-validation-functions.html?s_eid=PSM_29435))도 제공됩니다. 예를 들어 정수(`mustBeInteger`)가 아니면 안된다던가 실수(`mustBeReal`) 등등이 있습니다. 이런 저런 조합으로 검증을 할 수 있으면 이야기가 빠릅니다.

예를 들어 ... 입력은 정수여야 합니다, 라고 한다면,

```matlab
function c = myFunction(a,b)

arguments
    a (1,1) {mustBeInteger(a)} = 1
    b = 2
end

c = a+b;
end
```
```
>> myFunction(1.1)
Error using myFunction
 myFunction(1.1)
            ↑
Invalid argument at position 1. Value must be integer.
```

이런 식입니다. 검증함수는 `{}`로 둘러싸야합니다. 물론 두 가지 이상을 사용할 수도 있습니다.

```matlab
function c = myFunction(a,b)

arguments
    a (1,1) {mustBeInteger(a),mustBePositive(a)} = 1
    b = 2
end

c = a+b;
end
```

정수(`mustBeInteger`) 그리고 양수(`mustBePositive`)라는 조건으로 해보았습니다.

```
>> myFunction(-1)
Error using myFunction
 myFunction(-1)
            ↑
Invalid argument at position 1. Value must be positive.
```

## 더 복잡한 일을 해보고 싶은 경우

물론 준비된 검증함수 만으로는 부족한 경우도 있습니다.

예를 들어 이전 ["꿈틀꿈틀 움직이는 막대 그래프 Bar Chart Race를 그려보자: 실장편"](https://qiita.com/eigs/items/c1675e6dc6fd497e714a)에서 소개한 barChartRace 함수([Link to GitHub](https://github.com/minoue-xx/BarChartRaceAnimation/blob/master/function/barChartRace.m))에서

```matlab
arguments
    inputs {mustBeNumericTableTimetable(inputs)}
    options.Time (:,1) {mustBeTimeInput(options.Time,inputs)} = setDefaultTime(inputs)
    options.LabelNames {mustBeVariableLabels(options.LabelNames,inputs)} = setDefaultLabels(inputs)
    options.ColorGroups {mustBeVariableLabels(options.ColorGroups,inputs)} = setDefaultLabels(inputs)
    options.Position (1,4) {mustBeNumeric,mustBeNonzero} = get(0, 'DefaultFigurePosition')
    (중략)
```

라고 열심히 써서 사용하고 있고, `mustBeTimeInput`, `mustBeVariableLabels`는 직접 만든 검증용 함수입니다. `setDefaultTime`은 디폴트 값을 설정하는 함수로 만들었습니다.

각각의 함수는 여기 ([Link to GitHub](https://github.com/minoue-xx/BarChartRaceAnimation/tree/master/function/private))에 있습니다만, 예를 들면 `mustBeTimeInput`을 보게 되면,

```matlab
function mustBeTimeInput(arg, inputs)
% Custom validation function for Name-Pair Value 'Time'
% Copyright 2020 Michio Inoue

if ~(isnumeric(arg) || isdatetime(arg))
    error("The datatype must be numeric or datetime.");
end

if length(arg) ~= size(inputs,1)
    error("The length must be same as that of inputs ("...
        + num2str(size(inputs,1)) + ")");
end
end
```

입력 인수 `arg`는 `numeric` 혹은 `datetime` 형으로 거기에 추가해 필수로 있는 `inputs`과 같은 길이여야 한다는 조건을 가지고 있습니다.

### 초기값 설정도 까다롭게 해보고 싶은 경우

`setDefaultTime`도 `input`이 `timetable`형이라면 그 시각을 사용하지만 그렇지 않으면 ... 하는 형태로 정의하고 있습니다.

```matlab
function time = setDefaultTime(inputs)
% A function to generate the default values for 'Time'
% Copyright 2020 Michio Inoue

if isa(inputs,'timetable')
    time = inputs.Time;
else
    time = 1:size(inputs,1);
end
```

초기값 설정용 함수는 출력만 하면 무엇이라도 좋기 때문에, 예를 들어

```matlab
options.Position (1,4) {mustBeNumeric,mustBeNonzero} = get(0, 'DefaultFigurePosition')
```

는 `Position`(Figure의 property)에 지정된 것이 없다면 디폴트 값을 사용한다는 의도로 작성하였습니다.

# 3. 함수 사용 시 옵션 선택이 조금 멋져진다.

Live Editor에서 사용할 경우 이렇게 표시됩니다. 이게 직접 만든 함수라도 가능해집니다.

<img src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-07-05-function_arguments/argument_in_livescript.png">

위의 예에서는 기대한 입력 인수가 무엇인지, 디폴트 값 설정이 있는 경우에는 "선택 사항"(옵션)이라는 표시까지도 나오게 됩니다.

# Name-Value Pair (옵션)을 추가

함수 실행 시 사용하는 옵션 설정입니다. 특별히 용도는 없지만 ... `'Method'`도 취할 수 있도록 해보겠습니다.

```matlab
function c = myFunction(a,b,options)

arguments
    a (1,1) {mustBeInteger(a),mustBePositive(a)} = 1
    b = 2
    options.Method {mustBeMember(options.Method,{'linear','spline'})} = 'linear'
end

c = a+b;
disp(options.Method);
end
```

`options.Method`라는 형태로 취한 것은 함수 입력시에 Name-Value pairs (옵션)로써 리스트가 나오게 됩니다.

<img src=  "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-07-05-function_arguments/argument_in_livescript_option.png">

이 기능에서 개인적으로 마음에 들었던 것은, `mustBeMember`를 사용하는 경우입니다. `Method`는 `liner` 혹은 `spline` 밖에 안됩니다라고 검증하고 있습니다만, 이것이 검증할 때 뿐만 아니라 함수에 입력을 넣을 때에도 활약하게 됩니다.

<img src=  "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-07-05-function_arguments/argument_in_livescript_option2.png">

라고 하고 있는 것 처럼, 'Method'에서 요구하고 있는 것은 이것뿐입니다 라고 명시해주고 있습니다.

거기다, 위에서 소개한 `barChartRace.m`은 이런 느낌입니다.

<img src=  "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-07-05-function_arguments/barChartArgumentOptions.png">

# 마무리

Arguments를 사용해서 디폴트 인수 설정의 방법부터 입력값의 검증까지 소개해보았습니다.

"음, 솔직히 내가 사용하고 있는 함수에서 필요한 것은 아니지..."라고 생각합니다. 그러나, **1주일 전의 내가 만든 코드는 더 이상 내가 만든 코드가 아닌 셈이니까요.** 다른 사람에게도 사용해주셨으면 하는 게 있습니다. 에러의 원인을 필사적으로 찾은 결과 입력값의 상정이 잘못되었다는 것 뿐이라면 너무 슬플것 같으니까요.

물론 R2019a 이전에도 똑같은 것이 가능하지만, Arguments를 사용한 방법과 비교하면 힘든 편입니다.

* [마음에 드는 R2019b 신기능 - 입력 인수 검증](https://blogs.mathworks.com/japan-community/2019/11/05/favorite-r2019b-feature/?s_eid=PSM_29435&from=kr)
* [입력인수 검증 ~ 숨겨진 편리한 기능](https://blogs.mathworks.com/japan-community/2019/11/27/function-arguments-part2/?s_eid=PSM_29435&from=kr)

에서는 예전의 방법과 비교도 하고 있으므로 흥미가 있으신 분들은 부디 확인 바랍니다.