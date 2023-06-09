% testMatrix07.m

% MATLAB의 행렬 계산 능력, 등고선 계산 능력 측정 결과를 그래프로 나타냅니다.

clear
close all

% 측정 결과 (testMatric03.m, testMatric06.m에 의한)
% 1열: 1:R2019a, 2:R2007b, 3:ver7.1, 4:ver5.3
% 2열: 1:행렬식, 2:행렬곱, 3:역행렬, 4:고유값, 5:등고선
% 3열: 행렬 크기, 분할 수
% 4열: 평균 처리 시간 [초]
% 5열: 최단 처리 시간 [초]
% 6열: 최장 처리 시간 [초]

% MATLAB R2019a의 측정 결과
data01=[
  1  1   100     0.00229     0.00054     0.00480
  1  1   200     0.00091     0.00078     0.00118
  1  1   400     0.00240     0.00184     0.00386
  1  1   600     0.00741     0.00340     0.01272
  1  1   800     0.01265     0.00887     0.01765
  1  1  1000     0.02539     0.01786     0.03267
  1  1  1500     0.06241     0.05843     0.07142
  1  1  2000     0.09998     0.09678     0.10558
  1  1  2500     0.16163     0.15030     0.18691
  1  1  3000     0.29388     0.25771     0.33068
  1  1  3500     0.41446     0.37204     0.44449
  1  1  4000     0.61044     0.55276     0.69935
  1  2   100     0.00130     0.00016     0.00344
  1  2   200     0.00052     0.00034     0.00070
  1  2   400     0.00303     0.00224     0.00368
  1  2   600     0.00885     0.00681     0.01207
  1  2   800     0.01956     0.01260     0.02503
  1  2  1000     0.03461     0.02382     0.03907
  1  2  1500     0.08758     0.08034     0.09270
  1  2  2000     0.19124     0.15106     0.22087
  1  2  2500     0.31125     0.28061     0.35784
  1  2  3000     0.54782     0.45339     0.62738
  1  2  3500     0.86390     0.76462     0.94933
  1  2  4000     1.20136     1.12973     1.37760
  1  3   100     0.00660     0.00052     0.02969
  1  3   200     0.00216     0.00095     0.00622
  1  3   400     0.00796     0.00570     0.01080
  1  3   600     0.01694     0.01346     0.01912
  1  3   800     0.02830     0.02311     0.03417
  1  3  1000     0.05378     0.05067     0.06332
  1  3  1500     0.13477     0.12015     0.16201
  1  3  2000     0.27424     0.26614     0.28695
  1  3  2500     0.50273     0.48888     0.51644
  1  3  3000     0.80817     0.76344     0.83770
  1  3  3500     1.35569     1.27317     1.44354
  1  3  4000     1.87069     1.83551     1.92074
  1  4   100     0.01440     0.00402     0.05400
  1  4   200     0.02349     0.02117     0.02777
  1  4   400     0.07628     0.07195     0.09006
  1  4   600     0.22723     0.21886     0.24064
  1  4   800     0.35808     0.34878     0.37077
  1  4  1000     0.57684     0.55290     0.58788
  1  4  1500     1.55741     1.53836     1.57451
  1  4  2000     3.45890     3.43195     3.53665
  1  4  2500     6.59489     6.56158     6.61371
  1  4  3000    11.66058    11.53541    11.75744
  1  4  3500    17.74509    17.57694    18.11189
  1  5   100     0.09018     0.06668     0.11260
  1  5   200     0.10157     0.09928     0.10434
  1  5   400     0.14529     0.14058     0.15164
  1  5   600     0.21915     0.21437     0.22513
  1  5   800     0.29538     0.28526     0.30494
  1  5  1000     0.41234     0.40947     0.41646
  1  5  1500     0.82213     0.81714     0.82565
  1  5  2000     1.46583     1.43961     1.52399
  1  5  2500     2.28179     2.23877     2.33725
  1  5  3000     3.25969     3.22792     3.31430
  1  5  3500     4.40113     4.34763     4.47549
  1  5  4000     5.81969     5.77652     5.92862
  1  5  4500     7.32599     7.16071     7.62689
  1  5  5000     9.38206     8.91221     9.80008];

