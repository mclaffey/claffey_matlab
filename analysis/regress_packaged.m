function [reg_stats] = regress_packaged(a, b)
% Perform regression on two vectors and return structure of statistics
%
% [reg_stats] = regress_packaged(a, b)
%

% Copyright 2009 Mike Claffey
% 06/02/09 added is_sig and result field, removed extra fields, help documentation
% 04/02/09 original version

    % adds a column of ones to b
    b = [ones(size(b,1),1), b];
    
    [bval,bint,residuals,rint,stats] = regress(a, b);
    
    reg_stats.is_sig = [];
    reg_stats.result = '';
    reg_stats.slope = bval(2);
    reg_stats.intercept = bval(1);
    reg_stats.r_squared = stats(1);
    reg_stats.r = sqrt(reg_stats.r_squared) * sign(reg_stats.slope);
    reg_stats.f_value = stats(2);
    reg_stats.p = stats(3);
    reg_stats.raw_data = [a, b];
    reg_stats.means = mean(reg_stats.raw_data);
    
    reg_stats.is_sig = reg_stats.p < 0.05;
    if reg_stats.is_sig
        reg_stats.result = sprintf('Correlation is SIGNIFICANT, r=%1.2f, %s', reg_stats.r, p_value_text(reg_stats.p));
    else
        reg_stats.result = sprintf('Correlation is not significant, r=%1.2f, %s', reg_stats.r, p_value_text(reg_stats.p));
    end


end
    