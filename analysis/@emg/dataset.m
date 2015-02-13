function [data] = dataset(e, varargin)
% Produces a single-row dataset containing tags, metrics and sections
%
% [dataset] = dataset(e, [name-value pairs])
%
% OPTIONS
%   dataset(e, 'tags', TAG_OPTION, ...)
%       if TAG_OPTION = 'all' (default), all numeric and character tags
%       will be returned. if TAG_OPTION = '', no tags are returned.
%       TAG_OPTION can also be a cell array of specific tags to return.
%
%   dataset(e, 'metrics', METRIC_OPTION, ...)
%       if METRIC_OPTION = 'all' (default), all metrics are returned. if
%       METRIC_OPTION = '', no metrics are returned. METRIC_OPTION can also
%       be a cell array of specific metrics to return. 
%
%   dataset(e, 'sections', SECTION_OPTIONS, ...)
%       dataset will recursively show all sections of the emg_object.
%       if SECTION_OPTION = 'all' (default), data for all sections will be
%       returned. if SECTION_OPTION = '', no sections are returned.
%       SECTION_OPTION can also be a cell array of specific sections to
%       return.
    
% Copyright 2008 Mike Claffey (mclaffey[]ucsd.edu)

% 10/31/08 error handling for nonexistant metrics
% 10/14/08 improved performance of tags
% 09/20/08 used dataset_append_varnames function
% 08/25/08 original version

%% process arguments
    p.tags = 'all';
    p.sections = 'all';
    p.metrics = 'all';
    p.var_prefix = '';
    p = paired_params(varargin, p);
    
    data = dataset();
    pseudo_tags = {'start', 'duration'};
    
%% tags
    if strcmpi(p.tags, 'all')
        tag_list = fieldnames(e.tags);
    elseif strcmpi(p.tags, '')
        tag_list = [];
        pseudo_tags = [];
    else
        if ischar(p.tags), p.tags = {p.tags}; end;
        tag_list = p.tags;
        pseudo_tags = intersect(pseudo_tags, tag_list);
        tag_list = setdiff(tag_list, pseudo_tags);
    end
    all_tags = fieldnames(e.tags);
    
    if size(tag_list,1) == 1, tag_list = tag_list'; end; % make tag_list a vertical array
    tag_list_present = cellfun(@ismember, tag_list, repmat({all_tags}, length(tag_list), 1)); % determine which tags are actually present
    for x = 1:length(tag_list)
        if ~tag_list_present(x)
            % don't do anything, the warnings were annoying
            %warning('EMG:dataset:unknown_tag', 'Tag ''%s'' does not exist while trying to convert to dataset', tag_list{x})
        else
            tag_value = e.tags.(tag_list{x});
            if isnumeric(tag_value)
                data.(tag_list{x}) = tag_value;
            elseif islogical(tag_value)
                data.(tag_list{x}) = double(tag_value);
            elseif ischar(tag_value)
                data.(tag_list{x}) = nominal(tag_value);
            end
        end
    end

%% pseudo-tags
    if strmatch('start', pseudo_tags, 'exact')
        data.start = e.time.start;
    end
    if strmatch('duration', pseudo_tags, 'exact')
        data.duration = e.time.duration;
    end
    
%% metrics
    if strcmpi(p.metrics, 'all')
        metric_list = fieldnames(e.tags.metrics);
    elseif strcmpi(p.metrics, '')
        metric_list = [];
    else
        if ischar(p.metrics), p.metrics = {p.metrics}; end;
        metric_list = p.metrics;
    end
    for x = 1:length(metric_list)
        try
            data.(metric_list{x}) = e.tags.metrics.(metric_list{x});
        catch
            error('Metric does not exist: %s', metric_list{x});
        end
    end
    
%% sections (recursive)
    if strcmpi(p.sections, 'all')
        section_list = fieldnames(e.sections);
    elseif strcmpi(p.sections, '')
        section_list = [];
    else
        if ischar(p.sections), p.sections={p.sections}; end;
        section_list = p.sections;
    end
    for x = 1:length(section_list)
        section_name = section_list{x};
        p_temp = p;
        p_temp.sections = setdiff(section_list, section_name);
        p_temp.var_prefix = sprintf('%s_', section_name);
        param_list = paired_params(p_temp);
        try
            section_data = dataset(e.sections.(section_list{x}), param_list{:});
            data = horzcat(data, section_data);
        catch
            % do nothing
        end
    end
    
%% append prefix
    if ~isempty(p.var_prefix), data = dataset_append_varnames(data, p.var_prefix); end;
end
    