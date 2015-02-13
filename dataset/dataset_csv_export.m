function dataset_csv_export(data, filename)
% Exports a dataset as a csv
%
% dataset_csv_export(DATA, FILE_NAME)
%
%   DATA is a dataset variable to export
%
%   FILE_NAME is the file name to write to. It can have a full path specified or will
%     write to the current directory if no path is provided.
%
% dataset_csv_export(DATA, 'open')
%
%   When the second command is the string 'open', the function will export to a temporary
%   file and immediately try to open this file with the system's default application for 
%   csv files (e.g. Excel)
%

% Copyright 2008 Mike Claffey (mclaffey[]ucsd.edu)
%
% 08/04/09 added open_in_sytem feature
% 07/13/09 renamed from dataset_to_csv to dataset_csv_export
% 07/09/09 now using any2str
% 06/01/08 original version

%% prepare variables

    open_in_system = false;
    var_name = nz(inputname(1), 'unnamed_csv_dataset');

    % default filename is none is provided
    if ~exist('filename', 'var')
        filename = sprintf('%s.csv', var_name);
    elseif strcmpi(filename, 'excel') || strcmpi(filename, 'open')
        filename = sprintf('%s_%s.csv', tempname, var_name);
        open_in_system = true;
    end
    
%% open file

    fid = fopen(filename, 'w');
    if fid < 0
        fprintf('Failed to open file: %s', filename);
        error('Could not write to file')
    end

%% check for observation names

    obs_names = get(data, 'ObsNames');
    using_obs_names = ~isempty(obs_names);
    
%% export column names

    col_names = get(data, 'VarNames');
    if using_obs_names
        fprintf(fid, 'ObsNames,');        
    end
    col_count = length(col_names);
    for col = 1:col_count
        fprintf(fid, col_names{col});
        if col < col_count, fprintf(fid, ','); end;
    end
    fprintf(fid, '\n');

%% export data

    for row = 1:size(data, 1)
        if using_obs_names
            fprintf(fid, '%s,', obs_names{row});
        end
        for col = 1:col_count
            str = any2str(data{row, col_names{col}});
            fprintf(fid, str);
            if col < col_count, fprintf(fid, ','); end;
        end
        fprintf(fid, '\n');
    end

%% close file for writing    
    
    fclose(fid);
    
%% finish with prompt

    if open_in_system
        fprintf('Opening dataset %s in excel\n', var_name);
        system(sprintf('open %s', filename));
    else    
        containing_directory = fileparts(filename);
        if isempty(containing_directory), containing_directory = pwd; end;
        fprintf('Dataset %s exported to %s\n', var_name, link_text('file',containing_directory, filename));
    end
    
end