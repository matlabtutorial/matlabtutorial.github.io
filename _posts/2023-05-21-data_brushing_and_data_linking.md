---
title: 데이터 브러싱과 데이터 링킹
published: true
permalink: data_brushing_and_data_linking.html
summary: "시각적으로 데이터들을 선택하고 데이터 간 연관성을 찾을 수 있는 직관적인 방법"
tags: [blog]
identifier: data_brushing_and_data_linking
sidebar: false
toc: true
---

# Data Brushing

브러싱(brushing)은 MATLAB의 그래픽스 기능 중 아주 유용한 기능이지만 소외 받고 있는 기능이라는 생각이 들어 여기서 짧게나마 공유해보고자 한다. 브러싱을 이용하면 아래와 같은 일들이 가능하다. 

* 플롯 상의 특정 데이터들만 대화형 방식으로 선택해 표시할 수 있다.
* 플롯 상의 특정 데이터들만 대화형 방식으로 선택해 색깔을 바꿀 수 있다.
* 플롯 상의 특정 데이터들만 대화형 방식으로 선택해 저장할 수 있다.
* 플롯 상의 특정 데이터들만 대화형 방식으로 선택해 제거할 수 있다.

## 기본 사용법

브러싱을 이용하기 위해서는 커맨드 윈도우에 "brush"라고 입력하거나 axes 위에 있는 아이콘 
<img src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-05-21-data_brushing_and_data_linking/brush_icon.png">
을 클릭하면 된다

## 플롯 상의 데이터 표시

아래와 같은 코드를 이용해 얻을 수 있는 데이터 분포에서 특정 범위의 사각형 안에 있는 데이터만 표시하고 싶은 경우 브러싱을 사용할 수 있다.

```matlab
clear; close all; clc;

x = randn(1000, 2);
figure; plot(x(:,1), x(:,2), '.');
% brush('on'); % 스크립트에서 직접 브러싱을 켤 때 사용
```

figure에서 아래와 같이 브러싱을 켜주고 표시하고자 하는 부분을 드래그하자.

<p align = "center">
  <img width = "500" src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-05-21-data_brushing_and_data_linking/fig_untitled2.png">
  <br>
</p>

브러싱이 완료된 후에 그림을 저장하면 아래와 같이 브러싱이 표시된 채로 플롯이 저장된다. 

<p align = "center">
  <img width = "500" src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-05-21-data_brushing_and_data_linking/untitled2.png">
  <br>
</p>

## 플롯 상의 데이터 색깔 변경

```matlab
x = randn(1000, 2);
figure; plot(x(:,1), x(:,2), '.');
% 커맨드를 이용하여 색깔을 변경하려는 경우
% b = brush;
% b.Enable = 'on';
% b.Color = 'g';
```

브러싱 된 데이터들을 다른 색깔로 표시하려는 경우 아래와 같이 아무 데이터나 브러싱을 수행한 뒤에 오른쪽 마우스 버튼을 클릭하여 "color"로 들어가도록 하자. 그런 다음 원하는 색깔을 선택하면 새로운 색깔로 브러싱하여 데이터를 표시할 수 있다.

<p align = "center">
  <img width = "500" src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-05-21-data_brushing_and_data_linking/brushing_color.png">
  <br>
</p>

아래의 예시에서는 초록색으로 브러싱을 수행해보았다.

<p align = "center">
  <img width = "500" src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-05-21-data_brushing_and_data_linking/green_brushing.png">
  <br>
</p>

## 플롯 상의 데이터 저장

브러싱을 수행한 뒤에 데이터 브러싱된 데이터 값을 마우스 오른쪽 버튼으로 클릭한 다음 "Export Brushed"를 클릭해준다.

<p align = "center">
  <img width = "500" src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-05-21-data_brushing_and_data_linking/export_brushed.png">
  <br>
</p>

이 데이터들을 가령 "brushedData"라고 저장한다면 아래와 같이 브러싱된 데이터들이 저장되는 것을 알 수 있다.

```
Variables have been created in the base workspace.
>> brushedData

brushedData =

    0.2204   -0.6212
    0.0698    0.3536
    0.0673   -0.1650
    0.7396    0.2620
    0.3968   -0.5204

... (이하 생략)

```
## 플롯 상의 데이터 제거

브러싱 기능을 이용하면 선택된 데이터만 삭제할 수 있다. 아래와 같이 지우고자 하는 데이터만 부분 선택한 뒤 마우스 우클릭하여 나타나는 "Remove Brushed"를 선택해보자.

<p align = "center">
  <img width = "500" src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-05-21-data_brushing_and_data_linking/remove_brushed.png">
  <br>
</p>

그러면 선택되었던 데이터들만 삭제되는 것을 알 수 있다.

<p align = "center">
  <img width = "500" src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-05-21-data_brushing_and_data_linking/after_removal.png">
  <br>
</p>

여기서 "Ctrl + Z"를 누르면 삭제된 것을 복원할 수도 있다. 이제, "Remove Unbrushed"를 선택하면 선택된 데이터만 남기고 나머지 데이터들은 지우는 것도 가능하다.

<p align = "center">
  <img width = "500" src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-05-21-data_brushing_and_data_linking/after_removal2.png">
  <br>
</p>

# Data Linking
https://www.mathworks.com/help/matlab/ref/matlab.graphics.internal.linkdata.html?s_tid=doc_ta

데이터 연결(data linking) 기능을 이용하면 차트와 해당 작업 변수를 동기화 할 수 있다. 다시 말해, 어떤 변수에 대해 데이터 연결 기능을 켜두면 이 변수를 plot 한 뒤에 데이터를 수정하면 자동으로 변경 사항이 업데이트 되어 plot에 반영된다. 데이터 연결 기능을 켜기 위해선 "linkdata" 함수를 이용하거나 figure 창의 
<img src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-05-21-data_brushing_and_data_linking/datalink_icon.png">
아이콘을 클릭할 수 있다


## 작업 공간 변수 변경 시 차트 업데이트

우선, 작업 공간 변수를 변경했을 때 플롯이 자동으로 업데이트 되는 예시를 확인해보도록 하자. 아래의 스크립트를 작동시켜 지수 함수의 그래프를 그려보자.

```matlab
clear; close all;

figure;
x = log(1:10);
y = exp(x);
plot(x, y, 'o');
linkdata on;
```

이 때, Command Window에 `y(5) = 10`이라고 입력하면 즉각 플롯이 수정되는 것을 알 수 있다.

<p align = "center">
  <img width = "500" src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-05-21-data_brushing_and_data_linking/exp_datalink_changed.png">
  <br>
</p>

## 차트 변경 시 작업 공간 데이터 업데이트

이번에는 플롯 상에서 브러싱 기능을 이용해 데이터를 삭제했을 때 데이터 연결 기능이 켜져 있을 때 작업 공간 상의 데이터에도 변경 사항이 적용되는 것을 확인해보도록 하자.

위 예제와 마찬가지의 플롯을 그려주고 데이터 연결 기능은 켜두도록 하자.

```matlab
clear; close all;

figure;
x = log(1:10);
y = exp(x);
plot(x, y, 'o');
linkdata on;
```


## 서로 다른 subplot의 데이터 연결

```matlab
A = rand(100, 3);

figure;
subplot(2,1,1);
plot(A(:,1),A(:,2),'.');
subplot(2,1,2);
plot(A(:,2),A(:,3),'.');
brush on
linkdata on
```

<p align = "center">
  <img src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-05-21-data_brushing_and_data_linking/temp.png">
  <br>
</p>