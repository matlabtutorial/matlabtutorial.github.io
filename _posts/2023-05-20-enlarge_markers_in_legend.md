---
title: legend의 마커사이즈 키우기
published: true
permalink: enlarge_markers_in_legend.html
tags: [blog]
identifier: enlarge_markers_in_legend
sidebar: false
toc: true
---

MATLAB에서 그린 그림에서 가끔 legend 안의 마커 크기만 키우고 싶을 때가 있다. 이럴 땐 "findobj" 함수를 사용해서 legend 내부 아이콘의 크기만 키워보자. 

<p align = "center">
  <img src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/master/images/blog_posts/2023-05-20-enlarge_markers_in_legend/pic1.png">
  <br>
  그림 1. findobj 함수를 이용하면 legend 안의 마커의 크기만 크게 만들 수 있다.
</p>

<a target = "_blank" href= "https://matlab.mathworks.com/open/github/v1?repo=matlabtutorial/matlabtutorial.github.io&file=m_files/blog_posts/2023-05-20-enlarge_markers_in_legend/to_enlarge_markers_in_legend.m">
<span class="label label-success">Open in MATLAB Online</span>
</a>

```matlab
clear; close all; clc;

rng(1)

figure;
h1 = plot(1:10, rand(1,10), 'o', 'markerfacecolor', [0, 0.447, 0.741]);
hold on;
h2 = plot(1:10, rand(1,10), 'o', 'markerfacecolor', [0.85, 0.325, 0.098]);
h3 = plot(1:10, rand(1,10), 'o', 'markerfacecolor', [0.929, 0.694, 0.125]);

h = [h1, h2, h3];

[~, icons] = legend(h,'LGD 1', 'LGD 2', 'LGD 3');

% Type은 line이면서 Marker는 없지는 않는 것(즉, 라인이지만 마커는 있는 오브젝트)을 찾아야 함.
icons = findobj(icons,'Type','line','-not','Marker','none'); 

set(icons, 'Markersize',12)
```