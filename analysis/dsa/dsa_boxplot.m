function [params] = dsa_boxplot(data, params)
% Create a boxplot from a dataset
%
%   [params] = dsa_bar(data, params)
%
% the DATA argument
%
%   data must be a two column dataset. The first column contains the group labels for the x axis and
%   can be numeric, cells or nominal. The second column is the values to plot and must be numeric.
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
% See-also: dsa_bar
    
% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 04/18/09 cleaned up code to adhere to dsa standards
% 03/01/09 original version

%% check arguments
    
    % params argument
    if ~exist('params', 'var') , params = struct(); end;
    assert(isstruct(params), 'Second argument must be a structure');
    default_params.axis_handle = gca;
    default_params.bar_handle = [];
    params = catstruct(default_params, params);

    % data
    assert(isa(data, 'dataset'), 'Argument must be a dataset');
    assert(size(data,2) == 2, 'Dataset must have two columns');

    data_as_struct = struct(data);
    x_name = data_as_struct.varnames{1};
    x =      data_as_struct.data{1};
    y_name = data_as_struct.varnames{2};
    y =      data_as_struct.data{2};
    
%% graph data

    params.box_handle = boxplot(y, x);
    
%% format graph        
        
    xlabel(strrep(x_name, '_', ' '));
    ylabel(strrep(y_name, '_', ' '));
    
end