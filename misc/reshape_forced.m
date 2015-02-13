function [b] = reshape_forced(a, dim1, dim2)
    
    original_elements = length(a(:));
    assert(~isempty(dim1) | ~isempty(dim2), 'One of the two dimensions must be specified')
    if isempty(dim1), dim1 = ceil(original_elements / dim2); end;
    if isempty(dim2), dim2 = ceil(original_elements / dim1); end;    
    total_elements = dim1 * dim2;
    
    if original_elements >= total_elements
        b = a(1:total_elements);
    elseif original_elements < total_elements
        if iscell(a)
            b = vertcat(a(:), cell(total_elements-original_elements,1));
        elseif isnumeric(a)
            b = vertcat(a(:), nan(total_elements-original_elements,1));
        else
            error('reshape_forced can''t make new elements for class %s', class(a))
        end
    end
    b = reshape(b(:), dim1, dim2);
end