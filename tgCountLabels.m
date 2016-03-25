function c = tgCountLabels(tg, tierInd, label)
% function c = tgCountLabels(tg, tierInd, label)
% Vrati pocet labelu v dane vrstve (tier), ktere se rovnaji pozadovanemu retezci.
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

c = 0; % pocet

for I = 1: length(tg.tier{tierInd}.Label)
    if strcmp(tg.tier{tierInd}.Label{I}, label) == 1
        c = c + 1;
    end
end
