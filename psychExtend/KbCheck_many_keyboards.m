function [KeyIsDown, press_time, keyCode] = KbCheck_many_keyboards(keyboard_pointers)
% Perform KbCheck on multiple keyboards using for loop
%
%   [KeyIsDown, press_time, keyCode] = KbCheck_many_keyboards(keyboard_pointers)
%

% Copyright Mike Claffey (mclaffey[]ucsd.edu)
%
% 05/05/09 fixed substantial bug with max(keyCode, [], 1)
% 04/27/09 compatibility with pc
% 03/07/09 original version

    if isempty(keyboard_pointers) || all(keyboard_pointers == 0) || ispc
        [KeyIsDown, press_time, keyCode] = KbCheck();
    elseif length(keyboard_pointers) == 1
        [KeyIsDown, press_time, keyCode] = KbCheck(keyboard_pointers);
    else
        KeyIsDown = []; press_time=[]; keyCode=[];
        for x = 1:length(keyboard_pointers)
            [KeyIsDown(x), press_time(x), keyCode(x,:)] = KbCheck(keyboard_pointers(x)); %#ok<AGROW>
        end
        KeyIsDown = any(KeyIsDown);
        press_time = min(press_time);
        keyCode = max(keyCode, [], 1);
    end

end