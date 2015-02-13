function [edata, trial_data, loaded_from_workspace] = exp_admin_load_vars
    
    try
        edata = evalin('base', 'edata');
        trial_data = evalin('base', 'trial_data');
        loaded_from_workspace = true;
    catch
        edata = exp_initialize_edata;
        trial_data = [];
        loaded_from_workspace = false;
    end

end