%%
clear
clc
%%
clc
ef = enum_files()
ef.base_dir = cd('wanting_v2_tms/data')

ef.files.behav = 'Want_v1_subj_%d_*'

ef.files.behav
ef.files.behav(10)
ef.files.behav(1:3)

%%
ef.files.emg = 's%d/s%d_emg.mat'
ef.files.emg(:)

%%
ef.identifier = 'Want_v1_subj_%d_*'
ef.ids
ef.next_id

%%
ef.identifier = 'behav'
ef.ids

ef.behav