function tgNew = tgRemovePoint(tg, tierInd, index)
% function tgNew = tgRemovePoint(tg, tierInd, index)
% Odstraní bod s daným indexem z PointTier.
% v1.0, Tomáš Boøil, borilt@gmail.com

if nargin ~= 3
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

npoints = tgGetNumberOfPoints(tg, tierInd);
if index < 1 || index>npoints
    error(['index bodu mimo rozsah, index = ' num2str(index) ', npoints = ' num2str(npoints)]);
end

if ~isInt(index)
    error(['index musí být celé èíslo od 1 výše [' num2str(index) ']']);
end

tgNew = tg;
for I = index: npoints - 1
    tgNew.tier{tierInd}.T(I) = tgNew.tier{tierInd}.T(I+1);
    tgNew.tier{tierInd}.Label{I} = tgNew.tier{tierInd}.Label{I+1};
end

tgNew.tier{tierInd}.T(end) = [];
tgNew.tier{tierInd}.Label(end) = [];
