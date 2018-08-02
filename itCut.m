function itNew = itCut(it, tStart, tEnd)
% function itNew = itCut(it, tStart, tEnd)
%
% Cut the specified interval from the IntensityTier and preserve time
%
% it      ... IntensityTier object
% tStart  ... [optional] beginning time of interval to be cut (default -Inf = cut from the tMin of the IntensityTier)
% tEnd    ... final time of interval to be cut (default Inf = cut to the tMax of the IntensityTier)
% 
% v1.0, Tomas Boril, borilt@gmail.com
%
% Example
%   it = itRead('demo/maminka.IntensityTier');
%   it2 =   itCut(it,  0.3);
%   it2_0 = itCut0(it, 0.3);
%   it3 =   itCut(it,  0.2, 0.3);
%   it3_0 = itCut0(it, 0.2, 0.3);
%   it4 =   itCut(it,  -Inf, 0.3);
%   it4_0 = itCut0(it, -Inf, 0.3);
%   it5 =   itCut(it,  -1, 1);
%   it5_0 = itCut0(it, -1, 1);
%   subplot(3,1,1)
%   itPlot(it)
%   subplot(3,1,2)
%   itPlot(it2)
%   subplot(3,1,3)
%   itPlot(it2_0)
%   figure
%   subplot(2,3,1)
%   itPlot(it3)
%   subplot(2,3,4)
%   itPlot(it3_0)
%   subplot(2,3,2)
%   itPlot(it4)
%   subplot(2,3,5)
%   itPlot(it4_0)
%   subplot(2,3,3)
%   itPlot(it5)
%   subplot(2,3,6)
%   itPlot(it5_0)

if nargin < 1 || nargin > 3
    error('Wrong number of arguments.')
end

if nargin == 1
    tStart = -Inf;
    tEnd = Inf;
elseif nargin == 2
    tEnd = Inf;
end


if isinf(tStart) && tStart>0
    error('infinite tStart can be negative only')
end
if isinf(tEnd) && tEnd<0
    error('infinite tEnd can be positive only')
end

if isnan(tStart)
    error('tStart must be a number')
end

if isnan(tEnd)
    error('tEnd must be a number')
end

if tEnd < tStart
    error('tEnd must be >= tStart')
end

itNew = it;
itNew.t = it.t(it.t >= tStart  &  it.t <= tEnd);
itNew.i = it.i(it.t >= tStart  &  it.t <= tEnd);

if isinf(tStart)
    itNew.tmin = it.tmin;
else
    itNew.tmin = tStart;
end

if isinf(tEnd)
    itNew.tmax = it.tmax;
else
    itNew.tmax = tEnd;
end
