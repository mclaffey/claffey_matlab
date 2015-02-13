function [varargout] = report(varargin)
        
    persistent report_is_on
    persistent report_backlog
    
    if nargout > 0
        varargout{1} = report_is_on;
        return
    end
    
    if nargin == 0
        if report_is_on
            fprintf('Reporting is currently on\n')
        else
            fprintf('Reporting is currently off\n')
        end
    elseif nargin == 1 && ~ischar(varargin{1})
        report_is_on = varargin{1};
        report();
    elseif nargin == 1 && strcmpi(varargin{1}, 'log')
        cellfun(@fprintf, report_backlog);
        report_backlog = {};
    else
        % make sure it ends with a line feed
        if ~strcmpi(varargin{1}(end-1:end), '\n')
            varargin{1} = [varargin{1}, '\n'];
        end
        if report_is_on
            fprintf(varargin{:});
        else
            report_backlog{end+1,1} = sprintf(varargin{:});
        end
    end
end