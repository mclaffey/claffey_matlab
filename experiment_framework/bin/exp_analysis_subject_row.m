function [sub_row] = exp_analysis_subject_row(edata, trial_data) %#ok<INUSD>
% Create a single row results dataset for between subject analysis

%%
    sub_row = dataset();

%% subject info

    sub_row.subject_num = edata.subject_id;
    sub_row.subject_irb = edata.irb.irb_number;
    
%% adding vectors to a dataset

%     col_data = edata.analysis.vector_data;
% 
%     for x = 1:length(col_data)
%         col_name = sprintf('data_point_%02d', x);
%         sub_row.(col_name) = col_data(x);
%     end
    
%%

end