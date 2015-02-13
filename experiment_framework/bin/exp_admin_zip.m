function exp_admin_zip(edata, zip_mode)
    
    if ~exist('zip_mode', 'var')
        zip_mode = menu_str('Create what type of zip?', {'All', 'No Data', 'Data Only'});
        if strcmpi(zip_mode, 'cancel'), return; end;
    end;
    
%% generate directory list

    zip_items = dir(edata.files.base_dir);
    zip_items = {zip_items.name};
    exclude_items = {'.', '..', '.DS_Store', 'zips'};
    zip_items = setdiff(zip_items, exclude_items);

    switch zip_mode
        case {[], '', 'all'}
            % do nothing
            zip_name = [edata.files.exp_abbr '_' datestr(now, 'yyyy_mm_dd') '.zip'];
            
        case 'no data'
            % option to exclude data directory
            zip_items = setdiff(zip_items, {'data'});
            zip_name = [edata.files.exp_abbr '_NO_DATA_' datestr(now, 'yyyy_mm_dd') '.zip'];
            
        case 'data only'
            zip_items = {'data'};
            zip_name = [edata.files.exp_abbr '_DATA_ONLY_' datestr(now, 'yyyy_mm_dd') '.zip'];
            
        otherwise
            error('Unknown zip mode: %s', zip_mode)
    end

%% create zip

    zip_directory = [edata.files.base_dir filesep 'zips' ];
    if ~exist(zip_directory, 'dir'), mkdir(zip_directory); end;
    zip_location = [zip_directory  filesep zip_name];
    zip(zip_location, zip_items, edata.files.base_dir)
    
%% report

    fprintf('Zip file created: %s\n', zip_name);
    fprintf('In directory: %s\n', link_text('file', fileparts(zip_location)));
    
end
