function [secs] = time_str2secs(time_str)
% Convert a formatted time string to seconds
%
%   [secs] = time_str2secs(time_str)
%
%   time_str2secs('7:56')
%
%   ans = 
%
%       476

    colon_index = strfind(time_str, ':');

        
    if isempty(colon_index)
        secs = str2double(time_str);
        if isnan(secs), secs = 0; end
       
    else
        try
            minutes = str2double(time_str(1:colon_index-1));
            seconds = str2double(time_str(colon_index+1:end));
        catch
            error('Failed to convert answer to seconds');
        end
        
        secs = minutes * 60 + seconds;
    end

end