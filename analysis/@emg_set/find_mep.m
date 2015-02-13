function [meps] = find_mep(e, varargin)
%FIND_MEP Locates an MEP pattern each trial and returns it as an emg_set object

    meps = emg_set();
    meps.channel_names = e.channel_names;

%% iterate through each emg object and run find_mep
    for trial = 1:size(e, 1)
        for chan = 1:size(e, 2)
            try
                meps.data{trial, chan} = find_mep(e.data{trial, chan}, varargin{:});
            catch
                last_error = lasterror;
                if strcmpi(last_error.identifier, 'EMG:find_mep:missing_section')
                    fprintf('Couldn''t find necessary section in trial %d channel %d to find mep\n', trial, chan );
                    meps.data{trial, chan} = emg();
                else
                    error(last_error)
                end
            end
            if isempty(meps.data{trial, chan}), meps.data{trial, chan} = emg(); end;
        end
    end            

end
