function tgNew = tgSetTierName(tg, tierInd, name)
% function tgNew = tgSetTierName(tg, tierInd, name)
% Nastavi (zmeni) jmeno vrstvy (tier) s danym indexem.
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

tgNew = tg;
tgNew.tier{tierInd}.name = name;
