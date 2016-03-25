function t = tgGetPointTime(tg, tierInd, index)
% function t = tgGetPointTime(tg, tierInd, index)
% Vrátí èas bodu s daným indexem ve vybrané vrstvì (tier) typu PointTier.
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

if ~isInt(index)
    error(['index musí být celé èíslo od 1 výše [' num2str(index) ']']);
end

npoints = tgGetNumberOfPoints(tg, tierInd);
if index < 1 || index>npoints
    error(['index bodu mimo rozsah, index = ' num2str(index) ', npoints = ' num2str(npoints)]);
end


t = tg.tier{tierInd}.T(index);