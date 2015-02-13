function [edata, audio_data] = exp_audio_acquire_audio_response(edata)
% Continue querying audio until input goes above edata.audio.thresh

%% initialize

    audio_data = 0;
    audio_sample = 0;

    % specify amount to sample repeated to detect audio inpur
    sample_size_secs = 0.1;
    sample_size_n = sample_size_secs * edata.audio.freq;
    
    % specify maximum amount of total audio to accept even if audio levels
    % haven't returned to baseline
    max_input_duration = 3; % seconds
    
    % amount to pad before and after edata.audio.thresh crossings
    front_pad_secs = 0.1;
    back_pad_secs = 0.1;
    
    % edata.audio.thresh to detect audio input    
    thresh = .1;
    
%% start audio recording    
    
    repititions = 0;
    when = 0;
    waitForStart = 1; % hold until device really starts
    PsychPortAudio('Start', edata.audio.port, repititions, when, waitForStart);

%% wait until audio input goes over edata.audio.thresh

    while prctile(audio_sample, .99) < edata.audio.thresh
        
        audio_data = PsychPortAudio('GetAudioData', edata.audio.port);
        if size(audio_data, 2) > sample_size_n
            audio_sample = abs(audio_data(1, 1:sample_size_n));
        end
        
        audio_peak = prctile(audio_sample, .99);
        fprintf('%f\t%d\n', audio_peak / edata.audio.thresh, audio_peak * 1000 * 1000);        
    end
    
%% wait until the input goes under edata.audio.thresh

    max_input_time = GetSecs + max_input_duration;
    keep_sample = true;
    below_time_limit = 0.5;
    below_time_end = NaN;    
    
    while keep_sample
        audio_data = PsychPortAudio('GetAudioData', edata.audio.port);
        if size(audio_data, 2) > sample_size_n
            audio_sample = abs(audio_data(1, end-sample_size_n:end));
        end
        
        fprintf('%f\t%d\n', audio_peak / edata.audio.thresh, audio_peak * 1000 * 1000);        

        current_sample_below = prctile(audio_sample, .99) < edata.audio.thresh       
        
        if current_sample_below
            if isnan(below_time_end)
                below_time_end = GetSecs + below_time_limit;
            else
                if GetSecs > below_time_end
                    keep_sampling = false;
                end
            end
        else
            below_time_end = NaN;
        end
            
        
        if GetSecs > max_input_time
            keep_sampling = false;
        end
    end
    
%% download full sound buffer

    audio_data = PsychPortAudio('GetAudioData', edata.audio.port);
    PsychPortAudio('Stop', edata.audio.port);    

%% trim
    
    front_pad_n = front_pad_secs * edata.audio.freq;
    back_pad_n = back_pad_secs * edata.audio.freq;
    
    chan_1_rectified = abs(audio_data(1, :));
    
    detect_start = find(chan_1_rectified > thresh, 1, 'first');
    clip_start = max(detect_start - front_pad_n, 1);
    
    detect_end = find(chan_1_rectified > thresh, 1, 'last');
    clip_end = min(detect_end - front_pad_n, length(chan_1_data));
    
    audio_data = audio_data(:, clip_start:clip_end);
    
%%
end