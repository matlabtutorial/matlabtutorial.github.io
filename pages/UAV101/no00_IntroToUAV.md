---
title: UAV 시뮬레이션의 큰 그림 - 에어프레임 모델부터 제어까지
published: true
sidebar: uav101
permalink: no00_IntroToUAV.html
identifier: no00_IntroToUAV
toc: true
ogimage: https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/uav101/ogimage.png
---

<style>
r { color: Red }
o { color: Orange }
g { color: Green }
</style>

이 포스팅은 Michael Thorburn의 [Quadcopter_Lessons](https://kr.mathworks.com/matlabcentral/fileexchange/115770-quadcopter_lessons?s_tid=prof_contriblnk) 강의를 기반으로 작성되었으며 Google Gemini의 도움으로 작성되었습니다.

# UAV 시뮬레이션의 큰 그림: 에어프레임 모델부터 제어까지

안녕하세요! 복잡하게만 보이던 무인 항공기(UAV), 특히 쿼드콥터의 비행 시뮬레이션을 Simulink로 이해하고 만들어보는 여정에 오신 것을 환영합니다. 이 튜토리얼 시리즈는 고등학교 물리학을 이해하는 분들이라면 누구나 흥미를 가지고 따라올 수 있도록, UAV 모델링의 '큰 그림'을 수학적인 원리와 함께 쉽고 명확하게 설명해 드릴 것입니다.

---

## 1. 왜 UAV 모델링을 배워야 할까요?

오늘날 쿼드콥터는 우리의 일상생활 곳곳에서 활용되고 있습니다. 스포츠 경기 촬영, 영화 제작, 송전선 검사, 심지어 소포 배달에 이르기까지 그 활용도는 무궁무진하죠. 이러한 쿼드콥터의 놀라운 능력과 신뢰성은 정교한 제어 시스템 설계 덕분입니다. 조종사가 네 개의 프로펠러를 독립적으로 제어하여 비행기의 6가지 움직임(3차원 공간 좌표와 3가지 자세 좌표)을 모두 제어할 수 있어야 하죠.

이처럼 복잡하지만 충분히 이해할 수 있는 쿼드콥터는 '모델 기반 설계(Model-based Design)'의 훌륭한 예시입니다. 엔지니어는 비행체의 운동 방정식, 제어 시스템, 환경 요인, 센서 시스템 등을 각각 모델링하고 이를 통합하여 전체 시스템을 설계하고 테스트할 수 있습니다. 시뮬레이션을 통해 실제 비행체를 만들기 전에 안전성, 효율성, 예측 가능성을 검증할 수 있기 때문이죠.

이 시리즈에서는 여러분이 직접 UAV 비행 동역학을 모델링하고, Simulink 모델을 조립하여 UAV가 공중을 움직이고 회전하는 방식을 이해하는 것을 목표로 합니다.

---

## 2. UAV 모델의 큰 그림: 핵심 구성 요소

UAV 모델을 개발하고 테스트하려면 여러 구성 요소가 함께 작동해야 합니다. 전체 시스템은 크게 다음과 같은 부분으로 나눌 수 있습니다:

* **에어프레임(Airframe):** 비행체 자체의 물리적 움직임을 담당하는 핵심 부분입니다.
* **컨트롤러(Controller):** 비행기가 원하는 대로 움직이도록 명령하고 조종하는 알고리즘입니다.
* **환경(Environment):** 중력, 바람, 공기 밀도 등 비행에 영향을 미치는 외부 요인입니다.
* **센서(Sensors):** 비행기의 현재 상태(위치, 속도, 자세 등)를 측정하여 컨트롤러에 피드백을 제공합니다.

이 시리즈에서는 이러한 구성 요소들을 처음부터 모두 다루기보다는, 가장 기본적인 **에어프레임 모델**부터 시작하여 점진적으로 컨트롤러, 환경 요인, 센서 피드백 등을 추가해나가며 모델의 기능을 확장해 나갈 것입니다.

---

## 3. 모듈 1: 에어프레임 모델 – 비행의 기초

1장에서 수행하게 될 활동의 핵심은 **에어프레임 모델**을 구축하는 것입니다. 여기서는 에어프레임 모델에 작용하는 수학적 원리를 간단하게 요약하겠습니다. 에어프레임 모델은 쿼드콥터에 어떤 '힘'과 '토크'가 가해졌을 때, 비행체가 어떻게 움직이고 자세를 바꿀지 예측하는 역할을 합니다.

### 비행의 물리 원리: 상태 방정식의 이해

UAV의 비행을 지배하는 물리 원리는 '상태 방정식(State Equations)'이라고 불리는 수학적인 방정식들로 표현됩니다. Simulink의 [**6자유도 (Euler Angles) 블록**](https://kr.mathworks.com/help/aeroblks/6dofeulerangles.html){:target="_blank"}은 이 복잡한 물리 엔진의 역할을 수행하며, 비행체에 가해지는 힘(Forces)과 토크(Torques)를 입력받아 비행체의 속도, 위치, 자세(오일러 각), 가속도와 같은 다양한 출력값을 계산합니다.

주요 운동 원리는 다음과 같습니다:

1.  **병진 운동 (Translational Motion): 물체의 직선 움직임 및 속도 변화**
    비행기가 앞뒤, 좌우, 상하로 움직이는 속도 변화를 나타내는 원리입니다. 마치 자동차가 엔진의 힘으로 가속하고 브레이크를 밟아 감속하는 것과 같아요. 비행기는 프로펠러의 추력(밀어내는 힘), 날개의 양력(들어 올리는 힘), 공기 저항, 그리고 중력과 같은 다양한 힘을 받아 직선 방향으로 움직이거나 속도를 변화시킵니다.
    이러한 병진 운동은 다음 방정식으로 표현됩니다:

    $$F_b =m\left(\frac{d}{\mathrm{d}t}V_b +\omega \times V_b \right)$$
    
    여기서 $F_b$는 비행기에 가해지는 총 힘, $m$은 비행기의 질량, $V_b$는 비행기의 속도, $\omega$는 비행기의 회전 속도를 나타냅니다. 이 방정식은 "힘은 질량과 가속도의 곱과 같다"는 뉴턴의 제2법칙의 확장된 형태로, 비행기가 회전할 때 발생하는 추가적인 가속도 항까지 고려합니다.

2.  **회전 역학 (Rotational Dynamics): 물체의 회전 자세 변화**
    비행기가 기울거나(롤), 코를 들거나 내리거나(피치), 좌우로 방향을 트는(요) 등 회전하는 움직임을 나타내는 원리입니다. 이는 물체를 회전시키는 힘인 '토크'에 의해 발생합니다. 쿼드콥터는 각각의 프로펠러 속도를 조절하여 정교하게 토크를 발생시킵니다.
    회전 운동은 다음 방정식으로 표현됩니다:

    $$M_b =I\frac{\mathrm{d}}{\mathrm{d}t}\omega +\omega \times \left(I\omega \right)$$

    여기서 $M_b$는 비행기에 가해지는 총 토크(회전시키는 힘), $I$는 비행체의 관성 텐서(물체가 회전 운동에 얼마나 저항하는지를 나타내는 물리량), $\omega$는 비행기의 각속도(회전 속도)를 나타냅니다. 이 방정식은 토크가 관성 모멘트와 각가속도의 곱과 같다는 회전 운동의 기본 원리를 나타냅니다.

3.  **오일러 각 변화율 (Rate of Change of Euler Angles): 비행기의 자세 표현**
    비행기의 '자세'는 롤($\phi$), 피치($\theta$), 요($\psi$)라는 세 가지 '오일러 각'으로 표현됩니다. 이 각도들은 비행기의 X, Y, Z축에 대한 회전 정도를 나타냅니다.
    * $\phi$: 롤(Roll) 각 (X축 기준 회전)
    * $\theta$: 피치(Pitch) 각 (Y축 기준 회전)
    * $\psi$: 요(Yaw) 각 (Z축 기준 회전)
    비행기의 각속도($p, q, r$)가 이 오일러 각들의 변화율에 어떻게 영향을 미치는지는 다음 방정식으로 정의됩니다:

    $$\frac{\mathrm{d}}{\mathrm{d}t}\left\lbrack \begin{array}{c} \phi \newline \theta \newline \psi  \end{array}\right\rbrack =\left\lbrack \begin{array}{ccc} 1 & \left(\sin \phi \;\tan \theta \right) & \left(\cos \phi \;\tan \theta \right)\newline 0 & \cos \phi  & -\sin \phi \newline 0 & \frac{\sin \phi }{\cos \theta } & \frac{\cos \phi }{\cos \theta } \end{array}\right\rbrack \left\lbrack \begin{array}{c} p\newline q\newline r \end{array}\right\rbrack$$

    이 방정식은 비행기의 '회전 속도'가 '자세' 변화에 어떻게 연결되는지를 보여주며, Simulink 6자유도 블록은 이를 통해 실시간으로 비행기의 자세를 추적합니다.

### 모델링 가정

이 에어프레임 모델에는 몇 가지 중요한 가정이 있습니다:
1.  **질량은 일정합니다.** (전기 쿼드콥터에는 합리적이지만, 연료를 소비하는 내연기관 쿼드콥터에는 적합하지 않을 수 있습니다.)
2.  **오일러 각은 피치 각($\theta$)이 $\pm 90^{\circ}$일 때 특이점(Singularity)을 가집니다.** (이 모델에서는 작은 피치 각만 허용하므로 문제가 되지 않습니다.)

### Simulink 6자유도 블록의 역할

위에서 설명한 복잡한 물리 방정식들은 Simulink의 **6자유도 블록** 내부에 구현되어 있습니다. 이 블록은 비행기의 현재 상태를 계산하기 위해 다음 '상태 방정식들'을 풀어냅니다:

* **관성 기준 프레임에서의 위치 변화율:**
    비행기의 속도(바디 프레임 기준)와 자세에 따라 지구 기준 프레임에서 위치가 어떻게 변하는지 계산합니다.

    $$\frac{\mathrm{d}}{\mathrm{d}t}\left\lbrack \begin{array}{c} x\newline y\newline z \end{array}\right\rbrack =R^T \left(\theta ,\phi ,\psi \right)\left\lbrack \begin{array}{c} u\newline v\newline w \end{array}\right\rbrack$$

* **바디 기준 프레임에서의 속도 변화율:**
    비행기가 받는 힘과 현재 회전 속도에 따라 비행기 몸체 기준으로 속도가 어떻게 변하는지 계산합니다.

    $$\frac{d}{\mathrm{d}t}\left\lbrack \begin{array}{c} u\newline v\newline w \end{array}\right\rbrack =-\left\lbrack \begin{array}{c} p\newline q\newline r \end{array}\right\rbrack \times \left\lbrack \begin{array}{c} u\newline v\newline w \end{array}\right\rbrack +\frac{1}{m}\left\lbrack \begin{array}{c} F_x \newline F_y \newline F_z  \end{array}\right\rbrack$$

* **바디 기준 프레임에서의 각속도 변화율:**
    비행기가 받는 토크와 현재 각속도, 그리고 관성 모멘트에 따라 비행기 몸체 기준으로 회전 속도가 어떻게 변하는지 계산합니다.
    
    $$ \frac{d}{\mathrm{d}t}\left\lbrack \begin{array}{c} p\newline q\newline r \end{array}\right\rbrack ={\left\lbrack \begin{array}{ccc} I_{\textrm{xx}}  & {-I}_{\textrm{xy}}  & {-I}_{\textrm{xz}} \newline {-I}_{\textrm{yx}}  & I_{\textrm{yy}}  & {-I}_{\textrm{yz}} \newline {-I}_{\textrm{zx}}  & {-I}_{\textrm{zy}}  & I_{\textrm{zz}}  \end{array}\right\rbrack }^{-1} \left(\left\lbrack \begin{array}{c} M_x \newline M_y \newline M_z  \end{array}\right\rbrack -\left\lbrack \begin{array}{c} p\newline q\newline r \end{array}\right\rbrack \times \left\lbrack \begin{array}{ccc} I_{\textrm{xx}}  & {-I}_{\textrm{xy}}  & {-I}_{\textrm{xz}} \newline {-I}_{\textrm{yx}}  & I_{\textrm{yy}}  & {-I}_{\textrm{yz}} \newline {-I}_{\textrm{zx}}  & {-I}_{\textrm{zy}}  & I_{\textrm{zz}}  \end{array}\right\rbrack \left\lbrack \begin{array}{c} p\newline q\newline r \end{array}\right\rbrack \right) $$

* **오일러 각 변화율:**
    비행기의 각속도에 따라 자세(오일러 각)가 어떻게 변하는지 계산합니다.

    $$\frac{\mathrm{d}}{\mathrm{d}t}\left\lbrack \begin{array}{c} \theta \newline \phi \newline \psi  \end{array}\right\rbrack =\left\lbrack \begin{array}{ccc} 1 & \sin \left(\phi \right)\tan \left(\theta \right) & \cos \left(\phi \right)\tan \left(\theta \right)\newline 0 & \cos \left(\phi \right) & -\sin \left(\phi \right)\newline 0 & \frac{\sin \left(\phi \right)}{\cos \left(\theta \right)} & \frac{\cos \left(\phi \right)}{\cos \left(\theta \right)} \end{array}\right\rbrack \left\lbrack \begin{array}{c} p\newline q\newline r \end{array}\right\rbrack$$

이처럼 6자유도 블록은 비행기의 질량과 관성 모멘트 같은 물리적 특성, 그리고 가해지는 힘과 토크를 입력받아 비행기의 모든 움직임을 계산해줍니다. 우리는 복잡한 미분 방정식을 직접 풀 필요 없이, 이 강력한 블록을 활용하여 비행 시뮬레이션을 구현할 수 있습니다.

### Simulink 모델의 주요 요소

Simulink 모델을 구축하는 데 필요한 몇 가지 핵심 블록들은 다음과 같습니다:

* **Fixed Mass Body Euler Angles Equations of Motion Block:** 6자유도 블록의 정식 명칭으로, 질량이 고정된 물체의 오일러 각 기반 운동 방정식을 구현합니다.
* **Bus Creator / Bus Selector:** 여러 신호들을 하나의 '버스'로 묶거나, 묶인 버스에서 필요한 신호를 선택할 때 사용하며, 모델의 가독성을 높여줍니다.
* **Scope:** 시뮬레이션 결과를 그래프로 시각화하여 보여주는 블록입니다.
* 그 외 기본적인 연산 블록들 (덧셈, 곱셈, 상수 등)이 사용됩니다.

---

## 4. 이 시리즈의 다음 단계는 무엇일까요?

에어프레임 모델을 이해하고 구축하는 것은 UAV 시뮬레이션의 첫걸음입니다. 이 시리즈의 다음 단계에서는 에어프레임에 대한 지식을 확장하고 쿼드콥터가 실제로 어떻게 작동하는지 학습합니다.

* **쿼드콥터 모델 (Quadcopter Model):** 쿼드콥터의 프로펠러와 모터 기능, 그리고 실제 UAV 매개변수를 모델에 통합합니다.
* **쿼드콥터 제어 (Quadcopter Control):** 비행기를 원하는 상태로 제어하는 방법을 배우게 됩니다. 단순한 추력 조절을 넘어, 원하는 위치를 지정하고 실제 위치에 대한 '피드백'을 사용하여 추력 수준을 도출하는 정교한 제어 알고리즘(예: PID 제어)을 구현합니다.
* **PID 튜닝 (PID Tuning):** 제어 알고리즘의 성능을 최적화하기 위한 PID 컨트롤러의 '튜닝' 방법을 배우게 됩니다.

이러한 단계들을 거치면서 여러분은 단순히 비행 모델을 만드는 것을 넘어, 실제 비행체의 움직임을 예측하고 제어하는 데 필요한 모든 핵심 지식을 습득하게 될 것입니다.

---

## 결론

이 튜토리얼 시리즈는 UAV 시뮬레이션의 복잡한 세계를 체계적이고 단계적으로 탐험할 수 있도록 설계되었습니다. 에어프레임 모델이라는 기초부터 시작하여, 그 이면에 있는 물리 원리, Simulink의 강력한 6자유도 블록의 활용법, 그리고 앞으로 배우게 될 제어 시스템의 기초까지 살펴보았습니다.
