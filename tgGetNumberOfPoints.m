function c = tgGetNumberOfPoints(tg, tierInd)
% function c = tgGetNumberOfPoints(tg, tierInd)
% Vrati pocet bodu v dane vrstve (tier) typu PointTier.
% v1.0, Tomas Boril, borilt@gmail.com

if nargin ~= 2
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

if ~tgIsPointTier(tg, tierInd)
    error(['tier ' num2str(tierInd) ' is not PointTier']);
end

c = length(tg.tier{tierInd}.T);
