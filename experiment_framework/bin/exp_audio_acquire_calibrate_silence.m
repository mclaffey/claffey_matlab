function [edata] = exp_audio_acquire_calibrate_silence(edata)

    repititions = 0;
    when = 0;
    waitForStart = 1; % hold until device really starts
    stopStop=3;
    PsychPortAudio('Stop', edata.audio.port);
    PsychPortAudio('Start', edata.audio.port, repititions, when, waitForStart, stopStop);
    pause(stopStop);
    audio_data = PsychPortAudio('GetAudioData', edata.audio.port);
    
    thresh = prctile(abs(audio_data(:)), .99);
    
    fprintf('Threshold set to %d / billion\n', fix(thresh * 1000 * 1000 * 1000));
    
    edata.audio.thresh = thresh;    

end