function tgNew = tgInsertPoint(tg, tierInd, time, label)
% function tgNew = tgInsertPoint(tg, tierInd, time, label)
% Vloží nový bod do PointTier.
% v1.0, Tomáš Boøil, borilt@gmail.com

if nargin ~= 4
    error('nesprávný poèet argumentù')
end

% if ~isInt(tierInd)
%     error(['index tier musí být celé èíslo od 1 výše [' num2str(tierInd) ']']);
% end
tierInd = tgI(tg, tierInd);

% ntiers = tgGetNumberOfTiers(tg);
% if tierInd < 1 || tierInd>ntiers
%     error(['index tier mimo rozsah, tierInd = ' num2str(tierInd) ', ntiers = ' num2str(ntiers)]);
% end
if ~tgIsPointTier(tg, tierInd)
    error(['tier ' num2str(tierInd) ' není PointTier']);
end

tgNew = tg;

indPosun = tgGetPointIndexHigherThanTime(tg, tierInd, time);
npoints = tgGetNumberOfPoints(tg, tierInd);

if ~isnan(indPosun)
    for I = npoints: -1: indPosun
        tgNew.tier{tierInd}.T(I+1) = tgNew.tier{tierInd}.T(I);
        tgNew.tier{tierInd}.Label{I+1} = tgNew.tier{tierInd}.Label{I};
    end
end

if isnan(indPosun)
    indPosun = length(tgNew.tier{tierInd}.T) + 1;
end
tgNew.tier{tierInd}.T(indPosun) = time;
tgNew.tier{tierInd}.Label{indPosun} = label;

tgNew.tmin = min(tgNew.tmin, time);
tgNew.tmax = max(tgNew.tmax, time);