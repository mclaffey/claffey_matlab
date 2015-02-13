% errorSurface - error surface plot.
%
%   h_ = errorSurface(x, y, e, [surfaceColor], [surfaceAlpha])
%
%   plots color surface instead of errorbars. looks more 
%   attractive in ds's opinion. the surface covers [y-e] to [y+e], 
%   i.e. these are symmetrical errorbars. Returns the handles to
%   the graphics objects. NB! if you want to plot things on a log
%   scale you need to be clever about it (transform the data
%   yourself, define tickmarks, etc.)
%
%   x, y            - data vectors
%   e               - std/se [error]
%                       [if e is 2 x length(y), it is interpreted as
%                       [lower; upper] and the asymmetric errors
%                       are plotted
%
%   surfaceColor    - 1x3 color-vector (e.g. gray is [0.5, 0.5, 0.5])
%                       (default value is gray)
%   surfaceAlpha    - scalar alpha between 0 and 1 (sets translucence)
%                       (default value is 1)
%                     [on Apple X11, anything but 1 causes printing
%                     problems due to a ML/X11 bug]
%
%         For example,
%
%            x = 0:0.2:(2*pi);
%            y = 2.*x+randn(size(x));
%            e = 0.2.*y;
%            figure, errorSurface(x,y,e)  % errorsurface underneath
%            hold on
%            plot(x,y)  % plot line on top
%            hold off            
%
%         draws symmetric error surface of unit standard deviation.
%         See also errorPlot, dataFitPlot
%
% ds 10/26/03 - written
% ds 01/25/04 - wrote some more comments
% ds 02-11-04 - added asymmetric errorsurface [e needs to be Mx2]
function h_ = errorSurface(x, y, e, surfaceColor, surfaceAlpha)

% default surfaceColor
if (~exist('surfaceColor','var') )
    surfaceColor = [1 1 1]*0.6; 
end

% default surfaceAlpha
if (~exist('surfaceAlpha','var') )
    surfaceAlpha = 1; % default
end

% add some logic to deal with asymmetric errors
% x, y, e <-- this is assumed
% x, y, l,u <-- add stuff to deal this one

% check sizes of input
if (prod(size(x)) ~= prod(size(y))) 
 error('check the sizes of x and y - they look off! echume provlima')
end

%  prod(size(e))/2
% prod(size(y))

if  ( prod(size(y)) ~= prod(size(e)) ) & ( prod(size(y)) ~= prod(size(e))/2 ) 
 error('e must be length(Y) or length(Y)x2');
end

% check that the x/y/e are [.....] rather than [....]'
% so that fliplr works below.
% vectors needs to be 1xN 

if size(x,1) > size(x,2)
    x = x';
end

if size(y,1) > size(y,2)
    y = y';
end

if size(e,1) > size(e,2)
    e = e';
end

% make one big polygon...
%
%   <-- fliplr[x]--| y+e 
%                  |    
%   [x] ---------->| y-e

X = [ x fliplr(x) ];
if size(e,1) == 1
    Y = [y-e fliplr(y+e)];
elseif size(e,1) == 2 % asymmetric error bars
    % Y = [y-e(2,:) fliplr(y+e(1,:))]
    Y = [y-abs(e(1,:)) fliplr( y+abs(e(2,:)) )];
end  
% now use patch to make the plot...
% pp_  the handles get returned so they can be modified outside the
% function.

pp_ = fill(X,Y,surfaceColor);
% pp_ = patch(X,Y,surfaceColor);
set(pp_,'FaceAlpha', surfaceAlpha, ...
	'linestyle', 'none'); %, ...
			      %	'edgecolor', [1, 1, 1], 'edgealpha', 0)
			      % edge color and alpha are 0 by default...

if nargout == 1
  h_ = pp_;
end


return;