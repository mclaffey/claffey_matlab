% Various functions for frequent drawing routines
% Many of these functions are dependent on one another, so it may be
%   advisable to copy the entire code into the calling function
% all functions use the 'w' as the screen pointer

function drawing_functions(varagin) %#ok<INUSD>
    if nargin < 1
        menu_text = 'This function does not perform any action, it only contains subfunctins which are useful for copying into other programs. Would you like to view the code itself?';
        open_code = menu(menu_text,'Yes','No');
        if open_code == 1
            edit drawing_functions.m
        end
    end
    
%% setup screen

    keyboard
    w = setup_screen;
    display_outlined_character('<', 144)
    Screen('flip', w)


    function [w] = setup_screen()
        % use PsychToolbox to initialize the screen
        Screen('Preference','VisualDebugLevel',4);  %% sets calibration level for screen
        fprintf('Setting up screen with PsychToolbox\n');
        screen_list=Screen('Screens');
        the_screen=max(screen_list);
        w=Screen('OpenWindow', the_screen);
        Screen('Flip',w);
        
        Screen('TextFont', w, 'Arial');
        Screen('TextSize', w, 36);
        Screen('TextColor', w, BlackIndex(w));

    end


%% basic shapes

    function draw_rec(dim_array, color)
        Screen('FillRect', w, color, dim_array);
    end

    function draw_black_rec(dim_array)
        draw_rec(dim_array, BlackIndex(w))
    end

    function draw_white_rec(dim_array)
        draw_rec(dim_array, WhiteIndex(w))
    end

    function draw_gray_rec(dim_array)
        draw_rec(dim_array, (WhiteIndex(w) + BlackIndex(w))/2)        
    end

    function draw_red_rec(dim_array)
        draw_rec(dim_array, [255 0 0])        
    end

    function draw_green_rec(dim_array)
        draw_rec(dim_array, [0 255 0])        
    end

    function draw_blue_rec(dim_array)
        draw_rec(dim_array, [0 0 255])        
    end

%% background

    function draw_background(bg_color)
        Screen('FillRect', w, bg_color);
    end

    function draw_white_background()
        Screen('FillRect', w, WhiteIndex(w));
    end

    function draw_black_background()
        Screen('FillRect', w, BlackIndex(w));
    end

%% advanced shapes

    function draw_fixation_cross(cross_length, cross_thickness, cross_color)
        if nargin < 1, cross_length = 10; end;
        if nargin < 2, cross_thickness = 1; end;
        if nargin < 3, cross_color = BlackIndex(w); end;

        draw_rec(center_rec_on_screen(cross_thickness, cross_length), cross_color) % vertical line
        draw_rec(center_rec_on_screen(cross_length, cross_thickness), cross_color) % horiztonal line
    end


    function draw_border_rec(dim_array, thickness, border_color, inside_color)
        % If THICKNESS is positive, the border is drawn outwards from the
        % DIM_ARRAY. If it is negative, it is drawn inwards.
        if thickness > 0
            inside_dim_array = dim_array;
            outside_dim_array = offset_dim_array(dim_array, thickness);
        else
            outside_dim_array = dim_array;
            inside_dim_array = offset_dim_array(dim_array, thickness);
        end
        draw_rec(outside_dim_array, border_color);
        draw_rec(inside_dim_array, inside_color);
    end

    function draw_thin_black_border_rec(outside_dim_array)
        draw_border_rec(outside_dim_array, -2, BlackIndex(w), WhiteIndex(w))
    end

%% text
    

    function display_centered_white_text(text, font_size)
        if nargin < 2, font_size = 0; end;
        display_centered_text(text, font_size, WhiteIndex(w), BlackIndex(w))
    end
    
    function display_centered_black_text(text, font_size)
        if nargin < 2, font_size = 0; end;
        display_centered_text(text, font_size, BlackIndex(w), WhiteIndex(w))
    end
    
    function display_centered_text(text, font_size, font_color, background_color)
        old_font_size = 0;
        if nargin >= 2 && font_size ~= 0, old_font_size = Screen('TextSize', w, font_size); end;
        if nargin < 3, font_color = BlackIndex(w); end
        if nargin < 4, background_color = WhiteIndex(w); end;

        text_bounds = Screen('TextBounds', w, text);
        text_dim_array = center_rec_on_screen(text_bounds(3), text_bounds(4));
        y_pos = text_dim_array(1);
        x_pos = text_dim_array(2);
        draw_background(background_color);
        Screen('DrawText', w, text, x_pos, y_pos, font_color, background_color);
        if old_font_size ~= 0; Screen('TextSize', w, old_font_size); end;
    end

    function display_outlined_character(display_char, font_size)
        if nargin < 2, font_size = 175; end;
        old_font_size = Screen('TextSize', w, font_size);
        text_bounds = Screen('TextBounds', w, display_char);
        text_dim_array = center_rec_on_screen(text_bounds(3), text_bounds(4));
        y_pos = text_dim_array(1);
        x_pos = text_dim_array(2);

        draw_black_background();
        for x = -10:10
            for y = -3:3
                Screen('DrawText', w, display_char, x_pos + x, y_pos + y, WhiteIndex(w), BlackIndex(w));
            end
        end
        Screen('DrawText', w, display_char, x_pos, y_pos, BlackIndex(w), WhiteIndex(w) );
        Screen('TextSize', w, old_font_size);
    end


%% functions that calculate the placement of coordinates of rectangles

    function [dim_array] = center_rec_at_coordinate(y_pos, x_pos, rec_width, rec_height)
        % returns the coordinates of a rectangle of the specified width and
        % height centered over the given point on the screen
        left_edge = x_pos - (rec_width / 2);
        right_edge = x_pos + rec_width;
        top_edge = y_pos - (rec_height / 2);
        bottom_edge = y_pos + rec_height;
        dim_array = fix([top_edge left_edge bottom_edge right_edge]);
    end

    function [dim_array] = center_rec_on_screen(rec_width, rec_height)
        % returns the coordinates of a rectangle of the specified width and
        % height centered on the screen
        [screen_width, screen_height]=Screen('WindowSize', w);
        dim_array = center_rec_at_coordinate(screen_height/2, screen_width/2, rec_width, rec_height);
    end

    
    function [new_array] = offset_dim_array(dim_array, offset)
       % DIM_ARRAY is the coordinates for a rectangle in form [left, top, right, bottom]
       % offset_dim_array returns a dim_array that is either larger or
       % smaller by OFFSET pixels (positive values mean larger)
       new_array = dim_array + [-offset -offset offset offset];
    end
    
end