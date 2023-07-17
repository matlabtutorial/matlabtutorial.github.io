---
title: (번역) polyfit 함수에 손을 대서 실행 속도 업 (주의-리스크 있음)
published: true
permalink: customize_polyfit.html
summary: "함수의 프로파일링과 내장 함수를 커스터마이징 해서 사용하는 방법 소개"
tags: [번역, 프로파일링, 커스터마이징]
identifier: customize_polyfit
sidebar: false
toc: true
ogimage: https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-07-06-customize_polyfit/profiler_result.png
---

본 포스트의 원문은 아래의 URL에서 확인하실 수 있습니다. 본 포스트는 원작자에게 동의를 구한 뒤 한국어로 번역하였습니다.

- [【MATLAB】polyfit 関数に手を加えて実行速度アップ（注：リスクあり）](https://qiita.com/eigs/items/3dc064bb52e2de86727f)

# 수행해 본 것

함수의 실행 속도를 높이기 위해서 MATLAB의 내장 함수 `polyfit`을 수정해버리고 (+ 별도로 저장) 실행 속도가 약 5배가 되었다는 이야기입니다. R2019a에서 실시했습니다.

그럼에도 불구하고 루트 디렉토리 (아래)에 있는 MATLAB 함수를 직접 만져버리는 것은 온갖 문제의 원인이 될 수 있으므로 수정할 때는 별도의 이름(예를 들어 `my_polyfit`)의 함수로 저장합니다.

```
 matlabroot
ans =
    'C:\Program Files\MATLAB\R2019a'
```

저장 위치는 함수를 호출하는 스크립트와 같은 폴더에 넣는 등 영향 범위는 적은 것이 안전하겠습니다.

**주1: MALTAB 루트 디렉토리의 함수는 편집하지 않습니다.**

**주2: 게재 내용을 잘 읽고 효과와 부작용 등의 리스크를 이해한 다음 활용해주십시오.**

# 계기

MATLAB Answers에 이런 질문이 올라왔습니다.

{% include callout.html content=" - [다차원 배열에 대한 Polyfit 가속화 (MATLAB Answers)](https://kr.mathworks.com/matlabcentral/answers/478773-polyfit?s_eid=PSM_29435) <br><br> 나는 측정 레벨 x, 종속 변수 y에 대해 y=a0 + a1 x + a2 x^2 의 형태로 커브 피팅을 실시하고 싶습니다. 예를 들면 x의 차원은 100만×3, y의 차원은 100만×3이며, 각각의 행에 대해서 상기 커브 피팅을 실시하고 싶습니다.
arrayfun을 사용하여 아래와 같은 함수를 만들면 계산이 가능했지만 실행 속도가 매우 느립니다. 실행 속도를 향상시키기 위해 더 나은 구현 방법이 없습니까?" type="primary" %} 

함수를 호출하는 방법으로 어떻게든 되면 좋겠습니다만, 아쉽게도 `polyfit`은 벡터 데이터에 대해서만 대응이 되어 있어, 행렬을 주어 여러 개의 피팅 결과를 돌려줄 수 없습니다 (R2019b 기준). 위의 질문에서는 `arrayfun` 함수를 이용해 `for` 루프를 피하고 있습니다만, 실행 속도에 그다지 개선이 없다는 것이죠.

그런 질문에 대응해 아래의 해결책이 제시되었습니다.

{% include callout.html content=" - [Multiple use of polyfit - could I get it faster?](https://kr.mathworks.com/matlabcentral/answers/1836-multiple-use-of-polyfit-could-i-get-it-faster?s_eid=PSM_29435) <br><br> you can omit the nice and secure error checks of POLYFIT." type="primary" %} 

그렇네요, **리스크를 인지한 상태에서** 에러 체크 등을 지워버리면 좋다는 것이네요. 이 방법으로 위의 질문자의 경우는 원래의 구현에 비해 50배 속도가 향상되었다고 하네요.

# 애시당초 시간이 걸리는 원인은 무엇이었을까?

실행 속도가 걸리는 경우에는 우선 프로파일링을 이용해서 무엇이 병목(bottle neck)에 해당하는지 체크해보는 것이 좋습니다. 참고: [프로파일링을 사용하는 방법](https://kr.mathworks.com/help/matlab/matlab_prog/profiling-for-improving-performance.html#f9-17087?s_eid=PSM_29435)

코드는 아래에 써있으며, `polyfit.m`의 내용에 관해서 아래와 같은 결과를 얻을 수 있었습니다.

<p align = "center">
    <img src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-07-06-customize_polyfit/profiler_result.png">
</p>

경고 체크 부분 `warnIfLargeConditionNum...`이나 `warning` 함수에 의해 시간이 많이 걸리는 것을 알 수 있습니다.

`>> edit polyfit` 이라고 입력하여 MATLAB이 제공하는 `polyfit.m`의 내용도 확인해보시기 바랍니다.

행렬의 조건수가 나쁜 경우 확실히 체크가 필요하겠지만, 그 부분은 제대로 이해한 후에 경고 체크 부분을 지워버려도 문제없다라고 하는 경우도 있겠죠. 

다음은 경고 체크 부분을 제워버린 함수를 만들어 효과를 보도록 하겠습니다.

프로파일러로 속도검증한 스크립트는 여기 있습니다.

```matlab
% 예를 들어
% 난수 100개의 x, y를 사용해서
%  y=a0 + a1*x + a2*x^2 의 형태로 커브 피팅을 1000회 반복합니다.
x = rand(100,1e3);
y = rand(100,1e3);
dim = 3; 
m = size(x,2); % m = 1000;

c1 = zeros(m,dim+1); % 계수 보존용
tic
for ii=1:m
   c1(ii,:) = polyfit(x(:,ii),y(:,ii),dim);
end
toc
```

# `polyfit`을 베이스로 `my_polyfit` 함수 작성

`polyfit.m`이 저장되어 있는 장소는 

```
>> which polyfit
C:\Program Files\MATLAB\R2019a\toolbox\matlab\polyfun\polyfit.m
```

으로 확인됩니다. 이 `polyfit.m`을 복사한 뒤, 프로파일러를 사용해 확인한 경고 체크 부분을 주석 처리한 다음, `my_polyfit.m`이라고 따로 이름 붙인 뒤 작업 경로에 별도의 이름으로 저장합니다. `m` 파일 내의 함수명 변경도 잊지 말아주세요.

# 그러면, 빨라졌을까요?

이하 `sample2.m`처럼 같은 데이터에 대해 처리 속도를 비교해보면,

```
>> sample2
경과 시간은 0.300088초입니다.
경과 시간은 0.022066초입니다.
```

가 됩니다. 빨라졌네요.

속도 체크용 스크립트입니다.

```matlab
% 난수 100개의 x, y를 사용해서
%  y=a0 + a1*x + a2*x^2 의 형태로 커브 피팅을 1000회 반복합니다.
x = rand(100,1e3);
y = rand(100,1e3);
dim = 3; 
m = size(x,2); % m = 1000;

c1 = zeros(m,dim+1); % 계수 저장용
tic
for ii=1:m
   c1(ii,:) = polyfit(x(:,ii),y(:,ii),dim);
end
toc

c2 = zeros(m,dim+1); % 계수 저장용
tic
for ii=1:m
   c2(ii,:) = my_polyfit(x(:,ii),y(:,ii),dim);
end
toc

% 결과가 동일한지 확인
isequal(c1,c2)
```

# 마치며

리스크나 부작용을 신경쓰지 않아도 괜찮은 상황이라면 MATLAB 측에서 제공하는 함수를 복사 & 붙여넣기해서 목적을 달성할 수 있는 경우도 있다는 예시었습니다.

`polyfit` 함수의 경우 오차 추정도 구하기 위해서 계수를 계산할 때 

```matlab
[Q,R] = qr(V,0);
p = R\(Q'*y);
```

이라고 일단 QR 분해를 하고 있습니다. 여기서 오차 추정도 없이 계수만을 구하려고 하는 경우라면

```matlab
p = V\y;
```

만 써도 괜찮습니다. 이렇게 하면 확실히 더 빨라집니다. 흥미 있으신 분들은 시험해 보셔도 좋을 것 같네요.