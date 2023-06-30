---
title: 【번역】【MATLAB】하이퍼링크가 붙은 텍스트가 포함된 엑셀 자동화
published: true
permalink: auto_excel_with_hyperlinked_texts.html
summary: "엑셀에 하이퍼링크를 붙인채로 텍스트를 출력하는 방법에 대해 알아보자."
tags: [번역, Excel, QiitaAPI, 자동화]
identifier: auto_excel_with_hyperlinked_texts
sidebar: false
toc: true
---

본 포스트의 원문은 아래의 URL에서 확인하실 수 있습니다. 본 포스트는 원작자에게 동의를 구한 뒤 한국어로 번역하였습니다.

- [【MATLAB】ハイパーリンク付きテキストのExcel への書き込み自動化](https://qiita.com/eigs/items/26279a79319992ac123d)

# 수행해본 것

하이퍼링크가 붙어있는 텍스트를 MATLAB에서 엑셀로 쓰는 작업을 수행했습니다.

웹사이트 리스트(2000개 정도)를 클릭하면 링크를 열어주는 형식으로 엑셀에 정리하는 것을 MATLAB을 이용하였으며, 포인트들을 소개하고자 합니다. 혹시 같은 일을 당했을 때에는 참고해주세요 (허허).

## 핵심 포인트

1. 엑셀의 `hyperlink` 함수
2. 큰 따옴표를 포함하는 문자열을 `string` 형으로 정의하는 방법
3. `writecell` vs `xlswrite`
4. error code: 0x800A03EC

여기서는 샘플로써 제가 지금까지 투고한 Qiita 포스팅을 리스트업하는 것으로 하겠습니다. 결과물입니다.

<p align = "center">
    <img src ="https://camo.qiitausercontent.com/edc2cfa781722c4fe7eaf080441d62f98efe3075/68747470733a2f2f71696974612d696d6167652d73746f72652e73332e61702d6e6f727468656173742d312e616d617a6f6e6177732e636f6d2f302f3134393531312f34366438326463362d623863342d353065622d306430392d6631383238353433373438652e706e67">
    <br>
</p>

## 실행환경

Windows 10

Excel[^1]

MATLAB R2019b, 기타 툴박스 없음[^2]

[^1]: 그다지 엑셀의 버전을 신경쓰지 않았습니다만, 관계 있을까요?

[^2]: table형 변수와 `xlswrite` 함수가 사용된다면 R2019b 보다 예전 버전도 OK 일 것입니다. (확인 해보지는 않음)

# 일단은 `hyperlink` on Excel에 대해서

"음, 어쩌지? ActiveX 사용하면 번거로운데..." 라고 생각하면서 우선은 구글에서 검색해 아래의 MATLAB Answers를 발견했습니다.

[MATLAB Answers: Add a hyperlink in excell through matlab](https://kr.mathworks.com/matlabcentral/answers/22768-add-a-hyperlink-in-excell-through-matlab?s_eid=PSM_29435)

엑셀에 `HYPERLINK`라는 함수가 있는 것 같습니다. 예를들어 엑셀의 셀에

```
= hyperlink("https://qitta.com/eigs", "eigs@qiita")
```

라고 쓰면 됩니다.

매트랩에서 이 수식을 문자열로 정의하고, 엑셀에 출력한다면 충분합니다. 한번 해보겠습니다.

```matlab
url = "https://qiita.com/eigs";
text = "eigs@qiita"; 
string2Excel = "=HYPERLINK(""" + url + """,""" + text + """" + ")"
xlswrite('sample1.xlsx',{string2Excel}); % 1x1 cell 로써 출력
```

실행해보면,

<p align = "center">
    <img src ="https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F149511%2F4ccfcd95-25be-bcce-19ad-66a529a2ebc3.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&w=1400&fit=max&s=abb332ddc6424eb33b926e28fec45c9c">
    <br>
</p>

이런식이 됩니다. 하이퍼링크 처리가 잘 되었습니다.

# 주의 사항: `writecell` vs `xlswrite`

R2019a부터 `writecell`이나 `writematrix` 같은 함수가 등장해서 Excel에 데이터를 출력할 때 사용할 함수로써 추천되고 있습니다. 실제로 데이터를 쓸 때 속도는 `xlswrite`에 비해서 확실히 빨라진 케이스가 많습니다. 그렇지만 이번에 엑셀에 써넣은 수식을 실행할 때에는 `xlswrite`가 아니면 잘 되지 않았습니다.

`writecell`로 실행한 것이 아래와 같습니다.

<p align = "center">
    <img src ="https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F149511%2F68bf61ca-3968-5e06-4cbe-b375452964b5.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&w=1400&fit=max&s=76f112e18307c0b2f062c77d1560dc83">
    <br>
</p>

문자로써 기록되버립니다.

**\[2019년 10월 28일 추가\]**

`writecell`로 실행할 경우에는 `'UseExcel'` 옵션을 `true`로 설정해주면 잘 된다는 것을 알게되었습니다.

# 여러 행으로 정리 후 써서 출력해봅시다

이번 샘플 데이터는 과거에 작성한 포스팅입니다.

<p align = "center">
    <img src ="https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F149511%2Fd9d29bd1-ac43-1bbc-d041-badae465d281.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&w=1400&fit=max&s=caaccdff67331b71e796c05e1ca258ad">
    <br>
</p>

이것을 정리해서 엑셀에 정리하겠습니다. Qiita API를 사용해서 이 데이터를 취합한 MATLAB 코드를 페이지 하단에 기재해두었으니 흥미있으신 분들은 봐주시기 바랍니다.

## Excel로 내보낼 수식 작성

Excel에 써보내는 수식을 만들어봅시다. `itemList.url`과 `itemList.title`을 `hyperlink` 함수 내에 넣은 문자열을 만들면 OK입니다.

```matlab
% 타이틀의 "에 대응
itemList.title2Excel = replace(itemList.title,"""",""""""); % 이 부분이 중요합니다! 뒤에 더 적도록 하겠습니다.

% 수식 작성
itemList.toExcel = "=hyperlink(""" + itemList.url + """,""" ...
 + itemList.title2Excel + """" + ")";
```

첫번째의 수식을 보면,

```
>> itemList.toExcel(1)
ans = 
    "=hyperlink("https://qiita.com/eigs/items/bfba81f1d3e2d7690c58","MATLAB Answers에서 답변해주신 분의 주간 랭킹(일본)")"
```

라고 쓰여져 있으며, 이 수식을 엑셀에 적어 넣으면 잘 작동합니다.

## 몇 개의 큰 따옴표를 붙여넣어야 하는지에 관한 문제

MATLAB의 `string` 타입을 정의할 때에는 큰 따옴표 사이에 문자열을 끼워넣어야 합니다. 또, 엑셀의 수식 입력값도 큰 따옴표사이에 끼워 넣을 필요가 있습니다. 결과적으로 써서 보낼 문자열 안에 큰 따옴표가 들어가버리게 되고, 그 큰 따옴표는 (또 다른) 큰 따옴표 안에 들어갈 필요가 있게 되므로 최종적으로 큰 따옴표 투성이가 되어 코드의 가독성을 좋지 않게 만들어 버립니다.

예를 들어 큰 따옴표 문자 하나를 `string` 타입으로 정의하려고 하면 """"가 됩니다. 그 외에도

```
text = "【MATLAB】패스설정에관한""기초""지식"; 
```

에서 "기초"를 `string` 타입의 문자열 내에 넣으려고 하면 ""기초""처럼 큰 따옴표 하나 앞에 또 다른 큰 따옴표를 붙여줘야 합니다.

```
string2Excel = "=HYPERLINK(""" + url + """,""" + text + """" + ")"
```

이 경우는 더 복잡하게 들어가 있습니다만, Excel의 수식 안에서 "(url)", "(text)"라고 입력하기 위해서 4개의 큰 따옴표가 추가된 것입니다.

결국은 잘 들어갈 때까지 큰 따옴표를 더하거나 빼면서 시행착오를 겪게 되겠네요.

## 타이틀에 큰따옴표가 들어가있는 경우는 주의하세요.

이번 타이틀에 큰따옴표가 들어가있어서 그대로 `hyperlink` 함수에 넣으려고하면 엑셀 쪽에서 에러를 발생시킵니다. 엑셀 쪽에서 수식을 평가할때 그제서야 오류가 발생하기 때문에 (MATLAB 입장에서는) 명확한 오류 메시지가 나오지 않으면서 쓰기에 실패하게 됩니다. 원인을 찾는데 꽤 고생했습니다.

```
itemList.title2Excel = replace(itemList.title,"""",""""""); % 제일 중요!
```

이것으로 대응하고 있습니다. `replace` 함수로 """" ("라는 문자열)을 """""" (""라는 문자열)로 값을 변환해주는 내용입니다. 결과적으로,

```
>> itemList.title(4)
ans = 
    "【MATLAB】패스 설정에 관한 "기초" 지식"
```

이

```
>> itemList.title2Excel(4)
ans = 
    "【MATLAB】패스 설정에 관한 ""기초"" 지식"
```

으로 한 개짜리 큰 따옴표가 두 개가 되어버렸네요. 이러면 엑셀쪽에서 처리가 가능합니다. 에러는 아래 스크립트를 실행해서 확인해볼 수 있습니다.

```
url = "http";
text = "【MATLAB】패스 설정에 관한 ""기초"" 지식"; 
string2Excel = "=HYPERLINK(""" + url + """,""" + text + """" + ")"
xlswrite('error1.xlsx',{string2Excel}); % 1x1 cell として出力
```

(역주: 에러 메시지는 아래와 같습니다.)

<span style = "color:red">Error using xlswrite<br>
Error: Object returned error code: 0x800A03EC</span>

참고: [Why do I receive an error (error code: 0x800A03EC) when using XLSWRITE in MATLAB?](https://kr.mathworks.com/matlabcentral/answers/101631-why-do-i-receive-an-error-error-code-0x800a03ec-when-using-xlswrite-in-matlab?s_eid=PSM_29435)

## 문자열을 엑셀로 써보내기

```matlab
% 포스팅 일자와 제목을 출력합니다.
tmp = table2cell(itemList(:,["created_at","toExcel"]));
xlswrite('qiitaTitles.xlsx',tmp);

% 제목만 출력하려면 이것만으로도 가능합니다.
% xlswrite('qiitaTitles_v2.xlsx',itemList.toExcel); 
```

으로 완성!

<p align = "center">
    <img src ="https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F149511%2F46d82dc6-b8c4-50eb-0d09-f1828543748e.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&w=1400&fit=max&s=945a98e9fe5e29aae4c11c73ddafef76">
    <br>
</p>

# 마치며

엑셀의 수식을 MATLAB에서 정의하고 Excel에 써내보내는 것으로, 하이퍼링크가 붙은 텍스트를 나열한 엑셀 파일을 만드는 자동화를 해보았습니다. 이 방법을 이용하면 몇 천 개, 몇 만 개가 있어도 문제없이 자동화가 가능합니다. 10개 정도있으면 수작업으로 할 수도 있지만요.

# Appendix: 코드 전문

인터넷만 연결되어 있다면 이대로 실행할 수 있을 것입니다.

```matlab
% QiitaAPI 로 포스팅 제목을 얻어옵니다.
% accessToken = 'Bearer xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'; % 더미
% opts = weboptions('HeaderFields',{'Authorization',accessToken});
opts = weboptions; % accessToken을 쓰지 않는 경우

url = "https://qiita.com/api/v2/users/eigs/items";
tmp = webread(url,opts);
tmp = struct2table(tmp); % 구조체에서 table형으로 변경

% 포스팅 날짜, 제목, URL만 확보합니다.
itemList = tmp(:,{'created_at','title','url'});

% 날짜는 datetime 타입으로 바꿔놓겠습니다.
itemList.created_at = datetime(itemList.created_at,...
    'InputFormat', "uuuu-MM-dd'T'HH:mm:ss'+09:00", ...
    'Format', "uuuu-MM-dd");

% 제목, URL, 날짜를 string 형으로 변경
itemList.title = string(itemList.title);
itemList.url = string(itemList.url);
itemList.created_at = string(itemList.created_at);

% 제목의 큰 따옴표에 대한 대응
itemList.title2Excel = replace(itemList.title,"""","""""");

% 수식 작성
itemList.toExcel = "=hyperlink(""" + itemList.url + """,""" ...
 + itemList.title2Excel + """" + ")";

% 포스팅한 날짜와 제목을 출력합니다.
tmp = table2cell(itemList(:,["created_at","toExcel"]));
xlswrite('qiitaTitles.xlsx',tmp);

% 제목만 출력하려면 이것만으로도 가능합니다.
% xlswrite('qiitaTitles_v2.xlsx',itemList.toExcel);
```