function publish_clean(script_name, file_name, file_format, open_in_system)
% Based on built-in publish command with more robust features
%
% publish_clean(script_name, file_name, file_format, open_in_system)
%
%   script_name - matlab .m file to publish
%
%   file_name - name of file to write to
%
%   file_format - options include html, pdf and latex. If ommited, defaults to html.
%
%   open_in_system - if TRUE or omitted, opens in the system internet browser (instead of matlab web
%   browser). If FALSE, creates file without opening it.

% Copyright 2009-2013 Mike Claffey (mclaffey[]ucsd.edu)
%
% 05/24/13 fixed to open file in windows
% 04/20/10 catch outputs of system(open) command to prevent spill to command line
% 04/05/10 put file name in quotes for open_in_system
% 04/24/09 added documentation
% 03/07/09 original version
    
%% Error checking

    if ~exist('script_name', 'var')
        error('Must provide a script name to publish')
    else
        [script_dir, script_file_name] = fileparts(which(script_name));
        if isempty(script_file_name)
            error('Could not find script: %s to publish', script_name);
        else
            script_name = which(script_name);
        end
    end

    if ~exist('file_name', 'var') || isempty(file_name)
        file_name = fullfile(script_dir, script_file_name);
    end
    if ~exist('file_format', 'var')
        file_format = 'html';
    else
        file_format = lower(file_format);
    end;
    if ~ismember(file_format, {'html', 'latex', 'pdf'}); error('Unrecognized format: %s', file_format); end;

    if ~exist('open_in_system', 'var'), open_in_system = true; end;
    
%% specific publishing options
    if strcmpi(file_format, 'pdf')
        pub_options.format = 'latex';
    else
        pub_options.format = file_format;
    end
    pub_options.outputDir = fileparts(file_name);
    if isempty(pub_options.outputDir), pub_options.outputDir = pwd; end;
    %pub_options.imageFormat = '';
    pub_options.maxHeight = [];
    pub_options.maxWidth = [];
    pub_options.showCode = false;
    pub_options.useNewFigure = false;
    
%% publish
    publish(script_name, pub_options);

%% File handling    
    
    % get rid of extension
    script_name = change_extension(script_name, '');

    % file handling
    switch file_format
        case 'html'
            % rename file
            movefile(sprintf('%s/%s.html', pub_options.outputDir, script_file_name), file_name);
        case 'latex'
            movefile(sprintf('%s/%s.tex', pub_options.outputDir, file_script_name), file_name);
        case 'pdf'
            file_name = tex_to_pdf(sprintf('%s/%s.tex', pub_options.outputDir, script_file_name), file_name);
            delete(sprintf('%s/%s.tex', pub_options.outputDir, script_name));
    end
    
    % open file, if requested
    if open_in_system
        if ispc()
            winopen(file_name);
        else
            [status, message] = system(sprintf('open ''%s''', file_name));
        end
    end    
    
end