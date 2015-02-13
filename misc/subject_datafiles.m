function [varargout] = subject_datafiles(command, subject_id_range, file_name_template, datafile_path)    
% Function for dealing with multiple subject datafiles with a common naming template
%
% [varargout, status_message] = subject_datafiles(command, subject_id_range, file_name_template, datafile_path)   
%
%   commands:
%       files [without path] - list of all matlab files in the data dir
%       subjects [without path] - list of all matlab files fitting name template
%       ids - matrix of ids for found subject files
%       next id - one more than the highest subject file found
%       new [override] - attempt to create and save a new datafile
%       prompt new - interactive prompt for confirming next file

%       'save file'
%       'load file'
%       'load subject'

% mikeclaffey@yahoo.com
% last updated April 17, 2008

%% default values
    varargout = [];
    status_message = [];
    default_subject_id_range = 1:1000;

    
%% check that arguments are accurate
    
    % no arguments, recommend help
    if nargin < 1
        disp('type HELP subject_datafiles() for description'); 
        return;
    end

    % no subject id range, use default of 1-1000
    if nargin < 2, subject_id_range=[]; end;
    if isempty(subject_id_range)
        subject_id_range = default_subject_id_range;
        subject_range_was_empty = 1;
    else
        subject_range_was_empty = 0;
    end;
    
    % no filename template, look for one in the config folder
    if nargin < 3, file_name_template=''; end;
    if isempty(file_name_template)
        try %#ok<TRYNC>
            defaults = load('config/defaults_for_subject_datafiles');
            file_name_template = defaults.file_name_template;
        end
    end
    
    % location of datafiles
    if nargin < 4, datafile_path='data/'; end;


%% query directory for existing data files
    
    % find all files in the directory
    data_files_struct = dir(horzcat(datafile_path, '*.mat'));
    data_file_names = {data_files_struct.name}';
    
    % then find the files for the specified subject id range
    found_subject_ids = [];
    found_subject_files = {};
    if ~isempty(file_name_template)
        build_subject_id_inventory()
        next_available_subject_id = max([found_subject_ids 0]) + 1;
    end
    
    % by default, append path to file lists
    if strfind(command, 'no path')
        % do nothing to the file variables, but remove 'no path' from the
        % command so it will be caught by 'switch command...' below
        command = command(1:end-8);
    else
        if ~isempty(data_file_names)
            data_file_names = append_path(data_file_names);
        end
        if ~isempty(found_subject_files)
            found_subject_files(:,2) = append_path(found_subject_files(:,2));
        end
    end
    
    
%% run specified command    
    command = lower(command);
    switch command
            
        case {'files', 'list all files'}
            varargout = {data_file_names};
                        
        case {'subject', 'subjects', 'list subject files', 'list subj files'}
            varargout = {found_subject_files};
        
        case {'ids', 'list ids', 'get ids'}
            varargout = {found_subject_ids};
            
        case {'next', 'next id'}
            varargout = {next_available_subject_id};
            
        case {'prompt new'}
            next_id = subject_datafiles('next', [], file_name_template);
            prompt_id = input(sprintf('Enter subject id (default is %d): ', next_id));
            if isempty(prompt_id)
                subject_id = next_id;
            else
                subject_id = prompt_id;
            end
            if ~ismember(subject_id, found_subject_ids)
                [new_id, new_file] = subject_datafiles('new', subject_id, file_name_template);
            else
                if strcmp('yes', input(sprintf('Subject %d already exists. Are you sure you want to create a new file for this subject?\n (type: ''yes'' to create new file, otherwise hit ENTER: ', subject_id), 's'))
                    [new_id, new_file] = subject_datafiles('new override', subject_id, file_name_template);
                else
                    fprintf('\n\nNo subject file created\n')
                    varargout = cell(nargout,1);
                    return
                end
            end
                    
            if isempty(new_file)
                error('could not create new data file')
            else
                fprintf('New subject datafile: %s\n', new_file)
                if nargout == 1
                    varargout = new_id;
                elseif nargout == 2
                    varargout = {new_id, new_file};
                end
            end
            
        case {'new', 'new file', 'new override', 'new file override'}
            if subject_range_was_empty
                new_file_subject_id = next_available_subject_id;
                
            elseif ~subject_range_was_empty && length(subject_id_range) > 1
                error('More than one subject id was provided to subject_datafiles(''new file'')');
                
            elseif ismember(subject_id_range(1), found_subject_ids)
                if strcmp('override', command(end-7:end))
                    % this is okay, an additional datafile will be created
                    new_file_subject_id = subject_id_range(1);
                    warning('subject file with this name already exists, but will overwrite') %#ok<WNTAG>
                else
                    % don't create a new data file, return error message
                    new_file_subject_id = [];
                    varargout = {};
                    warning('subject file with this name already exists, use [override] to proceed anyway') %#ok<WNTAG>
                end
            else
                new_file_subject_id = subject_id_range(1);
            end

            % if no errors were encountered, create a new data file
            if new_file_subject_id
                data_to_initialize_with = 'this file created by subject_datafiles()';
                variable_list = {'data_to_initialize_with'};
    
                try
                    save_file_name = get_save_name(new_file_subject_id);
                    save(save_file_name, variable_list{:});
                    varargout = {new_file_subject_id, save_file_name};
                catch
                    varargout = {};
                    warning('could not create new file (%s)', lasterr); %#ok<WNTAG>
                end
            end           
 
        otherwise
            error('invalid command provided to subject_datefiles()')

    end


%% build an inventory of found subject ids

    function build_subject_id_inventory()
        for subject_id = subject_id_range
            found_file_names = find_subject_files(subject_id, file_name_template);
            find_count = size(found_file_names,1);
            if find_count > 0
                found_subject_ids(end+1) = subject_id; %#ok<AGROW>
                found_subject_id_and_file_names = [mat2cell(repmat(subject_id, find_count, 1), ones(find_count,1),1) found_file_names];
                found_subject_files = vertcat(found_subject_files, found_subject_id_and_file_names);
            end
        end
    end

    
%% sub function to search for a given subject's file    
    
    function [found_file_names] = find_subject_files(subject_id, file_name_template)
        subject_file_name = sprintf(file_name_template, subject_id);
        str_length = length(subject_file_name);
        found_file_names = data_file_names( strncmpi(data_file_names, subject_file_name, str_length) );
    end
    
%% subfunction to build filename
    function [save_name] = get_save_name(subject_id)
        if ~strfind(file_name_template, '%')
            % the file_name_template is not really a template but a
            % specifically defined file name
            save_name = file_name_template;
        else
            subject_and_experiment = sprintf(file_name_template, subject_id);
            date_str = datestr(now, 'mmm-dd-yyyy');
            time_str = strtrim(datestr(now, 'HH-MM-AM'));
            save_name = [   datafile_path ...
                            subject_and_experiment ...
                            '_' date_str ...
                            '_started_' time_str ...
                        ];
        end
    end
    
%% subjection append path
    function [names_with_path] = append_path(names_without_path)
        file_count = length(names_without_path);
        names_with_path = cell(file_count,1);
        for x = 1:file_count
            names_with_path{x, 1} = horzcat(datafile_path, names_without_path{x});
        end
    end
    
end
