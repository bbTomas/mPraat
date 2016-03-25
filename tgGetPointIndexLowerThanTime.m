function ind = tgGetPointIndexLowerThanTime(tg, tierInd, time)
% function ind = tgGetPointIndexLowerThanTime(tg, tierInd, time)
% Vrati index bodu, ktery je nejblize zleva danemu casu (vcetne), vybrana vrstva (tier) musi byt typu PointTier.
% Pokud nenalezne, vrati NaN.
% v1.0, Tomas Boril, borilt@gmail.com

if nargin ~= 3
    error('Wrong number of arguments.')
end

% if ~isInt(tierInd)
%     error(['index tier musi byt cele cislo od 1 vyse [' num2str(tierInd) ']']);
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
