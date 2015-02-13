function [status_dataset] = svn_status_to_dataset(status_text)
% Convert the text returned by the svn status command to a dataset of files
%
%   [status_dataset] = svn_status_to_dataset(status_text)

% Copyright 2009-2010 Mike Claffey (mclaffey[]ucsd.edu)
%
% 05/24/13 silenced warnings thrown by dataset category subasgn
% 06/08/11 moved the starting column to 9 not 8
% 12/19/10 find the starting column for file names based on svn output specifications
% 10/20/10 fixed formatting dealing with the status line provided with the -u option
% 07/20/09 added recognition of conflicted status
% 07/13/09 fixed bug so that out of date files are properly recognized
% 05/08/09 changed code to handle file names with spaces
% 05/05/09 original version

%% reformat text from a single line with carriage returns to a char block

    run_with_u_option = false;

    % convert the text to a cell of one element per file-line
    svn_status_cell = str_block2cell(status_text); 
    
    % if status was run with the -u option, remove the 'Status against revision' line at the end
    last_line = svn_status_cell{1};
    try %#ok<TRYNC>
        if strncmpi(last_line, 'Status against revision', 23)
            svn_status_cell = svn_status_cell{1:end-1};
            run_with_u_option = true;
        end
    end
        
    % now convert the cell to an MxN char block
    svn_status_char = char(svn_status_cell);
   
%% find the char column that starts the file names

    if run_with_u_option
        file_name_start = 21;
    else
        % previously this was column 8 but now appears to be column 9
        % as of 6/8/11. not sure if there was a change in more recent
        % versions of svn or if this was always wrong
        file_name_start = 9;
    end

%     file_name_start = [];
%     shortest_line_length = min(cellfun(@length, svn_status_cell));
%     for x = shortest_line_length:-1:2
%         if all(isspace(svn_status_char(:,x)))
%             file_name_start = x+1;
%             break;
%         end
%     end
%     if isempty(file_name_start)
%         error('Couldn''t parse filenames from this:\n%s', svn_status_char);
%     end
    
%% extract relevant data

    status = svn_status_char(:,1);
    out_of_date = svn_status_char(:,8);
    file_names = svn_status_char(:, file_name_start:end);
    file_names = cellstr(file_names);
    
%% convert to dataset

    status_dataset = dataset(...
        {status, 'status'}, ...
        {out_of_date, 'out_of_date'}, ...
        {file_names, 'file_name'}          );
    
    status_dataset.out_of_date = status_dataset.out_of_date == '*';
    
    status_dataset = dataset_nominalize_fields(status_dataset, 'status');
    
    % clarify status codes
    warning('off', 'stats:categorical:subsasgn:NewLevelAdded');
    warning('off', 'stats:categorical:subsasgn:NewLevelsAdded');
    status_dataset.status(status_dataset.status=='?') = 'Not SVN';
    status_dataset.status(status_dataset.status=='!') = 'Deleted';
    status_dataset.status(status_dataset.status=='M') = 'Modified';
    status_dataset.status(status_dataset.status=='A') = 'To be added';
    status_dataset.status(status_dataset.status=='D') = 'To be deleted';
    status_dataset.status(status_dataset.status=='C') = 'To be deleted';
    status_dataset.status(isundefined(status_dataset.status) & ...
        status_dataset.out_of_date==true) = 'Out of date';
    
end

        