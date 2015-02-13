function [b] = mat2cell_same_size(a)
% Convert a matrix to a cell of the same dimensions

    b = mat2cell(a, ones(size(a, 1), 1), ones(size(a, 2), 1));
end    
    