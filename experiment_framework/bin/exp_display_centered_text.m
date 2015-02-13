function exp_display_centered_text(edata, varargin)
% Draw a black background and display a text string in the center
%
%   exp_display_centered_text(edata, the_string)
%
% Also accepts sprintf() style arguments. Example:
%
%   exp_display_centered_text(edata, 'here is a string %s and number %d', 'my_string', 5)

% Copyright 2009 Mike Claffey
%
% 11/04/09 added documentation

    assert(ischar(varargin{1}), 'Second argument must be a string');
    screen_text = sprintf(varargin{:});
    
    exp_display_black_background(edata);
    DrawFormattedText(edata.display.index, screen_text, 'center', 'center', edata.display.colors.white);

end