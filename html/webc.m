function webc(html_text)
% Capture (display) html text in the web browser
%
%   webc(html_text)
%   
%       Creates a temporary html file containing the html text and displays it
%
%   webc(A)
%
%       When passed variable A of any class, webc calls any2html(a) to attempt to
%       convert it to valid html. It then creates a temp file based on that html
%       output.
%
% See-also: any2html
%

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 07/23/09 assert argument is provided
% 04/21/09 renamed to webc and improved documentation
% 04/16/09 original version

    assert(logical(exist('html_text', 'var')), 'Must provide an argument to display');

%% if the argument is not text, try converting it to html    
    if ~ischar(html_text)
        html_text = any2html(html_text, -1);
    end

%% get a tempfile, write the text    
    temp_file = tempname;
    fid = fopen(temp_file, 'w');
    fwrite(fid, css_header);
    fwrite(fid, html_text);
    fclose(fid);
    
%% display in browser    
    web(temp_file);
    
end
