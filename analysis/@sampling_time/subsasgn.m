function t = subsasgn(t, subscripts, val)


%% () and {} indexing
    if strcmpi(subscripts(1).subs, '()') || strcmpi(subscripts(1).subs, '()')
        error('Assign values to properties of sampling_time object')
    end
            
%% field indexing            
    switch subscripts(1).subs
        case 'start'
            t.start = val;

        case 'end'
            t.duration = val - t.start;
            t.points = t.duration * t.sampling_rate;
            
        case 'range'
            t.start = val(1);
            t.duration = val(2) - t.start;
            t.points = t.duration * t.sampling_rate;

        case 'duration'
            t.duration = val;
            t.points = t.duration * t.sampling_rate;

        otherwise
            error('Can only adjust start, end, range or duration')
    end
end


