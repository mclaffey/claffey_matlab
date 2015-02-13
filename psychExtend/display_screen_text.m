function [varargout] = display_screen_text(raw_text, screen_pointer, wait_for, font_size, background_color, text_color, margin, font_name)
% Uses PsychToolbox to display long text on full screen
%
% FUNCTION SYNTAX
%   [screen_pointer] = display_screen_text(screen_pointer, raw_text, wait_for, font_size, background_color, text_color, margin, font_name)
%
% ARGUMENTS             TYPE        DEFAULT VALUE
%   raw_text            cell array  Required. (see note below)
%   screen_pointer      integer     if -1, empty or missing, opens a new screen
%   wait_for            string      keyboard (see note below)
%   font_size           integer     36
%   background_color    integer     black (0)
%   text_color          integer     white (255)
%   margin              integer     10% of screen in pixels
%   font_name           string      'Arial'
%
% wait_for - Indicates what user input to wait for before returning control
%    to the executing program. Can be 'keyboard' or 'mouse', or 'any' to
%    respond to both. If the argument is unrecognized, it defaults to keyboard.
%    Setting to 'no wait' flips the screen and returns control to the 
%    executing program. Setting to 'no flip' returns control to the program
%    so that additional graphics can be added to the screen buffer before
%    displaying.
% 
% raw_text - This is a cell array with each paragraphs to display in a separate cell.  
%    It automatically divides the paragraphs up into individual lines
%    according to how big the font is and what will fit on the current
%    display. A blank space is inserted between each paragraph.


% Copyright 2008 Mike Claffey (mclaffey[]ucsd.edu)
%
% 04/23/08 original version
%

%% check the input variables
    % originally the screen_pointer variable was first, followed by the
    % raw_text. If it appears that these arguments were passed in this old
    % order (because the first arguement is a number and the second is a
    % string), then flip them
     if exist('raw_text', 'var') && exist('screen_pointer', 'var') && isnumeric(raw_text) && (ischar(screen_pointer) || iscell(screen_pointer))
        temp_var = raw_text;
        raw_text = screen_pointer;
        screen_pointer = temp_var;
     end

%% if a file is specified for the raw_text argument, see if it can be loaded
    if exist('raw_text', 'var') && ischar(raw_text) && strncmp(raw_text, '//', 2)
        filename = raw_text([3:end]); %#ok<NBRAK>
        fid = fopen(filename);
        if fid < 1, error('could not open filename for string %s', raw_text); end;

        % process each line of the file
        try
            raw_text = {};
            while true
                tline = fgetl(fid);
                if tline == -1, break; end;

                if ~isempty(tline)
                    if length(tline) > 255
                        warning('PsychToolbox will not accept strings over 255 chars long') %#ok<WNTAG>
                    end
                    raw_text{end+1, 1} = tline; %#ok<AGROW>
                end
                tline = fgetl(fid);
            end
        catch
            error('opened filename %s but could not process it', filename)
        end
    end
     
%% setup screen if no pointer was provided

    if ~exist('screen_pointer', 'var') || isempty(screen_pointer) || screen_pointer == -1
        fprintf('\n\nSetting up screen with PsychToolbox\n\n');
        Screen('Preference','VisualDebugLevel',0);
        screen_list=Screen('Screens');
        the_screen = max(screen_list);
        screen_pointer = Screen('OpenWindow', the_screen);
        Screen('Flip', screen_pointer);
    end

%% get variabels about the screen
    [screen_width, screen_height]=Screen('WindowSize', screen_pointer);
    screen_x_center=screen_width/2;
    screen_y_center=screen_height/2;
    black=BlackIndex(screen_pointer); % Should equal 0.
    white=WhiteIndex(screen_pointer); % Should equal 255.
    gray = (black + white) / 2;
    red = [200 0 0] ; %#ok<NASGU>
    green = [0 200 0] ; %#ok<NASGU>
    blue = [0 0 200]; %#ok<NASGU>

