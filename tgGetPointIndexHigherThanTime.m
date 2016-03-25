function ind = tgGetPointIndexHigherThanTime(tg, tierInd, time)
% function ind = tgGetPointIndexHigherThanTime(tg, tierInd, time)
% Vrátí index bodu, který je nejblíže zprava danému èasu (vèetnì), vybraná vrstva (tier) musí být typu PointTier.
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

ind = NaN;
npoints = length(tg.tier{tierInd}.T);
for I = 1: npoints
    if time <= tg.tier{tierInd}.T(I)
        ind = I;
        break;
    end
end