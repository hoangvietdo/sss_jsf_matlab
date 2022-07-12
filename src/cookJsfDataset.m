%% License: intelligent Navigation and Control System Laboratory (iNCLS) - Sejong University
%  Author : Viet
%  e-Mail : hoangvietdo@sju.ac.kr
%  Date :

%% TODO
% Add more message since only message 80 is decoded

%%
clear
clc
close 

%% File Path
path = "D:\PC-AUV 센서 데이터 샘플자료\SSS_해저맵핑소나";
file = "615530003_0831_Binned";
filepath = path + "\" + file + ".jsf";

%% Options
type80 = 1;
type3000 = 0;

%% Read and Decode
[fid, readMessage] = fopen(filepath, 'r', 'l');

if ~isempty(readMessage)
    error('No such file or directory')
end

sonarBuffer = {};
bath3000Buffer = {};

while ~feof(fid) % While the file is not end (help feof)
    header = headerDescription();
    
    % read the header of every message
    % help rowfun + help fread
    data = rowfun(@(dimesion, type) fread(fid, [1 dimesion], type), header, 'InputVariables', {'Dimension', 'Type'}, 'ExtractCellContent', true, 'OutputFormat', 'cell');
    data = cell2struct(data, header.Name, 1);

    % find interested message
    if data.SonarMessage == 80 && type80 == 1
        sonarHeader = sonarHeaderDescription();
        sonar = rowfun(@(dimesion, type) fread(fid, [1 dimesion], type), sonarHeader, 'InputVariables', {'Dimension', 'Type'}, 'ExtractCellContent', true, 'OutputFormat', 'cell');
        sonar = cell2struct(sonar, sonarHeader.Name, 1);

        % see Data Format Byte offset 34-35
        % see also "Sonar trace data" in page 13
        % total bytes of data 
        totalNumberOfIntegers = sonar.Sample * (sonar.DataFormat + 1);
        if totalNumberOfIntegers * 2 + 240 ~= data.ByteCount
            error('Acoustic data size is wrong')
        end

        % Unscaled acoustic data
        sonar.SonarData = fread(fid, [1, totalNumberOfIntegers], 'int16');

        buffer_.Header = data;
        buffer_.Sonar80 = sonar;
        sonarBuffer{end + 1} = buffer_;

    elseif data.SonarMessage == 3000 && type3000 == 1
        bath3000Header = bathymetricHeaderDescription('3000');
        bath3000 = rowfun(@(dimesion, type) fread(fid, [1 dimesion], type), bath3000Header, 'InputVariables', {'Dimension', 'Type'}, 'ExtractCellContent', true, 'OutputFormat', 'cell');
        bath3000 = cell2struct(bath3000, bath3000Header.Name, 1);
        
        bath3000SubHeader = bathymetricHeaderDescription('3000Sub');
        numberOfSamples = bath3000.NumberOfSample;
        for i = 1:1:numberOfSamples
            bath3000.bathymetric{i} = rowfun(@(dimesion, type) fread(fid, [1 dimesion], type), bath3000SubHeader, 'InputVariables', {'Dimension', 'Type'}, 'ExtractCellContent', true, 'OutputFormat', 'cell');
            bath3000.bathymetric{i} = cell2struct(bath3000.bathymetric{i}, bath3000SubHeader.Name, 1);
        end

        buffer3000_.Header = data;
        buffer3000_.bath3000 = bath3000;
        bath3000Buffer{end + 1} = buffer3000_;
    else
        uninterestedMessage = fread(fid, [1 data.ByteCount], 'uint8');
    end
end

if type80 == 1 && type3000 == 0
    save('0831_sonarMessage_80.mat', 'sonarBuffer')
elseif type80 == 1 && type3000 == 1
    save('0831_sonarMessage_80_3000.mat', 'sonarBuffer', 'bath3000Buffer', '-v7.3')
end