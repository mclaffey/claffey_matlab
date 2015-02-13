function [move_direction] = joystick_calc_move_direction(joystick_position_array, percent_move_threshold)
% Calculates move direction given deflection and angle thresholds    
%

% Copyright 2008 Mike Claffey (mclaffey[]ucsd.edu)
%
% 01/23/08 original version
%

    joystick_count = size(joystick_position_array, 3);
    sample_count = size(joystick_position_array, 1);
    move_direction = NaN(1, joystick_count);
    degrees_per_direction = 180;
    
    for sample_index = 1:sample_count
        for joystick_number = 1:joystick_count
            
            % if a direction has not yet been calculated for the given
            % joystick...
            if isnan(move_direction(joystick_number))

                % calculate its current movement
                x_pos = joystick_position_array(sample_index, 2, joystick_number);
                if isnan(x_pos), x_pos = 0; end;
                y_pos = joystick_position_array(sample_index, 3, joystick_number);
                if isnan(y_pos), y_pos = 0; end;
                xy_radius = sqrt( (x_pos^2) + (y_pos^2) );
                
                % if it is crossing the threshold for the first time...
                if xy_radius > percent_move_threshold
                    
                    % calculate the direction in degrees
                    move_direction_in_radians = cart2pol(x_pos, y_pos);
                    move_direction_in_degrees = move_direction_in_radians * (360 / (2 * pi));
                    move_direction_in_degrees_rounded = round(move_direction_in_degrees/degrees_per_direction) * degrees_per_direction;
                    if move_direction_in_degrees_rounded < 0, move_direction_in_degrees_rounded = move_direction_in_degrees_rounded + 360; end;
                    move_direction(joystick_number) = move_direction_in_degrees_rounded;
                end
            end
        end
    end
end
    
