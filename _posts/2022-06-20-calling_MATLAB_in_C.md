---
title: C에서 MATLAB 호출하기
published: true
permalink: calling_MATLAB_in_C.html
summary: "C에서 MATLAB Engine을 구동하기 위해 필요한 환경 세팅과 C 코드 실습."
tags: [외부 언어 인터페이스]
identifier: calling_MATLAB_in_C
sidebar: false
toc: true
---

본 내용에 대한 더 자세한 내용은 MathWorks 홈페이지를 참고하시기 바랍니다.

- [Call MATLAB from C](https://www.mathworks.com/help/matlab/calling-matlab-engine-from-c-programs-1.html?s_tid=CRUX_lftnav)

# C의 개발환경과 MATLAB 엔진

MATLAB에서 알고리즘 개발이 용이한 이유는 자료의 시각화 기능이 편리하고, low level 알고리즘을 구현하지 않아도 여러 툴박스에서 구현된 기능들을 가져다 쓸 수 있기 때문이다.

그러나 많은 경우 C/C++ 같은 low level 언어를 이용한 개발을 피할 수 없는 경우가 많다. 가끔씩 데이터를 시각화 하고 싶을 때 'MATLAB을 쓸 수 있다면 참 좋을텐데...' 하는 생각이 들 때가 종종 있다. 가령, cosine 함수를 계산해놓고 '그려서 볼 수 있다면 편하지 않을까?' 하는 것이다. 물론 C/C++ 에서 txt 파일로 변수값을 출력하고 다시 MATLAB에서 이것을 읽어들여 plot 해볼 수도 있지만 C/C++에서 직접 MATLAB의 내장 함수를 불러와 바로 사용할 수 있다면 업무 효율을 더 높일 수 있을 것이다.

이번 포스팅에서는 Windows 환경에서 가장 널리 쓰이는 C/C++ IDE 중 하나인 Visual Studio를 이용해 C/C++ 코드에서 MATLAB 엔진을 구동해 C/C++에서 계산된 변수를 plot 해보고자 한다. 

# Windows Visual Studio의 설정

Visual Studio에서 MATLAB을 열기 위해선 여러가지 설정이 수행되어야 한다.

Visual Studio 설정과 관련된 내용은 StackOverflow Question 중 하나인 [Calling MATLAB Engine error: libeng.dll is missing from your computer](https://stackoverflow.com/questions/37470396/calling-matlab-engine-error-libeng-dll-is-missing-from-your-computer)에서 찾은 것임을 밝힌다.

(1) 우선 MATLAB을 COM Server로 등록해야 한다. 만약 여러개 MATLAB을 가지고 있다면 C/C++에서 부르고자 하는 MATLAB 버전과 동일한 버전의 MATLAB을 등록해야 한다. MATLAB을 관리자 권한으로 열고 아래와 같이 Command Window에 타이핑하자.

>!matlab -regserver

이 때, MATLAB Command Window 창이 하나 뜨게 되는데 이 창은 닫아주자. 더 자세한 사항은 아래의 MathWorks 홈페이지를 참고해보자.

- [Register MATLAB as a COM server](https://www.mathworks.com/help/matlab/matlab_external/registering-matlab-software-as-a-com-server.html)  

(2) Visual Studio에서 Debugger를 실행시킬 때 참고할 경로를 설정해주자. 내 컴퓨터를 우클릭하여 "설정"을 누르면 시스템 설정 창이 뜨게 된다. 여기서 "고급 시스템 설정"에 들어가서 "환경 변수 > 시스템 변수"로 들어가 "Path"를 수정(Edit)해주자. 아래와 같은 경로를 추가하자.

"C:\Program Files\MATLAB\R2021b\bin\win64"

(현재는 R2021b 버전을 기준으로 작성하였지만 사용하는 버전에 맞춰 작성하면 됨)

만약, Visual Studio를 켜둔 상태에서 이 과정이 수행되었다면 반드시 Visual Studio를 재시작하자. 

(3) Visual Studio를 켜고 C/C++을 위한 project를 생성하자. 그리고 project의 Property를 열어보자.

<p align = "center">
  <img src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/master/images/blog_posts/2022-06-20-calling_MATLAB_in_C/pic1.jpg">
  <br>
  그림 1. Project의 Property
</p>

(4) 64-bit MATLAB을 구동한다면 "Configuration Manager"를 열고 active solution platform이 "x64"로 설정되어 있는지 확인하자.

<p align = "center">
  <img src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/master/images/blog_posts/2022-06-20-calling_MATLAB_in_C/pic2.jpg">
  <br>
  그림 2. 64 bit 매트랩을 사용한다면 꼭 64비트 platform에서 C코드가 동작할 수 있도록 확인하자
</p>

(5) VC++ Directiries > Library Directories에 아래와 같은 path를 입력해주자.

C:\Program Files\MATLAB\R2021b\bin\win64

<p align = "center">
  <img src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/master/images/blog_posts/2022-06-20-calling_MATLAB_in_C/pic3.jpg">
  <br>
  그림 3. Library directory path
</p>

(6) C/C++ IDE에서 MATLAB을 호출하기 위해선 "engine.h"를 불러와야 한다. 이 header 파일은 아래의 경로에서 찾을 수 있다.

C:\Program Files\MATLAB\R2021b\extern\include

이 경로를 C/C++ > General > Additional Include Directories에 넣어주자.

<p align = "center">
  <img src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/master/images/blog_posts/2022-06-20-calling_MATLAB_in_C/pic4.jpg">
  <br>
  그림 4. "engine.h" Header 파일의 경로 추가
</p>

(7) MATLAB engine 사용 시에 사용되는 Linker 파일들은 "libeng.lib"와 "libmx.lib" 인데 이 파일들은 아래의 경로에서 찾을 수 있다.

C:\Program Files\MATLAB\R2021b\extern\lib\win64\microsoft

이 경로를 Linker > General > Additional Library Directories에 추가해주자.

<p align = "center">
  <img src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/master/images/blog_posts/2022-06-20-calling_MATLAB_in_C/pic5.jpg">
  <br>
  그림 5. Linker 파일 경로 추가
</p>

(8) 또 앞서 언급한 *.lib 파일들을 아래와 같이 Linker > Input에 추가해주자.

<p align = "center">
  <img src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/master/images/blog_posts/2022-06-20-calling_MATLAB_in_C/pic6.jpg">
  <br>
  그림 6. Linker 파일 경로 추가
</p>


# 예시

아래의 C/C++ 코드를 이용하면 cosine 함수를 C/C++에서 계산하고 MATLAB에서 plot 해줄 수 있다.

<p align = "center">
  <img src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/master/images/blog_posts/2022-06-20-calling_MATLAB_in_C/pic7.jpg">
  <br>
  그림 7. C 코드를 이용해 MATLAB을 호출하여 cosine 함수를 plot하는 예시
</p>

```c
#define _USE_MATH_DEFINES
 
#include <iostream>
#include <math.h>
#include <conio.h>
#include <ctype.h>
#include "engine.h"
 
using namespace std;
 
int main() {
    Engine* ep = engOpen(NULL);
    double x[1000];
 
    int i;
    double t = 0;
    const double dt = 0.001;
 
    mxArray* x_array = mxCreateDoubleMatrix(1000, 1, mxREAL);
    mxDouble* px = mxGetDoubles(x_array);
 
    for (i = 0; i < 1000; i++) {
        x[i] = cos(2 * M_PI * t); // To check numbers in C
        t += dt;
 
        px[i] = x[i];
    }
 
    engPutVariable(ep, "x", x_array);
    engEvalString(ep, "plot(x)");
   
    _getch(); // To make cmd stop until pressing any keys.
 
    engClose(ep);
 
    return 0;
}
 
```