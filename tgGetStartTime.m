function t = tgGetStartTime(tg, tierInd)
% function t = tgGetStartTime(tg, tierInd)
% Vrati pocatecni cas. Bud minimum vsech vrstev (default)
% ci konkretni vrstvy - tier (v takovem pripade vraci NaN, kdyz vrsta nic
% neobsahuje).
% v1.0, Tomas Boril, borilt@gmail.com

if nargin  == 1
    t = tg.tmin;
    return;
end

if nargin ~= 2
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

if tgIsPointTier(tg, tierInd)
    if length(tg.tier{tierInd}.T) < 1
        t = NaN;
    else
        t = tg.tier{tierInd}.T(1);
    end
elseif tgIsIntervalTier(tg, tierInd)
    if length(tg.tier{tierInd}.T1) < 1
        t = NaN;
    else
        t = tg.tier{tierInd}.T1(1);
    end
else
    error('unknown tier type')
end
