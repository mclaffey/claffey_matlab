function [left_rt, right_rt] = stop1_get_response(edata, td)
    
%% prepare variables    

    keep_checking = true;
    response_was_made = false;
    screen_needs_to_be_cleared = true;
    left_rt = NaN;
    right_rt = NaN;
    if td.trial_type == 'stop' %#ok<STCMP>
        stop_signal_pending = true;
    else
        stop_signal_pending = false;
    end

%% suppress keyboard output
% if in debug mode, don't suppress because it makes it difficult to recover from errors
    if ~edata.run_mode.debug
        ListenChar(2);
    end

%% begin the querying loop
% the querying loop is wrapped in a try-catch structure. if anything goes wrong, we can turn off
% the ListenChar() funciton, which makes it much easier to recoved from errors

    try

        while keep_checking
        
%% check for any response

            if isOSX
                [key_was_pressed, press_time, key_list] = PsychHID('KbCheck', edata.inputs.main_keyboard_index);
            else
                [key_was_pressed, press_time, key_list] = KbCheck();
            end
            
%% if there was a response, record which hand it was            

            if key_was_pressed
                if isnan(left_rt) && key_list(edata.inputs.left_key)
                    left_rt = press_time;
                    response_was_made = true;
                    % if there was a stop signal pending and the subject responded before it, cancel
                    % the stop signal
                    stop_signal_pending = false; 
                end
                if isnan(right_rt) && key_list(edata.inputs.right_key)
                    right_rt = press_time;
                    response_was_made = true;
                    % if there was a stop signal pending and the subject responded before it, cancel
                    % the stop signal
                    stop_signal_pending = false; 
                end
            end

%% clear the screen as soon as the subject responds
% however, the keyboard query will continue until the limited hold to see if they hit other buttons

            if screen_needs_to_be_cleared && response_was_made
                Screen('Flip', edata.display.index);
                screen_needs_to_be_cleared = false;
            end
            
%% if it is time for a stop signal, play it

            if stop_signal_pending && GetSecs > edata.timing.play_stop_signal
                exp_audio_play_stop_signal(edata);
                stop_signal_pending = false;
            end

%% determine if we need to keep checking for responses

            if (GetSecs > edata.timing.end_limited_hold)
                % set keep_checking to false so we exit loop
                keep_checking = false;        
            end
        
%% end the while-loop and try-catch structure

        end
        
        % if needed, clear the screen
        if screen_needs_to_be_cleared
            Screen('Flip', edata.display.index);
        end
        
        ListenChar(0);
        
    catch 
        ListenChar(0);
        clear Screen;
        rethrow(lasterror);
    end
    
end