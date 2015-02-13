function [vargout] = svn_add_file_dataset(svn_dataset)
% Schedules files for addition to repository
%
% svn_add_file_dataset(svn_dataset)
%
%   SVN_DATASET should be in the form returned by svn_status()
%
% [command_output] = svn_add_file_dataset(svn_dataset)
%
%   Returns the results of the add command for each file in a cell array of strings.
%
% [command_output, system_code] = svn_add_file_dataset(svn_dataset)
%
%   Also results the first argument of the system() command
%

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 04/28/09 original version
    
%% check and intialize variables 

    assert(isa(svn_dataset, 'dataset'), 'First argument must be a dataset of files');
    file_count = size(svn_dataset,1);
    result = nan(file_count,1);
    svn_output = cell(file_count, 1);

%% add each file in the dataset    
    for x = 1:file_count
        file_name = svn_dataset.file_name{x};
        add_command = sprintf('svn add %s', file_name);
        [result(x), svn_output{x}] = system(add_command);
    end
    
%% Pack up output arguments

    if nargout == 0
        for x = 1:file_count
            fprintf('%s', svn_output{x});
        end
    elseif nargout == 1
        vargout = {svn_output};
    elseif nargout == 2
        vargout = {svn_output, result};
    else
        error('Does not produce more than two output arguments')
    end
    
end