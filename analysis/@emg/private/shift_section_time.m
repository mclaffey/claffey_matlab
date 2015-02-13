function e = shift_section_time(e, section_name, property, new_value)
% Changes the timebase of an emg section
%
% E = shift_section_time(E, SECTION_NAME, PROPERTY, NEW_VALUE)
%
% See shift_time for explaination of PROPERTY AND NEW_VALUE

% Copyright 2008 Mike Claffey
% modified July 29 2008 mclaffey@ucsd.edu

    % shift section in time
    section = shift_time(e.sections.(section_name), property, new_value);
    
    % get new data, compute metrics, and remove data since it is a section
    section.data = crop_data_by_time(e, section.time.start, section.time.end);
    section = compute_metrics(section);
    section.data = [];
    
    % update parent emg object
    e.sections.(section_name) = section;

end