function exp_analysis_open_html(edata, trial_data)
   
    html_file = edata.files.html(edata.subject_id);
    
    if ~exist(html_file, 'file')
        exp_analysis_publish(edata, trial_data);
    end
                
    % try opening with a system command, doesn't always work with PC
    [command_failed] = system(sprintf('open %s', html_file));
    if command_failed
        % otherwise open within matlab browser
        open(html_file);
    end
    
end