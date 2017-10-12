close all; % closes all open figure windows


Y1 = [0,0.3289571702,0.2335796125,0.2563993665,0.2585656756,0.2938522785,0.3809345028]; % Throughput A/B or Fairness Index, CSMA:CA 1, Scenario A
Y2 = [0,0.9761273808,0.9734293421,0.925899101,0.923288039,0.8197300308,0.547829298]; %Throughput A/B or Fairness Index, CSMA:CA 2, Scenario A
Y3 = [0,0.7985626257,0.3744301573,0.4139054679,0.4474408753,0.4274162353,0.3628596592]; % Throughput A/B or Fairness Index, CSMA:CA 1, Scenario B
Y4 = [0,0.44453857,0.3350368194,0.2518266725,0.4087353879,0.5006991499,0.5159186066]; % Throughput A/B or Fairness Index, CSMA:CA 2, Scenario B

X = [0,50, 100, 200, 300, 400, 500]; % Lambda Values

set(0,'defaulttextinterpreter','latex'); % allows you to use latex math
set(0,'defaultlinelinewidth',2); % line width is set to 2
set(0,'DefaultLineMarkerSize',10); % marker size is set to 10
set(0,'DefaultTextFontSize', 16); % Font size is set to 16
set(0,'DefaultAxesFontSize',16); % font size for the axes is set to 16

figure(1)
%title = "Figure 1A"
plot(X, Y1, X, Y2, X, Y3, X, Y4); % plotting three curves Y1, Y2 for the same X
grid on; % grid lines on the plot
legend('CSMA Scenario A', 'CSMA Scenario A with Virtual Sensing', 'CSMA Scenario B', 'CSMA Scenario B with Virtual Sensing');
ylabel('$Fairness-Index$'); %Throughput (Kbps) or Fairness Index (N)
xlabel('$\lambda$ (frames/sec)');
