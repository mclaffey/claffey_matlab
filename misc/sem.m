function t = sem(y)
% Computes the standard error of the mean (SEM)

    n = size(y,1);
    if n==0
        t = nan(1,size(y,2));
    else
        t = std(y,0,1) / sqrt(n);
    end
end
