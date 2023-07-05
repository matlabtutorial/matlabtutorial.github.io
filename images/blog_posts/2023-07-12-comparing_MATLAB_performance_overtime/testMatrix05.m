% testMatrix05.m

% n×n 크기의 대형 행렬 A=rand(n)/K를 생성할 때,
% 행렬 크기 n과 다음의 K 값과의 관계를 그래프로 나타냅니다.
% 데이터는 다음 명령을 명령창에서 입력하고 K와 n 값을 변경하면서
% 인내심을 가지고 얻은 결과를 그대로 사용합니다.
%    K=10; n=3000; disp(datestr(now,'dd-mmm-yyyy HH:MM:SS')),...
%    pause(0.5); A=rand(n)/K; disp(det(A))
% 
% 최적 K 값 Kbest    : |A| 값이 대략적으로 e+00 순서가 되는 K 값
% 허용 최소 K 값 Kmin : |A| 값이 절대로 ±Inf가 되지 않는 K 값의 하한
% 허용 최대 K 값 Kmax : |A| 값이 절대로 0 (underflow)이 되지 않는 K 값의 상한

clear all
close all

% 측정 결과 데이터 (귀중하고 중요합니다. 데이터 수집에 상당한 시간이 소요되었습니다.)
% A=rand(n)/K로 설정한 경우, 최적 K(Kbest) 및
% 하한과 상한 K(Kmin, Kmax ... MATLAB R2019a 및 다른 버전의 Kmin5, Kmax5)입니다.
n =    [100     200    300   400   500   700   1000  1500  2000  3000  4000  5000];
Kbest = [1.78    2.49   3.04  3.51  3.94  4.64  5.55  6.79  7.83  9.59  11.08 NaN];
Kmin  = [0.00153 0.0733 0.290 0.602 0.958 1.692 2.74  4.24  5.51  7.59  9.29  NaN];
Kmax  = [3039    102    36.1  22.4  17.3  13.41 11.65 11.15 11.51 11.54 11.84 NaN];
Kmin5 = [NaN     NaN    NaN   NaN   NaN   NaN   2.74  4.24  5.51  7.59  9.29  10.76];
Kmax5 = [NaN     NaN    NaN   NaN   NaN   NaN   11.65 11.15 11.34 12.27 13.33 14.36];

figure(1)
h1 = loglog(n, Kbest, 'o', 'LineWidth', 2);
hold on
grid on
xlim([50 12000])
ylim([0.9 15])
h2 = loglog([1 10000],[0.1 10]*1.75,'LineWidth',2);
h3=loglog(n,Kmin,'o-','LineWidth',1);
h4=loglog(n,Kmax,'o-','LineWidth',1);
h5=loglog(n,Kmin5,'.-','LineWidth',1,'MarkerSize',14);
h6=loglog(n,Kmax5,'.-','LineWidth',1,'MarkerSize',14);

aa=gca;
aa.GridColor='k';
aa.GridAlpha=1;
aa.MinorGridColor='k';
aa.MinorGridAlpha=0.3;
aa.MinorGridLineStyle='-';

text(32, 15.5, 'Figure 1', 'FontSize', 20);
text(60, 10^0.95, 'Kbest .... |A| 값의 지수부가 대략적으로 e+00이 되는 K');
text(60, 10^0.90, 'Kmin  .... |A| 값이 절대로 ±Inf가 되지 않는 K');
text(60, 10^0.85, 'Kmax  ... |A| 값이 0 (underflow)이 되지 않는 K');

title(['  난수 행렬 A=rand(n)/K에 대한' ...
       ' |A|을 매개변수로 한 n과 K의 관계'], 'FontSize', 11);
xlabel('행렬 크기 n (정방 행렬의 한 변)');
ylabel('K');
legend([h1 h2 h3 h4 h5 h6], ...
       {'Kbest' 'K=0.175*sqrt(n)' 'Kmin(R2019a)' 'Kmax(R2019a)'...
        'Kmin(ver5.3)' 'Kmax(ver5.3)'}, 'Location', 'southeast');