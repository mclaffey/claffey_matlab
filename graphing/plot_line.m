function [varargout] = plot_line(line_value, direction, varargin)
% Plots a vertical or horizatontal line
%
% [line_handle] = plot_line(LINE_VALUE [, DIRECTION [, LINE_PROPERTIES]])
%
%   LINE_VALUE is a required scalar to indicate the position of the line
%
%   DIRECTION can be either a string 'v' (or 'vertical') or 'h' (or 'horizontal')
%       to indicate the orientation of the line. If not specified, the line is vertical.
%
%   LINE_PROPERTIES can be a cell array of values to pass on to the standard matlab PLOT() command
%
% Example:
%
%   plot_line(0.5)
%
%       plots an up and down line the crosses the x axis at 0.5
%
%   plot_line(0.25, 'h', {'--rs','LineWidth',2})
%
%       plots a horizontal line that crosses the y axis at 0.25, with additional properties of
%       being double dashed, red and linewidth of 2
%    

% Copyright 2008 Mike Claffey (mclaffey[]ucsd.edu)
%
% 03/22/10 return line handle as output argument
% 10/23/08 improved help
% 03/23/08 original version

%% error checking

    if isempty(line_value)
        error('plot_line was provided with an empty first argument')
    elseif ~isscalar(line_value)
        error('the first argument to plot_line must be scalar value')
    end        

%% determine direction and plot    
    switch direction
        case {'', 'vertical', 'v'}
            x_data = [line_value line_value];
            y_data = get(gca, 'ylim');
        case {'horizontal', 'h'}            
            x_data = get(gca, 'xlim');
            y_data = [line_value line_value];
        otherwise
            error('direction should be either ''h'' or ''v'' in plot_line()')
    end
    
    hold on    
    line_handle = plot(x_data, y_data, varargin{:});

%% return line handle if requested    
    
    if nargout == 0
        varargout = {};
    elseif nargout == 1
        varargout = {line_handle};
    else
        error('Can not return more than one output argument');
    end
    
end
            
    
    