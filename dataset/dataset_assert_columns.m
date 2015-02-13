function [columns_exist] = dataset_assert_columns(a, column_names, error_message)
% Throw an error message if the specified columns do not exist
%
% dataset_assert_column(A, COLUMN_NAMES)
%
%   Throws an error message if any of the values in the cell array of 
%   strings COLUMN_NAMES are not the name of a column in dataset A.
%   COLUMN_NAMES can also be a string to check a single column.
%
% dataset_assert_column(A, COLUMN_NAMES, ERROR_MESSAGE)
%
%   If string ERROR_MESSAGE is provided, throws that message as error.
%   Otherwise a default message is thorwn.
%
% [COLUMNS_EXIST] = dataset_assert_column(A, COLUMN_NAMES)
%
%   Results an array a true/false values corresponding to whether each name in
%   COLUMN_NAMES exists in the dataset or not. Does not throw an error message.
%


% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 08/16/09 original version

%% check arguments

    assert(isa(a, 'dataset'), 'First argument must be a dataset');
    if ischar(column_names)
        column_names = {column_names};
    elseif ~iscell(column_names)
        error('Second argument must be either a string or a cell of strings');
    end
    if exist('error_message', 'var')
        assert(ischar(error_message), 'Third argument, if provided, must be a string');
    else
        error_message = 'The above specified columns do not exist in the dataset';
    end
    
%% check column names

    existing_column_names = get(a, 'VarNames');
    columns_exist = ismember(column_names, existing_column_names);

%% throw error if any columns were missing and columns_exist was not requested
    
    if ~all(columns_exist) && nargout == 0
        fprintf('Missing columns:\n');
        disp(column_names(~is_member_results));
        error(error_message);
    end

end    