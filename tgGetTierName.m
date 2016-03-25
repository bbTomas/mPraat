function n = tgGetTierName(tg, tierInd)
% function n = tgGetTierName(tg, tierInd)
% Vrátí jméno vrstvy (tier).
% v1.0, Tomáš Boøil, borilt@gmail.com

if nargin ~= 2
    error('Wrong number of arguments.')
end

% if ~isInt(tierInd)
%     error(['index tier musí být celé èíslo od 1 výše [' num2str(tierInd) ']']);
% end
tierInd = tgI(tg, tierInd);
% ntiers = tgGetNumberOfTiers(tg);

% if tierInd < 1 || tierInd>ntiers
%     error(['index tier mimo rozsah, tierInd = ' num2str(tierInd) ', ntiers = ' num2str(ntiers)]);
% end

n = tg.tier{tierInd}.name;