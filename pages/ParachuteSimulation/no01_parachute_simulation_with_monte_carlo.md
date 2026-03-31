---
title: 낙하산 시뮬레이션 - 하늘에서 떨어뜨린 패키지가 어디에 떨어질지 미리 알 수 있을까?
published: true
sidebar: aerospace
permalink: no01_parachute_simulation_with_monte_carlo.html
identifier: no01_parachute_simulation_with_monte_carlo
toc: true
ogimage: https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/ParachuteSimulation/ogimage.png
---

본 포스트는 아래의 매트랩/시뮬링크의 Aerospace Blockset의 예제에 기반하여 작성되었습니다.

👉[Parachute Simulation Study with Monte Carlo Analysis](https://kr.mathworks.com/help/aeroblks/parachute-simulation-study-with-monte-carlo-analysis.html)

---

*"저희는 낙하산 시뮬레이션이 필요한데요..."*

낙하산? 로켓 동아리에 MATLAB, Simulink 활용한 지원이 필요한게 뭐가 있는지 알아보는 과정에서 받은 요청사항이다. 당연히 로켓, 비행기, 쿼드콥터 드론 같은 얘기를 할 줄 알았거늘 낙하산은 의외였다. 하지만, 알고보니 로켓에 카메라나 여타 센서를 달아서 신호를 획득하려면 낙하산 장착은 필수적이었다. 또, 센서를 굳이 달지 않더라도 발사체를 재사용하기 위해선 낙하산은 필수적인 요소였다.

다행히 매스웍스에서 [직접 제공하는 예제](https://kr.mathworks.com/help/aeroblks/parachute-simulation-study-with-monte-carlo-analysis.html)가 있어 이 예제를 기반으로 낙하산 시뮬레이션에 대해 알아보고자 한다. 이 포스팅에서 다루는 예제는 원래 예제에서 약간 수정된 부분이 있다.

# 시뮬레이션의 진행 과정

![](../images/ParachuteSimulation/pic1.png)

시뮬레이션은 위와 같이 전개된다. 고도 250m에서 x 방향으로 10m/s, y 방향으로 10m/s로 비행하고 있는 물체에서 패키지가 사출된다. 투하 초기, 패키지는 항공기의 비행 속도를 그대로 이어받는다. 낙하산이 펼쳐지기 전까지 패키지는 공기 저항이 거의 없는 '포물선 운동'을 하며 관성에 의해 전방으로 나아간다.

하지만 설정된 고도 100m 에 도달하여 낙하산이 펼쳐지는 순간 항력 (drag force, $F_d$)를 받아 속도가 줄어들기 시작한다.

이 포스팅에서 사용된 시뮬링크 모델은 아래 링크에서 확인할 수 있다.

👉[Parachute Workshop Material](https://github.com/angeloyeo/Parachute_Simulation_Workshop)

# 자유낙하

낙하산을 달아서 시뮬레이션 하기에 앞서, 우선 물체를 낙하산 없이 자유낙하 시키는 시뮬레이션부터 시작해보자. 

시뮬링크에는 6 자유도 (xyz 방향 힘과 모멘트) 물리 모델링 및 공기 밀도나 바람 등의 환경 모델링을 위한 블록([6DOF (Euler Angles)](https://kr.mathworks.com/help/aeroblks/6dofeulerangles.html))을 제공한다.

![](../images/ParachuteSimulation/pic2.png)

이 **6자유도 (6 Degrees of Freedom) 블록**은 낙하 물체의 움직임을 시뮬레이션하는 데 있어 핵심적인 '물리 엔진' 역할을 한다. 6자유도는 3개의 선형 이동(앞뒤, 좌우, 상하)과 3개의 회전 이동(롤, 피치, 요)을 포함하여 물체가 공간에서 가질 수 있는 모든 움직임을 의미한다. 여기서 (Euler Angles)는 이러한 회전 움직임을 '오일러 각'이라는 방식으로 표현한다는 뜻이다. 이 블록은 낙하 물체에 **가해지는 힘(Forces)과 토크(Torques)를 입력**으로 받는다. 다만 여기서는 토크는 없는 상태를 가정할 것이다. 그리고 이 입력값을 기반으로 낙하 물체의 **속도, 위치, 오일러 각(자세), 그리고 가속도**와 같은 다양한 출력값을 계산하여 제공받을 수 있다. 여기서는 속도와 위치를 중점적으로 볼 예정이다.

[워크샵 자료](https://github.com/angeloyeo/Parachute_Simulation_Workshop)의 `no01_freefalling.slx` 파일을 열어보면 아래와 같이 모델링되어 있는 것을 알 수 있다.

![](../images/ParachuteSimulation/pic3.png)

왼쪽 위부터 중력을 계산하였고, 낙하산에 의한 항력은 x, y, z 방향 모두 0으로 설정하였다. $M_{xyz}$에 들어가는 값은 회전 관성 모멘트인데 이 물체는 회전하지 않는다고 가정하여 x, y, z에 들어가는 값 모두를 마찬가지로 0으로 설정하였다. 6DOF 블록의 오른쪽에 나오는 $V_e$와 $X_e$는 각각 관성계(여기서는 지구)에서 본 속도와 위치이다. 와이파이 표시처럼 생긴 것은 이 시뮬레이션의 값을 수치적으로 관찰하겠다는 의미로 달았다. 수치적으로 보면 아래와 같은 결과를 얻을 수 있다.

![](../images/ParachuteSimulation/pic4.png)

위 그림의 아랫쪽 패널에 있는 `position(3)` 의 수치를 보면 250m에서 최종 0m까지 포물선을 그리며 떨어지는 것을 알 수 있다.

# 낙하산을 붙이면

[워크샵 자료](https://github.com/angeloyeo/Parachute_Simulation_Workshop)의 `no02_parachuteDrag.slx` 파일을 열어보면 아래와 같이 모델링되어 있는 것을 알 수 있다.

![](../images/ParachuteSimulation/pic5.png)

새롭게 포함된 Environment 서브시스템에 들어가보면 아래와 같이 현재 위치에 따라 항력을 [0, 0, 0]이 아니라 다른 값으로 계산하도록 만든 것을 알 수 있다.

![](../images/ParachuteSimulation/pic6.png)

낙하산은 100m부터 펼치도록 모델링하였으며 항력은 아래와 같이 계산된다.

$$F_{d} = \frac{1}{2}C_d A \rho v^2$$

* $C_d$: 항력 계수 (unitless)
* $A$: 물체의 운동에 수직인 방향으로 물체에 투영된 단면적 (m^2)
* $\rho$: 유체의 밀도 (kg/m^3)
* $v$: 물체의 속력 (m/s)

또, 여기서 항력 계수 $C_d$는 아래와 같이 계산하였다.

$$C_d = \frac{2mg}{\rho v^2 A}$$

항력과 중력은 방향이 반대이며, 계속 낙하하다가 항력과 중력이 같아지는 지점에서 종단 속도에 도달하게 되면서 약 5.3m/s의 속도로 착지하게 된다.

![](../images/ParachuteSimulation/pic7.png)

이제, 낙하산이 없을 때와 낙하산을 100m 상공에서 펼칠 때를 3D 시각화할 수도 있다. 시각화는 매스웍스에서 제공하는 [US City Scene](https://kr.mathworks.com/help/uav/ref/uscityblock.html)에서 진행하였다. 이 Scene의 지도는 아래와 같으며 지도의 9번 교차로 (좌표: 76.40, 0)에서 물체를 사출하였다. x, y 방향으로 모두 10m/s으로 날고 있었으니 9번 교차로에서 15번 교차로로 낙하하게 된다.

![](../images/ParachuteSimulation/pic8.png)

<center>
<video width = "100%" loop autoplay muted controls>
  <source src = "../../images/ParachuteSimulation/compare1and2.mp4">    
</video> 자유 낙하 할 때와 100m 상공에서 낙하산을 펼칠 때의 시뮬레이션 비교 시각화
</center>

# 바람 시뮬레이션

[워크샵 자료](https://github.com/angeloyeo/Parachute_Simulation_Workshop)의 `no03_parachuteDragAndWind.slx` 모델을 열어 Environment 서브시스템에 들어가보면 아래와 같이 바람 모델이 추가되어 있는 것을 알 수 있다.

![](../images/ParachuteSimulation/pic9.png)

바람의 모델링은 [Wind Shear Model](https://kr.mathworks.com/help/aeroblks/windshearmodel.html), [Dryden Wind Turbulence Model (Continous)](https://kr.mathworks.com/help/aeroblks/drydenwindturbulencemodelcontinuous.html), [Discrete Wind Gust Model](https://kr.mathworks.com/help/aeroblks/discretewindgustmodel.html)의 세 가지 블록을 이용해 수행되었다. 이 블록들은 모두 군사 규격에 의거한 것이라고 한다.

* Wind Shear Model – 고도에 따라 풍속이 달라지는 현상인 윈드시어를 모델링하며, 주로 지표면 근처에서의 바람 구배를 시뮬레이션한다.
* Dryden Wind Turbulence Model (Continuous) – 실제 대기 난류를 연속 확률 과정으로 표현하며, 필터링된 백색 잡음을 통해 난류의 주파수 특성을 재현한다.
* Discrete Wind Gust Model – 특정 시점에 급격하게 불어오는 돌풍을 이산적인 파형(1-cosine 형태)으로 모델링하여 구조적 하중 해석 등에 활용된다.

![](../images/ParachuteSimulation/pic10.png)

시뮬레이션 결과 수치는 아래와 같다. 마지막 행에 풍속 값을 표시해보았다. 미미해보이긴하지만 이와 같이 바람을 모델링할 수 있었고, 시뮬레이션 말미에는 바람 값을 랜덤하게 바꾸어가면서 어디에 물체가 떨어질지 대략적인 분포를 활용하는데 쓰고자 한다.

![](../images/ParachuteSimulation/pic11.png)

바람이 없을 때와 바람이 있을 때를 비교한 3D 시각화 결과는 아래와 같다.

<center>
<video width = "100%" loop autoplay muted controls>
  <source src = "../../images/ParachuteSimulation/compare2and3.mp4">    
</video> 100m 상공에서 낙하산을 펼칠 때 바람이 없을 때와 바람이 있을 때의 비교
</center>

# 랜덤성을 고려한 시뮬레이션 - Monte Carlo 분석을 통한 낙하 분포 확인

시뮬레이션 할 때 한 가지 생각해야하는 점은 언제나 실제 구현은 시뮬레이션과 다르다는 점이다. 가령, 낙하 지점의 편차, 바람의 변화 혹은 낙하산을 펼치는 높이 등의 오차도 고려할 수 있을 것이다. Simulink는 시뮬레이션 할 때 이와 같은 값들을 바꿔가면서 수차례 시뮬레이션 할 수 있다. 또, Simulink는 병렬 시뮬레이션 기능을 지원하므로 여러 CPU 코어들이 병렬적으로 시뮬레이션을 수행하게 할 수 있다.

[워크샵 자료](https://github.com/angeloyeo/Parachute_Simulation_Workshop)의 `no04_geoplotWithTargetOnTheMap_m.m` 파일을 열어 코드를 실행하면 총 100회 병렬 시뮬레이션을 수행하는 것을 알 수 있다. 여기서는 사출 고도와 낙하산 적용 지점의 편차를 정규분포로 모델링하고, 바람의 형태도 랜덤성을 부여하였다.

앞선 `no03_parachuteDragAndWind.slx` 모델의 시뮬레이션의 배경을 위성 지도로 옮겨, 김해공항(latitude: 35.176250, longitude: 128.944814)의 250m 상공에서 자유낙하 및 100m 상공에서 낙하산을 펼치게 된다면 아래와 같이 착륙시킬 수 있다.

![](../images/ParachuteSimulation/pic12.png)

parsim 명령어로 병렬 시뮬레이션을 실행하면 아래와 같이 시뮬레이션 매니저 창이 뜨면서 현재 입력으로 넣고 있는 값들을 표시해준다. 총 100회 시뮬레이션을 수행하며 시뮬레이션 매니저에서는 8.5배 속도 향상을 보았다고 한다.

![](../images/ParachuteSimulation/pic13.png)

이를 통해 위성 지도 상에서 100회 시뮬레이션 결과를 확인해보면 아래와 같이 빨간 네모 안의 범위에 착륙할 수 있는 것을 알 수 있다.

![](../images/ParachuteSimulation/pic14.png)


