---
title: (번역) plot 창에 보조 확대창을 달아주는 ZoomPlot 함수 소개
published: true
permalink: auxiliary_zoom_plot.html
summary: "시각화 과정에서 간혹 특정 부분만을 확대한 보조창을 함께 도시해줄 필요가 있다. 매트랩에는 이와 같은 내장 기능이 없으나 FileExchange에 올라온 ZoomPlot으로 이 기능을 수행할 수 있습니다. 훌륭한 함수라고 생각해 소개해드리고자 합니다."
tags: [번역, 시각화, 확대창]
identifier: auxiliary_zoom_plot
sidebar: false
toc: true
ogimage: https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-07-14-auxiliary_zoom_plot/ogimage.png
---

본 포스트의 원문은 아래의 URL에서 확인하실 수 있습니다. 본 포스트는 원작자에게 동의를 구한 뒤 한국어로 번역하였습니다.

- [【MATLAB】プロットにサクッと拡大図を追加する ZoomPlot](https://qiita.com/eigs/items/b6edb95a5193abed5c8a)

# 소개

[Kepeng Qiu](https://jp.mathworks.com/matlabcentral/profile/authors/24919958-kepeng-qiu)님이 만든 [ZoomPlot](https://jp.mathworks.com/matlabcentral/fileexchange/93845-zoomplot?s_eid=PSM_29435) 함수를 사용하면 손쉽게 확대 그림을 삽입할 수 있습니다.

![image_0.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/507039c4-2440-84e2-f6d5-eca7f94283d0.png)

사용 방법은 기본 플롯을 그린 후에 다음 2줄을 실행합니다.

```matlab
zp = BaseZoom();
zp.plot;
```

개인적으로 올해 가장 감동받은 File Exchange 함수이므로, 이 함수가 어떻게 구현되었는지 내부 처리를 간단히 소개하겠습니다.
  
## 설치 방법: 애드온 얻기

MATLAB의 File Exchange에서 공개된 [ZoomPlot](https://jp.mathworks.com/matlabcentral/fileexchange/93845-zoomplot?s_eid=PSM_29435)을 직접 다운로드하는 것도 좋지만, 추천하는 방법은 "애드온 얻기"에서 설치하는 것입니다.

![image_1.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/227ccc70-8fa8-6a2e-720e-4b0fb42df1a2.png)

"애드온 얻기"를 클릭하면 "애드온 탐색기"가 열리고, "zoomPlot"을 검색하여 "추가"를 클릭하면 됩니다!

{% include note.html content="경로 설정 등도 자동으로 처리해주므로 편리합니다." %}

![image_2.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/9255f60a-e010-4a77-1d2a-0b3b92e25969.png)

## 요구되는 환경

버전은 R2014b 이상이면 됩니다.

확대 영역을 선택하기 위해 Image Processing Toolbox의 [`drawrectangle`](https://jp.mathworks.com/help/images/ref/drawrectangle.html?s_eid=PSM_29435) 함수(R2018a 이전의 경우 [`imrect`](https://jp.mathworks.com/help/images/ref/imrect.html?s_eid=PSM_29435) 함수)를 사용하므로, [Image Processing Toolbox](https://jp.mathworks.com/products/image.html?s_eid=PSM_29435)가 필요합니다.

  
# 코드 설명

코드를 열면 약 500줄 정도인 BaseZoom 클래스가 작성되어 있는 것을 볼 수 있습니다. 버전에 따라 [`drawrectangle`](https://jp.mathworks.com/help/images/ref/drawrectangle.html?s_eid=PSM_29435) 함수 또는 [`imrect`](https://jp.mathworks.com/help/images/ref/imrect.html?s_eid=PSM_29435) 함수를 사용하기 위해 R2018a 이전의 버전을 지원하기 위한 세부적인 처리가 되어 있습니다.

```matlab:Code
version_ = version('-release')
```

```text:Output
version_ = '2021b'
```

이런식으로 [version](https://jp.mathworks.com/help/matlab/ref/version.html?s_eid=PSM_29435) 함수를 사용하여 환경(버전)을 확인합니다.

## 확대 그림은 어떻게 삽입되나요?

가장 중요한 부분은 다음과 같습니다. 그러나 매우 간단합니다.

   1. 새로운 axes 객체를 생성합니다.
   2. 원래의 axes 객체에서 요소를 복사합니다.
   3. 확대하고 싶은 부분만 표시합니다.
   4. 확대한 부분에 사각형을 표시합니다.

이런 순서로 진행됩니다. 원래의 axes 객체의 Children을 모두 복사하고 있습니다.

{% include note.html content = "객체 조작에 익숙한 분이라면 이해할 수 있을 것입니다. 원하는 요소만 확대하려면 여기에서 Tag 등을 사용하여 검색 조건을 지정하면 됩니다." %}

확대 그림 작성 작업을 모방하면 다음과 같습니다.

```matlab
figure
fplot(@sin); % 예를 들어 이런 플롯

% 원래 axes의 객체 핸들
h_original = gca;
% 새로운 axes 생성 [x,y,width,height]
h_zoom = axes('Position',[0.3,0.6,0.2,0.2]);
% 원래 axes에서 플롯 복사
copyobj(get(h_original, 'children'), h_zoom);
% 확대하고 싶은 부분 지정
xlim(h_zoom,[-2,-1]);
ylim(h_zoom,[-1,-0.8]);
% 확대한 부분에 사각형 표시 [x,y,width,height]
rectangle(h_original,'Position',[-2,-1,1,0.2],...
    'EdgeColor','red',...
    'LineWidth',2);
```

![figure_0.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/d3f3199e-2c03-0004-fda3-5c888c0a1b87.png)

나머지는 새로운 축(확대 그림)과 확대 영역(빨간 테두리)의 꼭짓점을 선으로 연결하면 완료됩니다. 그러나 실제로 구현하려고 하면 조금 까다로울 수 있습니다. 위치에 따라 어떤 두 점을 각각 선택해야 하는지가 문제가 됩니다. 이 부분은 `connectAxesAndBox` 메소드에서 정의되어 있지만, 그 안에서 호출되는 `getLineDirection` 메소드에서는 사각형과의 위치 관계에 따라 주의 깊게(차근차근히) 조건 분기를 수행하고 있습니다.

### 수동으로 지정하는 기능이 필요합니다...

이 예시에서는 확대 영역 및 확대 그림 위치를 수동으로 지정하고 있습니다. 이전 버전(v1.1)에서는 가능했지만, 현재 버전(v1.2.1)의 [ZoomPlot](https://jp.mathworks.com/matlabcentral/fileexchange/93845-zoomplot?s_eid=PSM_29435)에서는 수동으로 지정할 수 없습니다.

이럴 때는 File Exchange 페이지의 "View Version History"를 클릭하여 이전 버전을 사용하는 것도 한 가지 방법입니다. 수동 지정 및 마우스로 지정하는 기능을 모두 사용할 수 있는 것이 가장 좋습니다.

![image_3.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/21fbf56b-f9a3-0807-c161-8a4e9cb643d4.png)

이렇게 사용할 수 있습니다(사용할 수 있었습니다).

```matlab:Code(Display)
parameters = struct('axesPosition', [0.6, 0.1, 0.2, 0.4],...
                    'zoomZone', [1.5, 2.5; 0.6, 1.3],...
                    'lineDirection', [1, 2; 4, 3]);

zp = BaseZoom();
zp.plot(parameters)
```

이제 다음 작업이 가능해졌습니다.

   1. 새로운 axes 객체를 생성합니다.
   2. 원래의 axes 객체에서 요소를 복사합니다.
   3. 확대하고 싶은 부분만 표시합니다.
   4. 확대한 부분에 사각형을 표시합니다.

2와 3이 완료되었습니다.

## 영역 선택은 어떻게?

영역 선택은 [`drawrectangle`](https://jp.mathworks.com/help/images/ref/drawrectangle.html?s_eid=PSM_29435) 함수 또는 [`imrect`](https://jp.mathworks.com/help/images/ref/imrect.html?s_eid=PSM_29435) 함수를 사용할 수 있습니다. 여기서는 R2018b 이후 권장되는 [`drawrectangle`](https://jp.mathworks.com/help/images/ref/drawrectangle.html?s_eid=PSM_29435) 함수를 사용합니다. 이 함수는 Image Processing Toolbox의 기능으로, 보통 이미지의 ROI(Region of Interest)를 선택하는 데 사용됩니다.

```matlab
I = imread('cameraman.tif');
figure
imshow(I);
roi = drawrectangle('Color','r');
```

![figure_1.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/0ff453a5-1983-ef9e-db9a-47f0cc12a080.png)

```text:Output
roi = 
  Rectangle Properties:

         Position: [115 51 59 54]
    RotationAngle: 0
      AspectRatio: 0.9153
            Label: ''
            Color: [1 0 0]
           Parent: [1x1 Axes]
          Visible: on
         Selected: 0

  Show all properties

```

이렇게 `Position`으로 선택한 영역의 정보를 얻을 수 있습니다.

이 정보를 기반으로 다음을 수행합니다.

   1. 새로운 axes 객체를 생성합니다.
   2. 원래의 axes 객체에서 요소를 복사합니다.
   3. 확대하고 싶은 부분만 표시합니다.
   4. 확대한 부분에 사각형을 표시합니다.

1과 4를 수행합니다.

### 영역 선택 중 동작은 어떻게 처리되나요?

이 비디오의 후반부를 보면 영역 선택 중에 확대 그림이 동적으로 변경되는 것을 확인할 수 있습니다.

![image_0.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/94d50b75-8772-c6c1-52d6-1feb06d5011d.png)

이는 ROI 이동 이벤트 리스너를 설정하여 구현됩니다. 이벤트가 감지되면 지정된 콜백 함수가 실행됩니다. `BaseZoom.m` 파일을 보면 다음과 같은 설정이 있습니다.

```matlab:Code(Display)
addlistener(obj.roi, 'MovingROI', @obj.allEventsForRectangleNew);
addlistener(obj.roi, 'ROIMoved', @obj.allEventsForRectangleNew);
```

사용 가능한 이벤트 목록은 [Rectangle 이벤트](https://jp.mathworks.com/help/images/ref/images.roi.rectangle.html#mw_165f149b-e6e2-4e32-b321-a346ab575eb3?s_eid=PSM_29435)에서 확인할 수 있습니다. 다음과 같습니다.

   -  `DeletingROI`: ROI가 상호작용적으로 삭제되려고 함.
   -  `DrawingStarted`: ROI가 상호작용적으로 그려지려고 함.
   -  `DrawingFinished`: ROI가 상호작용적으로 그려짐.
   -  `MovingROI`: ROI의 모양 또는 위치가 상호작용적으로 변경 중.
   -  `ROIMoved`: ROI의 모양 또는 위치가 상호작용적으로 변경됨.
   -  `ROIClicked`: ROI가 클릭됨.

여기서는 `MovingROI`와 `ROIMoved`가 설정되어 있으며, ROI 모양이 변경 중이거나 변경 후에 콜백 함수(`allEventsForRectangleNew`)가 호출되는 것을 확인할 수 있습니다.

다음 [샘플 코드](https://jp.mathworks.com/help/images/ref/images.roi.rectangle.html#mw_ca2d4df8-02c6-4f53-83e1-5c9dcfa7deeb?s_eid=PSM_29435)를 실행해보면 다음과 같습니다.

![image_5.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/d59d25a4-cff7-aa28-0013-eac82532c2bb.png)

ROI의 위치 변경 중 및 변경 후의 위치가 표시되는 것을 확인할 수 있습니다. 리스너 설정은

```matlab:Code
addlistener(roi,'MovingROI',@allevents);
addlistener(roi,'ROIMoved',@allevents);
```

으로, 콜백함수 `allevents`의 정의는 아래와 같습니다.

```matlab:Code(Display)
function allevents(src,evt)
    evname = evt.EventName;
    switch(evname)
        case{'MovingROI'}
            disp(['ROI moving previous position: ' mat2str(evt.PreviousPosition)]);
            disp(['ROI moving current position: ' mat2str(evt.CurrentPosition)]);
        case{'ROIMoved'}
            disp(['ROI moved previous position: ' mat2str(evt.PreviousPosition)]);
            disp(['ROI moved current position: ' mat2str(evt.CurrentPosition)]);
    end
end
```

## 함수화

다른 데이터에서 동일한 위치에 확대 그림을 추가하는 경우는 드물 수도 있습니다. 그러나 있다면 다음과 같을 것입니다.

![image_6.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/d9db5177-0655-b501-1edb-e83e6884aab9.png)

이렇습니다.

다행히도 확대 그림을 포함한 함수가 자동으로 생성되었으므로, 해당 함수를 사용하면 동일한 플롯을 재현할 수 있습니다. 그러나 이 경우 아래 코드에서 표시 범위를 지정하는 부분이 주석 처리되어 있으므로 주의해야합니다. 주석 해제가 필요합니다.

같은 확대 그림을 다양한 데이터에 추가하고 싶을 때 유용할 수 있습니다.

```matlab
% X 축 범위를 유지하기 위해 다음 라인의 주석을 해제합니다.
% xlim(axes1,[0 12.5663706143592]);
% Y 축 범위를 유지하기 위해 다음 라인의 주석을 해제합니다.
% ylim(axes1,[0 300]);
```

# 마지막으로

[ZoomPlot](https://jp.mathworks.com/matlabcentral/fileexchange/93845-zoomplot?s_eid=PSM_29435) 함수는 제가 작성한 함수가 아닙니다. 그러나 구현 방법이 우아하다는 점에 감동하여 간단하게 설명을 해보았습니다.