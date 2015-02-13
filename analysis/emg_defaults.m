function [val] = emg_defaults(inquiry)
    
    if ~exist('inquiry', 'var'), inquiry = 'all'; end;
    
%% specify defaults    
    def.y_lim = 1;
    def.sampling_rate = 2000;
    def.mep_search_threshold = 0.005;
    def.mep_search_duration = 0.007;
    def.mep_search_algorithm = 'bidir longest';
    
    def.mep_name = 'mep';
    def.tms_name = 'tms';
    
%% return requested value    
    switch inquiry
        case {'all', ''}
            val = def;
        case {'edit', 'show'}
            edit emg_defaults.m
        otherwise
            val = def.(inquiry);
    end
   
    
end