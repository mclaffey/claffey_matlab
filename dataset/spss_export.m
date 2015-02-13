function spss_export(varargin)
% Export a matrix, cell or dataset to SPSS
%
% Creates a tab delimited text file and an SPSS syntax file for importing it
%
% spss_export(DATA [,COLUMN_NAMES, FILE_NAME, OPEN_IN_SPSS])
%
% DATA is the matrix, cell or dataset to export
%
% COLUMN_NAMES is a cell array listing the variable names for each column
%   of data. If DATA is a dataset, the dataset column names are used by
%   default. For matrices and cells, default strings are created if
%   COLUMN_NAMES is empty.
%
% FILE_NAME is the path and file name to export to. If no extension is
%   provided, the txt extension is appended. If an existing directory is
%   provided instead of a file name, the name of the DATA variable is used
%   for the file name in the given directory. If FILE_NAME equals the
%   string '?', a file dialogue box is provided.
%
% OPEN_IN_SPSS is an optional boolean. If TRUE, the file is immediate
%   opened in SPSS.

% Copyright 2008, 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 11/03/09 added support for ordinals
% 10/29/09 fixed bug with logicals again, not sure how long the 09/04/09
%          fix was busted
% 09/20/09 handled columns of structure (export as string '[struct]')
%          explicitly declare scale type in spss for numeric columns
% 11/03/08 space was treated as a delimited, removed for proper handling of strings
%          nominals have correct field width
% 10/22/08 fixed bug with cell export
% 09/04/08 added capability for logicals and long strings

