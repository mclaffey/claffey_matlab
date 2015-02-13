function display(ef)
% Display information about an enum_files object in the command line

    fprintf('\n%s = \n', inputname(1))
    
    fprintf('\t%s\n', ef.template)
    fprintf('\tFound IDs: %s\n', mat2str(get_ids(ef)'))
    fprintf('\n\n')
    
end
    
    