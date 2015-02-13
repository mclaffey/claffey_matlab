function svn_status_display_dataset(svn_status_dataset, repository_url)
% Display an svn_status_dataset in the command window

% Copyright 2009 Mike Claffey (mclaffey[]ucs.edu]
%
% 07/20/09 show conflicted files
% 05/05/09 original version
    
%% exit if there are no status issues

    if isempty(svn_status_dataset)
        fprintf('No locally modified changes out of sync with repository\n');
        return
    end

%% display repository as a heading    
    
    if exist('repository_url', 'var')
        command_window_line
        fprintf('SVN Repository: %s\n', repository_url);
    end
    
%% iterate through status lines

    for out_of_date = [0 1];
        out_of_date_data = svn_status_dataset(svn_status_dataset.out_of_date == out_of_date, :);
        
        if ~isempty(out_of_date_data)
            command_window_line
            if out_of_date
                fprintf('Files out of date compared to repository:\n');
            else
                fprintf('Files up to date with repository:\n');            
            end
        end
        
        % Report files in groups based on their status
        status_values = unique(out_of_date_data.status);
        for x = 1:length(status_values);
            status_value = status_values(x);
            switch char(status_value)
                case 'Modified'
                    fprintf('  Locally modified:\n');
                case 'Deleted'
                    fprintf('  Locally deleted:\n');
                case 'Not SVN'
                    fprintf('  Locally created and not under SVN control:\n');
                case 'To be added'
                    fprintf('  Scheduled for addition to repository with next commit:\n');
                case 'To be deleted'
                    fprintf('  Scheduled for deletion from repository with next commit:\n');
                case 'Out of date'
                    fprintf('  New version available on server:\n');
                case 'Conflicted'
                    fprintf('  Changes for both local copy and server version:\n');
                    
                otherwise
                    fprintf('  Unknown:\n');
            end
                    
            % list each file name with relevant commands based on status
            status_data = out_of_date_data(out_of_date_data.status == status_value, :);
            for y = 1:size(status_data)
                switch char(status_value)
                    case 'Modified'
                        fprintf('\t%s (%s %s)\n', ...
                            link_text('edit', status_data.file_name{y}), ...
                            link_text('matlab', sprintf('svn_diff(''%s'')', status_data.file_name{y}), 'compare'), ...
                            link_text('matlab', sprintf('svn_commit(''%s'')', status_data.file_name{y}), 'commit') ...
                            );
                    case {'To be added'}
                        fprintf('\t%s (%s)\n', ...
                            link_text('edit', status_data.file_name{y}), ...
                            link_text('matlab', sprintf('svn_commit(''%s'')', status_data.file_name{y}), 'commit') ...
                            );
                    case 'Not SVN'
                        fprintf('\t%s (%s %s)\n', ...
                            link_text('edit', status_data.file_name{y}), ...
                            link_text('matlab', sprintf('svn_add(''%s'')', status_data.file_name{y}), 'add'), ...
                            link_text('matlab', sprintf('svn_add_and_commit(''%s'')', status_data.file_name{y}), 'commit') ...
                            );
                    case 'Deleted'
                        fprintf('\t%s (%s)\n', ...
                            link_text('edit', status_data.file_name{y}), ...
                            link_text('matlab', sprintf('svn_commit(''%s'')', status_data.file_name{y}), 'commit delete') ...
                            );
                    case 'Out of date'
                        fprintf('\t%s (%s %s)\n', ...
                            link_text('edit', status_data.file_name{y}), ...
                            link_text('matlab', sprintf('svn_diff(''%s'', true)', status_data.file_name{y}), 'compare'), ...
                            link_text('matlab', sprintf('svn_update(''%s'')', status_data.file_name{y}), 'update') ...
                            );
                    otherwise
                        fprintf('\t%s\n', link_text('edit', status_data.file_name{y}));
                end
            end
        end        
    end
    
%% display repository as a footer
    
    if exist('repository_url', 'var')
        command_window_line
        fprintf('SVN Repository: %s\n', repository_url);
        command_window_line
    end
    
end