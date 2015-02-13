function [ data, dData, minmax, stats ] = Analyze3dfmDna( file, scales, thresholds, timestep, startTime, endTime, tranRad )
% [ data, dData, minmax, stats ] = Analyze3dfmDna( file, scales,
% thresholds, timestep, startTime, endTime, tranRad )  
% Analyzes 3DFM position data using multiscale analysis.  Finds
% discontinuities (edges) in the position data.
% Input:
%   file        A string specifying a file name containing only 3dfm
%               position data
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
%   data        Position data, extracted from the input file
%   dData       Position data derivative scale space
%   minmax      A vector that indicates minima and maxima within the data
%   stats       A table of mean and standard deviations for each region

% Load the data
data = load(file);
data = data(:,[5]);            % position data is in 5th column
% data = data(100000:300000);    % so much data...better cut down a little

if (nargin >= 7)
    [dData, minmax, stats] = AnalyzeEdges(data, scales, thresholds, timestep, startTime, endTime, tranRad);
elseif (nargin == 6)
    [dData, minmax, stats] = AnalyzeEdges(data, scales, thresholds, timestep, startTime, endTime);
elseif (nargin == 5)
    [dData, minmax, stats] = AnalyzeEdges(data, scales, thresholds, timestep, startTime);
elseif (nargin == 4)
    [dData, minmax, stats] = AnalyzeEdges(data, scales, thresholds, timestep);
elseif (nargin == 3)
    [dData, minmax, stats] = AnalyzeEdges(data, scales, thresholds);
elseif (nargin == 2)
    [dData, minmax, stats] = AnalyzeEdges(data, scales);
else
    [dData, minmax, stats] = AnalyzeEdges(data);
end