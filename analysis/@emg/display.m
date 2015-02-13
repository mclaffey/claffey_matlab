function display(e)
% Display information about an emg object in the command window    
    disp(' ');
    disp([inputname(1),' = '])
    
    if isempty(e)
        fprintf('\t[empty emg object]\n\n');
        return
    end
    
    % zero length sections
    if e.time.duration == 0
        fprintf('\tZero length section at %5.3f secs\n', e.time.start);

    % non-zero length sections
    else
        fprintf('\t%5.3f second signal (time %5.3f - %5.3f secs)\n', e.time.duration, e.time.start, e.time.end);
        fprintf('\tAmplitude: %3.2f %s (Area: %4.3f)\n', e.tags.metrics.peak2peak, e.tags.units, e.tags.metrics.area);
    end

    % validity
    if e.tags.valid
        fprintf('\tIs marked valid ');
    else
        fprintf('\tIs marked invalid ');
    end
    
    % data
    if isempty(e.data)
        fprintf('(no data, possible section)\n')
    else
        fprintf('(has data)\n')
    end
    
    % tags
    tag_list = setdiff(fieldnames(e.tags), {'valid', 'units', 'metrics'});
    if isempty(tag_list)
        fprintf('\tNo tags\n');
    else
        fprintf('\tTags:\n');
        for x = 1:length(tag_list)
            tag_value = e.tags.(tag_list{x});
            if isnumeric(tag_value)
                fprintf('\t\t%s: %f\n', tag_list{x}, tag_value);
            elseif ischar(tag_value)
                fprintf('\t\t%s: %s\n', tag_list{x}, tag_value);
            else
                fprintf('\t\t%s: [%s]\n', tag_list{x}, class(tag_value));                
            end
        end
    end
            
    % sections
    if isempty(e.sections) || isempty(fieldnames(e.sections))
        fprintf('\tNo sections\n');
    else
        fprintf('\tSections:\n');
        section_names = fieldnames(e.sections);
        for x = 1:length(section_names)
            fprintf('\t\t%s [%3.2f secs] (%3.2f - %3.2f)\n', section_names{x}, ...
                e.sections.(section_names{x}).time.duration, ...
                e.sections.(section_names{x}).time.start, ...
                e.sections.(section_names{x}).time.last );                
        end
    end

    if is_compressed(e)
        fprintf('\n** DATA IS COMPRESSED (use unzip before working with data)\n\n')
    end    
    

        
    disp(' ');
end