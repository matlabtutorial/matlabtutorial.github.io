---
title: Simulink로 에어프레임 모델 구축하기
published: true
sidebar: uav101
permalink: no01_Airframe.html
identifier: no01_Airframe
toc: true
ogimage: https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/path_planning/ogimage.jpg
---

<style>
r { color: Red }
o { color: Orange }
g { color: Green }
</style>

# Simulink로 에어프레임 모델 구축하기 (쿼드콥터 UAV를 위한 동역학 모델링)

안녕하세요! 이번 포스팅에서는 Simulink를 활용하여 비행체의 핵심이라고 할 수 있는 **에어프레임 모델**을 구축하는 방법에 대해 자세히 알아보겠습니다. 특히, 쿼드콥터 무인 항공기(UAV)를 위한 모델링에 초점을 맞추며, 에어프레임의 움직임을 지배하는 물리 방정식까지 함께 살펴보겠습니다.

해당 포스팅은 아래 영상의 설명을 기반으로 하였으며, Google Gemini의 도움을 받아 작성되었습니다.

<p align = "center"><iframe width="560" height="315" src="https://www.youtube.com/embed/uQXS3aeMUhY?si=vFu2nWpl3tRePQdE" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe></p>

---

## 1. 학습 목표 (Learning Goals)

이 모듈을 완료하면 다음과 같은 내용을 이해할 수 있습니다:

* 쿼드콥터의 움직임 유형을 설명할 수 있습니다.
* 에어프레임에 사용되는 물리적 운동 방정식을 설명할 수 있습니다.
* 간단한 질량 블록이 방정식을 어떻게 구현하는지 설명할 수 있습니다.
* Simulink에서 에어프레임 모델을 구현할 수 있습니다.
* Simulink를 사용하여 모델 시스템의 해를 구할 수 있습니다.
* 다양한 강제력(forcings) 하에서 에어프레임 모델의 동작을 설명할 수 있습니다.
* 원하는 동작을 생성하는 강제 함수를 설계할 수 있습니다.

---

## 2. 에어프레임 모델이란?

에어프레임 모델은 비행체의 **시스템 모델**을 구성하는 핵심 요소입니다. 쿼드콥터 UAV를 예로 들면, 이 모델은 외부 **환경 요인**과 UAV의 **물리적 매개변수**를 입력으로 받아, 비행체의 **상태 방정식**을 계산하고 실제와 같은 움직임을 시뮬레이션합니다.

간단히 말해, 에어프레임 모델은 비행체에 어떤 힘과 토크가 가해졌을 때, 비행체가 어떻게 움직이고 자세를 바꿀지를 예측하는 역할을 합니다. 에어프레임은 또한 관성 기준 프레임과 바디 기준 프레임 간의 변환을 계산합니다. 앞으로 프로펠러 및 모터 기능, UAV 매개변수, 명령 및 제어 알고리즘, 센서 피드백 등에 대해서도 다룰 예정입니다.

---

## 3. 에어프레임 모델 구축 시작하기: 6자유도 (Euler Angles) 블록의 활용

Simulink에서 에어프레임 모델을 구축하려면 먼저 Simulink 창을 열고 라이브러리 브라우저에서 필요한 블록을 가져와야 합니다. 이 비디오에서는 특히 **6자유도 (Euler Angles) 블록**을 활용하여 모델을 구축합니다.

### 6자유도 (Euler Angles) 블록과 에어프레임 모델의 연관성

**6자유도 (6 Degrees of Freedom) 블록**은 비행 물체의 움직임을 시뮬레이션하는 데 있어 핵심적인 '물리 엔진' 역할을 합니다. 6자유도는 3개의 선형 이동(앞뒤, 좌우, 상하)과 3개의 회전 이동(롤, 피치, 요)을 포함하여 물체가 공간에서 가질 수 있는 모든 움직임을 의미합니다. 여기서 (Euler Angles)는 이러한 회전 움직임을 '오일러 각'이라는 방식으로 표현한다는 뜻입니다.

이 블록은 에어프레임에 **가해지는 힘(Forces)과 토크(Torques)를 입력**으로 받습니다. 그리고 이 입력값을 기반으로 비행체의 **속도, 위치, 오일러 각(자세), 그리고 가속도**와 같은 다양한 출력값을 계산하여 제공합니다.

