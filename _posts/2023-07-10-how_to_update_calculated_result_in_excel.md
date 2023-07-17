---
title: (번역) Excel 안의 계산 결과를 업데이트 하는 방법
published: true
permalink: how_to_update_calculated_result_in_excel.html
summary: "MATLAB에서 Excel 파일을 열지 않고도 Excel 함수를 이용한 결과물이 업데이트 될 수 있도록 하는 방법을 소개합니다."
tags: [번역, Excel, ExcelVBA]
identifier: how_to_update_calculated_result_in_excel
sidebar: false
toc: true
ogimage: https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-07-10-how_to_update_calculated_result_in_excel/translated_tweet.png
---

본 포스트의 원문은 아래의 URL에서 확인하실 수 있습니다. 본 포스트는 원작자에게 동의를 구한 뒤 한국어로 번역하였습니다.

- [【MATLAB】Excel 内での計算結果を更新させる方法](https://qiita.com/eigs/items/534724b58ce37c733d7c)

# 시작하면서

Excel 시트에 MATLAB으로 무언가 값을 출력하고, Excel을 여는 일 없이 MATLAB으로 출력한 값에 대응해 Excel 안에서 뭔가 계산처리를 동시에 하고싶다. 그럴 때에는 `'UseExcel'` 옵션을 사용하면 된다는 이야기입니다.

Twitter에서 두부샌드([@tohu_sand](https://twitter.com/tohu_sand))님과도 얘기를 주고 받았는데, Qiita(역주: 일본의 개발자 블로그 커뮤니티)에도 비망록으로써 남겨둡니다.

<p align = "center">
<a href = "https://twitter.com/tohu_sand/status/1322513635051151362?ref_src=twsrc%5Etfw">
<img src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-07-10-how_to_update_calculated_result_in_excel/translated_tweet.png"></a>
<br>
(번역된 트윗입니다.)
</p>

`'UseExcel'` 옵션은 R2019b부터 디폴트로 `'false'` 입니다만, 이전까지는 Excel을 사용할 수 있는 환경이라면 `'true'`라는 점에는 주의가 필요합니다. 릴리즈 노트는 [여기: UseExcel](https://kr.mathworks.com/help/matlab/release-notes.html?rntext=UseExcel&startrelease=R2018a&endrelease=R2020b&groupby=release&sortby=descending&searchHighlight=UseExcel)에서 볼 수 있습니다. 그래서 R2019a 이전 릴리즈를 사용하는 경우에는 특별히 의식할 필요가 있다고 생각합니다.

이 기사의 LiveScript 버전 (MATLAB)은 [GitHub: ActiveX-Excel-MATLAB](https://github.com/mathworks/ActiveX-Excel-MATLAB)에 있습니다.

# 사용 환경

* MATLAB R2020b

# 수행해 본 것

예를 들어 이런 식입니다.

```matlab
data = rand(5,5);
writematrix(data, 'example.xlsx', 'Range', 'A2:E6');
```

<img src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-07-10-how_to_update_calculated_result_in_excel/excel1.png">

MATLAB에서 입력값을 내보내고 총합은 Excel에서 계산합니다. (이정도의 계산이라면 MATLAB으로 해버리지...라고 얘기할 수도 있습니다만 어디까지나 예시입니다.)

Excel로 출력하는 방법에 따라서는 재차 Excel 파일을 열지 않으면 A9의 총합이 갱신되지 않습니다.

# 값이 갱신되지 않는다니?

A2:E6의 범위에 새로운 값을 MATLAB에서 출력해주더라도 그대로는 Excel쪽의 A9의 값이 변하지 않는 현상입니다. 예를들어 새로운 데이터를 써서 내보낸 후 Excel 내의 처리결과 (A9)를 확인해보면

```matlab
data = rand(5,5);
writematrix(data,'example.xlsx','Range','A2:E6');
readmatrix('example.xlsx','Range','A9:A9')
```
```
ans = 12.6398
```
```matlab
sum(data,'all')
```
```
ans = 12.0239
```

와 같이 값이 다르게되거나 A9의 값이 갱신되지 않는 함정에 빠지게 되는 것이죠.

물론 Excel 파일을 열면 결과는 갱신되지만, 하나하나 열어보는 것도 귀찮은 경우가 있을 수 있겠습니다.

# 왜 갱신되지 않는 것인가?

최근에는 [xlsread 함수](https://kr.mathworks.com/help/matlab/ref/xlsread.html?s_eid=PSM_29435)나 [xlswrie 함수](https://kr.mathworks.com/help/matlab/ref/xlswrite.html?s_eid=PSM_29435)는 비추천되고 ([왜 xlswrite는 추천하지 않는가?](how_to_control_width_of_excel_columns.html#왜-xlswrite는-추천하지-않는가?)) 있고, 대신 [writematrix 함수](https://kr.mathworks.com/help/matlab/ref/writematrix.html?s_eid=PSM_29435)나 [writetable 함수](https://kr.mathworks.com/help/matlab/ref/writetable.html?s_eid=PSM_29435) 등의 사용이 권장되고 있습니다.

그런데 [xlswrite 함수](https://kr.mathworks.com/help/matlab/ref/xlswrite.html?s_eid=PSM_29435)를 사용하면 제대로 갱신되는 것을 알 수 있습니다.

```matlab
data = rand(5,5);
xlswrite('example.xlsx',data,'A2:E6');
readmatrix('example.xlsx','Range','A9:A9')
```
```
ans = 11.9684
```
```matlab
sum(data,'all')
```
```
ans = 11.9684
```

다행이네요.

이런 결과가 나오는 이유는 [xlswrite 함수](https://kr.mathworks.com/help/matlab/ref/xlswrite.html?s_eid=PSM_29435)는 (Excel이 설치되어 있는 환경에 있다면) 함수가 동작할 때 Excel을 실행시키기 때문입니다. Excel이 실행되면 Excel 내의 계산을 실행하게 됩니다. [xlswrite 함수](https://kr.mathworks.com/help/matlab/ref/xlswrite.html?s_eid=PSM_29435)가 비추천되는 가장 큰 이유가 바로 Excel을 실행시켜 처리할 때 시간이 걸리기 때문으로 보입니다. [writematrix 함수](https://kr.mathworks.com/help/matlab/ref/writematrix.html?s_eid=PSM_29435) 등과 같은 비교적 새로운 함수는 (R2019b 버전 이후의 디폴트 설정으로는) Excel 프로그램을 사용하지 않고 데이터를 출력합니다.

참고: 거기다 자동계산을 멈추는 설정도 가능합니다. [Anyway to turn off Excel automatic calculation by a MatLab command for faster export ?](https://kr.mathworks.com/matlabcentral/answers/26847-anyway-to-turn-off-excel-automatic-calculation-by-a-matlab-command-for-faster-export?s_eid=PSM_29435)

# 그러면 어떻게 해야할까?

Excel을 실행하면 좋겠지만, 다른 좋은 방법도 있다면 댓글로 알려주세요.

## 방법 1

[writematrix 함수](https://kr.mathworks.com/help/matlab/ref/writematrix.html?s_eid=PSM_29435)에는 `'UseExcel'`이라는 옵션이 있는데 아무것도 설정하지 않으면 `'false'`로 설정하게 되어 Excel을 사용하지 않게 됩니다. 여기를 `'true'`로 변경하면 해결할 수 있습니다.

```matlab
data = rand(5,5);
writematrix(data,'example.xlsx','Range','A2:E6','UseExcel',true);
readmatrix('example.xlsx','Range','A9:A9')
```
```
ans = 13.7890
```
```matlab
sum(data,'all')
```
```
ans = 13.7890
```

잘 되었네요. 총 합 (A9)도 제대로 업데이트 되었습니다.

## 방법 2

위에서 이미 본 방법이지만 [xlswrite 함수](https://kr.mathworks.com/help/matlab/ref/xlswrite.html?s_eid=PSM_29435)도 비추천이지만 필요하다면 사용할 수도 있겠죠 (개인적 견해). [xlswrite 함수](https://kr.mathworks.com/help/matlab/ref/xlswrite.html?s_eid=PSM_29435)를 사용하면 Excel을 실행하기 때문에 계산 결과도 업데이트 됩니다.

## 방법 3

# 마치며