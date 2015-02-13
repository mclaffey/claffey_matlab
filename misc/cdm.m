function cdm(m_file_name)
% Change to the directory containing the specified m-file
%
% cdm('pathdef.m')
%
% cdm pathdef    % this version will also work at the command line
%
% Copyright 2009 Mike Claffey
%
% 05/20/09 original version

    assert(ischar(m_file_name), 'Argument must be a string');
    m_file_name = change_extension(m_file_name, 'm');
    m_file_path = which(m_file_name);
    if isempty(m_file_path)
        error('Can not find file: %s\n', m_file_name);
    end
    cd(fileparts(m_file_path));
end