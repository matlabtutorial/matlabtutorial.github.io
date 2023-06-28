---
title: VBA에서 MATLAB 호출하기
published: true
permalink: calling_MATLAB_in_VBA.html
summary: "VBA를 이용해 MATLAB을 호출하는 방법과 실습"
tags: [외부 언어 인터페이스]
identifier: calling_MATLAB_in_VBA
sidebar: false
toc: true
---

# MATLAB을 COM Server에 등록하기

VBA에서 MATLAB과 통신하기 위해 사용하시는 MATLAB 을 COM Server에 등록해야 합니다. MATLAB이 COM 서버에 등록되어 있지 않다면 아래 문서를 참고하시어 주로 사용하시는 MATLAB Release의 실행파일을 COM 서버에 등록하십시오.

- [Register MATLAB as COM Server](https://www.mathworks.com/help/matlab/matlab_external/register-matlab-as-automation-server.html
)

# Shell 명령어 사용하여 MATLAB 열기

VBA에서 MATLAB을 구동하기 위해서 Shell 명령어를 사용할 수 있습니다. 아래는 VBA 코드 입니다.
```shell
Sub OpenMATLAB()
Shell ("matlab -desktop /automation")
End Sub
```

위와 같이 Shell 명령어를 이용해 MATLAB을 열어주면 아래와 같은 명령어를 수행 시 true값이 나와야 합니다.  아래는 MATLAB 명령어입니다.

```matlab
% MATLAB
enableservice('AutomationServer')
```

만약, Shell 명령어의 "/automation" 옵션을 이용하지 않고 MATLAB을 열었을 경우 VBA와 COM 통신하기 위해 아래와 같은 명령어로 AutomationServer 서비스를 활성화시키십시오. 아래는 MATLAB 명령어입니다.

```matlab
% MATLAB
enableservice('AutomationServer', true)
```

# MATLAB에서 명령어 수행하기

AutomationServer 서비스가 활성화된 MATLAB 인스턴스가 열린 상태에서 아래의 VBA 스크립트를 수행하면 MATLAB 명령을 수행할 수 있습니다. 아래는 VBA 코드입니다.
 
```shell
Sub MatlabInvoke()
     Dim MatLab As Object
     Dim Result As String
     Set MatLab = GetObject(, "MATLAB.Desktop.Application")
     Result = MatLab.Execute("logo")
End Sub
```