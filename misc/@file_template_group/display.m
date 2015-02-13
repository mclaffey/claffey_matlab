function display(ftg)
% Display information about a file_template_group in the command line

    fprintf('\n%s = \n', inputname(1))
    
    fprintf('\tBase directory: %s\n', ftg.base_dir);
    
    if isempty(ftg.file_types)
        fprintf('\tFile types: none\n');
    else
        fprintf('\tFile types:\n');
        for x = 1:length(ftg.file_types)
            fprintf('\t\t%s (%s)\n', ftg.file_types(x).name, ftg.file_types(x).template);
        end
    end
    fprintf('\n\n')
    
end
    
    