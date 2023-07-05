% testMatrix06.m

% MATLAB의 등고선 그리기 능력 측정
% "데이터 수집용 프로그램"

clear
close all

testrep=5;     % 테스트 반복 횟수
thisfile='testMatrix06.m';

% ■■■ 선택 필요 ■■■ ==========================
% 테스트할 MATLAB 버전을 번호로 선택

mat_ver=1;   % 1: R2019a, 2: R2007b, 3: MATLAB7.1, 4: MATLAB5.3

% ===============================================

switch mat_ver
case 1
  mat_name='R2019a';
case 2
  mat_name='R2007b';
case 3
  mat_name='ver7.1';
case 4
  mat_name='ver5.3';
end

% 평가할 분할 수의 목록
% R2019a용
nd1=[1 2 4 6 8 [10:5:50]]*100;  % n=5500은 확인하지 않음
% R2007b용
nd2=[1 2 4 6 8 [10:5:50]]*100;  % n=5500은 확인하지 않음
% MATLAB7.1용
nd3=[1 2 4 6 8 [10:5:35]]*100;  % n=4000에서 이상 동작
% MATLAB5.3용
nd4=[1 2 4 6 8 [10:5:35]]*100;  % n=4000에서 이상 동작

nD={ nd1 nd2 nd3 nd4 };

% 데이터 기록용 변수
div_vs_time=[];

% 중간에 프리즈되어도 데이터가 유지되도록 파일에도 순차적으로 기록
% 그것을 위한 파일 준비
Date=datestr(now,'dd-mmm-yyyy HH:MM:SS');
Date=strrep(strrep(strrep(Date,'-','_'),':','_'),' ','_');
fid=fopen(['xx_div_vs_time_' Date '.txt'],'w+');
fprintf(fid,['xx_div_vs_time_' Date '.txt']);
fprintf(fid,'\n');
fprintf(fid,'Ver Com  Div    Time_ave    Time_min    Time_max');
fprintf(fid,'\n');
fclose(fid);

com=5;            % 테스트할 명령어 종류
                  % 5:contour
com_name='등고선';
ndiv=nD{mat_ver};         % 분할 수 목록

for nd=ndiv;              % 각각의 분할 수에 대해 반복
  x=linspace(-1,1,nd+1);  % -1부터 1까지를 nd분할한다.
  y=x;
  [X,Y]=meshgrid(x,y);    % x,y 평면을 nd×nd로 분할한 메쉬
  Z=X.^2.*(1-X.^2)-Y.^2;  % 곡면 Z(X,Y)
  timedata=[];            % 매번 연산 실행 시간을 기록하는 행 벡터
  for ne=1:testrep        % 변동성의 평균화를 위한 반복 처리
    tic;                  % 시간 측정 시작
    [dc,hc]=contour(X,Y,Z,[-0.5:0.1:0.2]);   % 등고선 계산
    te=toc;               % 소요 시간 기록

    % 실행 시간의 경향을 시각적으로 확인하기 위해 매번 콘솔에 출력
    disp([mat_name '　　' com_name '　　' ...
          sprintf('%4s',num2str(nd)) '×' ...
          sprintf('%4s',num2str(nd)) ...
          '　　처리 시간 ' num2str(te) ' 초'])

    timedata=[timedata te];     % 매번 실행 시간을 모두 기록

    drawnow;                    % 그림 그리기 유도
    pause(2);                   % 그림 결과를 확인하기 위해 2초간만 표시
    close all;                  % 첫 번째 그림과 조건 맞춤을 위해
  end

  % 반복 실행의 결과로부터 평균, 최단, 최장 시간을 계산하고 출력
  t_ave=sum(timedata)/testrep;  % 평균 시간
  t_min=min(timedata);          % 최단 시간
  t_max=max(timedata);          % 최장 시간
  disp('　')
  disp(['　　평균 시간：' num2str(t_ave,'%11.5f') ...
        '　　최단 시간：' num2str(t_min,'%11.5f') ...
        '　　최장 시간：' num2str(t_max,'%11.5f')]);
  disp('　')

  % 데이터 기록용 변수에 측정 결과 추가
  % (MATLAB 버전, 명령어, 분할 수, 여러 시간)
  div_vs_time=[div_vs_time; ...
                mat_ver  com  nd  t_ave  t_min  t_max];

  % 중간에 프리즈되어도 데이터가 유지되도록 파일에도 순차적으로 기록
  % ver5.3에서는 모호하게 '%d'로는 불가능. 자릿수를 명시하지 않으면 오류.
  fid=fopen(['xx_div_vs_time_' Date '.txt'],'a');
  fprintf(fid,'%3s',num2str(mat_ver,'%1d'));
  fprintf(fid,'%3s',num2str(com,'%1d'));
  fprintf(fid,'%6s',num2str(nd,'%4d'));
  fprintf(fid,'%12s',num2str(t_ave,'%11.5f'));
  fprintf(fid,'%12s',num2str(t_min,'%11.5f'));
  fprintf(fid,'%12s',num2str(t_max,'%11.5f'));
  fprintf(fid,'\n');
  fclose(fid);

end

% 측정결과를 커맨드 라인에 문자 부호로 찍어내기
disp(datestr(now,'dd-mmm-yyyy HH:MM:SS'));
disp( ['  created by ' thisfile ' on ' mat_name]);
disp('Ver Com  Div    Time_ave    Time_min    Time_max');
B=div_vs_time;
for n=1:size(B,1)
  disp([sprintf('%3s',num2str(B(n,1),'%1d')) ...
        sprintf('%3s',num2str(B(n,2),'%1d')) ...
        sprintf('%6s',num2str(B(n,3),'%4d')) ...
        sprintf('%12s',num2str(B(n,4),'%11.5f')) ...
        sprintf('%12s',num2str(B(n,5),'%11.5f')) ...
        sprintf('%12s',num2str(B(n,6),'%11.5f'))])
end