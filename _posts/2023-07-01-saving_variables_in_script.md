---
title: 【번역】【MATLAB】변수를 스크립트에 저장하는 방법
published: true
permalink: saving_variables_in_script.html
summary: "변수를 스크립트에 저장하면 mat, xlsx 등에서 파일로 불러오지 않더라도 곧바로 변수를 생성해 사용할 수 있다."
tags: [번역, 변수, QiitaAPI]
identifier: saving_variables_in_script
sidebar: false
toc: true
---

본 포스트의 원문은 아래의 URL에서 확인하실 수 있습니다. 본 포스트는 원작자에게 동의를 구한 뒤 한국어로 번역하였습니다.

- [【MATLAB】変数をスクリプトへ保存](https://qiita.com/eigs/items/f6a73f8f38d043b3b3bc)

# 변수를 스크립트에 저장한다고?

MATLAB에서 계산 결과를 저장할 때에는 보통 MAT 파일이나 엑셀등의 파일로 저장하지만, 변수의 형태에 따라서는 스크립트에 써두는 것도 가능합니다. 포인트는 스크립트 자체에서 변수를 만들도록 하는 것이죠. 매트랩을 사용한지 10년 정도 되었습니다만 얼마전 "처음으로" 도움이 되었습니다. 그 밖에도 도움이 되는 경우가 있을 것이라고 생각해서 소개해드리도록 하겠습니다.

이런 경우에서 사용하고 있다던가 사용해봤다던가 같은 사례가 있다면 댓글로 공유 부탁드리겠습니다.

## 방법 1: GUI

워크스페이스 상에서 저장하고 싶은 변수를 "우클릭" 하고

<p align = "center">
	<img src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-07-01-saving_variables_in_script/savevariable_as_m.png">
	<br>
</p>

"Save As" -> "m-file"을 선택하면 ...

<p align = "center">
	<img src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-07-01-saving_variables_in_script/newscript.png">
	<br>
</p>

이런식입니다. 저장할 수 없는 클래스나 오브젝트가 있는 경우 혹은 배열 사이즈가 너무 큰 경우에는 mat 파일에 저장한 뒤 그것을 읽어들이는 m 파일이 완성됩니다.

## 방법 2: 명령어

물론 명령어로도 가능합니다. 변수 `Var1`을 저장하려면 아래와 같이 수행할 수 있습니다.

```
matlab.io.saveVariableToScript('mydata.m','Var1');
```

자세한 내용은 여기서 확인할 수 있습니다: [작업 공간 변수를 MATLAB 스크립트에 저장](https://kr.mathworks.com/help/matlab/ref/matlab.io.savevariablestoscript.html)

## Workspace 설정 화면

"설정(preference)"에도 관련 항목이 있습니다.

<p align = "center">
	<img src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-07-01-saving_variables_in_script/pref_workspace_variables.png">
	<br>
</p>

## 그래서 뭐가 좋은거지?

파일에서 읽고 싶지 않을 때 쉬운 방법으로 변수를 다시 만들어낼 수 있습니다. 몇 개의 데이터만 있다면 하나 하나 타이핑 하는 것도 좋을 수 있겠지만 데이터 수가 많다면 곤란하겠지요. 예를 들어 ThingSpeak의 MATLAB Analysis에서 사용하려는 변수가 있다던가, MATLAB Answers에 샘플 코드를 올릴 때 라던가, C 코드 생성 시 변수를 m 파일에 직접 써두고 싶다던가 할 때 사용할 수 있습니다.

# 예시

이번에 사용했던 예시(에 가까운 것)을 참고하겠습니다. Qiita(역주: 일본의 개발자 커뮤니티 블로그 서비스)의 MATLAB 태그가 붙은 포스트의 월간 포스팅 개수를 정기적으로 그리는 것을 만들어보고자 했습니다.

<p align = "center">
	<img src = "https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F149511%2Fdceb1dcb-3286-16f4-65bf-b7026a2027e1.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&w=1400&fit=max&s=9142acc07285bbf5310cdd5641efc0a1">
	<br>
</p>

매번 Qiita API를 사용해서 모든 포스트의 포스팅 날짜 데이터를 모으는 것도 가능하지만, 포스팅 수가 많아지면 그다지 현실적이지도 않고, API도 너무 많이 사용하면 좀 미안한 감도 있습니다. ~~MATLAB 태그라면 데이터 양도 아직 알려져있긴 하지만...~~

그래서, ThingSpeak 같은 시스템에서 지금 시점까지의 포스팅 수는 정기적으로 저장하기 위해 지금까지의 월간 포스팅 수 데이터는 스크립트에 기입해 두기로 했습니다.

```matlab
% Historical data: 2011/10/1 - 2019/10/31
counts = [1; 2; 0; 0; 0; 0; 0; 2; 0; 0; 0; 1; 1; 1; 3; 1; 1; 0; 0; 1; 0; 0; ...
     0; 0; 0; 1; 0; 0; 2; 4; 3; 1; 1; 3; 2; 0; 1; 4; 2; 2; 0; 0; 1; 2; ...
     5; 5; 2; 2; 4; 5; 7; 2; 1; 1; 1; 6; 2; 2; 2; 5; 6; 9; 2; 6; 5; 4; ...
     3; 3; 5; 7; 10; 2; 7; 50; 11; 4; 9; 4; 5; 4; 15; 13; 9; 13; 11; 7; ...
     13; 3; 8; 8; 2; 7; 6; 4; 32; 23; 24];
xmonths = datetime(2011,10,1) + calmonths(0:(length(counts)-1))';
bar(xmonths,counts,1)
grid on
```

코드 상단의 `counts` 부분이 스크립트에 저장 기능을 사용해 만들어낸 부분을 복붙한 것입니다. 거기다가 포스팅 총 수는 이런식으로 얻게 됩니다.

```
url = "https://qiita.com/api/v2/tags/matlab";
tmp = webread(url);
```

# 마치며

변수를 스크립트에 저장하는 방법을 소개해드렸습니다.

여러분들이 "이런 곳에서 도움이 되었다!"는 것이 있다면 코멘트 부탁드립니다.

그건 그렇고, R2019b를 사용하고 있습니다.

# Appendix: 월간 포스팅 수를 집계하여 막대 그래프 그리기 코드

모든 포스팅의 포스팅 날짜를 얻고 월간 포스팅 수를 집계해 그려주는 스크립트 전체

```matlab
accessToken = 'Bearer xxxxxxxxxxxxxxxxxxxxxxxxxxx'; % 더미 토큰
opts = weboptions('HeaderFields',{'Authorization',accessToken});
% opts = weboptions; % 토큰을 사용하지 않는 경우

item_list = table;
index = 0;
while true
    index = index + 1;
    % 100건 씩 가져옵니다. 
    url = "https://qiita.com/api/v2/tags/matlab/items?page="+index+"&per_page=100";
    tmp = webread(url,opts);
    
    if isempty(tmp) % 종료 조건
        break
    end
    
    created_at = datetime(vertcat(tmp.created_at),...
        'InputFormat', "uuuu-MM-dd'T'HH:mm:ss'+09:00");
    N = length(created_at);
    tmp = table(created_at, ones(N,1), ...
        'VariableNames',{'created_at','count'});
    item_list = [item_list; tmp]; % item_list 에 추가
end

% 월간 데이터에 집계
titem_list = table2timetable(item_list,'RowTimes','created_at');
monthlyitem = retime(titem_list,'monthly','count');

% 바 그래프로 그리기
x = monthlyitem.created_at;
y = monthlyitem.count;
bar(x,y,1);
grid on
title('MATLAB tag: 월간 포스팅 수');
```