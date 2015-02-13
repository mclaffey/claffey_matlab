function [ stats ] = RegionStats( data, regionIdx, radius )
% [ stats ] = RegionStats( data, regionIdx )
% Finds statistics for data broken up into distinct regions.
% Input:
%   data        The data to analyze
%   regionIdx   The indices that demarcate distinct data regions
%   radius      The radius of transition regions (data within transition  
%               regions is excluded from statistics)

if (nargin < 3)
    radius = 1;
end

region = 1:regionIdx(1)-radius;
stats(1, :) = [mean(data(region)), std(data(region))];
for i = 2:length(regionIdx)
    region = regionIdx(i-1)+radius:regionIdx(i)-radius;
    stats(i, :) = [mean(data(region)), std(data(region))];
end
region = regionIdx(end)+radius:length(data);
stats(end+1, :) = [mean(data(region)), std(data(region))];