% MATLAB R2007b의 측정 결과
data02=[
  2  1   100     0.00021     0.00016     0.00027
  2  1   200     0.00081     0.00075     0.00092
  2  1   400     0.00725     0.00558     0.00943
  2  1   600     0.01737     0.01550     0.01909
  2  1   800     0.03563     0.03304     0.03692
  2  1  1000     0.06679     0.06561     0.06792
  2  1  1500     0.21936     0.21639     0.22419
  2  1  2000     0.50645     0.50120     0.51059
  2  1  2500     0.96557     0.95803     0.97042
  2  1  3000     1.63351     1.62234     1.64124
  2  1  3500     2.55805     2.54849     2.57340
  2  1  4000     3.76943     3.75093     3.78148
  2  2   100     0.00190     0.00020     0.00796
  2  2   200     0.00191     0.00145     0.00242
  2  2   400     0.01235     0.01109     0.01380
  2  2   600     0.03692     0.03560     0.03789
  2  2   800     0.08474     0.08313     0.08558
  2  2  1000     0.16265     0.16159     0.16379
  2  2  1500     0.59976     0.52985     0.63757
  2  2  2000     1.37499     1.32621     1.43914
  2  2  2500     2.73006     2.64790     2.81836
  2  2  3000     4.24834     4.15515     4.53684
  2  2  3500     6.66432     6.59504     6.77264
  2  2  4000     9.84562     9.82265     9.88438
  2  3   100     0.00649     0.00039     0.03086
  2  3   200     0.00287     0.00238     0.00385
  2  3   400     0.01665     0.01475     0.01827
  2  3   600     0.04610     0.04334     0.04745
  2  3   800     0.10424     0.09864     0.10840
  2  3  1000     0.19463     0.19100     0.19821
  2  3  1500     0.63645     0.63124     0.64269
  2  3  2000     1.47813     1.47590     1.48018
  2  3  2500     2.90117     2.85418     3.04439
  2  3  3000     4.90081     4.88524     4.91227
  2  3  3500     7.70092     7.68362     7.72392
  2  3  4000    11.41932    11.39077    11.44221
  2  4   100     0.01035     0.00381     0.03483
  2  4   200     0.02477     0.02341     0.02847
  2  4   400     0.11796     0.11756     0.11858
  2  4   600     0.38650     0.38588     0.38752
  2  4   800     0.68896     0.67834     0.70601
  2  4  1000     1.11384     1.10799     1.12115
  2  4  1500     3.11351     3.10732     3.13447
  2  4  2000     6.76006     6.73526     6.77717
  2  4  2500    12.74787    12.69403    12.92670
  2  4  3000    20.21341    20.13866    20.28293
  2  4  3500    30.33170    30.24185    30.38879
  2  5   100     0.08335     0.04799     0.11860
  2  5   200     0.11303     0.09013     0.17929
  2  5   400     0.12802     0.11861     0.13658
  2  5   600     0.17055     0.14985     0.18171
  2  5   800     0.22761     0.19060     0.28158
  2  5  1000     0.29125     0.27005     0.30682
  2  5  1500     0.52285     0.49355     0.54245
  2  5  2000     0.84889     0.83426     0.87938
  2  5  2500     1.26317     1.22916     1.31744
  2  5  3000     1.74134     1.72806     1.75393
  2  5  3500     2.34496     2.31857     2.36714
  2  5  4000     3.03385     3.01381     3.05601
  2  5  4500     3.84646     3.79442     3.96145
  2  5  5000     4.73073     4.65457     4.78454];

