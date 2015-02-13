function e = subsasgn(e, subscripts, val)
%SUBSASGN Assignment function for the emg_set class
%

% Copyright 2008 Mike Claffey (mclaffey[]ucsd.edu)

% 10/30/08 ability to assign [] to multiple trials/channels
% 10/14/08 added {} assignment
% 10/01/08 imporoved warning handling
% 10/01/08 change to emg_set assignment
% 09/17/08 added safe_data_grow
% 09/02/08 error checking for channel_names assignment

%% for () and {} indexing, determine which trials and chans are affected
    
    switch subscripts(1).type
        case {'()', '{}'}            
            
            % trial indexing
            trial_indices = subscripts(1).subs{1};
            if ischar(trial_indices) && isequal(trial_indices, ':'), trial_indices = 1:size(e.data, 1); end;
            if islogical(trial_indices), trial_indices = find(trial_indices); end;
            
            % channel indexing as second element in parentheses
            if length(subscripts(1).subs) == 1
                channel_names = ':';
            else
                channel_names = subscripts(1).subs{2};
            end
            channel_indices = channel_names_to_indices(e, channel_names);            
            
            % channel indexing after period
            rest_of_subscripts = subscripts(2:end);
            if ~isempty(rest_of_subscripts) && ismember(rest_of_subscripts(1).subs, e.channel_names)
                channel_indices = channel_names_to_indices(e, rest_of_subscripts(1).subs{1});
                subscripts = subscripts([1 3:end]);
            end
            
            trial_count = length(trial_indices);
            chan_count = length(channel_indices);
    end
    
%% main switch

    switch subscripts(1).type

        case '()'
            
            % remove first subscript, already handled above
            subscripts = subscripts(2:end);

%% parentheses cont: nothing after () = assigment of emg_set
            
            if isempty(subscripts)
                
                e = safe_data_grow(e, trial_indices);
                
                % if val is empty, delete the respective trial/channels
                if isempty(val)
                    for trial = 1:trial_count
                        for chan = 1:chan_count
                            e.data{trial_indices(trial), channel_indices(chan)} = emg();
                        end
                    end
                
                else
                    % assigning a single emg object
                    if trial_count == 1 && chan_count == 1
                        if isa(val, 'emg')
                            e.data{trial_indices, channel_indices} = val;
                        else
                            error('Right side must be an emg object')
                        end

                    % assigning an emg_set
                    else
                        if ~isa(val, 'emg_set')
                            error('Right side must be a emg_set')
                        elseif size(val, 1) ~= trial_count || size(val, 2) ~= chan_count
                            error('The left side (size: [%d %d]) does not have same dimensions as the right side (size: [%d %d])', trial_count, chan_count, size(val, 1), size(val, 2))
                        end

                        % make assignment
                        for trial = 1:trial_count
                            for chan = 1:chan_count
                                e.data{trial_indices(trial), channel_indices(chan)} = val.data{trial, chan};
                            end
                        end
                    end
                end
            
%% parentheses cont: stuff after () =  assigment to properties of individual emgs            

            else
                % if only a single value is provided, assign that to all
                % trials and channels
                if max(size(val)) <= 1 || ischar(val) || (isnumeric(val) && isequal(size(val), [1 2]))
                    
                    % make assignment
                    warning_state = warning('off', 'all'); % turn off warnings during mass assignment
                    for trial = 1:trial_count
                        for chan = 1:chan_count
                            try
                                e.data{trial_indices(trial), channel_indices(chan)} = ...
                                    subsasgn(e.data{trial_indices(trial), channel_indices(chan)}, subscripts, val);
                            catch
                                fprintf('Failed to make assignment to trial %d, channel %d\n', trial, chan);
                            end
                        end
                    end
                    warning(warning_state); % return the warning state
                    
                % otherwise, attempt an element-wise assignment
                else
                    % error checking
                    if size(val, 1) ~= trial_count || size(val, 2) ~= chan_count
                        error('Emg_set on left does not have same dimensions (size: [%d %d]) as the variable on the right side (size: %s)', ...
                            trial_count, chan_count, mat2str(size(val)))
                    end

                    % for consistency, always operate on a cell
                    if ~iscell(val), val = mat2cell_same_size(val); end;

                    % make assignment
                    warning_state = warning('off', 'all'); % turn off warnings during mass assignment
                    for trial = 1:trial_count
                        for chan = 1:chan_count
                            try
                                e.data{trial_indices(trial), channel_indices(chan)} = ...
                                    subsasgn(e.data{trial_indices(trial), channel_indices(chan)}, subscripts, val{trial, chan});
                            catch
                                fprintf('Failed to make assignment to trial %d, channel %d\n', trial, chan);
                            end
                        end
                    end
                    warning(warning_state); % return the warning state
                end
            end

%% {} indexing                
        case '{}'
            
            % remove first subscript, already handled above
            subscripts = subscripts(2:end);

            if trial_count ~= 1 || chan_count ~= 1
                error('Curly assignments {} can only be applied to a single trial and channel')
            end
            
            if ~isempty(subscripts)
                error('Use () notation to assign to properties of emg objects within a emg_set')
            end
            
            e.data{trial_indices, channel_indices} = val;
            
%% period indexing
        case '.'
            after_period = lower(subscripts(1).subs);
            switch after_period
                
                case 'channel_names'
                    if iscell(val)
                        if length(val) == size(e,2)
                            e.channel_names = val;
                        else
                            error('emg_set:subasgn:bad_channel_names', 'Channel names must be a cell array with one element per channel')
                        end
                    elseif ischar(val)
                        if size(e,2) == 1
                            e.channel_names = {val};
                        else
                            error('emg_set:subasgn:bad_channel_names', 'Channel names must be a cell array with one element per channel')
                        end
                    else
                        error('emg_set:subasgn:bad_channel_names', 'Channel names must be either a string or cell')
                    end
                    
                otherwise
                    % for all other values, rethrow this in parentheses
                    % format to be handled by the code above
                    rethrow_subs = substruct('()', {':' ':'});
                    
                    % if the next subscript is a channel name, include it
                    if ismember(after_period, e.channel_names)
                        rethrow_subs.subs{2} = after_period;
                        subscripts(1) = [];
                    end
                    
                    % if the next subscript is a parens index, include it
                    if ~isempty(subscripts) && strcmp(subscripts(1).type, '()')
                        rethrow_subs.subs{1} = subscripts(1).subs{1};
                        subscripts(1) = [];
                    end
                        
                    subscripts = [rethrow_subs, subscripts];
                    e = subsasgn(e, subscripts, val);
            end

%%
    end % end of switch
end
