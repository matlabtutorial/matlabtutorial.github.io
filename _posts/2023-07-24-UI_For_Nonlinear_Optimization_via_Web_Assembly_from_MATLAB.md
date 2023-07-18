---
title: (번역) UI편 - MATLAB -> C++ -> WebAssembly 자동 변환을 사용한 비선형 최적화 on JavaScript
published: true
permalink: UI_For_Nonlinear_Optimization_via_Web_Assembly_from_MATLAB.html
summary: "MATLAB을 통해 생성한 WebAssembly 코드를 웹페이지에 실을 수 있게 UI를 구현해보았습니다."
tags: [번역, C++, WebAssembly, JavaScript, jQuery]
identifier: UI_For_Nonlinear_Optimization_via_Web_Assembly_from_MATLAB
sidebar: false
toc: true
ogimage: https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-07-20-Nonlinear_Optimization_via_Web_Assembly_from_MATLAB/ogimage.png
---

본 포스트의 원문은 아래의 URL에서 확인하실 수 있습니다. 본 포스트는 원작자에게 동의를 구한 뒤 한국어로 번역하였습니다.

- [UI編：MATLAB -> C++ -> WebAssembly の自動変換を使った非線形最適化 on JavaScript](https://qiita.com/eigs/items/403baeb4205b185ef638)

# 0. 소개

이전에 웹 어셈블리(WebAssembly)를 생성하고 MATLAB의 `fmincon`을 브라우저에서 실행하는 방법에 대해 설명한 적이 있습니다. 이번에는 UI 부분을 만들어보았으니 소개하겠습니다.

이 코드는 공개용으로 충분히 사용할 수 있는 것은 아니지만, 차차 개선해 나갈 예정이므로 힌트나 의견이 있다면 언제든지 주시면 감사하겠습니다. 감사합니다.

실행 페이지는 다음 위치에서 확인할 수 있습니다: Github Pages: [Rebalance Portfolio](https://minoue-xx.github.io/rebalance_portfolio/)
코드는 다음 위치에서 확인할 수 있습니다: GitHub: [minoue-xx/rebalance_portfolio](https://github.com/minoue-xx/rebalance_portfolio)


MATLAB에서 WebAssembly로의 자동 변환 부분은 다음의 게시물을 참조하십시오.
[Qiita: MATLAB -> C++ -> WebAssembly の自動変換を使った非線形最適化 on JavaScript](https://qiita.com/eigs/items/68cdcec7b8d56a5b440f)

# 1. 용도와 사용 방법

목표는 항상 다음과 같습니다.

**"균형을 잃은 보유 비율을 목표 비율에 가깝게 조정하기 위해 각 주식을 몇 주 구매해야 하는가"**

하지만 선택은 "구매"만 가능합니다. 리밸런싱이지만 판매는 고려하지 않습니다. 투자 계획용인가요?
다음은 조작 화면(GIF)입니다.

![portolioRebalance_video.gif](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/bc4945b0-4904-c9c4-9dfe-d90a3364a658.gif)

이런 느낌입니다.

### Step 1: 현재 포트폴리오 표시

보유 주식 및 수량은 csv 파일에서 읽어옵니다. 테스트로 샘플 데이터를 시작으로 해도 됩니다.
현재 가격, 소계, 총액, 비율은 자동으로 계산됩니다. 필요에 따라 주식, 보유 수량 등을 변경해보세요. csv 파일의 형식은 다음과 같이 구성되어야 합니다. [티커],[보유 수량],[목표 보유 비율] 순서로 입력하세요.

![Capture.PNG](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/e7e0b5c6-656b-5a44-1028-02d867b9a1cf.png)

### Step 2: 예산 금액 입력
사용 가능한 예산 금액을 입력하고 [Rebalance] 버튼을 클릭하세요.

### Step 3: 필요 구매 수량 계산 및 결과 표시
목표 비율에 가까워졌습니다.


# 2. 사용한 세부 요소에 대해

JavaScript는 처음이었기 때문에 검색하면서 + 동료로부터 힌트를 받아 구축하였습니다. 수행한 작업은 기본적인 것들이라고 생각합니다. 이번에 많이 도움이 되고 공부가 되었던 정보들을 정리해두겠습니다.


### 0. [Finantial Modeling Prep](https://financialmodelingprep.com/)

무료이며 인증이 필요하지 않은 조건으로 찾아서 주식 가격 정보에 이 API를 사용했습니다.
(무료 API 목록: https://github.com/public-apis/public-apis)


### 1. [Qiita: let과 var의 차이](https://qiita.com/y-temp4/items/289686fbdde896d22b5e)

우선 이것부터입니다. 많은 사람의 코드를 복사하여 사용하였기 때문에 var와 let이 혼재되어 있었습니다. let으로 통일할 때 스코프의 차이로 인해 오류가 발생하는 등에 도움이 되었습니다.

### 2. [Using jQuery to Perform Calculations in a Table](https://www.dotnetcurry.com/jquery/1189/jquery-table-calculate-sum-all-rows)

이번 페이지 구성의 기반이 되었습니다.

### 3. [【jQuery입문】find()로 하위 요소를 가져오는 다양한 방법](https://www.sejuku.net/blog/37474)

위를 이해하는 데 도움이 되었습니다. class 속성이라면 ". "을 사용하고, id 속성이라면 "#"을 사용합니다.

### 4. [Read CSV File in jQuery using HTML5 File API](https://www.aspsnippets.com/Articles/Read-CSV-File-in-jQuery-using-HTML5-File-API.aspx)

csv 파일을 읽어오는 부분은 거의 여기를 복사했습니다.

### 5. [How to convert a currency string to a double with jQuery or Javascript? - Stack Overflow](https://stackoverflow.com/questions/559112/how-to-convert-a-currency-string-to-a-double-with-jquery-or-javascript)

통화 문자열을 숫자로 변환하는 것은 꽤 귀찮은 작업입니다.

```javascript
(12345.67).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,');  // 12,345.67
```

이 코드를 사용했습니다.

### 6. [How can I format numbers as currency string in JavaScript? - Stack Overflow](https://stackoverflow.com/questions/149055/how-can-i-format-numbers-as-currency-string-in-javascript)

통화를 나타내는 문자열을 숫자로 변환하는 부분은 다음과 같이 할 수 있습니다.

```javascript
var currency = "$123,456.00";
var number = Number(currency.replace(/[^0-9\.]+/g,""));
```

# 3. 마지막으로: WebAssembly로 변환된 MATLAB 코드

[(번역) MATLAB -> C++ -> WebAssembly 자동 변환을 사용한 비선형 최적화 on JavaScript](Nonlinear_Optimization_via_Web_Assembly_from_MATLAB.html)에서 소개한 것과 거의 동일합니다. 다만 다음과 같이 변경되었습니다.

1. `budget` 변수를 입력으로 추가 (스칼라 값)
2. 초기값은 예산을 목표 보유 비율로 분배한 값을 사용합니다.

결과가 초기값에 의존하고 (지역 해를 생성) 있는 점에 대해서는 나중에 다시 써보도록 하겠습니다.

```matlab
function xlong = getPosition2Add(target_pf, price, position, budget)

% 크기와 데이터 타입 지정
assert(isa(target_pf, 'double'));
assert(isa(price, 'double'));
assert(isa(position, 'double'));
assert(isa(budget, 'double'));
assert(all( size(target_pf) == [ 1, 10 ]))
assert(all( size(price) == [ 1, 10 ]))
assert(all( size(position) == [ 1, 10 ]))
assert(all( size(budget) == [ 1, 1 ]))

idx = target_pf > 0;
target_pf = target_pf(idx);
price = price(idx);
position = position(idx);
N = sum(idx);

% 각 종목의 목표 보유 비율에 가까워지기 위해 구매해야 할 주식 수를 계산합니다.
% 제약 조건은 총 구매 비용인 Cost입니다.
Cost = budget(1);

% 선형 부등식 제약 조건 없음
A = [];
b = [];
% 선형 등식 제약 조건 (총 비용이 Cost)
% Aeq = [];
% beq = [];
Aeq = price;
beq = Cost;
% 주식 수의 상하한
lb = zeros(1,N);
ub = inf(1,N);
% 초기값은 Cost를 target_pf로 나눈 값을 사용합니다.
x0 = Cost*target_pf./(price);

options = optimoptions('fmincon','Algorithm','sqp');

% 목적 함수는 getDiff에서 정의되며,
% 목표 보유 비율과의 오차 제곱합의 제곱근을 최소화하는 것을 목표로 합니다.
objfun = @(x2add) getDiff(x2add,price,position,target_pf);
x = fmincon(objfun,x0,A,b,Aeq,beq,lb,ub,[],options);

% fmincon을 사용합니다.
% 원래는 정수 문제이지만, 주식 수를 실수로 구한 후 소수점 이하는 무시합니다.
% 구매 주식 수가 많다면 큰 문제가 되지 않기 때문입니다.
% 구매 주식 수의 소수점 이하를 버립니다.
xlong = zeros(1,10);
xlong(1:N) = floor(x);

end

function errorRMS = getDiff(position2add,marketvalue,position,target_pf)
newTotal = marketvalue.*(position2add+position);
newPF = newTotal/sum(newTotal);
errorRMS = sqrt(sum( (newPF - target_pf).^2 ) );
end
```


