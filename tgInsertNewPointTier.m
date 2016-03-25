function tgNew = tgInsertNewPointTier(tg, tierInd, tierName)
% function tgNew = tgInsertNewPointTier(tg, tierInd, tierName)
% Vytvori novou vrstvu (tier) textgridu typu PointTier a vlozi ji na dany index (1 = prvni).
% Nasledujici vrstvy posune o jednu dal.
% Je treba zadat jmeno nove vrstvy - retezec tierName.
% v1.0, Tomas Boril, borilt@gmail.com

if nargin ~= 3
    error('Wrong number of arguments.')
end

% if ~isInt(tierInd)
%     error(['index tier musi byt cele cislo od 1 vyse [' num2str(tierInd) ']']);
% end
tierInd = tgI(tg, tierInd);

ntiers = tgGetNumberOfTiers(tg);
% if tierInd < 1 || tierInd>ntiers+1
%     error(['index tier mimo rozsah <1; ntiers+1>, tierInd = ' num2str(tierInd) ', ntiers = ' num2str(ntiers)]);
% end

tgNew = tg;

tNew.name = tierName;
tNew.type = 'point';
tNew.T = [];
tNew.Label = {};
for I = ntiers + 1: -1: tierInd+1
    tgNew.tier{I} = tgNew.tier{I-1};
end

tgNew.tier{tierInd} = tNew;
