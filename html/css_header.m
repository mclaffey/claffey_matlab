function [css_header_text] = css_header
% Return html header text that references matlab stylesheet
%
%   [css_header_text] = css_header

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 04/16/09 original version

    css_header_text = sprintf(...
        '<head><link rel="stylesheet" type="text/css" href="%s" /></head>', ...
        css_file_name);
end