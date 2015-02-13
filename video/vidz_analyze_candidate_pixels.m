function [vid] = vidz_analyze_candidate_pixels(vid)
% Determine/update candidate pixels
%
%   [vid] = vidz_analyze_candidate_pixels(vid)

%% if bad pixels doesn't exist, create it

    if ~isfield(vid.data, 'excluded_pixels')
        vid.data.excluded_pixels = false(size(vid.data.out_of_minmax));
    end

%% candidate pixels are anything out of minmax but not labeled as exclude    
    
    vid.data.candidate_pixels = vid.data.out_of_minmax & ~vid.data.excluded_pixels;
    
%%    
    
end