### 에어프레임 운동 방정식 살펴보기

에어프레임의 움직임을 지배하는 물리 방정식은 다음과 같습니다 (참고: Aerospace Blockset / Equations of Motion / 6DOF).

1.  **병진 운동 (Translational Motion): 물체의 위치와 속도 변화**
    비행기가 이동하는 속도 변화를 나타내는 방정식입니다.

    $$ F_b =m\left(\frac{d}{\mathrm{d}t}V_b +\omega \times V_b \right) $$

    * $F_b$: 바디 프레임에 적용되는 힘 (뉴턴)
    * $m$: 물체의 질량 (kg)
    * $V_b$: 바디 프레임에서의 속도 벡터
    * $\omega$: 바디 프레임에서의 각속도 벡터
    * $\frac{d}{\mathrm{d}t}V_b$: 바디 프레임에서의 속도 변화율 (가속도)
    * $\omega \times V_b$: 코리올리 가속도 항 (회전하는 좌표계에서 발생하는 겉보기 힘)

    이 방정식은 "비행기에 가해지는 힘은 비행기의 질량과 가속도의 곱과 같다"는 뉴턴의 제2법칙($F=ma$)의 확장 버전으로 이해할 수 있습니다. 특히, 비행기가 회전할 때 발생하는 추가적인 가속도 항($\omega \times V_b$)이 포함됩니다.

2.  **회전 역학 (Rotational Dynamics): 물체의 회전 자세 변화**
    비행기가 기울거나 방향을 트는 등 회전하는 움직임을 나타내는 방정식입니다.

    $$ M_b =I\frac{\mathrm{d}}{\mathrm{d}t}\omega +\omega \times \left(I\omega \right) $$

    * $M_b$: 바디 프레임에 적용되는 모멘트(토크) (뉴턴 미터)
    * $I$: 관성 텐서 (물체가 회전 운동에 얼마나 저항하는지를 나타내는 물리량)
    * $\frac{\mathrm{d}}{\mathrm{d}t}\omega$: 각속도 변화율 (각가속도)
    * $\omega \times (I\omega)$: 회전하는 물체의 복잡한 회전 운동을 설명하는 항

    이 방정식은 뉴턴의 회전 운동 법칙을 나타냅니다. 물체에 가해지는 토크는 물체의 관성 모멘트와 각가속도의 곱과 같다는 원리($\tau = I\alpha$)의 회전하는 좌표계 버전입니다.

3.  **오일러 각 변화율 (Rate of Change of Euler Angles): 비행기의 자세 표현**
    비행기의 각속도($p, q, r$)가 오일러 각($\phi, \theta, \psi$)의 변화율에 어떻게 영향을 미치는지를 정의합니다.

    $$ \frac{\mathrm{d}}{\mathrm{d}t}\left\lbrack \begin{array}{c} \phi \newline \theta \newline \psi  \end{array}\right\rbrack =\left\lbrack \begin{array}{ccc} 1 & \left(\sin \phi \;\tan \theta \right) & \left(\cos \phi \;\tan \theta \right)\newline 0 & \cos \phi  & -\sin \phi \newline 0 & \frac{\sin \phi }{\cos \theta } & \frac{\cos \phi }{\cos \theta } \end{array}\right\rbrack \left\lbrack \begin{array}{c} p\newline q\newline r \end{array}\right\rbrack $$

    * $\phi$: 롤(Roll) 각 (X축 기준 회전)
    * $\theta$: 피치(Pitch) 각 (Y축 기준 회전)
    * $\psi$: 요(Yaw) 각 (Z축 기준 회전)
    * $p, q, r$: 각각 X, Y, Z축에 대한 바디 프레임 각속도 성분

    이 방정식은 비행기의 '각속도'가 '자세(오일러 각)' 변화에 어떻게 연결되는지를 보여줍니다. 예를 들어, X축(p)으로 회전하면 롤 각($\phi$)이 변하고, Y축(q)으로 회전하면 피치 각($\theta$)이 변하며, Z축(r)으로 회전하면 요 각($\psi$)이 변합니다.

### 모델링 가정 (Modeling Assumptions)

