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

%% Read and Decode
[fid, readMessage] = fopen(filepath, 'r', 'l');

if ~isempty(readMessage)
    error('No such file or directory')
end

sonarBuffer = {};
while ~feof(fid) % While the file is not end (help feof)
    header = headerDescription();
    
    % read the header of every message
    % help rowfun + help fread
    data = rowfun(@(dimesion, type) fread(fid, [1 dimesion], type), header, 'InputVariables', {'Dimension', 'Type'}, 'ExtractCellContent', true, 'OutputFormat', 'cell');
    data = cell2struct(data, header.Name, 1);

    % find interested message
    if data.SonarMessage == 80
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
        rawdata = fread(fid, [1, totalNumberOfIntegers], 'int16');
        sonar.SonarData = rawdata;

        buffer_.Header = data;
        buffer_.Sonar80 = sonar;
        sonarBuffer{end + 1} = buffer_;
    else
        uninterestedMessage = fread(fid, [1 data.ByteCount], 'uint8');
    end
end

save('0831_sonarMessage_80.mat', 'sonarBuffer')