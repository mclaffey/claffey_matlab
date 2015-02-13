function e = subsasgn(e, subscripts, val)
% Assignment function for the emg object class

%% () and {} are not supported    
    if strcmpi(subscripts(1).type, '()')
        error('Can not assign values to emg class using () notation')
    end
    
    if strcmpi(subscripts(1).type, '{}')
        error('Can not assign values to emg class using {} notation')
    end
    
%% field indexing    
    switch subscripts(1).subs
%% data
        case 'data'
            error('Can not change the data of an existing emg object. create a new instance instead.')
            
%% .time
        case 'time'
            
            if isempty(val)
                error('Can not delete properties of the sampling time')
            elseif length(subscripts) == 1
                error('Can not replace the time base - use crop() or modify time properties')
            elseif ~isempty(e.data) && ~strcmpi(subscripts(2).subs, 'start')
                error('Can only change the start time of an emg object. Use crop() instead')
            else
                e = shift_time(e, subscripts(2).subs, val);
            end
        
%% .tags
        case {'tags', 'tag'}
            
            % deleting
            if isempty(val)
                if length(subscripts) == 1
                    error('Can not delete ''tag'' field from emg object')
                elseif length(subscripts) == 2
                    deleted_tag = subscripts(2).subs;
                    if isfield(e.tags, deleted_tag)
                        e.tags = rmfield(e.tags, deleted_tag);
                    else
                        warning('EMG_SET:delete_nonexisting_tag', 'Trying to delete non-existant tag: %s', deleted_tag)
                    end
                else
                    sub_tags = subsref(e.tags, subscripts(2:end-1));
                    sub_tags = rmfield(sub_tags, subscripts(end).subs);
                    e.tags = subsasgn(e.tags, subscripts(2:end-1), sub_tags);
                end

            % assignment
            else
                if length(subscripts) == 1
                    e.tags = val;
                else
                    e.tags = subsasgn(e.tags, subscripts(2:end), val);                
                end
            end
                    
%% .sections
        case {'sections', 'section'}
            if length(subscripts) == 1
                error('Can not assign directly to the ''sections'' property')
            end
            
            section_name = subscripts(2).subs;
            subscripts = subscripts(3:end);
            
            % deleting
            if isempty(val)
                if isempty(subscripts)
                    if isfield(e.sections, section_name)
                        e.sections = rmfield(e.sections, section_name);
                    else
                        warning('EMG:subsasgn:delete_nonexisting_section', 'Section %s does not exist to be deleted', section_name)
                    end                        
                else
                    e.sections.(section_name) = subsasgn(e.sections.(section_name), subscripts, val);
                end
                
            % assigning
            else
                
                % if there are no more subscripts, a section is being
                % created or manipulated. 
                if isempty(subscripts)
                    if length(val) == 1 && isnumeric(val)
                        e = make_section(e, section_name, val);

                    elseif length(val) == 2 && isnumeric(val)
                        e = make_section(e, section_name, val(1), val(2));

                    else
                        error('Can only assign a start value or [start, end] to a section')
                    end

                % handle all other assignments here
                else
                    e.sections.(section_name) = subsasgn(e.sections.(section_name), subscripts, val);
                end
            end
                    

%% otherwise                    
        otherwise
            error('Unknown property ''%s'' of emg object', subscripts(1).subs)
    end
end