function datatipinfo(e)
% Displays mouse over information on an emg object
    
    if isempty(e)
        fprintf('[empty emg object]\n\n');
        return
    end
    
    % time base
    if e.time.duration == 0
        fprintf('Zero length section at %5.3f secs\n', e.time.start);
    else
        fprintf('%5.3f second signal (time %5.3f - %5.3f secs)\n', e.time.duration, e.time.start, e.time.end);
    end
        
    % validity
    if e.tags.valid
        fprintf('Is valid\n');
    else
        fprintf('Is NOT valid\n');
    end
    
    % tags
    tag_list = setdiff(fieldnames(e.tags), {'valid', 'units', 'metrics'});
    if isempty(tag_list)
        fprintf('No tags\n');
    else
        fprintf('Tags:');
        for x = 1:length(tag_list)
            fprintf(' %s', tag_list{x});
        end
        fprintf('\n');
    end
            
    % sections
    if isempty(e.sections) || isempty(fieldnames(e.sections))
        fprintf('No sections\n');
    else
        fprintf('Sections:');
        section_names = fieldnames(e.sections);
        for x = 1:length(section_names)
            fprintf('  %s', section_names{x});
        end
        fprintf('\n');
    end

end