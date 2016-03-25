function tgNew = tgInsertNewIntervalTier(tg, tierInd, tierName, tStart, tEnd)
% function tgNew = tgInsertNewIntervalTier(tg, tierInd, tierName, tStart, tEnd)
% Vytvori novou vrstvu (tier) textgridu typu IntervalTier a vlozi ji na dany index (1 = prvni).
% Nasledujici vrstvy posune o jednu dal.
% Je treba zadat jmeno nove vrstvy - retezec tierName.
% Po vzoru Praatu prazdna intervalova tier obsahuje jeden interval
% s prazdnym labelem pres cely casovy rozsah tmin az tmax textgridu,
% jedine tak je totiz mozne v Praatu tento interval "delit" na mensi, a tim vlastne
% vkladat nove intervaly.
% Rozsah tmin az tmax je mozne zadat nepovinnymi parametry tStart a tEnd.
% v1.0, Tomas Boril, borilt@gmail.com

if nargin ~= 3 && nargin ~= 5
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
