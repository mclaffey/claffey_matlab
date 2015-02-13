function [params] = dsa_bar(data, params)
% Creates a bar graph with error bars based on a dataset
%
%   [params] = dsa_bar(data, params)
%
% the DATA argument
%
%   data must be a two column dataset. The first column contains the group labels for the x axis and
%   can be numeric, cells or nominal. The second column is the values to plot and must be numeric.
%
%   dsa_bar is intended to take datasets with multiple rows for each group value in the group (1st)
%   column. Before plotting, it aggregates the data to one row for each unique value in the group
%   column (using the grpstats function) and plots the bar height as the mean.
%
% the PARAMS argument
%
%   by default, the error bars are standard error of the mean (SEM). If you would like to plot error
%   bars as standard deviation, pass the params argument with a field named 'error_bar_type' set
%   equal to the string 'std'.
%
%   if you would like to plot this graph in an axis other than the current axis (gca), add a field
%   called 'axis_handle' to the input params argument and set it equal to the desired axis handle.
%
% the returned PARAMS argument
%
%   the param argument returned by the function is a structure which contains the handles of the
%   axis, the bar object and the errorbar object. 
%
% See-also: dsa_bar_grouped
    
% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 04/07/09 cleaned up code, change ind/dep arguments to just the data, added documentation
% 03/01/09 original version

%% check arguments
    
    % params argument
    if ~exist('params', 'var') , params = struct(); end;
    default_params.error_bar_type = 'sem';
    default_params.axis_handle = gca;
    default_params.bar_handle = [];
    default_params.error_handle = [];
    default_params.bar_width = .8;
    params = catstruct(default_params, params);

    % data
    assert(isa(data, 'dataset'), 'First arguments must be datasets');
    if size(data,2) > 2
        % if more than two columns, use dsa_bar_grouped (transparent to user)
        [params]=dsa_bar_grouped(data, params);
        return
    elseif size(data,2) < 2
        error('Dataset must be at least two columns')
    end
    data_as_struct = struct(data);
    x_name = data_as_struct.varnames{1};
    x =      data_as_struct.data{1};
    y_name = data_as_struct.varnames{2};
    y =      data_as_struct.data{2};
    
%% aggregate data

    graph_data = grpstats(data, x_name, {'nanmean', params.error_bar_type}, 'DataVars', y_name, ...
        'VarNames', {'x_name', 'count', 'mean', 'error'});
    params.data = graph_data;
    graph_data.x_name = any2cell(graph_data.x_name);

%% graph

    params.fig_handle = gcf;
    params.bar_handle = bar(graph_data.mean, params.bar_width, 'grouped', 'w');
    set(params.axis_handle, 'XTickLabel', graph_data.x_name);
    hold on
    params.error_handle = errorbar(1:length(graph_data.mean), graph_data.mean, graph_data.error, 'k', 'linestyle', 'none');

%% format graph        
        
    xlabel(strrep(x_name, '_', ' '));
    ylabel(strrep(y_name, '_', ' '));    
    
end