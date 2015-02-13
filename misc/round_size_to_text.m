function [size_text] = round_size_to_text(size_value_in_bytes)
% Rounds a size in bytes to a text string
%
% [size_text] = round_size_to_text(size_value_in_bytes)

% Copyright 2009 Mike Claffey mclaffey[]ucsd.edu
%
% 03/18/09 original version
    
    if size_value_in_bytes < 1000
        size_text = sprintf('%d bytes', round(size_value_in_bytes));
    elseif size_value_in_bytes < 1000 * 1000
        size_text = sprintf('%1.1f KB', size_value_in_bytes / 1000);
    else
        size_text = sprintf('%1.1f MB', size_value_in_bytes / 1000 / 1000);
    end
    
end
