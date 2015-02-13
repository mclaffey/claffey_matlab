function [b] = any2cell(a)
% Convert a variety of datatypes to cell
%
%   Supported datatypes: cell, numeric matric, nominal

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 05/07/09 added support for logicals
% 04/07 original version

    switch class(a)
        case 'cell'
            b = a;
        case {'double', 'logical'}
            b = mat2cell_same_size(a);
        case 'nominal'
            b = nominal_to_cell(a);
        otherwise
            error('Unable to convert class %s to cell', class(a))
    end
end