function [is_compressed] = is_compressed(e)
    
    is_compressed = isa(e.data, 'uint8');
end
    