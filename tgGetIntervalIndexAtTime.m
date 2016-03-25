function ind = tgGetIntervalIndexAtTime(tg, tierInd, time)
% function ind = tgGetIntervalIndexAtTime(tg, tierInd, time)
% Vrati index intervalu obsahujici dany cas, vybrana vrstva (tier) musi byt typu IntervalTier.
% Interval musi splnovat tStart <= time < tEnd. Pokud nenalezne, vrati NaN.
% v1.0, Tomas Boril, borilt@gmail.com

if nargin ~= 3
    error('Wrong number of arguments.')
end

% if ~isInt(tierInd)
%     error(['index tier musi byt cele cislo od 1 vyse [' num2str(tierInd) ']']);
% end
tierInd = tgI(tg, tierInd);
% ntiers = tgGetNumberOfTiers(tg);
% if tierInd < 1 || tierInd>ntiers
%     error(['index tier mimo rozsah, tierInd = ' num2str(tierInd) ', ntiers = ' num2str(ntiers)]);
% end
if ~tgIsIntervalTier(tg, tierInd)
    error(['tier ' num2str(tierInd) ' is not IntervalTier']);
end

ind = NaN;
nint = length(tg.tier{tierInd}.T1);
for I = 1: nint
    if tg.tier{tierInd}.T1(I) <= time  && time < tg.tier{tierInd}.T2(I)
        ind = I;
        break;
    end
end