이 에어프레임 모델에는 몇 가지 중요한 가정이 있습니다.

1.  **질량은 일정합니다 (The mass is constant).** 이는 전기 쿼드콥터에는 합리적이지만, 연료를 소비하는 내연기관 쿼드콥터에는 적합하지 않을 수 있습니다.
2.  **오일러 각은 $\cos \theta = 0$일 때 특이점(Singularity)을 가집니다.** 즉, 피치 각($\theta$)이 $\pm 90^{\circ}$ (코가 완전히 위나 아래를 향할 때)일 때는 방정식이 수학적으로 정의되지 않습니다. 이 모델에서는 작은 피치 각만 허용하므로 문제가 되지 않습니다.

### 상태 방정식 구현 (Implementation of Equations)

위에서 설명한 물리 방정식을 바탕으로, 6자유도 블록은 다음 상태 방정식들을 풀어 비행체의 현재 상태를 계산합니다.

* **관성 기준 프레임에서의 위치 변화율:**
    
    $$ \frac{\mathrm{d}}{\mathrm{d}t}\left\lbrack \begin{array}{c} x\newline y\newline z \end{array}\right\rbrack =R^T \left(\theta ,\phi ,\psi \right)\left\lbrack \begin{array}{c} u\newline v\newline w \end{array}\right\rbrack $$

    이 방정식은 바디 프레임에서의 속도($u,v,w$)를 비행기 자세($\theta, \phi, \psi$)에 따라 관성 프레임에서의 위치 변화율($x,y,z$)로 변환합니다. $R^T$는 바디 프레임에서 관성 프레임으로 변환하는 회전 행렬입니다.
* **바디 기준 프레임에서의 속도 변화율:**
  
    $$ \frac{d}{\mathrm{d}t}\left\lbrack \begin{array}{c} u\newline v\newline w \end{array}\right\rbrack =-\left\lbrack \begin{array}{c} p\newline q\newline r \end{array}\right\rbrack \times \left\lbrack \begin{array}{c} u\newline v\newline w \end{array}\right\rbrack +\frac{1}{m}\left\lbrack \begin{array}{c} F_x \newline F_y \newline F_z  \end{array}\right\rbrack $$

    바디 프레임에서 비행기가 받는 힘($F_x, F_y, F_z$)과 각속도($p,q,r$)에 따라 속도($u,v,w$)가 어떻게 변하는지를 나타냅니다.
* **바디 기준 프레임에서의 각속도 변화율:**
  
    $$ \frac{d}{\mathrm{d}t}\left\lbrack \begin{array}{c} p\newline q\newline r \end{array}\right\rbrack ={\left\lbrack \begin{array}{ccc} I_{\textrm{xx}}  & {-I}_{\textrm{xy}}  & {-I}_{\textrm{xz}} \newline {-I}_{\textrm{yx}}  & I_{\textrm{yy}}  & {-I}_{\textrm{yz}} \newline {-I}_{\textrm{zx}}  & {-I}_{\textrm{zy}}  & I_{\textrm{zz}}  \end{array}\right\rbrack }^{-1} \left(\left\lbrack \begin{array}{c} M_x \newline M_y \newline M_z  \end{array}\right\rbrack -\left\lbrack \begin{array}{c} p\newline q\newline r \end{array}\right\rbrack \times \left\lbrack \begin{array}{ccc} I_{\textrm{xx}}  & {-I}_{\textrm{xy}}  & {-I}_{\textrm{xz}} \newline {-I}_{\textrm{yx}}  & I_{\textrm{yy}}  & {-I}_{\textrm{yz}} \newline {-I}_{\textrm{zx}}  & {-I}_{\textrm{zy}}  & I_{\textrm{zz}}  \end{array}\right\rbrack \left\lbrack \begin{array}{c} p\newline q\newline r \end{array}\right\rbrack \right) $$

    비행기가 받는 토크($M_x, M_y, M_z$)와 현재 각속도($p,q,r$), 그리고 관성 텐서($I$)에 따라 각속도($p,q,r$)가 어떻게 변하는지를 설명합니다.
