function display(t)
    
    %fprintf('\n')
    fprintf('%s = \n', inputname(1));
    %fprintf('\n')
    fprintf('\t Start: \t %1.4f \n', t.start);
    fprintf('\t End: \t\t %1.4f (Last point at %1.4f) \n', t.start + t.duration, last_point(t));
    fprintf('\t Duration: \t %1.4f \n', t.duration);
    fprintf('\n')
    fprintf('\t Sampling Freq:\t %5.1f Hz (%1.0f points)\n', t.sampling_rate, t.points);
    fprintf('\n')
end