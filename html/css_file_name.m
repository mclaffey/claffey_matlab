function [css_file_name_str] = css_file_name()
% Return the name of the default stylesheet
%
%   [css_file_name_str] = css_file_name()

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 04/16/09 original version

    css_file_name_str = which('css_for_matlab_display.css');
    assert(~isempty(css_file_name_str), 'Could not find css file')
    
end