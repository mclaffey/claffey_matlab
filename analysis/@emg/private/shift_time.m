function e = shift_time(e, property, new_value)
% Changes the timebase of an emg object
%
% E = shift_time(E, PROPERTY, NEW_VALUE)
%
% PROPERTY can be one of four values
%   'START' shifts the start to NEW_VALUE without changing duration
%   'END' changes the end to NEW_VALUE by altering the duration,
%       without changing the start time
%   'OFFSET' shifts both the start and end by NEW_VALUE without
%       changing the duration
%   'DURATION' makes the duration equal to NEW_VALUE by altering the
%       end time without changing the start time
%   'LIMITS' changes the start time to NEW_VALUE(1) and the end time to
%       NEW_VALUE(2), altering the duration as necessary

% Copyright 2008 Mike Claffey (mclaffey[]ucsd.edu)

% 12/08/2008 changed help documentation
% 07/29/2008 original version
    
    property = lower(property);

%% for start or duration, modify them to a more generic case
    switch property
        case 'start'
            property = 'offset';
            new_value = new_value - e.time.start;
        case 'duration'
            property = 'end';
            new_value = e.time.start + new_value;
    end

%%    
    switch property
        
%% offset changes
    
        case 'offset'
            e.time.start = e.time.start + new_value;
            section_names = fieldnames(e.sections);
            for x = 1:length(section_names)
                section = section_names{x};
                e.sections.(section) = shift_time(e.sections.(section), 'offset', new_value);
            end

%% end changes
        case 'end'
            e.time.end = new_value;

            section_names = fieldnames(e.sections);
            for x = 1:length(section_names)
                section = section_names{x};
                if e.sections.(section).time.start > new_value
                    e.sections.(section).time.start = new_value;
                    e.sections.(section).time.duration = 0;
                elseif e.sections.(section).time.end > new_value
                    e.sections.(section) = shift_time(e.sections.(section), 'end', new_value);
                end
            end
            %% end changes
            
%% limits changes            
        case 'limits'
            if length(new_value) ~= 2
                error('when adjusting limits, must provide a new start and end time')
            end
            
            e.time.start = new_value(1);
            e.time.end = new_value(2);

            section_names = fieldnames(e.sections);
            for x = 1:length(section_names)
                section = section_names{x};
                if e.sections.(section).time.start < new_value(1)
                    e.sections.(section).time.start = new_value(1);
                end
                if e.sections.(section).time.end > new_value(2);
                    e.sections.(section) = shift_time(e.sections.(section), 'end', new_value(2));
                end
            end
            
%%            
        otherwise
            error('Unknown time property ''%s'' for shift_time', property)
    end
    
    e = compute_metrics(e);

end