function [b] = dataset_numericize_fields(a, field_names)
% Convert multiple columns to numeric format (cell2mat)
%
%   [b] = dataset_numericize_fields(a, field_names)

% Copyright 2009 Mike Claffey mclaffey[]ucsd.edu
%
% 09/28/09 added all() to all(sum(diff(cell2mat(cell_sizes)))==0) to fix bug
% 09/03/09 fixed warning 'Observations with default values added to dataset...'
% 05/05/09 new if statements prevents conversion attempt if a column is already numeric
% 03/30/09 original version
    
    assert(isa(a, 'dataset'), 'First argument must be a dataset');
    if ~exist('field_names', 'var'), field_names = get(a, 'VarNames'); end;
    if ischar(field_names), field_names = {field_names}; end;
    assert(iscell(field_names), 'Second argument must be a char or cell');

    b = a;
    % iterate through each column for attempted conversion
    for x = 1:length(field_names)
        % get the current column data
        col_data = b.(field_names{x});
        % if the column is a cell and has no empty elements
        if iscell(col_data) && ~any(cellfun(@isempty, col_data))
            % for numeric values
            if all(cellfun(@isnumeric, col_data))
                % calculate the dimension of all the elements
                cell_sizes = cellfun(@size, col_data, 'UniformOutput', false);
                % only proceed if all the elements are 2-D and the same size
                if all(cellfun(@length, cell_sizes)==2) && all(sum(diff(cell2mat(cell_sizes)))==0)
                    b.(field_names{x}) = cell2mat(col_data);
                end
                
            % for logical values
            elseif all(cellfun(@islogical, col_data))
                b.(field_names{x}) = logical(cell2mat(col_data));
            end
        end
    end    
    
end