* **오일러 각 변화율:**
  
    $$ \frac{\mathrm{d}}{\mathrm{d}t}\left\lbrack \begin{array}{c} \theta \newline \phi \newline \psi  \end{array}\right\rbrack =\left\lbrack \begin{array}{ccc} 1 & \sin \left(\phi \right)\tan \left(\theta \right) & \cos \left(\phi \right)\tan \left(\theta \right)\newline 0 & \cos \left(\phi \right) & -\sin \left(\phi \right)\newline 0 & \frac{\sin \left(\phi \right)}{\cos \left(\theta \right)} & \frac{\cos \left(\phi \right)}{\cos \left(\theta \right)} \end{array}\right\rbrack \left\lbrack \begin{array}{c} p\newline q\newline r \end{array}\right\rbrack $$

    이 방정식은 앞서 설명한 것과 동일하게 각속도($p,q,r$)를 오일러 각($\phi, \theta, \psi$)의 변화율로 변환합니다.

---

## 4. Simulink 모델의 주요 요소

Simulink 모델을 구축하는 데 필요한 몇 가지 핵심 블록들이 있습니다.

* **Fixed Mass Body Euler Angles Equations of Motion Block:** 6자유도 블록의 정식 명칭이며, 질량이 고정된 물체의 오일러 각 기반 운동 방정식을 구현합니다.
* **Bus Creator / Bus Selector:** 여러 신호들을 하나의 '버스'로 묶거나, 묶인 버스에서 필요한 신호를 선택할 때 사용합니다. 모델의 가독성을 높여줍니다.
* **Scope:** 시뮬레이션 결과를 그래프로 시각화하여 보여주는 블록입니다.
* 그 외 기본적인 연산 블록들 (덧셈, 곱셈, 상수 등)이 사용됩니다.

---

## 5. 입력 힘(Forces) 설정

입력 힘은 반드시 비행체의 **바디 프레임 기준**이어야 합니다.

* **추력 (Thrust):** 프로펠러가 직접 아래를 향하므로, 추력은 Z축 방향으로 작용합니다.
* **중력 (Gravitational Force):** 관성(지구) 기준 프레임에서 바디 기준 프레임으로 변환되어 적용되어야 합니다.
* **토크 (Torques):** 이 초기 모델에서는 토크가 적용되지 않으므로, 토크 입력은 모두 0으로 설정됩니다.

### `Thrust = [0, 0, -10]` 의 의미

영상에서 스로틀 입력을 `-10`으로 설정하는 예시가 나옵니다. 여기서 `Thrust = [0, 0, -10]` 이라는 힘 벡터는 다음과 같이 해석됩니다:

* **X축 방향의 힘: 0**
* **Y축 방향의 힘: 0**
* **Z축 방향의 힘: -10**

Simulink에서 6자유도 블록이 사용하는 좌표계는 일반적으로 **Z축이 지면을 향하는(아래쪽) 방식**을 따릅니다. 따라서 `-10`이라는 음수 값은 **Z축의 양의 방향(아래)과는 반대되는, 즉 위쪽으로 10단위의 힘이 가해지는 것**을 의미합니다. 이는 쿼드콥터가 이륙하거나 상승할 때 필요한 **상향 추력**을 나타내는 것입니다.

---

## 6. 시뮬레이션 결과 및 분석

첫 번째 시뮬레이션 결과는 매우 예측 가능합니다. 첫 번째 시뮬레이션에서는 토크 입력 없이 시뮬레이션 합니다.

* **이륙 및 가속:** 이 경우, 추력이 중력보다 약간 더 커서 쿼드콥터는 **일정한 가속도**로 이륙합니다.
* **속도와 위치:** 속도 크기는 선형적으로 증가하며, 속도와 위치 값이 음수로 나타나는 것은 **Z축이 지면을 향하고 있기 때문**입니다. 즉, Z축이 아래를 향하는데 비행기가 위로 올라가므로 Z 위치는 점점 0에서 음수 방향으로 멀어지는 것을 의미합니다.

<center><img width = "60%" src="../../images/uav101/no01_Airframe/noTorque.jpg"/><br></center>

여기서 $Ve$와 $Xe$는 각각 지구 관성 기준 프레임의 속도와 위치인데, 순간적으로 속도를 내면서 올라갔다가 천천히 비행해 올라가면서 추력(thrust)과 중력(gravitational force)가 밸런스를 잡게되는 지점까지 올라가게 된다. 가속도가 일정하지 않은 것은 약간의 제어 블록이 포함되었기 때문이다. 

