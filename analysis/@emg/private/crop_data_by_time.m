function [cropped_data] = crop_data_by_time(e, start_time, end_time)
% Returns the data within the specified time as a vector
%
% [cropped_data] = crop_data_by_time(e, start_time, end_time)

% Copyright 2008 Mike Claffey
% modified July 29 2008 mclaffey@ucsd.edu


    if start_time == end_time
        cropped_data = [];
    else
        crop_indices = e.time(start_time, end_time);
        cropped_data = e.data(crop_indices(1):crop_indices(2));
    end
end