---
title: 【번역】【MATLAB】파워포인트 슬라이드를 자동으로 만드는 방법
published: true
permalink: auto_ppt_slide.html
summary: "MATLAB 코드를 이용해 파워포인트 슬라이드를 작성하는 방법에 대하여"
tags: [번역, 자동화, 파워포인트]
identifier: auto_ppt_slide
sidebar: false
toc: true
---

본 포스트의 원문은 아래의 URL에서 확인하실 수 있습니다. 본 포스트는 원작자에게 동의를 구한 뒤 한국어로 번역하였습니다.

- [【MATLAB】PowerPoint スライド作成自動化](https://qiita.com/eigs/items/8c4bf743fc1319762607)

# 개요

매트랩의 처리 결과를 정리하기 위해 PowerPoint를 사용하는 방법에 대한 포스트입니다. 샘플 코드로써 유용하게 사용되었으면 합니다.

이 포스트에서는 기계학습에서 단골로 사용되는 Iris 데이터셋을 이용해서 여러 알고리즘의 검증결과를 파워포인트로 모으는 샘플 코드를 소개하고자 합니다. 보고서를 만들 때 사용하는 간단한 반복 작업을 자동화하는데 힌트가 되었으면 좋겠습니다. 아래는 자동 생성된 슬라이드의 예시입니다.

<p align = "center">
    <img width = "800" src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-06-28-auto_ppt_slide/pic1.png">
    <br>
</p>

# 환경

* MATLAB R2019a
* Statistics and Machine Learning Toolbox[^1]

[^1]: 이 툴박스는 기계학습 부분에서 사용되고 있으며, 파워포인트 슬라이드 작성은 MATLAB만으로도 오케이입니다.

# 리포트 생성작업은 매우 어렵습니다.

분석 결과를 보여주기 위한 자료를 만들 때 어떻게들 하십니까?

저는 주로

* [LiveScript (.mlx)의 Export](https://kr.mathworks.com/help/matlab/ref/export.html)
* [고전 스크립트 (.m)의 퍼블리시](https://kr.mathworks.com/help/matlab/matlab_prog/publishing-matlab-code.html?s_eid=PSM_29435)

를 사용합니다.

어떤걸 사용하건간에 매트랩 코드, 실행 결과를 그대로 반영해주고 코드와 문서 관리가 편리합니다. 보여주는 상대방에 따라 출력 결과를 숨기거나 하는 등의 설정을 해서 pdf로 출력 후 메일로 첨부하는 것을 가장 많이 사용합니다. ~~이걸 알기 전에는 워드에 하나 하나 복붙해서 사용했습니다.~~

이 외에도 파워포인트에 그림을 정리해야 하는 경우가 존재했지만, 복붙하기에는 어찌되었든 많은 시간을 낭비하게 됩니다. 프로그램을 조금 편집하려고하면 그림을 작게 바꾸고 그 후에 복붙, 복붙... 결국에는 어떤 버전의 코드에서 나온 그림인지 알수 없는 상황으로도 번지기도 하죠. 그런 연유로, 파워포인트 슬라이드를 자동화 하는 방법을 조사해보았습니다.

---

참고로 Python에는 python-pptx라는 라이브러리를 사용해서 자동화할 수 있었고 아래의 포스팅이 MATLAB에서의 방법을 정리해보는 계기가 되었습니다.

참조: [Qiita: Python을 이용해서 레포트 자동화 작성【PowerPoint】【python-pptx】](https://qiita.com/kousakulog/items/34855cd8286bd4f33c08)


# 여러 선택지가 있습니다.

검색해보니 몇 가지 COM 서버를 이용한 구식 방법이 소개되어 있었습니다.

* [MATLAB Answers: M 파일 스크립트로부터 PPT파일의 슬라이드를 복사&붙여넣기](https://kr.mathworks.com/matlabcentral/answers/404115)
* [MATLAB ANswers: PowerPoint로 그림을 붙여넣으려면 어떤 방법이 좋습니까?](https://kr.mathworks.com/matlabcentral/answers/99268)

이 외에도 유저가 작성한 함수를 발견할 수 있었습니다. 내부 코드는 잘 이해하지 못했지만, COM 서버는 사용하지 않는 것으로 보입니다.

* [File Exchange: MatLab tool for exporting data to PowerPoint 2007+ files without using COM-objects automation](https://kr.mathworks.com/matlabcentral/fileexchange/40277-exporttopptx?s_eid=PSM_29435)

소속되신 조직에서 공통 방법으로 본격적으로 하려고 하면 MATLAB Report Generator라는 선택지도 있긴합니다. (툴박스)

* [MATLAB Report Generator: Create a Presentation Generator](https://kr.mathworks.com/help/rptgen/ug/create-a-presentation-generator.html?s_eid=PSM_29435)

# Yet another example

특별히 새로운 방법을 소개하려는 것은 아닙니디만 ~~예가 많은 것보다 더 좋은 것은 없다고 생각해서요~~ 여기서는 구식 방법인 COM 서버를 이용하는 방법으로 각 기계학습 알고리즘의 정도를 파워포인트로 모아보려고 합니다.

## 결과물: ExamplePresentation.pptx

파워포인트 슬라이드가 첨부되지 않으니 캡처 이미지로 양해 부탁드립니다.같은 요령으로 루프를 돌리면 수백 케이스 분이라도 슬라이드로 결과를 정리할 수 있습니다.

<p align = "center">
    <img width = "800" src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-06-28-auto_ppt_slide/pic2.png">
    <br>
</p>

## 코드

```matlab
%% PowerPoint 열기
h = actxserver('PowerPoint.Application');
% PowerPoint의 창을 표시（출력 내용 확인 용）
h.Visible = 1;

%% 프레젠테이션 추가
h.Presentation.invoke;
Presentation = h.Presentation.Add;

%% 커스텀 레이아웃을 읽어 들임.
titleSlide = Presentation.SlideMaster.CustomLayouts.Item(1);
blankSlide = Presentation.SlideMaster.CustomLayouts.Item(2);

%% 타이틀 페이지 추가
Slide1 = Presentation.Slides.AddSlide(1,titleSlide);
Slide1.Shapes.Title.TextFrame.TextRange.Text = 'MATLAB -> PowerPoint 자동화';

%% 2페이지 이하의 이미지 그리기
methods = ["fitcnb","fitcsvm","fitctree","fitcknn"];
methodnames = ["나이브베이즈",...
    "서포트 벡터 머신",...
    "결정 트리",...
    "k-NN"];
for ii=1:4
    newslide = Presentation.Slides.AddSlide(ii+1,blankSlide);
    newslide.Shapes.Title.TextFrame.TextRange.Text = [methodnames(ii) + "-" + methods(ii)];

    [loss, figH1, figH2] = checkClassificationPerformance(methods(ii));

    % 첫번째 Figure를 복붙
    print(figH1,'-dmeta','-r150')

    Image1 = newslide.Shapes.Paste;
    set(Image1, 'Left', 50) % 위치, 크기를 세팅
    set(Image1, 'Top', 120)
    set(Image1, 'Width', 300)
    set(Image1, 'Height',300)

    % 두 번째 Figure를 복붙
    print(figH2,'-dmeta','-r150')

    Image2 = newslide.Shapes.Paste;
    set(Image2, 'Left',450)
    set(Image2, 'Top', 120)
    set(Image2, 'Width', 300)
    set(Image2, 'Height', 300)

    % Text 삽입 (Left, Top, Width, Height는 Text Box의 위치와 사이즈)
    tmp = newslide.Shapes.AddTextbox('msoTextOrientationHorizontal',200,450,400,70);
    tmp.TextFrame.TextRange.Text = '혼동행렬';
    tmp = newslide.Shapes.AddTextbox('msoTextOrientationHorizontal',570,450,400,70);
    tmp.TextFrame.TextRange.Text = '산포도（x는 오답）';
    tmp = newslide.Shapes.AddTextbox('msoTextOrientationHorizontal',600,70,400,70);
    tmp.TextFrame.TextRange.Text = "Loss: " + string(loss);
end

%% 프레젠테이션 저장
Presentation.SaveAs([pwd '\ExamplePresentation.pptx']);

%% PowerPoint 종료
h.Quit;
h.delete;

function [loss, figH1, figH2] = checkClassificationPerformance(method)

% 데이터 읽어들이기
s = load(fullfile(matlabroot, 'toolbox', 'stats', 'statsdemos', 'fisheriris.mat'));
X = s.meas(:,3:4);
Y = categorical(s.species);

switch method
    case 'fitcnb' % 나이브 베이즈
        Mdl = fitcnb(X,Y,...
            'ClassNames',{'setosa','versicolor','virginica'});
    case 'fitcsvm' % 서포트 벡터 머신
        Mdl = fitcecoc(X,Y,...
            'ClassNames',{'setosa','versicolor','virginica'});
    case 'fitctree' % 결정 트리
        Mdl = fitctree(X,Y,...
            'ClassNames',{'setosa','versicolor','virginica'});
    case 'fitcknn' % k-NN
        Mdl = fitcknn(X,Y,...
            'ClassNames',{'setosa','versicolor','virginica'});
    otherwise
        disp('not recognized');
end

% 교차 검증된(분할된) 모델만들기
CVMdl = crossval(Mdl,'KFold',5);
loss = kfoldLoss(CVMdl);
predictedLabels = kfoldPredict(CVMdl);

figH1 = figure(1); % 혼동행렬
cm = confusionchart(Y,categorical(predictedLabels));
cm.FontSize = 15;

figH2 = figure(2); % 산포도 플롯
idx = Y == predictedLabels;
gscatter(X(~idx,1),X(~idx,2),Y(~idx),'rgb','x',8,'on');
hold on
gscatter(X(idx,1),X(idx,2),Y(idx),'rgb','.',18,'on');
hold off
title('Fisher''s Iris Data','FontSize',15);
xlabel('Petal Length (cm)','FontSize',13);
ylabel('Petal Width (cm)','FontSize',13);

grid on
end
```

# 마치며

COM 서버를 이용한 방법으로 기계학습 알고리즘의 정도를 파워포인트로 모으는 예제를 소개해드렸습니다. 파워포인트 템플릿을 사용하면 위치를 수정하는 것도 조금은 쉬울 수 있을 것 같습니다만 그것은 이 다음에 알아보도록 하겠습니다.