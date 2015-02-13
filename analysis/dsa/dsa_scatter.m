function dsa_scatter(x, y)
    
    assert(isa(x, 'dataset') & isa(y, 'dataset'), 'Arguments must be datasets');
    x_name = char(get(x, 'VarNames'));
    x_data = x.(x_name);
    y_name = char(get(y, 'VarNames'));
    y_data = y.(y_name);
    
    ax_h = gca; % axis handle
    
%% numeric scatter
    if isnumeric(x_data)
        scatter(x_data, y_data)
    
%% grouped scatter
    elseif isa(x_data, 'nominal')
        scatter(x_data, y_data)
        xticks_from_nominal(ax_h, x_data);
    
%% otherwise        
    else
        warning('Unrecognized x data type') %#ok<WNTAG>
        keyboard
    end        

%% format graph        
        
    xlabel(strrep(x_name, '_', ' '));
    ylabel(strrep(y_name, '_', ' '));
    
    
end