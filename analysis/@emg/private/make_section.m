function e = make_section(e, section_name, start_time, end_time)
% Creates a new section in an emg object at the specified time
%
% e = make_section(e, section_name, start_time, end_time)
%
% The section is created and the data is erased, as data is only maintained
%   in the parent emg object

% Copyright 2008 Mike Claffey
% modified July 29 2007 mclaffey@ucsd.edu
    
    if ~exist('end_time', 'var'), end_time = start_time; end;
    
    section = crop(e, start_time, end_time);
    section.data = [];
    e.sections.(section_name) = section;
end