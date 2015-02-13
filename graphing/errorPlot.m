% errorPlot - combine errorsurface and line into an elegant plot
%
%  h = errorplot(x, y, e, [plotColor], [ebColor], [ebAlpha])
% 
%  For example,
%
%     x = 0:0.2:(2*pi);
%     y = 2.*x+randn(size(x));
%     e = 0.2.*y;
%     figure, errorPlot(x,y,e, [1 0 0], 0.5*[1 1 1])   
%
% ds 07-27-2004
function h = errorPlot(x, y, e, plotColor, ebColor, ebAlpha)

if nargin < 6
    ebAlpha = 1;
end

if nargin < 5
    ebColor = [1 1 1]*0.5;
end

if nargin < 4
    plotColor = [0 0 0];
end

hold on
es_ = errorSurface(x, y, e, ebColor, ebAlpha);
hold on
p_ = plot(x,y,'color', plotColor, 'linewidth',2);
hold off

if nargout == 1
  h = {es_, p};
end


