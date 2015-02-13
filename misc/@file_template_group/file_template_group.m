function [ftg] = file_template_group(base_dir)
% Consructor function for file_template_group
%
%   [ftg] = file_template_group(base_dir)
%
% .base_dir				- directory from which all relative paths are built
% .file_types.name		- name to identify file type
% .file_types.template	- template to produce file of given file_type
%
% Copyright 2009 Mike Claffey
%
% 10/16/09 original version

    ftg.base_dir = base_dir;
    ftg.file_types.name = [];
    ftg.file_types.template = [];
    ftg.file_types(1) = [];

    ftg = class(ftg, 'file_template_group');

end