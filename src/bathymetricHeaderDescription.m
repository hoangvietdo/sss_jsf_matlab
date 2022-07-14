function bathymetricHeader = bathymetricHeaderDescription(type)
    
    switch type
        case '3000'
            % Reference: section 2.5.1.1
            % Count = 27 (sum of all dimension)
            bathymetricHeader = cell2table({...
                'TimeSince1970'             1   'uint32'
                'Nanosecond'                1   'uint32'
                'Ping'                      1   'uint32'
                'NumberOfSample'            1   'uint16'
                'Channel'                   1   'int8'
                'AlgorithmType'             1   'int8'
                'NumberOfPulse'             1   'int8'
                'PulsePhase'                1   'int8'
                'PulseLength'               1   'uint16'
                'TransmitPulse'             1   'float'
                'StartFreq'                 1   'float'
                'EndFreq'                   1   'float'
                'MixedFreq'                 1   'float'
                'SampleRate'                1   'float'
                'TimeToFirstSample'         1   'uint32'
                'TimeDelayUncertainty'      1   'float'
                'TimeScaleFactor'           1   'float'
                'TimeScaleAccuracy'         1   'float'
                'AngleScaleFactor'          1   'uint32'
                'Reserved0'                 1   'uint32'
                'TimeToFirstBottomReturn'   1   'uint32'
                'FormatLevel'               1   'int8'
                'BinningFlag'               1   'int8'
                'TVG'                       1   'int8'
                'Reserved1'                 1   'int8'
                'Span'                      1   'float'
                'Bin'                       1   'float'
            }, 'VariableNames', {'Name', 'Dimension', 'Type'});
        case '3000Sub'
            % Reference: section 2.5.1.3
            % Count =  (sum of all dimension)
            bathymetricHeader = cell2table({ ...
                'TimeDelay'             1   'uint16'
                'Angle'                 1   'int16'
                'Amplitude'             1   'int8'
                'AngleUncertainty'      1   'int8'
                'Flag'                  1   'int8'
                'SNR'                   1   'ubit5'
                'Quality'               1   'ubit3'
                }, 'VariableNames', {'Name', 'Dimension', 'Type'});
        case '3002'
            % Reference: section 2.5.3
            % Count =  (sum of all dimension)
            bathymetricHeader = cell2table({ ...
                'TimeSince1970'         1   'uint32'
                'Nanosecond'            1   'uint32'
                'ValidFlag'             1   'uint32'
                'AbsolutePressure'      1   'float'
                'WaterTemp'             1   'float'
                'Salinity'              1   'float'
                'Conductivity'          1   'float'
                'SoundVelocity'         1   'float'
                'Depth'                 1   'float'
                }, 'VariableNames', {'Name', 'Dimension', 'Type'});
    end
end