% MATLAB ver7.1의 측정 결과
data03=[
  3  1   100     0.00127     0.00121     0.00141
  3  1   200     0.00643     0.00616     0.00719
  3  1   400     0.04904     0.04460     0.06494
  3  1   600     0.12576     0.12271     0.12849
  3  1   800     0.25747     0.25283     0.26485
  3  1  1000     0.47301     0.46722     0.48090
  3  1  1500     1.46980     1.42981     1.53355
  3  1  2000     3.20180     3.16059     3.23868
  3  1  2500     5.95840     5.88513     6.02364
  3  1  3000     9.73500     9.67580     9.79549
  3  1  3500    17.47936    17.22252    17.68559
  3  1  4000    22.15679    21.25188    24.53420
  3  2   100     0.09726     0.00108     0.48192
  3  2   200     0.01445     0.00691     0.04423
  3  2   400     0.07857     0.04869     0.09058
  3  2   600     0.18564     0.15302     0.22108
  3  2   800     0.37529     0.35730     0.38196
  3  2  1000     0.66245     0.64896     0.68863
  3  2  1500     2.15878     2.08352     2.25796
  3  2  2000     4.88904     4.83850     4.94647
  3  2  2500     9.76765     9.64881     9.87365
  3  2  3000    16.92031    16.30056    17.70760
  3  2  3500    29.39530    27.54045    32.75164
  3  2  4000    47.33367    46.02548    48.61029
  3  3   100     0.21919     0.00286     1.08436
  3  3   200     0.20068     0.01369     0.93799
  3  3   400     0.28501     0.13389     0.78561
  3  3   600     0.36959     0.33940     0.42750
  3  3   800     0.73782     0.71540     0.75283
  3  3  1000     1.31694     1.28087     1.37239
  3  3  1500     3.92831     3.85538     4.06811
  3  3  2000     8.72406     8.40220     9.17784
  3  3  2500    15.95907    15.91925    16.00671
  3  3  3000    26.45950    26.42847    26.52666
  3  3  3500    41.50427    41.40494    41.69957
  3  3  4000    59.58553    59.39745    59.94225
  3  4   100     0.06946     0.01901     0.25213
  3  4   200     0.16241     0.12322     0.19546
  3  4   400     1.32765     1.29709     1.34607
  3  4   600     4.61600     4.59640     4.64813
  3  4   800    10.68325    10.61664    10.75417
  3  4  1000    20.35686    20.31969    20.42164
  3  4  1500    73.34735    70.19733    76.82302
  3  4  2000   166.99092   166.53052   167.43886
  3  4  2500   407.40939   360.27411   420.39288
  3  4  3000   721.54401   720.45538   722.05789
  3  4  3500  1418.72562  1407.31936  1439.20624
  3  5   100     1.06960     0.44859     2.34288
  3  5   200     0.86968     0.55586     1.20123
  3  5   400     1.17377     0.87546     1.88831
  3  5   600     1.23008     1.18047     1.31700
  3  5   800     1.68130     1.62462     1.76356
  3  5  1000     2.26599     2.15029     2.45652
  3  5  1500     4.16328     4.12798     4.20845
  3  5  2000     6.91324     6.80712     6.98531
  3  5  2500    10.28977    10.19799    10.39823
  3  5  3000    14.76414    14.70922    14.86422
  3  5  3500    36.66370    21.48734    51.33949];

% MATLAB ver5.3의 측정 결과
data04=[
  4  1   100     0.00200     0.00000     0.01000
  4  1   200     0.01000     0.01000     0.01000
  4  1   400     0.40260     0.39000     0.41100
  4  1   600     1.45200     1.40200     1.48200
  4  1   800     3.70340     3.55500     3.79600
  4  1  1000     6.91800     6.88000     6.97000
  4  1  1500    23.64820    23.26400    24.29500
  4  1  2000    54.83040    54.60800    55.03900
  4  1  2500   107.97120   105.55200   116.42700
  4  1  3000   212.24080   184.10500   269.91800
  4  1  3500   289.54240   287.56300   291.86000
  4  1  4000   429.14680   427.20400   432.72200
  4  1  4500   619.80320   609.27600   626.07000
  4  1  5000   892.76560   848.74000  1052.77400
  4  2   100     0.00800     0.00000     0.01000
  4  2   200     0.02000     0.02000     0.02000
  4  2   400     0.74540     0.74100     0.76100
  4  2   600     2.38520     2.36300     2.43300
  4  2   800     5.87440     5.83800     5.91800
  4  2  1000    10.73340    10.65500    10.79500
  4  2  1500    34.69000    34.63000    34.74000
  4  2  2000    80.72420    80.63600    80.83700
  4  2  2500   157.97300   157.85700   158.22700
  4  2  3000   270.51480   270.32800   270.81000
  4  2  3500   427.68500   424.63000   434.55500
  4  2  4000   659.19580   647.12000   677.38400
  4  2  4500   906.63760   905.34200   909.18700
  4  3   100     0.01200     0.00000     0.03000
  4  3   200     0.03400     0.03000     0.04000
  4  3   400     0.76520     0.75100     0.78100
  4  3   600     3.31480     3.25500     3.42500
  4  3   800     7.89300     7.78100     7.99100
  4  3  1000    16.32760    15.76300    17.17400
  4  3  1500    52.63580    51.49400    53.75800
  4  3  2000   128.40840   122.53600   134.69300
  4  3  2500   239.24800   238.04200   240.15500
  4  3  3000   406.95520   406.13400   407.90600
  4  3  3500   655.38040   645.58900   677.36400
  4  3  4000   968.09220   950.82800   982.79300
  4  3  4500  1387.02240  1371.95300  1401.71500
  4  3  5000  1952.38780  1867.45500  2097.83700
  4  4   100     0.04400     0.03000     0.07000
  4  4   200     0.25040     0.25000     0.25100
  4  4   400     3.22440     3.17500     3.26500
  4  4   600    13.08700    12.91900    13.17900
  4  4   800    32.50880    32.10600    33.15800
  4  4  1000    64.41860    62.57000    69.97100
  4  4  1500   227.06860   219.56600   239.10400
  4  4  2000   537.15420   526.91700   552.50400
  4  4  2500  1460.32360  1438.17800  1493.33700
  4  4  3000  2308.87600  2297.12300  2333.61600
  4  5   100     0.63500     0.53100     0.70100
  4  5   200     0.64280     0.61100     0.69100
  4  5   400     0.94140     0.82200     1.03100
  4  5   600     1.40000     1.32200     1.50200
  4  5   800     1.93060     1.89300     1.99300
  4  5  1000     2.65980     2.60300     2.78400
  4  5  1500     5.01920     4.97700     5.09700
  4  5  2000     8.12000     8.04200     8.20200
  4  5  2500    12.34780    12.20700    12.68800
  4  5  3000    17.82580    17.60500    18.40700
  4  5  3500    24.31860    24.08400    24.71500];

