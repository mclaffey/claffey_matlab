function [b] = dataset_obsnames(a, col_names)
% Assign observation names based on values merged from one or more columns
%
%   [b] = dataset_obsnames(a, col_names)
%
% Calling without col_names clears the observeraion names completely
%
%   [b] = dataset_obsnames(a)
%
% Example:
%
% [trial_stats] = dateset_obsnames(trial_stats, {'block', 'foreknowledge'});
%

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 11/18/09  added clear observation capability
% 07/13/09 added documentation
% 04/01/09 orignal version

    % if no col_names, provided clear observations
    if ~exist('col_names', 'var') || isempty(col_names)
        b = set(a, 'ObsNames', {});
        
    % othewise set based on col_names
    else
        if ischar(col_names), col_names = {col_names}; end;    
        obsnames = dataset_merge_columns(a, col_names);
        b = set(a, 'ObsNames', obsnames);    
    
    end
    
end