% PRIVATE
%
% EMG Object Manipulation
%   crop_data_by_time          - Returns the data within the specified time as a vector
%   get_section_with_data      - Returns the specified section of an emg object
%   make_section               - Creates a new section in an emg object at the specified time
%   shift_section_time         - Changes the timebase of an emg section
%   shift_time                 - Changes the timebase of an emg object
%
% Plotting
%   plot_emg_data              - Plots the data signal and sections in a figure axis    
%
% Calculation Helpers
%   compute_metrics            - Used to automatically populate tags.metrics of an emg object
%   cumulative_above_threshold - Calculates the number of consecutive elements in an array above a scalar threshold
%   find_mep_in_array          - Find an MEP-like pattern in an scalar array of EMG data
%   smoothout                  - Simple smoothing by taking each point to the max of it and it's two neighbors

% Verification Files
%   verify_basic_has_data      - True if data is a non-empty array (no modifications to e)
%   verify_basic_is_valid      - True if .tags.valid is true (no modifications to e)
%   verify_basic_metrics_ok    - True if all metrics are accurate (corrects metrics of e)
%   verify_basic_no_bursts     - True if there are no periods with rms > .05 (no modifications to e)
%   verify_basic_no_noise      - True if there are no periods with rms > .005 (no modifications to e)
%   verify_basic_not_maxed     - True if there are no data points equal to +/- 1 (no modifications to e)
%   verify_basic_sections_ok   - True if none of the sections contain overhead data (removes data from e)
%   verify_mep__found          - True if an mep section is found (no modifications to e)
%   verify_mep_big_enough      - True if an mep section is found with amplitude > 0.1 (no modifications to e)
%   verify_mep_long_enough     - True if an mep section is found with duration > 0.015 (no modifications to e)
%   verify_mep_quiet_before    - True if the 100 ms before tms has rms < .005 (creates mep.tags.pre_tms.rms)
