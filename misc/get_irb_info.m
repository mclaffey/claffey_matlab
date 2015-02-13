function [irb_info] = get_irb_info()
% Prompt user for irb number, gender, age, handedness and create structure

    irb_info.irb_number = input('Enter IRB number: ', 's');
    irb_info.gender = input('Enter gender: ', 's');
    irb_info.age = input('Enter age: ');
    irb_info.handedness = input('Enter handedness (''l'' or ''r''): ', 's');
    irb_info.experimenter = input('Name of experimenter: ', 's');
    irb_info.time = datestr(now);
end