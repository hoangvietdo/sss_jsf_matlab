function header = headerDescription()
    % Reference: section 2.1

    header = cell2table({ ...
            'StartOfMessage'   1      'uint16'
            'Version'          1      'uint8'
            'SessionId'        1      'uint8'
            'SonarMessage'     1      'uint16'
            'SonarCommand'     1      'uint8'
            'SubSystem'        1      'uint8'
            'Channel'          1      'uint8'
            'Sequence'         1      'uint8'
            'ReservedHeader'   1      'uint16'
            'ByteCount'        1      'uint32'
            }, 'VariableNames', {'Name', 'Dimension', 'Type'});
end