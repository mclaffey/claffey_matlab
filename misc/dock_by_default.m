function dock_by_default(should_dock)
% Sets the figure docking mode
%

    if ~exist('should_dock', 'var')
        fprintf('No argument provided, assuming true for dock_by_default\n')
        should_dock=true;
    end
    if should_dock
        set(0,'DefaultFigureWindowStyle','docked')
    else
        set(0,'DefaultFigureWindowStyle','normal')
    end
end