---
title: 모델 예측 제어(MPC)를 이용해 로켓을 수직착륙 시켜보았습니다 (2탄)
published: true
permalink: vertical_landing_of_rocket_with_MPC_6DOF.html
summary: "6자유도 로켓 동역학 모델 및 MPC를 활용한 로켓 수직 착륙 제어"
tags: [MPC, Simscape Multibody, Controls]
identifier: vertical_landing_of_rocket_with_MPC_6DOF
sidebar: false
toc: true
ogimage: https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/blog_posts/2026-03-26-vertical_landing_of_rocket_with_MPC_6DOF/ogimage.png
---

본 포스트의 원문은 아래의 링크에서 확인할 수 있습니다.

👉[非線形モデル予測制御によるロケットの着陸制御🚀 第2弾](https://qiita.com/getBack1969/items/9738e4dad615c95a68cd)

---

# 시작하며

일론 머스크가 이끄는 SpaceX에서는 화성 및 달 비행을 위한 로켓 개발을 추진하고 있습니다.
특히 Starship은 현존하는 로켓 중에서도 최대급의 로켓 엔진을 탑재하고 있으며, Falcon 9 로켓과 같은 부분 재사용이 아닌 완전 재사용 가능한 RLV(Reusable Launch Vehicle)를 목표로 개발이 진행되고 있습니다.
또한 Falcon 9과 마찬가지로 자율적인 착륙 제어 기술을 통해 기체의 자세를 유지하고, 정해진 궤도 및 착륙 지점까지 비행할 수 있는 시스템으로 구성되어 있는 것으로 알려져 있습니다.

<iframe width="560" height="315" src="https://www.youtube.com/embed/921VbEMAwwY?si=mNjyqReIKG2ZvyAQ" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

<iframe width="560" height="315" src="https://www.youtube.com/embed/5seefpjMQJI?si=AFqzg2JnoWzwKWto" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

<iframe width="560" height="315" src="https://www.youtube.com/embed/ODY6JWzS8WU?si=24Dun6x4768M8xnz" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

이전 글 ([모델 예측 제어(MPC)를 이용해 로켓을 수직착륙 시켜보았습니다](https://matlabtutorial.github.io/vertical_landing_of_rocket_with_MPC.html)) 에서 SpaceX의 로켓 제어에는 모델 예측 제어(MPC)가 사용되고 있다는 점을 바탕으로, 실제로 간단한 로켓의 비선형 운동 모델을 기반으로 시뮬레이션을 수행했습니다.

이번에는 이전 내용에서 조금 더 **심화된** 시뮬레이션을 진행해 보고자 합니다.


# 6자유도 비선형 운동방정식

이번 검토에 사용할 로켓의 운동 모델은 X, Y, Z의 3차원 공간 내 위치 및 자세를 고려한 강체 운동으로 가정하여, 6자유도 비선형 운동방정식을 구성합니다.

여기서 로켓은 엔진에서 연료를 연소시켜 추력을 얻지만, 연료를 소비함에 따라 기체의 질량이 시시각각 변화하는 강한 비선형성을 가진 대상으로 알려져 있습니다.
이에 더해, 행성의 대기 중을 항행할 때는 기체에 가해지는 저항 등의 공기력, 바람 등 다양한 불확정 외력이 발생하므로 예측이 어려운 복잡한 제어 대상이 됩니다.

따라서 MPC를 설계하기 위해서는 먼저 위의 요소들을 포함한 운동 모델을 수식으로 준비하는 것이 전제 조건입니다.
그러므로 아래 그림과 같이 질량 변화 및 공기력을 고려한 6자유도 비선형 운동방정식을 정의합니다.

![Screenshot 2024-03-11 135219.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2525369/eab346f3-6dd7-4bed-dbda-d2240013c9c7.png)


> [!WARNING]
> 본 모델은 실제 로켓 제어에 사용되는 엄밀한 모델이 아닙니다.
> 본 글 내에서만 유효한 모델임을 양해 바랍니다.

상태량은 총 13개이며, 모두 센서 등을 통해 관측 가능하다고 가정합니다.

또한 로켓의 제어 방식으로는 추력 벡터 제어(TVC)를 전제로 합니다.
따라서 제어 입력으로는 추력 $T$, 각 축 방향의 짐벌 각도($\eta_1$, $\eta_2$), 총 3개를 다루기로 합니다.

# 수식 툴을 이용한 운동방정식 코드 자동 생성

앞 장에서 로켓의 운동방정식이 도출되었으므로, 이를 MATLAB의 함수 코드로 준비합니다.
MATLAB의 제품군 중 하나인 Symbolic Math Toolbox는 기호(심볼릭) 수식 표현을 기반으로 변수 간의 사칙연산·행렬 연산, 미분·편미분 등을 수행할 수 있을 뿐만 아니라, 그 결과로부터 MATLAB이나 C 등의 코드를 자동으로 생성하는 기능을 갖추고 있습니다. 이를 활용하여 운동방정식에서 MATLAB 함수 코드를 자동 생성하고자 합니다.

기호 변수를 정의하려면 `sym` 또는 `syms` 커맨드를 사용합니다.

[syms 또는 sym 함수 선택하기](https://kr.mathworks.com/help/symbolic/choose-syms-or-sym-function.html)

또한 정의한 수식으로부터 야코비안(Jacobian)이나 헤시안(Hessian)을 계산할 때는 `jacobian`, `hessian` 커맨드를 활용할 수 있습니다.

[jacobian, 기호 함수로 구성된 야코비 행렬](https://kr.mathworks.com/help/symbolic/sym.jacobian.html)

[hessian, 기호 스칼라 함수로 구성된 헤세 행렬](https://kr.mathworks.com/help/symbolic/sym.hessian.html)

최종적으로 생성한 각 수식 객체로부터 코드를 자동 생성할 때는 `matlabFunction` 커맨드 또는 `ccode` 커맨드를 사용할 수 있습니다.

[matlabFunction, 기호 표현식을 함수 핸들 또는 파일로 변환](https://kr.mathworks.com/help/symbolic/sym.matlabfunction.html)

[ccode, C code presentation of symbolic expression](https://kr.mathworks.com/help/symbolic/sym.ccode.html)

위 기능을 사용하여 로켓 운동 모델의 코드를 생성하는 스크립트는 다음과 같습니다.

```matlab
% Symbolic Math Toolbox를 이용한 로켓 운동 모델 자동 코드 생성 예시
% States
syms xe ye ze u v w phi theta psi p q r m
x1 = [xe;ye;ze];
x2 = [u;v;w];
x3 = [phi;theta;psi];
x4 = [p;q;r];
states = [x1;x2;x3;x4;m];
V = sqrt(u^2+v^2+w^2);

% Inputs
syms T ita1 ita2
inputs = [T;ita1;ita2];

% Pareameters
syms s_L s_radius s_Ixx s_Iyy s_Izz s_g s_Sx s_Sy s_Sz s_Cd s_rho s_Isp s_MainThrust
I = diag([s_Ixx,s_Iyy,s_Izz]);                        % Inertia matrix

% Additional input parameters for NMPC
syms Q Qn R;

% Rotation Matrix
% Body to Inertia
Reb = [cos(psi)*cos(theta) cos(psi)*sin(theta)*sin(phi)-sin(psi)*cos(phi) cos(psi)*sin(theta)*cos(phi)+sin(psi)*sin(phi);
       sin(psi)*cos(theta) sin(psi)*sin(theta)*sin(phi)+cos(psi)*cos(phi) sin(psi)*sin(theta)*cos(phi)-cos(psi)*sin(phi);
       -sin(theta) cos(theta)*sin(phi) cos(theta)*cos(phi)];
% Inertia to Body
Rbe = [cos(psi)*cos(theta) sin(psi)*cos(theta) -sin(theta);
       cos(psi)*sin(theta)*sin(phi)-sin(psi)*cos(phi) sin(psi)*sin(theta)*sin(phi)+cos(psi)*cos(phi) cos(theta)*sin(phi);
       cos(psi)*sin(theta)*cos(phi)+sin(psi)*sin(phi) sin(psi)*sin(theta)*cos(phi)-cos(psi)*sin(phi) cos(theta)*cos(phi)];

% Angular velocity matrix
R_ang = [1 sin(phi)*tan(theta) cos(phi)*tan(theta);
     0 cos(phi) -sin(phi);
     0 sin(phi)/cos(theta) cos(phi)/cos(theta)];

% State Function
f = [Reb*x2;
    1/m*([s_MainThrust*T*cos(ita2)*cos(ita1) -s_MainThrust*T*cos(ita2)*sin(ita1) s_MainThrust*T*sin(ita2)]')-cross(x4,x2)+Rbe*[-s_g 0 0]'-s_rho/(2*m)*[V*u*s_Sx*s_Cd V*v*s_Sy*s_Cd V*w*s_Sz*s_Cd]';
    R_ang*x4;
    inv(I)*(0.5*s_L*[0 s_MainThrust*T*sin(ita2) s_MainThrust*T*sin(ita1) ]'-cross(x4,I*x4));
    -s_MainThrust*T/(s_Isp*s_g)];
f = subs(f,[s_L s_radius s_Ixx s_Iyy s_Izz s_g s_Cd s_Sx s_Sy s_Sz s_rho s_Isp s_MainThrust],[L radius Ixx Iyy Izz g Cd Sx Sy Sz rho Isp Main_Thrust]);
f = simplify(f);

% Jacobian
A = jacobian(f,states);
B = jacobian(f,inputs);

% Generate MATLAB Function Code
matlabFunction(f,'File','./source/landerStateFcn','Vars',{states,inputs,Q,Qn,R});
matlabFunction(A,B,'File','./source/landerStateJacobianFcn','Vars',{states,inputs,Q,Qn,R});
```

참고로, 기체 및 환경에 관해 사전에 정의된 기호 파라미터 변수(s_L, s_radius 등)에는 `subs` 커맨드를 사용하여 실제 값을 대입·처리할 수 있습니다.

[subs, 기호 대입](https://kr.mathworks.com/help/symbolic/sym.subs.html)

이번에는 다음 파라미터를 사용합니다.
특히 중력 가속도와 공기 밀도는 화성의 값으로 설정했습니다.

```matlab
% Initial mass
mass = 500e3;
dry_mass = 0.7*mass;
% Length
L = 47.5;
% Radius
radius = 1.865;
% Inertia
Ixx = 0.5*mass*radius^2;
Iyy = (radius^2/4 + L^2/12)*mass;
Izz = Iyy;
% Representative area
Sx = pi*radius^2;
Sy = L*2*radius;
Sz = Sy;
% Drag coefficient
Cd = 2;
% Specific impulse
Isp = 348;
% Gravity of Mars
g = 3.721;
% Air density of Mars
rho = 0.0118;
% Main Thrust
Main_Thrust = 5*mass*g;
% RCS Thrust
RCS_Thrust = 3e4;
```

다음은 기호 수식으로부터 `matlabFunction` 커맨드를 통해 실제로 생성된 MATLAB 함수 코드 중 하나입니다.

```matlab
function f = landerStateFcn(in1,in2,Q,Qn,R)
%landerStateFcn
%    F = landerStateFcn(IN1,IN2,Q,Qn,R)

%    This function was generated by the Symbolic Math Toolbox version 9.3.
%    2024/03/07 18:32:52

T = in2(1,:);
ita1 = in2(2,:);
ita2 = in2(3,:);
m = in1(13,:);
p = in1(10,:);
phi = in1(7,:);
psi = in1(9,:);
q = in1(11,:);
r = in1(12,:);
theta = in1(8,:);
u = in1(4,:);
v = in1(5,:);
w = in1(6,:);
t2 = conj(T);
t3 = conj(ita1);
t4 = conj(ita2);
t5 = cos(phi);
t6 = cos(psi);
t7 = cos(theta);
t8 = sin(phi);
t9 = sin(psi);
t10 = sin(theta);
t11 = tan(theta);
t15 = u.^2;
t16 = v.^2;
t17 = w.^2;
t18 = 1.0./m;
t12 = cos(t4);
t13 = sin(t3);
t14 = sin(t4);
t19 = t15+t16+t17;
t20 = sqrt(t19);
t21 = conj(t20);
mt1 = [-v.*(t5.*t9-t6.*t8.*t10)+w.*(t8.*t9+t5.*t6.*t10)+t6.*t7.*u;v.*(t5.*t6+t8.*t9.*t10)-w.*(t6.*t8-t5.*t9.*t10)+t7.*t9.*u;-t10.*u+t7.*t8.*v+t5.*t7.*w;-q.*w+r.*v-t6.*t7.*3.721-t18.*t21.*conj(u).*1.289405600688818e-1+t2.*t12.*t18.*cos(t3).*9.3025e+6];
mt2 = [p.*w-r.*u+t5.*t9.*3.721-t18.*t21.*conj(v).*2.090665-t6.*t8.*t10.*3.721-t2.*t12.*t13.*t18.*9.3025e+6;-p.*v+q.*u-t8.*t9.*3.721-t18.*t21.*conj(w).*2.090665-t5.*t6.*t10.*3.721+t2.*t14.*t18.*9.3025e+6;p+q.*t8.*t11+r.*t5.*t11;q.*t5-r.*t8;(q.*t8+r.*t5)./t7;0.0];
mt3 = [p.*r.*9.907930069717351e-1+t2.*t14.*2.339286561771103;p.*q.*(-9.907930069717351e-1)+t2.*t13.*2.339286561771103;T.*(-7.183908045977011e+3)];
f = [mt1;mt2;mt3];
end
```

보충 설명으로, `in1`이 상태, `in2`가 입력에 해당합니다.

또한 Q, Qn, R은 각각 평가 함수 내 각 항의 가중치에 관한 추가 파라미터입니다.
가중치 파라미터는 상태 함수의 계산에 직접 관계되지는 않지만, 비선형 모델 예측 제어(NMPC) 설계에서는 툴의 제약상 외부에서 추가로 제공하는 조정 가능한 임의의 파라미터는 모든 함수에 입력 인수로 포함시켜야 합니다.
자세한 내용은 다음 헬프 문서를 참조하세요.

[Specify Prediction Model for Nonlinear MPC](https://kr.mathworks.com/help/mpc/ug/specify-prediction-model-for-nonlinear-mpc.html)


# 상세한 로켓 물리 모델

앞 장까지에서 로켓의 운동을 나타내는 운동방정식이 생성되었습니다.
이는 이후 MPC의 예측 모델로 사용되지만, 이와는 별도로 시뮬레이션을 위한 플랜트 모델(제어 대상)이 필요합니다.

일반적으로는 생성한 수식 모델을 그대로 플랜트 모델로 사용해도 되지만, 여기서는 보다 상세한 물리 모델로 구축하는 것을 전제로 하여 물리 모델링 툴인 Simscape, Simscape Multibody를 사용하여 아래 그림과 같이 모델링합니다.

<img width="1000" alt="파일명" src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2525369/1a023c36-a7ca-630d-431a-51489b967070.png">

여기서 Simscape Multibody는 3D 기구 모델을 설계하기 위한 물리 모델링 툴로, 형상 지정(CAD 가져오기도 지원), 운동의 자유도 및 구속 조건, 접촉 정의 등을 모델화할 수 있습니다.

<img width="800" alt="파일명" src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2525369/d6bf4a41-22d1-2b34-af18-1938317942a8.png">

<img width="800" alt="파일명" src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2525369/920f857c-5418-890d-1aee-e7c6f1360564.png">

<img width="800" alt="파일명" src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2525369/4999a7d0-0533-3b49-f547-5462467c14cc.png">

특히 접촉 정의에서는 Spatial Contact Force 블록을 사용하여, 블록에 입력하는 기준 축(B: Base)과 상대 축(F: Follower) 간의 고체끼리의 접촉력을 계산합니다.

[Modeling Contact Force Between Two Solids](https://kr.mathworks.com/help/sm/ug/modeling-contact-force-between-two-solids.html)

접촉 계산은 아래 그림과 같이 볼록 껍질(Convex Hull)을 기반으로 수행됩니다.

<img width="400" alt="파일명" src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2525369/e77d71b4-6cd9-3909-db06-1f1519c8395a.png">

이미지 출처: [Spatial Contact Force](https://kr.mathworks.com/help/sm/ref/spatialcontactforce.html)


이번에는 각 착륙 다리의 끝 면과 지면 사이에 접촉을 정의하여, 접지 시 지면을 관통하지 않도록 처리합니다.

완성된 모델은 Mechanics Explorer 기능을 통해 3D 애니메이션으로 표시할 수 있습니다.

<img width="1000" alt="파일명" src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2525369/3f9bf5bf-bec2-686f-d285-04aac7a649c6.png">

도출한 수식 모델과 Simscape 상세 모델 간의 차이를 시뮬레이션으로 확인해 봅니다.
비교 시뮬레이션에서는 아래 그림과 같이 각 모델에 동일한 입력을 인가했을 때의 응답을 확인합니다.

<img width="600" alt="파일명" src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2525369/1b86488f-30b5-aff4-c4ce-2499645105e6.png">

다음 그림은 10초간 시뮬레이션을 수행한 결과 트렌드입니다.
이때의 테스트 입력으로는 기체를 천천히 하강시키면서 추력 편향으로 자세 변화를 일으키는 운동을 모의했습니다.

<img width="1000" alt="파일명" src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2525369/c2c06850-88b8-f34c-4c5a-439a5c65a0d1.png">

각 상태량에 대해 파란 선이 수식 모델, 초록 선이 상세 모델의 결과인데, 대체로 파형의 경향은 일치하지만 오차가 존재함을 알 수 있습니다.
이 오차는 모델링에 따른 오차로, 모델링 오차라고 합니다.

제어계 설계에서는 이처럼 실기(이번에는 모두 가상의 모델이지만...)와의 모델링 오차가 필연적으로 발생합니다.
따라서 오차에 대해 강인(robust)한 제어계를 구축하는 것이 필요합니다.

# 비선형 모델 예측 제어를 이용한 착륙 제어계 구성

이제 착륙 제어를 위한 컨트롤러를 MPC의 일종인 비선형 모델 예측 제어(NMPC: Nonlinear MPC)를 사용하여 설계해 보겠습니다.
이번에도 컨트롤러 개발에는 Model Predictive Control Toolbox를 사용합니다.
설계는 이전 글의 내용을 기반으로 하고 있으나, 크게 다른 점으로는 ① 질량 제약을 고려한다는 점, ② 착륙에 관한 비선형 부등식 제약을 고려한다는 점이 있습니다.

①에 관해서는, 로켓 질량의 약 30%가 연료(wet mass)이고 나머지가 기체 구조에 관한 질량(dry mass)이라고 가정합니다.
따라서 질량에는 하한 제약(dry mass)을 물리적으로 위반하지 못하도록 제약을 부여합니다.
이렇게 함으로써 NMPC는 항상 질량이 하한 이상이 되도록 제어하므로, 연료의 유한성을 고려한 최적화를 수행하게 됩니다.
만약 연료가 소진된 경우에는 엔진 추력이 발생하지 않게 되는데, 그 영향은 플랜트 모델 측에서 처리합니다. (제어적으로는 실행 불가능한 상태)

②에 관해서는, 착륙 지점으로 정밀하게 유도하기 위해 아래 그림과 같이 착륙 지점인 관성계의 원점을 꼭짓점으로 하는 글라이드 슬로프(Glide Slope)를 설정하고, 슬로프에 의해 형성되는 원뿔면에 대해 기체가 항상 그 면 내에 위치하도록 제어하는 것을 제약 조건으로 부여합니다.

<img width="800" alt="파일명" src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2525369/198a19bb-d27a-6d15-d716-9d7eb028fae9.png">

다음은 NMPC 설계 스크립트입니다.

```matlab
% 비선형 모델 예측 제어 설계
Ts = 0.6;
lander = nlmpc(13,13,3);
lander.Ts = Ts;
p = 12;
m = 2;
lander.PredictionHorizon = p;
lander.ControlHorizon    = m;

% Model
lander.Model.StateFcn = 'landerStateFcn';
lander.Jacobian.StateFcn = 'landerStateJacobianFcn';

% Custom Cost Function
lander.Optimization.CustomCostFcn = 'landerCostFunction';

% Custom Constraints
lander.Optimization.CustomIneqConFcn = 'landerIneqConFunction';

% Thrust Power [pu]
lander.MV(1).Min = 0;
lander.MV(1).Max = 1;

% Gimbal1 angle [rad]
lander.MV(2).Min = -10*pi/180;
lander.MV(2).Max = 10*pi/180;
lander.MV(2).RateMin = -100*pi/180*Ts;
lander.MV(2).RateMax = 100*pi/180*Ts;

% Gimbal2 angle [rad]
lander.MV(3).Min = -10*pi/180;
lander.MV(3).Max = 10*pi/180;
lander.MV(3).RateMin = -100*pi/180*Ts;
lander.MV(3).RateMax = 100*pi/180*Ts;

% OV physical limits
% x 
lander.OV(1).MinECR = 0;
lander.OV(1).Min = L/2;
% Mass
lander.OV(13).Min = dry_mass;
lander.OV(13).MinECR = 0;                            % Hard constraint

% Scaling Factor
lander.States(1).ScaleFactor = 100;
lander.States(2).ScaleFactor = 100;
lander.States(3).ScaleFactor = 100;
lander.States(4).ScaleFactor = 10;
lander.States(5).ScaleFactor = 10;
lander.States(6).ScaleFactor = 10;
lander.States(7).ScaleFactor = 10*pi/180;
lander.States(8).ScaleFactor = 10*pi/180;
lander.States(9).ScaleFactor = 10*pi/180;
lander.States(10).ScaleFactor = 10*pi/180;
lander.States(11).ScaleFactor = 10*pi/180;
lander.States(12).ScaleFactor = 10*pi/180;
lander.States(13).ScaleFactor = mass;
lander.ManipulatedVariables(2).ScaleFactor = 10*pi/180;
lander.ManipulatedVariables(3).ScaleFactor = 10*pi/180;

% Weights for cost function
Q = diag([50 50 50 5 5 5 0 2 2 0 1 1 0]);               % Stage cost of state
Qn = 10*diag([100 100 100 10 10 10 0 2 2 0 1 1 0]);       % Terminal cost
R = diag([2 .1 .1]);                               % Stage cost of input 

% Number of optional parameters
lander.Model.NumberOfParameters = 3;
```

```matlab
% 글라이드 슬로프에 관한 비선형 부등식 제약
function cineq = landerIneqConFunction(X,U,e,data,Q,Qn,R)
    % X:states
    % U:inputs
    % e:slack variable
    % data:structured parameters
    % Q,Qn,R:additional parameters (weights)
    
    % Nonlinear inequality constraint about Glide Slope
    x = X(:,1);
    y = X(:,2);
    z = X(:,3);
    glide_slope_angle = 20*pi/180;  % Glide slope angle

    cineq = sqrt(y.^2 + z.^2)*tan(glide_slope_angle)-x;
end
```

여기서 NMPC의 제어 주기는 계산 비용을 고려하여 0.6[s]로 설정하고, 예측 호라이즌은 12스텝으로 설정하여 7.2[s] 앞까지의 응답을 예측하면서 실시간으로 최적화 문제를 풀어나가는 설정으로 합니다.
또한 평가 함수의 각 가중치(Q, Qn, R)는 시뮬레이션을 통한 시행착오를 거쳐 조정한 결과입니다.

# 시뮬레이션

이제 설계한 NMPC 컨트롤러를 사용하여 착륙 제어 시뮬레이션을 수행해 보겠습니다.

폐루프(closed-loop) 시뮬레이션 모델은 아래 그림과 같은 구성입니다.

<img width="800" alt="파일명" src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2525369/20729c58-c503-e3aa-f49b-c8e7eddfb1fc.png">

여기서 Landing Controller 서브시스템이 착륙 제어를 위한 컨트롤러입니다.
본 서브시스템의 내부는 아래 그림과 같이 Stateflow의 Chart 블록을 사용하여, 이벤트 드리븐 방식으로 제어 모드가 전환되는 스케줄러를 구성하고 있습니다.

<img width="800" alt="파일명" src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2525369/930037a3-bb65-5b24-7a84-6f60bfc7f004.png">

Chart 블록의 내부에서는 Simulink 서브시스템을 상태(State)로 호출하기 위한 Simulink 상태(Simulink State) 기능이 있으므로, 이를 통해 착륙 제어가 Enable(ON) 상태와 Disable(OFF) 상태일 때 출력 내용이 전환되도록 구성하고 있습니다.

[Simulink 서브시스템을 상태로 사용](https://kr.mathworks.com/help/stateflow/ug/about-simulink-states.html)

시뮬레이션에서는 로켓이 화성 대기권에 진입하여 동력 하강을 시작한 상황에서, 지정된 고도로부터 NMPC 제어에 의해 최종 착륙 페이즈로 전환하는 시나리오를 상정하고자 합니다.
이를 위해 다음과 같은 초기 조건을 부여합니다.

```matlab
% 초기 조건 (dcmbe는 자작 함수)
% Initial values
euler0 = [0 -80*pi/180 0];
% Position
px0 = 1000;py0 = -100;pz0 = -100;
% Velocity
Ve0 = [-100 0 0];           % Velocity @ inertia axis
Vb0 = dcmbe(euler0)*Ve0';   % Velocity @ body axis
u0 = Vb0(1);v0 = Vb0(2);w0 = Vb0(3);
% Attitude
phi0 = euler0(1);theta0 = euler0(2);psi0 = euler0(3);
% Angular velocity
p0 = 0;q0 = 0;r0 = 0;
```

또한 외란으로 랜덤한 돌풍을 상정합니다.
화성은 공기 밀도가 지구의 약 100분의 1로 매우 희박하지만, 연간 평균 풍속이 10[m/s]로 지구와 비교해도 높다는 것이 지금까지의 관측을 통해 밝혀졌습니다.
따라서 바람에 의한 영향이 어느 정도 발생하기 때문에 리스크를 고려한 평가가 필요합니다.

[화성의 평균 풍속](https://ja.science19.com/average-wind-speed-on-mars-4887)

이제 아래에 시뮬레이션 결과 및 그때의 애니메이션을 나타냅니다.

<img width="1000" alt="파일명" src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2525369/5890b8ca-163a-6214-31dc-e497b144522d.png">

<img width="1000" alt="파일명" src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2525369/c16f8d33-79d0-4536-0fde-a9b1d0ca587c.png">

![Untitled Project.gif](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2525369/1b62203a-b91b-6ddb-fcae-88a44130e65c.gif)


결과에서 알 수 있듯이, 처음에 기체의 큰 자세 변화를 수반하면서도 최종적으로는 양호하게 착륙 지점을 향해 선회하여 유도되고 있음을 확인할 수 있습니다.

애니메이션에는 지면에 착륙 지점을 중심으로 반경 10[m] 범위의 마킹이 그려져 있는데, 기체는 그 영역 내에서 접지하고 있으므로 매우 높은 정밀도로 제어되고 있다고 할 수 있겠습니다.
이에 더해, 애니메이션에서는 글라이드 슬로프에 의한 원뿔도 중간 고도까지 표시되어 있는데, 기체는 항상 이 범위 내에 수렴하고 있음을 확인할 수 있습니다.

트렌드에서 특히 주목할 만한 점은 질량 변화가 상당히 크게 발생하고 있다는 것입니다.
제어 시작 시 500[t]이었던 질량이 추력에 의한 연료 소비로 최종적으로는 400[t] 정도까지 감소했습니다.
약 20% 이상의 질량 변동이 발생한 계산이 되지만, NMPC는 이 변동에 대해 강인하게 제어할 수 있었습니다.

다음 애니메이션에서는 질량 변동에 따른 무게중심 위치 변화를 표시하고 있습니다.

![Untitled Project.gif](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2525369/3a869f50-e57b-eea8-9a7c-fccc28ec252f.gif)

그 외에 기상 영향으로서 돌풍 외란도 고려하고 있는데, 바람에 휩쓸리지 않고 안정적으로 제어되고 있음을 확인할 수 있습니다.
이때의 입력 결과를 살펴보면 모두 지정된 제약 범위 내에 수렴하고 있어 문제가 없습니다.

이상의 평가로부터, 이번 모델에 대해 NMPC는 우수한 제어 성능을 달성하고 있다고 결론 내릴 수 있겠습니다.

## 마치며

이번에는 로켓 착륙 제어 2편으로, 이전보다 조금 더 심화된 검토를 진행해 보았습니다.

NMPC의 예측 모델을 생성하기 위해 Symbolic Math Toolbox를 활용했는데, 기호 변수로부터 수식 정의 및 편미분 연산도 수행할 수 있어 원활하게 모델을 구축할 수 있었습니다.

여담으로, 개발이 진행 중인 Starship은 2024년 3월 14일에 3번째 궤도 발사 시험이 진행되어, 1단 로켓인 Super Heavy와 2단인 Starship의 모든 엔진이 정상적으로 연소되었으며, 예정된 궤도 도달, Super Heavy와 Starship의 분리, Super Heavy 귀환을 위한 부스트백 비행 등 다양한 마일스톤을 달성했습니다.

분리 후 Starship은 서브오비탈 비행을 계속하면서 그 사이 Raptor 엔진 재점화, 연료 이송, 페이로드 도어 개폐 등 다양한 테스트를 시도했습니다.

최종적으로 대기권 재진입을 시도했으나, 자세 제어에 문제가 발생하여 소정보다 롤 레이트가 크게 나타났고, 그 영향인지 확실하지는 않으나 재진입 시 발생하는 공력 가열에 기체가 견디지 못하고 소실되었습니다.[1][2]

재진입 과정은 기체 탑재 Starlink 단말기를 통해 라이브 중계되었으며, 마치 SF 영화 같은 장엄한 영상이 되었습니다↓

<iframe width="560" height="315" src="https://www.youtube.com/embed/ApMrILhTulI?si=eXvKOWZXXEuUwEgw" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

올해도 우주에 관한 소식이 뜨거운 한 해가 될 것 같습니다 🚀

## 참고 자료

* [1] https://news.infoseek.co.jp/article/sorae_129376/
* [2] https://news.yahoo.co.jp/articles/79bc02d101a7a7607f5d0bf6cc7c68dfbf860011?page=2