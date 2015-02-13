function [results] = ffmpeg_run(ffmpeg_cmd, show_feedback_bln)
% Run a validly formatted ffmpeg command in the system

% Copyright 2010 Mike Claffey (mclaffey [] ucsd.edu)
%
% 08/04/10 original

    if ~exist('show_feedback_bln', 'var'), show_feedback_bln = false; end;

%%

    % if the command is already a string, run it
    if ischar(ffmpeg_cmd)
        
        % run command in system
        [status, message] = system(ffmpeg_cmd);
        
        % compile results
        results.command = ffmpeg_cmd;
        results.ok = ~status;
        results.output = message;
        
        % if failed, throw error
        if ~results.ok
            fprintf(results.output);
            fprintf('\nffmpeg command:\n\t%s\n\n', ffmpeg_cmd);
            error('ffmpeg command failed (see command and output above)');
        end
        
        % display feedback if requested
        if show_feedback_bln
            fprintf('ffmpeg command:\n\t%s\n%s\n', results.command, results.output);
        end
            
    % if the command is in structure format, convert to string and run it
    elseif isstruct(ffmpeg_cmd)
        ffmpeg_cmd2 = ffmpeg_build(ffmpeg_cmd);
        ffmpeg_run(ffmpeg_cmd2, show_feedback_bln);

    % unknown input
    else
        error('ffmpeg_cmd must be eithe a string or a structure');
        
    end

end