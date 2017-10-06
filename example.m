close all; 
set(0,'defaulttextinterpreter','latex'); % allows you to use latex math
set(0,'defaultlinelinewidth',2); % line width is set to 2
set(0,'DefaultLineMarkerSize',10); % marker size is set to 10
set(0,'DefaultTextFontSize', 16); % Font size is set to 16
set(0,'DefaultAxesFontSize',16); % font size for the axes is set to 16
plot(X, Y1, '-bo', X, Y2, '{rs', X);
grid on; % grid lines on the plot
legend('CSMA', 'CSMA w. virtual Sensing');
ylabel('$T$ (Kbps)');
xlabel('$delta$ (frames/sec)');