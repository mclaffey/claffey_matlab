function val = subsref(e, subscripts)
% Property retrieval function for the emg object class

    switch subscripts(1).type
        
%% () indexing        
        % emg(start_time, end_time) indexing returns an emg object cropped
        % to the times specified
        case '()'
            if length(subscripts.subs) ~= 2, 
                error('Must provide a start and end time')
            end
            
            val = crop(e, subscripts.subs{1}, subscripts.subs{2});
            
%% {} indexing            
        % emg{start_time, end_time} indexing returns a matrix of the raw
        % emg data for the time specified
        case '{}'
            if length(subscripts.subs) ~= 2
                error('Must provide a start and end time')
            end
            
            val = crop_data_by_time(e, subscripts.subs{1}, subscripts.subs{2});
            
%% field indexing        
        case '.'
            switch subscripts(1).subs
                case 'time'
                    val = e.time;
                case 'tags'
                    val = e.tags;
                case 'data'
                    val = e.data;
                case 'sections'
                    if length(subscripts) == 1
                        val = e.sections;
                    else
                        val = e.sections.(subscripts(2).subs);
                        val.data = crop_data_by_time(e, val.time.start, val.time.end);
                        subscripts = subscripts(2:end);
                    end
                case 'metrics'
                    val = e.tags.metrics;
                otherwise
                    if isfield(e.tags.metrics, subscripts(1).subs)
                        val = e.tags.metrics.(subscripts(1).subs);
                    elseif isfield(e.sections, subscripts(1).subs)
                        val = e.sections.(subscripts(1).subs);
                    else
                        error('Unknown field for emg object: %s', subscripts(1).subs)
                    end
            end
    end
    
%% handle remaining subscripts, if any

    if length(subscripts) > 1
        val = subsref(val, subscripts(2:end));
    end
end