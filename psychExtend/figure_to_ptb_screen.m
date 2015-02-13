function figure_to_ptb_screen(f_handle, w, screen_size)
% Display a figure as an image using the PsychToolbox Putimage command
%
%   figure_to_ptb_screen(FIGURE_HANDLE, SCREEN_POINTER, [SCREEN_SIZE])

% Copyright Mike Claffey 2009 (mclaffey[]ucsd.edu)
%
% 02/19/09 original version
        

%% check arguments
    assert(ishandle(f_handle), 'First argument must be a figure handle');
    assert(logical(exist('w', 'var')), 'Second argument must be a valid screen pointer');
    if ~exist('screen_size', 'var')
        [screen_width, screen_height] = Screen('WindowSize', w);
    else
        assert(isnumeric(screen_size), 'Third argument must be a two-element numeric array');
        screen_width = screen_size(1);
        screen_height = screen_size(2);    
    end


%% get an image of the figure

    file_name = sprintf('temp_figure_to_ptb_screen');
    print(f_handle, '-dtiff', file_name);
    f_image = imread(file_name, 'tiff');
    delete([file_name '.*'])
    
%% scale the image for the screen    
    f_image_size = size(f_image);
    image_scale_percentage = min([1, .8 * screen_height / f_image_size(1), .8 * screen_width / f_image_size(2)]);    
    new_f_image_size = round(f_image_size(1:2) * image_scale_percentage);
    old_warnings = intwarning('off'); % turn off integer warnings for now, speeds up calculations
    f_image = imresize(f_image, new_f_image_size);
    intwarning(old_warnings); % revert to old warning state
    
    f_image_size = size(f_image);
    image_height = f_image_size(1);
    image_width = f_image_size(2);
    

%% center the image on the screen
    img_coords = [0 0 image_width image_height] + repmat([(screen_width-image_width)/2 (screen_height-image_height)/2], 1, 2);
    Screen(w, 'PutImage', f_image, img_coords);

end