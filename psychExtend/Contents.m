% PsychExtend
%   Helper functions extending the functionality of PsychToolbox
%
% Copyright (C) 2008 Mike Claffey
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.% 
%
%
% Input Devices
%   input_device_by_prompt       - Prompts the user to activate a device and returns the relevant index
%   input_device_find            - Find input device numebers using criteria
%   input_device_keyboard        - Returns the index of the first full keyboard found, ignoring keypads
%   input_device_list            - Builds a cell of which input devices are connected and active
%   input_device_report          - Displays a report of which input devices are connected and active
%   get_key_press                - Waits for user input from keyboard with customizable options
%   get_mouse_click              - Waits for a mouse click, with options for having a maximum
%   get_simultaneous_key_press   - Similar to get_key_press, but checks for two sequential presses

% Joystick Functions
%   joystick_calc_move_direction - Calculates move direction given deflection and angle thresholds    
%   joystick_get_index           - Returns the device index of 'Attack 3' joystick among USB devices
%   joystick_get_trigger_button  - Wait for a trigger press    
%   joystick_track_movements     - Waits for a joystick to move and track coordinats for specified time
%   get_joystick_move            - Waits for a joystick move, with options for having a maximum

% Screen Helpers
%   cls                          - Clears Screen variables
%   coords_from_margins          - Creates a subwindow from a larger window using margins on each side
%   display_screen_text          - Uses PsychToolbox to display long text on full screen
%   draw_arrow                   - Draws an arrow using PsychToolbox commands
%   drawing_functions            - Various functions for frequent drawing routines
%   scr                          - Opens a PsychToolBox screen and saves ID to variable 'w'

% Sound Triggers
%   SimpleVoiceTriggerDemo       - SimpleVoiceTriggerDemo(triggerlevel)
