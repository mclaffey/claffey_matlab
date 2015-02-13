function [e, metrics] = mark_mep(e, varargin)
%MARK_MEP Similar to find_mep, but returns the original emg_set with the meps as sections

    mep_amps = nan(size(e, 1), size(e, 2));
    
%% iterate through each emg object and run find_mep
    for trial = 1:size(e, 1)
        for chan = 1:size(e, 2)
            fprintf('Finding mep in trial %d, chan %d\n', trial, chan);
            if false
                % this avoids the error catching for when trying to debug
                fprintf(' * * MARK_MEP is operating in DEBUG mode * *\n')
                [e.data{trial, chan}, metrics] = mark_mep(e.data{trial, chan}, varargin{:});
            else
                try
                    [e.data{trial, chan}, metrics] = mark_mep(e.data{trial, chan}, varargin{:});
                catch
                    last_error = lasterror;
                    if strcmpi(last_error.identifier, 'EMG:find_mep:missing_section')
                        fprintf('Couldn''t find necessary section in trial %d channel %d to find mep\n', trial, chan );
                    else
                        error(last_error)
                    end
                    metrics=[];
                end
            end
            if ~isempty(metrics)
                mep_amps(trial, chan) = metrics.peak2peak;
            end
        end
    end
    
%% report metrics
    metrics = [];
    metrics.trials = size(e,1);
    metrics.percent_found = (1-sum(isnan(mep_amps)) ./ metrics.trials) * 100;
    metrics.average_amp = nanmean(mep_amps);
    metrics.std = nanstd(mep_amps);

end
