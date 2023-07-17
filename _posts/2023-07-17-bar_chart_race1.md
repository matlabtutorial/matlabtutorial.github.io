---
title: (번역) 꿈틀 꿈틀 움직이는 바 그래프를 그려봅시다 - 준비편
published: true
permalink: bar_chart_race1.html
summary: "꿈틀 꿈틀 움직이는 바 그래프가 유행인 것 같아 보여서 MATLAB으로 그려보려고 합니다."
tags: [번역, 시각화, 애니메이션, 막대 그래프]
identifier: bar_chart_race1
sidebar: false
toc: true
ogimage: https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/073cb359-8bf3-5a23-c6ba-d4c86cd704a1.gif
---


본 포스트의 원문은 아래의 URL에서 확인하실 수 있습니다. 본 포스트는 원작자에게 동의를 구한 뒤 한국어로 번역하였습니다.

- [ぬめぬめ動く棒グラフ Bar Chart Race を描いてみよう: 準備編](https://qiita.com/eigs/items/62fbc0b6bdc5e7094abf)

# 서론

최근에 자주 보이는 이런 플롯: 각 데이터의 시계열 변화를 등수와 함께 표현하는 플롯입니다. 시간이 지남에 따라 등수가 변경되기 때문에 Bar Chart Race라고 불리는 것 같고, 검색하면 다양한 데이터의 시각화를 볼 수 있습니다.

<img src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/073cb359-8bf3-5a23-c6ba-d4c86cd704a1.gif" alt="attach:cat" title="attach:cat" width=500px>

이것을 MATLAB에서 작성할 수 없을까..라는 의견이 들어와서 해보았습니다.

**MATLAB 코드는 여기 [GitHub: BarChartRaceAnimation](https://github.com/minoue-xx/BarChartRaceAnimation)**


이번에는 준비 편으로 그리기에 필요한 요소가 갖추어져 있는지 확인합니다. `barh` 함수의 기능을 확인해보겠습니다.

계속해서 이어지는 부분은 여기에서 확인해주세요: [꿈틀 꿈틀 움직이는 막대 그래프 Bar Chart Race 그리기: 구현 편](bar_chart_race2.html)

# 가로 막대 그래프 플롯

먼저 `barh` 함수를 사용하여 막대 그래프를 그려보겠습니다.

```matlab
clear; close all
x = 1:5;
y = (1:5)/10;
handle_bar = barh(x,y);
```

<img src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/b5c8c0c3-c1f5-a049-8314-703c1d21f6e1.png" alt="attach:cat" title="attach:cat" width=500px>

간단합니다. x는 세로 위치를, y는 막대의 길이를 결정합니다.

`barh` 함수의 약간 혼동스러운 점은 x가 세로축 상의 위치, y가 해당하는 막대의 길이라는 점입니다. 직관적으로 x와 y가 반전되어 있는 것처럼 느껴집니다.


# 막대 그래프의 막대 위치 지정 (정수)


속성을 살펴보겠습니다.

```
handle_bar = 
  Bar의 속성:

    BarLayout: 'grouped'
     BarWidth: 0.8000
    FaceColor: [0 0.4470 0.7410]
    EdgeColor: [0 0 0]
    BaseValue: 0
        XData: [1 2 3 4 5]
        YData: [0.1000 0.2000 0.3000 0.4000 0.5000]

```

막대 그래프의 위치(세로 방향)는 `XData` 속성을 변경할 수 있을 것 같습니다. 예를 들어 2와 3을 교환해보겠습니다.

```matlab
handle_bar.XData = [1,3,2,4,5];
```

<img src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/96738e07-1e1b-d2d4-df00-fe23d4dbce11.png" alt="attach:cat" title="attach:cat" width=500px>

3과 2의 위치가 바뀌었습니다.

# 막대 그래프의 막대 위치 지정하기 (소수점)

소수점 (불규칙한 위치 지정)도 가능하다면, 순위가 바뀌는 전환을 표현할 수 있을 것 같습니다.

2를 2.8로, 3을 2.2로 변경하여 **서로 지나치는 후**를 표현해보겠습니다.

```matlab
handle_bar.XData = [1,2.8,2.2,4,5];
```

<img src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/e9d2f744-d314-b09f-2377-139b9c0fd7e8.png" alt="attach:cat" title="attach:cat" width=500px>

## 조금 다른 점

위치가 바뀌긴 했지만 뭔가 이상합니다. 네, 막대의 너비가 좁아졌습니다!

이것은 `barh` 함수가 각각의 막대가 겹치지 않도록 그리기 위해 자동으로 조정해주기 때문입니다. 음, 이해는 되지만 조금은 아쉽네요.

이 문제를 해결하기 위해서는 `BarWidth` 속성을 사용해야 합니다.

> 기본값은 `0.8`이며, MATLAB에서는 약간의 간격을 두고 각 막대가 표시됩니다. 이 속성을 `1`로 설정하면 막대들이 간격 없이 표시됩니다. 참조: [Bar Properties](https://www.mathworks.com/help/matlab/ref/matlab.graphics.chart.primitive.bar-properties.html?s_eid=PSM_29435)

```
handle_bar.BarWidth 
= 0.8000
```

# `BarWidth` 속성


그렇다면 이 값을 어떻게 설정해야 할까요? 간격이 정확히 1이었을 때에는 0.8로 괜찮은 표시였습니다. 그렇다면 직관적으로 데이터의 폭에 반비례하도록 `BarWidth` 값을 크게 설정하면 어떨까요?

해보겠습니다. 현재는

```matlab
tmp = handle_bar.XData
```
```
tmp = 1x5    
    1.0000    2.8000    2.2000    4.0000    5.0000

```

위와 같은 위치 관계이므로, 가장 가까운 위치에 있는 막대 사이의 거리를 사용하여 계산해보겠습니다.

```matlab
scaleWidth = min(diff(sort(tmp)))
```
```
scaleWidth = 0.6000
```

일단 `sort`를 한 이유는 순서가 반대로 되어 있기 때문입니다. 이 값을 사용하여 `BarWidth` 값을 기본값인 0.8과 같은 모양으로 변경해보겠습니다.

```matlab
handle_bar.BarWidth = 0.8/scaleWidth;
```

<img src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/95e8b338-9e24-8ff0-b845-a3c1a9a0638d.png" alt="attach:cat" title="attach:cat" width=500px>

오, 잘 된 것 같습니다.

이제 y 축의 위치를 랭킹(순위)에 해당하는 것으로 `XData` 속성을 변경하면 됩니다. 막대의 위치를 부드럽게 전환하기 위해 랭킹 교환 부분을 내삽하여 조금씩 순위가 변경되도록 만들면, 부드러운 전환을 표현할 수 있을 것 같습니다!

# 축 및 표시

y 축에 소수점이 표시되는 것이 거슬립니다. 이 부분을 깔끔하게 처리해보겠습니다.

사용할 것은 `Axes` 객체의 `YTick`과 `YTickLabel`입니다. 각각의 막대의 라벨은

```matlab
names = ["A","B","C","D","E"];
```

으로 지정합니다. 먼저 라벨을 표시할 위치인 `YTick`을 지정합니다. 랭킹(위치)에 해당하는 `XData` 속성 값을 그대로 넣어보겠습니다.

```matlab
handle_axes = gca;
handle_axes.YTick = handle_bar.XData;
```

```
에러: 값은 단일 또는 배정밀도 벡터여야 하며, 값이 증가해야 합니다.
```
# YTick은 단조 증가해야 함

에러가 발생했습니다. `YTick`에는 **단조 증가**하는 값을 제공해야 오류가 발생하지 않습니다. 정렬을 해보겠습니다. (작은 순서대로)

```matlab
[tmp,idx] = sort(handle_bar.XData,'ascend');
```

`XData`를 정렬한 결과에 따라 막대의 이름인 `names`의 순서도 변경해야 하므로, 두 번째 출력 변수 `idx`도 사용합니다.

```matlab
handle_axes.YTick = tmp;
handle_axes.YTickLabel = names(idx);
```

<img src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/106e214d-ccea-eda9-5981-f742a3d50d8c.png" alt="attach:cat" title="attach:cat" width=500px>

B와 C가 교환되었다는 느낌이 드네요!

# 아쉬운 점: 색상 문제

`barh`의 아쉬운 점은 하나의 막대 객체에 대해 하나의 색상만 지정할 수 있다는 것입니다.

**추가 사항 (2020/1/22)**

[nonlinopt](https://twitter.com/nonlinopt) 님의 [지적](https://twitter.com/nonlinopt/status/1219569299188137989)을 받아 `CData` 속성을 사용하여 막대를 개별적으로 색상으로 나눌 수 있다는 것을 알게 되었습니다. nonlinopt 님께 감사드립니다.

<img src="https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-07-17-bar_chart_race1/cdata.png">

```matlab

b = bar(1:10,'FaceColor','flat');
b.CData(2,:) = [0 0.8 0.8];
```
이런 느낌이군요. 참고: [Bar Properties](https://kr.mathworks.com/help/matlab/ref/matlab.graphics.chart.primitive.bar-properties.html)

또한, MATLAB의 릴리스 노트를 다시 확인해본 결과 `CData` 속성을 사용할 수 있는 것은 R2017b부터이므로, R2017a 이전 버전을 사용하는 경우에는 아래 방법을 사용해볼 수도 있습니다.

**추가 사항 여기까지**

그러므로, 색상 종류만 다른 `barh`를 실행하여 다른 막대 객체를 생성하면 될 것 같습니다.

```matlab
figure
x = 1:5;
y1 = [1:4,0]/10;
y2 = [0,0,0,0,5]/10;
handle_bar1 = barh(x,y1);
hold on
handle_bar2 = barh(x,y2);
hold off
```

<img src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/466955c6-ef96-4cc4-db25-6b124fd83019.png" alt="attach:cat" title="attach:cat" width=500px>

# 요약

준비 편은 여기까지입니다! 색상의 수만큼 bar 객체를 만들면 여러 가지로 복잡해질 수 있지만, 오히려 다양한 사용자 정의가 가능하여 좋을 수도 있습니다.

할 수 있을 것 같습니다. 다음은 샘플 데이터를 사용하여 랭킹이 변동하는 애니메이션을 작성해보겠습니다.

해야 할 것은 다음 두 가지입니다.

   - 여러 시계열 데이터의 각 시점에서의 값의 순위 매기기
   - 순위가 변경되는 전환 부분을 표시하기 위한 데이터 내삽

이 두 가지를 할 수 있다면, 나머지는 막대 객체에 값을 넣어주기만 하면 될 것 같습니다! (아마도)

