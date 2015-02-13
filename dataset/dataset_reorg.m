function [varargout] = dataset_reorg(a, varargin)
% Rename, move and delete columns in a dataset
%
% dataset_reorg() reorganizes the columns of a dataset
% in a single command. It's first argument is a DATASET to
% reorganize followed by COLUMN_NAME-ACTION pairs. The COLUMN_NAME
% value refers to a column in DATASET, the ACTION value can be
% any of the following:
%
%   ''          (empty) - include column as is
%   '-'         do not include column
%   NUMERIC     add a new column named COLUMN_NAME with value ACTION
%   STRING      rename COLUMN_NAME to ACTION
%
% The columns appear in the order of the arguments. If the last argument is an
% asterisk, any column not included as an argument will be placed on the right
% of the returned dataset;
%
% Example:
%
%     > a = dataset({magic(3), 'col_a', 'col_b', 'col_c'})
%     a = 
%         col_a    col_b    col_c
%         8        1        6    
%         3        5        7    
%         4        9        2   
%
%     > b = dataset_reorg( a, ...
%           'col_b', 'first_col', ...       % rename and place first
%           'col_a', 'second_col', ...      % include as in and place second
%           'col_a', 'third_col_copy', ...  % include as a copy
%           'fourth_col', 0 ...             % add a new column of zeros
%       )
%     b = 
%         first_col    second_col    third_col_copy     fourth_col
%         1            8             8                  0        
%         5            3             3                  0        
%         9            4             4                  0
%
% Calling with function without any arguments besides the dataset
% returns a template of code to modify.

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 12/04/09 original version

        col_names = get(a, 'VarNames');
        uncited_col_names = col_names;
        
%% if no arguments are provided, output code template

    if nargin == 1
        
        col_names = get(a, 'VarNames');
        fprintf('%s_modified = dataset_reorg(%s, ...\n', inputname(1), inputname(1));
        
        for x = 1:size(a,2)
            fprintf('\t''%s'', '''', ...\n', col_names{x});
        end
        fprintf('\t''*'' ...\n');

        fprintf(');\n');
        
        varargout = {};
        return
        
    end
    
%% initialized variables

    b = dataset();
    if strcmpi(varargin{end}, '*')
        include_uncited = true;
        varargin{end} = [];
    else
        include_uncited = false;
    end

%% iterate through arguments to reorg each cited column

    for arg_num = 1:2:nargin-1
        arg_col = varargin{arg_num};
        arg_value = varargin{arg_num+1};
        
        % remove any cited columsn from the list of uncited
        uncited_col_names = setdiff(uncited_col_names, arg_col);
        if ischar(arg_value), uncited_col_names = setdiff(uncited_col_names, arg_value); end;
        
        % add column as is
        if isempty(arg_value)
            b.(arg_col) = a.(arg_col);
            
        % delete column
        elseif strcmpi(arg_value, '-')
            % do nothing, column will not be copied over
            
        % add a blank numeric column
        elseif isnumeric(arg_value)
            b = dataset_add_columns(b, arg_col, arg_value);
            
        % rename a column
        else
            b.(arg_value) = a.(arg_col);
        end
    end

%% add any uncited columns

    if include_uncited
        for x = 1:length(uncited_col_names)
            col_name = uncited_col_names{x};
            b.(col_name) = a.(col_name);
        end
    end
    
%% return dataset    
    
    varargout = {b};
    
end