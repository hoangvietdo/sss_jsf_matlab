%% TODO
% seperate data into 'port' and 'starboard'. Currently only acoustic data is splitted.

%%
% clear
close
clc

%%
% load 0831_sonarMessage_80_3000.mat

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
weightingFactor = splitBuffer(sonarBuffer, 'Sonar80', 'WeightingFactor');
for i = 1:1:length(sonarBuffer)
    % Scaled acoustic data
    % see equation 2-2-1
    rawData = sonarBuffer{i}.Sonar80.SonarData;
    scaledData = sonarBuffer{i}.Sonar80.SonarData * 2^(-weightingFactor(i));

    timeIdx = 1:1:length(rawData);
    if sonarBuffer{i}.Header.Channel == 0
        figure(111),
        plot(-timeIdx, scaledData, 'r','DisplayName', 'Port'); hold on;
        xlim([-length(rawData) length(rawData)])
        title('Scaled Mixed Frequency Signals')
        xlabel('Number of Data')
        ylabel('Amplitude (dB)')
        legend
        pause(0.05)
    elseif sonarBuffer{i}.Header.Channel == 1
        figure(111),
        plot(timeIdx, scaledData, 'b', 'DisplayName', 'Starboard'); hold off;
        legend
        pause(0.05)
    end
end