function [ffmpeg_path] = ffmpeg_find() 
% Find the path to ffmpeg

% Copyright 2013 Mike Claffey (mclaffey[]ucsd.edu)
%
% 05/24/13 add handling for PC paths
% 04/07/13 original version

    ffmpeg_path = '';

%% Mac options

    if ~isempty(strfind(lower(computer), 'mac')) || ~isempty(strfind(lower(computer), 'apple'))

        % see if ffmpeg is in the path
        [status, message] = system('which ffmpeg');
        if (status==0)
            ffmpeg_path = message;
            return;
        end

        % if no luck, start trying some common locations

        try_path = '/opt/local/bin/ffmpeg';
        [status, message] = system(['ls ', try_path]);
        if (status == 0)
            ffmpeg_path = try_path;
        end

        try_path = '/usr/local/bin/ffmpeg';
        [status, message] = system(['ls ', try_path]);
        if (status == 0)
            ffmpeg_path = try_path;
        end
        
        % otherwise, return with empty string
        return;
    end
        
%% (otherwise) PC options

    [status, message] = system('where ffmpeg');
    if status == 0
        % wrap in double quotes and remove newline at end
        ffmpeg_path = ['"' message(1:end-1) '"'];
        return;
    end

end