%% use default values if parameters were not provided.
    if nargin < 1, raw_text = {'Press any key to continue'}; end;
    %f nargin < 2, ...this has already been handled up above
    if nargin < 3, wait_for = 'keyboard'; end;
    if nargin < 4, font_size = 36; end;
    if nargin < 5, background_color = black; end;
    if nargin < 6, text_color = white; end;
    if nargin < 7, margin = 0.1; end;
    if nargin < 8, font_name = 'Arial'; end;
    if nargin > 8 , error('Too many arguments provided to display_screen_text'); end;

    if margin >= .5, error('the margin must be less than half, you specified %3.2f', margin); end;
    if margin >= .25, warning('a margin of %3.2f is unusually large, .05-.15 is typical', margin); end; %#ok<WNTAG>
    
%% use the parameters to customize the display
    
    % set the font for text
    Screen('TextFont', screen_pointer, font_name);
    Screen('TextSize', screen_pointer, font_size);
    Screen('TextColor', screen_pointer, text_color);
    line_height = font_size * 1.25;
    if margin < 1, margin = fix(screen_width * margin); end;
    text_space_width = screen_width - 2 * margin;
    wait_for = lower(wait_for);

%% reformat the raw_text to displayable_text

    displayable_text = convert_raw_text_to_lines(raw_text);
    
%% display the background & text
    Screen('FillRect', screen_pointer, background_color);
    for text_line = 1:length(displayable_text)
        line_position = margin + text_line * line_height;
        Screen(screen_pointer, 'DrawText', displayable_text{text_line}, margin, line_position, text_color);
    end

%% wait for user response
    switch wait_for
        case 'no flip'
            % use this case if the screen should not be flipped because
            % additional graphics will be displayed.
            % routine doesn't wait for user input and immediately passes
            % control back to the function that called it.
        case 'no wait'
            Screen('Flip', screen_pointer);
        case 'any'
            Screen('Flip', screen_pointer);
            while ~get_mouse_click(0,0.01) && ~get_key_press(0,0.01); end;
        case 'mouse'
            Screen('Flip', screen_pointer);
            get_mouse_click
        otherwise
            Screen('Flip', screen_pointer);
            get_key_press
    end
    
%% return arguments
    if nargout == 1
        varargout = {screen_pointer};
    else
        varargout = {};
    end
    
%% help functions

    function [line_text] = convert_raw_text_to_lines(raw_text)
       if ischar(raw_text), raw_text = {raw_text}; end;
       raw_paragraphs = length(raw_text);
       line_text = {};
       line_index = 1;
       
       for paragraph_index = 1:raw_paragraphs
           % for each paragraph, pull out blocks of texts that will span
           % one line in the display until the entire paragraph has been
           % processed
           raw_paragraph = raw_text{paragraph_index};
           
           % in case the raw text has been "double wrapped" as a cell,
           % convert to a string
           if iscell(raw_paragraph)
               raw_paragraph = raw_paragraph{1};
           end
 
           while ~isempty(raw_paragraph)
               
               new_line = raw_paragraph;
               while text_is_too_wide(new_line, text_space_width)
                   new_line = remove_last_word(new_line);
               end
               
               % add the proper length line to the output cell
               line_text{line_index} = new_line; %#ok<AGROW>
               line_index = line_index + 1;
               
               % remove the processed text from the paragraph
               actual_line_length = length(new_line);
               remaining_text = raw_paragraph(actual_line_length+1:end);
               raw_paragraph = remaining_text;
           end
           
           % add a blank line between paragraphs
           line_text{line_index} = ''; %#ok<AGROW>
           line_index = line_index + 1;

       end
       
    end

    function [out_text] = remove_last_word(in_text)
        out_text = trim_trailing_spaces(in_text);
        if isempty(out_text), return; end;
        if isempty(findstr(out_text, ' ')), return; end;
        
        % now trim the last word of the string
        while ~isempty(out_text) && ~strcmp(out_text(end), ' ')
            out_text = out_text(1:end-1);
        end           
    end

    function [trim_text] = trim_trailing_spaces(trim_text)
        while ~isempty(trim_text) && strcmp(trim_text(end), ' ')
            trim_text = trim_text(1:end-1);
        end
    end

    function [too_wide] = text_is_too_wide(text, max_width_in_pixels)
        normBoundsRect = Screen('TextBounds', screen_pointer, text);
        text_width = normBoundsRect(3);
        if text_width > max_width_in_pixels
            too_wide = 1;
        else
            too_wide = 0;
        end
    end
    
end



