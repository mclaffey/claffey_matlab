function [vid, data_found] = vidz_load(original_vid, show_feedback_bln)
% Search for metadata file and load if found

% 09/01/10 feedback reflects whether matlab file was not found or couldn't be loaded

    %vid = [];
    if ~exist('show_feedback_bln', 'var'), show_feedback_bln = false; end
    
%% check for file

    if exist(original_vid.file.matlab, 'file')
        try
            load(original_vid.file.matlab)
            if show_feedback_bln
                fprintf('Existing matlab file loaded\n');
            end
            data_found = true;
            % vid (the returned argument) will now be equal to the loaded variable
        catch
            if show_feedback_bln
                fprintf('Existing matlab file found but error loading it\n');
            end
            vid = original_vid;
            data_found = false;
        end
    else
        if show_feedback_bln
            fprintf('No existing matlab file found, starting from scratch\n');
        end
        vid = original_vid;
    end
    
end