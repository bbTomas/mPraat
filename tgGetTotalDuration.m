function t = tgGetTotalDuration(tg, tierInd)
% function t = tgGetTotalDuration(tg, tierInd)
% Vrati celkove trvani. Bud maximum vsech vrstev (default)
% ci konkretni vrstvy - tier (v takovem pripade vraci NaN, kdyz vrsta nic
% neobsahuje).
% v1.0, Tomas Boril, borilt@gmail.com

if nargin  == 1
    t = tgGetEndTime(tg) - tgGetStartTime(tg);
elseif nargin == 2
    t = tgGetEndTime(tg, tierInd) - tgGetStartTime(tg, tierInd);
else
    error('Wrong number of arguments.')
end
