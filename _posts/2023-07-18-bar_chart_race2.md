---
title: (번역) 꿈틀 꿈틀 움직이는 바 그래프를 그려봅시다 - 구현편
published: true
permalink: bar_chart_race2.html
summary: "꿈틀 꿈틀 움직이는 바 그래프가 유행인 것 같아 보여서 MATLAB으로 그려보려고 합니다."
tags: [번역, 시각화, 애니메이션, 막대 그래프]
identifier: bar_chart_race2
sidebar: false
toc: true
---

본 포스트의 원문은 아래의 URL에서 확인하실 수 있습니다. 본 포스트는 원작자에게 동의를 구한 뒤 한국어로 번역하였습니다.

- [ぬめぬめ動く棒グラフ Bar Chart Race を描いてみよう: 実装編](https://qiita.com/eigs/items/c1675e6dc6fd497e714a)
  
# 시작하기

각 데이터의 시계열 변화를 순위와 함께 표현하는 Bar Chart Race. 이전에는 `barh` 함수를 사용하여 Bar Chart Race를 구현할 수 있는지 확인해보았습니다. `BarWidth` 속성의 사용법이 중요했죠.

자세한 내용은 [(번역) 꿈틀 꿈틀 움직이는 바 그래프를 그려봅시다 - 준비편](bar_chart_race1.html)에서 확인할 수 있습니다.

![output.gif](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/90cecb93-2b82-5f67-b545-374433e00274.gif)

이번에는 구현 편으로서 실제로 이 동영상(GIF)을 만드는 과정까지 설명하겠습니다.

이미 함수를 [minoue-xx/BarChartRaceAnimation](https://github.com/minoue-xx/BarChartRaceAnimation)에서 공개하였으므로, 사용 예 및 주요 포인트만 간략히 소개하겠습니다.

### 실행 환경

R2019b에서 작성되었습니다. 설명하는 Arguments와 관련된 부분을 제외하면 R2017b에서도 작동할 것으로 생각됩니다. 확인은 하지 않았습니다.

# 사용 예시: 각 도·부·현의 추정 인구 변동 (타이쇼 9년 ~ 헤이세이 12년[^1])

[^1]: 역주 - 타이쇼, 헤이세이는 일본에서만 독자적으로 사용하는 연호(年號)입니다. 타이쇼 9년은 서기 1920년, 헤이세이 12년은 서기 2000년에 해당합니다. 

먼저 [e-Stat](https://www.e-stat.go.jp/stat-search/files?page=1&layout=datalist&toukei=00200524&tstat=000000090001&cycle=0&tclass1=000000090004&tclass2=000000090005&stat_infid=000000090265)의 페이지에서 해당 데이터를 다운로드하고, `05k5-5.xlsx`라는 파일이 이 스크립트와 동일한 폴더에 다운로드되었다고 가정합니다.

## Step 1: 데이터 읽기

간단하게 임포트 도구에서 읽는 스크립트를 작성했습니다.

![Untitled.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/db2ad97b-046c-c823-bc89-3f0c9f16869f.png)

"현재 폴더"에 표시되는 `05k5-5.xlsx`를 더블 클릭하여, 읽을 범위를 지정하고 "스크립트 생성"을 클릭합니다. 출력 유형은: 셀 배열입니다.

생성된 스크립트를 실행하면 변수 `k55`로 읽어와집니다. (`importData.m`은 [여기](https://github.com/minoue-xx/BarChartRaceAnimation/tree/master/example/RegionalPopulationJapan)에도 있습니다.)

```matlab
importData
```

## Step 2: 데이터 정리

시계열 데이터를 `timetable` 형식으로 정리하는 것이 편리합니다. 주의: 오키나와는 데이터가 크게 누락되어 있으므로 제외합니다.

```matlab
% k55에서 필요한 부분을 추출합니다.
years = [k55{1,3:end}]'; % 연도
names = string(k55(4:end-1,1)); % 도·부·현 이름
data = cell2mat(k55(4:end-1,3:end)); % 인구 (숫자 부분)

% 연도 데이터를 datetime 형식으로 변경합니다.
timeStamp = datetime(years,1,1);
timeStamp.Format = 'yyyy'; % 표시 형식은 yyyy년

% timetable 형식의 데이터 생성
T = array2timetable(data','RowTimes',timeStamp);
T.Properties.VariableNames = names; % 변수 이름 지정
```

이렇게 데이터가 구성됩니다.

```matlab
head(T)
```

![Capture.PNG](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/515e04f8-a5f0-7692-e4d6-d5217678c82d.png)

## Step 3: 플롯


여기까지 오면

```matlab
barChartRace(T);
```

으로 OK!

다만, 모든 데이터를 플롯하면 무슨 도·부·현인지 알기 어렵기 때문에 몇 가지 옵션을 사용해보겠습니다.

```matlab
barChartRace(T,'NumDisplay',6,'NumInterp',4,...
    'Position',[500 60 470 370],'ColorGroups',repmat("g",length(names),1),...
    'XlabelName',"상위 6개 도·부·현의 인구 (천 명)",...
    'GenerateGIF',true,"Outputfilename",'top5.gif');
```

를 실행하면, 앞서 언급한 GIF가 생성됩니다.

## 다양한 옵션

자세한 내용은 GitHub의 [README.md](https://github.com/minoue-xx/BarChartRaceAnimation/blob/master/README.md) 또는

```matlab
help barChartRace
```

를 참조해주시기 바랍니다. 몇 가지 예시로는

   -  `'NumDisplay'`: 상위 몇 위까지 표시할지 (기본값: 전체)
   -  `'FontSize'`: 플롯에 사용할 폰트 크기 (기본값: 15)
   -  `'GenerateGIF'`: GIF를 출력할지 여부 (기본값: false)
   -  `'LabelNames'`: `timetable` 또는 `table` 형식 변수의 경우 변수 이름을 그대로 사용하지만, 이 옵션으로 지정 가능
   -  `'Position'`: 생성되는 Figure의 크기

와 같은 옵션들이 있습니다.


### Arguments

Arguments를 사용하여 옵션 목록을 표시하는 기능을 추가했습니다. R2019b부터 사용할 수 있는 Arguments입니다. (자세한 내용은 [Argument Validation Functions](https://jp.mathworks.com/help/matlab/matlab_prog/argument-validation-functions.html?s_eid=PSM_29435)을 참조해주세요.)

`barChartRace.m`의 맨 위에 있는 부분이 해당합니다.

```matlab
arguments
    inputs {mustBeNumericTableTimetable(inputs)}
    options.Time (:,1) {mustBeTimeInput(options.Time,inputs)} = setDefaultTime(inputs)
    options.LabelNames {mustBeVariableLabels(options.LabelNames,inputs)} = setDefaultLabels(inputs)
    options.ColorGroups {mustBeVariableLabels(options.ColorGroups,inputs)} = setDefaultLabels(inputs)
    (중략)
```

이 부분이 해당합니다. 모든 변수가 올바르게 입력되었는지 확인하는 작업을 수행합니다. 예를 들어...

```matlab
barChartRace('에러가 나올 거야')
```
```
에러: barChartRace
위치 1의 입력 인수가 유효하지 않습니다. Input data must be either timetable, table, or numeric array (double)
```

첫 번째 입력은 timetable 형식, time 형식 또는 double 배열이어야 합니다.

```matlab
barChartRace(T,'LabelNames',"이것도 안 좋아")
```
```
에러: barChartRace
이름과 값의 인수 'LabelNames'가 유효하지 않습니다. The size must be same as the number of variables of inputs (46)
```

`'LabelName'`이라는 옵션은 입력과 동일한 변수 수 (46개)를 준비해야 합니다. 에러의 원인을 표시하는 방식입니다. 자신만 사용하는 함수라면 필요하지 않을 수 있지만, 다른 사람에게도 사용하도록 한다면 편리할 것 같아서 추가했습니다.

# 플롯의 포인트 1: 데이터 보간(interpolation)

각 막대가 순위 교환을 나타내려면 순위 데이터의 보간이 필요합니다. `barChartBar.m`에서는 다음과 같이 작성되어 있습니다.

```matlab
%% Interpolation: Generate nInterp data point in between
time2plot = linspace(time(1),time(end),length(time)*NumInterp);
ranking2plot = interp1(time,rankings,time2plot,Method);
data2plot = interp1(time,data,time2plot,Method);
```

여기서 `interp1` 함수를 사용합니다.

`Method`를 사용하여 보간 방법을 지정할 수 있습니다. 간단하게 선형 보간을 사용하면 위와 같은 동영상이 생성됩니다. 그러나 `spline` 보간과 같은 방법을 사용하면 막대의 위치가 오버슈트되어 더욱 다이내믹한 효과가 발생합니다. 필요 없을 것 같네요 (웃음).

![top5Spline.gif](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/ecfed785-abfa-4a25-5501-87a9f40ec7ee.gif)

커맨드는 다음과 같습니다. `'Method'`에 `'spline'`을 지정합니다.

```matlab
barChartRace(T,'NumDisplay',6,'NumInterp',4,...
    'Position',[500 60 470 370],'ColorGroups',repmat("g",length(names),1),...
    'XlabelName',"상위 6개 도·부·현의 인구 (천 명)",'Method','spline',...
    'GenerateGIF',true,"Outputfilename",'top5Spline.gif');
```

# 플롯의 포인트 2: CData

이전에도 nonlinopt님께서 지적해주신 것처럼 각 막대의 색상은 `CData` 속성으로 지정할 수 있습니다. `'FaceColor'`를 `'flat'`으로 설정하는 것에도 주의해야 합니다.

그러나 CData 내에서 색상의 순서는 각 막대의 위치와 연동되어 있습니다. 예를 들어 CData를 그대로 두면 원래의 순위 (1위: 빨강, 2위: 파랑)가 반전되면 1위가 파랑으로, 2위가 빨강으로 바뀌게 됩니다.

예를 들어,

```matlab
hb = barh([1,2],'FaceColor','flat');
hb.CData = [0,0,1
    1,0,0];
```

<img src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/220f8348-34d9-71ab-7bff-61a74432a8ec.png" alt="attach:cat" title="attach:cat" width=500px>

원래 설정은 위쪽이 빨강, 아래쪽이 파랑입니다. 그러나 위치를 변경하면...

```matlab
hb.XData = [2,1];
```

<img src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/bf23d27b-022e-4088-a82e-c84084555125.png" alt="attach:cat" title="attach:cat" width=500px>

색상의 순서는 그대로 유지됩니다. 당연한 얘기이긴 하지만요. 따라서, `CData` 내의 순서도 맞춰서 변경해야 합니다. `barChartBar.m`에서는 다음과 같이 작성되어 있습니다.

```matlab
    % Set YTick position by ranking
    % Set YTickLabel with variable names
    [ytickpos,idx] = sort(ranking,'ascend');
    handle_axes.YTick = ytickpos;
    handle_axes.YTickLabel = LabelNames(idx);
    
    % Fix CData
    handle_bar.CData = colorScheme(idx,:);
```

`YTick`의 순위 변경에 맞춰서 `CData`도 변경합니다.

# 플롯의 포인트 3: 막대 옆의 숫자 표시

이 부분은 `text` 객체를 사용합니다. 이 글([매트랩의 Annotation을 만들어보자](https://qiita.com/Monzo_N/items/c68f52e88fd532671a19))에서도 논의되었습니다만, `text` 객체의 좋은 점은 플롯 데이터와 동일한 좌표계에서 위치를 지정할 수 있다는 것입니다. Figure 내의 상대적인 위치나 Axes 내의 상대적인 위치를 계산할 필요가 없어 직관적으로 사용하기 편합니다. `barChartRace.m`에서는 다음과 같이 작성되어 있습니다.

```matlab
% Add value string next to the bar
if IsInteger
    displayText = string(round(value2plot(idx)));
else
    displayText = string(value2plot(idx));
end
xTextPosition = value2plot(idx) + maxValue*0.05;
yTextPosition = ytickpos;

% NumDisplay values are used
xTextPosition = xTextPosition(1:NumDisplay);
yTextPosition = yTextPosition(1:NumDisplay);
displayText = displayText(1:NumDisplay);
handle_text = text(xTextPosition,yTextPosition,displayText,'FontSize',options.FontSize);
```

숫자를 오른쪽으로 5%만큼 이동하여 숫자를 표시하고 있습니다. 원래 데이터가 정수인 경우에는 옵션을 추가하여 정수로 반올림하여 표시합니다. 내삽을 수행하므로 그대로 표시하면 인구가 소수점으로 표시됩니다. (약간 어색하지만) 

# 보너스 포인트

플롯을 보면 "Visualized by MATLAB"이라는 표시가 지나치게 강조되어 있습니다 (웃음).

`barCharRace.m`에서는 다음 한 줄로 작성되어 있으며, 여러분들은 원하는 문자로 변경하여 사용하실 수 있습니다.

```matlab
% Display created by MATLAB message
text(0.99,0.02,"Visualized by MATLAB",'HorizontalAlignment','right',...
    'Units','normalized','FontSize', 10,'Color',0.5*[1,1,1]);
```

# 간단한 방법

빠르게 만들어보기만 하려면 다음과 같은 방법도 있습니다.

1. Excel에서 데이터를 복사합니다.
2. MATLAB에 붙여넣기합니다.
3. `barChartRace(unnamed')`를 실행합니다.

![Untitled Project.gif](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/4e8314f4-afa2-49ca-cc24-a3f1499c02f6.gif)

# 요약

위에서는 `barChartRace` 함수 내에서의 주요 포인트를 간단하게 소개했습니다.

인구 변동, 인기 프로그래밍 언어 순위, 각 기업의 시가 총액 순위, 각 국가의 출생률 순위, 각 대학의 입학 점수 순위 등 데이터만 있으면 흥미로운 플롯을 만들 수 있을 것 같습니다.

궁금한 점이 있으면 언제든지 댓글로 문의해주세요.


