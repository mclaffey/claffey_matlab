function [is_equal_boolean] = isequal(e1, e2)
    
    if isempty(e1)
        is_equal_boolean = isempty(e2);
    else
        if ~isa(e2, 'emg_set')
            is_equal_boolean = false;
        else
            is_equal_boolean = isequalwithequalnans(e1.data, e2.data);
        end
    end
    
end