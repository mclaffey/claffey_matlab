function [b] = nonan(a)
% Return array without nan values
    b = a;
    b(isnan(b))=[];
end