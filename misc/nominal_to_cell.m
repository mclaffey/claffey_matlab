function [b] = nominal_to_cell(a)
    assert(isa(a, 'nominal'), 'Input must be a cell');
    labels = getlabels(a);
    b = labels(double(a));
    if size(a,2)==1, b = b'; end;
end