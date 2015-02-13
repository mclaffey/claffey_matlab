function [ dData, minmax, stats ] = AnalyzeEdges( data, scales, thresholds, timestep, startTime, endTime, tranRad )
% [ dData, minmax, stats ] = AnalyzeEdges( data, scales,
% thresholds, timestep, startTime, endTime, tranRad )
% Analyzes 1D data using multiscale analysis.  Finds distinct transition
% regions and transition ratios.
% Input:
%   data        The 1D data
%   scales      A list of scales at which to perform analysis
%   threshold   A list of numbers between 0 and 1 indicating how obvious a
%               step has to be at each scale in order to be considered a
%               transition
%   timestep    The amount of time that one data point represents
%   startTime   The time at which to start analysis
%   endTime     The time at which to end analysis
%   tranRad     The number of samples to ignore on either side of a
%               transition point when calculating region statistics
% Output:
%   dData       Data derivative scale space
%   minmax      A vector that indicates minima and maxima within the data
%   stats       A table of mean and standard deviations for each distinct
%               data region

% defaults
if (nargin < 7)
    tranRad = 1;
end
if (nargin < 6)
    endTime = 10;
end
if (nargin < 5)
    startTime = 0;
end

% time scale
if (nargin < 4)
    timestep = 1;
    format = '%5d\t%5.2f\t%5.2f';
else
    format = '%5.2f\t%5.2f\t%5.2f';
end

if (nargin < 3)
    thresholds = [.1, .2, .3, .4];
end
if (nargin < 2)
    scales = [1, 2, 4, 8];
end

% Limit analysis to time region specified
if (nargin < 4)         % no time data specified
    time = 1:length(data);
elseif (nargin < 5)     % scale specified, but no range
    time = 0:timestep:(length(data)-1)*timestep;
elseif (nargin < 6)     % scale and start time specified
    data = data((startTime/timestep)+1:end);
    time = startTime:timestep:(length(data)-1)*timestep + startTime;
else                    % scale and region specified
    data = data((startTime/timestep)+1:(endTime/timestep)+1);
    time = startTime:timestep:(length(data)-1)*timestep + startTime;
end

% Create the derivative scale space--minima and maxima of the derivative
% correspond to transitions
dData = CreateGaussScaleSpace(data, 1, scales);

% Find the position of local minima and maxima of the most coarse scale
minmax = FindLocalExtrema(dData(:, end), thresholds(end), scales(end));
minmaxIdx = find(minmax);

% Refine min/max positions through scale space
for i = size(scales)-1:-1:1
    minmax = FindLocalExtrema(dData(:,i), thresholds(i), scales(i), minmaxIdx);
    minmaxIdx = find(minmax);
end

% Find the data statistics in each region
stats = RegionStats(data, minmaxIdx, tranRad);

% Display the derivative scale space as an image
figure;
imagesc(dData);
colormap bone;

% Plot final transitions over most coarse derivative
figure;
plot(dData(:,end));
hold on;
plot(0.5 * minmax * max(dData(:,end)), 'r');
hold off;

% Plot detected transitions over original data
figure;
plot(data);
hold on;
plot(1.0 * minmax * max(data(:,end)), 'r');
hold off;

% Print region statistics
disp(sprintf(' Time\t Mean\t Stdv'))
for i = 1:length(minmaxIdx);
    disp(sprintf(format, time(minmaxIdx(i)), stats(i,1), stats(i,2)));
end
disp(sprintf(format, time(length(data)), stats(end,1), stats(end,2)));
