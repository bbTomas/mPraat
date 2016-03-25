function ind = tgGetIntervalIndexAtTime(tg, tierInd, time)
% function ind = tgGetIntervalIndexAtTime(tg, tierInd, time)
% Vrátí index intervalu obsahující daný èas, vybraná vrstva (tier) musí být typu IntervalTier.
% Interval musí splòovat tStart <= time < tEnd. Pokud nenalezne, vrátí NaN.
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
if ~tgIsIntervalTier(tg, tierInd)
    error(['tier ' num2str(tierInd) ' není IntervalTier']);
end

ind = NaN;
nint = length(tg.tier{tierInd}.T1);
for I = 1: nint
    if tg.tier{tierInd}.T1(I) <= time  && time < tg.tier{tierInd}.T2(I)
        ind = I;
        break;
    end
end