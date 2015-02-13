function [x] = round_decimal(x, decimal_places)
% Round a variable to a given number of decimal places
%
% [x] = round_decimal(x, decimal_places)
%
% If x is a structure, round_decimal recursively rounds each field field.

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 07/30/09 added documentation
%          added functionality to round fields of a structure


    if isstruct(x)
        field_names = fieldnames(x);
        for field_num = 1:length(field_names)
            field_name = field_names{field_num};
            if isnumeric(x.(field_name)) || isstruct(x.(field_name))
                x.(field_name) = round_decimal(x.(field_name), decimal_places);
            end
        end
        
    elseif isnan(x)
        return;
    
    elseif isnumeric(x)
        x = round(x * 10^decimal_places) / 10^decimal_places;
        
    else
        error('Unrecognized type %s', class(x));
    end
    
end