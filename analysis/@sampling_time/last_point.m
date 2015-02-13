function [last_point] = last_point(t)
    if t.duration == 0
        last_point = t.start;
    else
        last_point = t.start + t.duration - (1 / t.sampling_rate);
    end
end