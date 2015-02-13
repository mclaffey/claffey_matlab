function [b] = moving_rms(a, bin_size)
% Calculating a moving rms value

    if bin_size==1, b=a; return; end;

    % make a horizontal vector
    a = assert_vector(a, 2);
    
    % pad the end with nan's
    a = [a, nan(1, bin_size)];

    % replicate a for as many rows as specificed by bin_size
    a = repmat(a, bin_size, 1);
    
    % shift each row incrementally
    for x = 1:bin_size
        a(x, :) = circshift(a(x,:), [0 x-1]);
    end
    
    % now calculate rms all at once
    a = a .^ 2;
    a = mean(a);
    b = sqrt(a);
    
    
%     a_length = length(a);
%     b = nan(1, a_length);
%     for x = 1:(a_length-bin_size+1);
%         bin_data = a(x:x+bin_size-1);
%         b(x) = rms(bin_data);
%     end

end