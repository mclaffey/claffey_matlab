function val = subsref(ef, subscripts)
% Property retrieval function for the enum_file class
%
% general properties:       ids, next id, template, all_files
% file properties:          load, find, generate, exists

% Copyright 2008-2009 Mike Claffey (mclaffey[]ucsd.edu)

% 03/02/09 put quotes around filename for load so it can handle filenames with spaces
% 02/12/09 improved the load command, added properties help
% 11/18/08 fixed base_dir

%% for () indexing, determine which file numbers are being requested

    if strcmp(subscripts(1).type, '()')

        % check file ids
        file_ids = subscripts(1).subs{1};
        if ~isvector(file_ids), error('File IDS must be a 1-dimensional array'); end;
        if size(file_ids, 1) == 1, file_ids = file_ids'; end; % file_ids should be a vertical vector
            
        % Look at next subscript to determine which property is being accessed
        if length(subscripts) < 2
            property = 'generate';
        elseif strcmpi(subscripts(2).type, '.')
            property = subscripts(2).subs;
        else
            error('Improperty indexing')
        end
            
        % either generate or find file names
        if strcmpi(property, 'generate')
            limit_to_existing = false;
        else
            limit_to_existing = true;
        end
        
        % create list of file names
        file_count = length(file_ids);
        [file_names_as_list, file_names_by_idx, found_ids] = get_file_names(fullfile(ef.base_dir, ef.template), file_ids, limit_to_existing);
        
        % now process depending on which property was requested
        switch property
            case 'generate'
                val = file_names_as_list;
                
            case 'find'
                val = file_names_by_idx;

            case 'exists'
                val = ~cellfun(@isempty, file_names_by_idx);
            
            case 'load'
                if isempty(file_names_as_list)
                    warning('enum_files:no_files_found', 'No files found for requested id(s): %s\n', str2mat(file_ids));
                    val = {{}};
                else
                    if any(setdiff(file_ids, found_ids))
                        warning('enum_files:some_files_not_found', 'No files were found for the following ids: %s', mat2str(setdiff(file_ids, found_ids)))
                    end
                    val = cellfun(@load, file_names_as_list);
                    if nargout == 0
                        % no output arguments, so load in base workspace
                        if length(file_names_as_list) > 1, warning('enum_file:load_multiple', 'Loading more than one file in workspace, which may overwrite each other'); end;
                        for x = 1:length(file_names_as_list)
                            try
                                evalin('base', sprintf('load ''%s''', file_names_as_list{x}));
                            catch
                                warning('enum_files:failed_to_load', 'Could not load file for id %d\n', x, file_names_as_list{x});
                            end
                        end
                    end
                end
        end
        
        % if only one file_id was provided, convert cell to single element
        if iscell(val) && file_count == 1
            val = val{1};
            if ~isempty(val) && iscell(val), val = val{1}; end;
        end
        
        return
    end
            
%% {} indexing    
    if strcmp(subscripts(1).type, '{}')
        error('Curly bracket indexing is not used for enum_file')
    end
            
%% field indexing        
    if strcmp(subscripts(1).type, '.')
        
        property = subscripts(1).subs;
            
            % general properties:       ids, next id, template, files
        switch property
            case 'template'
                val = ef.template;
                
            case 'base_dir'
                val = ef.base_dir;
                
            case 'search_ids'
                val = ef.search_ids;
                
            case 'ids'
                val = get_ids(ef);
                
            case 'next_id'
                val = max(get_ids(ef)) + 1;
                if isempty(val), val = 1; end;
                
            case 'files'
                val = get_file_names(fullfile(ef.base_dir, ef.template), ef.search_ids, true);
                
            otherwise
                error('Unrecognized property')
                
        end
    end
end