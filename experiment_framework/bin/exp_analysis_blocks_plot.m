function [edata] = exp_analysis_blocks_plot(edata, trial_data)
% Create a figure of block data for feedback
%
%   [edata] = exp_analysis_blocks_plot(edata, trial_data)
%
% 11/05/09 added to experiment framework
    
    % make sure the data has been calculated
    assert(isfield(edata, 'analysis'), 'There is no analysis field in the edata structure');    
    assert(isfield(edata.analysis, 'block_stats'), 'There is no block stats field in the edata.analysis structure');

    % determine how many blocks are in the data
    block_max = max(edata.analysis.block_stats.block);
    
%% create some standard graph formatting properties

    gf = struct;
    gf.x_label = 'Block';
    gf.x_lim = [0 block_max + 1];
    gf.x_ticks = 1:block_max;
    gf.x_tick_labels = horzcat({' '}, mat2cell_same_size(gf.x_ticks), {' '});
    gf.x_increment = 1;
    gf.font_size = 'tiny';
    all_gf = gf;
    
%% Reaction Time graph

    subplot(3,1,1)
    errorbar( edata.analysis.block_stats.block, ...
              edata.analysis.block_stats.mean_rt, ...
              edata.analysis.block_stats.std_rt, '-*b');
    gf = all_gf;
    gf.x_label = '';
    gf.y_label = 'Reaction Time (secs)';
    %gf.y_lim = [0 1];
    graph_formatter(gf);

%% Go Accuracy graph

    subplot(3,1,2)
    plot(edata.analysis.block_stats.block, edata.analysis.block_stats.going_correct, '-*r');
    gf = all_gf;
    gf.y_lim = [50 100];
    gf.y_increment = 25;
    gf.x_label = '';
    gf.y_label = '% Going accuracy';
    graph_formatter(gf);

%% Stopping Accuracy graph

    subplot(3,1,3)
    plot(edata.analysis.block_stats.block, edata.analysis.block_stats.stopping_correct, '-*r');
    gf = all_gf;
    gf.y_lim = [0 75];
    gf.y_increment = 25;
    gf.y_label = 'Stopping Accuracy';
    graph_formatter(gf);

end
