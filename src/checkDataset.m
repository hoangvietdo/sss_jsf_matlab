%% TODO
% Fix AngleScaleFactor not match with edgeTech program

%%
clear
close
clc

%%
load 0831_sonarMessage_80_3000.mat

%% Attitude (convert from EdgeTech unit to degree) - see page 11
roll = splitBuffer(sonarBuffer, 'Sonar80', 'Roll');
roll = (roll / 32768.0) * 180;
pitch = splitBuffer(sonarBuffer, 'Sonar80', 'Pitch');
pitch = (pitch / 32768.0) * 180;
heading = splitBuffer(sonarBuffer, 'Sonar80', 'CompassHeading');
heading = heading / 100;

N = length(roll);
figure(1),
subplot(311),
plot(roll);
ylabel('Roll [Deg]'); xlim([0 N])
subplot(312),
plot(pitch)
ylabel('Pitch [Deg]'); xlim([0 N])
subplot(313),
plot(heading)
ylabel('Heading [Deg]'); xlim([0 N])
xlabel('Sample Step')

%% longitude + latitude in minutes of arc; Altitude in meter
% see page 8
longitude = splitBuffer(sonarBuffer, 'Sonar80', 'X');
longitude = longitude / 10000;
latitude = splitBuffer(sonarBuffer, 'Sonar80', 'Y');
latitude = latitude / 10000;
Altitude = splitBuffer(sonarBuffer, 'Sonar80', 'Altitude');
Altitude = Altitude / 1000; % milimeter -> meter

figure(2),
subplot(311),
plot(longitude)
ylabel('Longitude [minutes]'); xlim([0 N])
subplot(312),
plot(latitude)
ylabel('Latitude [minutes]'); xlim([0 N])
subplot(313),
plot(Altitude)
ylabel('Altitude [m]'); xlim([0 N])
xlabel('Sample Step')

%% Sound Speed in m/s
soundSpeed = splitBuffer(sonarBuffer, 'Sonar80', 'SoundSpeed');

figure(3),
plot(soundSpeed)
xlabel('Sample Step'); xlim([0 N])
ylabel('Sound Speed [m/s]')

%% GNSS Speed (Knots) + Course (Degree)
% see page 12
GNSS_Speed = splitBuffer(sonarBuffer, 'Sonar80', 'NMEASpeed');
GNSS_Speed = 1/10 * GNSS_Speed; %  Knot
GNSS_Course = splitBuffer(sonarBuffer, 'Sonar80', 'NMEACourse');

figure(4),
subplot(211),
plot(GNSS_Speed)
ylabel('Speed [Knots]'); xlim([0 N])

subplot(212),
plot(GNSS_Course)
xlabel('Sample Step'); xlim([0 N])
ylabel('Course [Deg]')

%% Plot scaled acoustic data
imageMap.Port = [];
imageMap.StarBoard = [];
weightingFactor = splitBuffer(sonarBuffer, 'Sonar80', 'WeightingFactor');

figure(111),
scaledDataLeft = 0;
scaledDataRight = 0;
timeIdx = 0;
h1 = plot(-timeIdx, scaledDataLeft, 'r','DisplayName', 'Port'); hold on;
h2 = plot(timeIdx, scaledDataRight, 'b', 'DisplayName', 'Starboard');
xlim([-length(rawData) length(rawData)])
title('Scaled Mixed Frequency Signals')
xlabel('Number of Data')
ylabel('Amplitude (dB)')
legend

for i = 1:1:length(sonarBuffer)
    % Scaled acoustic data
    % see equation 2-2-1
    rawData = sonarBuffer{i}.Sonar80.SonarData;
    scaledData = sonarBuffer{i}.Sonar80.SonarData * 2^(-weightingFactor(i));
    timeIdx = 1:1:length(rawData);

    if length(scaledData) == 3472
        if sonarBuffer{i}.Header.Channel == 0
            imageMap.Port(:, end + 1) = scaledData;
        elseif sonarBuffer{i}.Header.Channel == 1
            imageMap.StarBoard(:, end + 1) = scaledData;
        end
    end

    if sonarBuffer{i}.Header.Channel == 0
        set(h1,'YData', scaledData, 'XData', timeIdx);
        drawnow();
        pause(0.05)
    elseif sonarBuffer{i}.Header.Channel == 1
        set(h2,'YData', scaledData, 'XData', -timeIdx);
        drawnow();
        pause(0.05)
    end
end

%% Plot sonar image
figure(555),
imagesc(imageMap.Port); colormap('gray');
figure(666),
imagesc(imageMap.StarBoard); colormap('gray');

% to_display = 0 * imageMap.Port;
% figure(555);
% imagesc(to_display); colormap('gray')
% drawnow();
% for row = 1 : size(imageMap.Port, 1)
%   to_display(row,:) = imageMap.Port(row,:);
%   imagesc(to_display)
%   drawnow();
% end

%% Type 3000
% sonarRange = {};
% for i = 1:1:length(bath3000Buffer)
%     foo = bath3000Buffer{i}.Bath3000;
%     asd(i) = foo.AngleScaleFactor;
%     foo_ = bath3000Buffer{i}.Bath3000.Bathymetric;
%     channel = foo.Channel;
%     for j = 1:1:length(foo_)
%         % see eq. 2-2
%         sonarRange{i}.echoTime(j) = ((foo.TimeToFirstSample / 1e9) + (foo_{j}.TimeDelay * foo.TimeScaleFactor));
%         sonarRange{i}.slantRange(j) = (soundSpeed(1) / 2) * echoTime;
% %         figure(888),
% %         plot(1:1:400,sonarRange{i}.slantRange(j),'b.')
% %         sonarRange{i}.AngleFromNadir(j) = (-1)^(channel + 1) * foo_{j}.Angle * foo.AngleScaleFactor;
% %         sonarRange{i}.X(j) = sonarRange{i}.slantRange(j) * sin(sonarRange{i}.AngleFromNadir(j));
% %         sonarRange{i}.Z(j) = sonarRange{i}.slantRange(j) * cos(sonarRange{i}.AngleFromNadir(j));
%     end
% end
