function [ extrema ] = FindLocalExtrema( data, threshold, scale, regions )
% maxmin = FindLocalExtrema( data )
% Finds locally maximal or minimal values in the y direction of the given
% data.
%
% Input:
%   data        1D data array (image)
%   threshold   What fraction of total maximum or minimum a data point
%               needs to be for consideration (non-maximum supression)
%   scale       Specifies the number of data points in a local neighborhood
%               (neighborhood legth is 2 * scale + 1)
%   regions     Specifies a set of regions to look in--if not supplied,
%               the whole data region will be searched
% Output:
%   extrema     a vector the same size as the input data with value 1 at
%               input data maxima and minima, 0 elsewhere

if (nargin < 3)
    scale = 1;
end
if (nargin < 2)
    threshold = 0.5;
end

% rescale data
rdataMax = data / max(data);
rdataMin = data / min(data);

winmax = zeros(size(data));
winmin = zeros(size(data));

% Note: It would have been nice to do the follwing as a vector operation,
% even within the min/max detection below.  For reasons opaque to me, the
% max() function doesn't seem to work in a vector operation.  We wanted
% something like:
% winmax(ii) = max(rdataMax(ii-scale:ii+scale));
% But, this seems to generate a vector mostly of, almost like the maximum
% is being applied cummulatively. Oh, well...this isn't too slow if the 
% data are not too big.
% create a sliding window min & max
for i = 1+scale:size(data,1)-scale
    winmax(i) = max(rdataMax(i-scale:i+scale));
    winmin(i) = max(rdataMin(i-scale:i+scale));
end

maxima = zeros(size(data));
minima = zeros(size(data));

% find the local minima and maxima
if (nargin < 4)     % regions not defined--search everywhere
    ii = (1+scale:size(data,1)-scale)';
    maxima(ii) = rdataMax(ii) >= threshold & rdataMax(ii) >= winmax(ii);
    minima(ii) = rdataMin(ii) >= threshold & rdataMin(ii) >= winmin(ii);
else                % only search in specified regions
    for i = 1:length(regions)
        ii = (max(1+scale, regions(i)-scale):min(size(data,1)-scale, regions(i)+scale))';
        maxima(ii) = rdataMax(ii) >= threshold & rdataMax(ii) >= winmax(ii);
        minima(ii) = rdataMin(ii) >= threshold & rdataMin(ii) >= winmin(ii);
    end
end

% combine min and max
extrema = maxima + minima;