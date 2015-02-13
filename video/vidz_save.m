function vidz_save(vid)
% Save the vid variable without large analysis portions

%% remove large fields

%     vid.callibration.video = [];
%     vid.data.video = [];
%     vid.data.out_of_minmax = [];

%% save file

%     save(vid.file.metadata, 'vid');
    save(vid.file.matlab, 'vid');

end