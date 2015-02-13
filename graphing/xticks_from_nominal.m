function xticks_from_nominal(ax_h, x_data)
    
    xticks = unique(double(x_data))';
    xlimits = [0 max(xticks) + 1];
    
    xlabels = getlabels(x_data)';

    xlim(xlimits);
    set(ax_h, 'XTick', xticks);
    set(ax_h, 'XTickLabel', xlabels);
    
end