%%
clear
clc
behav = enum_file('fts_v2_tms/data/s%d/s%d_behav.mat')

%%
behav.template

%%
behav.ids

%%
behav.next_id

%%
behav.files

%%
behav(1)

%%
behav(1).generate

%%
behav(1).find
behav(1).exists

%%
behav(99).find
behav([1 99]).exists

%%
behav(1).load

%%
x = behav([1 2]).load


