function PsychPortAudio_close_all_ports
    for x = 1:10
        try
            evalc('PsychPortAudio(''Close'', x);');
        end
    end
end
    