function [section] = get_section_with_data(e, section_name)
% Returns the specified section of an emg object

% Copyright 2008 Mike Claffey
% modified July 29 2008 mclaffey@ucsd.edu

    section = e.sections.(section_name);
    section.data = crop_data_by_time(e, section.time.start, section.time.end);
end