DD={data01,data02,data03,data04};

for nc=[1:5]          % 각 명령에 대해 반복합니다.
  if nc==1||nc==3||nc==5
    % 그래프 용지 준비
    [hax,hsp,h_number] = make_axes_tidily ...
                    ('A4','land',[2 1],[250 75],[30 24 30 10]);
    delete(h_number);  % 불필요한 주석을 삭제합니다.
    axes(hsp(1))
    if nc==1||nc==3
      text(0,10,'MATLAB의 처리 능력 개선(행렬 크기와 처리 시간)','FontSize',16, ...
           'HorizontalAlign','center')
    else
      text(0,10,'MATLAB의 처리 능력 개선(분할 수와 처리 시간)','FontSize',16, ...
           'HorizontalAlign','center')
    end
    if nc==1
      text(-140,10,'그림 3','FontSize',20)
    elseif nc==3
      text(-140,10,'그림 4','FontSize',20)
    elseif nc==5
      text(-140,10,'그림 5','FontSize',20)
    end
    axes(hax(1))
    ax=gca;
    lincol=ax.ColorOrder;   % 표준 선 색상(7가지)을 가져옵니다.
  end

  for nv=[1:4]   % MATLAB의 각 버전에 대해 반복합니다.
    D=DD{nv};
    data=D(D(:,2)==nc,:);
    data(1,:)=[];     % 100×100은 오차가 너무 크므로 삭제합니다.
    col=lincol(nv,:);
    if nc==1||nc==2
      hf=hax(nc);
    elseif nc==3||nc==4
      hf=hax(nc-2);
    else
      hf=hax(nc-4);
    end
    [hl(nv)]=plot_data(data,col,hf);  % 선 그래프 작성 (로컬 함수 호출)
  end

  xlim([0.0001 10000])
  ylim([80 6000])
  grid on
  if nc==5
    ylabel('분할 수 (n×n의 n)')
  else
    ylabel('행렬 크기 (n×n의 n)')
  end
  aa=gca;
  aa.XAxis.FontSize=9.5;
  aa.YAxis.FontSize=9.5;
  aa.GridColor='k';
  aa.GridAlpha=1;
  aa.MinorGridColor='k';
  aa.MinorGridAlpha=0.3;
  aa.MinorGridLineStyle='-';
  aa.LabelFontSizeMultiplier=1.3;
  legend(hl,'MATLAB R2019a','MATLAB R2007b', ...
            'MATLAB ver7.1','MATLAB ver5.3','Location','southeast')
  if nc==1||nc==3
    xticklabels('')
  else
    xlabel('처리 시간 [초]')
  end
  switch nc
  case 1
    text(1.5e-4,3.5e3,'행렬식','FontSize',16);
  case 2
    text(1.5e-4,3.5e3,'행렬 곱','FontSize',16);
  case 3
    text(1.5e-4,3.5e3,'역행렬','FontSize',16);
  case 4
    text(1.5e-4,3.5e3,'고유값','FontSize',16);
  case 5
    text(1.5e-4,3.5e3,'등고선 (8단계)','FontSize',16);
  end
  if nc==5
    axes(hax(2));
    axis off;
  end
end


% =================================================

function [hl]=plot_data(data,col,hf)
  nn=data(:,3);   % 크기 (열 벡터)
  av=data(:,4);   % 평균 시간
  mn=data(:,5);   % 최단 시간
  mx=data(:,6);   % 최장 시간
  axes(hf);
  % 최단 시간과 최장 시간 그래프
  loglog(mn,nn,'.-','Color',col,'LineWidth',0.5);
  hold on
  loglog(mx,nn,'.-','Color',col,'LineWidth',0.5);
  % 최단 시간과 최장 시간으로 둘러싸인 영역을 투명하게 채움
  fill([mn;flipud(mx)],[nn;flipud(nn)],col,'FaceAlpha',0.3,'EdgeColor',col);
  % 평균 시간 그래프
  hl=loglog(av,nn,'o-','Color',col,'LineWidth',2);
end