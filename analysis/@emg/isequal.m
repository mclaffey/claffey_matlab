function [is_equal] = isequal(e1, e2)
% Compares the data of two emg objects (ignores tags & sections)

    if isempty(e1) && isempty(e2)
        is_equal = true;
    elseif xor(isempty(e1), isempty(e2))
        is_equal = false;
    else
        is_equal = isequal(e1.data, e2.data);
    end
    
end