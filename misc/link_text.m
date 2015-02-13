function [link_text] = link_text(link_mode, URL, link_text)
% Creates strings for displaying hyperlinks in the command window
%
% [link_text] = link_text(link_mode, URL, link_text)
%
%   link_mode can be either:
%       'edit' or 'm' - opens the .m file specified by URL for editing
%       'file' - opens the file/directory specified by URL in the system (e.g. finder)
%       'web' - opens the URL in matlab's webbrowser
%
% Example:
%    link_text('edit', 'link_text.m', 'edit this script')
%
%    link_text('file', pwd, 'this directory')
%
%    link_text('web', 'www.google.com', 'search engine')
%
%    link_text('matlab', '1+1', 'show the number two')
%

% Copyright Mike Claffey (mclaffey[]ucsd.edu)
%
% 12/19/10 fixed edit option to handle file names with spaces
% 04/10/09 minor change in documentation
% 03/12/09 added matlab link_mode
% 03/02/09 original version

    
    if ~exist('link_text', 'var') || isempty(link_text), link_text = URL; end;
    
    switch link_mode
        case 'edit'
            link_text = sprintf('<a href="matlab: edit ''%s''">%s</a>', URL, link_text);
            
        case 'file'
            link_text = sprintf('<a href="matlab: system('' open ''''%s'''' '')">%s</a>', URL, link_text);
            
        case 'web'
            link_text = sprintf('<a href="http://%s">%s</a>', URL, link_text);
            
        case 'matlab'
            link_text = sprintf('<a href="matlab: %s">%s</a>', URL, link_text);
            
        otherwise
            error('Unrecognized LINK_MODE argument: %s', link_mode)
            
    end
    
end