---
title: (번역) MATLAB의 뉴럴넷을 웹 브라우저에 구동시키기 - MATLAB> C++ > WebAssembly 자동 변환
published: true
permalink: Deploy_Neural_Network_via_Web_Assembly_from_MATLAB.html
summary: "MATLAB을 통해 얻은 뉴럴네트워크를 이용해 C++ 및 WebAssembly 코드를 생성한 뒤 웹 브라우저에서 구동시켜보았습니다. MATLAB에 내장된 기능들을 웹 배포에 활용하는 아주 좋은 예시가 되겠습니다."
tags: [번역, WebAssembly, JavaScript, MNIST]
identifier: Deploy_Neural_Network_via_Web_Assembly_from_MATLAB
sidebar: false
toc: true
---

본 포스트의 원문은 아래의 URL에서 확인하실 수 있습니다. 본 포스트는 원작자에게 동의를 구한 뒤 한국어로 번역하였습니다.

- [MATLAB のニューラルネットをブラウザで動かす: MATLAB > C++ > WebAssembly の自動変換](https://qiita.com/eigs/items/48e782baf3ae617190cb)

# 0. 소개

MATLAB을 브라우저에서 구현하면 재미있는 것이 있지 않을까 생각하다가 멋진 글을 발견하여 따라해보았습니다.

[TensorFlow.js로 MNIST 학습된 모델을 불러와 브라우저에서 손글씨 숫자 인식하기](https://qiita.com/yukagil/items/ca84c4bfcb47ac53af99)

이 글에서는 TensorFlow.js를 사용하여 웹 브라우저에서 작성한 숫자가 0에서 9 중 어떤 숫자인지 예측합니다. 그리고 이 예측 부분에 MATLAB의 신경망을 사용해보았다는 이야기입니다.

## 수행한 작업

코드는 여기에서 확인할 수 있습니다: [GitHub: minoue-xx/handwritten-digit-prediction-on-browser](https://github.com/minoue-xx/handwritten-digit-prediction-on-browser)
실행 페이지는 여기에서 확인할 수 있습니다: [Github Pages: Hand-written Digit Prediction on Browser](https://minoue-xx.github.io/handwritten-digit-prediction-on-browser/)

정확도는 의심스럽지만, 일단 동작하는 것을 먼저 구현했습니다. 간단한 신경망을 학습하고 GitHub Pages에 구현하는 과정을 설명하는 글입니다.

<img src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/806cceb9-4d90-4518-4b66-6bc90b209b97.png" alt="attach:cat" title="attach:cat" width=700px>

## WebAssembly 변환?

[MATLAB -> C++ -> WebAssembly를 사용한 JavaScript에서의 비선형 최적화](https://qiita.com/eigs/items/68cdcec7b8d56a5b440f)에서는 [fmincon 함수](https://jp.mathworks.com/help/optim/ug/fmincon.html?s_eid=PSM_29435)를 사용하여 최적화를 브라우저에서 구현했습니다. 이와 같은 방법을 사용합니다.

[File Exchange](https://jp.mathworks.com/matlabcentral/fileexchange?s_eid=PSM_29435)에 공개된 [Generate JavaScript Using MATLAB Coder](https://jp.mathworks.com/matlabcentral/fileexchange/69973-generate-javascript-using-matlab-coder?s_eid=PSM_29435)라는 도구를 사용하여 MATLAB Coder를 사용하여 MATLAB에서 WebAssembly로 변환하여 구현합니다.

![image_1.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/4a0fec65-0776-fa19-2bf6-a1dccf2ff4af.png)

기본적으로 Generate JavaScript Using MATLAB Coder에서 제공하는 [예제: Pass Data to a Library](https://viewer.mathworks.com/?viewer=live_code&url=https%3A%2F%2Fjp.mathworks.com%2Fmatlabcentral%2Fmlc-downloads%2Fdownloads%2Fbd0e1def-822e-40bc-8a7f-5842c7197c5e%2Fe7abd4d2-be59-4ad2-858e-3f1046727acf%2Ffiles%2Fexamples%2FcreateLibrary%2FPassingDataArray.mlx&embed=web)의 흐름을 따라 작업합니다.

### 환경

- MATLAB (R2019b Update 5)
- Deep Learning Toolbox
- MATLAB Coder
- Image Processing Toolbox (표시에 사용되는 [montage 함수](https://jp.mathworks.com/help/images/ref/montage.html?s_eid=PSM_29435)만 사용)
- Statistics and Machine Learning Toolbox (데이터 수집에 사용되는 [tabulate 함수](https://jp.mathworks.com/help/stats/tabulate.html?s_eid=PSM_29435)만 사용)
- [File Exchange: Generate JavaScript Using MATLAB Coder](https://jp.mathworks.com/matlabcentral/fileexchange/69973-generate-javascript-using-matlab-coder?s_eid=PSM_29435) v2.0.2 (작성자에게 문의한 결과, 현재 R2020a는 지원하지 않는 것으로 보입니다. 따라서 R2019b에서 작업합니다.)
- [Emscripten Development Kit](https://emscripten.org/index.html) v1.39.1
  
# 1. 도구 설정

기본적으로 [MATLAB -> C++ -> WebAssembly로의 자동 변환을 이용한 비선형 최적화 on JavaScript](https://qiita.com/eigs/items/68cdcec7b8d56a5b440f)와 동일한 단계를 따릅니다.

먼저, [Generate JavaScript Using MATLAB Coder](https://jp.mathworks.com/matlabcentral/fileexchange/69973-generate-javascript-using-matlab-coder?s_eid=PSM_29435)를 MATLAB File Exchange에서 설치합니다. 그런 다음, `Setup.mlx` 파일을 열고 Emscripten Development Kit의 최신 버전을 설치합니다. 네트워크 폴더에서는 작동하지 않을 수 있으므로 로컬에 설치하시기 바랍니다.


# 2. MATLAB 프로젝트 생성

[Generate JavaScript Using MATLAB Coder](https://jp.mathworks.com/matlabcentral/fileexchange/69973-generate-javascript-using-matlab-coder?s_eid=PSM_29435)에서는 [MATLAB 프로젝트](https://jp.mathworks.com/help/matlab/projects.html?s_eid=PSM_29435)를 사용합니다.

작업 폴더([trainingModels/generateWebAssembly](https://github.com/minoue-xx/handwritten-digit-prediction-on-browser/tree/master/trainingModels/generateWebAssembly))로 이동하여 다음을 실행합니다. 출력 형식은 동적 라이브러리 (dll)입니다.

```matlab
proj = webcoder.setup.project("digitprediction","Directory",pwd,"OutputType",'dll');
```

# 3. MATLAB 함수 생성

비선형 최적화를 수행하는 함수 `digitPredictionFcn.m`을 작성합니다. 먼저, 간단한 "얕은" 네트워크로만 하여 돌려보겠습니다.

   -  단계 1: 데이터 로드 
   -  단계 2: 학습 
   -  단계 3: 모델을 MATLAB 함수로 변환 
   -  단계 4: 코드 생성을 위한 마이너 수정

<img src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/6b8df9ea-7616-b8db-bcaa-c88f91fe489d.png" alt="attach:cat" title="attach:cat" width=500px>

학습 방법은 이 문서를 참고했습니다: [MathWorks Blog: Artificial Neural Networks for Beginners](https://blogs.mathworks.com/loren/2015/08/04/artificial-neural-networks-for-beginners?s_eid=PSM_29435)

## 단계 1: 데이터 로드

```matlab
%% 샘플 데이터 로드 (Deep Learning Toolbox에 포함된 데이터입니다)
[XTrain,YTrain,anglesTrain] = digitTrain4DArrayData;
classNames = categories(YTrain);
numClasses = numel(classNames);
numObservations = numel(YTrain);
whos XTrain
```
```
  Name         Size                      Bytes  Class     Attributes

  XTrain      28x28x1x5000            31360000  double              
```

28x28의 단일 채널 이미지가 5000장 들어 있습니다.

```matlab
montage(XTrain(:,:,:,1:16))
```

<img src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/93ec1c7b-0661-c449-8c41-427ba8a68671.png" alt="attach:cat" title="attach:cat" width=500px>

이런 이미지들이 있습니다. 각 레이블(숫자)마다 500장의 이미지가 준비되어 있습니다.

```matlab
tabulate(YTrain)
```
```
  Value    Count   Percent
      0      500     10.00%
      1      500     10.00%
      2      500     10.00%
      3      500     10.00%
      4      500     10.00%
      5      500     10.00%
      6      500     10.00%
      7      500     10.00%
      8      500     10.00%
      9      500     10.00%
```

## 단계 2: 학습

이 부분은 [MathWorks Blog: Artificial Neural Networks for Beginners](https://blogs.mathworks.com/loren/2015/08/04/artificial-neural-networks-for-beginners?s_eid=PSM_29435)에서 제공하는 내용을 그대로 사용할 수 있습니다. 다음은 앱에서 내보낸 MATLAB 코드를 거의 그대로 사용한 예입니다.

```matlab
outputs = dummyvar(YTrain);       % 레이블을 더미 변수로 변환
outputs = outputs';               % 더미 변수 전치
inputs = reshape(XTrain,28*28,5000);

rng(1); % 재현성을 위해 난수 초기화

x = inputs;
t = outputs;
trainFcn = 'trainscg';  % 스케일 조정된 공액 경사 하강법.

% Pattern Recognition Network 생성
hiddenLayerSize = 100;
net = patternnet(hiddenLayerSize, trainFcn);

% 훈련, 검증, 테스트용 데이터 분할 설정
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% 네트워크 훈련
[net,tr] = train(net,x,t);
```

오차 행렬을 작성해보면 꽤 좋은 결과가 나타납니다. 세부 사항은 일단 논의하지 않습니다.
```matlab
plotconfusion(t,net(x))
```

<img src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/a13a2724-2b66-ae96-db81-50d7ec9feac0.png" alt="attach:cat" title="attach:cat" width=500px>

## 단계 3: 모델을 MATLAB 함수로 변환

학습한 네트워크 `net`을 코드 생성을 위해 MATLAB 함수로 변환합니다.

```matlab
genFunction(net, 'digitPredictFcn');
```
```matlab:Output
 
MATLAB function generated: digitPredictFcn.m
To view generated function code: edit digitPredictFcn
For examples of using function: help digitPredictFcn
 
```

이렇게 `digitPredictionFcn.m`과 같은 함수 파일이 생성됩니다. 이 파일에는 네트워크의 가중치와 관련 정보가 모두 포함되어 있습니다.


## 단계 4: 코드 생성을 위한 조정

아쉽게도... 생성된 함수에는 코드 생성을 지원하지 않는 형식이 섞여 있기 때문에 C++로 자동 변환하려면 약간의 수정이 필요합니다. 최종 결과물은 다음 위치에서 확인할 수 있습니다: GitHub: [digitPredictFcn.m](https://raw.githubusercontent.com/minoue-xx/handwritten-digit-prediction-on-browser/master/trainingModels/generateWebAssembly/digitPredictFcn.m).

### 단계 4-1: 함수 정의 및 assertion

원래 함수는 다음과 같이 정의되어 있습니다.

```matlab
function [Y,Xf,Af] = digitPredictFcn(X,~,~) 
```


하지만 다음과 같이 간단하게 하나의 입력과 하나의 출력을 가지는 함수로 수정합니다.

```matlab
function YY = digitPredictFcn(XX)
```


또한, 코드 생성을 위해 입력 인수의 크기를 명시적으로 지정해야 합니다.

```matlab
assert(isa(XX, 'double'));
assert(all( size(XX) == [ 28*28, 1 ]));
```


위 코드를 함수의 맨 앞에 추가합니다.


### 단계 4-2: 인메모리 처리

다음과 같이 코드에서 사용된 `X = {X}`와 같은 부분은 안됩니다.

```matlab
X = {X}
```


대신 다음과 같이 처리합니다.

```matlab
% Format Input Arguments
isCellX = iscell(XX);
if ~isCellX
  X = {XX};
end
```


입력을 변수 `XX`로 바꾼 후 셀 배열 `X`로 변환합니다. 그 이후 코드는 그대로 사용합니다.

### 단계 4-3: cell2mat 함수

예측 결과가 셀 배열 `Y`로 반환되고, 마지막에 double 형으로 변환되는 부분입니다. 그러나 `cell2mat` 함수는 코드 생성 대상이 아닙니다.

```matlab
Y = cell2mat(Y);
```

이 부분은 조금 강제적으로 처리할 수 있습니다. 입력 변수의 크기가 정해져 있으므로 다음과 같이 대체합니다.

```matlab
YY = Y{:};
```

그리고 `YY`를 출력 변수로 사용합니다.

함수가 준비되면 `digitPredictFcn.m` 파일을 프로젝트에 추가하고, 레이블을 UserEntryPoints > Function으로 설정합니다.

<img src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/6de1cfee-a520-bcc0-5553-8003b3e3a864.png" alt="attach:cat" title="attach:cat" width=600px>

이렇게 설정하면 됩니다.

# 4. JavaScript 및 WebAssembly 생성

다음 코드를 사용하여 MATLAB 프로젝트에서 빌드합니다. 내부적으로 MATLAB Coder와 Emscripten SDK가 실행됩니다.

```matlab
proj = openProject(pwd);
webcoder.build.project(proj);
```
```
코드가 성공적으로 생성되었습니다. 보고서를 표시합니다.
```

정상적으로 완료되면 C++ 코드가 build 폴더에 출력됩니다. 또한, 이 C++ 코드가 `digitprediction.js` 및 `digitprediction.wasm`으로 컴파일되어 dist 폴더에 출력됩니다.

# 5. HTML/JavaScript에서 호출

이제 본론에 들어갑니다. MDN에 따르면,

> JavaScript typed arrays는 배열과 유사한 객체이며, 원시 이진 데이터에 액세스하는 메커니즘을 제공합니다.

따라서 이 JavaScript typed arrays를 사용하여 JavaScript에서 optimizeposition.wasm과 데이터를 교환할 수 있습니다.

## 처리 흐름

   1. JavaScript typed array 생성
   2. typed array의 요소 수를 기반으로 필요한 메모리 공간을 계산하고, wasm 측에서 메모리를 할당합니다.
   3. 할당된 공간에 typed array의 값을 복사합니다.
   4. wasm 측의 계산 프로세스를 실행합니다.
   5. wasm 측의 메모리에서 typed array로 값을 복사합니다.
   6. 더 이상 필요하지 않은 공간을 해제합니다.

1에서 3까지의 처리를 담당하는 함수는 `_arrayToHeap`이고, 5는 `_heapToArray`입니다. 처리의 자세한 내용은 [Guthub: Planeshifter/emscripten-examples](https://github.com/Planeshifter/emscripten-examples/tree/master/01_PassingArrays)의 README.md에 기재된 내용을 참고하실 수 있습니다.

JavaScript에서 호출하는 코드
  
```javascript

    function getAccuracyScores(imageData) {

      let inputs = [];
      let length = 28 * 28; // 펙셀 사이즈

      for (let i = 0; i < length * 4; i = i + 4) { // 필요한 픽셀만을 얻어 냅니다.
        inputs.push(imageData.data[i] / 255);
      }
      console.log(inputs); // 確認

      var Inputs = new Float64Array(inputs);
      var Outputs = new Float64Array(10);

      // Move Data to Heap var
      var Inputsbytes = _arrayToHeap(Inputs);
      var Outputsbytes = _arrayToHeap(Outputs);

      // Run Function
      Module._digitprediction_initialize();
      Module._digitPredictFcn(Inputsbytes.byteOffset, Outputsbytes.byteOffset)
      Module._digitprediction_terminate();

      // Copy Data from Heap 
      Outputs = _heapToArray(Outputsbytes, Outputs);
      var outputs = Array.from(Outputs);

      // Free Data from Heap 
      _freeArray(Inputsbytes);
      _freeArray(Outputsbytes);

      // Display Results
      console.log(outputs);
      const score = outputs;
      return score;
    }
```

# 6. 결과 확인하기

로컬 서버를 실행하여 결과를 확인해보겠습니다. Fetch API는 파일 URI Scheme을 지원하지 않기 때문에, 파일에 http URI Scheme을 사용하여 액세스할 수 있도록 설정해야 합니다. Generate JavaScript Using MATLAB Coder에는 이를 위한 함수가 제공되므로 이를 사용하겠습니다.

이전에 `.js`와 `.wasm` 파일이 출력된 dist 폴더에 index.html을 넣어줍니다. MATLAB에서 dist를 현재 폴더로 설정하고 다음과 같이 실행합니다.

```matlab
server = webcoder.utilities.DevelopmentServer("Port",8125);
start(server);
```
```
Development Server serving directory '.' at locations:
    http://10.0.1.14:8125
    http://localhost:8125
```
```matlab
% 서버를 종료할 때는
% stop(server);
```

<img src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/fc86f2eb-b799-4c4a-85ae-610628d02a00.png" alt="attach:cat" title="attach:cat" width=500px>

계산이 정상적으로 수행되는 것으로 보입니다. 일단은 성공한 것 같습니다.


# 7. 정리


우선 MATLAB에서 작성한 네트워크가 JavaScript에서 올바르게 호출되는 것을 확인할 수 있었습니다.


그러나 실제로 [Github Pages: Hand-written Digit Prediction on Browser](https://minoue-xx.github.io/handwritten-digit-prediction-on-browser/)에서 확인해보면 알 수 있듯이 정확도는 그리 좋지 않습니다.

입력 패드에서 입력된 이미지가 학습에 사용된 이미지와 특성이 다른 것인지, 아니면 처음부터 5,000개의 이미지만 사용한 것이 원인인지에 대해서는 다음에 다시 시도해보겠습니다.

