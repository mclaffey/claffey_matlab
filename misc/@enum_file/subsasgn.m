function ef = subsasgn(ef, subscripts, val)
% Assignment function for the enum_file class

    if ~isempty(subscripts) || ~ischar(val)
        error('Only a string template can be assigned to an enum_file object')
    end
    
    ef.template = val;


%% () and {} are not supported    
    if strcmpi(subscripts(1).type, '()')
        error('Can not assign values to enum_file using () notation')
    end
    
    if strcmpi(subscripts(1).type, '{}')
        error('Can not assign values to enum_file using {} notation')
    end
    
%% assign properties
    switch subscripts(1).subs
        case 'base_dir'
            ef.base_dir = val;
        case 'template'
            ef.template = val;
        case ef.search_ids
            ef.search_ids = val;
        otherwise
            error('Unrecognized property')
    end 
end