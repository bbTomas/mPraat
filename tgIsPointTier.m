function b = tgIsPointTier(tg, tierInd)
% function b = tgIsPointTier(tg, tierInd)
% Vrati true/false, zda tier je typus PointTier
% v1.0, Tomas Boril, borilt@gmail.com
%
% tierInd ... index vrstvy (tier)

% ntiers = length(tg.tier);

% if ~isInt(tierInd)
%     error(['index tier musi byt cele cislo od 1 vyse [' num2str(tierInd) ']']);
% end
tierInd = tgI(tg, tierInd);

% if tierInd < 1 || tierInd>ntiers
%     error(['index tier mimo rozsah, tierInd = ' num2str(tierInd) ', ntiers = ' num2str(ntiers)]);
% end

if strcmp(tg.tier{tierInd}.type, 'point') == 1
    b = true;
else
    b = false;
end
