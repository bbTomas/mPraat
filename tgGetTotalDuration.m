function t = tgGetTotalDuration(tg, tierInd)
% function t = tgGetTotalDuration(tg, tierInd)
% Vrátí celkové trvání. Buï maximum všech vrstev (default)
% èi konkrétní vrstvy - tier (v takovém pøípadì vrací NaN, když vrsta nic
% neobsahuje).
% v1.0, Tomáš Boøil, borilt@gmail.com

if nargin  == 1
    t = tgGetEndTime(tg) - tgGetStartTime(tg);
elseif nargin == 2
    t = tgGetEndTime(tg, tierInd) - tgGetStartTime(tg, tierInd);
else
    error('nesprávný poèet argumentù')
end