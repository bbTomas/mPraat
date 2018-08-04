function tgNew = tgCut0(tg, tStart, tEnd)
% function tgNew = tgCut0(tg, tStart, tEnd)
%
% Cut the specified time frame from the TextGrid and shift time so that the new tmin = 0
% 
% tg     ... TextGrid object
% tStart ... [optional] beginning time of time frame to be cut (default -inf = cut from the tmin of the TextGrid)
% tEnd   ... [optional] final time of time frame to be cut (default inf = cut to the tmax of the TextGrid)
%
% v1.0, Tomas Boril, borilt@gmail.com
%
% Example
%   tg = tgRead('demo/H.TextGrid');
%   tg2 =   tgCut(tg,  3);
%   tg2_0 = tgCut0(tg, 3);
%   tg3 =   tgCut(tg,  2, 3);
%   tg3_0 = tgCut0(tg, 2, 3);
%   tg4 =   tgCut(tg,  -Inf, 1);
%   tg4_0 = tgCut0(tg, -Inf, 1);
%   tg5 =   tgCut(tg,  -1, 5);
%   tg5_0 = tgCut0(tg, -1, 5);
%   figure, tgPlot(tg)
%   figure, tgPlot(tg2)
%   figure, tgPlot(tg2_0)
%   figure, tgPlot(tg3)
%   figure, tgPlot(tg3_0)
%   figure, tgPlot(tg4)
%   figure, tgPlot(tg4_0)
%   figure, tgPlot(tg5)
%   figure, tgPlot(tg5_0)
%
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

ntiers = tgGetNumberOfTiers(tg);
tmin = tgGetStartTime(tg);
tmax = tgGetEndTime(tg);

tgNew = tg;

if isinf(tStart)
    tgNew.tmin = min(tmin, tEnd);
else
    tgNew.tmin = tStart;
end

if isinf(tEnd)
    tgNew.tmax = max(tmax, tStart);
else
    tgNew.tmax = tEnd;
end

tNewMin = tgGetStartTime(tgNew);
tNewMax = tgGetEndTime(tgNew);


for I = 1: ntiers
    if tgIsPointTier(tgNew, I)
        sel = tg.tier{I}.T >= tStart  &  tg.tier{I}.T <= tEnd;
        tgNew.tier{I}.T     =     tg.tier{I}.T(sel) - tNewMin;
        tgNew.tier{I}.Label = tg.tier{I}.Label(sel);
    elseif tgIsIntervalTier(tgNew, I)
        sel = (tg.tier{I}.T1 >= tStart & tg.tier{I}.T2 <= tEnd) | (tStart >= tg.tier{I}.T1 & tEnd <= tg.tier{I}.T2) | (tg.tier{I}.T2 > tStart & tg.tier{I}.T2 <= tEnd) | (tg.tier{I}.T1 >= tStart & tg.tier{I}.T1 < tEnd);
        tgNew.tier{I}.T1    =    tg.tier{I}.T1(sel);
        tgNew.tier{I}.T2    =    tg.tier{I}.T2(sel);
        tgNew.tier{I}.Label = tg.tier{I}.Label(sel);

        tgNew.tier{I}.T1(tgNew.tier{I}.T1 < tStart) = tStart;
        tgNew.tier{I}.T2(tgNew.tier{I}.T2 > tEnd) = tEnd;
        
        tgNew.tier{I}.T1 = tgNew.tier{I}.T1 - tNewMin;
        tgNew.tier{I}.T2 = tgNew.tier{I}.T2 - tNewMin;
    else
        error(['unknown tier type:', tgNew.tier{I}.type]);
    end
end

tgNew.tmin = 0;
tgNew.tmax = tNewMax - tNewMin;


return
