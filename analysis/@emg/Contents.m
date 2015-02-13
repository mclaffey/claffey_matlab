% @EMG
%
% Written by Mike Claffey (mclaffey@ucsd.edu)
% Version 9-11-2008
%
% Class Functions
%   emg         - Constructor for the emg class
%   subsasgn    - Assignment function for the emg object class
%   subsref     - Property retrieval function for the emg object class
%
% Matlab Basic Functions
%   datatipinfo - Displays mouse over information on an emg object
%   display     - Display information about an emg object in the command window    
%   isempty     - Returns true if an emg object has no data, time info, tags or sections
%   isequal     - Compares the data of two emg objects (ignores tags & sections)
%   logical     - Returns true if an emg object is not empty
%   size        - Returns the number of points in the data of an emg object
%
% EMG Object Functions
%   crop        - Removes data and sections from an emg object outside the specified time
%   find_mep    - Locates an MEP pattern within the data and returns it as an emg object
%   mark_mep    - Similar to find_mep, but returns the original emg object with the mep as a sections
%   dataset     - Produces a single-row dataset containing tags, metrics and sections
%   verify      - Checks an emg object against a variety of quality assurance rules
%
% Plotting
%   plot        - Plots the emg data with interactive features for editing the emg object   
