function [varargout] = paired_params(varargin)
% Converts parameter name-value pairs to structure
%
% [pair_list] = paired_params(params)
%   When passed a structure, creates a name-value pair list from each field
%   in the structure.
%
% [params] = paired_params(arg_list, [params])
%   When passed arg_list, a cell of name-value pairs, it builds the
%   structure params. An existing structure, params, can be passed as a
%   second argument and new values will be appended, overwriting any
%   existing fields of the same name.
%
% [params] = pairded_params(name1, value1, name2, value2, ...)
%   When passed a list of name-value pairs, it builds the structure params.
%   Must be given an even number of arguments, and each name must be a
%   string
%
% SAMPLE USE IN FUNCTION
% ----------------------------------
% function myfunc(x_data, varargin)
%
%   % process arguments
%   p.font_size = '12';             % default is 12
%   p.y_data = x_data;              % default is to copy the x_data var
%   p.debug_mode = false;           % default is false
%   p = paired_params(varargin, p); % overwrite the defaults with provided args
%
%   % use params in function body...
%   if p.debug_mode
%       if isempty(p.y_data), p.y_data = x_data; end;
%   end
%   % continued...


% Copyright 2008 Mike Claffey (mclaffey[]ucsd.edu)

% 12/12/08 can pass two structurs and they will be blended if first taking priority
% 04/24/08 original version

%% error checking
    switch nargin
        case 0
            error('No arguments provided')
            
        case 1
            if isstruct(varargin{1})
                % structure to param list
                varargout{1} = struct_to_params(varargin{1});
                return
            elseif iscell(varargin{1})
                arg_list = varargin{1};
            else
                error('Single arguments must be either a cell or structure')
            end
            
        case 2
            if ischar(varargin{1})
                arg_list = varargin;
%             elseif isstruct(varargin{1}) && isstruct(varargin{2})
%                 arg_list = struct_to_params(varargin{1});
%                 params = varargin{2};
            elseif iscell(varargin{1}) && isstruct(varargin{2})
                params = varargin{2};
                if isempty(varargin{1})
                    arg_list = {};
                else
                    arg_list = varargin{1};
                    if isstruct(arg_list{1}), arg_list = struct_to_params(arg_list{1}); end;
                end
            else
                error('When providing 2 arguments, must either be a parameter-value pair or cell/params pair')
            end
            
        otherwise
            arg_list = varargin;
            params = [];
    end
   
    arg_count = length(arg_list);
    if mod(arg_count, 2) ~= 0
        error('Must provide an even number of arguments')
    end

%% iterate through each parameter-value pair and append to structure    
    for i = 1:2:arg_count
        arg_name = arg_list{i};
        arg_value = arg_list{i+1};
        
        if ~ischar(arg_name)
            error('First element in each parameter-value pair must be a string (#%d was not)', i)
        end
        params.(arg_name) = arg_value;
    end
    
%% build output variables
    switch nargout
        case {0, 1}
            varargout{1} = params;
        otherwise
            error('Too many output variables')
    end
    
%% helper function: struct_to_parms
    function [param_list] = struct_to_params(param_struct)
        param_names = fieldnames(param_struct);
        pair_count = length(param_names);
        param_list = {};
        for x = 1:pair_count
            param_list{end+1} = param_names{x}; %#ok<AGROW>
            param_list{end+1} = param_struct.(param_names{x}); %#ok<AGROW>
        end
    end
    
end