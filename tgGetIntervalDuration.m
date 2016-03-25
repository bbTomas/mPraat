function t = tgGetIntervalDuration(tg, tierInd, index)
% function t = tgGetIntervalEndTime(tg, tierInd, index)
% Vrátí èas konce intervalu s daným indexem ve vybrané vrstvì (tier) typu IntervalTier.
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

if ~isInt(index)
    error(['index musí být celé èíslo od 1 výše [' num2str(index) ']']);
end

nint = tgGetNumberOfIntervals(tg, tierInd);
if index < 1 || index>nint
    error(['index intervalu mimo rozsah, index = ' num2str(index) ', nint = ' num2str(nint)]);
end


t = tg.tier{tierInd}.T2(index) - tg.tier{tierInd}.T1(index);
