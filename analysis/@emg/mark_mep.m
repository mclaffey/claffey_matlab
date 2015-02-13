function [e, metrics] = mark_mep(e, varargin)
% Similar to find_mep, but returns the original emg object with the mep as a sections

    % process arguments    
    p.name = emg_defaults('mep_name');
    p = paired_params(varargin, p);
    
    % find mep
    mep = find_mep(e, varargin{:});
    
    % mark mep
    if mep
        e = make_section(e, p.name, mep.time.start, mep.time.end);
        metrics = e.sections.(p.name).tags.metrics;
    else
        metrics = [];
    end

end
