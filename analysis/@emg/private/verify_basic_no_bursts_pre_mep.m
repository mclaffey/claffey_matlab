function [is_ok, optional_message, e] = verify_basic_no_bursts(e)
% True if there are no periods with rms > .05 (no modifications to e)

    is_ok = true;
    optional_message = ''; % 

%% insert function text below (do not modify above)

%% gather signal to analyze
    if ~isfield(e.sections, 'mep')
        return
    else
        signal_data = crop_data_by_time(e, e.time.start, max(e.sections.mep.time.start-.1,0));
            %crop_data_by_time(e, min(e.sections.mep.time.end+.1, e.time.end), e.time.end)];
    end
    
%% check the rms
    threshold = 0.05;
    bin_size = 20;
    
    signal_length = length(signal_data);
    rms_violations = [];
    for x = 1:bin_size:signal_length-20
        bin_end = min(x+bin_size, signal_length);
        bin_data = signal_data(x:bin_end);
        bin_rms = std(bin_data, 1);
        if bin_rms > threshold, rms_violations(end+1) = bin_rms; end; %#ok<AGROW>
    end

%% report any violations
    if isempty(rms_violations)
        optional_message = sprintf('no points with rms > %1.3f', threshold);
    else
        is_ok = false;
        optional_message = sprintf('there were points %d points with rms > %1.3f (averaging %1.2f)', ...
            length(rms_violations), threshold, mean(rms_violations));
    end
    
end