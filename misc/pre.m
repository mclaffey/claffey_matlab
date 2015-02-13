function pre(a)
% Displays as much information as available about a variable in 10 lines or less
    if isempty(a) || size(a,1)==0, fprintf('\n\tvariable is empty\n\n'); return; end;

    switch class(a)
        case 'dataset'
            if size(a, 1) <= 10 && size(a, 2) <= 8
                disp(a);
            elseif size(a, 2) > 8
                fprintf('First row of data: (%d total)\n', size(a, 1));
                disp(a(1,:));
                command_window_line;
                var_names = get(a, 'VarNames')';
                var_names = reshape_forced(var_names, 4, []);
                fprintf('Column names: (%d total)\n', size(a,2));
                fprintf(cell2str(var_names));
            else
                disp(a(1:10, :));
                command_window_line;
                fprintf('\tData is abbreviated. There are %d more lines...\n', size(a,1)-10);
            end
        case 'struct'
            if size(fieldnames(a), 1) <= 10
                disp(a)
            else
                b = struct2cell(a);
                abbreviated_field_names = fieldnames(a);
                abbreviated_field_names = abbreviated_field_names(1:10);
                b = cell2struct(b(1:10, :), abbreviated_field_names);
                disp(b);
                command_window_line;
                fprintf('\tData is abbreviated. There are %d more fields...\n', size(fieldnames(a), 1)-10);
            end
        otherwise
            if size(a, 1) <= 10
                disp(a);
            else
                disp(a(1:10, :));
                command_window_line;
                fprintf('\tData is abbreviated. There are %d more lines...\n', size(a,1)-10);
            end
    end
end