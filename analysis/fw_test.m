%% class structure
% func_path
% data

clear
clc
fw = function_wrapper
fw.path
fw.data

%% create the function file
fw.new = 'calc_ages'
%  data = a.first + a.second;

%% edit the function
fw.edit

%% run the function
fw.inputs = struct('first', 5, 'second', 10)

%% see full details
fw.details

