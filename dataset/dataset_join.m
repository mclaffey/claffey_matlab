function [c, join_results] = dataset_join(a, b, a_fields, b_fields, join_type)
% Join two datasets based on many fields
%
% [c] = dataset_join(a, b)
%
%   Similar to the built-in join() function, except that it copies the observation
%   names of each dataset to a temporarily column and uses that temp column to complete
%   the join. It automatically drops any duplicate fields form the right dataset.
%
% [c] = dataset_join(a, b, a_fields, b_fields)
%
%   a_fields and b_fields can both be cell arrays of strings listing the column names
%   to base the join on. dataset_join() will make a temporary column in a by concatenating
%   the values in each of the columns listed in a_fields. This is repeated for b_fields.
%   If either a_fields or b_fields is empty [], it defaults to using observation names.
%
%   If there are any records missing in the left dataset, the corresponding
%   records are dropped from the right dataset (with warnings) to allow the join. The same
%   is done for any records missing in the right dataset
%
% [c] = dataset_join(a, b, [], [], join_type)
% [c] = dataset_join(a, b, a_fields, b_fields, join_type)
%
%   dataset_join is capable of handling the four major join types which address how to
%   handle records for join values that are present in one dataset but missing in the
%   other. Note that argument a corresponds to the LEFT dataset and argument b is the
%   RIGHT dataset. The join_types are as follows:
%
%       'inner'     The DEFAULT. Records are only included in the final dataset if
%                   they are present in both dataset a (left) and b (right).
%       'left'      Records in dataset a (left) that do not have corresponding records
%                   in dataset b (right) are appended, and the columns that would have
%                   come from dataset b are left blank. Records in dataset b (right)
%                   that do not have corresponding records in dataset a are ommitted.
%       'right'     The mirror opposite of 'left'. Records in dataset b (right) that do
%                   not have corresponding records in dataset a (left) are appended, and
%                   unmatched records from dataset a (left) are ommitted.
%       'outer'     No records are omitted. Unmatched records from both dataset a (left)
%                   and b (right) are both appended.
%
% [c, join_results] = dataset_join(...)
%
%   join_results is a structure containing information about the join, such as which
%   values and records were unmatched.
%   
% See-also: join
    
% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 08/17/09 handled cases were one of the two datasets are empty
% 07/21/09 renamed warning to dropping_duplicate_columns
%          introduced handling of empty dataset arguments
% 07/13/09 added join-type capability
% 04/18/09 added join fields capability
% 04/17/09 dropping missing obsnames to permit join (after throwing warning)
% 03/15/09 original version

%% handle cases when one of the two datasets are empty

    if isempty(a) && isempty(b)
        c = [];
        joined_results = [];
        return
    elseif ~isempty(a) && isempty(b)
        c = a;
        joined_results = [];
        return
    elseif isempty(a) && ~isempty(b)
        c = b;
        joined_results = [];
        return
    end        

%% determine join fields

    if ~exist('a_fields', 'var') || isempty(a_fields), a_fields = 'ObsNames'; end;
    if ~exist('b_fields', 'var') || isempty(b_fields), b_fields = 'ObsNames'; end;
    if ischar(a_fields), a_fields = {a_fields}; end;
    if ischar(b_fields), b_fields = {b_fields}; end;
    if numel(a_fields)==1 && strcmpi(a_fields{1}, 'obsnames')
        a.dataset_join_key = get(a, 'ObsNames');
    else
        [group_ids, group_names, group_column] = dataset_grp2idx(a, a_fields);
        a.dataset_join_key = group_column;
    end
    if numel(b_fields)==1 && strcmpi(b_fields{1}, 'obsnames')
        b.dataset_join_key = get(b, 'ObsNames');
    else
        [group_ids, group_names, group_column] = dataset_grp2idx(b, b_fields);
        b.dataset_join_key = group_column;
    end
    
    if ~exist('join_type', 'var')
        join_type = 'inner';
    end
    assert(ismember(join_type, {'inner', 'outer', 'left', 'right'}), 'Unrecognized join type');

%% handle duplicated fields    

    duplicate_fields = intersect(get(a, 'VarNames'), get(b, 'VarNames'));
    duplicate_fields = setdiff(duplicate_fields, {'dataset_join_key'});
    if ~isempty(duplicate_fields)
        warning('dataset_join:dropping_duplicate_columns', 'The following duplicate fields are being dropped from the right dataset:')
        check_warning = warning('query', 'dataset_join:dropping_duplicate_columns');
        if strcmpi(check_warning.state,'on')
            cellfun_easy(@fprintf, '\t%s\n', duplicate_fields);
        end
    end
    unique_b_fields = setdiff(get(b, 'VarNames'), get(a, 'VarNames'));
    assert(~isempty(unique_b_fields), 'There are no unique columns remaining in the right dataset');
    b = b(:, {'dataset_join_key', unique_b_fields{:}});
        
%% handle records that are missing from one of the datasets

    unmatched_records_from_a = [];
    unmatched_records_from_b = [];
    join_values_missing_from_a = setdiff(b.dataset_join_key, a.dataset_join_key);
    join_values_missing_from_b = setdiff(a.dataset_join_key, b.dataset_join_key);
    if ~isempty(join_values_missing_from_a)
        unmatched_records_from_b = b(join_values_missing_from_a, :);
        b(join_values_missing_from_a, :) = [];
    end
    if ~isempty(join_values_missing_from_b)
        unmatched_records_from_a = a(join_values_missing_from_b, :);
        a(join_values_missing_from_b, :) = [];
    end
    
%% perform join

    % all the extra handling here is in case one of the datasets is empty. as long as there are
    % records in both datasets, the most common path will be the first join() function
    if ~isempty(a) && ~isempty(b)
        c = join(a, b, 'key', 'dataset_join_key');
        c = dataset_encompass(c, a);
        c = dataset_encompass(c, b);
    else
        c = dataset_encompass(a, b);
    end
            
%% if there were any unmatched records, handle according to join type

    % handle records that are missing from a (left) dataset
    if ~isempty(unmatched_records_from_a)
        if strcmpi(join_type, 'outer') || strcmpi(join_type, 'left')
            unmatched_records_from_a = dataset_encompass(unmatched_records_from_a, c);
            c = dataset_append(c, unmatched_records_from_a);
        else
            warning('dataset_join:dropping_records', ...
                'Unmatched records have been dropped from the left dataset. See join_type in doc')
        end
    end        
    % handle records that are missing from b (right) dataset
    if ~isempty(unmatched_records_from_b)
        if strcmpi(join_type, 'outer') || strcmpi(join_type, 'right')
            unmatched_records_from_b = dataset_encompass(unmatched_records_from_b, c);
            c = dataset_append(c, unmatched_records_from_b);
        else
            warning('dataset_join:dropping_records', ...
                'Unmatched records have been dropped from the right dataset. See join_type in doc')
        end
    end
    
%% remove join key

    c.dataset_join_key = [];
    
%% create join results

    join_results.join_values_missing_from_a = join_values_missing_from_a;
    join_results.join_values_missing_from_b = join_values_missing_from_b;
    join_results.unmatched_records_from_a = unmatched_records_from_a;
    join_results.unmatched_records_from_b = unmatched_records_from_b;
    
end