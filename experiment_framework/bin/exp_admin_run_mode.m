function [edata] = exp_admin_run_mode(edata)
    
    run_mode = input_restricted('Run mode? (d=debug, ENTER for normal): ', {'d', 'n'}, 'n');

    % debug - typically provides verbose feedback while running
    edata.run_mode.debug = any(strfind(lower(run_mode), 'd'));
    
    % simulate - generates data automatically (not yet implemented)
    edata.run_mode.simulate = any(strfind(lower(run_mode), 's'));
    
end
