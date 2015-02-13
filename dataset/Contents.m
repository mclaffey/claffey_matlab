% Dataset Extension Functions
%   Helper functions for common manipulations of the matlab dataset class
%
% Copyright (C) 2008 Mike Claffey
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.% 
%
%
% Files
%   dataset_add_columns     - Add multiple columns to a dataset with default values
%   dataset_append          - Adds observations similar to vertcat, but creates new fields as needed
%   dataset_append_varnames - Append prefix and/or suffix to column names of a dataset
%   dataset_grp2idx         - Creates an index column from grouping columns
%   dataset_merge_columns   - Creates a column by merging values in each row across several columns
%   dataset_rename_column   - Rename the columns of a dataset
%   dataset_slices          - Organizes data by various dimensions for online analysis
%   dataset_to_csv          - Exports a dataset as a csv
%   dataset_trim            - Trims upper and lower rows from groups within a dataset
%   spss_export             - Export a matrix, cell or dataset to SPSS
%   dataset_encompass       - Expands a dataset to include all the columns of another dataset
