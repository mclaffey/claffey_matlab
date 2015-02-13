function [message] = tiff_export(f_handle, tiff_file_name, show_preview)
% Saves a given figure as a high resolution tiff
%
%   tiff_export(f_handle, tiff_file_name, show_preview)
%
%   If f_handle is not provided, the current figure is used.
%
%   If tiff_file_name is not provided, the figure is saved as figure_tiff_export.tif in the current
%   working directory
%
%   If show_preview is not provided, the resulting tiff is shown using the default system
%   application (e.g. Preview for Mac). If this is set to false, the preview is not shown.
%   
% Copyright 2009 Mike Claffey mclaffey[]ucsd.edu
%
% 04/03/09 - cleaned up code and wrote documentation
% 03/17/09 - Happy St. Patricks Day

%% check arguments
    if ~exist('f_handle', 'var'), f_handle = gcf; end;
    if ~exist('tiff_file_name', 'var'), tiff_file_name = fullfile(pwd, 'figure_tiff_export'); end;
    tiff_file_name = change_extension(tiff_file_name, 'tif');
    if ~exist('show_preview', 'var'), show_preview = true; end;

%% check export directory

    tiff_file_dir = fileparts(tiff_file_name);
    if isempty(tiff_file_dir)
        tiff_file_dir = pwd;
        tiff_file_name = [pwd filesep tiff_file_name];
    else
        if ~exist(tiff_file_dir, 'dir')
            fprintf('Making directory for tiff_export: %s', tiff_file_dir);
            mkdir(tiff_file_dir);
        end
    end
    
    
%% export as tiff    
    
    if exist(tiff_file_name, 'file'), delete(tiff_file_name); end;
    print('-dtiff', tiff_file_name, sprintf('-f%d', f_handle), '-r300');
    
%% if requested, show tiff in system (e.g. Preview)    
    if show_preview
        system(sprintf('open ''%s''', tiff_file_name))
    end
    
%% return outcome message
    message = sprintf('Figure exported to %s in %s\n', ...
        link_text('file', tiff_file_name, filename(tiff_file_name)), ...
        link_text('file', fileparts(tiff_file_name)));
    
end