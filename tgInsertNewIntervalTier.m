function tgNew = tgInsertNewIntervalTier(tg, tierInd, tierName, tStart, tEnd)
% function tgNew = tgInsertNewIntervalTier(tg, tierInd, tierName, tStart, tEnd)
% Vytvoøí novou vrstvu (tier) textgridu typu IntervalTier a vloží ji na daný index (1 = první).
% Následující vrstvy posune o jednu dál.
% Je tøeba zadat jméno nové vrstvy - øetìzec tierName.
% Po vzoru Praatu prázdná intervalová tier obsahuje jeden interval
% s prázdným labelem pøes celý èasový rozsah tmin až tmax textgridu,
% jedinì tak je totiž možné v Praatu tento interval "dìlit" na menší, a tím vlastnì
% vkládat nové intervaly.
% Rozsah tmin až tmax je možné zadat nepovinnými parametry tStart a tEnd.
% v1.0, Tomáš Boøil, borilt@gmail.com

if nargin ~= 3 && nargin ~= 5
    error('Wrong number of arguments.')
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
tNew.type = 'interval';
if nargin == 5
    if tStart >= tEnd
        error(['tStart [' num2str(tStart) '] must be lower than tEnd [' num2str(tEnd) ']']);
    end
    tNew.T1(1) = tStart;
    tNew.T2(1) = tEnd;
    tgNew.tmin = min(tg.tmin, tStart);
    tgNew.tmax = max(tg.tmax, tEnd);
else
    tNew.T1(1) = tg.tmin;
    tNew.T2(1) = tg.tmax;
end
tNew.Label{1} = '';
for I = ntiers + 1: -1: tierInd+1
    tgNew.tier{I} = tgNew.tier{I-1};
end

tgNew.tier{tierInd} = tNew;
