function [b] = dataset_rename_column(a, varargin)
% Rename the columns of a dataset
%
% Passing a list of column name pairs to be renamed:
%
%   [b] = dataset_rename_column(a, 'old_name_1', 'new_name_1', ['old_name_n', 'new_name_n'])
%
% Passing a cell of name paires to be renamed:
%
%   [b] = dataset_rename_column(a, ...
%           {'old_name_1', 'new_name_1'; ...
%            'old_name_n', 'new_name_n'}
%

% Copyright 2008-2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 06/04/09 added list version of input arguments
%          expanded help documentation
%          rewrote naming algorithm
% 05/01/08 original version

    assert(isa(a, 'dataset'), 'The first argument must be a dataset');
    
%% parse column name argument(s)

    if nargin == 1
        error('Must specify columns to rename');
        
    elseif nargin == 2
        % cell method
        name_pairs = varargin{1};
        assert(iscell(name_pairs), 'Second of two arguments must be a cell array of column names');
        assert(size(name_pairs, 2)==2, 'Second argument must be a Mx2 cell array');
        
    else
        % list of name pairs
        list_length = nargin - 1;
        assert(mod(list_length, 2)==0, 'Must provide an even number of column names');
        name_pairs = reshape(varargin, [length(varargin) / 2, 2]);
    end
    
%% assign column names to variables
    
    existing_names = get(a, 'VarNames');
    to_be_renamed = name_pairs(:, 1);
    new_names = name_pairs(:, 2);
    
%% check for any unrecognized column names

    [is_member_boolean, col_indices] = ismember(to_be_renamed, existing_names);
    if any(~is_member_boolean)
        unrecognized_columns = to_be_renamed(~is_member_boolean);
        disp(unrecognized_columns);
        error('The above column(s) were not found in the existing data');
    end
    
%% rename columns

    existing_names(col_indices) = new_names;
    b = set(a, 'VarNames', existing_names);
    
end