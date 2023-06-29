---
title: 【번역】【MATLAB】템플릿을 이용해서 파워포인트 슬라이드를 자동으로 만드는 방법 - Report Generator 편
published: true
permalink: auto_ppt_slide_with_template.html
summary: "MATLAB 코드를 이용해 파워포인트 슬라이드를 작성할 때 템플릿을 이용하면 글이나 사진등의 위치를 미리 조정해둘 수 있어 편리하다. 이 때 Report Geneartor 기능을 이용할 수 있다."
tags: [번역, 자동화, 파워포인트]
identifier: auto_ppt_slide_with_template
sidebar: false
toc: true
---
 
본 포스트의 원문은 아래의 URL에서 확인하실 수 있습니다. 본 포스트는 원작자에게 동의를 구한 뒤 한국어로 번역하였습니다.

- [【MATLAB】テンプレート使って PowerPoint スライド作成自動化：MATLAB Report Generator 編](https://qiita.com/eigs/items/cb48fdcd741126d09def)

# 시작하면서

업무 목적 상 정기적으로 어떤 분석 결과를 파워포인트에 모으고 있습니다. 그런데, MATLAB으로 데이터를 모으고 그래프로 그려서 복사하는 등의 시간이 약 30분 정도 소요되는데요. 이 작업이 만만찮게 귀찮습니다.

"뭐, 매일 하는 것도 아니고 ... "라고 참아 오고 있었지만 2020년은 **"지루한 것은 MATLAB으로 하자"** 라는 결심으로 자동화를 시작해보게 되었습니다. 그때 배운점과 파워포인트 템플릿을 이용한 예시를 소개해드리겠습니다.

# 환경

* MATLAB R2019b
* MALTAB Report Generator

이번에는 MATLAB Report Generator를 이용하지만 [COM 서버를 이용하는 방법](auto_ppt_slide.html)에 익숙하시다면 MATLAB만으로도 가능하다고 생각합니다.

# 파워포인트 템플릿 활용

이전 포스팅 [【번역】【MATLAB】파워포인트 슬라이드를 자동으로 만드는 방법](auto_ppt_slide.html)에서는 기계학습의 평가결과를 모으는 작업을 자동화하였습니다. 다만, 그림의 위치 등을 시행 착오를 통해 코드 내에서 그림의 위치를 결정할 수 있게 되었습니다. 표시 위치를 변경할 필요가 없다면 특별히 곤란할 것도 없다고 생각할 수도 있지만, 유지보수적인 관점에서는 아쉬운 예시가 되었습니다. 죄송합니다. 이번에는 약간 조금 더 확장하여 파워포인트 템플릿을 이용한 예시를 소개해드리겠습니다.

## 샘플 코드

좋은 소재가 생각이 나지 않았습니다만, 실제로 도움이 될지 어떨지는 여러분의 상상에 맡기겠습니다. 그래서, 주사위를 N번 흔든 결과를 정리하는 PPT를 만들어보았습니다.

```matlab
%% 사전 설정
% 파일이름에 오늘의 날짜를 사용합니다.
reportDate = datetime; 
reportDate.Format = 'yyyy-MM-dd';

% 관련 라이브러리를 읽어 들입니다.
import mlreportgen.ppt.*;

% 파일명과 타이틀명
fileName     = "sampleReport" + string(reportDate);
titleText    = "샘플 레포트";
subTitleText = "작성일 " + string(reportDate);

% 사전에 작성한 템플릿으로부터 슬라이드를 만듭니다.
pres = Presentation(fileName,'sampleTemplate.potx');

%% 타이틀 슬라이드를 만듭니다.
% 템플릿에 있는 "Title Slide" 레이아웃을 사용합니다.
titleSlide = add(pres,'Title Slide');

% Placeholder의 내용을 삽입해줍니다.
replace(titleSlide,'Title',titleText);
replace(titleSlide,'Subtitle',subTitleText);

%% 여기부터 리포트 페이지
% 주사위를 N번 흔들어서 나오는 눈의 횟수를 집계합니다.
names = ["one","two","three","four","five","six"];

for ii=1:5 % 10회부터 10만회까지
    N = 10^ii;
    
    % 1부터 6까지 정수를 생성
    diceResults = randi(6,[N,1]);
    % 각 출력의 눈의 횟수를 집계
    counts = histcounts(diceResults);
    [countsSorted,idx] = sort(counts,'descend');
    
    % 히스토그램 작성
    hFigure = figure(1);
    histogram(diceResults,'Normalization','probability');
    title('Histogram of Each Occurenace');
    ha = gca;
    ha.FontSize = 20;
    
    % 그림을 저장하고 난 뒤에 파워포인트로 복사
    imgPath = saveFigureToFile(hFigure);
    pictureObj = Picture(imgPath);
    
    % 슬라이드 타이틀
    slideTitle = "Uniformly Distributed? (N = " + string(N) + ")";
    
    % 사전에 준비해둔 커스텀 레이아웃에서 페이지 작성
    slide = add(pres, 'Custom');
    replace(slide,'Title',slideTitle); % 타이틀
    replace(slide,'Picture Placeholder Big', pictureObj); % 정 가운데 히스토그램을 배치
    
    % 나온 횟수순으로 탑 5: 나온 횟수와 그림을 배치
    topfive = names(idx);
    for jj=1:5
        % 그림은 사전에 준비한 것을 사용
        imagePath = "./images/" + topfive(jj) + ".png";
        if ~exist(imagePath,'file') % 만약을 위해 그림이 없는 경우
            imagePath = "./images/a.png";
        end
        pictureObj = Picture(char(imagePath));
        replace(slide,"Picture Placeholder " + jj, pictureObj);
        replace(slide,"Text Placeholder " + jj, string(countsSorted(ii)));
    end
    
    % hFigure 를 닫는다.
    if( isvalid(hFigure) )
        close(hFigure);
    end
end

%% 이상의 페이지를 바탕으로 파워포인트 작성
% msgbox로 다이어로그를 출력해본다.
hMsg = msgbox('Generating PowerPoint report...');

% pres 를 닫아버린다.
close(pres);
if(ispc) % 준비된 파워포인트를 연다.
    winopen(pres.OutputPath);
end

% 다이어로그를 닫는다.
if( isvalid(hMsg) )
    close(hMsg);
end


function imgPath = saveFigureToFile(hFigure)

% Create images folder if it does not exist
imgFolderPath = fullfile('.','tmp_plots');
if( ~isdir(imgFolderPath) )
    mkdir(imgFolderPath);
end

% Create randomized name for image file
imgName = ['img_',char(datetime('now','Format','yyyyMMddHHmmssSSSSS'))];

% Select an appropriate image type depending on the platform.
if ~ispc
    imgType = '-dpng';
    imgName= [imgName '.png'];
else
    % This Microsoft-specific vector graphics format
    % can yield better quality images in Word documents.
    imgType = '-dmeta';
    imgName = [imgName '.emf'];
end

% Create the path for the file
imgPath = fullfile(imgFolderPath,imgName);

% Save image to file
print(hFigure,imgPath,imgType);

end
```

<p align = "center">
    <img src = "https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F149511%2F035a9318-7155-b4c7-d733-3c790b3cb72c.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&w=1400&fit=max&s=744f5bd5cf3a223f46c83b6b5135a826">
</p>

네, 상상한 대로의 결과네요. 주사위 그림은 미리 만들어줄 필요가 있습니다만, 이런 느낌으로 레포트가 클릭 한번만으로 완성되어 버리네요. 사용할만한 곳이 있으려나요?

참고로 파워포인트 템플릿은 여기서 받을 수 있습니다: [minoue-xx/SlideTemplateExample_Qiita20200120](https://github.com/minoue-xx/SlideTemplateExample_Qiita20200120)

(역주: 위 repo를 통째로 zip 파일로 받아 사용하는 것을 추천합니다. images 폴더도 함께 사용해야 위의 MATLAB 코드가 정상적으로 작동됩니다.)

## 빼먹은 포인트

MATLAB 보다는 파워포인트 쪽의 이야기인데요. 템플릿의 "placeholder 이름"과 "콘텐츠 오브젝트 명"을 표시하는 방법을 모르고 있었습니다. ... orz.

예를 들어,

```matlab
%% 타이틀 슬라이드 작성
% 템플릿에 있는  "Title Slide" 레이아웃을 사용
titleSlide = add(pres,'Title Slide');

% 파일명과 타이틀
fileName     = "sampleReport" + string(reportDate);
titleText    = "샘플 타이틀";
subTitleText = "작성일" + string(reportDate);

% Placeholder의 내용을 삽입해줍니다.
replace(titleSlide,'Title',titleText);
replace(titleSlide,'Subtitle',subTitleText);
```

라고하는 형태로 'Title'나 'Subtitle' 등의 이름을 MATLAB 측에서 참조해가면서 슬라이드를 구성해갑니다만, 그 이름을 어디서 확인할 수 있는지 ...

<p align = "center">
    <img src = "https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F149511%2F2bcd7dbd-159e-b2d3-8329-1783eb446162.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&w=1400&fit=max&s=b87567374f9e861ed227502785361ecf">
</p>

여기 있었습니다. [Home] -> [Select] -> [Selection Pane]을 클릭하면


<p align = "center">
    <img src = "https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F149511%2F0b723d0c-484d-e0e2-cc37-e213ba881985.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&w=1400&fit=max&s=5a50ea17364c3772ef1c1a8e52097ae7">
</p>

이런식이죠. placeholder 이름을 클릭하면 임의의 이름으로 변경가능합니다.

공식 페이지로는 [Access PowerPoint Template Elements](https://kr.mathworks.com/help/rptgen/ug/access-powerpoint-template-elements.html)의 "View and Change Placeholder and Content Object Names"에도 자세한 설명이 있습니다.

# 마치며

주사위를 N번 흔들어서...라고 하는 레포트를 쓰는 사람은 없을 것이라고 생각합니다만, 샘플로서 도움이 된다면 좋겠습니다.

제 경우에는 데이터베이스에서 데이터를 끌어오고 ([Database Toolbox](https://kr.mathworks.com/products/database.html?s_eid=PSM_29435)), 정기적으로 변화하는 랭킹 같은 것을 정리하기 위해 이번에 소개한 템플릿을 사용하고 있습니다.


