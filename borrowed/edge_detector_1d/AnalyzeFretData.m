function [ fret, dFret, minmax, stats ] = AnalyzeFretData( file, scales, thresholds, timestep, startTime, endTime, tranRad )
% [ fret, dFret, minmax, stats ] = AnalyzeFretData( file, scales,
% thresholds, timestep, startTime, endTime, tranRad )
% Analyzes FRET data using multiscale analysis.  Finds distinct FRET
% regions and transition ratios.
% Input:
%   file        A string specifying a file name containing only FRET data
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
%   fret        FRET data, computed from the input file
%   dFret       FRET data derivative scale space
%   minmax      A vector that indicates minima and maxima within the data
%   stats       A table of mean and standard deviations for each distinct
%               FRET region


% Load the data
[fret, raw] = LoadFretData(file);

if (nargin >= 7)
    [dFret, minmax, stats] = AnalyzeEdges(fret, scales, thresholds, timestep, startTime, endTime, tranRad);
elseif (nargin == 6)
    [dFret, minmax, stats] = AnalyzeEdges(fret, scales, thresholds, timestep, startTime, endTime);
elseif (nargin == 5)
    [dFret, minmax, stats] = AnalyzeEdges(fret, scales, thresholds, timestep, startTime);
elseif (nargin == 4)
    [dFret, minmax, stats] = AnalyzeEdges(fret, scales, thresholds, timestep);
elseif (nargin == 3)
    [dFret, minmax, stats] = AnalyzeEdges(fret, scales, thresholds);
elseif (nargin == 2)
    [dFret, minmax, stats] = AnalyzeEdges(fret, scales);
else
    [dFret, minmax, stats] = AnalyzeEdges(fret);
end