function out = splitBuffer(in, varName, topic)
    out = zeros(1, length(in));
    for i = 1:1:length(in)
        out(:, i) = in{i}.(varName).(topic);
    end
end