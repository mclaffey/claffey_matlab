function [dups] = duplicates(a)
% Return matrix values that occur more than once
%
% Does not return NaN values, even if more than one occurs

    a = sortrows(a);
    vals = unique(a);
    counts = histc(a, vals);
    dup_idx = counts > 1;
    dups = vals(dup_idx);    
    
end