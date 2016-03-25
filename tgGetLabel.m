function lab = tgGetLabel(tg, tierInd, index)
% function lab = tgGetLabel(tg, tierInd, index)
% Vrátí label intervalu èi bodu s daným indexem ve vybrané vrstvì (tier) typu IntervalTier èi PointTier.
% v1.0, Tomáš Boøil, borilt@gmail.com

if nargin ~= 3
    error('Wrong number of arguments.')
end

% if ~isInt(tierInd)
%     error(['index tier musí být celé èíslo od 1 výše [' num2str(tierInd) ']']);
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
    error(['index must by integer >= 1 [' num2str(index) ']']);
end

lab = tg.tier{tierInd}.Label{index};