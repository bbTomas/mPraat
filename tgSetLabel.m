function tgNew = tgSetLabel(tg, tierInd, index, label)
% function tgNew = tgSetLabel(tg, tierInd, index, label)
% Zmeni label intervalu ci bodu s danym indexem ve vybrane vrstve (tier) typu IntervalTier ci PointTier.
% v1.0, Tomas Boril, borilt@gmail.com

if nargin ~= 4
    error('Wrong number of arguments.')
end

% if ~isInt(tierInd)
%     error(['index tier musi byt cele cislo od 1 vyse [' num2str(tierInd) ']']);
% end
tierInd = tgI(tg, tierInd);

% ntiers = tgGetNumberOfTiers(tg);
% if tierInd < 1 || tierInd > ntiers
%     error(['index tier mimo rozsah, tierInd = ' num2str(tierInd) ', ntiers = ' num2str(ntiers)]);
% end


if tgIsIntervalTier(tg, tierInd)
    nint = tgGetNumberOfIntervals(tg, tierInd);
    if index < 1 || index > nint
        error(['index of interval out of range, index = ' num2str(index) ', nint = ' num2str(nint)]);
    end
elseif tgIsPointTier(tg, tierInd)
    npoints = tgGetNumberOfPoints(tg, tierInd);
    if index < 1 || index > npoints
        error(['index of point out of range, index = ' num2str(index) ', npoints = ' num2str(npoints)]);
    end
else
    error('unknown tier type')
end

if ~isInt(index)
    error(['index must be integer >= 1 [' num2str(index) ']']);
end

tgNew = tg;
tgNew.tier{tierInd}.Label{index} = label;
