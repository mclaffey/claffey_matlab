function [edata] = stop1_block_stats(edata, trial_data)
    
%% calculate statistics for all blocks

    edata.block_stats = dataset_grpmean(trial_data, 'block', {'rt', 'correct'});
    edata.block_stats.correct = edata.block_stats.correct .* 100;

    block_max = max(edata.block_stats.block);
    max_rt = nz(round_decimal(max(edata.block_stats.rt) + .1, 2), 1);
    
%% graph formatting    

    gf.x_label = 'Block';
    gf.x_lim = [0 block_max + 1];
    gf.x_ticks = [1:block_max];
    gf.x_tick_labels = horzcat({' '}, mat2cell_same_size(gf.x_ticks), {' '});
    gf.x_increment = 1;
    gf.font_size = 'small';

%% Reaction Time graph

    subplot(2,1,1)
    plot(edata.block_stats.block, edata.block_stats.rt, '-*b');
    gf.y_lim = [0 max_rt];
    gf.y_increment = 0.1;
    gf.title = 'Reaction time';
    gf.y_label = 'Reaction time (secs)';
    graph_formatter(gf);

%% Go Accuracy graph

    subplot(2,1,2)
    plot(edata.block_stats.block, edata.block_stats.correct, '-*r');
    gf.y_lim = [0 100];
    gf.y_increment = 20;
    gf.title = 'Accuracy of going with correct fingers';
    gf.x_label = 'Block';
    gf.y_label = '% Accuracy';
    graph_formatter(gf);

end
