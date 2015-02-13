function [p_text] = p_value_text(p_value, alpha, show_ns_value)
% Takes a numerical p value and produces descriptive text (p < .05, p < .01, etc)
%
%   [p_text] = p_value_text(p_value [, alpha [, show_ns_value]])
%

% Copyright Mike Claffey 2009 mclaffey[]ucsd.edu
%
% 03/18/09 original version


    if ~exist('alpha', 'var'), alpha = .05; end;
    if ~exist('show_ns_value', 'var'), show_ns_value = true; end;

    if p_value > alpha
        if show_ns_value
            p_text = sprintf('p = %0.2f', p_value);
        else
            p_text = 'n.s.';
        end
    elseif p_value < 0.001
        p_text = 'p < .001';
    elseif p_value < 0.01
        p_text = 'p < .01';
    elseif p_value < 0.05
        p_text = 'p < .05';
    else
        p_text = sprintf('p = %0.2f', p_value);
    end
end