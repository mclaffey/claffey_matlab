function [b] = str_block2cell(a)
% Takes a single string with line returns and converts it to a Nx1 cell of strings
%
% [b] = str_block2cell(a)
%
% Example:
%     a = sprintf('this string\nhas multiple\nlines')
%
%     a =
%     this string
%     has multiple
%     lines
%
%     str_block2cell(a)
%
%     ans = 
%         'this string'
%         'has multiple'
%         'lines'

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 05/05/09 original version

    b = textscan(a, '%s', 'Delimiter', '\n', 'Whitespace', '');
    b = b{1};
    
end
