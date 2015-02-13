% MISC
%
% Conversions
%   any2str                  - Convert any variable to a string    
%   cell2num                 - Function to convert an all-numeric cell array to a double precision array
%   mat2cell_same_size       - Convert a matrix to a cell of the same dimensions

% Shortcuts
%   pre                      - Displays as much information as available about a variable in 10 lines or less
%   dock_by_default          - Sets the figure docking mode
%   whats                    - WHATS(DIR) Lists Matlab files in directory DIR, with hypertext.

% Matrix Manipulations
%   expandmat                - Creates multiple copies of each element in an area
%   nz                       - Replaces empty and NaN values with a default value
%   trim_mat                 - Trims off the highest and lowest percent of values from an array

% Calculations
%   find_longest_streak      - Finds the longest consecutive streak of 1's in a logical array
%   sem                      - Computes the standard error of the mean (SEM)

% Other
%   paired_params            - Converts parameter name-value pairs to structure
%   subject_datafiles        - Function for dealing with multiple subject datafiles with a common naming template

%   assert_field             - Adds a field to a structure if it does not already exist, with an optional default value
%   awaitbar                 - displays waitbar with abort button
%   change_extension         - 
%   duplicates               - Return matrix values that occur more than once
%   ef_demo                  - 
%   ef_test                  - 
%   format_graph             - Set the main properties of an axis with a single command
%   get_irb_info             - Prompt user for irb number, gender, age, handedness and create structure
%   iif                      - Returns one of two possible values depending on the truth of a third argument
%   prev                     - 
%   publish_clean            - Based on built-in publish command with more robust features
%   randperm_chop            - Randomizes an array and only keeps a specified number of elements
%   report                   - 
%   round_decimal            - Round a variable to a given number of decimal places
%   round_percent            - Divides a num by a denom, multiples by 100 and rounds to a number of decimal places
%   sigmoid                  - Sigmoid creates a Sigmoid function using parameters in PARAMS and the 
%   tex_to_pdf               - Convert a TeX file to pdf
%   wait_until               - Wait until a specificied clock time
%   any2cell                 - Convert a variety of datatypes to cell
%   any2html                 - Display any variable as html
%   assert_directory         - Creates a directory and all containing directories as needed
%   assert_vector            - Asserts/manipuates a variable to be a vector in a given direction or returns an error
%   bash                     - Bash command line
%   cdm                      - Change to the directory containing the specified m-file
%   cell2str                 - Convert a cell of strs to a block of text
%   cellfun_easy             - Similar to cellfun but doesn't require the arguments to be same size    
%   command_window_line      - 
%   consecutive_values       - Return a logical array indicating if each value in an array is the same as the previous
%   dir_no_hidden            - usage  [output] = dir_no_hidden(input)
%   exprnd_bounded           - Similar to exprnd except the values can be bound by a mininum/maximum
%   filename                 - 
%   input_restricted         - Based on built-in input() but re-prompts user if answer is not in acceptable list
%   input_yesno              - Prompts user to answer a yes or no question in the command line
%   isscalar_strict          - Improves upon the built-in isscalar to reject datasets, structures, etc
%   link_text                - Creates strings for displaying hyperlinks in the command window
%   many_vars_to_struct      - Takes an unlimited number of arguments and collects them into a structure    
%   menu2                    - Similar to menu, but return the lowercase text of the choice
%   menu_str                 - Modified version of built-in menu function (see 'help menu_str')
%   moving_rms               - Calculating a moving rms value
%   nominal_to_cell          - 
%   randperm_in_groups       - Generate a index that randomizes items in groups of a certain size    
%   randperm_limited_streaks - Randomize a sequence while limiting streaks of the same values
%   repeat_rows_to_total     - Repeats an array vetically to reach the specified number of rows
%   reshape_forced           - 
%   rms                      - Compute root-mean-square
%   round_size_to_text       - Rounds a size in bytes to a text string
%   round_time_to_text       - 
%   str2field_name           - Makes necessary changes to a string so it can be used as a field name
%   str2file_name            - Makes necessary changes to a string so it can be used as a file name
%   str_block2cell           - Takes a single string with line returns and converts it to a Nx1 cell of strings
%   struct_flatten           - Takes a structure and brings all sub fields to the top level
%   tiff_export              - Saves a given figure as a high resolution tiff
%   weighted_mean            - Calculated a weighted average    
