---
title: (번역) Excel 파일의 셀 폭 자동 조정
published: true
permalink: how_to_control_width_of_excel_columns.html
summary: "MATLAB에서 Excel 파일 출력 시 엑셀의 셀(열) 폭을 자동으로 조정할 수 있는 방법을 소개합니다."
tags: [번역, Excel, ExcelVBA]
identifier: how_to_control_width_of_excel_columns
sidebar: false
toc: true
ogimage: https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F149511%2F298e69ac-89f4-496c-d160-bc2f379674d2.png
---

본 포스트의 원문은 아래의 URL에서 확인하실 수 있습니다. 본 포스트는 원작자에게 동의를 구한 뒤 한국어로 번역하였습니다.

- [【MATLAB】Excel ファイルのセル幅自動調整](https://qiita.com/eigs/items/3a71c0da1744e48e9bca)

# 수행해 본 것

(MATLAB에서) Excel 파일로 출력 시 셀의 폭이 아쉬울 수 있습니다. 이것을 자동 조절되게 해보았습니다. 다만, 유감스럽지만 MATLAB측의 기능으로는 가능하지 않아보였기 때문에 MATLAB을 통해 Excel 기능을 이용하였습니다.

공식 페이지라고 할 수 있는 것은 여기를 확인하여 주십시오: [Read Spreadsheet Data Using Excel as Automation Server](https://kr.mathworks.com/help/matlab/matlab_external/example-reading-excel-spreadsheet-data.html?lang=en)

`xlswrite`를 사용하는 방법은 아래의 "[왜 xlswrite는 추천하지 않는가?](https://matlabtutorial.github.io/how_to_control_width_of_excel_columns.html#%EC%99%9C-xlswrite%EB%8A%94-%EC%B6%94%EC%B2%9C%ED%95%98%EC%A7%80-%EC%95%8A%EB%8A%94%EA%B0%80)" 글꼭지을 읽어보셔도 좋을 것 같습니다.

LiveScript판 (MATLAB)은 [GitHub: ActiveX-Excel-MATLAB](https://github.com/mathworks/ActiveX-Excel-MATLAB)[^1]에 올라가있습니다.

[^1]: Livescript에서 markdown으로 변경하는 것은 <a href = "https://kr.mathworks.com/matlabcentral/fileexchange/73993-livescript2markdown-matlab-s-live-scripts-to-markdown?s_eid=PSM_29435">livescript2markdown​: MATLAB's live scripts to markdown</a>을 사용하고 있습니다.

## 셀 폭 조정? 구체적으로 어떤 것이지?

예를 들어 테이블 형식으로

```matlab
data = ["fileEnsembleDatastore","ds","datastore"];
data = array2table(data)
```

|   | data1                   | data2 | data3       |
|---|-------------------------|-------|-------------|
| 1 | "fileEnsembleDataStore" | "ds"  | "datastore" |

라는 데이터를 엑셀에 써보내 보겠습니다.

```matlab
filename = 'undisiredFormat.xlsx';
writetable(data,filename);
```

엑셀에서 열어보면 약간 아쉬운 마음이 들게 됩니다.

<img src = "https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F149511%2F3574dbfb-2d2e-d63b-e6bc-9775e24e08bf.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&w=1400&fit=max&s=5d8a39fb9dfbf9dd15aad8ab8f602142">

이것을

```matlab
autoFitCellWidth(filename);
```

<img src = "https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F149511%2F298e69ac-89f4-496c-d160-bc2f379674d2.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&w=1400&fit=max&s=3df2e0191b380bb517d7d519bdd332f0">

처럼 데이터의 길이에 맞게 폭을 조절해보겠다는 이야기입니다.

# 여담: Excel에 써보내기 위한 함수

MATLAB에서 Excel 파일로 출력해주는 함수라고하면 `xlswrite` 함수가 가장 오래 사용되어 왔습니다만, 최근에는

* [writetable 함수](https://kr.mathworks.com/help/matlab/ref/writetable.html?s_eid=PSM_29435) (R2013b ~): 테이블형 변수 출력
* [writetimetable 함수](https://kr.mathworks.com/help/matlab/ref/writetimetable.html?s_eid=PSM_29435) (R2019a ~): 타임테이블형 변수 출력
* [wirtematrix 함수](https://kr.mathworks.com/help/matlab/ref/writematrix.html?s_eid=PSM_29435) (R2019a ~): array(double형/string형)의 출력
* [writecell 함수](https://kr.mathworks.com/help/matlab/ref/writecell.html?s_eid=PSM_29435) (R2019a ~): cell 배열 출력

와 같은 것들이 추천되고 있습니다. 같은 방식으로 [csvwrite 함수](https://kr.mathworks.com/help/matlab/ref/csvwrite.html?s_eid=PSM_29435)도 사용을 권장하지 않는다는 메시지가 나오는 것 같습니다.

## 왜 xlswrite는 추천하지 않는가?

내보내기 속도가 다릅니다. 이 예에서는 100배 이상 다릅니다.

```matlab
data = rand(10,10);
tic
xlswrite('test_xlswrite.xlsx',data);
toc
```

```
경과 시간은 8.999516 초 입니다.
```

```matlab
tic
writematrix(data,'test_writematrix.xlsx');
toc
```

```
경과 시간은 0.071814 초 입니다.
```

확실히 다르네요.

`xlswrite` 함수는 `Excel`을 실행해야 하기 때문에 시간이 걸립니다. 게다가 불편하게도 여러 번 호출하면 매번 Excel을 시작하고 닫고를 반복하기 때문에 시간이 많이 걸립니다. 가능하면 "write"로 시작하는 함수들을 사용합시다.

# 셀 폭 조정

그러면 본격적으로 함수의 내용을 보는 편이 빠르겠네요. VBA에 익숙하신 분들이라면 감이 오시겠지만, 어떻습니까?

```
function autoFitCellWidth(filename)

    % Excel 파일의 절대 경로를 획득
    filepath = which(filename);
    
    % Excel에 대해 ActiveX를 연다
    h = actxserver('excel.application');
    wb = h.WorkBooks.Open(filepath);
    
    % UsedRange: 데이터가 들어가있는 범위의
    % EntireColumn: 열 전체를
    % AutoFit: 데이터에 맞는 폭으로 변경한다.
    wb.ActiveSheet.UsedRange.EntireColumn.AutoFit;
    
    % 지정한 파일명을 저장하고 엑셀을 닫는다.
    wb.SaveAs(filename);
    wb.Close;
    h.Quit;
    h.delete;
    % 주의: 이 쫌에서 Close/Quit/Delete 해두지 않으면 나중에 복잡해집니다.
    % (다른 앱에서 사용하고 있는데 열린다던가, 지울 수 없게 되는 이슈 등이 발생합니다)
    % 이럴 때는 PC를 재부팅해주면 괜찮아집니다.
end
```

ActiveSheet이나 UsedRange나 EntireColumn같은 것들은 모두 Excel 쪽의 명령어입니다. 같은 요령으로 그 밖에도 Excel을 활용할 수 있겠죠?

## 기타 편집 작업 예시

범위를 지정해서 동일한 작업을 한다고 하면

```matlab
    range = 'A1:H5';
    wbrange = wb.ActiveSheet.get('Range',range);
    wbrange.EntireColumn.AutoFit;
```

이라던가 셀 폭을 결정해서 입력해주고 싶다면

```matlab
    wbrange.EntireColumn.ColumnWidth = 20;
```

등으로 할 수 있겠네요.

그리고 셀의 배경색이나 글자 색깔을 바꾸려고한다면,

```matlab
    % 셀 배경색 변경
    wb.ActiveSheet.UsedRange.Interior.Color=hex2dec('00FF00'); % 초록
    % 폰트색
    wb.ActiveSheet.UsedRange.Font.Color=hex2dec('0000FF'); % 빨강
    % 색깔은 10진수의 BGR의 조합으로 지정됩니다.
    % 빨강: 0000FF
    % 파랑: FF00FF
    % 초록: 00FF00
    % 검정: 000000
    % 하양: FFFFFF
```

# 참고

* [Office VBA Reference/Excel/Object model/Range object](https://learn.microsoft.com/en-us/office/vba/api/excel.range(object))
* [TipsFound: VBA 열 폭을 조정하다](https://www.tipsfound.com/vba/09010-vba)
* [MATLAB Answers: ActiveX를 이용해서 Excel의 임의의 셀에 이미지를 삽입할 수 있습니까?](https://kr.mathworks.com/matlabcentral/answers/387921-activex-excel?s_eid=PSM_29435)
* [MATLAB Answers: MATLAB에서 Excel Spreadsheet에 셀 배경색이나 폰트 색상을 지정해서 데이터를 써보내려면 어떻게 하는 것이 좋습니까?](https://kr.mathworks.com/matlabcentral/answers/95482-matlab-excel-spreadsheet?s_eid=PSM_29435&requestedDomain=)
* [MATLAB Answers: XLSWRITE 함수로 지정한 워크 시트만 가진 Excel 파일을 만드는 것이 가능합니까?](https://kr.mathworks.com/matlabcentral/answers/99172-xlswrite-excel?s_eid=PSM_29435)
* [MATLAB Answers: Excel 파일의 시트명을 변경하는 것이 가능합니까?](https://kr.mathworks.com/matlabcentral/answers/102016-excel?s_eid=PSM_29435&requestedDomain=)
* [Can MATLAB pre-format individual cells when writing data to an EXCEL spreadsheet?](https://kr.mathworks.com/matlabcentral/answers/216917-can-matlab-pre-format-individual-cells-when-writing-data-to-an-excel-spreadsheet?s_eid=PSM_29435)

# Appendix: autoFitCellWidth 함수

```
function autoFitCellWidth(filename)

    % Excel 파일의 절대 경로를 획득
    filepath = which(filename);
    
    % Excel에 대해 ActiveX를 연다
    h = actxserver('excel.application');
    wb = h.WorkBooks.Open(filepath);
    
    % UsedRange: 데이터가 들어가있는 범위의
    % EntireColumn: 열 전체를
    % AutoFit: 데이터에 맞는 폭으로 변경한다.
    wb.ActiveSheet.UsedRange.EntireColumn.AutoFit;
    
    % 지정한 파일명을 저장하고 엑셀을 닫는다.
    wb.SaveAs(filename);
    wb.Close;
    h.Quit;
    h.delete;
    % 주의: 이 쫌에서 Close/Quit/Delete 해두지 않으면 나중에 복잡해집니다.
    % (다른 앱에서 사용하고 있는데 열린다던가, 지울 수 없게 되는 이슈 등이 발생합니다)
    % 이럴 때는 PC를 재부팅해주면 괜찮아집니다.
end
```