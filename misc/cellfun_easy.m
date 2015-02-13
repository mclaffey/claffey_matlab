function [b] = cellfun_easy(func_handle, varargin)
% Similar to cellfun but doesn't require the arguments to be same size    
    
    arg_sizes = nan(length(varargin), 4);    
    
%% determine how big the arguments are
    for x = 1:length(varargin);
        arg = varargin{x};
        if ischar(arg), arg = {arg}; end;
        arg_sizes(x, 1) = size(arg,1);
        arg_sizes(x, 2) = size(arg,2);
        varargin{x} = arg;
    end
    
%% determine how much they need to be adjusted    
    max_size = max(arg_sizes);
    arg_sizes(:, 3) = max_size(1) ./ arg_sizes(:, 1);
    arg_sizes(:, 4) = max_size(2) ./ arg_sizes(:, 2);
    
%% convert any numeric matrices to cells

    for x = 1:length(varargin)
        if isnumeric(varargin{x})
            varargin{x} = mat2cell_same_size(varargin{x});
        end
    end

%%
%     large_numeric = find( arg_sizes(:,3)==1 & arg_sizes(:,4)==1 & ~cellfun(@iscell, varargin') )
%     if any(no_scaling_arg)
%         if ~iscell(varargin{no_scaling_arg})
%             if isnumeric(varargin{no_scaling_arg})
%                 varargin{no_scaling_arg} = mat2cell_same_size(varargin{no_scaling_arg});
%             end
%         end
%     end
    
%% adjust the arguments that are too small    
    
    for x = 1:length(varargin);
        arg = varargin{x};
        arg = repmat(arg, arg_sizes(x,3), arg_sizes(x,4));
        varargin{x} = arg;
    end
    
%% perform cellfun    
    
    b = cellfun(func_handle, varargin{:}, 'UniformOutput', false);
    
end