function ind = tgGetPointIndexLowerThanTime(tg, tierInd, time)
% function ind = tgGetPointIndexLowerThanTime(tg, tierInd, time)
% Vrátí index bodu, který je nejblíže zleva danému èasu (vèetnì), vybraná vrstva (tier) musí být typu PointTier.
% Pokud nenalezne, vrátí NaN.
% v1.0, Tomáš Boøil, borilt@gmail.com

if nargin ~= 3
    error('Wrong number of arguments.')
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
    error(['tier ' num2str(tierInd) ' is not PointTier']);
end

ind = NaN;
npoints = length(tg.tier{tierInd}.T);
for I = npoints: -1: 1
    if time >= tg.tier{tierInd}.T(I)
        ind = I;
        break;
    end
end