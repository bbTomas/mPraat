function tgNew = tgInsertNewPointTier(tg, tierInd, tierName)
% function tgNew = tgInsertNewPointTier(tg, tierInd, tierName)
% Vytvoøí novou vrstvu (tier) textgridu typu PointTier a vloží ji na daný index (1 = první).
% Následujicí vrstvy posune o jednu dál.
% Je tøeba zadat jméno nové vrstvy - øetìzec tierName.
% v1.0, Tomáš Boøil, borilt@gmail.com

if nargin ~= 3
    error('nesprávný poèet argumentù')
end

% if ~isInt(tierInd)
%     error(['index tier musí být celé èíslo od 1 výše [' num2str(tierInd) ']']);
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
