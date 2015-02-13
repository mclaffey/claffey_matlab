function [b] = any2str(a)
% Convert any variable to a string    

% Copyright 2008-2010 Mike Claffey
%
% 04/26/10 added handling of logicals with more than one element
% 10/09/09 added handling of ordinals
% 08/10/09 unknown classes return a string indicating class, instead of a terminating error
% 05/19/09 handle structures, better handling of large matrices
% 04/14/09 added handling of function_wrapper
% 11/22/08 misc improvements

    if ischar(a)
        b = a;
    elseif isempty(a)
        b = '';
    elseif iscell(a)
        if length(a) == 1
            b = any2str(a{1});
        else
            b = cellfun(@any2str, a, 'UniformOutput', false);
        end
    elseif isnumeric(a)
        if ndims(a) > 2
            b = sprintf('[%s]', mat2str(size(a)));
        elseif numel(a) <= 9
            b = num2str(a);
        else
            abbrev_rows = 1:min(3, size(a,1));
            abbrev_cols = 1:min(3, size(a,2));
            b = sprintf('Abbrv [%s]: %s', num2str(size(a)), num2str(a(abbrev_rows,abbrev_cols)));
        end
    elseif islogical(a);
        if numel(a) == 1
            if a, b = 'true'; else b = 'false'; end;
        else
            b = sprintf('Logical [%s]', num2str(size(a)));
        end
    else
        switch class(a)
            case {'nominal', 'ordinal'}
                b = char(a);
            case 'function_wrapper'
                b = sprintf('function wrapper: %s', a.function);
            case 'struct'
                b = sprintf('structure %d fields', length(fieldnames(a)));
            otherwise
                try
                    b = str(a);
                catch
                    b = sprintf('any2str(class: %s) not supported', class(a));
                end
        end
    end
end    
    