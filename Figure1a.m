close all; % closes all open figure windows


Y1 = [4.37E+05, 1.07E+06, 2.50E+06, 2.51E+06, 2.06E+06, 3.18E+06]; % Throughput A, CSMA:CA 1, Scenario A
Y2 = [6.56E+05, 1.07E+06, 2.70E+06, 2.91E+06, 3.35E+06, 2.69E+06]; % Throughput A, CSMA:CA 2, Scenario A

Y3 = [5.79E+05, 1.01E+06, 2.41E+06, 2.96E+06, 2.82E+06, 2.81E+06]; % Throughput A, CSMA:CA 1, Scenario B
Y4 = [2.74E+05, 6.11E+05, 1.09E+06, 1.30E+06, 2.37E+06, 2.47E+06]; % Throughput A, CSMA:CA 2, Scenario B

X = [50, 100, 200, 300, 400, 500];

set(0,'defaulttextinterpreter','latex'); % allows you to use latex math
set(0,'defaultlinelinewidth',2); % line width is set to 2
set(0,'DefaultLineMarkerSize',10); % marker size is set to 10
set(0,'DefaultTextFontSize', 16); % Font size is set to 16
set(0,'DefaultAxesFontSize',16); % font size for the axes is set to 16

figure(1)
plot(X, Y1, X, Y2, X, Y3, X, Y4); % plotting three curves Y1, Y2 for the same X
grid on; % grid lines on the plot
legend('CSMA Scenario A', 'CSMA Scenario A with Virtual Sensing', 'CSMA Scenario B', 'CSMA Scenario B with Virtual Sensing');
ylabel('$Throughput$ (Kbps)');
xlabel('$Lambda$ (frames/sec)');