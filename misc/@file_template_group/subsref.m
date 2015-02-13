function [val] = subsref(ftg, subscripts)
    
%% querying a file type

    if strcmpi(subscripts(1).type, '.')
        if ismember(subscripts(1).subs, {ftg.file_types.name})
            
            file_type = subscripts(1).subs;
            
            % if no other subscripts, return codes
            if length(subscripts) == 1
                val = return_codes(ftg, file_type);
                
            % if a code was specified, return template
            elseif strcmpi(subscripts(2).type, '()')
                val = get_file_path(ftg, subscripts(2).subs{1}, file_type);
            end
        end
    end
                
end