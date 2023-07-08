---
title: inline 함수에서 if-else문을 쓸 수 있을까? (a.k.a. 삼항 연산자 만들기)
published: true
permalink: if_else_with_inline_function.html
summary: "MATLAB inline 함수는 짧게 한줄로 써야하다보니 if-else 문을 도입하는 것은 어렵다. 그런데, varargin을 사용하면 가능하다?"
tags: [삼항 연산자, 인라인 함수, varargin]
identifier: if_else_with_inline_function
sidebar: false
toc: true
---

# 시작하면서

제목에서 보았겠지만 inline 함수를 이용해 최대한 압축적으로 if-else문을 를 만들 수 있다. 결과부터 보자면 아래와 같다.

```matlab
ternary = @(varargin) varargin{end - varargin{1}};
ternary(true,'yes','no') % 결과는 'yes'가 나온다.
ternary(false,'yes','no') % 결과는 'no'가 나온다.
```

이 사례는 아래의 MATLAB Answers(<a href = "https://kr.mathworks.com/matlabcentral/answers/299802-how-to-write-all-of-an-if-statement-in-a-single-lline" target = "_blank">링크</a>)에서도 답변해준 바 있다.

<a href = "https://kr.mathworks.com/matlabcentral/answers/299802-how-to-write-all-of-an-if-statement-in-a-single-lline" target = "_blank">
   <img src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-07-13-if_else_with_inline_function/ternary_example.png">
</a>

원하는 바가 충실히 작동함을 알 수 있다. 참고로 ternary는 항(項)이 세 개라는 뜻이다. 여기서는 condition, true일때의 출력물, false일 때의 출력물을 의미한다.

# inline 함수를 최대한 펼쳐보자

사실 위의 inline 함수를 한번에 이해하는 것은 어렵다.또, inline 함수는 디버깅이 어렵기 때문에 내용물을 잘 이해하기 위해서 일단 inline 함수를 일반적인 m-file 함수로 펼쳐놓고 각각의 내용물이 의미하는 바를 살펴보도록 하자.

```matlab
function out = func_ternary(varargin)
out = varargin{end - varargin{1}};
```

한 줄이 두줄 되었을 뿐 별 차이가 없어 보이지만 디버깅을 수행할 수 있게 되었다는 사실을 최대한 이용해봅시다. 커맨드 라인에서 아래의 명령어들으 수행해서 두 번째 라인에 디버깅 포인트를 걸고 `func_ternary`를 실행시켜보자.

```matlab
>> dbstop in func_ternary at 2; % func_ternary.m 파일에 들어가서 2번 라인에 breakpoint를 직접 걸어줘도 괜찮다.
>> func_ternary(true, 'yes', 'no');
```

그러면 `func_ternary` 함수에 대한 디버깅을 시작할 수 있게 된다. 여기서 핵심 포인트는 `varargin`이 무엇인지 이해하는 것이다.

<img src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-07-13-if_else_with_inline_function/debug_func_ternary.png">


## varargin 이란?

`varargin`은 여러개의 입력을 받으려고 하지면 총 몇 개의 입력이 들어올지 예상하기 어려울 때, 들어오는 입력 모두를 cell 타입 변수로 받아주는 입력 변수이다. `varargin`이라는 이름은 약속된 이름이므로 다른 이름을 사용할 수는 없다. (variable argument input의 줄임말인 것 같다.)

위 그림에서 볼 수 있듯이 이번 사례에서는 varargin이 세 개의 원소로 구성된 cell 타입 변수가 되었다.

```
{[1]}, {'yes'}, {'no'}
```

즉 `func_ternary(true, 'yes', 'no')`라고 명령했을 때 입력한 변수들이 들어가있다는 것을 알 수 있다.

## varargin{end - varargin{1}}의 의미

그렇다면 `ternary` 함수의 가장 핵심인 `varargin{end - varargin{1}}`을 해석해보자.

일단 `varargin{1}`이 없이 `varargin{end}`만 사용하는 경우를 생각해보자.

