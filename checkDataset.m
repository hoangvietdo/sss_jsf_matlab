%%
clear
close
clc

%%
load 0831_sonarMessage_80.mat

%% Plot
for i = 1:1:length(sonarBuffer)
    foo = sonarBuffer{i}.Sonar80.SonarData;
    figure(1),
    plot(foo, '.')
    xlim([0 length(foo)])
    pause(0.5)
end