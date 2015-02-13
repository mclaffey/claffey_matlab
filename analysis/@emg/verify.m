function [varargout] = verify(e, rule_file_pattern)
% Checks an emg object against a variety of quality assurance rules

    if ~exist('rule_file_pattern', 'var') || isempty(rule_file_pattern)
        rule_file_pattern = '*';
    end
    results = struct();
    rule_failures = '';

%% build list of verify files
    
    verify_dir = [fileparts(mfilename('fullpath')), '/private'];
    verify_files = dir(sprintf('%s/verify_%s.m', verify_dir, rule_file_pattern));
    verify_funcs = {verify_files.name};
    if isempty(verify_funcs)
        error('No rule files were found matching the pattern ''@emg/private/verify_%s.m''', rule_file_pattern)
    end
    
%% process each verify function

    for x = 1:length(verify_funcs)
        verify_func_name = verify_funcs{x}(1:end-2);
        verify_func_handle = str2func(verify_func_name);
        [is_ok, verify_message, e] = feval(verify_func_handle, e);
        results.(verify_func_name(8:end)) = {is_ok verify_message};
        if ~is_ok, rule_failures = [rule_failures, verify_func_name(8:end), ', ']; end; %#ok<AGROW>
    end
    
%% overall
    if isempty(rule_failures)
        verification_passed = true;
        results.overall = {1 ''};
    else
        verification_passed = false;
        results.overall = {0, sprintf('rule failures: %s', rule_failures(1:end-2))};
    end

%% prepare output arguments
    if nargout == 0
        % print the results to the command window
        results %#ok<NOPRT>
    elseif nargout > 3
        error('Too many output arguments requested')
    else
        varargout = {verification_passed, results, e};
        varargout = varargout(1:nargout);
    end
    
end