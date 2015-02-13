function [b, keep_index] = trim_mat(a, trim_percent)
% Trims off the highest and lowest percent of values from an array
%
% [B, KEEP_INDEX] = trim_mat(A, TRIM_PERCENT)
%
%   TRIM_PERCENT is a scalar (0-100) of the percent of total elements to remove, so TRIM_PERCENT / 2
%       is removed from both the highest and lowest tails. Note that when calculating how many
%       elements to trim, fractions of elements will be rounded up (actuall trim percent will be
%       higher tha TRIM_PRECENT)
%   KEEP_INDEX is a logical array of which elements were kept
%
% Example:
%   data = randn(10,1)
%   [trimmed_data, keep_index] = trim_mat(data, 20)
%   trimmed_elements = find(~keep_index)
%
% See also dataset_trim, pctile

% Copyright 2008 Mike Claffey (mclaffey[]ucsd.edu)

% 10/27/08 rewrote to fix how matrices with many equal values in the tails were handled
% 09/11/08 original version

    
    if trim_percent > 100 || trim_percent < 0, error('trim_percent must be between 0 and 100'); end;
    if ~isvector(a), error('matrix a must be 1-dimensional'); end;
    trim_count_each_side = ceil(trim_percent / 100 /2 * length(a));
    if length(a) - trim_count_each_side * 2 < 1
        error('Array passed to trim_mean has too few values (%d) to trim', length(a))
    end
    
%% create an index of which values will be kept    
    keep_index = (1+trim_count_each_side):(length(a)-trim_count_each_side);    
    
%% return the trimmed values in sorted order    
    [sorted_a, sorted_idx] = sort(a);
    b = sorted_a(keep_index);
    
%% create a logical of which values were kept
    keep_logicals = zeros(length(a),1);
    keep_logicals(sorted_idx(keep_index)) = 1;
    keep_index = logical(keep_logicals);
    
end