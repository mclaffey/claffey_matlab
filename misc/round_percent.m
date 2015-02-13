function [x] = round_percent(num, denom, decimal_places)
% Divides a num by a denom, multiples by 100 and rounds to a number of decimal places
%
% [x] = round_percent(num, denom, decimal_places)

    if ~exist('decimal_places', 'var'), decimal_places = 0; end;
    x = round_decimal(num ./ denom .* 100, decimal_places);
end