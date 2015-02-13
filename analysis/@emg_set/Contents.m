% @EMG_SET
%
% Written by Mike Claffey (mclaffey@ucsd.edu)
% Version 9-11-2008
%
% Class Functions
%   emg_set     - Constructor for the emg_set class
%   subsasgn    - Assignment function for the emg_set class
%   subsref     - Property retrieval function for the emg object class
%
% Matlab Basic Functions
%   datatipinfo - Displays mouse over information on an emg_set object
%   display     - Display information about an emg_set in the command window
%   end         - Last index in an indexing expression for an emg_set.
%   isempty     - Returns true if there are no emg objects or channel names in an emg_set
%   length      - Returns the number of trials in an emg_set    
%   logical     - Returns true if the emg_set is not empty    
%   size        - Returns the size as [trial_count, channel_count, signal_length]
%   vertcat     - Appends the trials of two emg_sets with the same number of channels    
%
% EMG_SET Functions
%   dataset     - Produces a dataset with one row for each trial of an emg_set
%   emg         - Converts an emg_set containing a single trial and channel to an emg object
%   find_mep    - Locates an MEP pattern each trial and returns it as an emg_set object
%   mark_mep    - Similar to find_mep, but returns the original emg_set with the meps as sections
%   verify      - Runs the verify function on each emg object within an emg_set
%
% Plotting
%   plot        - Plots the data of trials within an emg_set   
%   review      - Manually plot and manipulate each trial in an emg_set
