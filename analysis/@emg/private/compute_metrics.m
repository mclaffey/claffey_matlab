function [e, metrics] = compute_metrics(e)
% Used to automatically populate tags.metrics of an emg object
%
% Both AREA and AREA15 are multiplied by 1000, so that if the signal was
% originally in mV, the area metric is is mV*mS. Without this modification,
% the number of decimal places make the area values difficult to read
    
% Copyright 2008 Mike Claffey
% modified Sept 1 2008 mclaffey@ucsd.edu
    
    data = e.data;
    samp_rate = e.time.sampling_rate;
    
    if isempty(data)
        e.tags.metrics = struct('max', NaN, 'min', NaN, 'peak2peak', NaN, 'area', NaN, 'rms', NaN, 'mean', NaN, 'area15', NaN);
    else
        e.tags.metrics.max = max(data);
        e.tags.metrics.min = min(data);
        e.tags.metrics.peak2peak = e.tags.metrics.max - e.tags.metrics.min;
        e.tags.metrics.area = sum(abs(data)) ./ samp_rate * 1000;
        e.tags.metrics.rms = std(data, 1);
        e.tags.metrics.mean = mean(data);
        % area15 - area for first 15 ms only
        length15 = min(length(data), round(0.015 * samp_rate));
        e.tags.metrics.area15 = sum(abs(data(1:length15))) ./ samp_rate * 1000;
    end
    
    metrics = e.tags.metrics;
end