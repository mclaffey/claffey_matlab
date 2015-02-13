function [value_frequency_table] = freq_table(x, bin_width)
% Returns the frequency count of values in a vector (table version of histc)
%
%   [value_frequency_table] = freq_table(x, bin_width)

% Copyright 2010 Mike Claffey (mclaffey [] ucsd.edu)
%
% 03/21/10 original version

    if ~exist('bin_width', 'var'), bin_width = 1; end;
    
    % make x a verticl vector
    x = assert_vector(x, 1);

    % run histc
    hist_edges = [min(x):bin_width:max(x) inf];
    [n,bin]=histc(x, hist_edges);
    
    % list only non-empty bins in table form
    non_empty_bin_logical = n~=0;
    non_empty_bin_labels = hist_edges(non_empty_bin_logical);
    non_empty_bin_counts = n(non_empty_bin_logical);
    value_frequency_table = [non_empty_bin_labels', non_empty_bin_counts];
end
