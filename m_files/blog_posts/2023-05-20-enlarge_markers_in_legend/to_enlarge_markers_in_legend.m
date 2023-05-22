clear; close all; clc;

rng(1)

figure;
h1 = plot(1:10, rand(1,10), 'o', 'markerfacecolor', [0, 0.447, 0.741]);
hold on;
h2 = plot(1:10, rand(1,10), 'o', 'markerfacecolor', [0.85, 0.325, 0.098]);
h3 = plot(1:10, rand(1,10), 'o', 'markerfacecolor', [0.929, 0.694, 0.125]);

h = [h1, h2, h3];

[~, icons] = legend(h,'LGD 1', 'LGD 2', 'LGD 3');

% Type은 line이면서 Marker는 없지는 않는 것을 찾아야 함!
icons = findobj(icons,'Type','line','-not','Marker','none'); 

set(icons, 'Markersize',12)