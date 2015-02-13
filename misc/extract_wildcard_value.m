function [wildcard_str] = extract_wildcard_value(search_string, template)
% Returns the value in a string that matches the * in a template
%
%   [wildcard_str] = extract_wildcard_value(search_string, template)
%
% Example:
%
%   > extract_wildcard_value('my_7th_file', 'my_*_file')
%   ans =
%   7th
%
% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 10/27/09 original version
    
    % wildcard_start is the start of the matched substring in search_string that matches *
    % wildcard_end is the end of the matched substring in search_string that matches *
    
    % condense consecutive wildcards to one
    while strfind(template, '**'), template=strrep(template, '**', '*'); end;
    
    % find start of wildcard
    wildcard_start = findstr(template, '*');
    
    % throw error if no wildcard
    assert(~isempty(wildcard_start), 'Could not find wildcard');
    
    % get characters that come after wildcard
    post_wildcard_start = wildcard_start+1;
    post_wildcard_template = template(post_wildcard_start:end);
    
    % if there's another wildcard, keep only the characters before it
    next_wildcard_location = findstr(post_wildcard_template, '*');
    if ~isempty(next_wildcard_location)
        post_wildcard_template = post_wildcard_template(1:next_wildcard_location(1)-1);
    end
    
    % if nothing comes after the wildcard, wildcard_end will be the end of the string
    if isempty(post_wildcard_template)
        wildcard_end = length(search_string);
    
    % otherwise, try to match post_wildcard_template in the search text to find the end
    else
        wildcard_end = post_wildcard_start + findstr(search_string, post_wildcard_template)-1;
    end
    
    % get wildcard
    wildcard_str = search_string(wildcard_start(1):wildcard_end(1)-1);
    
end