`varargin`은 {[1]}, {'yes'}, {'no'}의 세 가지 값을 가지는 cell 타입 변수이므로 `varargin{end}`는 무조건 `'no'`를 출력해줄 것이라는 것을 우선 생각할 수 있다. 그런데, `varargin{1}`은 true(1) 혹은 false(0)의 값 만을 가진다는 점을 생각해보았을 때, varargin{1}은 1 혹은 0이 된다는 것을 알 수 있다. 그러므로 첫 번째 입력이 treu 이면 `end - varargin{1}` 은 `end-1`과 같아지고 첫 번째 입력이 false 이면 `end-varargin{1}`은 `end-0`이 되는 것을 알 수 있다.

따라서, 첫 번째 입력이 `true`이면 `varargin{end-varargin{1}}`은 `varargin{end-1}`이 되고 그 말은 `'yes'`를 출력하는 것이다. 반대로 첫 번째 입력이 `false`이면 `varargin{end-varargin{1}}`은 `varargin{end-0}`이 되고 그 말은 `'no'`를 출력하는 것이다.

# if-elseif-else 문을 inline 함수로 만들 수도 있을까?

if-else문을 inline 함수로 만들었으니 if-else-else 문도 inline 함수로 만들 수 있을까 하는 생각이 들 수 있다. 이에 대해서는 아래와 같이 구현할 수 있다는 것을 알아냈다.

```matlab
iif = @(varargin) varargin{2 * find([varargin{1:2:end}], 1, 'first')}();
```

위 코드는 오래되어 가는 MathWorks 공식 블로그 포스팅 [Introduction to Functional Programming with Anonymous Functions, Part 1](https://blogs.mathworks.com/loren/2013/01/10/introduction-to-functional-programming-with-anonymous-functions-part-1/?from=kr#c8d04efb-1a2d-4c35-afff-dd52e6c660d2)에서 가져온 것이다. 이 외에도 기괴한(?) inline 함수에 대한 소개가 많기 때문에 한번 볼만하다.

위의 코드가 하는 일을 조금 쉽게 풀어쓰자면 아래와 같은 것이다.

```matlab
   [out1, out2, ...] = iif( if this,      then run this, ...
                            else if this, then run this, ...
                            ...
                            else,         then run this );
```

이 코드에서는 `varargin{1:2:end}`를 이용해 홀수번째 입력값들 중 `true`인 경우가 어디인지를 찾고자 한다. 그래서 `find` 함수를 이용했고 1과 'first'를 이용해 가장 먼저 true가 나오는 곳의 index가 몇 번인지 알아보는 것이다. 그리고 2를 곱해줌으로써 가장 먼저 true가 나온 곳의 그 다음번 명령문 "then run this" 부분을 실행 시키는 것이다. 여기서 가장 왼쪽에서 볼 수 있듯이 실행시킬 함수 또한 varargin을 통해 함수 핸들로 받아내고 소괄호를 또 오른쪽 외곽에 붙여서 함수로 작동할 수 있게 하는 것이다.

예를 들어 어떤 입력 `x`가 들어왔을 때 `inf` 값이 하나라도 있으면 에러를 띄워주고, 또 만약 `x`가 모두 0이면 `zeros(size(x))` 함수를 출력해주고 그 모두 해당이 안된다면 정규화 시켜주는 함수 `normalize`를 inline 함수로 정의할 수 있다. 이런 두 가지 이상의 연속적인 조건을 가지는 함수는 if-elseif-else 문으로 작성하는 것이 가장 바람직하지만 압축적으로 아래와 같이 inline 함수를 이용할 수도 있다는 것이다.

```matlab
normalize = @(x) iif( ~all(isfinite(x)), @() error('Must be finite!'), ...
                      all(x == 0),       @() zeros(size(x)), ...
                      true,              @() x/norm(x) );
```

테스트 해보면 아래와 같이 정상적으로 작동하는 것을 알 수 있다.

```
>> normalize([1,1,0])

ans =

    0.7071    0.7071         0
```

```
>> try normalize([0 inf 2]), catch err, disp(err.message); end

Must be finite!
```

```
>> normalize([0 0 0])

ans =

     0     0     0
```

# 참고

* [if statement - ternary operator in matlab - Stack Overflow](https://stackoverflow.com/questions/5594937/ternary-operator-in-matlab)
* [Introduction to Functional Programming with Anonymous Functions, Part 1](https://blogs.mathworks.com/loren/2013/01/10/introduction-to-functional-programming-with-anonymous-functions-part-1/?from=kr#c8d04efb-1a2d-4c35-afff-dd52e6c660d2)