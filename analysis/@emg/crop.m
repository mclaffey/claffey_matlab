function e = crop(e, start_time, end_time)
% Removes data and sections from an emg object outside the specified time
%
% e = crop(e, start_time, end_time)
%
% Typically used to manipulate emg objects from the command line. In
%   contrast, make_section is a private function that uses crop() to add
%   child sections to an existing emg object
%
% See also subsref.
%
% Example
%   Crops the emg object E to t=1 to t=2:
%       e_cropped = crop(e, 1, 2)

% Copyright 2008 Mike Claffey
    
    if ~exist('end_time', 'var'), end_time = start_time; end;

%% error checking of crop times
    if start_time > end_time
        error('start time of crop is after end time of crop')
    end
    if start_time < e.time.start
        start_time = e.time.start;
        warning('EMG:crop:cropping_outside_signal', 'Attempted to crop to a time that is earlier than the start of the signal.') %#ok<WNTAG>
    end
    if end_time > e.time.end
        end_time = e.time.end;
        warning('EMG:crop:cropping_outside_signal', 'Attempted to crop to a time that is after the end of the signal.') %#ok<WNTAG>
    end

%% crop data
    
    crop_indices = e.time(start_time, end_time);
    e.data = e.data(crop_indices(1):crop_indices(2));
    e.time.range = [start_time, end_time];
    e = compute_metrics(e);
    
%% crop away sections outside of new limit
    section_list = fieldnames(e.sections);
    for x = 1:length(section_list)
       if e.sections.(section_list{x}).time.start < start_time || e.sections.(section_list{x}).time.end > end_time
           e.sections = rmfield(e.sections, section_list(x));
       end
    end
        
end