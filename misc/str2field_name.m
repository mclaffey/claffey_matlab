function [b] = str2field_name(a)
% Makes necessary changes to a string so it can be used as a field name
%
% [b] = str2field_name(a)

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 04/14 original version

    b = a;
    
    % replace punctuation
    chars_to_replace_with_underscores = ' !@#$%^&*()-=+\|<>,.?/;:"';
    for x = 1:length(chars_to_replace_with_underscores);
        b = strrep(b, chars_to_replace_with_underscores(x), '_');
    end
    
    % get rid of multiple underscores in a row
    while findstr(b, '__')
        b = strrep(b, '__', '_');
    end
    
    % if string starts with a number, prepend an 'x'
    if strfind(b(1), '1234567890')
        b = ['x', b];
    end

end