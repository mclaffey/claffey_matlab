function [b] = repeat_rows_to_total(a, row_total)
% Repeats an array vetically to reach the specified number of rows
%
%   [b] = repeat_rows_to_total(a, row_total)

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 04/23/09 original version

    needed_replications = row_total / size(a, 1);
    if mod(needed_replications, 1) ~= 0
        error('Row total (%d) is not a multiple of current row count (%d)', ...
            row_total, size(a, 1));
    end;
    b = repmat(a, needed_replications, 1);

end