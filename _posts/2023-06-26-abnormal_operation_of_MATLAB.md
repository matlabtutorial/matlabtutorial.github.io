---
title: (번역) 무슨 일이 일어나고 있는지 모르지만 치명적인 오류를 해결하는 방법
published: true
permalink: abnormal_operation_of_MATLAB.html
summary: "예상치 못한 매트랩/시뮬링크의 비정상 동작을 해결할 수 있는 간단 코맨드 솔루션!"
tags: [번역, 환경설정, 경로]
identifier: abnormal_operation_of_MATLAB
sidebar: false
toc: true
---

본 포스트의 원문은 아래의 URL에서 확인하실 수 있습니다. 본 포스트는 원작자에게 동의를 구한 뒤 한국어로 번역하였습니다.

- [【MATLAB】何が起こっているか分からないが致命的っぽいエラーの処置方法](https://qiita.com/eigs/items/3def0ad104d2f2efed8a)

# 뭔가 이상하다... 그럴 때에는

* 의미를 모르는 오류가...
* 플롯 표시가 뭔가 이상하거나 표시되지 않는다.
* 근본 원인은 뭐든지 간에 어떻게든 고쳐졌으면 좋겠다. 다시 설치해주겠어!

에러문도 잘 모르겠고, 어떻게 생각해도 자신이 쓴 부분이 원인이 아닐 것 같다... MATLAB을 사용하는 경우 ~~(가끔)~~ 있습니다.

그럴 때, 화를 내고 다시 설치하기 전에 손쉽게 시도해볼 수 있는 두 가지 함수와 그 배경을 소개합니다.

1. 경로 초기화: [restoredefaultpath](https://kr.mathworks.com/help/matlab/ref/restoredefaultpath.html)
2. 설정 파일 초기화: [prefdir](https://kr.mathworks.com/help/matlab/ref/prefdir.html)

```matlab
restoredefaultpath % 패스초기화
savepath %초기화된 패스의 설정을 보존
prefdir % 표시되는 폴더 삭제 (백업은 필요에 따라 수행)
```

이것입니다.

특별히, "설정 파일"은 재설치만으로는 초기화되지 않는 경우가 있기에, 재설치가 시간 낭비로 끝나는 것도 주의해야 합니다.

참고: [MATLAB 환경을 초기화하려면 어떻게 해야 합니까?](https://kr.mathworks.com/matlabcentral/answers/376415)

물론 이 두 가지로 모든 문제가 해결되는 것은 아닙디만, 어쩔 수 없는 때에 시도할 수 있는 것이라는 느낌으로 부디 사용하여 주십시오. 각각에 대해 소개하겠습니다.

# 경로 초기화: restoredefaultpath

```matlab
restoredefaultpath % 경로 초기화
savepath % 초기화된 경로를 저장
```

어떤 것이 원인인지는 잠시 제쳐두고, MATLAB을 설치한 직후에 경로 설정이 문제를 일으키는 경우가 종종 있습니다. 그리고 실수로 경로를 건드려버린 경우도 있죠. 그럴 때는 "에이!" 하고 restoredefaultpath를 사용하여 경로 설정을 초기화하고 문제가 해결되었는지 확인해봅시다. 해결되었다면 savepath를 사용하여 초기화한 경로 설정을 저장합니다.

restoredefaultpath를 실행하는 것만으로는 경로 초기화가 일시적인 것이기 때문에 MATLAB을 다시 시작하면 원래 상태로 돌아갑니다. 그러니 걱정하지 말고 손쉽게 시도해보세요.

## 경로 초기화로 해결되는 문제는?

아래는MATLAB Answers에서 인용한 오류 예시입니다:

* 함수 'workspace​func' (타입 '​struct'의 입력 ​인수)가 정의되지 않았습니다.
  * 예: [MATLAB 시작 시 "함수 'workspace​func' (타입 '​struct'의 입력 ​인수)가 정의되지 않았습니다"라는 오류가 발생하는 이유는 무엇인가요?](https://jp.mathworks.com/matlabcentral/answers/307357-matlab-workspacefunc-struct?s_eid=PSM_29435)
* 경고: matlabrc에서 설정을 초기화할 수 없었습니다.
  * 예: [MATLAB 시작 시 오류에 대해](https://jp.mathworks.com/matlabcentral/answers/477825-matlab?s_eid=PSM_29435)
* readonly Error: Unexpected MATLAB expression. workspacefunc 287
  * 예: [워크스페이스 파일을 열 때 "readonly" 경고가 표시되는데, 원인을 모르겠습니다.](https://jp.mathworks.com/matlabcentral/answers/431932-readonly?s_eid=PSM_29435)
* double에서 struct로 변환할 수 없습니다.
  * 예: [patternnet 함수에서 "double에서 struct로 변환할 수 없습니다."라는 오류가 발생하는 이유는 무엇인가요?](https://jp.mathworks.com/matlabcentral/answers/318257-patternnet-double-struct?s_eid=PSM_29435)
* 'matlab.internal.getSettingsRoot'가 정의되지 않았습니다.
  * 예: [클러스터 프로파일 매니저를 실행할 때 'matlab.in​ternal.get​SettingsRo​ot'가 정의되지 않았다는 오류가 발생하는 이유는 무엇인가요?](https://jp.mathworks.com/matlabcentral/answers/251460-matlab-internal-getsettingsroot?s_eid=PSM_29435)

여러 가지 문제가 있네요.

만약 경로 초기화로 해결된 다른 문제가 있다면 언제든지 댓글로 알려주세요!

# 설정 파일 초기화: prefdir

MATLAB의 재설치로도 해결되지 않는 것인가요?
그런 무서운 현상의 배경에 있는 것이 prefdir입니다.

```
>> prefdir
ans =
    'C:\Users\eigs\AppData\Roaming\MathWorks\MATLAB\R2019a'
```

여기에는 대략 이런 식으로 MATLAB의 버전별로 저장되는 여러 가지 설정 파일이 있습니다.
명령 기록, 단축키, 레이아웃, 언어 설정 등이 저장되어 있습니다.

실수로 설정을 바꿔서 이상해졌는데, 정확히 무엇을 바꿨는지 기억이 안 나네요. 아니, 아무것도 안 했어요 (대체로요...). 그런 상황에는 이 폴더를 그냥 삭제하고 MATLAB을 다시 시작하면 됩니다. 재시작하면 설정 파일이 다시 생성됩니다.

조심성 있는 분은 폴더 이름을 변경(예: R2019a_bk)하여 백업을 해두는 것도 좋습니다. 나중에 R2019a로 되돌리면 원래대로 돌아갑니다.

**만약 제대로 삭제되지 않았다면, 다시 설치한 MATLAB이 이 폴더를 다시 참조하기 때문에 원래 문제가 재현될 수 있습니다.** 무서운 일이네요.

물론, 다른 컴퓨터에서 동일한 설정을 재현하고 싶은 경우에는 이 폴더의 내용을 복사하면 됩니다.

참고: [How do I save my editor preferences when I copy MATLAB to a new machine?](https://kr.mathworks.com/matlabcentral/answers/97176)


## 설정 파일 초기화로 해결되는 문제는?

이쪽도 다방면에 걸쳐있습니다. 순간 생각나는 것들은 아래와 같습니다.

* Live Editor에서 플롯이 표시되지 않음
* App이 시작되지 않음.
* (MATLAB을) 켜는데 시간이 오래 걸리고 자바 에러가 발생함.

등 (발생하는 현상이) 사용자가 조작할 수 있는 설정과는 상관없어 보이는 것이 특징입니다.

# 마치며

"뭔가 이상하네..." 

그럴 때에는 시험해볼만한 가치가 있는 두 가지 명령어를 소개해드렸습니다. 직접적인 원인은 알지 못한 채 흐지부지 넘어가게 되지만, 이유를 알 수 없는 에러에 좌절하기 전에 부디 사용해보시길 바랍니다.

```matlab
restoredefaultpath % 패스초기화
savepath %초기화된 패스의 설정을 보존
prefdir % 표시되는 폴더 삭제 (백업은 필요에 따라 수행)
```