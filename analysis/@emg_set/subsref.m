function val = subsref(e, subscripts)
% Property retrieval function for the emg object class
%
% () indexing always returns an emg_set, even if it has only one emg object
%
% {} indexing can only return an emg object, so a single trial and channel
% must be specified
    
    
%- e(1)              trial 1, all channels           AS emg_set
% e(1).right        trial 1, right chnnale          AS emg
% e(1, 'right')     SAME AS ABOVE
% e(1).right.sections.mep.metrics.area
%                   1 trial, right channel          AS double

%- e.right           all trials, right channel only  AS emg_set
% e.right.sections.mep.metrics.area
%                   all trials, right channel       AS vector

% e.sections.mep.metrics.area
%                   all trials, all channels        AS matrix

% 09/20/08 error handling of 'unknown channel or proerpty'

    val = [];
    
    % SUBSREF
    switch subscripts(1).type
        
        
%% parentheses & curly indexing to access trials
        case {'()', '{}'}
            
            % checking whether curlies are being used for future use
            using_curlies = logical(strcmpi(subscripts(1).type, '{}'));
            
            % trial indexing
            trial_indices = subscripts(1).subs{1};
            e.data = e.data(trial_indices, :);
            
            % channel indexing as second element in parentheses
            if length(subscripts(1).subs) > 1
                channel_indices = subscripts(1).subs{2};
                e = isolate_channels(e, channel_indices);
            end

            subscripts = subscripts(2:end);
            
            % channel indexing after period
            if ~isempty(subscripts) && ismember(subscripts(1).subs, e.channel_names)
                channel_indices = subscripts(1).subs;
                e = isolate_channels(e, channel_indices);
                subscripts = subscripts(2:end);
            end

            % if no channels were returned, return an empty emg_set
            if size(e,2) == 0, e = emg_set(); end;

            val = e;
            
            % if using curly indexing, ensure that only one emg trial is
            % being returned
            if using_curlies
                if size(e, 1) > 1
                    error('Must specify a single trial with {} notation')
                elseif size(e, 2) > 1
                    error('Must specify a single channel with {} notation')
                end
                
                val = e.data{1,1};
                
            else
                val = e;
            end            

%% period indexing            
        case '.'
            after_period = lower(subscripts(1).subs);
            % REMINDER: each case must remove any processed subscripts
            switch after_period
                case 'channel_names'
                    val = e.channel_names;
                    subscripts = subscripts(2:end);

                    
                case {'tags', 'time', 'data'}
                    val = cell(size(e, 1), size(e,2));
                    for trial = 1:size(e,1)
                        for chan = 1:size(e,2)
                            emg_obj = e.data{trial, chan};
                            try
                                temp_val = subsref(emg_obj, subscripts);
                            catch
                                temp_val = [];
                            end
                            if isempty(temp_val)
                                val{trial, chan} = NaN;
                            else
                                val{trial, chan} = temp_val;
                            end
                        end                        
                    end
                    try %#ok<TRYNC>
                        val = cell2mat(val);
                    end
                    % kill the rest of subscripts since they were used in
                    % the above subsref function call
                    subscripts = subscripts(end+1:end);
                                        
                case 'sections'
                    if length(subscripts) < 2, error('Must provide a section name'); end;
                    section_name = subscripts(2).subs;
                    new_emg_set = emg_set();
                    new_emg_set.channel_names = e.channel_names;
                    for trial = 1:size(e, 1)
                        for chan = 1:size(e, 2)
                            try
                                new_emg_obj = e.data{trial, chan}.sections.(section_name);
                            catch
                                new_emg_obj = emg();
                                new_emg_obj.tags.error = sprintf('Section %s did not exist', section_name);
                                new_emg_obj.tags.valid = 0;
                            end
                            new_emg_set.data{trial, chan} = new_emg_obj;
                        end                        
                    end
                    val = new_emg_set;
                    subscripts = subscripts(3:end);
                                        
                otherwise
                    if ismember(after_period, e.channel_names)
                        val = isolate_channels(e, after_period);
                        subscripts = subscripts(2:end);
                    else
                        error('Unknown channel or property: %s', after_period)
                    end
            end
    end % end of switch
    
%% if more subscripts, continue processing
    if ~isempty(subscripts)
        val = subsref(val, subscripts);
    end

end