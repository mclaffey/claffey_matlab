function [master_data] = dataset(e, varargin)
% Produces a dataset with one row for each trial of an emg_set
%
% [dataset] = dataset(e, [name-value pairs])
%
% SEE emg/dataset for name-value pairs
%

% Copyright 2008 Mike Claffey mclaffey@ucsd.edu
%
% 11/24/08 fixed bug: multiple channels was just repeating the first channel's data
% 09/20/08 added functionality for multiple channels
% 08/25/08 original version

%% error checking

    if isempty(e)
        data = dataset();
        return
    end;

%% get dataset for each channel and trial    
    trial_count = size(e,1);
    channel_count = size(e,2);
    data_as_cell = cell(trial_count, channel_count);
    
    for chan = 1:channel_count
        for trial = 1:trial_count
            data_as_cell{trial, chan} = dataset(e.data{trial, chan}, varargin{:});
        end
    end
    

%% compile a list of all variables for each channel
%     chan_vars = struct('complete_var_list', {}, 'default_values', {});
    chan_vars = struct();
    
    for chan = 1:channel_count
        chan_vars(chan).complete_var_list = {};
        chan_vars(chan).default_values = {};
        
        for trial = 1:trial_count

            trial_data = data_as_cell{trial, chan};
            new_vars = setdiff(get(trial_data, 'VarNames'), chan_vars(chan).complete_var_list);
            
            % add each new variable to the list and find its default value
            for x = 1:length(new_vars);
                chan_vars(chan).complete_var_list{end+1} = new_vars{x}; %#ok<AGROW>
                if any(strfind(new_vars{x}, 'valid'))
                    chan_vars(chan).default_values{end+1} = 0; %#ok<AGROW>
                elseif isnumeric(trial_data.(new_vars{x}))
                    chan_vars(chan).default_values{end+1} = NaN; %#ok<AGROW>
                elseif isa(trial_data.(new_vars{x}), 'nominal')
                    chan_vars(chan).default_values{end+1} = nominal(''); %#ok<AGROW>
                end
            end
        end
    end
    
%% compile all datasets
    master_data = dataset();
    for chan = 1:channel_count
        chan_data = dataset();
        for trial = 1:trial_count
            trial_data = dataset_add_columns(data_as_cell{trial, chan}, chan_vars(chan).complete_var_list, chan_vars(chan).default_values);
            chan_data = dataset_append(chan_data, trial_data);
        end
        
        if channel_count == 1
            % if there is only one channel, return that channel as is
            master_data = chan_data;

        else
            % otherwise, each channel's data needs the channel name appended to each column name and
            % the entire dataset merged onto the master data
            chan_data = dataset_append_varnames(chan_data, sprintf('%s_', e.channel_names{chan}));
            if chan == 1
                master_data = chan_data;
            else
                master_data = horzcat(master_data, chan_data);
            end
        end
        
    end
   
end