%% input variables
    if nargin == 0
        error('Must provide a variable to export')
    elseif nargin > 4
        error('Too many arguments provided')
    end

    % get the data
    if nargin >= 1
        data = varargin{1};
        col_names = {};
        if isa(data, 'dataset'), col_names = get(data, 'VarNames'); end;
    end
    
    % column names
    if nargin >= 2 && ~isempty(varargin{2})
        col_names = varargin{2};
        if length(col_names) ~= size(data, 2)
            error('Number of column names does not match number of columns')
        end
    end
    
    % export file name
    path_name = [];
    data_name = [];
    data_extension = [];
    if nargin >= 3 && ~isempty(varargin{3})
        if isequal(varargin{3}, '?')
            % file dialog box
            [data_name, path_name] = uiputfile({'*.txt';'*.csv';'*.*'},'Save output for SPSS Import');
            if data_name==0, return; end;
            [junk, data_name, data_extension] = fileparts(data_name);
            if isempty(data_extension), data_extension = 'txt'; end;
        else
            % use provided argument
            data_name = varargin{3};
            [path_name, data_name, data_extension] = fileparts(data_name);
        end
    end
    % fill in missing pieces with defaults
    if isempty(path_name), path_name = pwd; end;
    if path_name(1)~='/', path_name = [pwd '/' path_name]; end;
    if path_name(end)~='/', path_name = [path_name '/']; end;
    if isempty(data_name), data_name = inputname(1); end;
    if isempty(data_extension), data_extension = '.txt'; end;
    % create full file names
    data_file_name = sprintf('%s%s%s', path_name, data_name, data_extension');
    syntax_file_name = sprintf('%s%s.sps', path_name, data_name');
    
    % open in spss
    if nargin >= 4
        open_in_spss = varargin{4};
    else
        open_in_spss = false;
    end

%% check export directory
    
    if ~exist(path_name, 'dir')
        mkdir(path_name);
    end
    
%% open data file for writing
    fid = fopen(data_file_name, 'w');
    if fid < 0
        error('spss_export:couldnt_write', 'Could not write to file: %s', data_file_name);
    end

%% export column names
    col_count = length(col_names);
    
    if isempty(col_names)
        col_names = cell(1, col_count);
        for col = 1:col_count
            col_names{col} = sprintf('var_%d', col);
        end
    end
    
    for col = 1:col_count
        fprintf(fid, col_names{col});
        if col < col_count, fprintf(fid, '\t'); end;
    end
    fprintf(fid, '\n');

%% export data: case 1 - numeric matrix
    if isnumeric(data)
        for row = 1:size(data, 1)
            for col = 1:col_count
                fprintf(fid, num2str(data(row, col)));
                if col < col_count, fprintf(fid, '\t'); end;
            end
            fprintf(fid, '\n');
        end

%% export data: case 2 - cell or dataset
    else
        for row = 1:size(data, 1)
            for col = 1:col_count
                str = data{row, col};
                if isa(str, 'nominal') || isa(str, 'ordinal')
                    str = char(str);
                elseif isstruct(str)
                    str = '[struct]';
                elseif isnan(str)
                    str = '';
                elseif islogical(str)
                    str = iif(str, 'true', 'false');
                elseif isnumeric(str)
                    str = num2str(str);
                end;
                fprintf(fid, str);
                if col < col_count, fprintf(fid, '\t'); end;
            end
            fprintf(fid, '\n');
        end
    end

%% terminate data file

    fclose(fid);
    
%% open syntax file for writing 
    fid = fopen(syntax_file_name, 'w');
    if fid < 0
        error('spss_export:couldnt_write', 'Could not write to file: %s', syntax_file_name);
    end

%% create syntax file

    % create a variable to record which variables need to be explicitly declared as
    %   scale variables for spss
    scale_variables = zeros(length(size(data, 2)));

    fprintf(fid,'GET DATA\n');
    fprintf(fid,'   /TYPE = TXT\r\n');
    fprintf(fid,'   /FILE = ''%s''\r\n ', data_file_name);
    fprintf(fid,'   /DELCASE = LINE\r\n');
    fprintf(fid,'   /DELIMITERS = "\\t"\r\n');
    fprintf(fid,'   /ARRANGEMENT = DELIMITED\r\n');
    fprintf(fid,'   /FIRSTCASE = 2\r\n');
    fprintf(fid,'   /IMPORTCASE = ALL\r\n');
    fprintf(fid,'   /VARIABLES =\r\n');
        
    % column names and variable format
    if isnumeric(data)
        % numeric matrix
        
        % all variables are scale variables
        scale_variables(:) = 1;
        
        % helper function for finding integers
        is_whole_number = @(x) (rem(x,1)==0);
        
        for col=1:size(data, 2)
            if all(arrayfun(is_whole_number, data(:, col)))
                fprintf(fid,'\t%s F12.0\n', col_names{col});
            else
                fprintf(fid,'\t%s F12.4\n', col_names{col});
            end
        end
    else
        % cells and datasets

        % helper function for finding integers
        is_whole_number = @(x) isnumeric(x) && rem(x,1)==0;
        
        for col=1:size(data, 2)
            if iscell(data)
                % if data is a cell, pull out a column
                data_col = data(:,col);
            else
                % otherwise it is a dataset and column may need conversion
                var_names = get(data,'VarNames');
                data_col = data.(var_names{col});
                if iscell(data_col)
                    % do nothing
                elseif isa(data_col, 'nominal') || isa(data_col, 'ordinal')
                    data_col = cellstr(char(data_col));
                elseif isnumeric(data_col) || islogical(data_col)
                    data_col = mat2cell_same_size(data_col);
                elseif isstruct(data_col)
                    data_col = {'[struct]'};
                else
                    fprintf('Unknown type\n')
                    keyboard
                end
            end
            
            if all(cellfun(is_whole_number, data_col)) % whole numbers
                fprintf(fid,'\t%s F12.0\n', col_names{col});
                scale_variables(col)=1;
            elseif all(cellfun(@isnumeric, data_col)) % all decimal numbers
                fprintf(fid,'\t%s F12.4\n', col_names{col});
                scale_variables(col)=1;
            elseif all(cellfun(@islogical, data_col)) % logicals
                fprintf(fid,'\t%s F1.0\n', col_names{col});
            else
                string_length = max(vertcat(cellfun(@length,data_col), 8)); % strings
                fprintf(fid,'\t%s A%d\n', col_names{col}, string_length);
            end
        end
    end
        
    fprintf(fid,'   .\r\n');
    fprintf(fid,'CACHE.\r\n');
    fprintf(fid,'EXECUTE.\r\n');
    fprintf(fid,'SAVE OUTFILE=''%s%s.sav'' \r\n', path_name, data_name);
    fprintf(fid,'   /COMPRESSED.\n');
    fprintf(fid,'DATASET NAME %s WINDOW=FRONT.\n', data_name);
    
    % declare scale variables.
    if any(scale_variables)
        fprintf(fid, '\nVARIABLE LEVEL\n');
        for col = find(scale_variables);
            fprintf(fid, '  %s(SCALE)\n', col_names{col});
        end
        fprintf(fid, '.\nEXECUTE.\n');
    end
    
    fclose(fid);

%% terminate

    fprintf('Variable ''%s'' exported to %s\n', inputname(1), data_file_name);
    
    if open_in_spss
        system(sprintf('open %s', syntax_file_name));
    end
