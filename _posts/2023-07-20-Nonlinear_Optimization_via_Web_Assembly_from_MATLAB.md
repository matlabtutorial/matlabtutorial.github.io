---
title: (번역) MATLAB -> C++ -> WebAssembly 자동 변환을 사용한 비선형 최적화 on JavaScript
published: true
permalink: Nonlinear_Optimization_via_Web_Assembly_from_MATLAB.html
summary: "MATLAB에서 제공하는 비선형 최적화 알고리즘을 이용해 C++ 및 WebAssembly 코드를 생성한 뒤 웹 브라우저에서 구동시켜보았습니다. MATLAB에 내장된 기능들을 웹 배포에 활용하는 아주 좋은 예시가 되겠습니다."
tags: [번역, C++, WebAssembly, JavaScript, WASM]
identifier: Nonlinear_Optimization_via_Web_Assembly_from_MATLAB
sidebar: false
toc: true
ogimage: https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2023-07-20-Nonlinear_Optimization_via_Web_Assembly_from_MATLAB/ogimage.png
---

본 포스트의 원문은 아래의 URL에서 확인하실 수 있습니다. 본 포스트는 원작자에게 동의를 구한 뒤 한국어로 번역하였습니다.

- [MATLAB -> C++ -> WebAssembly の自動変換を使った非線形最適化 on JavaScript](https://qiita.com/eigs/items/68cdcec7b8d56a5b440f)
# 0. 소개

MATLAB Central에서 [Generate JavaScript Using MATLAB Coder](https://jp.mathworks.com/matlabcentral/fileexchange/69973-generate-javascript-using-matlab-coder?s_eid=PSM_29435)라는 도구를 발견했습니다. MATLAB Coder를 사용하여 MATLAB에서 C++로 변환한 후에 WebAssembly로까지 변환하는 도구로 보입니다. 이전에는 JavaScript를 다루지 않았지만, 자동으로 변환할 수 있다면 해보기로 결정하여 놀아보았습니다.

여기에서는 변환 부분에 대해서만 소개하겠습니다. UI 부분에 대해서는 다음 글을 참조하십시오.
[UI 편: MATLAB -> C++ -> WebAssembly의 자동 변환을 사용한 비선형 최적화 on JavaScript](https://qiita.com/eigs/items/403baeb4205b185ef638)

![Capture.PNG](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/4633d947-974b-6514-10d8-2d995fdb07e0.png)

WebAssembly에 대해서는 다음 두 가지 글을 참고하였습니다.

- [Qiita: WebAssembly란](https://qiita.com/ShuntaShirai/items/3ac92412720789576f22)
- [Qiita: WebAssembly란?~실제로 C 언어를 브라우저에서 실행하기~[2019년 6월판]](https://qiita.com/umamichi/items/c62d18b7ed81fdba63c2)

WebAssembly는 프로그램을 브라우저에서 빠르게 실행하기 위한 이진 형식으로, JavaScript에서 호출하는 형태로 사용된다고 합니다. 일부 처리의 가속화, 기존 C/C++ 등의 다른 언어로 작성된 애플리케이션을 이식하는 데 유용할 것으로 보입니다.

## 수행한 작업

이전에도 Qiita에 게시한 내용[^3]입니다.

[^3]: [【MATLAB & Python】최적화 계산과 Google Sheets 읽기/쓰기](https://qiita.com/eigs/items/4182fcd9b5da748ef77e)

**"균형이 깨진 보유 비율을 목표 비율에 가깝게 만들기 위해 각 종목을 몇 주 구매해야 하는가"**입니다. 이전 글에서는 이 계산을 MATLAB의 `fmincon`과 Google Sheets + Python을 사용하여 수행했습니다. 하지만 이번에는 브라우저에서 완료하려는 것이 최종 목표이지만, 일단은 MATLAB의 `fmincon` 비선형 최적화 계산을 JavaScript에서 실행하는 부분을 정리하겠습니다. UI는 좀 더 공부해야 할 것 같으므로 나중에 다시 다루도록 하겠습니다.

기본적으로 Generate JavaScript Using MATLAB Coder에서 제공하는 [예제: Pass Data to a Library](https://viewer.mathworks.com/?viewer=live_code&url=https%3A%2F%2Fjp.mathworks.com%2Fmatlabcentral%2Fmlc-downloads%2Fdownloads%2Fbd0e1def-822e-40bc-8a7f-5842c7197c5e%2Fe7abd4d2-be59-4ad2-858e-3f1046727acf%2Ffiles%2Fexamples%2FcreateLibrary%2FPassingDataArray.mlx&embed=web)의 흐름을 따라 작업하고 있습니다.

MATLAB 중급 사용자에게는 메모리 처리 방법이 약간 까다로웠습니다.

코드는 [GitHub: minoue-xx/MATLAB2WASM_sample](https://github.com/minoue-xx/MATLAB2WASM_sample)에서 확인할 수 있으며, 실행 페이지는 (아무것도 눈에는 보이지 않겠지만) [Github Pages: MATLAB2WASM_sample](https://minoue-xx.github.io/MATLAB-to-WebAssembly-sample/)에서 확인할 수 있습니다.


### 환경

- MATLAB (R2019b[^1])
    - Optimization Toolbox
    - MATLAB Coder
- [File Exchange: Generate JavaScript Using MATLAB Coder](https://jp.mathworks.com/matlabcentral/fileexchange/69973-generate-javascript-using-matlab-coder?s_eid=PSM_29435) v2.0.2
- [Emscripten Development Kit](https://emscripten.org/index.html) v1.39.1
- Google Chrome

[^1]: `fmincon`의 C 코드 생성은 R2019b에서 지원되었습니다.


# 1. 도구 설정

File Exchange에서 [Generate JavaScript Using MATLAB Coder](https://jp.mathworks.com/matlabcentral/fileexchange/69973-generate-javascript-using-matlab-coder?s_eid=PSM_29435)를 설치합니다. 먼저 "Setup.mlx" 파일을 열고 Emscripten Development Kit의 최신 버전을 설치하는 지침에 따릅니다. 네트워크 폴더에서 설치하면 문제가 발생할 수 있으므로 로컬에 설치하십시오.

# 2. MATLAB 프로젝트 생성

Generate JavaScript Using MATLAB Coder에서는 [MATLAB 프로젝트](https://jp.mathworks.com/help/matlab/projects.html?s_eid=PSM_29435)[^4]를 사용합니다.

[^4]: MATLAB 프로젝트는 파일 및 설정 관리, 필요한 파일 검색 및 소스 제어를 수행하는 앱입니다. R2019a에서 도입되었습니다.


작업 폴더로 이동한 후 다음을 실행합니다. 출력 형식은 Dynamic Library (dll)입니다.

```matlab

proj = webcoder.setup.project("optimizePosition","Directory",pwd,"OutputType",'dll');
```

# 3. MATLAB 함수 작성

비선형 최적화를 수행하는 `getPosition2Add.m` 함수를 작성합니다. 내용은 [Qiita:【MATLAB & Python】最適化計算と Google Sheets の読み書き](https://qiita.com/eigs/items/4182fcd9b5da748ef77e)에서 소개한 것과 거의 동일하지만, 코드 생성을 위해 입력 인수의 크기와 데이터 유형을 명시합니다. 전체 코드는 여기에서 확인하실 수 있습니다: [GitHub](https://github.com/minoue-xx/MATLAB2WASM_sample)

```matlab

% getPosition2Add.m(일부)

function xlong = getPosition2Add(target_pf, price, position)

% Specify the Dimensions and Data Types
assert(isa(target_pf, 'double'));
assert(isa(price, 'double'));
assert(isa(position, 'double'));
assert(all( size(target_pf) == [ 1, 10 ]))
assert(all( size(price) == [ 1, 10 ]))
assert(all( size(position) == [ 1, 10 ]))

%(이하 생략)
```

여기에서는 최대 10 종목을 지원하는 것으로 가정하고, 입력 배열의 크기를 1x10 벡터로 설정하여 코드를 생성합니다.

MATLAB Coder 자체적으로 "배열 크기는 최대 10까지"라는 설정이 가능하지만, 이상하게도 WebAssembly로 이동하면 메모리 오류가 발생합니다. 원인을 현재 조사 중입니다.

함수가 완성되면 `getPosition2Add.m` 파일을 프로젝트에 추가하고, 라벨을 `UserEntryPoints > Function`으로 설정합니다.

![Capture.PNG](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/20434c34-04dc-41e8-d003-b38c4de83156.png)

이런 느낌입니다.

# 4. JavaScript와 WebAssembly 생성

다음 코드를 사용하여 MATLAB 프로젝트에서 빌드합니다. 내부에서 MATLAB Coder + Emscripten SDK가 실행되고 있는 것 같습니다.

```matlab

proj = openProject(pwd);
webcoder.build.project(proj);
```

C++ 코드가 build 폴더에 출력됩니다. 또한 이 C++ 코드가 `optimizeposition.js` 및 `optimizeposition.wasm`으로 컴파일되어 dist 폴더에 출력됩니다.


# 5. HTML/JavaScript에서 호출

이제 드디어 본론입니다. [MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Typed_arrays)에 따르면,
>JavaScript typed arrays는 배열과 유사한 객체이며, 원시 바이너리 데이터에 접근하는 메커니즘을 제공합니다.

이 JavaScript typed arrays를 사용하여 JavaScript에서 `optimizeposition.wasm`과 데이터를 교환합니다.

**처리 흐름**
1. JavaScript typed array 생성
2. typed array의 요소 수에 기반하여 필요한 메모리 영역을 계산하고 wasm 측 메모리를 할당
3. 할당된 영역에 typed array의 값 복사
4. wasm 측 계산 처리 실행
5. wasm 측 메모리에서 typed array로 값 복사
6. 불필요한 영역 해제

1-3 단계는 `_arrayToHeap` 함수를 통해 처리되고, 5단계는 `_heapToArray` 함수를 통해 처리됩니다. 처리의 자세한 내용은 [Guthub: Planeshifter/emscripten-examples](https://github.com/Planeshifter/emscripten-examples/tree/master/01_PassingArrays)의 README.md를 참고하시면 도움이 될 것입니다.

```javascript
    // script.js
    // JavaScript Array to Emscripten Heap
    function _arrayToHeap(typedArray) {
        var numBytes = typedArray.length * typedArray.BYTES_PER_ELEMENT;
        var ptr = Module._malloc(numBytes);
        var heapBytes = new Uint8Array(Module.HEAPU8.buffer, ptr, numBytes);
        heapBytes.set(new Uint8Array(typedArray.buffer));
        return heapBytes;
    }
    // Emscripten Heap to JavasSript Array
    function _heapToArray(heapBytes, array) {
        return new Float64Array(
            heapBytes.buffer,
            heapBytes.byteOffset,
            heapBytes.length / array.BYTES_PER_ELEMENT);
    }
    // Free Heap
    function _freeArray(heapBytes) {
        Module._free(heapBytes.byteOffset);
    }
    // Example of Passing Data Arrays
    var Module = {
        onRuntimeInitialized: function () {
            var target_pf = [0.275, 0.125, 0.2, 0.1, 0.1, 0.15, 0.05, 0, 0, 0];
            var price = [155.83, 90.4, 42.78, 42.50, 142.56, 112.93, 39.23, 0, 0, 0];
            var position = [12, 20, 40, 15, 6, 18, 12, 0, 0, 0];
            // Create Data    
            var Target_pf = new Float64Array(target_pf);
            var Price = new Float64Array(price);
            var Position = new Float64Array(position);
            var Position2Add = new Float64Array(10);
            // Move Data to Heap
            var Target_pfbytes = _arrayToHeap(Target_pf);
            var Pricebytes = _arrayToHeap(Price);
            var Positionbytes = _arrayToHeap(Position);
            var Position2Addbytes = _arrayToHeap(Position2Add);
            // Run Function
            Module._optimizeposition_initialize();
            Module._getPosition2Add(Target_pfbytes.byteOffset, Pricebytes.byteOffset, Positionbytes.byteOffset, Position2Addbytes.byteOffset)
            Module._optimizeposition_terminate();
            //  Copy Data from Heap
            Position2Add = _heapToArray(Position2Addbytes, Position2Add);
            var position2add = Array.from(Position2Add);
            // Free Data from Heap
            _freeArray(Target_pfbytes);
            _freeArray(Pricebytes);
            _freeArray(Positionbytes);
            _freeArray(Position2Addbytes);
            // Display Results
            console.log(position + " + " + position2add);
        }
    };
```

# 6. 결과 확인

로컬 서버를 실행하여 결과를 확인해보겠습니다. Fetch API는 파일 URI Scheme을 지원하지 않기 때문에, 파일에 http URI Scheme으로 액세스할 수 있도록 설정해야합니다. Generate JavaScript Using MATLAB Coder에는 이를 위한 함수가 제공되므로 해당 함수를 사용하겠습니다.

이전에 `.js` 및 `.wasm` 파일이 출력된 `dist` 폴더에 `index.html` 파일을 배치합니다. MATLAB에서 `dist` 폴더를 현재 폴더로 설정한 다음,

```matlab
server = webcoder.utilities.DevelopmentServer("Port",8125)
start(server);
web('http://localhost:8125')

% 서버를 종료하려면
% stop(server);
```

Chrome에서 열고 [Ctrl] + [Shift] + [i]를 누르면 다음과 같이 나타납니다. [Github Pages: MATLAB2WASM_sample](https://minoue-xx.github.io/MATLAB2WASM_sample/)에서도 확인할 수 있습니다.

![Capture.PNG](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/149511/2337b835-5cd2-eb5b-f4dd-64042d8edf0c.png)

계산이 성공적으로 수행되는 것으로 보입니다.

동일한 계산을 MATLAB에서 시도하여 실행하면,

```matlab
target_pf = [0.275, 0.125, 0.2, 0.1, 0.1, 0.15, 0.05, 0, 0, 0];
price = [155.83, 90.4, 42.78, 42.50, 142.56, 112.93, 39.23, 0, 0, 0];
position = [12, 20, 40, 15, 6, 18, 12, 0, 0, 0];
xlong = getPosition2Add(target_pf, price, position)
```

결과는 다음과 같습니다.

```
xlong =
  Columns 1 through 9
     7     0     9     8     0     0     0     0     0
  Column 10
     0
```

동일한 결과가 나타나는 것을 확인할 수 있습니다. 축하합니다!


# 요약

일단 MATLAB로 작성한 최적화 계산이 JavaScript에서 올바르게 호출되는 것을 확인할 수 있었습니다.

주가 `price`와 보유 수량 `position`의 값도 고정된 배열 크기로 결정되고, 결과도 콘솔에 표시되기만 하기 때문에 현재로서는 사용하기에는 아직 부족합니다. UI 디자인에 대한 개선은 나중에 진행할 예정입니다.

## 참고 자료

- [Qiita: 数独ソルバーで使うことでEmscriptenの仕組みを調べてみた](https://qiita.com/bellbind/items/c37183dd4b7eb9949b9a)
- [【WebAssembly】JS側で作成したtyped arrayをwasm側に渡す](http://blog.shogonir.jp/entry/2017/05/23/232600)
- [Guthub: Planeshifter/emscripten-examples](https://github.com/Planeshifter/emscripten-examples/tree/master/01_PassingArrays)
- [MDN Web docs: JavaScript typed arrays](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Typed_arrays)
- [WebAssembly 開発環境構築の本：WebAssembly 入門](https://wasm-dev-book.netlify.com/hello-wasm.html)

특히 [【WebAssembly】JS側で作成したtyped arrayをwasm側に渡す](http://blog.shogonir.jp/entry/2017/05/23/232600)에서 공개된 많은 예제들은 매우 유용하다고 생각됩니다. 도움이 되었습니다. 감사합니다.

## 첨부 1. getPosition2Add.m

```matlab
function xlong = getPosition2Add(target_pf, price, position)

% Specify the Dimensions and Data Types
assert(isa(target_pf, 'double'));
assert(isa(price, 'double'));
assert(isa(position, 'double'));
assert(all( size(target_pf) == [ 1, 10 ]))
assert(all( size(price) == [ 1, 10 ]))
assert(all( size(position) == [ 1, 10 ]))


idx = target_pf > 0;
target_pf = target_pf(idx);
price = price(idx);
position = position(idx);
N = sum(idx);

% Determine the number of shares to be purchased for each security to approach the target portfolio allocation. The constraint is the cost: how much dollars to spend in total. Here, we set it as $2k (about 200,000 yen).

Cost = 2e3; % $2k

% Linear inequality constraint (total cost should be less than or equal to Cost)
A = price;
b = Cost;
% No linear equality constraint
Aeq = [];
beq = [];
% Upper and lower bounds on the number of shares
lb = zeros(1,N);
ub = inf(1,N);
% Initial values are set to 0.
x0 = zeros(1,N);

options = optimoptions('fmincon','Algorithm','sqp');

% The objective function is defined by getDiff.
% We aim to minimize the square root of the sum of squared differences between the target portfolio allocation and the actual portfolio allocation.
objfun = @(x2add) getDiff(x2add,price,position,target_pf);
x = fmincon(objfun,x0,A,b,Aeq,beq,lb,ub,[],options);

% Use fmincon
% It is originally an integer programming problem, but we calculate the number of shares as real numbers first and ignore the fractional part.
% It is not a big problem if the number of shares to be purchased is large.
% Of course, if the number of shares to be purchased is small, there will be an impact, so adjustments are made.
% Round down the decimal places of the number of shares to be purchased.
xlong = zeros(1,10);
xlong(1:N) = floor(x);

end

function errorRMS = getDiff(position2add,marketvalue,position,target_pf)
newTotal = marketvalue.*(position2add+position);
newPF = newTotal/sum(newTotal);
errorRMS = sqrt(sum( (newPF - target_pf).^2 ) );
end
```

## Appendix 1. index.html

```html
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Position to add</title>
</head>

<body>
    <script async type="text/javascript" src="optimizeposition.js"></script>
    <script>
        // JavaScript Array to Emscripten Heap
        function _arrayToHeap(typedArray) {
            var numBytes = typedArray.length * typedArray.BYTES_PER_ELEMENT;
            var ptr = Module._malloc(numBytes);
            var heapBytes = new Uint8Array(Module.HEAPU8.buffer, ptr, numBytes);
            heapBytes.set(new Uint8Array(typedArray.buffer));
            return heapBytes;
        }
        // Emscripten Heap to JavasSript Array
        function _heapToArray(heapBytes, array) {
            return new Float64Array(
                heapBytes.buffer,
                heapBytes.byteOffset,
                heapBytes.length / array.BYTES_PER_ELEMENT);
        }
        // Free Heap
        function _freeArray(heapBytes) {
            Module._free(heapBytes.byteOffset);
        }
        // Example of Passing Data Arrays
        var Module = {
            onRuntimeInitialized: function () {
                var target_pf = [0.275, 0.125, 0.2, 0.1, 0.1, 0.15, 0.05, 0, 0, 0];
                var price = [155.83, 90.4, 42.78, 42.50, 142.56, 112.93, 39.23, 0, 0, 0];
                var position = [12, 20, 40, 15, 6, 18, 12, 0, 0, 0];
                // Create Data    
                var Target_pf = new Float64Array(target_pf);
                var Price = new Float64Array(price);
                var Position = new Float64Array(position);
                var Position2Add = new Float64Array(10);
                // Move Data to Heap
                var Target_pfbytes = _arrayToHeap(Target_pf);
                var Pricebytes = _arrayToHeap(Price);
                var Positionbytes = _arrayToHeap(Position);
                var Position2Addbytes = _arrayToHeap(Position2Add);
                // Run Function
                Module._optimizeposition_initialize();
                Module._getPosition2Add(Target_pfbytes.byteOffset, Pricebytes.byteOffset, Positionbytes.byteOffset, Position2Addbytes.byteOffset)
                Module._optimizeposition_terminate();
                //  Copy Data from Heap
                Position2Add = _heapToArray(Position2Addbytes, Position2Add);
                var position2add = Array.from(Position2Add);
                // Free Data from Heap
                _freeArray(Target_pfbytes);
                _freeArray(Pricebytes);
                _freeArray(Positionbytes);
                _freeArray(Position2Addbytes);
                // Display Results
                console.log(position + " + " + position2add);
            }
        };
    </script>
</body>

</html>
```
