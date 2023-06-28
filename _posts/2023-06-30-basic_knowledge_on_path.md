---
title: 【번역】【MATLAB】Path 설정에 관한 "기초" 지식
published: true
permalink: basic_knowledge_on_path.html
summary: "MATLAB 코드를 이용해 파워포인트 슬라이드를 작성할 때 템플릿을 이용하면 글이나 사진등의 위치를 미리 조정해둘 수 있어 편리하다. 이 때 Report Geneartor 기능을 이용할 수 있다."
tags: [번역, 경로, 환경설정]
identifier: basic_knowledge_on_path
sidebar: false
toc: true
---

본 포스트의 원문은 아래의 URL에서 확인하실 수 있습니다. 본 포스트는 원작자에게 동의를 구한 뒤 한국어로 번역하였습니다.

- [【MATLAB】パス設定に関する"基礎"知識](https://qiita.com/eigs/items/96697bd372cd45508ff1)

# 시작하면서

이전에 `restoredefaultpath`를 사용하여 경로 설정을 초기화 하는 방법에 관해 소개해 드린적이 있었습니다.

* 참고: [【번역】【MATLAB】무슨 일이 일어나고 있는지 모르지만 치명적인 오류를 해결하는 방법](abnormal_operation_of_MATLAB.html)

이번에는 패스 설정에 더 가까이 다가가보려 합니다. 이는 MATLAB을 켤 때 마다 뒤에서 항상 진행되고 있는 사항입니다.

* pathdef.m
* userpath

위의 두 가지 사항에 관해서 소개해드리겠습니다. 패스 설정의 "기초"라고 할 수 있겠습니다.

팀에서 공용으로 사용하고 있는 PC에 본인 혼자서만 경로 설정을 해서 사용하고 있다고 하면 그럴 때 제 역할을 할 수 있을 것 같습니다.

# 관련 Q&A

* [MATLAB Answers: MATLAB 내에서 사용자 지정 경로를 설정하고 있지만 MATLAB 경로를 재설정해야 하지만 실행하기 전에 이를 백업할 수 있습니까?](https://jp.mathworks.com/matlabcentral/answers/166888-matlab-matlab?s_eid=PSM_29435)
* [MATLAB Answers: MATLAB을 시작하면 "함수 또는 변수 'matlab.internal.editor.EvaluationOutputsService.prewarmExecution'이 인식되지 않습니다." 오류가 발생합니다. 왜 인가요?](https://jp.mathworks.com/matlabcentral/answers/228738-matlab-matlab-internal-editor-evaluationoutputsservice-prewarmexecution?s_eid=PSM_29435)

# 애시당초 경로(path)란?

(제 스스로부터가 그랬습니다만 ...) MATLAB 패스 설정을 만지고 있는 분이 얼마나 계실까요? 경로(path)가 뭐였지? 라는 생각이 드시는 분은 MATLAB 뿐만 아니라 경로 설정 자체에 대한 좋은 포스트들이 있으므로 이쪽을 참고해주시기 바랍니다.

* [Path를 통과하면 환경 변수는 무엇입니까?](https://qiita.com/fuwamaki/items/3d8af42cf7abee760a81) by [@fuwamaki 님](https://qiita.com/fuwamaki)
* ["PATH를 통과"의 의미를 가능한 한 알기 쉽게 설명하는 시도](https://qiita.com/sta/items/63e1048025d1830d12fd) by [@sta 님](https://qiita.com/sta/items/63e1048025d1830d12fd)


# 우선 pathdef.m 부터...

MATLAB에서는 경로 설정을 `pathdef.m`이라는 파일에 저장하고 MATLAB을 켤 때 읽어들입니다. 이 파일의 위치는 우리가 잘 아는 `which` 명령어로 찾아볼 수 있습니다.

```matlab
>> which -all pathdef
C:\Program Files\MATLAB\R2019a\toolbox\local\pathdef.m
```

예를 들어, `addpath` 함수로 폴더를 경로(path)에 추가하고나면, `savepath` 함수를 실행하면 `pathdef.m`가 업데이트 됩니다. 경로 설정을 가지고 놀아볼 생각이시라면 이 파일을 백업해두면 안심할 수 있겠네요.

내용을 확인하기 위해 `>> edit pathdef` 명령을 수행할 수 있습니다. 중요한 경로 설정이 직접 쓰여져 있군요. 자신있는 분들은 손으로 수정해볼 수도 있겠지만 (별로 좋지는 않을 수도) 조심해 주시기 바랍니다.

혹시, 의도치않게 수정해버렸다면 `savepath`로 원래대로 돌아갈 수 있는 가능성도 있지만 역시 안되겠다면

```matlab
restoredefaultpath
savepath
```

로 초기화 할 수 있습니다[^1].

[^1]: 환경변수 `MATLABPATH`로 MATLAB 시작 시 경로를 추가하는 방법도 있습니다. (참고: [MATLABPATH 환경 변수 설정하기](https://kr.mathworks.com/help/matlab/matlab_env/add-folders-to-matlab-search-path-at-startup.html#btpajlw?s_eid=PSM_29435))

# 두 번째인 pathdef.m 은?

그러면 특별히 아무것도 하지 않으면 `pathdef.m`은 파일 하나만으로 충분합니다만, 글의 첫 부분에서 언급한 것 처럼 두 개 이상 준비할 수 있으면 편리한 경우도 있습니다. 예를 들면,

* 여러 사람이 공유하고 있는 PC인데 한 사람이 경로(path)를 가지고 놀아 버리면 다른 사람에게 피해가 됩니다.
* `C:\Program Files\MATLAB\R2019a\toolbox\local`의 편집 권한이 없고, 경로 설정을 변경할 수 없는 경우.

이럴 때 `userpath`에 `pathdef.m`을 저장하면 OK입니다.

## "userpath" 라는 것은 또 뭐지?

`userpath`라는 것은 사용자 개인의 작업 폴더와 같은 것입니다. 특별히 설정한 기억이 없더라도 특정 폴더가 `userpath`로 지정되어 있을 것이므로 관심이 생기신 분은 확인해 보시기 바랍니다.

```matlab
>> userpath
ans =
    'C:\Users\eigs\Documents'
```

이 폴더는 `pathdef.m`이 있다면 `C:\Program Files\MATLAB\R2019a\toolbox\local` 보다 우선 읽어들여지게 됩니다.

`userpath`에 `pathdef.m`을 복사해서 `which` 명령어로 보게되면,

```matlab
>> which -all pathdef
C:\Users\eigs\Documents\pathdef.m
C:\Program Files\MATLAB\R2019a\toolbox\local\pathdef.m  % Shadowed
```

라고 나오게 되며, 원래의 `pathdef.m` 보다 우선 선택되어 있습니다. 이 상태에서 경로를 가지고 놀아 `savepath`하게되면 `userpath`에 있는 `pathdef.m`이 수정되게 됩니다.

`>> userpath(절대경로명)`으로 임의의 폴더를 설정할 수 있으므로 사용자 고유의 경로 설정을 가질 수 있는 것입니다.

## "userpath" 설정정보는 어디에 저장되어 있나?

이미 친숙한 `prefdir` 폴더에 저장되어 있습니다. 

```matlab
>> prefdir
ans =
    'C:\Users\eigs\AppData\Roaming\MathWorks\MATLAB\R2019a'
```

이것도 사용자 고유의 것을 가질 수 있겠네요.

# 여러개의 MATLAB 버전을 설치해두었을 때에는 주의하세요.

여러 MATLAB 버전으로 같은 `userpath`을 사용하게 되면 같은 `pathdef.m`을 공유해버리게 됩니다. 폴더 구성은 모든 버전이 같지는 않기에 문제가 될 수 있습니다. `userpath`도 버전마다 바꿔줄 필요가 있습니다.

- [MATLAB Answers: MATLAB를 실행하면 "함수 또는 변수 'matlab.internal.editor.Evaluation Outputs Service.prewarm Execution'이 인식되지 않습니다." 오류가 발생하는 이유는 무엇입니까?](https://kr.mathworks.com/matlabcentral/answers/228738-matlab-matlab-internal-editor-evaluationoutputsservice-prewarmexecution?s_eid=PSM_29435)

# 마치며

경로 설정의 "기초"를 소개해드렸습니다. 이것으로 이미 MATLAB 경로 설정으로 헤매는 일은 없겠네요. 거기다 `userpath` 폴더는 검색 경로의 첫번째에 추가되게 됩니다.

```matlab
>> path
		MATLABPATH
	C:\Users\eigs\Documents
	C:\Program Files\MATLAB\R2019a\toolbox\matlab\capabilities
	C:\Program Files\MATLAB\R2019a\toolbox\matlab\datafun
(중략)
```

공식 페이지: [MATLAB 검색 경로의 표시와 변경](https://kr.mathworks.com/help/matlab/search-path.html?s_eid=PSM_29435)