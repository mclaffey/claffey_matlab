function [pdf_file] = tex_to_pdf(tex_file, pdf_file)
% Convert a TeX file to pdf

% Modified from http://www.mathworks.com/support/solutions/data/1-OVNVK.html

    tex_file = change_extension(tex_file, 'tex');
    if ~exist('pdf_file', 'var'), pdf_file = tex_file; end;

    % get data on tex file
    if ~exist(tex_file, 'file'), error('TeX file does not exist: %s', tex_file); end;
    [tex_dir, tex_name] = fileparts(tex_file);    

    % get pdf data and insure proper extension
    [pdf_dir, pdf_name, pdf_ext] = fileparts(pdf_file);
    if isempty(pdf_dir), pdf_dir = tex_dir; end;
    pdf_file = change_extension(fullfile(pdf_dir, pdf_name), 'pdf');
    
    % Do LaTeX processing in system
    cmd = [ ...
        'PATH="/usr/texbin:$PATH" && ', ...                 % Get TeX in the path
        sprintf('cd %s && ', tex_dir), ...                  % Change to the directory
        sprintf('latex %s && ', tex_file), ...              % Generate dvi file
        sprintf('dvipdfm %s', fullfile(tex_dir, tex_name)) ... % Generate pdf file from dvi
        ];
    [status, output] = system(cmd);
    
    
    if status
        fprintf(output);
        error('Encountered an error (above) while processing latex commands');
    end
    
    % Rename pdf file
    default_pdf = sprintf('%s.pdf', fullfile(tex_dir, tex_name));
    if ~strcmpi(default_pdf, pdf_file)
        movefile(default_pdf, pdf_file);
    end
    
    % Clean up intermediate files
    delete(change_extension(tex_file, 'aux'));
    delete(change_extension(tex_file, 'dvi'));
    delete(change_extension(tex_file, 'log'));
    
end