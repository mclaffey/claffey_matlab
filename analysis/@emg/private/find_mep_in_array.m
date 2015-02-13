function [mep_start, mep_end, p] = find_mep_in_array(signal_data, value_threshold, varargin)
% Find an MEP-like pattern in an scalar array of EMG data
%
% [mep_start, mep_end, search_params] = find_mep(signal_data, value_threshold, [])


%% process arguments
    if ~exist('value_threshold', 'var')
        value_threshold = emg_defaults('mep_search_threshold');
    end

    p.min_indices = [];
    p.min_time = emg_defaults('mep_search_duration');
    p.sampling_rate = emg_defaults('sampling_rate');
    p.debug = false;
    p.decline_rate = 2;
    p.output_as_time = true;
    p.algorithm = emg_defaults('mep_search_algorithm');
    p = paired_params(varargin, p);

%% error checking

    % calculate on element or time basis
    if isempty(p.min_indices)
        if isempty(p.min_time) || isempty(p.sampling_rate)
            error('Must specify either min_indices, or min_time & sampling_freq')
        else
            p.min_indices = p.min_time .* p.sampling_rate;
        end
    end
    
    % if returning as time, make sure necessary sampling_freq was provided
    if p.output_as_time && isempty(p.sampling_rate)
        error('Must provide sampling rate if returning mep boundaries as times')
    end
        
    
    % make sure signal data is a horizontal vector
    if isempty(signal_data)
        mep_start = 0;
        mep_end = 0;
        return;
    elseif ~isvector(signal_data)
        error('signal_data must be a 1-dimensional vector')
    else
        if size(signal_data, 2) == 1, signal_data = signal_data'; end;
    end

%% calculate using the specified algorithm

    switch p.algorithm
        case 'bidir longest'
            bidir_longest()
        case 'smooth'
            smoothed_out()
        otherwise
            error('Unknown search algorithm: %s', p.algorithm)
    end    
    
%% pack up output arguments
    
    % if no signal was found, return zeros
    if isempty(mep_start), mep_start=0;end;
    if isempty(mep_end), mep_end=0;end;
    
    % convert outputs to time, if request
    if p.output_as_time
        mep_start = mep_start / p.sampling_rate;
        mep_end = mep_end / p.sampling_rate;
    end
    
    % save data to the search parameters for review/debugging
    p.signal_data = signal_data;
    
%% Search algorithms
% ----------------------------------------------------

%%  ALGORITHM: longest streak using forward and backward cumulative above threshold
    function bidir_longest()
        original_signal = signal_data;
        signal_data = smoothout(abs(signal_data));
        
        % get counts above threshold counting forwards and backwards
        forward_count = cumulative_above_threshold(signal_data, value_threshold, p.decline_rate);
        backward_count = cumulative_above_threshold(fliplr(signal_data), value_threshold, p.decline_rate);
        backward_count = fliplr(backward_count);
        bidir_count = max(forward_count, backward_count);

        % find the longest streak above the threshold for the minimum duration
        [mep_start, mep_length] = find_longest_streak(bidir_count >= p.min_indices);
        
        if isempty(mep_start)
            mep_end = [];
        else
            
            % find the mep_end as the first point after the streak where
            % the signal comes below threshold
            mep_end = mep_start + mep_length - 1;
            mep_end = mep_end + find(signal_data(mep_end:end) < value_threshold, 1, 'first');
            % if the signal never comes below the end, just use the end
            if isempty(mep_end), mep_end = length(signal_data); end;

            % adjust the start to be the point where the streak first rose
            % above threshold 
            mep_start = find(signal_data(1:mep_start) < value_threshold, 1, 'last');
            % if the above find() function returns empty, there signal is
            % above threshold since the beginning
            if isempty(mep_start), mep_start = 1; end; 
        
            % adjustment for fluke case where mep start and end are equal
            if mep_start == mep_end, mep_end = mep_start + 1; end;
        
        end
        
        % debug graphs
        if ischar(p.debug), p.debug = eval(p.debug); end;
        if p.debug
            figure
            
            ax(1) = subplot(3, 1, 1);
            plot(original_signal)
            hold on
            plot_line(value_threshold, 'h', 'r')
            plot_line(-value_threshold, 'h', 'r')
            if mep_start
                plot_line(mep_start, 'v', 'r')
                plot_line(mep_end, 'v', 'r')
            end
            title('Original Signal')
            
            ax(2) = subplot(3, 1, 2);
            plot(signal_data)
            hold on
            plot_line(value_threshold, 'h', 'r')
            if mep_start
                plot_line(mep_start, 'v', 'r')
                plot_line(mep_end, 'v', 'r')
            end
            title('Rectified Signal')
            
            ax(3) = subplot(3, 1, 3);
            plot(bidir_count)
            hold on
            plot_line(p.min_indices, 'h', 'r')
            if mep_start
                plot_line(mep_start, 'v', 'r')
                plot_line(mep_end, 'v', 'r')
            end
            title('Bidir Count')
            
            linkaxes(ax, 'x')
        end
        
    end
%%  ALGORITHM: smoothed out and above threshold
    function smoothed_out()
        original_signal = signal_data;
        signal_data = abs(signal_data);
        smooth_data = signal_data;
        for i = 2:length(signal_data)-1
            smooth_data(i) = max(signal_data(i-1:i+1));
        end
        
        % get counts above threshold counting forwards
        forward_count = cumulative_above_threshold(smooth_data, value_threshold, p.decline_rate);
%         backward_count = cumulative_above_threshold(fliplr(signal_data), value_threshold, p.decline_rate);
%         backward_count = fliplr(backward_count);
%         bidir_count = max(forward_count, backward_count);

        % find the longest streak above the threshold for the minimum duration
%         [mep_start, mep_length] = find_longest_streak(bidir_count >= p.min_indices);
        [mep_start, mep_length] = find_longest_streak(forward_count >= p.min_indices);
        mep_end = mep_start + mep_length - 1;

        % adjust the start to be the point where the streak first rose above threshold
        mep_start = find(smooth_data(1:mep_start) < value_threshold, 1, 'last') + 1;
        
        % this corrects for a fluke case
        if ~isempty(mep_start) && mep_start == mep_end, mep_end = mep_end + 1; end;
        
        % debug graphs
        if ischar(p.debug), p.debug = eval(p.debug); end;
        if p.debug
            figure
            
            ax(1) = subplot(3, 1, 1);
            plot(original_signal)
            hold on
            plot_line(value_threshold, 'h', 'r')
            plot_line(-value_threshold, 'h', 'r')
            plot_line(mep_start, 'v', 'r')
            plot_line(mep_end, 'v', 'r')
            title('Original Signal')
            
            ax(2) = subplot(3, 1, 2);
            plot(smooth_data)
            hold on
            plot_line(value_threshold, 'h', 'r')
            plot_line(mep_start, 'v', 'r')
            plot_line(mep_end, 'v', 'r')
            title('Smoothed Signal')
            
            ax(3) = subplot(3, 1, 3);
            plot(forward_count)
            hold on
            plot_line(p.min_indices, 'h', 'r')
            plot_line(mep_start, 'v', 'r')
            plot_line(mep_end, 'v', 'r')
            title('Bidir Count')
            
            linkaxes(ax, 'x')
        end
        
    end

end
