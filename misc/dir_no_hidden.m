%% usage  [output] = dir_no_hidden(input)
% Lists the contents of the directory and excludes hidden files such as ./,
% ../ or .DS_store. This is useful for listing files in a directory which
% need to all be used and you do not have a reasonable wildcard operator.

function [contents] = dir_no_hidden(input_directory)

contents = dir(input_directory);

contents = contents(~strncmp({contents(:).name},'.',1));

end
