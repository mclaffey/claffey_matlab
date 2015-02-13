function [rates, rule_results, trial_results, e] = verify(e, rule_file_pattern, show_status)
% Runs the verify function on each emg object within an emg_set
%
% [rates, rule_results, trial_results, e] = verify(e, rule_file_pattern)
%
% See also: emg/verify

% Copyright 2008 Mike Claffey (mclaffey[]ucsd.edu)

% 10/14/08 improved help
% 10/01/08 original version

    if ~exist('rule_file_pattern', 'var'), rule_file_pattern = []; end;
    if ~exist('show_status', 'var'), show_status = true; end;
    rule_results = struct();
    rates = struct();
    trials = size(e,1);
    chans = size(e,2);
    trial_results = cell(trials, chans);
    
    % determine verify_func list and initialize results variable
    [verification_passed, verification_results, correct_e] = verify(e.data{1, 1}, rule_file_pattern);
    verify_funcs = fieldnames(verification_results);
    verify_func_count = length(verify_funcs);
    for x = 1:verify_func_count
        verify_func_name = verify_funcs{x};
        rates.(verify_func_name) = [];
        rule_results.(verify_func_name) = struct();
        rule_results.(verify_func_name).is_ok = nan(trials, chans);
        rule_results.(verify_func_name).message = cell(trials, chans);
    end

    % verify each emg obect within the set
    for trial = 1:size(e, 1)
        for chan = 1:size(e,2)
            if show_status
                fprintf('Verifying trial %d, chan %d\n', trial, chan);
            end
            [verification_passed, verification_results, correct_e] = verify(e.data{trial, chan}, rule_file_pattern);
            e.data{trial, chan} = correct_e;
            trial_results{trial, chan} = verification_results;
            for x = 1:verify_func_count
                verify_func_name = verify_funcs{x};
                verify_func_results = verification_results.(verify_func_name);
                rule_results.(verify_func_name).is_ok(trial, chan) = verify_func_results{1};
                rule_results.(verify_func_name).message{trial, chan} = verify_func_results{2};
            end
        end
    end

%% tally rates
    overall_ok = ones(trials, chans);
    for x = 1:verify_func_count
        verify_func_name = verify_funcs{x};
        rates.(verify_func_name) = sprintf('%3.2f\t', mean(rule_results.(verify_func_name).is_ok));
        overall_ok = overall_ok & rule_results.(verify_func_name).is_ok;
    end
    rates.overall = sprintf('%3.2f\t', mean(overall_ok));
    rule_results.overall.is_ok = overall_ok;
    
end