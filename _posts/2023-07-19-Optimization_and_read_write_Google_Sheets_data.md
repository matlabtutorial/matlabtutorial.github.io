---
title: (번역) MATLAB & Python - 최적화 계산 및 Google Sheets 읽기/쓰기
published: true
permalink: Optimization_and_read_write_Google_Sheets_data.html
summary: "MATLAB에서 Python 패키지로 제공되는 GoogleAPI를 이용해 데이터를 불러온 뒤 최적화 계산에 사용하였습니다.."
tags: [번역, 파이썬, googleapi, 최적화, GoogleSpreadSheet]
identifier: Optimization_and_read_write_Google_Sheets_data
sidebar: false
toc: true
ogimage: https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-07-19-Optimization_and_read_write_Google_Sheets_data/ogimage.png
---

본 포스트의 원문은 아래의 URL에서 확인하실 수 있습니다. 본 포스트는 원작자에게 동의를 구한 뒤 한국어로 번역하였습니다.

- [【MATLAB & Python】最適化計算と Google Sheets の読み書き](https://qiita.com/eigs/items/4182fcd9b5da748ef77e)

# 수행해본 것

MATLAB에서 Python을 불러보았습니다. 구체적으로는 아래와 같습니다.

1. Google Sheets에서 데이터를 불러온다 (by Python)
2. 최적화 계산 (by MATLAB)
3. Google Sheets로 결과를 써넣는다. (by Python)

MATLAB에서 하기에는 시간이 많이 들뻔 했던 Google Sheets를 이용한 작업(1과 3)을 이번에는 MATLAB에서 Python 모듈을 불러오는 방법으로 수고를 덜었습니다.

예를들면

```m
pyOut = py.gspread_sample.getValues();
```

이런 식입니다.

## 누구를 위한 내용인가?

- 조금 Python을 배워둬볼까... 하는 MATLAB 유저
- 사용하고 싶은 Python의 모듈이 있는 MATLAB 유저
- 사용하고 싶은 MATLAB의 함수가 있는 Python 유저

를 위한 내용이라고 생각합니다.

Python과 MATLAB의 연동에 대한 공식 페이지는 여기에 있으니 참고하여 주십시오: [MATLAB에서 Python 호출하기](https://kr.mathworks.com/help/matlab/call-python-libraries.html)

## 왜 MATLAB과 Python을 함께 쓰는거지?

전부 MATLAB으로, 혹은 Python으로 작업을 수행하는 방법도 있겠습니다만,

- Google Sheets를 읽어들이는 Python코드를 발견했다.
- MATLAB이 특기라는 개인적 사정 (하하..)

의 두가지 이유때문에 MATLAB을 베이스로 해보게 되었습니다. Python은 평소에 잘 만지지 않기 때문에 부족한 점이 있다고 생각합니다만, 만약 개선할 수 있는 점이 있다면 지적 부탁드립니다. 

보충) File Exchange에 공개되어 있느s MATLAB 함수 [GetGoogleSpreadsheet](https://jp.mathworks.com/matlabcentral/fileexchange/39915-getgooglespreadsheet?s_eid=PSM_29435) 를 쓰면 더 쉬울지도 모르겠습니다.

## 환경

MATLAB R2019a (+ Optimization Toolbox)
Python 3.6
pip 19.2.3
gspread 3.1.0 → [GitHub: gspread](https://github.com/burnash/gspread)
oauth2client 4.1.3

## 참고한 Qiita 블로그 포스팅
 
Google Sheets 와의 데이터 교환에 대해서는 아래의 포스팅에 있는 것을 거의 그대로 사용했습니다. 감사합니다!

- [Python으로 Google 스프레드 시트를 편집하기](https://qiita.com/akabei/items/0eac37cb852ad476c6b9) by @akabei님


# 그래서 실제로 무엇을 했나요?

포트폴리오의 균형이 깨진 보유 비율을 목표 비율에 가깝게 만들기 위해서는 각 종목을 몇 주씩 사야하는지 계산해야 합니다. 리밸런싱이 중요하죠 (웃음)
참고: [포트폴리오 리밸런싱: 효과를 계산해봤습니다. (주가 가져오기 편)](https://qiita.com/eigs/items/1b2b0a9900602ac2b24e)

보유 종목의 주가와 보유 수량은 Google Sheets에서 관리하고, 계산 결과도 Google Sheets에 반영됩니다.


결과물은 여기에 있습니다 (Google Sheets 캡처 이미지)
![animation_samplegspread.gif](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/d3a69a8f-38c1-7a29-384d-3129bc03be6a.gif)

- **위 표**: 현재 보유 수량
    - current_pf (현재 보유 비율)과 target_pf (목표 보유 비율)의 차이가 1% 이상인 종목은 빨간색으로 표시되어 있습니다.
- **아래 표**: 코드 실행 결과
    - 매수에 소요되는 총액에 상한선을 설정하고, target_pf에 가까워지도록 각 종목의 추가 매수 수량을 업데이트하고 있습니다. 다음 매수는 이대로 진행하면 됩니다!

Google Sheets([sample_portfolio](https://docs.google.com/spreadsheets/d/1A9lXf0Oje19YR3U_h2l3a_MD09A3m3M4lu5n1qtpIiw/))에서 시트를 공개하고 있으니 관심있는 분들은 확인해보세요.
참고로 주가는 Google Sheets의 `GOOGLEFINANCE` 함수를 사용하여 가져오고 있습니다.


순서대로 살펴보겠습니다.

# 1. Google Sheets에서 데이터 읽어오기 (MATLAB에서 Python을 통해)

필요한 모듈은 gspread_sample.py에 모아두었습니다.
MATLAB에서의 호출 방법은 간단합니다. 사전에 `load`는 필요하지 않습니다.

```m
% getValues 함수 (Python)를 사용하여
% Google Spreadsheet에서 데이터를 읽어옵니다 (py.tuple 클래스로).
pyOut = py.gspread_sample.getValues();
whos pyOut 
```

그러면 출력은 `tuple` 형태로 얻어집니다.

```m
Name       Size            Bytes  Class       Attributes

pyOut      1x2                 8  py.tuple   
```

이 데이터 형식은 후속으로 사용할 `fmincon` 함수의 인수로 사용할 수 없으므로, 약간의 처리가 필요합니다. 특히, Google Sheets의 값은 모두 문자열로 들어오기 때문에 Python 쪽에서 처리할 수도 있지만, MATLAB이 더 능숙하므로 MATLAB로 처리하겠습니다.

필요한 것은 숫자 데이터뿐입니다.

```matlab
% 먼저 셀 형식으로 변경
vname = cell(pyOut{1}); % 변수명 부분
value = cell(pyOut{2}); % 데이터 부분

%% 데이터를 MATLAB에서 처리하기 쉽도록 변경
% 데이터를 문자열 형식으로 변경
vname = cellfun(@(x) string(x.value), vname);
value = cellfun(@(x) string(x.value), value);
value = reshape(value,6,[])';
% table 형식 변수로 통합
pfData = array2table(value,'VariableNames',vname)
```

이 시점에서 이렇게 보입니다. $ 나 %가 방해되네요.

![pfData1.PNG](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/a13e6382-6ffa-bd3b-314d-bb5d8edf46fd.png)

```matlab
%% 추가 처리
pfData.position = double(pfData.position);% 문자열 -> 숫자로 변경
pfData.marketvalue = double(extractAfter(pfData.marketvalue,"$")); % $ 기호 제거 및 숫자로 변경
pfData.total = double(extractAfter(pfData.total,"$")); % $ 기호 제거 및 숫자로 변경
pfData.current_pf = double(extractBefore(pfData.current_pf,"%"))/100; % % 제거 및 숫자로 변경
pfData.target_pf = double(extractBefore(pfData.target_pf,"%"))/100; % % 제거 및 숫자로 변경
```

드디어 깔끔해졌습니다. Python 쪽에서 전처리를 할 수 있다면 좀 더 간단할 것 같습니다.

![pfData2.PNG](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/c1148266-6742-523b-17b9-a781f56b0553.png)

# 2. MATLAB에서 최적화 계산 (by MATLAB)

이제 최적의 매수 주식 수를 찾아봅시다.
제약 조건인 매수 예산 `Cost`를 사용하고자 하므로, 최적화 도구인 Optimization Toolbox의 `fmincon` 함수를 사용합니다. 자세한 내용은 주석을 참조하십시오. 제약 조건이 없다면 Optimization Toolbox가 필요하지 않은 `fminsearch`를 사용할 수도 있습니다.

```matlab
%% 최적화 시작
% 각 주식 종목별로 목표 보유 비율에 가까워지기 위해 몇 주를 매수해야 하는지 계산합니다.
% 이때 제약 조건은 매수 예산인 Cost로 설정합니다.
% 이 예제에서는 2,000달러 (약 200만원)로 설정합니다.
Cost = 2e3; % $2k

% fmincon 함수 사용
% 원래는 정수 문제지만, 실수로 주식 수를 계산한 후 소수점은 무시합니다.
% 주식 수가 많으면 큰 문제가 되지 않으므로.
% 물론 주식 수가 적은 경우에는 영향이 있으므로 조정이 이루어집니다.
% 선형 부등식 제약 조건 (총 비용이 Cost 이하)
A = pfData.marketvalue';
b = Cost;
% 선형 등식 제약 조건 없음
Aeq = [];
beq = [];
% 주식 수의 상하한
lb = zeros(7,1);
ub = inf(7,1);
% 초기값은 0으로 설정
x0 = zeros(7,1);

% 목적 함수는 getDiff를 사용하여 정의됩니다.
% 목표 보유 비율과의 오차 제곱의 합의 제곱근을 최소화하려고 합니다.
x = fmincon(@(x) getDiff(pfData,x),x0,A,b,Aeq,beq,lb,ub);
```

목적 함수로 지정된 getDiff.m은 다음과 같습니다. 추가 매수 후의 비율과 각각의 목표 비율 간의 차이의 제곱의 합의 제곱근입니다. 조금 복잡하네요!

```matlab
% getDiff.m
function errorRMS = getDiff(pfData, position2add)
newTotal = pfData.marketvalue.*(position2add+pfData.position);
newPF = newTotal/sum(newTotal);
errorRMS = sqrt(sum( (newPF - pfData.target_pf).^2 ) );
end
```

# 3. Google Sheets에 결과 작성 (by Python from MATLAB)

`fmincon` 함수 실행 결과, 추가로 매수할 주식 수는 다음과 같습니다.

```m
x =

    2.3795
    4.5881
   13.2482
   10.8342
    0.0000
    1.5591
    1.2656
```

따라서 이를 소수점 이하를 버리고 Google Sheets에 작성합니다. 남은 현금은 MMF로 매수해두겠습니다.

```matlab
% 주식 수의 소수점 이하 버림
xlong = floor(x);

% updateValues 함수 (Python)를 사용하여
% Google Spreadsheet에 데이터 작성
py.gspread_sample.updateValues(xlong)
```

이상입니다!

# 요약

MATLAB과 Python을 협업하여 작업해보았습니다. 데이터 형식을 왔다갔다하는 부분이 조금 귀찮을 수 있지만,

```m
py.gspread_sample.getValues
```

와 같이 간편하게 호출할 수 있는 점이 편리했습니다. Python을 좀 더 공부하면 활동 범위가 넓어질 것 같습니다!

조금 번거로웠던 점은 MATLAB에서 Python 코드를 편집한 후 MATLAB에서 실행하기 위해서는 모듈을 다시 로드해야 한다는 점입니다.

```matlab
clear classes %#ok<CLCLS>
mod = py.importlib.import_module('gspread_sample');
py.importlib.reload(mod);
```

드문듯한 경우를 대비하여 안심을 위해 맨 처음에 달아놓으면 좋습니다. 자세한 내용은 여기에 있습니다: [변경된 사용자 정의 Python 모듈 다시 로드](https://www.mathworks.com/help/matlab/matlab_external/call-modified-python-module.html?s_eid=PSM_29435)

다음에는 사용한 Python 및 MATLAB 코드의 전체 내용을 기록해두었습니다.

## Python 함수 전체

```python
# gspread_sample.py
def getValues():
    """get values in A2:F9 from 'sample_portfolio'"""

    import gspread
    from oauth2client.service_account import ServiceAccountCredentials

    scope = ['https://spreadsheets.google.com/feeds',
             'https://www.googleapis.com/auth/drive']

    credentials = ServiceAccountCredentials.from_json_keyfile_name('<JSONファイル名>.json', scope)
    gc = gspread.authorize(credentials)
    wks = gc.open('sample_portfolio').sheet1

    vname_list = wks.range('A2:F2');
    value_list = wks.range('A3:F9');
    #print(vname_list)

    return vname_list, value_list


def updateValues(position2add):
    """updates values in B13:B19 on 'sample_portfolio' with virtual purchase"""

    import gspread
    from oauth2client.service_account import ServiceAccountCredentials

    scope = ['https://spreadsheets.google.com/feeds',
             'https://www.googleapis.com/auth/drive']

    credentials = ServiceAccountCredentials.from_json_keyfile_name('<JSONファイル名>.json', scope)
    gc = gspread.authorize(credentials)
    wks = gc.open('sample_portfolio').sheet1

    # Update in batch
    cell_list = wks.range('B13:B19')

    for x in range(7):
       cell_list[x].value = position2add[x]

    wks.update_cells(cell_list)

    # Update one cell by one
    """
    wks.update_acell('B13', position2add[0])
    wks.update_acell('B14', position2add[1])
    wks.update_acell('B15', position2add[2])
    wks.update_acell('B16', position2add[3])
    wks.update_acell('B17', position2add[4])
    wks.update_acell('B18', position2add[5])
    wks.update_acell('B19', position2add[6])
    """

def main():
    vname_list, value_list = getValues()
    print(vname_list)
    print(value_list)

if __name__ == '__main__':
    main()
```


## MATLAB 코드 전문 (앞선 내용을 다시 올림)

```matlab
% sample_optimization.m
% 변경된 사용자 정의 Python 모듈 다시로드
% https://www.mathworks.com/help/matlab/matlab_external/call-modified-python-module.html
clear classes %#ok<CLCLS>
mod = py.importlib.import_module('gspread_sample');
py.importlib.reload(mod);

% getValues 함수(Python)를 사용하여
% Google 스프레드시트에서 데이터 읽기(py.tuple 클래스로 반환)
pyOut = py.gspread_sample.getValues();
whos pyOut 
% 셀 형식으로 변환
vname = cell(pyOut{1}); % 변수 이름 부분
value = cell(pyOut{2}); % 데이터 부분

%% MATLAB에서 처리하기 쉽게 데이터 변환
% 데이터를 문자열(string) 형식으로 변환
vname = cellfun(@(x) string(x.value), vname);
value = cellfun(@(x) string(x.value), value);
value = reshape(value,6,[])';
% table 형식으로 변환
pfData = array2table(value,'VariableNames',vname)

%% 추가적인 처리
pfData.position = double(pfData.position);% 문자열 -> 숫자로 변환
pfData.marketvalue = double(extractAfter(pfData.marketvalue,"$")); % $ 기호 제거하고 숫자로 변환
pfData.total = double(extractAfter(pfData.total,"$")); % $ 기호 제거하고 숫자로 변환
pfData.current_pf = double(extractBefore(pfData.current_pf,"%"))/100; % % 제거하고 숫자로 변환
pfData.target_pf = double(extractBefore(pfData.target_pf,"%"))/100; % % 제거하고 숫자로 변환
% 완료
pfData

%% 최적화 계산 시작
% 각 종목별로 목표 보유 비율에 근접하도록 몇 주를 구매해야 하는지 계산합니다.
% 이때 제약 조건은 총 구매 비용을 얼마로 제한할 것인지입니다.
% 여기서는 2천 달러(약 200만 원)으로 제한합니다.
Cost = 2e3; % $2k

% fmincon 함수 사용
% 일반적으로는 정수 문제이지만 실수로 주식 수를 계산한 후 소수점 이하는 무시합니다.
% 주식 수가 많다면 큰 문제가 되지 않으므로 문제 없습니다.
% 물론 주식 수가 적은 경우 영향을 받을 수 있으므로 조정이 필요합니다.
% 선형 부등식 제약 조건(총 구매 비용이 Cost 이하)
A = pfData.marketvalue'; 
b = Cost;
% 선형 등식 제약 조건 없음
Aeq = [];
beq = [];
% 주식 수의 상하한 제한
lb = zeros(7,1);
ub = inf(7,1);
% 초기값은 0입니다.
x0 = zeros(7,1);

% 목적 함수는 getDiff를 사용하여 정의되었습니다.
% 목표 보유 비율과의 오차 제곱의 합의 제곱근을 최소화합니다.
x = fmincon(@(x) getDiff(pfData,x),x0,A,b,Aeq,beq,lb,ub);

% 주식 수의 소수점 이하는 버립니다.
xlong = floor(x);

% updateValues 함수(Python)를 사용하여
% Google 스프레드시트에 데이터 쓰기
py.gspread_sample.updateValues(xlong)

% 추가 구매 후 새로운 보유 수(확인용)
% position2 = pfData.position + xlong;
% total = pfData.marketvalue'*position2;
% [pfData.current_pf,pfData.marketvalue.*position2/total,pfData.target_pf]


function errorRMS = getDiff(pfData, position2add)
newTotal = pfData.marketvalue.*(position2add+pfData.position);
newPF = newTotal/sum(newTotal);
errorRMS = sqrt(sum( (newPF - pfData.target_pf).^2 ) );
end
```