<center>
<video width = "60%" loop autoplay muted>
  <source src = "../../images/uav101/no01_Airframe/noTorque.mp4">     
</video> 아무런 토크 입력 없이 추력 10단위의 힘만 가해서 비행 시뮬레이션 하는 경우
</center>

### 초기 조건 조정

추력 값을 조절하여 쿼드콥터가 제자리에서 **호버링(Hovering)**할 수 있도록 힘을 결정하는 연습도 해볼 수 있습니다. 호버링은 추력과 중력이 정확히 균형을 이루는 상태를 말합니다.

---

## 7. 다음 단계 미리 보기: 제어 시스템으로 확장

후속 강의에서는 에어프레임에 대한 지식을 확장하고 쿼드콥터가 어떻게 작동하는지 학습합니다. 그 후에는 쿼드콥터를 원하는 상태로 제어하는 방법을 배우게 됩니다.

### 목표 위치 및 피드백 루프 (Commanded Position and Feedback Loop)

가장 큰 변화는 입력 부분에 있습니다. 단순히 추력 레벨을 지정하는 대신, **원하는 위치를 지정**하고 실제 위치에 대한 **피드백**을 사용하여 추력 레벨을 도출합니다.

이 모델에서 추력은 다음과 같은 방정식으로 계산됩니다:
$$ T=-m\;g+k_p \left(z_{\textrm{desired}} -z\right)+k_d \left(0-\frac{\textrm{dz}}{\textrm{dt}}\right) $$
* $T$: 계산된 총 추력
* $-m\;g$: **피드포워드 항**입니다. 쿼드콥터가 원하는 위치에서 호버링하고 있다면, 이 항은 중력($mg$)을 상쇄하는 데 필요한 정확한 양의 추력을 제공합니다.
* $k_p \left(z_{\textrm{desired}} -z\right)$: **비례 제어(P-control) 항**입니다. 원하는 고도($z_{\textrm{desired}}$)와 현재 고도($z$)의 **오차에 비례**하여 추력을 조절합니다. 고도가 낮으면 추력을 늘려 상승시키고, 높으면 추력을 줄여 하강시킵니다. $k_p$는 비례 상수입니다.
* $k_d \left(0-\frac{\textrm{dz}}{\textrm{dt}}\right)$: **미분 제어(D-control) 항**입니다. 현재 속도($\frac{\textrm{dz}}{\textrm{dt}}$)의 **변화율에 비례**하여 추력을 조절합니다. 속도가 급격하게 변하는 것을 막아 안정적인 제어를 돕습니다. $k_d$는 미분 상수입니다.

이러한 제어 방식을 통해 쿼드콥터가 원하는 고도에 도달하지 못했다면, 추가 항에 의해 추력이 증가하여 고도를 맞추게 됩니다. 이는 고전적인 **PID 제어**의 한 형태로, 비행체가 원하는 상태를 유지하도록 돕는 핵심적인 방법입니다.

### 시뮬레이션된 다중 바디 모델 (Simulated Multibody Model)

시뮬레이션의 또 다른 새로운 요소는 다중 바디 쿼드콥터의 움직임을 시뮬레이션하는 것입니다. 이 예시에서는 주로 **움직임을 시각적으로 보여주는 목적**으로 사용됩니다. 이 블록은 Simulink UAV Toolbox / Simulation 3D에서 찾을 수 있습니다.

---

## 결론

이 포스팅에서는 Simulink를 활용한 에어프레임 모델 구축의 깊은 내용을 탐구했습니다. 단순히 모델을 만드는 것을 넘어, 그 이면에 있는 물리 방정식, 좌표계의 중요성, 그리고 제어 시스템의 기초까지 살펴보았습니다. 이는 향후 더욱 복잡한 비행체 제어 시스템을 개발하는 데 필수적인 기반 지식을 제공합니다.

이 포스팅이 Simulink를 이용한 에어프레임 모델링 이해에 도움이 되었기를 바랍니다! 궁금한 점이 있다면 언제든지 댓글로 질문해주세요.