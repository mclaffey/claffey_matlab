function [b] = moving_average(a, bin_size, nonoverlapping)
% Create a moving binned average of an array
%
% b = moving_average(a, [bin_size])
%
%   Creates a vector b where each value is the binned nanmean of as many elements from vector a as
%   were specified by bin_size. Elements that are too close to the start or end of vector to allow
%   for a complete bin use truncated bins.
%
%   If bin_size is not specified, the default is 10% of the number of elements in a.
%
% [b, indices] = moving_average(a, bin_size, nonoverlapping)
%
%   If nonoverlapping is TRUE, the averages are calculated from bins of consecutive, non-overlapping
%   elements from a. all other values in b are NaN
%

%% Example indexing
% bin size = 3
%   1   2   3   4   5   6   7   8   9   10    
% start_index = ceil(bin_size/2) = ceil(3/2)=ceil(1.5)=2
% stop_index = a_length - floor(bin_size/2) = 10 - floor(3/2)=10-floor(1.5)=10-1=9
%   NaN                                 NaN
%
% bin_size = 4
%   1   2   3   4   5   6   7   8   9   10    
% start_index = ceil(bin_size/2) = ceil(4/2)=ceil(2)=2
% stop_index = a_length - floor(bin_size/2) = 10 - floor(4/2)=10-floor(2)=10-2=8
%   NaN                             NaN NaN
% backward_span = start_index-1;
% forward_span = bin_size-start_index;
 
% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 05/22/09 original version

%% Check variables    
    assert_vector(a);
    a_length = length(a);
    if ~exist('bin_size', 'var'), bin_size = round(a_length * .2); end;
    assert(bin_size > 0, 'Bin_size must be greater than 0');
    assert(bin_size < a_length, 'Bin_size must be less than the length of A');    
    b = nan(a_length,1);
    if ~exist('nonoverlapping', 'var') || nonoverlapping == false
        increment = 1;
        start_index = 1;
        stop_index = a_length;
    else
        increment = bin_size;
        start_index = ceil(bin_size/2);
        stop_index = a_length - floor(bin_size/2);
    end
    backward_span = start_index-1;
    forward_span = bin_size-start_index;
    
%% Calculate averages

    indices = start_index:increment:stop_index;
    for x = indices
        start_span = max(1, x-backward_span);
        end_span = min(a_length, x+forward_span);
        b(x)=nanmean(a(start_span:end_span));
    end
        
end