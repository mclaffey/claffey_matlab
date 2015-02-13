function [size_e] = size(e, dim)
% Returns the size of an emg_set
%
% [emg_set_dimensions] = size(e)
%   Returns the size of the emg_set E as a 3-element array of trial_count, channel_count,
%   and average_signal_length
%
% [dimension_size] = size(E, DIM)
%   To return only one dimension of the emg_set size, provide DIM as 1 (trial_count), 2
%   (channel_count), or 3 (average_signal_length)
%
% Example:
%   size(emg_set('demo'))
%   ans =
%       10  2
%
% Due to performance issues, the 3rd dimension - average data points is not returned by the above
% format. However, it can be calculated by requesting the 3rd dimension explicitedly
%   size(emg_set('demo'), 3)
%   ans =
%       1400
%
% See-also length

% Copyright 2008 Mike Claffey (mclaffey[]ucsd.edu)

% 10/31/08 bug fix
% 10/14/08 removed third dimension (data points) from default mode to improve performance
% 09/17/08 changed third dimension to be average, rather than first, signal length
    
    if ~exist('dim', 'var'), dim = []; end;

    trial_count = size(e.data, 1);
    channel_count = size(e.data, 2);
    signal_length = NaN;

%% if explicitedly requested, calculate average num of data points    
    if ~isempty(dim) && dim == 3 && trial_count > 0 && channel_count > 0
        signal_lengths = zeros(trial_count,channel_count);
        for i = 1:trial_count
            for j = 1:channel_count
                try %#ok<TRYNC>
                    signal_lengths(i, j) = length(e.data{i,j}.data);
                end
            end
        end
        signal_length = nanmean(signal_lengths(:));
    end
    
%% return results

    if isempty(dim)
        size_e = [trial_count, channel_count];
        
    else
        size_e = [trial_count, channel_count, signal_length];
        if dim <= 3
            size_e = size_e(dim);
        else
            error('emg_sets only have 3 dimensions')
        end;
    end    
end