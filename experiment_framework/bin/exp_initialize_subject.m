function [edata] = exp_initialize_subject(edata)

    if edata.run_mode.debug
        edata.subject_id = 0;

    else
        next_subject_id = edata.files.behav.next_id;
        edata.subject_id = input(sprintf('What subject number? (Next unused ID is %d - Press ENTER to use): ', next_subject_id));
        if isempty(edata.subject_id), edata.subject_id = next_subject_id; end;
        edata.irb = get_irb_info;
    end

end