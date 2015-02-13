function [data] = dataset_nominalize_fields(data, field_list)
% Convert mulitple fields in a dataset to nominal type
%
% [DATA] = dataset_nominalize_fields(DATA, FIELD_LIST)
    
% Copyright Mike Claffey 2009 (mclaffey[]ucsd.edu)
%
% 07/13/09 throw an error if any values in field_list aren't in the dataset
% 05/06/09 only try to convert columns that aren't already nominals
% 02/09/09 original version

%% check arguments
    assert(isa(data, 'dataset'), 'First argument must be a dataset.')
    if ischar(field_list), field_list = {field_list}; end;
    assert(iscell(field_list), 'FIELD_LIST must be either a string or cell array of strings')
    mising_columns = setdiff(field_list, get(data, 'VarNames'));
    if ~isempty(mising_columns)
        disp(mising_columns);
        error('The above column(s) is not in the dataset');
    end
    
%% iterate through each field in field_list and try converting to a nominal

    failed_convert_fields = {};
    
    for x = 1:length(field_list)
        if ~isa(data.(field_list{x}), 'nominal')
            try
                data.(field_list{x}) = nominal(data.(field_list{x}));
            catch
                failed_convert_fields{end+1} = field_list{x}; %#ok<AGROW>
            end
        end
    end
        
%% report any errors
    
    if ~isempty(failed_convert_fields)
        warning('dataset_nominalize_fields:failed_fields', 'The following fields could not be converted:')
        disp(failed_convert_fields);
    end
    
end