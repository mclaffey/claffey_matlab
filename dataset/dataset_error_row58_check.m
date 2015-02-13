function [error_exists] = dataset_error_row58_check(dont_ask_to_fix)
% Checks for and offers to fix the row 58 for dataset assignments
%
% The code corrects a bug in Matlab 2007a that was corrected in verion
%   2008b. (Report to Mathworks in Request ID: 1-8ZGKFU)
%
% Correcting the error requires overwrite the dataset/subsasgn.m file of the
%   stats toolbox. You must have write access to this file for the correction
%   to take place
%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
%
% Assigning a one row dataset to row 58 of a dataset
%
%   myDataset(58,:) = oneRowDataset
%
% corrupts the dataset. The problem relates to the recurring
% problem with misinterpretting the semicolon index with the 
% value of 58 double(':')=58.
% 
% To fix this issue, change line 175 in @dataset/subsasgn.m from:
% 
%   if isequal(obsIndices,':')
% 
% to
% 
%   if ischar(obsIndices) && isequal(obsIndices,':') 
 

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 09/20/09 cleaned up documentation
%          renamed from dataset_row58_error to avoid autocomplete competition with dataset_rows2col
% 03/02/09 made PC compatible
% 02/23/09 original version

    error_exists = true;
    if ~exist('dont_ask_to_fix', 'var'), dont_ask_to_fix = false; end;
    
%% if matlab is new enough, don't even check

    matlab_ver = ver('matlab');
    matlab_ver = str2double(matlab_ver.Version);
    if matlab_ver >= 7.8
        fprintf('The bug has been corrected in this version of matlab\n')
        error_exists = false;
        return
    end

%% try producing the error  

    test_data = dataset({ones(60,2), 'value'});
    try
        test_data(58, :) = test_data(1, :);
        disp(test_data(2,:))
        error_exists = false;
    catch
        error_exists = true;
    end

%% no error, no problem    
    
    if ~error_exists
        fprintf('This version of matlab did not produce any errors\n')
        return
    end

%% return without fixing, if requested

    if dont_ask_to_fix, return; end;
    
%% error found, offer to fix

    fprintf('Your version of matlab produces the dataset-row-58 error.\n')
    fprintf('This can be corrected by updating the /toolbox/stats/@dataset/subsasgn.m file.\n')
    fix_reply = input('If you would like to update the file, type "fix": ', 's');
    if ~strcmpi(fix_reply, 'fix')
        fprintf('Not updating matlab\n')
        return
    end

%% replace file to fix error

    source_file = which('row58error_fix_dataset_subsasgn.txt');
    dest_file = which('dataset/subsasgn.m');
    [status,message,messageid] = copyfile(source_file, dest_file);%,'f')
    if status == 1
        fprintf('File updated okay\n')
    else
        error('Unknown error when I tried to update the file: %s\n', message)
    end
    
%% try to clear classes

    fprintf('To complete the change, I need to execute "clear classes", which will erase any data in the workspace.\n')
    fprintf('If you do not want to do this now, you can type and execute "clear classes" at any point.\n')
    fix_reply = input('If you would like to do this now, type "clear": ', 's');
    if ~strcmpi(fix_reply, 'clear')
        fprintf('Not clearing classes, error will persist until you run "clear classes" or restart.\n')
        return
    end
    
    clear classes
    if ~dataset_row58error(true)
        fprintf('The problem has been fixed.\n')
    else
        fprintf('Could not fix the problem, unclear why.\n')
    end

end

