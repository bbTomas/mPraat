function ind = tgGetPointIndexNearestTime(tg, tierInd, time)
% function ind = tgGetPointIndexNearestTime(tg, tierInd, time)
% Vrátí index bodu, který je nejblíže danému èasu (z obou smìrù), vybraná vrstva (tier) musí být typu PointTier.
% Pokud nenalezne, vrátí NaN.
% v1.0, Tomáš Boøil, borilt@gmail.com

if nargin ~= 3
    error('nesprávný poèet argumentù')
end

% if ~isInt(tierInd)
%     error(['index tier musí být celé èíslo od 1 výše [' num2str(tierInd) ']']);
% end
tierInd = tgI(tg, tierInd);

% ntiers = tgGetNumberOfTiers(tg);
% if tierInd < 1 || tierInd > ntiers
%     error(['index tier mimo rozsah, tierInd = ' num2str(tierInd) ', ntiers = ' num2str(ntiers)]);
% end
if ~tgIsPointTier(tg, tierInd)
    error(['tier ' num2str(tierInd) ' není PointTier']);
end

npoints = length(tg.tier{tierInd}.T);
minDist = inf;
minInd = NaN;
for I = 1: npoints
    dist = abs(tg.tier{tierInd}.T(I) - time);
    if dist < minDist
        minDist = dist;
        minInd = I;
    end
end

ind = minInd;