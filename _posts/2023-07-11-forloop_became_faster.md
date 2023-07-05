---
title: (번역) 최근 for 루프가 빨라진 것 같습니다.
published: true
permalink: forloop_became_faster.html
summary: "MATLAB에서 for 루프가 빨라지게 된 기술적 배경을 소개합니다."
tags: [번역, 수치 계산]
identifier: forloop_became_faster
sidebar: false
toc: true
---

본 포스트의 원문은 아래의 URL에서 확인하실 수 있습니다. 본 포스트는 원작자에게 동의를 구한 뒤 한국어로 번역하였습니다.

- [【MATLAB】最近 for ループが速くなってるらしいよ](https://qiita.com/eigs/items/6d10a98faac0e01a0856)

# 시작

**"for 루프를 행렬 연산으로 변경하면 빨라집니다"**

MATLAB을 사용해 본 적이 있는 분들은 한 번쯤 들어보셨을 것입니다. 최근 @t--shin 님이 게시한 글([Matlab이나 Python의 반복문은 느리다고 들었는데 진짜야?](https://qiita.com/t--shin/items/9117139f64243bd8e1ae))에서도 for 루프를 사용하지 않는 것이 처리 속도가 빠르다는 결과가 보고되었습니다.

하지만 R2015b부터는 JIT(Just-in-Time) 컴파일 기능([공식 페이지](https://kr.mathworks.com/products/matlab/matlab-execution-engine.html))이 개선되어 상황이 변하고 있습니다.

그럼 얼마나 차이가 있는 걸까요? @t--shin 님의 글에 따르면, 버전에 따른 차이를 정리해 보았습니다. 연산 내용은 [Matlab이나 Python의 반복문은 느리다고 들었는데 진짜야?](https://qiita.com/t--shin/items/9117139f64243bd8e1ae)를 확인해 주세요.

**2020/10/16 추가**

본 글에서 사용한 예제는 벡터화에 불리한 조건이어서 오해를 불러일으키고 있다는 지적을 받았습니다. 지적하신 대로 "벡터화는 for 문보다 느리다"라는 점이 아니라, 최근 for 루프가 빠르게 실행될 수 있도록 되었다는 점을 전달하는 내용임을 양해해 주십시오. FDTD 식은 conv2나 imfilter로 작성하는 것이 좋아보입니다. [(참고 링크)](https://twitter.com/yatabe_/status/1316911716236742656)

**추가 끝**

# 수행한 작업

코드는 마지막에 첨부 파일로 정리했지만, @t--shin 님의 파동 방정식 차분해법 코드를 약간 수정하여 차분 평가에 for 루프를 사용한 경우와 벡터화한 경우의 처리 시간을 다음 버전에서 조사했습니다. Windows 10 Intel(R) Core(TM) i7-8650U CPU @ 1.90GHz 기기를 사용하였습니다.

   -  R2015a 
   -  R2015b 
   -  R2017b 
   -  R2019b 
   -  R2020b (작성 당시의 최신 버전) 

다음은 한 예입니다.

<p align = "center">
    <img width = "600" src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-07-11-forloop_became_faster/forloop.png">
    <br>
</p>

**아니, 마지막에 있는 for 루프가 더 빠른데 말이야!**

R2015a에서 R2020b까지 34배 빨라졌습니다.

R2015a 이후로 for 루프를 사용한 경우의 처리 시간이 상당히 개선되었으며, 이 경우에는 R2019b에서 역전(!)되었음을 알 수 있습니다.

JIT 컴파일의 성과가 나타나기 쉬운 루프였기 때문일 것으로 생각되지만, 코드를 꼼꼼히 다듬고 가독성을 희생시키지 않고 벡터화 처리해야 하는 필요성은 항상 그렇지 않을 수도 있습니다. **그러나 이는 한 예에 불과하며 모든 경우에 대해 for 루프로 구현하는 것이 더 빠르다는 것은 아니므로 유의해 주십시오.**

숫자로 나타내면 다음과 같습니다 (단위는 초):

| |forLoop(평균)|vector(평균)|forLoop(std)|vector(std)|
|:--:|:--:|:--:|:--:|:--:|
|R2015a|9.21|0.35|0.34|0.015|
|R2015b|1.59|0.38|0.07|0.034|
|R2017b|0.48|0.33|0.016|0.032|
|R2019b|0.27|0.34|0.023|0.039|
|R2020b|0.27|0.33|0.020|0.045|

사용한 코드는 모두 마지막에 첨부 파일로 정리되어 있으며, 비교한 for 루프 버전과 벡터 버전의 차이는 다음과 같습니다.

```matlab
u2(2:xmesh-1,2:ymesh-1) = 2*u1(2:xmesh-1,2:ymesh-1)-u0(2:xmesh-1,2:ymesh-1)+c*c*dt*dt*(diff(u1(:,2:ymesh-1),2,1)/(dx*dx)+diff(u1(2:xmesh-1,:),2,2)/(dy*dy));
```

```matlab
for j = 2:ymesh-1
   for i = 2:xmesh-1
       u2(i,j) = 2*u1(i,j)-u0(i,j) + c*c*dt*dt*((u1(i+1,j)-2*u1(i,j)+u1(i-1,j))/(dx*dx) +(u1(i,j+1)-2*u1(i,j)+u1(i,j-1))/(dy*dy) );
   end
end
```

# 고려해야 할 사항
## 왜 벡터화가 권장되는 걸까요?

실제로 [공식 페이지: 벡터화](https://kr.mathworks.com/help/matlab/matlab_prog/vectorization.html?s_eid=PSM_29435)에서도 벡터화가 권장됩니다.

인터프리터 언어에서는 입력 인수의 유효성 검사 및 함수 호출의 오버헤드를 피할 수 없기 때문에 루프를 사용하여 함수 호출 횟수가 증가하면 처리 시간이 오래 걸립니다. 또한 요소 단위로 처리하는 것보다 행렬 단위로 계산하는 것이 행렬 연산 라이브러리 ([MATLAB의 LAPACK](https://kr.mathworks.com/help/matlab/math/lapack-in-matlab.html?s_eid=PSM_29435), 공식 페이지)의 이점을 활용할 수 있기 때문입니다. (이 점에 대해서는 자세한 설명을 기다리고 있습니다.)

## JIT (Just-in-Time) 컴파일?

MATLAB 코드는 실행 시 Just-In-Time 컴파일이 사용되지만, 특히 R2015b에서 JIT (Just-in-Time) 컴파일 기능 ([공식 페이지](https://kr.mathworks.com/products/matlab/matlab-execution-engine.html))이 개선되었습니다. 결과적으로

   -  함수 호출의 오버헤드 감소
   -  객체 지향 처리 속도 향상
   -  요소 단위 연산의 처리 속도 향상

등의 효과를 기대할 수 있습니다. 그러나 물론 함수나 스크립트의 첫 실행 시에는 두 번째 이후보다 시간이 더 걸린다는 점을 잊어서는 안됩니다.

## 스크립트 vs 함수

특정 작업을 실행할 때는 스크립트의 상태로 비교하는 경우가 많지만, 함수화하면 상황이 달라질 수 있습니다. 이번 경우에서는 함수화하면 for 루프 버전이 더 빨리 실행되는 경향이 있습니다.


# 비교 방법 상세

이번에 구체적으로 검증한 내용은 모두 마지막에 첨부 파일로 정리되어 있으므로 관심 있는 분들은 꼭 시도해보시기 바랍니다. 그래프 그리기 등은 R2020b에서 수행했습니다.

@t--shin 님의 글에서는 N = 400에서 진행했지만, 시간이 오래 걸리므로 비교를 N = 100과 N = 200에서 진행해 보았습니다.
   -  함수 간 비교 (for 루프 vs 벡터 처리)
   -  스크립트 간 비교 (for 루프 vs 벡터 처리)

구체적으로는 20번 처리 시간을 측정하고, 평균값과 표준 편차를 플롯합니다. N = 400에서는 다른 경향이 나타날 수 있습니다.

```matlab
nchecks = 20;
T_forLoop = zeros(nchecks,1);
T_vector = zeros(nchecks,1);
for ii = 1:nchecks
    tic
    tmp1 = wave_forLoop_function(N);
    T_forLoop(ii) = toc;
    tic
    tmp2 = wave_vector_function(N);
    T_vector(ii) = toc;
end

vNumber = version('-release');
save(vNumber+"N"+string(N)+"_function.mat","T_forLoop", "T_vector");
```

이런 식의 함수 (`speedcheck.m`, 첨부 파일 참조)를 작성했습니다.

각 버전을 열어 실행하는 것은 번거롭고, 처리 시간만으로 순수하게 비교할 수 있도록 명령 프롬프트에서 다음 명령을 사용하여 각 버전에서 실행했습니다.

```shell
> "C:\Program Files\MATLAB\R2020b\bin\matlab" -batch "speedcheck(200)"
> "C:\Program Files\MATLAB\R2020b\bin\matlab" -batch "speedcheck(100)"
> "C:\Program Files\MATLAB\R2017b\bin\matlab" -nodesktop -nojvm -nosplash -r "speedcheck(200)"
.
.
```

R2017b 이전은 -batch 옵션이 없으므로 명령이 약간 다르지만, 이를 통해 각 버전마다 결과가 mat 파일에 저장되어 `plotResuts.m` (첨부 파일 참조)에서 플롯한 결과는 다음과 같습니다.
  
## 분할 수 N = 200으로 하여 비교

함수로 실행하면 R2019b즈음에서 역전 현상이 발생하네요.

<p align = "center">
    <img width = "600" src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-07-11-forloop_became_faster/forloop1.png">
    <br>
</p>


## 분할 수 N = 100으로 하여 비교

N = 200의 케이스와 비교해보면 for 루프의 케이스가 유리합니다.

<p align = "center">
    <img width = "600" src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-07-11-forloop_became_faster/forloop2.png">
    <br>
</p>

# 요약

for 루프도 그렇게 나쁘지 않네요.

가독성을 희생하지 않고까지 피해야 할 필요는 없는 것 같습니다. 다만, 반복해서 말하지만, 이는 단지 한 예시일 뿐이며 모든 경우에 for 루프로 구현하는 것이 더 빠르다는 것을 의미하지는 않으니 주의해주십시오.

만약 더 느린 다른 경우가 벡터화된 경우가 있다면 꼭 알려주세요!

# 첨부: 사용한 함수 평가

## speedcheck.m

계산 처리 시간 측정용 함수입니다. for 루프 버전과 벡터화 버전을 각각 함수와 스크립트로 20번씩 측정합니다. 플롯에는 평균값과 표준 편차를 사용합니다. 결과는 각 버전별로 다른 이름의 mat 파일에 저장됩니다.

```matlab
function speedcheck(N)
% 처리 시간 계산용 함수 (N은 그리드 수)

% 20회 측정하여 평균값과 표준편차를 사용합니다.
nchecks = 20;

% 스크립트로 실행
T_forLoop = zeros(nchecks,1);
T_vector = zeros(nchecks,1);
for ii = 1:nchecks
    tic
    wave_forLoop_script;
    T_forLoop(ii) = toc;
    tic
    wave_vector_script;
    T_vector(ii) = toc;
end

% 버전 마다 결과 저장
vNumber = version('-release');
save([vNumber,'N',num2str(N),'_script.mat'],'T_forLoop', 'T_vector');

% 함수로 실행
T_forLoop = zeros(nchecks,1);
T_vector = zeros(nchecks,1);
for ii = 1:nchecks
    tic
    tmp1 = wave_forLoop_function(N);
    T_forLoop(ii) = toc;
    tic
    tmp2 = wave_vector_function(N);
    T_vector(ii) = toc;
end

% 버전 마다 결과 저장
vNumber = version('-release');
save([vNumber,'N',num2str(N),'_function.mat'],'T_forLoop', 'T_vector');
```

## wave_forLoop_script.m


@t--shin 님이 게시한 글 [Matlab이나 Python의 반복문은 느리다고 들었는데 진짜야?](https://qiita.com/t--shin/items/9117139f64243bd8e1ae) 에 게재된 코드 (for 루프 버전)입니다. 분할 수를 자유롭게 설정할 수 있도록 변경했습니다.


```matlab
c = 1.0;
xmin = 0.;
ymin = 0.;
xmax = 1.;
ymax = 1.; % 계산 영역은 [0,1],[0,1]
xmesh = N; 
ymesh = N; % 분할수는 x,y축에 N개씩 
dx = (xmax-xmin)/xmesh;
dy = (ymax-ymin)/ymesh;
dt = 0.2*dx/c;
u0 = zeros(xmesh,ymesh); % u^{n-1}
u1 = zeros(xmesh,ymesh); % u^n
u2 = zeros(xmesh,ymesh); % u^{n+1}
idx1 = round(0.25*N);
idx2 = round(0.75*N);
u1(idx1:idx2,idx1:idx2)=1e-6;% 일정 영역에 초기 속도를 부여
x = xmin+dx/2:dx:xmax-dx/2;
y = ymin+dy/2:dy:ymax-dy/2;
t=0.;
% tic %tic toc으로 시간을 측정할 수 있어서 편리하다
while t<1.0
    for j = 2:ymesh-1
        for i = 2:xmesh-1
            u2(i,j) = 2*u1(i,j)-u0(i,j) + c*c*dt*dt*((u1(i+1,j)-2*u1(i,j)+u1(i-1,j))/(dx*dx) +(u1(i,j+1)-2*u1(i,j)+u1(i,j-1))/(dy*dy) );
        end
    end
    u0=u1;
    u1=u2;
    t = t+dt;
    % 디리클레 조건을 부여
    for i=1:xmesh
        u1(i,1)=0.;
        u1(i,ymesh)=0.;
    end
    for j=1:ymesh
        u1(1,j)=0.;
        u1(xmesh,j)=0.;
    end

end
```

  
## wave_vector_script.m

@t--shin 님이 게시한 글 [Matlab이나 Python의 반복문은 느리다고 들었는데 진짜야?](https://qiita.com/t--shin/items/9117139f64243bd8e1ae) 에 게재된 코드 (for 루프 버전)입니다. 분할 수를 자유롭게 설정할 수 있도록 변경했습니다.

```matlab
c = 1.0;
xmin = 0.;
ymin = 0.;
xmax = 1.;
ymax = 1.; % 계산 영역은 [0,1],[0,1]
xmesh = N; 
ymesh = N; % 분할수는 x,y축에 N개씩 
dx = (xmax-xmin)/xmesh;
dy = (ymax-ymin)/ymesh;
dt = 0.2*dx/c;
u0 = zeros(xmesh,ymesh); % u^{n-1}
u1 = zeros(xmesh,ymesh); % u^n
u2 = zeros(xmesh,ymesh); % u^{n+1}
idx1 = round(0.25*N);
idx2 = round(0.75*N);
u1(idx1:idx2,idx1:idx2)=1e-6;% 일정 영역에 초기 속도를 부여
x = xmin+dx/2:dx:xmax-dx/2;
y = ymin+dy/2:dy:ymax-dy/2;
t=0.;
% tic %tic toc으로 시간을 측정할 수 있어서 편리하다
while t<1.0
    u2(2:xmesh-1,2:ymesh-1) = 2*u1(2:xmesh-1,2:ymesh-1)-u0(2:xmesh-1,2:ymesh-1)+c*c*dt*dt*(diff(u1(:,2:ymesh-1),2,1)/(dx*dx)+diff(u1(2:xmesh-1,:),2,2)/(dy*dy));
    u0=u1;
    u1=u2;
    t = t+dt;
    % 디리클레 조건을 부여
    u1(:,1)=0.;
    u1(:,ymesh)=0.;
    u1(1,:)=0.;
    u1(xmesh,:)=0.;
end
```

## wave_forLoop_function.m

아래는 함수 버전입니다. 가독성을 위해 내부에서 스크립트를 호출하고 있습니다.

```matlab
function u1 = wave_forLoop_function(N)
    wave_forLoop_script;
end
```

## wave_vector_function.m

아래는 함수 버전입니다. 가독성을 위해 내부에서 스크립트를 호출하고 있습니다.

```matlab
function u1 = wave_vector_function(N)
    wave_vector_script;
end
```

## plotResults.m 

결과를 그려주기 위한 스크립트

```matlab
nversion = ["2015a","2015b","2017b","2019b","2020b"];

T_script100 = zeros(5,4);
T_function100 = zeros(5,4);
T_script200 = zeros(5,4);
T_function200 = zeros(5,4);
for ii=1:5
    load(nversion(ii) + "N100_script.mat");
    T_script100(ii,1) = mean(T_forLoop);
    T_script100(ii,2) = mean(T_vector);
    T_script100(ii,3) = std(T_forLoop);
    T_script100(ii,4) = std(T_vector);
    
    load(nversion(ii) + "N100_function.mat");
    T_function100(ii,1) = mean(T_forLoop);
    T_function100(ii,2) = mean(T_vector);
    T_function100(ii,3) = std(T_forLoop);
    T_function100(ii,4) = std(T_vector);
    
    load(nversion(ii) + "N200_script.mat");
    T_script200(ii,1) = mean(T_forLoop);
    T_script200(ii,2) = mean(T_vector);
    T_script200(ii,3) = std(T_forLoop);
    T_script200(ii,4) = std(T_vector);
    
    load(nversion(ii) + "N200_function.mat");
    T_function200(ii,1) = mean(T_forLoop);
    T_function200(ii,2) = mean(T_vector);
    T_function200(ii,3) = std(T_forLoop);
    T_function200(ii,4) = std(T_vector);
end

array2table(T_function200,'VariableNames',["forLoop(mean)","vector(mean)","forLoop(std)","vector(std)"])
%%
hf = figure(1);
hf = plotResults(hf,T_function100,"함수 실행(N=100)");

hf = figure(2);
hf = plotResults(hf,T_function200,"함수 실행(N=200)");

hf = figure(3);
hf = plotResults(hf,T_script100,"스크립트 실행(N=100)");

hf = figure(4);
hf = plotResults(hf,T_script200,"스크립트 실행(N=200)");


function hf = plotResults(hf,data,figureTitle)

nversion = ["R2015a","R2015b","R2017b","R2019b","R2020b"];
errorbar(data(:,1),data(:,3),'LineWidth',2,'CapSize',10)
hold on
errorbar(data(:,2),data(:,4),'LineWidth',2,'CapSize',10)
hold off
legend('forLoop','vector');
title(figureTitle)
set(gca,'XTick',[1,2,3,4,5]);
set(gca,'XTickLabel',nversion)
ylabel('처리시간 (초)');
xlabel('MATLAB 버전');
set(gca,'FontSize',14);
grid on

end
```

