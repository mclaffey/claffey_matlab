function [mep, p] = find_mep(e, varargin)
% Locates an MEP pattern within the data and returns it as an emg object

%% process arguments    
    p.name = emg_defaults('mep_name');
    p.start = '';
    p.after = '';
    p.end = '';
    p.by_end_of = '';
    p.duration = '';
    p.threshold = emg_defaults('mep_search_threshold');
    p = paired_params(varargin, p);
    
    if isempty(p.threshold), error('No threshold was specified'); end;

%% determine search time
    
    % start time or section
    if char(p.start)
        if isfield(e.sections, p.start)
            p.start = e.sections.(p.start).time.start;
        else
            error('EMG:find_mep:missing_section', 'Could not find section %s', p.start)
        end
    end
    
    % after section
    if char(p.after)
        if isfield(e.sections, p.after)
            p.start = e.sections.(p.after).time.end;
        else
            error('EMG:find_mep:missing_section', 'Could not find section %s', p.after)
        end
    end
    
    % if no start or after time was specified, default to beginning
    if isempty(p.start), p.start = e.time.start; end
    
    % end time or section
    if char(p.end)
        if isfield(e.sections, p.end)
            p.end = e.sections.(p.end).time.start;
        else
            error('EMG:find_mep:missing_section', 'Could not find section %s', p.end)
        end
    end
    
    % by_end_of section
    if char(p.by_end_of)
        if isfield(e.sections, p.by_end_of)
            p.end = e.sections.(p.by_end_of).time.end;
        else
            error('EMG:find_mep:missing_section', 'Could not find section %s', p.by_end_of)
        end
    end
    
    % if no end time was specified, use duration or end of emg
    if isempty(p.end)
        if isempty(p.duration)
            p.end = e.time.end;
        else
            p.end = min(p.start + p.duration, e.time.end);
        end
    end
    
%% pass that data to the find_mep
    signal_data = crop_data_by_time(e, p.start, p.end);
	[mep_start, mep_end, search_params] = find_mep_in_array(signal_data, p.threshold, varargin{:});
    
%% create or update the mep section

    if mep_start
        mep = crop(e, mep_start + p.start, mep_end + p.start);
    else
        mep = [];
    end
end
