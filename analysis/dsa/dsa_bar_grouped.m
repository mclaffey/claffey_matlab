function [params] = dsa_bar_grouped(data, params)
% Creates a grouped bar graph with error bars based on a dataset
%
%   [params] = dsa_bar(data, params)
%
% the DATA argument
%
%   data must be a three column dataset. The first column contains the labels for each group on the
%   x axis and can be numeric, cells or nominal. The second column contains the labels for each bar
%   and can also be numeric, cells or nominal. The third column contains the values to plot and must
%   be numeric.
%
%   dsa_bar_grouped is intended to take datasets with multiple rows for each group value in the
%   group (1st) and bar (2nd) column. Before plotting, it aggregates the data to one row for each
%   unique combination of values in the group and bar column (using the grpstats function) and plots
%   the bar height as the mean.
%
%   dsa_bar_grouped automatically adds a legend in order to differentiate the values for each bar.
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
%   axis, the bar objects, the errorbar objects and the legend. It also contains the names of the
%   groups (params.x_tick_labels) and of the bars (params.legend_text).
%
% See-also: dsa_bar
    
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
    default_params.show_legend = true;
    params = catstruct(default_params, params);

    % data
    assert(isa(data, 'dataset'), 'First arguments must be datasets');
    if size(data,2) == 2
        % if only two columns, use dsa_bar (transparent to user)
        [params]=dsa_bar_grouped(data, params);
        return
    elseif size(data,2) < 2
        error('Dataset must be at least two columns')
    elseif size(data,2) > 3
        error('Dataset can be no more than three columns')
    end
    data_as_struct = struct(data);
    x_name = data_as_struct.varnames{1}; % this variable will be different groups on the x-axis
    x =      data_as_struct.data{1};
    b_name = data_as_struct.varnames{2}; % this variable will be different bars in each group
    b =      data_as_struct.data{2};
    y_name = data_as_struct.varnames{3};
    y =      data_as_struct.data{3};
        

%% aggregate data

    graph_data = grpstats(data, {x_name, b_name}, {'nanmean', params.error_bar_type}, 'DataVars', y_name, ...
        'VarNames', {'x_name', 'b_name', 'count', 'mean', 'error'});
    params.data = graph_data;
    bar_data = double(dataset_rows2cols(graph_data, 'x_name', 'b_name', 'mean'));
    bar_data(:,1) = []; % get rid of group column
    error_data = double(dataset_rows2cols(graph_data, 'x_name', 'b_name', 'error'));
    error_data(:,1) = []; % get rid of group column
    
%% graph data

    [group_count, bar_count] = size(bar_data);
    width = 0.8;
    group_width = bar_count / (bar_count+1.5); % matlab gives a space of 1.5 bars between groups
	
%% graphing
    params.fig_handle = gcf;
    params.bar_handle = bar(bar_data, width);
    colormap(bone);
    hold on    
    for e = 1:bar_count
 		x = (1:group_count) - group_width/2 + (2*e-1) * group_width / (2*bar_count);
 		params.error_handle(e) = errorbar(x, bar_data(:,e), error_data(:,e), 'k', 'linestyle', 'none');
    end

%% labels

    xlabel(strrep(x_name, '_', ' '));
    ylabel(strrep(y_name, '_', ' '));
    
    params.x_tick_labels = any2cell(unique(graph_data.x_name));
    set(params.axis_handle, 'XTickLabel', params.x_tick_labels);

%% legend

    if params.show_legend
        params.legend_text = any2cell(unique(graph_data.b_name));
        params.legend_handle = legend(params.legend_text, 'location', 'Best');
    end

end