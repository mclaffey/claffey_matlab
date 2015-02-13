function val = subsref(t, subscripts)
% t(A)
%   If A is a single value, it returns the responding index.
%   If A is two values, it returns both indices. However, the second index
%   is decreased by one.
%
% [start, end] = t.range
%
% [timebase_matrix] = t.base

% 03/14/11 fixed an error in how indices were being calculated based on
%          provided time, which effected selections where being off by 1
%          index was unacceptable
% 10/14/08 changed from switch to if-then to improve performance

    % SUBSREF
    subs_1_type = subscripts(1).type;

%% () indexing - converts times to index
    if strcmpi(subs_1_type, '()')
            
        input_times = subscripts.subs;
        if iscell(input_times), input_times = cell2num(input_times); end;

        % error checking
        if length(input_times) > 2, error('Too many input_times'); end;
        if min(input_times) < t.start, error('One of the times requested is before the start'); end;
        if max(input_times) > t.start + t.duration, error('The time requested is after the end'); end;

        % calculate indices
        start_index = ceil((input_times(1) - t.start) .* t.sampling_rate) + 1;
        end_index = floor((input_times(2) - t.start) .* t.sampling_rate) + 1;
        val = [start_index, end_index];
                    
%% {} indexing - convert indices to time
    elseif strcmpi(subs_1_type, '{}')

        input_indices = subscripts.subs{1};
        val = t.start + (input_indices - 1) * 1 / t.sampling_rate;
            
%% field indexing
    
    elseif strcmpi(subs_1_type, '.')

        switch subscripts(1).subs
            case {'start', 'duration', 'points', 'sampling_rate'}
                val = t.(subscripts(1).subs);
            case 'end'
                val = t.start + t.duration;
            case {'range', 'limits'}
                val = [t.start, t.start + t.duration];
            case 'interval'
                val = 1 / t.sampling_rate;
            case 'last'
                val = last_point(t);
            case 'base'
                val = linspace(t.start, last_point(t), round(t.points));
            otherwise
                error('Unknown property ''%s'' of sampling_time object', subscripts(1).subs)
        end
            
    else
        error('Unrecognized subscript %s', subs_1_type)
    end
    
end